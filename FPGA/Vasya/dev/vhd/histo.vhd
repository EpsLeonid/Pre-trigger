--------------------------------------------------------------------------
--   HISTOGRAM ENTITY
--------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.reg_map.all;
use work.types.all;
use work.constants.all;

entity histo is 
  generic(                            
    --- TODO: reduce number of parameters
    BINWIDTH       : integer := 32;                              -- bin width
    BINWLOG2       : integer := 5;                               -- bin width bits                           
    VALBITS        : integer := 16;                              -- bits for bin content value  
    INPUTBITS      : integer := 12;                              -- bits for input value       
    ADDRBITS       : integer := 7 );                             -- bits for histogram bin indicies
  port(                                                     
    i_clock        : in  std_logic;                              -- clock
    i_reset        : in  std_logic;                              -- reset
    i_clear        : in  std_logic;                              -- clear histogram content
                                                               
    i_run          : in  std_logic;                              -- on/off filling the histogram
    i_test_mode    : in std_logic;                               -- if high, the histogram is filled with test values 0,1,2,...
                                                               
    i_wena         : in  std_logic;                              -- write enable to increment the histogram bin value
    i_data         : in  std_logic_vector(INPUTBITS-1 downto 0); -- input data (signal amplitude or coincidence duration)
                  
    i_raddr        : in  std_logic_vector(ADDRBITS-1 downto 0);  -- histo bin index to be read out
    o_rdata        : out std_logic_vector(VALBITS -1 downto 0);  -- read out bin content
    o_overflow     : out std_logic                               -- overflow flag
  );
end histo;

architecture histo_arch of histo is

  
  -- some constants
  constant MAX_BIN_ADDR       : std_logic_vector(ADDRBITS-1 downto 0) := (others => '1'); 
  constant MAX_BIN_DATA       : std_logic_vector(VALBITS -1 downto 0) := (others => '1');

  signal s_data               : std_logic_vector(INPUTBITS-1 downto 0) := (others => '0'); 

  -- write enable signals
  signal s_wena               : std_logic := '0'; -- histogram write enable
  signal s_wena_meta          : std_logic := '0';
  signal s_wena_pre           : std_logic := '0';
  
  -- bin data
  signal s_bin_rindex         : std_logic_vector(ADDRBITS-1 downto 0) := (others => '0'); -- bin index for reading from CPU
  signal s_bin_index          : std_logic_vector(ADDRBITS-1 downto 0) := (others => '0'); -- bin index
  signal s_bin_index_next     : std_logic_vector(ADDRBITS-1 downto 0) := (others => '0'); -- next index (for initialization) 
  signal s_bin_data           : std_logic_vector(VALBITS -1 downto 0) := (others => '0'); -- current bin value
  signal s_bin_data_next      : std_logic_vector(VALBITS -1 downto 0) := (others => '0'); -- next bin value
  signal s_bin_data_wr        : std_logic_vector(VALBITS -1 downto 0) := (others => '0'); -- write to bram

  -- initialization
  signal s_is_initialized     : std_logic := '0';  -- initialized flag
  signal s_init_in_progress   : std_logic := '0';  -- initialization is in progress
  signal s_clear              : std_logic := '0';  -- clear histogram
  signal s_clear_r            : std_logic := '0';
  
  -- overflow flag
  signal s_overflow           : std_logic := '0';
  
begin
  
  ----- HISTOGRAM CONTENT ------------
  histo_mem_i : entity work.bram_sdp_cc
  generic map (
    DATA => VALBITS,
    ADDR => ADDRBITS
  )
  port map (
    clka   => i_clock,
    wea    => s_wena_pre,
    addra  => s_bin_index,
    dina   => s_bin_data_wr,
    addrb  => s_bin_rindex,
    doutb  => s_bin_data
  );
  ------------------------------------
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_data <= i_data;
    end if;
  end process;


  FILL_BINS : process(i_clock, i_reset) 
  begin

    if i_reset = '1' then
        s_is_initialized   <= '0';
        s_init_in_progress <= '0';
        s_wena             <= '0';
        s_wena_pre         <= '0';
        s_overflow         <= '0';
        s_bin_index        <= (others => '0');
        s_bin_rindex       <= (others => '0');
        s_bin_data_wr      <= (others => '0');

    elsif rising_edge(i_clock) then

      s_wena <= '0';
      s_wena_pre <= s_wena;

      if i_wena = '1' and i_run = '1' and s_overflow = '0' then
        s_wena <= '1';
      end if;
      
      if s_init_in_progress = '1' then
        s_wena <= '1';
      end if;

      -- IF HISTOGRAM IS INITIALIZED
      IF_INI: if s_is_initialized = '1' then
      
        if i_run = '1' then
          -- fill histograms
          s_bin_rindex  <= s_data(INPUTBITS-1 downto BINWLOG2); -- ampl / binwidth
          s_bin_index   <= s_bin_rindex;

          -- overflow check
          if s_bin_data < MAX_BIN_DATA then
            s_bin_data_wr <= s_bin_data_next;
          else 
            s_bin_data_wr <= s_bin_data;
            s_overflow    <= '1';
          end if;
        
        else
          -- read its content
          s_bin_rindex  <= i_raddr;
        end if;
        
      else -- IF NOT INITIALIZED 
      
      ----- HISTOGRAM INITIALIZATION -----
        s_overflow <= '0';

        IF_PROG : if s_init_in_progress = '1' then

          s_bin_index_next <= s_bin_index + '1';
          s_bin_index      <= s_bin_index_next;

          IF_TEST : if i_test_mode = '0' then
            -- normal mode
            s_bin_data_wr  <= (others => '0');
          else 
            -- fill histo with 0,1,2,...,NBIS-1 for tests
            s_bin_data_wr(ADDRBITS-1 downto 0)        <= s_bin_index_next;
            s_bin_data_wr(VALBITS-1 downto ADDRBITS)  <= (others => '0');
          end if IF_TEST;

          -- finish initialization
          if s_bin_index = MAX_BIN_ADDR then
            s_is_initialized   <= '1';
            s_init_in_progress <= '0';
            s_wena             <= '0';
          end if;

        elsif s_init_in_progress = '0' then  -- INI NOT IN PROGRESS

          s_bin_index_next   <= (others => '0');
          s_bin_index        <= (others => '0');
          s_bin_data_wr      <= (others => '0');
          s_init_in_progress <= '1';

          s_wena <= '1';
        end if IF_PROG;
        ------------------------------------
      end if IF_INI;
       
      s_clear   <= i_clear;
      s_clear_r <= s_clear;

      if s_clear_r = '0' and s_clear = '1' then
        s_is_initialized <= '0';
        s_init_in_progress <= '0';
      end if;

    end if;

  end process FILL_BINS;

  s_bin_data_next <= s_bin_data + '1';

  o_rdata <= s_bin_data;
  
  o_overflow <= s_overflow;


end histo_arch;


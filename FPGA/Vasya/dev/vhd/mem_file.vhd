library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work;
use work.reg_map.all;
use work.types.all;
use work.constants.all;

entity mem_file is
	port ( 
		i_clock, i_reset       : in  std_logic;

    -- cpu eth interface 
    i_mem_addr  : in  std_logic_vector(31 downto 0);
    i_mem_wdata : in  std_logic_vector(15 downto 0); -- TODO
    o_mem_rdata : out std_logic_vector(15 downto 0);
    i_mem_wena  : in  std_logic; -- TODO
    
    -- access to the adc buffer
		o_adcbuf_raddr   : out std_logic_vector(LOM_ADCBUF_DEPTH-1 downto 0);
		i_adcbuf_rdata   : in t_adc_data_32_array;
    i_sumbuf_rdata   : in t_adc_sum_32_array;

    -- access to the histograms
    o_histo_index    : out std_logic_vector(LOM_HISTO_INDEX_BITS-1 downto 0); -- histogram number  
    o_histo_baddr    : out std_logic_vector(15 downto 0); -- number of bin
    i_histo_rdata    : in  std_logic_vector(LOM_HISTO_VAL_BITS -1 downto 0);  -- histogram bin value


    -- acess to the buffer with test waveform samples
    o_lomtest_raddr  : out t_testbuf_addr;
    i_lomtest_rdata  : in  t_adc_data; 
    o_lomtest_index  : out std_logic_vector(4 downto 0);
    o_lomtest_we     : out std_logic;
    o_lomtest_wdata  : out std_logic_vector(11 downto 0)

  );
end mem_file;

architecture mem_file_arch of mem_file is 

  signal s_mem_addr        : std_logic_vector(31 downto 0) := (others => '0');
  signal s_mem_addr_meta   : std_logic_vector(31 downto 0) := (others => '0');
  signal s_mem_addr_prev   : std_logic_vector(31 downto 0) := (others => '0');

  signal s_mem_rdata       : std_logic_vector(15 downto 0) := (others => '0');
  signal s_mem_rdata_prev  : std_logic_vector(15 downto 0) := (others => '0');
  signal s_mem_rdata_next  : std_logic_vector(15 downto 0) := (others => '0');

  signal s_adcbuf_raddr    : std_logic_vector(10 downto 0) := (others => '0');
  signal s_adcbuf_rdata    : std_logic_vector(15 downto 0) := (others => '0');
  signal s_sumbuf_rdata    : std_logic_vector(15 downto 0) := (others => '0');

  signal s_histo_baddr     : std_logic_vector(LOM_HISTO_ADDR_BITS-1 downto 0) := (others => '0');
  signal s_histo_rdata     : std_logic_vector(15 downto 0) := (others => '0');
  
  signal s_testbuf_rdata   : std_logic_vector(15 downto 0) := (others => '0');
  signal s_lomtest_rdata   : std_logic_vector(15 downto 0) := (others => '0');
  
  signal s_adcsel          : std_logic_vector(4 downto 0) := (others => '0');

  signal s_buf_select      : std_logic_vector(2 downto 0) := (others => '0'); -- 0 -- adc, 1 -- histo, 2 -- test

begin

  -- select buffer: adc buffer/histograms/lomtest/testbuf
  s_buf_select <= i_mem_addr(31 downto 29);

  MEMFILL : process(i_clock) 
  begin

    IF_EDGE : if rising_edge(i_clock) then

      IF_RST : if i_reset = '1' then

        s_mem_rdata <= (others => '0');
      
      else
      
        s_mem_rdata_next <= s_mem_rdata_next;

        o_lomtest_we <= '0';
        
        -- ADC buffer
        if s_buf_select = B"010" then
          s_mem_rdata_next <= s_adcbuf_rdata;

        -- running sums buffer
        elsif s_buf_select = B"011" then
          s_mem_rdata_next <= s_sumbuf_rdata;

        -- HISTOGRAMS
        elsif s_buf_select = B"100" then
          s_mem_rdata_next <= s_histo_rdata;
        
        -- LOMTEST
        elsif s_buf_select = B"001" then
          s_mem_rdata_next <= s_lomtest_rdata;
          o_lomtest_we    <= i_mem_wena;
        
        -- WRONG ADDRESS
        else 
          s_mem_rdata_next <= X"BADA";
        end if;
        
        s_mem_rdata      <= s_mem_rdata_next;
        s_mem_rdata_prev <= s_mem_rdata;
        
      end if IF_RST;
    
    end if IF_EDGE;
  
  end process MEMFILL;

  -- DATA to CPU
  o_mem_rdata <= s_mem_rdata;

  s_mem_addr <= i_mem_addr;

  s_lomtest_rdata <= B"0000" & i_lomtest_rdata;

  -- decode adresses
  o_histo_index   <= B"0" & s_mem_addr(28 downto 22);
  o_histo_baddr   <= s_mem_addr(15 downto 0);

  o_adcbuf_raddr  <= s_mem_addr(LOM_ADCBUF_DEPTH-1 downto 0);

  o_lomtest_index <= s_adcsel;
  o_lomtest_raddr <= s_mem_addr(4  downto 0);
  o_lomtest_wdata <= i_mem_wdata(11 downto 0);
  
  s_adcsel        <= s_mem_addr(21 downto 17);
  s_histo_rdata   <= i_histo_rdata;
  --
  


  --- select ADC number to be read out
  ADCSEL : process(i_clock)
  begin
    s_adcbuf_rdata <= B"0000" & i_adcbuf_rdata(conv_integer(s_adcsel)+1);
    s_sumbuf_rdata <= B"000"  & i_sumbuf_rdata(conv_integer(s_adcsel)+1);
  end process ADCSEL;


end mem_file_arch;


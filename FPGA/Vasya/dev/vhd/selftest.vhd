-------------------------------------------------------------------------------------------
-- Test module
-- Module takes data samples from the test buffer and provides it to the input of LOM logic
-------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.types.all;
use work.constants.all;

entity self_tester is
  generic (
    SAMPLESDEPTH : integer := 5 );
  port(
    i_clock         : in std_logic;
    i_reset         : in std_logic;

    -- enable signal to increment address
    i_enable        : in std_logic;
    i_cntclear      : in std_logic; -- clear test events counter

    -- if 0, addres is not incremented to make it possible to read data by mem_file
    i_run           : in std_logic;
    -- number of test events to generate
    i_nevents       : in t_reg_data; 
    
    o_testbuf_data  : out  t_adc_data_32_array;
    
    -- for mem file
    i_testbuf_addr  : in   t_testbuf_addr;
    i_testbuf_we    : in   std_logic;
    i_testbuf_wdata : in   t_adc_data;
    i_testbuf_index : in   std_logic_vector(4 downto 0); -- number of test buffer (ADC channel)
    o_testbuf_rdata : out  t_adc_data

  );
end self_tester;

architecture ampl_arch of self_tester is

  -- data read from BRAM 
  signal s_arr_adcdata        : t_adc_data_array(1 to 32) := (others => (others => '0'));
                             
  signal s_arr_adcdata_c      : t_adc_data_array(1 to 32) := (others => (others => '0')); -- test adc data with respect to number of test events
                                                                                          -- zero if n > n_0  
                             
  --signal s_data_buf           : t_adc_buf_data_array(0 to NTESTSAMPLES - 1) := (others => (others => '0'));
  signal s_testbuf_addr       : t_testbuf_addr := (others => '0'); 
  signal s_testbuf_addr_next  : t_testbuf_addr := (others => '0'); 
                             
  -- write enable for BRAM   
  signal s_vec_buf_we         : std_logic_vector(31 downto 0) := (others => '0');
                             
  -- read from CPU           
  signal s_testbuf_data       : t_adc_data := (others => '0');
                             
  -- write from CPU          
  signal s_buf_wdata          : t_adc_data := (others => '0');
  signal s_buf_waddr          : t_testbuf_addr := (others => '0');
                             
  signal s_events             : t_reg_data := (others => '0');

  constant c_testbuf_addr_max : std_logic_vector(SAMPLESDEPTH-1 downto 0) := (others => '1');
  constant ZERO_REGVAL        : t_reg_data := (others => '0');
begin

  -------------------------------------------------------
	-- BRAM memory to store test waveform samples 
  -------------------------------------------------------
  BUFGEN : for ICH in 1 to 32 generate
    lom_test_buf_i : entity work.bram_12x5_sdp
    generic map (
      DEFAULTS => (X"064", X"065", X"105", X"210", X"320", X"350", X"370", X"380",
                   X"400", X"401", X"401", X"350", X"300", X"200", X"205", X"100",
                   X"064", X"064", X"064", X"064", X"064", X"064", X"064", X"064",
                   X"064", X"064", X"064", X"064", X"064", X"064", X"064", X"064")
    )
    port map(
      clka  => i_clock,
      wea   => s_vec_buf_we(ICH - 1),
      addra => i_testbuf_addr,
      dina  => s_buf_wdata,

      addrb => s_testbuf_addr,
      doutb => s_arr_adcdata(ICH)
    );
  end generate BUFGEN;
  -------------------------------------------------------


  process(i_clock)
  begin
  
    if rising_edge(i_clock) then
      if i_reset = '1' or i_cntclear = '1' then
        s_testbuf_addr     <= (others => '0');
        s_events           <= (others => '0'); 
      else
        s_testbuf_addr <= s_testbuf_addr;

        -- lom is in test mode, increment address
        if i_run = '1' and i_enable = '1' then
            s_testbuf_addr <= s_testbuf_addr_next;
            if s_testbuf_addr = c_testbuf_addr_max and s_events < i_nevents then
              s_events <= s_events + '1';
            end if;
        end if;

        if s_events < i_nevents or i_nevents = ZERO_REGVAL then
          s_arr_adcdata_c <= s_arr_adcdata;
        else 
          s_arr_adcdata_c <= (others => (others => '0'));
        end if;

        -- read from given address for read/write from CPU
        if i_run = '0'  then 
          s_testbuf_addr <= i_testbuf_addr;
        end if;          

      end if;
    end if;

  end process;

  s_testbuf_addr_next <= s_testbuf_addr + '1';
  
  -- output
  o_testbuf_data <= s_arr_adcdata_c;
  
  s_buf_wdata <= i_testbuf_wdata;
  
  -- read from CPU
  READ_PROC : process(i_clock)
  begin

    s_vec_buf_we <= (others => '0');
    s_testbuf_data <= s_testbuf_data;
    
    INDLOOP : for ICH in 0 to 31 loop
      if conv_integer(i_testbuf_index) = ICH then
        s_testbuf_data    <= s_arr_adcdata(ICH+1);
        s_vec_buf_we(ICH) <= i_testbuf_we;
      end if;
    end loop INDLOOP;
    
  end process READ_PROC;

  o_testbuf_rdata <= s_testbuf_data;
  --
  
end ampl_arch;



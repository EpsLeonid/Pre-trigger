library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.reg_map.all;
use work.types.all;
use work.constants.all;

entity histo_manager is 
  generic(
    HINDEX_BITS : integer := 8 
  );

  port (
    -- input ports
    i_clock                   : in std_logic;
    i_reset                   : in std_logic;
                            
    i_hrun                    : in std_logic;                                        -- on/off filling of the histograms
                                                                                   
    i_htest_mode              : in std_logic;                                        -- histograms are filled with test values
    i_hclear                  : in std_logic;                                        -- clear histograms
                             
    i_vec_hist_wena           : in std_logic_vector(N_ADC-1 downto 0);               -- write eneable signals for histograms
    i_arr_adc_ampl            : in t_adc_data_array(1 to N_ADC);                     -- amplitudes to be filled in the histograms

    i_vec_sumhist_wena        : in std_logic_vector(N_ADC-1 downto 0);               -- write eneable signals for histograms
    i_arr_sum_ampl            : in t_adc_sum_array(1 to N_ADC);                     -- amplitudes to be filled in the histograms
                             
    i_hist_index              : in std_logic_vector(HINDEX_BITS-1 downto 0);         -- histogram index to be read out
    i_hbin_addr               : in std_logic_vector(15 downto 0);                    -- bin address to be read out
                             
    o_hbin_data               : out std_logic_vector(LOM_HISTO_VAL_BITS-1 downto 0); -- read histogram content
    
    o_vec_ahist_overflow       : out std_logic_vector(N_ADC-1 downto 0);             -- overflow flags
    o_vec_shist_overflow       : out std_logic_vector(N_ADC-1 downto 0)
    );

end histo_manager;

architecture histman_arch of histo_manager is

  signal s_arr_ahist_data         :  t_hdata_array(1 to N_ADC) := (others => (others => '0'));
  signal s_arr_shist_data         :  t_hdata_array(1 to N_ADC) := (others => (others => '0'));

  signal s_hread_addr             :  std_logic_vector(15 downto 0) := (others => '0');
  signal s_hbin_data              :  std_logic_vector(LOM_HISTO_VAL_BITS-1 downto 0)  := (others => '0');

begin

  -- GENERATE HISTOGRAMS FOR ALL ADC CHANNELS -----------
    -- AMPLITUDE HISTOGRAMS
  ADC_GEN : for iADC in 1 to 32 generate

    AMPHIST  : entity work.histo 
    generic map (
      BINWIDTH    => LOM_HISTO_BIN_WIDTH,
      BINWLOG2    => 5,
      VALBITS     => LOM_HISTO_VAL_BITS,
      INPUTBITS   => ADC_BIT_WIDTH,
      ADDRBITS    => LOM_HISTO_ADDR_BITS)
    port map (
      i_clock     => i_clock,
      i_reset     => i_reset,
      i_run       => i_hrun,
      i_clear     => i_hclear,
      i_test_mode => i_htest_mode,
               
      i_wena      => i_vec_hist_wena(iADC-1),
      i_data      => i_arr_adc_ampl(iADC),
                 
      i_raddr     => s_hread_addr(LOM_HISTO_ADDR_BITS-1 downto 0), 
      o_rdata     => s_arr_ahist_data(iADC),
      o_overflow  => o_vec_ahist_overflow(iADC-1) );

  end generate ADC_GEN;
  ---------------------------

  -- GENERATE HISTOGRAMS FOR ALL ADC CHANNELS -----------
    -- AMPLITUDE SUM HISTOGRAMS
  SUM_GEN : for iADC in 1 to 32 generate

    AMPHIST  : entity work.histo 
    generic map (
      BINWIDTH    => LOM_HISTO_BIN_WIDTH,
      BINWLOG2    => 5,
      VALBITS     => LOM_HISTO_VAL_BITS,
      INPUTBITS   => ADC_BIT_WIDTH+1,
      ADDRBITS    => 8)
    port map (
      i_clock     => i_clock,
      i_reset     => i_reset,
      i_run       => i_hrun,
      i_clear     => i_hclear,
      i_test_mode => i_htest_mode,
               
      i_wena      => i_vec_sumhist_wena(iADC-1),
      i_data      => i_arr_sum_ampl(iADC),
                 
      i_raddr     => s_hread_addr(7 downto 0), 
      o_rdata     => s_arr_shist_data(iADC),
      o_overflow  => o_vec_shist_overflow(iADC-1) );

  end generate SUM_GEN;
  --------------------------------------------------------------

  
  --------------------------------------------------------------
  -- MUX FOR HISTOGRAM DATA TO CPU -----------------------------
  -- AMPLITUDE HISTO
  process(i_clock)
  begin
    
    IF_EDGE : if rising_edge(i_clock) then

      IF_RST: if i_reset = '1' then
      else 
        
        IADC : for iiADC in 1 to N_ADC loop
        
          if conv_integer(i_hist_index) = iiADC-1 then
            s_hbin_data <= s_arr_ahist_data(iiADC);
          end if;

          if conv_integer(i_hist_index) = 32+iiADC-1 then
            s_hbin_data <= s_arr_shist_data(iiADC);
          end if;
        
        end loop IADC;
        
      end if IF_RST;

    end if IF_EDGE;

  end process;
  --------------------------------------------------------------
  
  s_hread_addr     <= i_hbin_addr;
  o_hbin_data      <= s_hbin_data;


end histman_arch;




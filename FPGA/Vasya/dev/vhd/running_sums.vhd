-------------------------------------------------------------------
-- Module to calculate runnning sums of signals from neighbour sectors
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.types.all;
use work.constants.all;

entity runsum is 
  generic(                            
    ); 
  port(                                                     
    i_clock        : in  std_logic;
    i_reset        : in  std_logic;     

    i_adc_mask     : std_logic_vector(N_ADC-1 downto 0); 

    i_adc_data     : in  t_adc_data_array(1 to N_ADC);
    
    o_sum_data     : out t_adc_sum_array(1 to N_ADC);
    o_adc_data     : out t_adc_data_array(1 to N_ADC) );
end runsum;

architecture arch of runsum is


  ----- CALCULATE CHANNEL NUMBER FOR RUNNING SUMS -------------------
  function func_chan16_plus_x(IADC : integer; x : integer) return integer is
    variable chan  : integer := 0;
    variable chan0 : integer := 0;
  begin
    
    -- chan0 - channel number inside single endcap
    if IADC > 16 then
      chan0 := IADC - 16;
    else 
      chan0 := IADC;
    end if;

    chan := chan0 + x;
    
    -- cycling inside endcap (16 channels)
    if chan > 16 then
      chan := chan - 16;
    end if;

    -- recalculate to 1-32 channel number
    if IADC > 16 then
      chan := chan + 16;
    end if;

    return chan;

  end function func_chan16_plus_x;
  -------------------------------------------------------------------

  signal s_adc_mask           : std_logic_vector(31 downto 0) := (others => '0'); 

  signal s_arr_adc_data        : t_adc_sum_array(1 to N_ADC)  := (others => (others => '0')); 
  signal s_arr_adc_sums        : t_adc_sum_array(1 to N_ADC)  := (others => (others => '0')); 

BEGIN

  process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_adc_mask <= i_adc_mask;
      s_arr_adc_data <= i_adc_data;
    end if;
  end process;
  
  -- Calculate running sums TODO move to some entity or better to adc_ctrl
  SUM_GEN : for nSum in 1 to N_ADC generate
    process(i_clock)
      variable v_adc1 : t_adc_sum  := (others => '0');
      variable v_adc2 : t_adc_sum  := (others => '0');

      variable v_i1 : integer := nSum;
      variable v_i2 : integer := func_chan16_plus_x(nSum, 1);
    begin
      if rising_edge(i_clock) then
        
        if s_adc_mask(v_i1 - 1) = '1' then
          v_adc1 := s_arr_adc_data(v_i1);
        else 
          v_adc1 := (others => '0');
        end if;

        if s_adc_mask(v_i2 - 1) = '1' then
          v_adc2 := s_arr_adc_data(v_i2);
        else 
          v_adc2 := (others => '0');
        end if;
        
        s_arr_adc_sums(nSum) <= v_adc1 + v_adc2;

      end if;
    end process; 

  end generate SUM_GEN;
  --
  
  o_sum_data <= s_arr_adc_sums;

  process(i_clock)
  begin
    o_adc_data <= s_arr_adc_data;
  end process;

end runsum;




-------------------------------------------------------------------
-- COUNTERS MANAGER
-------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.reg_map.all;
use work.types.all;
use work.constants.all;

entity counters_manager is 
  port (
    i_clock                   : in std_logic;
    i_reset                   : in std_logic;
    
    -- clear counters
    i_clear                   : in std_logic;

    -- enable/disable couners
    i_cnt_run                 : in std_logic;

    i_injveto                 : in std_logic; -- to measure veto time

    -- input one clock pulses 
    i_vec_adc_hit             : in std_logic_vector(N_ADC-1 downto 0);   -- adc hit
    i_vec_sum_hit             : in std_logic_vector(N_ADC-1 downto 0);   -- adc running sums hit
    i_vec_coi_hit             : in std_logic_vector(N_ADC/2-1 downto 0); -- coincidences of sum signals
    i_vec_roi_hit             : in std_logic_vector(N_ADC/2-1 downto 0); -- coincidences of signals from signal ADC (raw signals)
    i_vec_cmx_hit             : in std_logic_vector(255 downto 0);       -- coincidence matrix
    i_evt_hit                 : in std_logic;                            -- "event" temporary
    i_bharaw_hit              : in std_logic;                            -- bhabha without quality flag
    i_bhaqua_hit              : in std_logic;                            -- bhabha with quality flag

    -- measure tatal duration
    i_dead_time               : in std_logic;                            -- dead time signal
    -- TODO:
    -- i_veto_time            : in std_logic;

    -- output counters
    o_adc_cnt                 : out t_reg_32_array;                     -- adc occupancy
    o_sum_cnt                 : out t_reg_32_array;                     -- running sums occupancy
    o_coi_cnt                 : out t_reg_16_array;                     -- counter for number of coincidences of sum signals
    o_roi_cnt                 : out t_reg_16_array;                     -- counter for number of coincidences of raw signals
    o_cmx_cnt                 : out t_reg_array(0 to 255);    
    o_evt_cnt                 : out t_reg_data;                         -- events counter (temporary)
    o_bha_raw_cnt             : out std_logic_vector(31 downto 0);      -- bhabha w/o quality
    o_bha_qua_cnt             : out std_logic_vector(31 downto 0);      -- bhabha w/ quality
    o_clk_cnt                 : out std_logic_vector(31 downto 0);      -- number of clocks counted during measurement
    o_ded_cnt                 : out std_logic_vector(31 downto 0);      -- duration of the dead time in clock cycles        
    o_inj_cnt                 : out std_logic_vector(31 downto 0);      -- duration of the injection veto

    -- counters overflow flag
    o_cnt_overflow            : out t_reg_data
  );


end counters_manager;

architecture cntman_arch of counters_manager is

    signal s_cnt_run                 : std_logic;
    signal s_cnt_run_cmx             : std_logic_vector(255 downto 0) := (others => '0');
    signal s_vec_adc_hit             : std_logic_vector(N_ADC-1 downto 0);   -- adc hit
    signal s_vec_sum_hit             : std_logic_vector(N_ADC-1 downto 0);   -- adc running sums hit
    signal s_vec_coi_hit             : std_logic_vector(N_ADC/2-1 downto 0); -- coincidences of sum signals
    signal s_vec_roi_hit             : std_logic_vector(N_ADC/2-1 downto 0); -- coincidences of signals from signal ADC (raw signals)
    signal s_vec_dur_hit             : std_logic_vector(N_ADC/2-1 downto 0); -- obsolete TODO remove
    signal s_evt_hit                 : std_logic;                            -- "event" temporary
    signal s_bharaw_hit              : std_logic;                            -- bhabha without quality flag
    signal s_bhaqua_hit              : std_logic;                            -- bhabha with quality flag
    signal s_dead_time               : std_logic;                   

    -- constants
    constant c_adc_cnt_zero          :  t_reg_32_array := (others => (others => '0'));
    constant c_coi_cnt_zero          :  t_reg_16_array := (others => (others => '0'));
    constant c_cnt_max               :  t_reg_data     := (others => '1');
    constant c_cnt32_max             :  std_logic_vector(31 downto 0) := (others => '1');

    -- counters
    signal s_adc_cnt                 :  t_reg_32_array := (others => (others => '0'));
    signal s_sum_cnt                 :  t_reg_32_array := (others => (others => '0'));
    signal s_coi_cnt                 :  t_reg_16_array := (others => (others => '0'));
    signal s_roi_cnt                 :  t_reg_16_array := (others => (others => '0'));
    signal s_dur_cnt                 :  t_reg_16_array := (others => (others => '0'));
    signal s_evt_cnt                 :  t_reg_data;
    signal s_cmx_cnt                 :  t_reg_array(0 to 255);  --- NEED??

    signal s_clk_cnt                 :  std_logic_vector(31 downto 0) := (others => '0');
    signal s_bha_qua_cnt             :  std_logic_vector(31 downto 0) := (others => '0');
    signal s_bha_raw_cnt             :  std_logic_vector(31 downto 0) := (others => '0');
    signal s_ded_cnt                 :  std_logic_vector(31 downto 0) := (others => '0');
    signal s_inj_cnt                 :  std_logic_vector(31 downto 0) := (others => '0');

    -- status
    signal s_stat                    :  std_logic_vector(15 downto 0) := (others => '0');

    -- overflow
    signal s_cnt_overflow            :  t_reg_data       := (others => '0');

    signal s_clear                   : std_logic         := '0';
    signal s_injveto                 : std_logic         := '0';
  
begin
  
  -- input registers
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_cnt_run     <= i_cnt_run;
      s_vec_adc_hit <= i_vec_adc_hit;
      s_vec_sum_hit <= i_vec_sum_hit;
      s_vec_coi_hit <= i_vec_coi_hit;
      s_vec_roi_hit <= i_vec_roi_hit;
      s_evt_hit     <= i_evt_hit;    
      s_bharaw_hit  <= i_bharaw_hit; 
      s_bhaqua_hit  <= i_bhaqua_hit;
      s_dead_time   <= i_dead_time;
      s_injveto     <= i_injveto;
    end if;
  end process;
  
  RUNGEN : for ix in 0 to 255 generate
    process(i_clock)
    begin
      if rising_edge(i_clock) then
        s_cnt_run_cmx(ix) <= s_cnt_run;
      end if;
    end process;
  end generate RUNGEN;


  -- count counters
  CNT : process(i_clock)
  begin

    IF_EDGE : if rising_edge(i_clock) then

      IF_RST : if i_reset = '1' or i_clear = '1' then

        for jADC in 0 to N_ADC-1 loop
          s_adc_cnt(jADC) <= (others => '0');
          s_sum_cnt(jADC) <= (others => '0');
        end loop;

        s_coi_cnt     <= c_coi_cnt_zero;
        s_roi_cnt     <= c_coi_cnt_zero;
        s_dur_cnt     <= c_coi_cnt_zero;
        s_evt_cnt     <= (others => '0');
        s_bha_raw_cnt <= (others => '0');
        s_bha_qua_cnt <= (others => '0');
        s_ded_cnt     <= (others => '0');
        s_inj_cnt     <= (others => '0');
        s_stat        <= (others => '0');
        s_clk_cnt     <= (others => '0');
        
        s_cnt_overflow(14 downto 0)  <= (others => '0');
        
      else -- NOT RST

        s_cnt_overflow(14 downto 0)  <= (others => '0');

        -- CLOCKS COUNTER
        if s_cnt_run = '1' then
          if s_clk_cnt /= c_cnt32_max then
            s_clk_cnt <= s_clk_cnt + '1';
          else 
            s_cnt_overflow(0) <= '1';
          end if;
        end if;
  
        -- ADC OCCUPANCY
        for iADC in 0 to N_ADC-1 loop
          if s_vec_adc_hit(iADC) = '1' and s_cnt_run = '1' then
            if s_adc_cnt(iADC) /= c_cnt_max then
              s_adc_cnt(iADC) <= s_adc_cnt(iADC) + '1';
            else
              s_cnt_overflow(1) <= '1';
            end if;
          end if;
        end loop;

        -- SUM OCCUPANCY
        for iADC in 0 to N_ADC-1 loop
          if s_vec_sum_hit(iADC) = '1' and s_cnt_run = '1' then
            if s_sum_cnt(iADC) /= c_cnt_max then
              s_sum_cnt(iADC) <= s_sum_cnt(iADC) + '1';
            else
              s_cnt_overflow(2) <= '1';
            end if;
          end if;
        end loop;

        -- SUM COINCIDENCE COUNTER
        for iCOI in 0 to 15 loop
          if s_vec_coi_hit(iCOI) = '1' and s_cnt_run = '1' then
            if s_coi_cnt(iCOI) /= c_cnt_max then
              s_coi_cnt(iCOI) <= s_coi_cnt(iCOI) + '1';
            else
              s_cnt_overflow(3) <= '1';
            end if;
          end if;
        end loop;

        -- RAW COINCIDENCE COUNTER
        for iCOI in 0 to 15 loop
          if s_vec_roi_hit(iCOI) = '1' and s_cnt_run = '1' then
            if s_roi_cnt(iCOI) /= c_cnt_max then
              s_roi_cnt(iCOI) <= s_roi_cnt(iCOI) + '1';
            else
              s_cnt_overflow(4) <= '1';
            end if;
          end if;
        end loop;

        -- COINCIDENCE COUNTER
        for iDUR in 0 to 15 loop
          if s_vec_dur_hit(iDUR) = '1' and s_cnt_run = '1' then
            if s_dur_cnt(iDUR) /= c_cnt_max then
              s_dur_cnt(iDUR) <= s_dur_cnt(iDUR) + '1';
            else
              s_cnt_overflow(5) <= '1';
            end if;
          end if;
        end loop;

        -- EVENTS COUNTER
        if s_evt_hit = '1' and s_cnt_run = '1' then
          if s_evt_cnt /= c_cnt32_max then
            s_evt_cnt <= s_evt_cnt + '1';
          else 
            s_cnt_overflow(6) <= '1';
          end if;
        end if;

        -- BHABHA COUNTER RAW
        if s_bharaw_hit = '1' and s_cnt_run = '1' then
          if s_bha_raw_cnt /= c_cnt32_max then
            s_bha_raw_cnt <= s_bha_raw_cnt + '1';
          else 
            s_cnt_overflow(7) <= '1';
          end if;
        end if;

        -- BHABHA COUNTER WITH QUALITY SIGNAL
        if s_bhaqua_hit = '1' and s_cnt_run = '1' then
          if s_bha_qua_cnt /= c_cnt32_max then
            s_bha_qua_cnt <= s_bha_qua_cnt + '1';
          else 
            s_cnt_overflow(8) <= '1';
          end if;
        end if;

        -- DEAD TIME COUNTER
        if s_dead_time = '1' and s_cnt_run = '1' then
          if s_ded_cnt /= c_cnt32_max then
            s_ded_cnt <= s_ded_cnt + '1';
          else 
            s_cnt_overflow(9) <= '1';
          end if;
        end if;

        -- VETO TIME COUNTER
        if s_injveto = '1' and s_cnt_run = '1' then
          if s_inj_cnt /= c_cnt32_max then
            s_inj_cnt <= s_inj_cnt + '1';
          else 
            s_cnt_overflow(10) <= '1';
          end if;
        end if;

        --COINCIDENCE MATRIX 
        --for i in 0 to 255 loop
          --if i_vec_cmx_hit(i) = '1' and s_cnt_run = '1' then
            --if s_cmx_cnt(i) /= c_cnt_max then
              --s_cmx_cnt(i) <= s_cmx_cnt(i) + '1';
            --end if;
          --end if;
        --end loop;

      end if IF_RST;

    end if IF_EDGE;

  end process CNT;

  process(i_clock)
  begin
    if rising_edge(i_clock) then
      if i_reset = '1' or i_clear = '1' then
        s_cnt_overflow(15) <= '0';
      elsif s_cnt_overflow(14 downto 0) /= X"1FFF" then
        s_cnt_overflow(15) <= '1';
      else
        s_cnt_overflow(15) <= '0';
      end if;
    end if;

  end process;



  -- coincidence matrix 
  --MXGEN : for i in 0 to 255 generate
    --CNTMX : process(i_clock)
    --begin
      --if rising_edge(i_clock) then
        --if i_reset = '1' or i_clear = '1' then
          --s_cmx_cnt(i)     <= (others => '0');
        --elsif i_vec_cmx_hit(i) = '1' and s_cnt_run_cmx(i) = '1' then
            --if s_cmx_cnt(i) /= c_cnt_max then
              --s_cmx_cnt(i) <= s_cmx_cnt(i) + '1';
            --end if;
        --end if ;
      --end if;
    --end process CNTMX;
  --end generate MXGEN;




  -- output overflow flag
  o_cnt_overflow <= s_cnt_overflow;

  --output counters
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      o_adc_cnt     <= s_adc_cnt;
      o_sum_cnt     <= s_sum_cnt;
      o_coi_cnt     <= s_coi_cnt;
      o_roi_cnt     <= s_roi_cnt;
      o_cmx_cnt     <= s_cmx_cnt;
      o_evt_cnt     <= s_evt_cnt;
      o_clk_cnt     <= s_clk_cnt;
      o_bha_raw_cnt <= s_bha_raw_cnt;
      o_bha_qua_cnt <= s_bha_qua_cnt;
      o_ded_cnt     <= s_ded_cnt;
      o_inj_cnt     <= s_inj_cnt;
    end if;
  end process;

end cntman_arch;





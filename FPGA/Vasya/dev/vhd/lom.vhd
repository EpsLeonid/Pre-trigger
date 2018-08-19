library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.types.all;
use work.constants.all;

entity lom is 
  port (
    -- input
    i_clock           : in std_logic;
    i_reset           : in std_logic;

    -- input ADC data
    i_adc_data        : in t_adc_data_array(1 to N_ADC);

    -- histogram control
    i_hrun_ext        : in std_logic;  -- on/off filling of the histograms
    i_hclear          : in std_logic;  -- clear histograms
    i_htest_mode      : in std_logic;  -- histograms are filled with test values
                     
    i_crun_ext        : in std_logic;  -- on/off counters
    i_cclear          : in std_logic;  -- clear counters

    i_injveto         : in std_logic;

    -- input parameters of algorithm operation
    i_adc_mask        : in std_logic_vector(31 downto 0); -- mask for ADCs
    i_adc_thresholds  : in t_reg_32_array; -- amplitude discriminator thresholds
    i_adc_qthresholds : in t_reg_32_array; -- amplitude discriminator thresholds for bhabha quality signal
    i_sum_thresholds  : in t_reg_32_array; -- amplitude discriminator thresholds for bhabha quality signal
    i_discr_expand    : in t_reg_data;     -- duration of the signal from discriminator
    i_nevt            : in t_reg_data;     -- number of events before stop (temporary)
    i_clkmax          : in std_logic_vector(31 downto 0); -- measurement time
    i_trgtype         : in std_logic_vector(2 downto 0); -- trigger type

    i_dead_time_max   : std_logic_vector(31 downto 0); -- duration of the dead time pulse
    
    -- TODO:
    -- i_clk_max     : in std_logic_vector(31 downto 0); -- duration of the measurement

    -- read histograms
    i_hread_index     : in  std_logic_vector(LOM_HISTO_INDEX_BITS-1 downto 0); -- histogram number
    i_hread_addr      : in  std_logic_vector(15 downto 0);                     -- bin index
    o_hread_data      : out std_logic_vector(LOM_HISTO_VAL_BITS -1 downto 0);  -- read out histogram bin content 

    o_trg             : out std_logic;

    -- output status (histograms and counters running/stopped)
    o_lom_stat        : out t_reg_data;
                     
    -- amplitudes measured by peak detectors
    o_arr_adc_amp     : out t_adc_data_array(1 to N_ADC);
    o_arr_sum_amp     : out t_adc_sum_array(1 to N_ADC);

    -- output counters values
    o_adc_cnt         : out t_reg_32_array;                -- adc occupancy
    o_sum_cnt         : out t_reg_32_array;                -- running sums occupancy
    o_coi_cnt         : out t_reg_16_array;                -- counter for number of coincidences of sum signals
    o_roi_cnt         : out t_reg_16_array;                -- counter for number of coincidences of raw signals
    o_cmx_cnt         : out t_reg_array(0 to 255);      
    o_evt_cnt         : out t_reg_data;                    -- events counter (temporary)
    o_bha_raw_cnt     : out std_logic_vector(31 downto 0); -- bhabha w/o quality
    o_bha_qua_cnt     : out std_logic_vector(31 downto 0); -- bhabha w/ quality
    o_fake_cnt        : out std_logic_vector(31 downto 0); -- fake bhabha

    o_ded_cnt         : out std_logic_vector(31 downto 0); -- number of clocks counted during measurement
    o_clk_cnt         : out std_logic_vector(31 downto 0); -- duration of the dead time in clock cycles        
    o_inj_cnt         : out std_logic_vector(31 downto 0); -- duration of the injection time in clock cycles        

    -- overflow flags
    o_cnt_overflow    : out t_reg_data;
    o_hist_overflow   : out std_logic

  );

end lom;

architecture lom_arch of lom is

  --------- FUNCTIONS ---------------
  function func_vect_or(vec : std_logic_vector) return std_logic is
    variable res : std_logic := '0';
  begin
    for ix in 0 to vec'length-1 loop
      res := res or vec(ix);
    end loop;
    return res; 
  end func_vect_or;
  ------------------------------------

  ----- CALCULATE CHANNEL NUMBER FOR COINCEDENCE --------------------
  function func_chan32_plus_x(IADC : integer; x : integer) return integer is
    variable chan : integer := 0;
  begin
    chan := IADC + x;
    if chan > 32 then
      chan := chan - 32;
    end if;
    return chan;
  end function func_chan32_plus_x;
  -------------------------------------------------------------------

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

  signal s_arr_adc_data        : t_adc_sum_array(1 to N_ADC)      := (others => (others => '0')); 
  signal s_arr_adc_sums        : t_adc_sum_array(1 to N_ADC)  := (others => (others => '0')); 

  -- input parameters
  signal s_adc_mask           : std_logic_vector(31 downto 0) := (others => '0'); 
  signal s_adc_thresholds     : t_reg_32_array                := (others => (others => '0')); 
  signal s_adc_qthresholds    : t_reg_32_array                := (others => (others => '0')); 
  signal s_sum_thresholds     : t_reg_32_array                := (others => (others => '0')); 
  signal s_discr_expand       : t_reg_data                    := (others => '0');     
  signal s_coi_thresholds     : t_reg_16_array                := (others => (others => '0')); 
  signal s_nevt               : t_reg_data                    := (others => '0');     
  signal s_clk_max             : std_logic_vector(31 downto 0) := (others => '0');

  -- FOR DISCRIMINATORS
  signal s_vec_gate               : std_logic_vector(N_ADC-1 downto 0); -- gate signal for peak detectors
  signal s_vec_gate_sum           : std_logic_vector(N_ADC-1 downto 0); -- gate signal for peak detectors
  signal s_vec_texp               : std_logic_vector(N_ADC-1 downto 0); -- fixed duration signal after discriminators
  signal s_vec_texp_pre           : std_logic_vector(N_ADC-1 downto 0); -- fixed duration signal after discriminators
  signal s_vec_texp_sum           : std_logic_vector(N_ADC-1 downto 0); 

  signal s_texp_or                : std_logic;
  signal s_texp_or_pre            : std_logic;
  signal s_texp_or_meta           : std_logic;
  signal s_adc_hit_or             : std_logic; 
  signal s_adc_hit_dt             : std_logic; 
  signal s_adc_hit_dt_cnt         : t_reg_data                       := (others => '0');

  signal s_vec_discr_q            : std_logic_vector(N_ADC-1 downto 0); -- for bhabha quality

  -- AMPLITUDE
  signal s_arr_ampl               : t_adc_data_array(1 to N_ADC)     := (others => (others => '0'));
  signal s_arr_sum_ampl           : t_adc_sum_array(1 to N_ADC)      := (others => (others => '0'));

  signal s_arr_adc_amp            : t_adc_data_array(1 to N_ADC)     := (others => (others => '0'));
  signal s_arr_sum_amp            : t_adc_sum_array(1 to N_ADC)      := (others => (others => '0'));

  -- AMPL HISTS
  signal s_vec_hist_overflow      : std_logic_vector(N_ADC-1 downto 0)                 := (others => '0');
  signal s_hread_addr             : std_logic_vector(15 downto 0)                      := (others => '0');
  signal s_hread_data             : std_logic_vector(LOM_HISTO_VAL_BITS  - 1 downto 0) := (others => '0');
  signal s_vec_hist_wena          : std_logic_vector(N_ADC-1 downto 0); -- histograms write enable
  signal s_vec_sumhist_wena       : std_logic_vector(N_ADC-1 downto 0); -- histograms write enable
  signal s_vec_shist_overflow     : std_logic_vector(N_ADC-1 downto 0)  := (others => '0');

  -- FOR COINCEDENCE CIRCUITS
  signal s_vec_coi                : std_logic_vector(N_ADC/2-1 downto 0)  := (others => '0');
  signal s_coi_or                 : std_logic := '0';
  signal s_coi_or_pre             : std_logic := '0';
  signal s_vec_coi_hit            : std_logic_vector(N_ADC/2-1 downto 0)  := (others => '0');

  signal s_vec_roi                : std_logic_vector(N_ADC/2-1 downto 0)  := (others => '0');
  signal s_vec_roi_hit            : std_logic_vector(N_ADC/2-1 downto 0)  := (others => '0');
  signal s_vec_coimx              : std_logic_vector(255 downto 0)        := (others => '0');


  -- BHABHA
  signal s_bhabha_qua             : std_logic                        := '0';
  signal s_bhabha_raw             : std_logic                        := '0';
  signal s_QualityFWD             : std_logic                        := '0';
  signal s_QualityBWD             : std_logic                        := '0';
  signal s_Quality                : std_logic                        := '0';
  signal s_bha_raw_cnt            : std_logic_vector(31 downto 0)    := (others => '0');
  signal s_bha_qua_cnt            : std_logic_vector(31 downto 0)    := (others => '0');
  signal s_fake_bhabha_cnt        : std_logic_vector(31 downto 0)    := (others => '0');

  signal s_dead_time              : std_logic                        := '0';
  signal s_DeadTimeMAX            : std_logic_vector(31 downto 0)    := (others => '0');
  signal s_DeadTimeCNT            : std_logic_vector(31 downto 0)    := (others => '0');
  signal s_DeadTimeRaw            : std_logic                        := '0';
  signal s_DeadTimeRawMAX         : std_logic_vector(31 downto 0)    := (others => '0');
  signal s_DeadTimeRawCNT         : std_logic_vector(31 downto 0)    := (others => '0');

  -- dead time counter
  signal s_dt_cnt                : std_logic_vector(31 downto 0) := (others => '0');

  -- STATUS
  signal s_hrun_int               : std_logic := '0'; -- internally generated signal to run/stop histo filling
                                                      -- histo filling stopped by counter or overflow (?)
  signal s_crun_int               : std_logic := '0';

  -- status of the precesses (histograms/counters)
  signal s_lom_stat               : t_reg_data                    := (others => '0');
  signal s_data_ready             : std_logic                     := '0';

  -- resulting enable signals for counters and histograms (EXT & INT)
  signal s_hrun                   : std_logic := '0';
  signal s_crun                   : std_logic := '0';

  signal s_vec_adc_hit           : std_logic_vector(N_ADC-1 downto 0) := (others => '0'); 
  signal s_vec_sum_hit           : std_logic_vector(N_ADC-1 downto 0) := (others => '0'); 
  
  -- COUNTERS
  signal s_adc_cnt                : t_reg_32_array := (others => (others => '0'));
  signal s_sum_cnt                : t_reg_32_array := (others => (others => '0'));
  signal s_coi_cnt                : t_reg_16_array := (others => (others => '0'));
  signal s_roi_cnt                : t_reg_16_array := (others => (others => '0'));
  signal s_cmx_cnt                : t_reg_array(0 to 255) := (others => (others => '0'));
  signal s_evt_cnt                : t_reg_data     := (others => '0');
  signal s_clk_cnt                : std_logic_vector(31 downto 0) := (others => '0');
  signal s_inj_cnt                : std_logic_vector(31 downto 0) := (others => '0');

  signal s_trg                    : std_logic      := '0';
  signal s_trgtype                : std_logic_vector(2 downto 0) := (others => '0');

  signal s_cnt_overflow           : t_reg_data     := (others => '0');
  signal s_hist_overflow          : std_logic      := '0';

  signal s_injveto                : std_logic      := '0';
  
  constant ALL_ZEROS_16           : std_logic_vector(15 downto 0) := (others => '0');
  constant ALL_ZEROS_32           : std_logic_vector(15 downto 0) := (others => '0');
  constant REG_ZERO               : t_reg_data                    := (others => '0');

begin


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

  -- DFFs for input parameters. Is it needed? TIG them is better?
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_adc_mask        <= i_adc_mask; 
      s_adc_thresholds  <= i_adc_thresholds;
      s_adc_qthresholds <= i_adc_qthresholds;
      s_sum_thresholds  <= i_sum_thresholds;
      s_discr_expand    <= i_discr_expand;
      s_nevt            <= i_nevt;
      s_trgtype         <= i_trgtype;
      s_clk_max         <= i_clkmax;
      s_injveto         <= i_injveto;
    end if;
  end process;
  --


  --- generate coincidence logic for all ADC channels -------------------
  ADC_GEN : for nADC in 1 to N_ADC generate

    -- DFFs for input ADC samples
    IADC_PROC : process(i_clock)
    begin
      s_arr_adc_data(nADC) <= '0' & i_adc_data(nADC); -- extend by one bit for uniformity of 
                                                      -- single sector signals and sum signals
    end process IADC_PROC;
    --

    -- discriminator for quality signals
    DU_QUA : entity work.discriminator
    generic map ( INPUT_BITS => ADC_BIT_WIDTH+1 )
    port map(
      i_clock     => i_clock , 
      i_reset     => i_reset,
      i_enable    => s_adc_mask(nADC-1),    -- on/off 
      i_threshold => s_adc_qthresholds(nADC-1)(ADC_BIT_WIDTH downto 0), -- ADC_BIT_WIDTH+1
      i_texp      => s_discr_expand,        -- duration of the output signal
      i_input     => s_arr_adc_data(nADC),  -- input signal 
      o_texp      => open,                  -- output signal with fixed duration
      o_gate      => s_vec_discr_q(nADC-1)  -- gate signal for the peak detector
    );

    -- discriminators for coincidence circuits
    DU_RAW : entity work.discriminator
    generic map ( INPUT_BITS => ADC_BIT_WIDTH+1 )
    port map(
      i_clock     => i_clock , 
      i_reset     => i_reset,
      i_enable    => s_adc_mask(nADC-1),     -- on/off 
      i_threshold => s_adc_thresholds(nADC-1)(ADC_BIT_WIDTH downto 0),-- ADC_BIT_WIDTH+1
      i_texp      => s_discr_expand,         -- duration of the output signal
      i_input     => s_arr_adc_data(nADC),   -- input signal 
      o_texp      => s_vec_texp(nADC-1),     -- output signal with fixed duration
      o_gate      => s_vec_gate(nADC-1),     -- gate signal for the peak detector
      o_hit       => s_vec_adc_hit(nADC-1)
    );

    -- discriminator for running sum signals
    DU_SUM : entity work.discriminator
    generic map ( INPUT_BITS => ADC_BIT_WIDTH+1 )
    port map(
      i_clock     => i_clock , 
      i_reset     => i_reset,
      i_enable    => '1',    -- on/off (already masked while calculating sums)
      i_threshold => s_sum_thresholds(nADC-1)(ADC_BIT_WIDTH downto 0),-- ADC_BIT_WIDTH+1
      i_texp      => s_discr_expand,         -- duration of the output signal
      i_input     => s_arr_adc_sums(nADC),   -- input signal 
      o_texp      => s_vec_texp_sum(nADC-1), -- output signal with fixed duration
      o_gate      => s_vec_gate_sum(nADC-1), -- gate signal for the peak detector
      o_hit       => s_vec_sum_hit(nADC-1)   -- one clock signal
    );
    

    -- determine maximum of the signal inside a gate provided by discriminator component
    PD_RAW  : entity work.peak_detector
    generic map ( INPUT_BITS => ADC_BIT_WIDTH )
    port map (i_clock, i_reset, s_vec_gate(nADC-1), s_arr_adc_data(nADC)(ADC_BIT_WIDTH-1 downto 0), 
              s_vec_hist_wena(nADC-1), s_arr_ampl(nADC));

    -- peak detectors for running sum signals
    PD_SUM  : entity work.peak_detector
    generic map ( INPUT_BITS => ADC_BIT_WIDTH+1 )
    port map (i_clock, i_reset, s_vec_gate_sum(nADC-1), s_arr_adc_sums(nADC), 
              s_vec_sumhist_wena(nADC-1), s_arr_sum_ampl(nADC));

  end generate ADC_GEN;
  ----------------------------------------------------------------------------
    
  -- matrix 16x16 of coincidences
  --CU_BWD_GEN : for i in 0 to 15 generate
    --CU_FWD_GEN : for j in 0 to 15 generate
      --CU_MX  : entity work.coincidence 
      --port map (
        --i_clock            =>   i_clock, 
        --i_reset            =>   i_reset,
        --i_data_1           =>   s_vec_texp(i),
        --i_data_2           =>   s_vec_texp(16+j), 
        --o_coin             =>   s_vec_coimx(i + j*16)
      --);
    --end generate CU_FWD_GEN;
  --end generate CU_BWD_GEN;
  -----------------------------------------

  -- raw coincidences 
  CU_RAW_GEN : for nCOI in 1 to 16 generate
    CU_RAW  : entity work.coincidence 
    port map (
      i_clock            =>   i_clock, 
      i_reset            =>   i_reset,
      i_data_1           =>   s_vec_texp(nCOI-1),
      i_data_2           =>   s_vec_texp(func_chan32_plus_x(nCOI,16) - 1), 
      o_coin             =>   s_vec_roi(nCOI-1),        -- single clock coincidence signal
      o_coin_hit         =>   s_vec_roi_hit(nCOI-1)        -- single clock coincidence signal
    );
  end generate CU_RAW_GEN;
  ------------------------------------

  -- coincidences for sum signals
  CU_SUM_GEN : for nCOI in 1 to 16 generate
    CU_SUM  : entity work.coincidence 
    port map (
      i_clock            =>   i_clock, 
      i_reset            =>   i_reset,
      i_data_1           =>   s_vec_texp_sum(nCOI-1),
      i_data_2           =>   s_vec_texp_sum(func_chan32_plus_x(nCOI,16) - 1), 
      o_coin             =>   s_vec_coi(nCOI-1),           -- coincidence signal
      o_coin_hit         =>   s_vec_coi_hit(nCOI-1)        -- single clock coincidence signal
    );
  end generate CU_SUM_GEN;
  ------------------------------------

  s_texp_or <= func_vect_or(s_vec_texp);
  

  -- At the moment 'event' is the OR signal for ADC hits
  ADCHIT_PROC : process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_texp_or_meta       <= s_texp_or;
      s_texp_or_pre        <= s_texp_or_meta;

      if s_texp_or_pre = '0' and s_texp_or_meta = '1' and s_adc_hit_dt = '0' then
        s_adc_hit_dt       <= '1';
        s_adc_hit_or       <= '1';
        s_adc_hit_dt_cnt   <= (others => '0');
      else
        if s_adc_hit_dt = '1' and s_adc_hit_dt_cnt < s_discr_expand then
          s_adc_hit_dt     <= '1';
          s_adc_hit_dt_cnt <= s_adc_hit_dt_cnt + '1';
        else 
          s_adc_hit_dt     <= '0';
        end if;
        s_adc_hit_or       <= '0';
      end if;
    end if;
  end process ADCHIT_PROC;
  -------------------------------------------------------


  -- generate trigger signal ---------------------------
  TRG_PROC : process(i_clock)
  begin

    if rising_edge(i_clock) then
      case s_trgtype is 
        when B"000" =>   -- default TODO : change
          s_trg <= s_adc_hit_or;
        when B"001" =>
          s_trg <= s_adc_hit_or;
        when B"010" =>
          s_trg <= s_bhabha_raw;
        when B"011" => 
          s_trg <= s_bhabha_qua;
        when others =>
          s_trg <= '0';
      end case;
    end if;

  end process TRG_PROC;
  o_trg <= s_trg;
  -------------------------------------------------------


  -- catch amplitudes (for FAM studies)
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_arr_sum_amp <= s_arr_sum_ampl;
      s_arr_adc_amp <= s_arr_ampl;
    end if;
  end process;
  o_arr_adc_amp <= s_arr_adc_amp;
  o_arr_sum_amp <= s_arr_sum_amp;
  -------------------------------------------------------

  ----- HISTOGRAM MANAGER -------------------------------
  HIST_MAN : entity work.histo_manager 
  port map (
    i_clock              =>   i_clock,
    i_reset              =>   i_reset,

    i_hrun               =>   s_hrun,          -- run(1)/stop(0) filling histograms
    i_hclear             =>   i_hclear,        -- clear histograms content
                                              
    i_htest_mode         =>   i_htest_mode,    -- mode: normal(0)/test(1)

    i_vec_hist_wena      =>   s_vec_hist_wena, -- write enable for amplitude histograms
    i_arr_adc_ampl       =>   s_arr_ampl,      -- input amplitudes

    i_vec_sumhist_wena   =>   s_vec_sumhist_wena, -- write enable for amplitude histograms
    i_arr_sum_ampl       =>   s_arr_sum_ampl,      -- input amplitudes
                             
    i_hist_index         =>   i_hread_index,   -- input histogram index
    i_hbin_addr          =>   i_hread_addr,    -- input bin index

    o_hbin_data          =>   s_hread_data,    -- output bin value

    o_vec_ahist_overflow =>   s_vec_hist_overflow,
    o_vec_shist_overflow =>   s_vec_shist_overflow
  );

  s_hread_addr <= i_hread_addr;
  o_hread_data <= s_hread_data;
  -------------------------------------------------------

  ----- COUNTERS MANAGER --------------------------------
  CNT_MAN : entity work.counters_manager
  port map (
    i_clock        => i_clock,
    i_reset        => i_reset,

    i_clear        => i_cclear,
    i_cnt_run      => s_crun,

    i_injveto      => s_injveto,

    i_vec_adc_hit  => s_vec_adc_hit,
    i_vec_sum_hit  => s_vec_sum_hit,
    i_vec_coi_hit  => s_vec_coi_hit,     -- coinidences of runing sums
    i_vec_roi_hit  => s_vec_roi_hit, -- coincidence of raw signals  
    i_vec_cmx_hit  => s_vec_coimx,  -- matrix of coincidences
    i_evt_hit      => s_adc_hit_or, -- TODO : change meaning of the 'event'
    i_bharaw_hit   => s_bhabha_raw,
    i_bhaqua_hit   => s_bhabha_qua,
    i_dead_time    => s_dead_time,
                  
    o_adc_cnt      => s_adc_cnt,
    o_sum_cnt      => s_sum_cnt,
    o_coi_cnt      => s_coi_cnt,
    o_roi_cnt      => s_roi_cnt,
    o_cmx_cnt      => s_cmx_cnt,
    o_evt_cnt      => s_evt_cnt,
    o_bha_raw_cnt  => s_bha_raw_cnt,
    o_bha_qua_cnt  => s_bha_qua_cnt,
    o_clk_cnt      => s_clk_cnt,
    o_ded_cnt      => s_dt_cnt,
    o_inj_cnt      => s_inj_cnt,
    
    o_cnt_overflow => s_cnt_overflow

  );
  -------------------------------------------------------

  -------------------------------------------------------
  -- redirect counters to output
  -------------------------------------------------------
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      o_adc_cnt      <= s_adc_cnt;
      o_sum_cnt      <= s_sum_cnt;
      o_evt_cnt      <= s_evt_cnt;
      o_cmx_cnt      <= s_cmx_cnt;
      o_coi_cnt      <= s_coi_cnt;
      o_roi_cnt      <= s_roi_cnt;
                    
      o_clk_cnt      <= s_clk_cnt;
      o_bha_raw_cnt  <= s_bha_raw_cnt;
      o_bha_qua_cnt  <= s_bha_qua_cnt;
      o_ded_cnt      <= s_dt_cnt;
      o_inj_cnt      <= s_inj_cnt;
      o_cnt_overflow <= s_cnt_overflow;
    end if;
  end process;
  -------------------------------------------------------
  
  -------------------------------------------------------
  -- STOP PROCESSES WHEN MEASUREMENT IS FINISHED
  -------------------------------------------------------
  RUN_PROC: process(i_clock)
  begin
    if rising_edge(i_clock) then
      if ( s_nevt    /= REG_ZERO     and s_evt_cnt = s_nevt     ) or
         ( s_clk_max /= ALL_ZEROS_32 and s_clk_cnt(31 downto 2) = s_clk_max(29 downto 0)  ) then
        s_crun <= '0';
        s_hrun <= '0';
        s_data_ready <= '1';
      else
        s_hrun       <= i_hrun_ext;
        s_crun       <= i_crun_ext;
        s_data_ready <= '0';
      end if;
    end if;
  end process RUN_PROC;
  -------------------------------------------------------

  -------------------------------------------------------
  -- Redirect status to output
  -------------------------------------------------------
  STAT_PROC : process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_lom_stat(0) <= s_hrun;
      s_lom_stat(1) <= s_crun;
      s_lom_stat(2) <= s_data_ready;
      -- .... add some more parameters TODO
    end if;
  end process STAT_PROC;
  o_lom_stat    <= s_lom_stat;
  -------------------------------------------------------

  -------------------------------------------------------
  -- MANAGE OVERFLOW FLAGS (simply bitwise OR at this time)
  -------------------------------------------------------
  OVERPROC : process(i_clock)
  begin 
    
    if rising_edge(i_clock) then
      
      o_hist_overflow <= '0';
      if s_vec_shist_overflow /= ALL_ZEROS_32 then
        o_hist_overflow <= '1'; -- FIXME : move it to status register
      end if;
      if s_vec_hist_overflow /= ALL_ZEROS_32 then
        o_hist_overflow <= '1'; -- FIXME : move it to status register
      end if;

    end if;

  end process OVERPROC;
  -------------------------------------------------------

  -- generate bhabha quality signals (bhabha pattern)
  QUA_PROC : process(i_clock)
  begin
    if rising_edge(i_clock) then
      --B"0000_0000_0000_0000"
      -- backward endcap
      if s_vec_discr_q(15 downto 0)  = B"0000000000000001" or
         s_vec_discr_q(15 downto 0)  = B"0000000000000010" or
         s_vec_discr_q(15 downto 0)  = B"0000000000000100" or
         s_vec_discr_q(15 downto 0)  = B"0000000000001000" or
         s_vec_discr_q(15 downto 0)  = B"0000000000010000" or
         s_vec_discr_q(15 downto 0)  = B"0000000000100000" or
         s_vec_discr_q(15 downto 0)  = B"0000000001000000" or
         s_vec_discr_q(15 downto 0)  = B"0000000010000000" or
         s_vec_discr_q(15 downto 0)  = B"0000000100000000" or
         s_vec_discr_q(15 downto 0)  = B"0000001000000000" or
         s_vec_discr_q(15 downto 0)  = B"0000010000000000" or
         s_vec_discr_q(15 downto 0)  = B"0000100000000000" or
         s_vec_discr_q(15 downto 0)  = B"0001000000000000" or
         s_vec_discr_q(15 downto 0)  = B"0010000000000000" or
         s_vec_discr_q(15 downto 0)  = B"0100000000000000" or
         s_vec_discr_q(15 downto 0)  = B"1000000000000000" or

         s_vec_discr_q(15 downto 0)  = B"0000000000000011" or
         s_vec_discr_q(15 downto 0)  = B"0000000000000110" or
         s_vec_discr_q(15 downto 0)  = B"0000000000001100" or
         s_vec_discr_q(15 downto 0)  = B"0000000000011000" or
         s_vec_discr_q(15 downto 0)  = B"0000000000110000" or
         s_vec_discr_q(15 downto 0)  = B"0000000001100000" or
         s_vec_discr_q(15 downto 0)  = B"0000000011000000" or
         s_vec_discr_q(15 downto 0)  = B"0000000110000000" or
         s_vec_discr_q(15 downto 0)  = B"0000001100000000" or
         s_vec_discr_q(15 downto 0)  = B"0000011000000000" or
         s_vec_discr_q(15 downto 0)  = B"0000110000000000" or
         s_vec_discr_q(15 downto 0)  = B"0001100000000000" or
         s_vec_discr_q(15 downto 0)  = B"0011000000000000" or
         s_vec_discr_q(15 downto 0)  = B"0110000000000000" or
         s_vec_discr_q(15 downto 0)  = B"1100000000000000" or
         s_vec_discr_q(15 downto 0)  = B"1000000000000001" then

        s_QualityBWD <= '1';
      else 
        s_QualityBWD <= '0';
      end if;
      
      -- forward endcap 
      if s_vec_discr_q(31 downto 16) = B"0000000000000001" or
         s_vec_discr_q(31 downto 16) = B"0000000000000010" or
         s_vec_discr_q(31 downto 16) = B"0000000000000100" or
         s_vec_discr_q(31 downto 16) = B"0000000000001000" or
         s_vec_discr_q(31 downto 16) = B"0000000000010000" or
         s_vec_discr_q(31 downto 16) = B"0000000000100000" or
         s_vec_discr_q(31 downto 16) = B"0000000001000000" or
         s_vec_discr_q(31 downto 16) = B"0000000010000000" or
         s_vec_discr_q(31 downto 16) = B"0000000100000000" or
         s_vec_discr_q(31 downto 16) = B"0000001000000000" or
         s_vec_discr_q(31 downto 16) = B"0000010000000000" or
         s_vec_discr_q(31 downto 16) = B"0000100000000000" or
         s_vec_discr_q(31 downto 16) = B"0001000000000000" or
         s_vec_discr_q(31 downto 16) = B"0010000000000000" or
         s_vec_discr_q(31 downto 16) = B"0100000000000000" or
         s_vec_discr_q(31 downto 16) = B"1000000000000000" or  

         s_vec_discr_q(31 downto 16) = B"0000000000000011" or
         s_vec_discr_q(31 downto 16) = B"0000000000000110" or
         s_vec_discr_q(31 downto 16) = B"0000000000001100" or
         s_vec_discr_q(31 downto 16) = B"0000000000011000" or
         s_vec_discr_q(31 downto 16) = B"0000000000110000" or
         s_vec_discr_q(31 downto 16) = B"0000000001100000" or
         s_vec_discr_q(31 downto 16) = B"0000000011000000" or
         s_vec_discr_q(31 downto 16) = B"0000000110000000" or
         s_vec_discr_q(31 downto 16) = B"0000001100000000" or
         s_vec_discr_q(31 downto 16) = B"0000011000000000" or
         s_vec_discr_q(31 downto 16) = B"0000110000000000" or
         s_vec_discr_q(31 downto 16) = B"0001100000000000" or
         s_vec_discr_q(31 downto 16) = B"0011000000000000" or
         s_vec_discr_q(31 downto 16) = B"0110000000000000" or
         s_vec_discr_q(31 downto 16) = B"1100000000000000" or
         s_vec_discr_q(31 downto 16) = B"1000000000000001" then
        
        s_QualityFWD <= '1';
      else 
        s_QualityFWD <= '0';
      end if;

    end if;
  end process QUA_PROC;

  s_Quality <= s_QualityBWD and s_QualityFWD;
  
  -------------------------------------------------------
  -- Generate BhaBha signal
  -------------------------------------------------------
  s_DeadTimeMAX <= i_dead_time_max;
  BHABHA : process(i_clock)
  begin
    
    if rising_edge(i_clock) then
      s_dead_time       <= '0';
      s_bhabha_raw      <= '0';
      s_bhabha_qua      <= '0';

      if s_vec_coi /= X"0000" then
        s_coi_or <= '1';
      else 
        s_coi_or <= '0';
      end if;
      s_coi_or_pre <= s_coi_or;

      if s_coi_or = '1' and s_coi_or_pre = '0' and s_DeadTimeRaw = '0' then
        s_bhabha_raw       <= '1';
        s_DeadTimeRaw     <= '1';
        s_DeadTimeRawCNT  <= (others => '0');
      end if;
      
      if s_coi_or = '1' and s_coi_or_pre = '0' and s_dead_time = '0' and s_Quality = '1'  then
        s_bhabha_qua    <= '1';
        s_dead_time     <= '1';
        s_DeadTimeCNT  <= (others => '0');
      end if;
      
      if s_DeadTimeRaw = '1' and s_DeadTimeRawCNT < s_DeadTimeMAX then
         s_DeadTimeRaw    <= '1';
         s_DeadTimeRawCNT <= s_DeadTimeRawCNT + '1';
      elsif s_DeadTimeRawCNT = s_DeadTimeMAX then
        s_DeadTimeRawCNT  <= (others => '0');
        s_DeadTimeRaw     <= '0';
      end if;

      if s_dead_time = '1' and s_DeadTimeCNT < s_DeadTimeMAX then
         s_dead_time    <= '1';
         s_DeadTimeCNT <= s_DeadTimeCNT + '1';
      elsif s_DeadTimeCNT = s_DeadTimeMAX then
        s_DeadTimeCNT  <= (others => '0');
        s_dead_time     <= '0';
      end if;

    end if;

  end process BHABHA;
  -------------------------------------------------------


end lom_arch;
------------------------------------------



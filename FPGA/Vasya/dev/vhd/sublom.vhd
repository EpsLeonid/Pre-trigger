library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.types.all;
use work.constants.all;

entity lom is 
  generic
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

    -- input parameters of algorithm operation
    i_adc_mask        : in std_logic_vector(31 downto 0); -- mask for ADCs
    i_adc_thresholds  : in t_reg_32_array; -- amplitude discriminator thresholds
    i_adc_qthresholds : in t_reg_32_array; -- amplitude discriminator thresholds for bhabha quality signal
    i_discr_expand    : in t_reg_data;     -- duration of the signal from discriminator
    i_coi_thresholds  : in t_reg_16_array; -- threshold value for coincidence duration
    i_nevt            : in t_reg_data;     -- number of events before stop

    i_dead_time_max   : std_logic_vector(31 downto 0); -- duration of the dead time pulse

    -- read histograms
    i_hread_index     : in  std_logic_vector(LOM_HISTO_INDEX_BITS-1 downto 0); -- histogram number
    i_hread_addr      : in  std_logic_vector(15 downto 0);                     -- bin index
    o_hread_data      : out std_logic_vector(LOM_HISTO_VAL_BITS -1 downto 0);  -- read out histogram bin content 

    -- output status (histograms and counters running/stopped)
    o_lom_stat        : out t_reg_data;
                     
    -- output        
    o_arr_coidur      : out t_coidur_array(1 to N_ADC/2);
    -- output counters values
    o_adc_cnt         : out t_reg_32_array;
    o_coi_cnt         : out t_reg_16_array;
    o_dur_cnt         : out t_reg_16_array;
    o_evt_cnt         : out t_reg_data;
    o_bha_cnt         : out std_logic_vector(31 downto 0); 
    o_ded_cnt         : out std_logic_vector(31 downto 0);
    o_clk_cnt         : out std_logic_vector(31 downto 0);
                     
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
  function func_chan_plus_x(IADC : integer; x : integer) return integer is
    variable chan : integer := 0;
  begin
    chan := IADC + x;
    if chan > 32 then
      chan := chan - 32;
    end if;
    return chan;
  end function func_chan_plus_x;
  -------------------------------------------------------------------

  signal s_arr_adc_data        : t_adc_data_array(1 to N_ADC)      := (others => (others => '0')); 
  signal s_arr_adc_sums        : t_adc_sum_data_array(1 to N_ADC)  := (others => (others => '0')); 

  -- input parameters
  signal s_adc_mask           : std_logic_vector(31 downto 0) := (others => '0'); 
  signal s_adc_thresholds     : t_reg_32_array                := (others => (others => '0')); 
  signal s_adc_qthresholds    : t_reg_32_array                := (others => (others => '0')); 
  signal s_adc_sum_thresholds : t_reg_32_array                := (others => (others => '0')); 
  signal s_discr_expand       : t_reg_data                    := (others => '0');     
  signal s_coi_thresholds     : t_reg_16_array                := (others => (others => '0')); 
  signal s_nevt               : t_reg_data                    := (others => '0');     

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

  signal s_vec_discr_q            : std_logic_vector(N_ADC-1 downto 0); -- for bhabha quality

  -- AMPLITUDE
  signal s_arr_ampl               : t_adc_data_array(1 to N_ADC)      := (others => (others => '0'));


  -- AMPL HISTS
  signal s_vec_hist_overflow      : std_logic_vector(N_ADC-1 downto 0)                 := (others => '0');
  signal s_hread_addr             : std_logic_vector(15 downto 0)                      := (others => '0');
  signal s_hread_data             : std_logic_vector(LOM_HISTO_VAL_BITS  - 1 downto 0) := (others => '0');
  signal s_vec_hist_wena          : std_logic_vector(N_ADC-1 downto 0); -- histograms write enable

  -- FOR COINCEDENCE CIRCUITS
  signal s_arr_coidur             : t_coidur_array(1 to N_ADC/2)           := (others => (others => '0'));
  signal s_vec_coidur_we          : std_logic_vector(N_ADC-1 downto 0)   := (others => '0');
  signal s_vec_coidur_overflow    : std_logic_vector(N_ADC-1 downto 0)   := (others => '0');
  signal s_vec_coin               : std_logic_vector(N_ADC/2-1 downto 0) := (others => '0');
  signal s_vec_coin_thr           : std_logic_vector(N_ADC-1 downto 0)   := (others => '0');
  signal s_vec_coihist_overflow   : std_logic_vector(N_ADC/2-1 downto 0) := (others => '0');

  -- BHABHA
  signal s_Bhabha                 : std_logic                        := '0';
  signal s_QualityFWD             : std_logic                        := '0';
  signal s_QualityBWD             : std_logic                        := '0';
  signal s_Quality                : std_logic                        := '0';
  signal s_Bhabha_CNT             : std_logic_vector(31 downto 0)    := (others => '0');

  signal s_DeadTime               : std_logic := '0';
  signal s_DeadTimeMAX            : std_logic_vector(31 downto 0) := (others => '0');
  signal s_DeadTimeCNT            : std_logic_vector(31 downto 0) := (others => '0');

  -- dead time counter
  signal s_DT_GCNT                : std_logic_vector(31 downto 0) := (others => '0');
  -- clock counter
  signal s_CLK_GCNT               : std_logic_vector(31 downto 0) := (others => '0');

  -- STATUS
  signal s_hrun_int               : std_logic := '0'; -- internally generated signal to run/stop histo filling
                                                      -- histo filling stopped by counter or overflow (?)
  signal s_crun_int               : std_logic := '0';

  -- status of the precesses (histograms/counters)
  signal s_lom_stat               : t_reg_data                    := (others => '0');

  -- resulting enable signals for counters and histograms (EXT & INT)
  signal s_hrun                   : std_logic := '0';
  signal s_crun                   : std_logic := '0';

  signal s_vec_adc_hit           : std_logic_vector(N_ADC-1 downto 0) := (others => '0'); 
  
  -- COUNTERS
  signal s_adc_cnt                : t_reg_32_array := (others => (others => '0'));
  signal s_coi_cnt                : t_reg_16_array := (others => (others => '0'));
  signal s_dur_cnt                : t_reg_16_array := (others => (others => '0'));
  signal s_evt_cnt                : t_reg_data     := (others => '0');
  signal s_clk_cnt                : t_reg_data     := (others => '0');

  signal s_cnt_overflow           : t_reg_data     := (others => '0');
  signal s_hist_overflow          : std_logic      := '0';
  
  constant ALL_ZEROS_16           : std_logic_vector(15 downto 0) := (others => '0');
  constant ALL_ZEROS_32           : std_logic_vector(15 downto 0) := (others => '0');
begin

  -- DFFs for input ADC samples
  IADC_PROC : process(i_clock)
  begin
    s_arr_adc_data <= i_adc_data;
  end process IADC_PROC;
  --

  -- Calculate running sums
  SUM_GEN : for nSum in 1 to N_ADC generate
    process(i_clock)
      variable v_adc1 : t_adc_sum_data  := (others => '0');
      variable v_adc2 : t_adc_sum_data  := (others => '0');

      variable v_i1 : integer := nSum;
      variable v_i2 : integer := func_chan_plus_x(nSum, 1);
    begin
      if rising_edge(i_clock) then
        
        if s_adc_mask(v_i1 - 1) = '1' then
          v_adc1 := '0' & s_arr_adc_data(v_i1);
        else 
          v_adc1 := (others => '0');
        end if;

        if s_adc_mask(v_i2 - 1) = '1' then
          v_adc2 := '0' & s_arr_adc_data(v_i2);
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
      s_discr_expand    <= i_discr_expand;
      s_coi_thresholds  <= i_coi_thresholds;
      s_nevt            <= i_nevt;
    end if;
  end process;
  --
  
  



  --- generate coincidence logic for all ADC channels -------------------
  ADC_GEN : for nADC in 1 to N_ADC generate

    -- discriminator for quality signals
    DU_Q : entity work.discriminator
    port map(
      i_clock     => i_clock , 
      i_reset     => i_reset,
      i_enable    => s_adc_mask(nADC-1),    -- on/off 
      i_threshold => s_adc_qthresholds(nADC-1)(ADC_BIT_WIDTH-1 downto 0), 
      i_texp      => s_discr_expand,        -- duration of the output signal
      i_input     => s_arr_adc_data(nADC),  -- input signal 
      o_texp      => open,                  -- output signal with fixed duration
      o_gate      => s_vec_discr_q(nADC-1)  -- gate signal for the peak detector
    );

    -- discriminators for coincidence signals
    DU : entity work.discriminator
    port map(
      i_clock     => i_clock , 
      i_reset     => i_reset,
      i_enable    => s_adc_mask(nADC-1),     -- on/off 
      i_threshold => s_adc_thresholds(nADC-1)(ADC_BIT_WIDTH-1 downto 0), 
      i_texp      => s_discr_expand,         -- duration of the output signal
      i_input     => s_arr_adc_data(nADC),   -- input signal 
      o_texp      => s_vec_texp(nADC-1),     -- output signal with fixed duration
      o_gate      => s_vec_gate(nADC-1)      -- gate signal for the peak detector
    );

    -- discriminator for running sum signals
    DU_SUM : entity work.discriminator
    port map(
      i_clock     => i_clock , 
      i_reset     => i_reset,
      i_enable    => '1',    -- on/off (already masked while calculating sums)
      i_threshold => s_adc_sum_thresholds(nADC-1)(ADC_BIT_WIDTH-1 downto 0), 
      i_texp      => s_discr_expand,         -- duration of the output signal
      i_input     => s_arr_adc_sums(nADC),   -- input signal 
      o_texp      => s_vec_texp_sum(nADC-1), -- output signal with fixed duration
      o_gate      => s_vec_gate_sum(nADC-1)   -- gate signal for the peak detector
    );
    
    process(i_clock)
    begin
      if rising_edge(i_clock) then
        if i_reset = '1' then 
          s_vec_adc_hit(nADC-1)  <= '0';
          s_vec_texp_pre(nADC-1) <= '0';
        else
          s_vec_texp_pre(nADC-1) <= s_vec_texp(nADC-1);
          if s_vec_texp_pre(nADC-1) = '0' and s_vec_texp(nADC-1) = '1' then
            s_vec_adc_hit(nADC-1) <= '1';
          else
            s_vec_adc_hit(nADC-1) <= '0';
          end if;
        end if;
      end if;
    end process;


    -- determine maximum of the signal inside a gate provided by discriminator component
    AU  : entity work.amplitude
    port map (i_clock, i_reset, s_vec_gate(nADC-1), s_arr_adc_data(nADC), s_vec_hist_wena(nADC-1), s_arr_ampl(nADC));

  end generate ADC_GEN;
  ----------------------------------------------------------------------------
    
  CU_GEN : for nCOI in 1 to 16 generate
    CU  : entity work.coincidence 
    port map (
      i_clock            =>   i_clock, 
      i_reset            =>   i_reset,
      i_run              =>   i_hrun_ext,  -- TODO: separate from i_hrun_ext
      i_coidur_thresh    =>   s_coi_thresholds(nCOI-1), -- TODO remove
      i_data_1           =>   s_vec_texp(nCOI-1),
      i_data_2           =>   s_vec_texp(func_chan_plus_x(nCOI,1)-1), 
      o_coidur           =>   s_arr_coidur(nCOI),      -- TODO remove
      o_coidur_we        =>   s_vec_coidur_we(nCOI-1),
      o_coidur_overflow  =>   s_vec_coidur_overflow(nCOI-1), 
      o_coin             =>   s_vec_coin(nCOI-1),       -- single clock coincidence signal
      o_coin_thr         =>   s_vec_coin_thr(nCOI-1)    -- TODO remove
    );
  end generate CU_GEN;

  s_texp_or <= func_vect_or(s_vec_texp);
  
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_texp_or_meta <= s_texp_or;
      s_texp_or_pre  <= s_texp_or_meta;

      if s_texp_or_pre = '0' and s_texp_or_meta = '1' then
        s_adc_hit_or <= '1';
      else
        s_adc_hit_or <= '0';
      end if;
    end if;
  end process;

  ----- TEMPORARY --------------------------------------
  -- TODO: remove
  process(i_clock) 
  begin
    if rising_edge(i_clock) then
      if s_vec_coidur_we /= X"0000_0000" then
        o_arr_coidur <= s_arr_coidur;
      end if;
    end if;
  end process;
  ----- TEMPORARY --------------------------------------


  ----- HISTOGRAM MANAGER -------------------------------
  HM : entity work.histo_manager 
  port map (
    i_clock              =>   i_clock,
    i_reset              =>   i_reset,

    i_hrun               =>   s_hrun,         -- run(1)/stop(0) filling histograms
    i_hclear             =>   i_hclear,       -- clear histograms content
                             
    i_htest_mode         =>   i_htest_mode,   -- mode: normal(0)/test(1)

    i_vec_hist_wena      =>   s_vec_hist_wena, -- write enable for amplitude histograms
    i_arr_adc_ampl       =>   s_arr_ampl,      -- input amplitudes
                             
    i_vec_coidur_wena    =>   s_vec_coidur_we, -- TODO remove
    i_arr_coidur         =>   s_arr_coidur,    -- TODO remove

    i_hist_index         =>   i_hread_index,   -- input histogram index
    i_hbin_addr          =>   i_hread_addr,    -- input bin index

    o_hbin_data          =>   s_hread_data,    -- output bin value

    o_vec_ahist_overflow =>   s_vec_hist_overflow,
    o_vec_chist_overflow =>   s_vec_coihist_overflow
  );

  s_hread_addr <= i_hread_addr;
  o_hread_data <= s_hread_data;
  -------------------------------------------------------

  ----- COUNTERS MANAGER --------------------------------
  CM : entity work.counters_manager
  port map (
    i_clock        => i_clock,
    i_reset        => i_reset,

    i_clear        => i_cclear,
    i_cnt_run      => s_crun,

    i_vec_adc_hit  => s_vec_adc_hit,
    i_vec_coi_hit  => s_vec_coidur_we, -- no difference for now TODO
    i_vec_dur_hit  => s_vec_coidur_we, -- no difference for now TODO
    i_evt_hit      => s_adc_hit_or, -- TODO
    i_bhabha_hit   => s_Bhabha,
    i_dead_time    => s_DeadTime,
                  
    o_adc_cnt      => s_adc_cnt,
    o_coi_cnt      => s_coi_cnt,
    o_dur_cnt      => s_dur_cnt,
    o_evt_cnt      => s_evt_cnt,
    o_bha_cnt      => s_Bhabha_CNT,
    o_clk_cnt      => s_CLK_GCNT,
    o_ded_cnt      => s_DT_GCNT,
    
    o_cnt_overflow => s_cnt_overflow

  );
  -------------------------------------------------------

  -- redirect counters to output
  o_adc_cnt      <= s_adc_cnt;
  o_coi_cnt      <= s_coi_cnt;
  o_dur_cnt      <= s_dur_cnt;
  o_evt_cnt      <= s_evt_cnt;
                
  o_clk_cnt      <= s_CLK_GCNT;
  o_bha_cnt      <= s_Bhabha_CNT;
  o_ded_cnt      <= s_DT_GCNT;
  o_cnt_overflow <= s_cnt_overflow;
  --
  
  -------------------------------------------------------
  -- STOP PROCESSES WHEN NEVT EVENTS ARE ACCUMULATED
  -------------------------------------------------------
  RUN_PROC: process(i_clock)
  begin
    if rising_edge(i_clock) then
      if s_evt_cnt < s_nevt then
        s_hrun <= i_hrun_ext;
        s_crun <= i_crun_ext;
      else
        s_crun <= '0';
        s_hrun <= '0';
      end if;
    end if;
  end process RUN_PROC;
  --s_hrun <= i_hrun_ext and s_hrun_int; 
  --s_crun <= i_crun_ext and s_crun_int;
  -------------------------------------------------------


  -- Redirect status to output
  s_lom_stat(0) <= s_hrun;
  s_lom_stat(1) <= s_crun;
  --- .... TODO
  o_lom_stat    <= s_lom_stat;
  --

  -------------------------------------------------------
  -- MANAGE OVERFLOW FLAGS (simply bitwise OR at this time)
  -------------------------------------------------------
  OVERPROC : process(i_clock)
  begin 
    
    if rising_edge(i_clock) then
      
      o_hist_overflow <= '0';
      if s_vec_coihist_overflow /= ALL_ZEROS_16 then
        o_hist_overflow <= '1';
      end if;
      if s_vec_hist_overflow /= ALL_ZEROS_32 then
        o_hist_overflow <= '1';
      end if;

    end if;

  end process OVERPROC;
  -------------------------------------------------------

  -- generate bhabha quality signals (bhabha pattern)
  QUA_PROC : process(i_clock)
  begin
    if rising_edge(i_clock) then
      --B"0000_0000_0000_0000"
      if s_vec_discr_q(15 downto 0)  = B"0000000000000011" or
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
        
        s_QualityFWD <= '1';
      else 
        s_QualityFWD <= '0';
      end if;

      if s_vec_discr_q(31 downto 16) = B"0000000000000011" or
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
        s_QualityBWD <= '1';
      else 
        s_QualityBWD <= '0';
      end if;

    end if;
  end process QUA_PROC;

  s_Quality <= s_QualityFWD and s_QualityFWD;
  
  -------------------------------------------------------
  -- Generate BhaBha signal
  -------------------------------------------------------
  s_DeadTimeMAX <= i_dead_time_max;
  BHABHA : process(i_clock)
  begin
    
    if rising_edge(i_clock) then
      s_DeadTime       <= '0';
      s_Bhabha         <= '0';

      if s_vec_coin /= X"0000" and s_DeadTime = '0' and s_Quality = '1'  then
        s_Bhabha       <= '1';
        s_DeadTime     <= '1';
        s_DeadTimeCNT  <= (others => '0');
      end if;
      
      if s_DeadTime = '1' and s_DeadTimeCNT < s_DeadTimeMAX then
         s_DeadTime    <= '1';
         s_DeadTimeCNT <= s_DeadTimeCNT + '1';
      end if;
      
      if s_DeadTimeCNT = s_DeadTimeMAX then
        s_DeadTimeCNT  <= (others => '0');
        s_DeadTime     <= '0';
      end if;
    
    end if;

  end process BHABHA;
  -------------------------------------------------------


end lom_arch;
------------------------------------------




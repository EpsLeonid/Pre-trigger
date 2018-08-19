library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

--entity adc_deser_8ch_12bits is
--port(
	--clock : in std_logic;
	
	--bitslip_reset : in std_logic;

	--clock_adc : out std_logic;

	--o_data    : out stdlv_array_8x12_t;

	--data_we : out std_logic;
	
	---- PINS
	--SDATAP : in std_logic_vector(8 downto 1);
	--SDATAN : in std_logic_vector(8 downto 1);

	--DCOP : in std_logic;
	--DCON : in std_logic;
	
	--FCOP : in std_logic;
	--FCON : in std_logic);

--end adc_deser_8ch_12bits;

architecture xapp of adc_deser_8ch_12bits is
  type    t_qarray  is array (integer range <>) of std_logic_vector(3 downto 0);

	-- clock signals
	signal gclk        : std_logic                     := '0';
	signal rx_clk_in_p : std_logic                     := '0';
	signal rx_clk_in_n : std_logic                     := '0';
	signal clk_ddly_m  : std_logic                     := '0';
	signal clk_ddly_s  : std_logic                     := '0';
	signal rxioclkp    : std_logic                     := '0';
	signal rxioclkn    : std_logic                     := '0';
                                                    
  signal rx_serdesstrobe     : std_logic := '0';    
                                                    
  -- divided clocks                                 
  -- to bufg                                        
  signal rx_bufio2_div4 : std_logic                  := '0';
  -- to fabric                                      
  signal rx_bufg_div4 : std_logic                    := '0';

	-- data signals
	signal rx_data_in  : std_logic_vector(8 downto 0)  := (others => '0');              -- input data from ibufgds
	signal ddly_m      : std_logic_vector(8 downto 0)  := (others => '0');              -- delayed data for iserdes2
	signal mdata       : t_qarray(1 to 9)              := (others => (others => '0') ); -- data from iserdes2
	signal s_data      : t_adc_data_8_array            := (others => (others => '0') ); -- data after additional deserialization
	signal s_data_dr  : t_adc_data_8_array            := (others => (others => '0') ); -- data after additional deserialization
	signal s_data_ddr : t_adc_data_8_array            := (others => (others => '0') ); -- data after additional deserialization
	signal s_frame     : std_logic_vector(11 downto 0) := (others => '0');              -- deserialized frame
	signal q_frame     : std_logic_vector(3 downto 0)  := (others => '0');              -- frame from iserdes2
  signal bitslip_cnt : std_logic_vector(1 downto 0)  := (others => '0');              -- counter for bitslip signal

  signal s_frame_start : std_logic := '0';

  signal bitslip     : std_logic := '0';

	-- delay calibration TODO
	signal busy        : std_logic_vector(8 downto 0)  := (others => '0');
	signal cal_data    : std_logic_vector(8 downto 0)  := (others => '0');
	signal cal_done    : std_logic := '0';
  signal cal_ena     : std_logic := '0';
	signal cal_prog    : std_logic := '0';
	signal del_rst     : std_logic_vector(8 downto 0)  := (others => '0');

  -- write enable for adc buffer
	signal s_data_we   : std_logic := '0';
	
  -- for bad channel
	signal adc_data_bad      : t_adc_data := (others=>'0');
	signal buf_dco_ioclkp    : std_logic := '0';
	signal buf_dco_ioclkn    : std_logic := '0';
  signal dco_ioclkn_div1   : std_logic;
  signal dco_ioclkp_div1   : std_logic;
  signal fco_ioclkp_div1   : std_logic;
  signal buf_fco_ioclkp    : std_logic;
  signal clkfb : std_logic;
  signal locked : std_logic;
  signal frfr   : std_logic; -- without frfr signal PLL doesn't work
  signal s_data_we_bad     : std_logic := '0';


begin
	
	

	-- receive i/o clock
	iob_clk_in : IBUFDS_DIFF_OUT generic map(
		DIFF_TERM       => TRUE)
	port map (
		I               => DCOP,
		IB              => DCON,
		O               => rx_clk_in_p,
		OB              => rx_clk_in_n) ;

	iodelay_m : IODELAY2 generic map(
		DATA_RATE           => "SDR",           -- <SDR>, DDR
		SIM_TAPDELAY_VALUE  => 49,              -- nominal tap delay (sim parameter only)
		IDELAY_VALUE        => 0,               -- {0 ... 255}
		IDELAY2_VALUE       => 0,               -- {0 ... 255}
		ODELAY_VALUE        => 0,               -- {0 ... 255}
		IDELAY_MODE         => "NORMAL",        -- "NORMAL", "PCI"
		SERDES_MODE         => "MASTER",        -- <NONE>, MASTER, SLAVE
		IDELAY_TYPE         => "FIXED",         -- "DEFAULT", "DIFF_PHASE_DETECTOR", "FIXED", "VARIABLE_FROM_HALF_MAX", "VARIABLE_FROM_ZERO"
		COUNTER_WRAPAROUND  => "STAY_AT_LIMIT",     -- <STAY_AT_LIMIT>, WRAPAROUND
		DELAY_SRC           => "IDATAIN")       -- "IO", "IDATAIN", "ODATAIN"
	port map (
		IDATAIN         => rx_clk_in_p,     -- data from master IOB
		TOUT            => open,            -- tri-state signal to IOB
		DOUT            => open,            -- output data to IOB
		T               => '1',             -- tri-state control from OLOGIC/OSERDES2
		ODATAIN         => '0',             -- data from OLOGIC/OSERDES2
		DATAOUT         => clk_ddly_m,      -- Output data 1 to ILOGIC/ISERDES2
		DATAOUT2        => open,            -- Output data 2 to ILOGIC/ISERDES2
		IOCLK0          => '0',             -- High speed clock for calibration
		IOCLK1          => '0',             -- High speed clock for calibration
		CLK             => '0',             -- Fabric clock (GCLK) for control signals
		CAL             => '0',             -- Calibrate enable signal
		INC             => '0',             -- Increment counter
		CE              => '0',             -- Clock Enable
		RST             => '0',             -- Reset delay line to 1/2 max in this case
		BUSY            => open) ;          -- output signal indicating sync circuit has finished / calibration has finished


	iodelay_s : IODELAY2 generic map(
		DATA_RATE           => "SDR",               -- <SDR>, DDR
		SIM_TAPDELAY_VALUE  => 49,                  -- nominal tap delay (sim parameter only)
		IDELAY_VALUE        => 0,                   -- {0 ... 255}
		IDELAY2_VALUE       => 0,                   -- {0 ... 255}
		ODELAY_VALUE        => 0,                   -- {0 ... 255}
		IDELAY_MODE         => "NORMAL",            -- "NORMAL", "PCI"
		SERDES_MODE         => "SLAVE",             -- <NONE>, MASTER, SLAVE
		IDELAY_TYPE         => "FIXED",             -- "DEFAULT", "DIFF_PHASE_DETECTOR", "FIXED", "VARIABLE_FROM_HALF_MAX", "VARIABLE_FROM_ZERO"
		COUNTER_WRAPAROUND  => "STAY_AT_LIMIT",     -- <STAY_AT_LIMIT>, WRAPAROUND
		DELAY_SRC           => "IDATAIN")           -- "IO", "IDATAIN", "ODATAIN"
	port map (
		IDATAIN         => rx_clk_in_n,     -- data from slave IOB
		TOUT            => open,            -- tri-state signal to IOB
		DOUT            => open,            -- output data to IOB
		T               => '1',             -- tri-state control from OLOGIC/OSERDES2
		ODATAIN         => '0',             -- data from OLOGIC/OSERDES2
		DATAOUT         => clk_ddly_s,      -- Output data 1 to ILOGIC/ISERDES2
		DATAOUT2        => open,            -- Output data 2 to ILOGIC/ISERDES2
		IOCLK0          => '0',             -- High speed clock for calibration
		IOCLK1          => '0',             -- High speed clock for calibration
		CLK             => '0',             -- Fabric clock (GCLK) for control signals
		CAL             => '0',             -- Calibrate control signal, never needed as the slave supplies the clock input to the PLL
		INC             => '0',             -- Increment counter
		CE              => '0',             -- Clock Enable
		RST             => '0',             -- Reset delay line
		BUSY            => open) ;          -- output signal indicating sync circuit has finished / calibration has finished

	bufio2_2clk_inst : BUFIO2_2CLK generic map(
		  DIVIDE        => 4)               -- The DIVCLK divider divide-by value; default 1
	port map (
		  I             => clk_ddly_m,      -- Input source clock 0 degrees
		  IB            => clk_ddly_s,      -- Input source clock 0 degrees
		  IOCLK         => rxioclkp,        -- Output Clock for IO
		  DIVCLK        => rx_bufio2_div4,  -- Output Divided Clock
		  SERDESSTROBE  => rx_serdesstrobe);-- Output SERDES strobe (Clock Enable)		  


	bufg_pll_x1 : BUFG port map (I => rx_bufio2_div4, O => rx_bufg_div4) ;

	gclk <= rx_bufg_div4;

	bufio2_inst : BUFIO2 generic map(
		  I_INVERT          => FALSE,       
		  DIVIDE_BYPASS     => FALSE,       
		  USE_DOUBLER       => FALSE)       
	port map (
		  I                 => clk_ddly_s,  -- N_clk input from IDELAY
		  IOCLK             => rxioclkn,    -- Output Clock
		  DIVCLK            => open,        -- Output Divided Clock
		  SERDESSTROBE      => open) ;      -- Output SERDES strobe (Clock Enable)
		  

	---------------------------------------------------------------------------------------------


	-- data deserializers -----------------------------------------------------------------------
	ADC_CHAN : for i_CH in 1 to 9 generate -- i_CH = 9 for frame 
		
		-- input buffer
		IF_ADC : if i_CH < 9 generate      -- adc data
			iob_data_in : IBUFGDS generic map(
				DIFF_TERM       => TRUE)
			port map (
				I               => SDATAP(i_CH),
				IB              => SDATAN(i_CH),
				O               => rx_data_in(i_CH-1));
		end generate;

		IF_FCO : if i_CH = 9 generate      -- frame signal
			iob_data_in : IBUFGDS generic map(
				DIFF_TERM       => TRUE)
			port map (
				I               => FCOP,
				IB              => FCON,
				O               => rx_data_in(i_CH-1));
		end generate;

    GOOD_CHANNEL : if SIMPLE_DESER_CHAN /= (ADCNUM-1)*8+i_CH generate

      -- delay
      iodelay_m : IODELAY2 generic map(
        DATA_RATE           => "DDR",           -- SDR, DDR
        IDELAY_VALUE        => 0,               -- {0 ... 255}
        IDELAY2_VALUE       => 0,               -- {0 ... 255}
        IDELAY_MODE         => "NORMAL" ,       -- NORMAL, PCI
        ODELAY_VALUE        => 0,               -- {0 ... 255}
        IDELAY_TYPE         => "VARIABLE_FROM_HALF_MAX",-- "DEFAULT", "DIFF_PHASE_DETECTOR", 
                                                        -- "FIXED", "VARIABLE_FROM_HALF_MAX", 
                                -- "VARIABLE_FROM_ZERO"
        COUNTER_WRAPAROUND  => "WRAPAROUND",    -- <STAY_AT_LIMIT>, WRAPAROUND
        DELAY_SRC           => "IDATAIN",       -- "IO", "IDATAIN", "ODATAIN"
        SERDES_MODE         => "NONE",          -- <NONE>, MASTER, SLAVE
        SIM_TAPDELAY_VALUE  => 49)              -- for simulation
      port map (
        IDATAIN         => rx_data_in(i_CH-1),  -- data from primary IOB
        TOUT            => open,                -- tri-state signal to IOB
        DOUT            => open,                -- output data to IOB
        T               => '1',                 -- tri-state control from OLOGIC/OSERDES2
        ODATAIN         => '0',                 -- data from OLOGIC/OSERDES2
        DATAOUT         => ddly_m(i_CH-1),      -- Output data 1 to ILOGIC/ISERDES2
        DATAOUT2        => open,                -- Output data 2 to ILOGIC/ISERDES2
        IOCLK0          => rxioclkp,            -- High speed clock for calibration
        IOCLK1          => rxioclkn,            -- High speed clock for calibration
        CLK             => gclk,                -- Fabric clock (GCLK) for control signals
        CAL             => cal_data(i_CH-1),    -- Calibrate control signal
        INC             => '0',                 -- Increment counter
        CE              => '0',                 -- Clock Enable
        RST             => del_rst(i_CH-1),     -- Reset delay line
        BUSY            => busy(i_CH-1)) ;      -- output signal indicating sync circuit 
                                                -- has finished / calibration has finished
      
      -- deserialization 1:4
      iserdes_m : ISERDES2 generic map (
        DATA_WIDTH          => 4,           -- SERDES word width.  This should match the setting is BUFPLL
        DATA_RATE           => "DDR",       -- <SDR>, DDR
        BITSLIP_ENABLE      => TRUE,        -- <FALSE>, TRUE
        SERDES_MODE         => "NONE",      -- <NONE>, MASTER, SLAVE
        INTERFACE_TYPE      => "RETIMED")   -- NETWORKING, NETWORKING_PIPELINED, <RETIMED>
      port map (
        D               => ddly_m(i_CH-1), -- delayed data
        CE0             => '1',
        CLK0            => rxioclkp,        
        CLK1            => rxioclkn,        
        IOCE            => rx_serdesstrobe,   
        RST             => reset,
        CLKDIV          => gclk,
        SHIFTIN         => '0',
        BITSLIP         => bitslip,
        FABRICOUT       => open,
        Q4              => mdata(i_CH)(0),
        Q3              => mdata(i_CH)(1),
        Q2              => mdata(i_CH)(2),
        Q1              => mdata(i_CH)(3),
        DFB             => open,
        CFB0            => open,
        CFB1            => open,
        VALID           => open,
        INCDEC          => open,
        SHIFTOUT        => open);


    end generate GOOD_CHANNEL;

    GOOD_NOT_FRAME : if SIMPLE_DESER_CHAN /= (ADCNUM-1)*8+i_CH and i_CH /= 9 generate
      process(gclk)
      begin
        if rising_edge(gclk) then
          s_data_dr(i_CH) <= s_data(i_CH);
          if s_frame_start = '1' then
            o_data(i_CH) <= s_data_dr(i_CH);
          end if;
        end if;
      end process;
    end generate GOOD_NOT_FRAME;
		


    BAD_CHANNEL : if SIMPLE_DESER_CHAN = (ADCNUM-1)*8+i_CH and i_CH /= 9 generate

      PLL_BASE_inst : PLL_BASE
       generic map (
          BANDWIDTH => "OPTIMIZED",             -- "HIGH", "LOW" or "OPTIMIZED" 
          CLKFBOUT_MULT => 16,                   -- Multiply value for all CLKOUT clock outputs (1-64)
          CLKFBOUT_PHASE => 0.0,                -- Phase offset in degrees of the clock feedback output
                                                -- (0.0-360.0).
          CLKIN_PERIOD => 5.552,                  -- Input clock period in ns to ps resolution (i.e. 33.333 is 30
                                                -- MHz).
          -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for CLKOUT# clock output (1-128)
          CLKOUT0_DIVIDE => 4,
          CLKOUT1_DIVIDE => 4,
          CLKOUT2_DIVIDE => 13,
          -- CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for CLKOUT# clock output (0.01-0.99).
          CLKOUT0_DUTY_CYCLE => 0.5,
          CLKOUT1_DUTY_CYCLE => 0.5,
          CLKOUT2_DUTY_CYCLE => 0.5,
          -- CLKOUT0_PHASE - CLKOUT5_PHASE: Output phase relationship for CLKOUT# clock output (-360.0-360.0).
          CLKOUT0_PHASE => 0.0,
          CLKOUT1_PHASE => 180.0,
          CLK_FEEDBACK => "CLKFBOUT",           -- Clock source to drive CLKFBIN ("CLKFBOUT" or "CLKOUT0")
          COMPENSATION => "SYSTEM_SYNCHRONOUS", -- "SYSTEM_SYNCHRONOUS", "SOURCE_SYNCHRONOUS", "EXTERNAL" 
          DIVCLK_DIVIDE => 4,                   -- Division value for all output clocks (1-52)
          REF_JITTER => 0.1,                    -- Reference Clock Jitter in UI (0.000-0.999).
          RESET_ON_LOSS_OF_LOCK => FALSE        -- Must be set to FALSE
       )
       port map (
          CLKFBOUT => clkfb, -- 1-bit output: PLL_BASE feedback output
          -- CLKOUT0 - CLKOUT5: 1-bit (each) output: Clock outputs
          CLKOUT0 => dco_ioclkp_div1,
          CLKOUT1 => dco_ioclkn_div1,
          CLKOUT2 => frfr,
          LOCKED => locked,     -- 1-bit output: PLL_BASE lock status output
          CLKFBIN => clkfb,   -- 1-bit input: Feedback clock input
          CLKIN => rx_clk_in_p,       -- 1-bit input: Clock input
          RST => reset           -- 1-bit input: Reset input
       );

      dco_bufbufgp : BUFG
      port map(
        I => dco_ioclkp_div1,
        O => buf_dco_ioclkp);


      dco_bufbufgn : BUFG
      port map(
        I => dco_ioclkn_div1,
        O => buf_dco_ioclkn);


      SIMPLEDES : entity work.simple_deser
      port map (
        dco_ib_p   => buf_dco_ioclkp,
        dco_ib_n   => buf_dco_ioclkn,
        framestart => s_frame_start,
        clock_adc  => gclk,
        reset      => reset,
        shift      => shift, 
        rx_data_in => rx_data_in(i_CH-1), 
        o_data     => adc_data_bad,
        data_we    => s_data_we_bad
        --SDATAP     => SDATAP(iADC),
        --SDATAN     => SDATAN(iADC)
      );

      --process(gclk)
      --begin
        --if rising_edge(gclk) then
          --adc_data_r(i_CH) <= adc_data_r(i_CH);
          --if frame_start_r = '1' then
            --adc_data_r(iADC) <= adc_data_bad;
          --end if;
        --end if;
      --end process;
      process(gclk)
      begin
        if rising_edge(gclk) then
          s_data_dr(i_CH)  <= adc_data_bad;
          s_data_ddr(i_CH) <= s_data_dr(i_CH);
          if s_frame_start = '1' then
            o_data(i_CH) <= s_data_ddr(i_CH);
          end if;
        end if;
      end process;

    end generate BAD_CHANNEL;




	
	end generate ADC_CHAN;
	--------------------------------------------------------------------------------------

	--- additional 1 to 3 deserialization ------
  --for adc data
  ADC_1_3_GEN: for i_CH in 1 to 8 generate
    process(gclk)
    begin
      if rising_edge(gclk) then
        s_data(i_CH) <= s_data(i_CH)(7 downto 0) & mdata(i_CH);
      end if;
    end process;
  end generate ADC_1_3_GEN;

  -- for frame clock
  process(gclk)
  begin
    if rising_edge(gclk) then
      s_frame <= s_frame(7 downto 0) & mdata(9);
    end if;
  end process;
	--------------------------------------------

  
  --------------------------------------------
  -- generate bitslip and write enable signals
  --------------------------------------------
  process(gclk)
  begin
    if rising_edge(gclk) then

      bitslip <= '0';
      bitslip_cnt <= bitslip_cnt + '1';

      if mdata(9) /= X"F" and mdata(9) /= X"C" and mdata(9) /= X"0" and bitslip_cnt = B"11" then
        bitslip <= '1';
        bitslip_cnt <= B"00";
      end if;

      if s_frame = X"FC0" then
        bitslip_cnt <= B"00";
      end if;

    end if;
  end process;

  process(gclk)
  begin
    if rising_edge(gclk) then
      s_frame_start <= '0';
      if mdata(9) = X"F" then
        s_frame_start <= '1';
      end if;
    end if;
  end process;

  process(gclk)
  begin
    if rising_edge(gclk) then
      s_data_we <= '0';
      if s_frame_start = '1' then
        s_data_we <= '1';
      end if;
    end if;
  end process;

  o_clock_adc <= gclk;
  o_data_we   <= s_data_we;
	---------------------------------------
  

	-- calibration ------------------------
  -- doesn't have sense without phase detector 
  -- TODO: add phase detector later
	process(gclk)
	begin
		if rising_edge(gclk) then
			cal_data <= (others => '0');
      del_rst  <= (others => '0');
			if cal_done = '0' and cal_ena = '1' then 
				cal_data <= (others => '1');
				cal_prog <= '1';
			end if;
			if cal_prog = '1' then
        if busy = B"000000000" then
          cal_prog <= '0';
          del_rst <= (others => '1');
          cal_done <= '1';  
        end if;
			end if;
      
      if bitslip_reset = '1' then
        cal_done <= '0';
      end if;

		end if;
	end process;
	------------------------------------


end xapp;






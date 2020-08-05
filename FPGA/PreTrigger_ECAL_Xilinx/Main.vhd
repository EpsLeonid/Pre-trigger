----------------------------------------------------------------------------------
-- Company: BINP
-- Engineer: Epshteyn Leonid
-- 
-- Create Date:    15:06:18 04/06/2018 
-- Project Name: 	 Pre-trigger
-- Module Name:    Main
-- Target Devices: 
-- Tool versions: v.1
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.parameters.all;

entity Main is

port(
-- 1. Clocks
	Qclock		: in std_logic; -- system clock
	FCT_40		: in std_logic; -- system clock
	FCT_160		: in std_logic; -- clock
	FCT_160_n	: in std_logic; -- clock
-- In Trigger module FCT's Clock is checked inside Altera but switched outside 
	Sw_Quartz	: out std_logic;	-- connects Quartz to PLL ref.Input			-> Pin 
	Sw_FCTClk	: out std_logic;	-- connects Link's Clock to PLL ref.Input	-> Pin 

	MuxClock_in		: in std_logic;	-- Ref.clock for PLL (dedicated)			<- Pin 

-- Outputs for Indicators on LED's

	Led1			: out std_logic;	-- drives the Green LED								-> Pin 
	Led2			: out std_logic := '0';	-- drives the Blue LED						-> Pin 
	Led3			: out std_logic := '0';	-- drives the Red LED						-> Pin 
	Led4			: out std_logic := '0';	-- drives the Blue(Yellow) LED			-> Pin 
	Led5			: out std_logic := '0';	-- drives the Blue(Yellow) LED			-> Pin 

-- 2. Channel  

	ADCInDataLVDS		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDS_n	: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev_n: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCOutDataLVDSNext: out std_logic_vector(NUM_TrigCellNext-1 downto 0);	-- output of data from ADC	<- Pin 
	ADCOutDataLVDSNext_n: out std_logic_vector(NUM_TrigCellNext-1 downto 0);	-- output of data from ADC	<- Pin 

	ADC_CLK				: out std_logic;	-- Pin 
	ADC_DCO_LVDS		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_DCO_LVDS_n		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_FCO				: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_FCO_LVDSPrev	: in std_logic;	-- 
	ADC_FCO_LVDSPrev_n: in std_logic;	-- 
	ADC_FCO_LVDSNext	: out std_logic;	-- 
	ADC_FCO_LVDSNext_n: out std_logic;	-- 

--	ADC_test				: in std_logic;
--	ADC_res				: in std_logic;
	ADC_CSB				: out std_logic := '1';	-- Pin 
	ADC_SDIO				: out std_logic := '0';	-- Pin 
	ADC_SCLK				: out std_logic := '0';	-- Pin 

-- 3. Trig_in-out_FCT

	TrigInLVDS		: in std_logic;	-- Trigger from FC7					<- Pin 
	TrigInLVDS_n	: in std_logic;	-- 										<- Pin 
	FastTrigDes		: out std_logic;	-- Fast trigger desition to EROS/ROESTI	<- Pin
	TrigDes			: out std_logic;	-- Trigger desition to FC7			<- Pin
	TriggerData		: out std_logic_vector(TrigBits-1 downto 0):= (others => '0');	-- Trigger data to FCT

-- 4. Ethernet Phy device ports     LXT972
	RxClk			: in std_logic; --					-> Pin
	Crs			: in std_logic;-- Carrier Sense
	RxDv			: in std_logic;-- Data Valid
	RxD			: in std_logic_vector(3 downto 0); 
--RxEr			: input; -- RxEr not in use!!!! pin...-corner

	TxClk			: in std_logic; --					-> Pin
	TxEn			: out std_logic; --					-> Pin
	TxD			: out std_logic_vector(3 downto 0):= (others => '0'); --					-> Pin
	Col 			: in std_logic; -- Collision_Detect not used	-> Pin

-- 5. 
--ExtStart		: input = GND;  -- external Start						<- Pin
	ExtReset		: in std_logic;  -- external Reset (tied to GND --VCC)	<- Pin

-- 6. Test
	Test			: out std_logic_vector(9 downto 0):= (others => '0')

	);
end Main;

architecture Behavioral of Main is

	--- clocking
	signal Quarts				: std_logic;
	signal FCT40				: std_logic;
	signal ResultClock		: std_logic;	-- Ref.clock for PLL (dedicated)
	signal Resultclock1		: std_logic;
	signal Clock_in			: std_logic;
	signal Clk40				: std_logic;
	signal CLK40_90d			: std_logic;
	signal Clk20				: std_logic;
	signal Clk80				: std_logic;
	signal Clk80_o				: std_logic;
	signal Clk160				: std_logic;
	signal Clk160_o			: std_logic;
	signal Clk320				: std_logic;
	signal FCT160				: std_logic;
	signal Phase				: std_logic;
	signal Clk_Selected		: std_logic := '1';
	signal s_clock_locked	: std_logic;
	---

	--- system
	signal PowerUp0			: std_logic;
	signal PowerUp1_s			: std_logic;
	signal PowerUp1_o			: std_logic;
	signal PowerUp2_s			: std_logic;
	signal PowerUp2_o			: std_logic;
	signal PwrUpReset			: std_logic;
	signal Reset				: std_logic;
	---
	
	--- led
	signal o_green_led		: std_logic := '1';
	signal o_blue_led			: std_logic := '1';
	signal o_red_led			: std_logic := '1';
	---

	--- ADC SPI interface signals
	signal s_fadc_test		: std_logic := '0'; 
	signal s_fadc_sdio_test	: STD_LOGIC_VECTOR(49 downto 0) := "00000000000011010000110000000000001111111100000001";
											--									  "set	addr		 data			 set	addr		  data "
											--									   3bit	 13bit	 8bit			 3bit	13bit		  8bit
	signal shift_sdio_test	: std_logic;
	
	signal s_fadc_reset		: std_logic := '0'; 
	signal s_fadc_sdio_reset: STD_LOGIC_VECTOR(49 downto 0) := "00000000000011010000000000000000001111111100000001";
	signal shift_sdio_reset	: std_logic;
	
	signal s_fadc_csb			: std_logic := '1';
	signal s_fadc_sdio		: std_logic := '0'; 
	signal s_fadc_sclk		: std_logic := '0';
	
	signal ADC_Bit_write: std_logic := '0'; 
	signal ADC_bit_count: STD_LOGIC_VECTOR(5 downto 0);
	
	signal ADCtest_reg_sset	: std_logic := '1'; 
	signal ADCtest_SDIO_trig: std_logic; 
	signal ADCreset_reg_sset	: std_logic := '1'; 
	signal ADCreset_SDIO_trig: std_logic; 
	signal ADC_CSB_trig	: std_logic := '1'; 
	---
	
	--- Input ADC data
--	signal ADC_DCO				: std_logic_vector(NUM_TrigCell/4-1 downto 0);
--	signal ADC_FCO				: std_logic_vector(NUM_TrigCell/4-1 downto 0);
--	signal ADCInData			: std_logic_vector(NUM_TrigCell-1 downto 0);
--	signal ADC_FCOPrev		: std_logic; 
--	signal ADCInDataPrev		: std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	
	signal Test_ADCdeser		: std_logic_vector (15 downto 0);
	---
	
	--- Output ADC data
	signal ADCDataNext		: array_next_adc;
	signal DataShiftNext1	: std_logic;
	signal DataShiftNext2	: std_logic;
	signal ADCOutDataNext	: std_logic_vector (ADC_Bits-1 downto 0);
	signal ADCOutDataNext_o	: std_logic_vector (ADC_Bits-1 downto 0);
	signal ADC_FCONext		: std_logic; --std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	---
	
	--- Processing data
	signal InDataReg_p		: std_logic_vector(NUM_TrigCell-1 downto 0);
	signal InDataReg_n		: std_logic_vector(NUM_TrigCell-1 downto 0);
	signal InDataReg			: array_adc;
	signal InDataPrevReg_p	: std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	signal InDataPrevReg_n	: std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	signal InDataPrevReg		: array_prev_adc;

	signal MaxAmp_o			: std_logic_vector (Sum_Bits-1 downto 0);
	signal MaxCellNumber_o  : std_logic_vector (BitNumGroup downto 0);
	signal ThrNum1_o			: std_logic_vector (3 downto 0);
	signal ThrNum2_o			: std_logic_vector (3 downto 0);
	signal ThrNum3_o			: std_logic_vector (3 downto 0);
	signal ThrNum4_o			: std_logic_vector (3 downto 0);
	signal ThrNum5_o			: std_logic_vector (3 downto 0);
	
	signal Test_FindMaxAmp	: std_logic_vector (15 downto 0);
	---
	
	--- TriggerDes
	signal TrigIn	: std_logic;
	signal TrigDes_o	: std_logic;
	signal FastTrigDes_o	: std_logic;

	--- Read/Write to/from DAQ
	signal RW				: std_logic := '0';

	--- Test
	signal TestCnt	: std_logic_vector(25 downto 0);
	signal test_out: std_logic_vector(31 downto 0);

begin

--=================Inicialization of input LVDS signals=================--
--******** 1a. POWER_UP self-Reset pulse *************************************

	process (Clk40)
	begin
		if Clk40'event and Clk40='1' then  
			PowerUp0 <= not ExtReset AND s_clock_locked;
		end if;
	end process;
	
--	PowerUp1_s <= '1' when (PowerUp0= '1' and TestCt(25) = '1' and TestCt(0) = '1') else
--					  '0';
	PowerUp1_s <= (PowerUp0 AND (TestCnt(25) and TestCnt(0)));
	PowerUp1 : entity work.SRFF 
		port map (
			S		=> PowerUp1_s,
			CLK	=> Clk40,
			R		=> ExtReset,
			q		=> PowerUp1_o
		);
	PowerUp2_s <= (PowerUp1_o AND TestCnt(2));
	PowerUp2 : entity work.SRFF 
		port map (
			S		=> PowerUp2_s,
			CLK	=> Clk40,
			R		=> ExtReset,
			q		=> PowerUp2_o
		);

	PwrUpReset <= PowerUp1_o AND not PowerUp2_o;   -- ONE pulse ~1sec after powering up

--******** 1. Reference clock's & Frequency Control ********--
--Quarts_Clk40 : IBUFG
--	generic map (
--		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE"   
--		IOSTANDARD => "DEFAULT")
--	port map (
--		O => Quarts,     -- Clock buffer output
--		I => Qclock      -- Clock buffer input
--	);

FCT_Clk40 : IBUFG
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		IOSTANDARD => "DEFAULT")
	port map (
		O => FCT40,  -- Clock buffer output
		I => FCT_40  -- Diff_p clock buffer input
	);

LVDS_FCT_160 : IBUFGDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		DIFF_TERM => TRUE, -- Differential Termination 
		IOSTANDARD => "DEFAULT")
	port map (
		O => FCT160,		-- Buffer output
		I => FCT_160,	-- Diff_p buffer input (connect directly to top-level port)
		IB => FCT_160_n	-- Diff_n buffer input (connect directly to top-level port)
	);
	

--**************** Automatic Clock Switch for PLL reference ******************

PhaseSwitch: entity work.PhaseSW 
	generic map(
				Fmax				=> 42000, -- Upper limit in kHz
				Fmin				=> 38000, -- Lower limit in kHz
				RefClock			=> 40000  -- Local Quartz Freq(kHz) used as the reference
				)
	port map ( Clock				=> Quarts,--Qclock,--
				  SysClk				=> FCT40,--FCT_40,
				  Reset				=> Reset,
				  Phase				=> Phase,
				  SysClk_Selected	=> Clk_Selected--Test(9)
				);

--	ResultClock <= ((FCT_40 and Clk_Selected) OR (Qclock and not Clk_Selected));

--Clk_Selected <= '0';

Sw_FCTClk <= Clk_Selected;
Sw_Quartz <= not Clk_Selected;

--process (Quarts)
--begin
--	if rising_edge(Quarts) then
--		if Clk_Selected = '1' then ResultClock <= FCT40;
--									 else ResultClock <= Quarts;
--		end if;
--	end if;
--end process;

--ClockSwitch : BUFGCTRL
--	generic map (
--		INIT_OUT => 0,         -- Inital value of 0 or 1 after configuration
--		PRESELECT_I0 => TRUE, -- TRUE/FALSE set the I0 input after configuration
--		PRESELECT_I1 => FALSE) -- TRUE/FALSE set the I1 input after configuration
--	port map (
--		O => ResultClock,              -- Clock MUX output
--		CE0 => '1',          -- Clock enable0 input
--		CE1 => '1',          -- Clock enable1 input
--		I0 => Quarts,            -- Clock0 input
--		I1 => FCT40,            -- Clock1 input
--		IGNORE0 => '1',  -- Ignore clock select0 input
--		IGNORE1 => '1',  -- Ignore clock select1 input
--		S0 => not ResultClock1,            -- Clock select0 input
--		S1 => ResultClock1             -- Clock select1 input
--	);

ResultClock1 <= '0';

--	ResultClock <= ((FCT40 and ResultClock1) OR (Quarts and not ResultClock1));
	ResultClock <= ((FCT40 and ResultClock1) OR (Qclock and not ResultClock1));

DLL: entity work.DLL
	port map (
		CLK0_OUT => Clk40,					-- 0 degree DCM CLK output
		CLKDV_OUT => Clk20,					-- 0 degree DCM CLK output
		CLK2X_OUT => Clk80,				-- 2X DCM CLK output
		CLK90_OUT => Clk40_90d,			-- 90 degree DCM CLK output
		CLKFX_OUT => Clk160,				-- DCM CLK synthesis out (M/D)
		LOCKED_OUT => s_clock_locked,	-- DCM LOCK status output
		CLKIN_IN => ResultClock,			-- Clock input (from IBUFG, BUFG or DCM)
--		CLKIN_IN => MuxClock_in,			-- Clock input (from IBUFG, BUFG or DCM)
		RST_IN => Reset					-- DCM asynchronous reset input
	);

--******** LED ********--
--	process(Clk80)
--	begin
--		if rising_edge(Clk80) then
--			if ((TestCnt(23)='1' and s_clock_locked = '1' and Clk_Selected = '1') or (s_clock_locked = '1' and Clk_Selected = '0')) then LED1 <= '1';
--																																											else LED1 <= '0';
--			end if;
--		end if;
--	end process;
	o_green_led <= '0' when ((TestCnt(24)='1' and s_clock_locked = '1' and Clk_Selected = '0') or (s_clock_locked = '1' and Clk_Selected = '1'))else
						'1';
	Led_B : entity work.Light_Pulser 
		generic map ( DIV	=> 1000,
						  DUR	=> 10000)
		port map( 
					 clock => CLK80,
					 i_event => FastTrigDes_o,
					 o_flash => o_blue_led
					);

--	Led_R : entity work.Light_Pulser 
--		generic map ( DIV	=> 1000,
--						  DUR	=> 10000)
--		port map( 
--					 clock => CLK80,
--					 i_event => not s_clock_locked,
--					 o_flash => o_red_led
--					);

	o_red_led <= '0' when ((s_clock_locked = '0') OR (TestCnt(24)='1' and Clk_Selected = '0')) else
					 '1';

	LED1 <= o_green_led;
	LED2 <= not o_blue_led;
	LED3 <= o_red_led;

	LED4 <= '1' when TestCnt(21)='1' else
				'0' when TestCnt(21)='0' else
				'0';
	LED5 <= '1' when TestCnt(23)='1' else
				'0' when TestCnt(23)='0' else
				'0';
--********

	adc_deser_i: entity work.adc_deser
	port map(
		Clock_i		=> Clk80,
		SDATAP		=> ADCInDataLVDS,
		SDATAN		=> ADCInDataLVDS_n,
		SDATAPrevP	=> ADCInDataLVDSPrev,
		SDATAPrevN	=> ADCInDataLVDSPrev_n,

		DCOP			=> ADC_DCO_LVDS,
		DCON			=> ADC_DCO_LVDS_n,
		FCO_i			=> ADC_FCO,
		DCOPrevP		=> ADC_FCO_LVDSPrev,
		DCOPrevN		=> ADC_FCO_LVDSPrev_n,
		
		o_adc_data	=> InDataReg,
		o_dco			=> test_out,
		o_adc_data_prev	=> InDataPrevReg
	);
	
	ADC_FCONext <= Clk80;
	ADCDataNext(0) <= InDataReg(0);
	ADCDataNext(1) <= InDataReg(1);
	ADCDataNext(2) <= InDataReg(2);
	ADCDataNext(3) <= InDataReg(3);
	ADCDataNext(4) <= InDataReg(4);
	ADCDataNext(5) <= InDataReg(5);
	ADCDataNext(6) <= InDataReg(6);
	ADCDataNext(7) <= InDataReg(7);
	ADCDataNext(8) <= InDataReg(8);
	ADCDataNext(9) <= InDataReg(9);
	ADCDataNext(10) <= InDataReg(10);
	ADCDataNext(11) <= InDataReg(11);
	
	LVDS_buf_ADCNext: for i in 0 to NUM_TrigCellNext-1 generate 
		
		ADCOutDataNext <= ADCDataNext(i);
		
		OSERDES_inst : OSERDES
		generic map (
			DATA_RATE_OQ => "DDR", -- Specify data rate to "DDR" or "SDR" 
			DATA_RATE_TQ => "DDR", -- Specify data rate to "DDR", "SDR", or "BUF" 
			DATA_WIDTH => 8, -- Specify data width - For DDR: 4,6,8, or 10 
								  -- For SDR or BUF: 2,3,4,5,6,7, or 8 
			INIT_OQ => '0',  -- INIT for Q1 register - '1' or '0' 
			INIT_TQ => '0',  -- INIT for Q2 register - '1' or '0' 
			SERDES_MODE => "MASTER", --Set SERDES mode to "MASTER" or "SLAVE" 
			SRVAL_OQ => '0', -- Define Q1 output value upon SR assertion - '1' or '0' 
			SRVAL_TQ => '0', -- Define Q1 output value upon SR assertion - '1' or '0' 
			TRISTATE_WIDTH => 4) -- Specify parallel to serial converter width 
										-- When DATA_RATE_TQ = DDR: 2 or 4 
										-- When DATA_RATE_TQ = SDR or BUF: 1 " 
		port map (
			OQ => OQ,    -- 1-bit output
			SHIFTOUT1 => '0', -- 1-bit data expansion output
			SHIFTOUT2 => '0', -- 1-bit data expansion output
			TQ => TQ,    -- 1-bit 3-state control output
			CLK => Clk320,  -- 1-bit clock input
			CLKDIV => Clk80,  -- 1-bit divided clock input
			D1 => ADCOutDataNext(2),    -- 1-bit parallel data input
			D2 => ADCOutDataNext(3),    -- 1-bit parallel data input
			D3 => ADCOutDataNext(4),    -- 1-bit parallel data input
			D4 => ADCOutDataNext(5),    -- 1-bit parallel data input
			D5 => ADCOutDataNext(6),    -- 1-bit parallel data input
			D6 => ADCOutDataNext(7),    -- 1-bit parallel data input
			OCE => '1',  -- 1-bit clcok enable input
			REV => '0',  -- Must be tied to logic zero
			SHIFTIN1 => DataShiftNext1, -- 1-bit data expansion input
			SHIFTIN2 => DataShiftNext2, -- 1-bit data expansion input
			SR => SR,   -- 1-bit set/reset input
			T1 => T1,   -- 1-bit parallel 3-state input
			T2 => T2,   -- 1-bit parallel 3-state input
			T3 => T3,   -- 1-bit parallel 3-state input
			T4 => T4,   -- 1-bit parallel 3-state input
			TCE => TCE  -- 1-bit 3-state signal clock enable input
		);
		
		OSERDES_inst : OSERDES
		generic map (
			DATA_RATE_OQ => "DDR", -- Specify data rate to "DDR" or "SDR" 
			DATA_RATE_TQ => "DDR", -- Specify data rate to "DDR", "SDR", or "BUF" 
			DATA_WIDTH => 2, -- Specify data width - For DDR: 4,6,8, or 10 
								  -- For SDR or BUF: 2,3,4,5,6,7, or 8 
			INIT_OQ => '0',  -- INIT for Q1 register - '1' or '0' 
			INIT_TQ => '0',  -- INIT for Q2 register - '1' or '0' 
			SERDES_MODE => "SLAVE", --Set SERDES mode to "MASTER" or "SLAVE" 
			SRVAL_OQ => '0', -- Define Q1 output value upon SR assertion - '1' or '0' 
			SRVAL_TQ => '0', -- Define Q1 output value upon SR assertion - '1' or '0' 
			TRISTATE_WIDTH => 4) -- Specify parallel to serial converter width 
										-- When DATA_RATE_TQ = DDR: 2 or 4 
										-- When DATA_RATE_TQ = SDR or BUF: 1 " 
		port map (
			OQ => OQ,    -- 1-bit output
			SHIFTOUT1 => DataShiftNext1, -- 1-bit data expansion output
			SHIFTOUT2 => DataShiftNext2, -- 1-bit data expansion output
			TQ => TQ,    -- 1-bit 3-state control output
			CLK => Clk320,  -- 1-bit clock input
			CLKDIV => Clk80,  -- 1-bit divided clock input
			D1 => D1,    -- 1-bit parallel data input
			D2 => D2,    -- 1-bit parallel data input
			D3 => D3,    -- 1-bit parallel data input
			D4 => D4,    -- 1-bit parallel data input
			D5 => ADCOutDataNext(1),    -- 1-bit parallel data input
			D6 => ADCOutDataNext(0),    -- 1-bit parallel data input
			OCE => '1',  -- 1-bit clcok enable input
			REV => '0',  -- Must be tied to logic zero
			SHIFTIN1 => '0', -- 1-bit data expansion input
			SHIFTIN2 => '0', -- 1-bit data expansion input
			SR => SR,   -- 1-bit set/reset input
			T1 => T1,   -- 1-bit parallel 3-state input
			T2 => T2,   -- 1-bit parallel 3-state input
			T3 => T3,   -- 1-bit parallel 3-state input
			T4 => T4,   -- 1-bit parallel 3-state input
			TCE => TCE  -- 1-bit 3-state signal clock enable input
		);
		
		OBUFDS_inst : OBUFDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			IOSTANDARD => "DEFAULT")
		port map (
			O => ADCOutDataLVDSNext(i),		-- Diff_p output (connect directly to top-level port)
			OB => ADCOutDataLVDSNext_n(i),	-- Diff_n output (connect directly to top-level port)
			I => ADCOutDataNext_o(i)				-- Buffer input 
		);
	end generate LVDS_buf_ADCNext;
	
	OBUFDS_inst : OBUFDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		IOSTANDARD => "DEFAULT")
	port map (
		O => ADC_FCO_LVDSNext,		-- Diff_p output (connect directly to top-level port)
		OB => ADC_FCO_LVDSNext_n,	-- Diff_n output (connect directly to top-level port)
		I => ADC_FCONext				-- Buffer input 
	);
	
	FindMaxAmp_i: entity work.FindMaxAmp
	port map(
		In_Data			=> InDataReg,
		In_DataPrev		=> InDataPrevReg,
		RegInit			=> '0',
		MaxAmp			=> MaxAmp_o,
		MaxCellNumber	=> MaxCellNumber_o,
		ThrNum1			=> ThrNum1_o,
		ThrNum2			=> ThrNum2_o,
		ThrNum3			=> ThrNum3_o,
		FastTrig			=> FastTrigDes_o,
		Trig				=> TrigDes_o,
	--	SaveTrigData	=> '0',

		Clock				=> CLK40,
		Clock160			=> CLK160,

		Reset				=> Reset,
	--	ResetAll			=> '0',
	--	Error				=> '0',

		test				=> Test_FindMaxAmp
	);

	ADC_CLK <= CLK80;
	TriggerData(9 downto 0)	  <= MaxAmp_o;
	TriggerData(13 downto 10) <= MaxCellNumber_o;
	TriggerData(19 downto 14) <= (others => '0');
	TriggerData(23 downto 20) <= ThrNum1_o;
	TriggerData(27 downto 24) <= ThrNum2_o;
	TriggerData(31 downto 28) <= ThrNum3_o;
	TriggerData(32)			  <= FastTrigDes_o;
	TriggerData(33)			  <= TrigDes_o;
	TriggerData(63 downto 34) <= (others => '1');
	
	FastTrigDes <= FastTrigDes_o;
	TrigDes <= TrigDes_o;

--******** TriggerIn part ********--

	LVDS_signal : IBUFDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		DIFF_TERM => TRUE, -- Differential Termination 
		IOSTANDARD => "DEFAULT")
	port map (
		O => TrigIn,		-- Buffer output
		I => TrigInLVDS,	-- Diff_p buffer input (connect directly to top-level port)
		IB => TrigInLVDS_n	-- Diff_n buffer input (connect directly to top-level port)
	);

--******** Ethernet part ********--

	TxEn					<= '1';
	TxD(3 downto 0)	<= (others => '1');

--******** ADC test part ********--

--	ADC_Ctrl : entity work.adc_ctrl_i 
--	port map (
--			Clock			=> Clk20,
--			ADC_Test		=> '1',--s_fadc_test,
--			ADC_Reset	=> s_fadc_reset,
--
--			ADC_CSB		=> s_fadc_csb,
--			ADC_SDIO		=> s_fadc_sdio,
--			ADC_SCLK		=> s_fadc_sclk
--				);

	ADCTest : entity work.V_Counter 
	generic map(
				WIDTH => 6
			)
	port map (
				clock 	=> Clk20,
				clk_en	=> ADC_Bit_write,
				sclr		=> PwrUpReset,
				q			=> ADC_bit_count
				);

	process (Clk20)
	begin
		if rising_edge(Clk20) then
			if (ADC_bit_count < "110100") Then ADC_Bit_write <= '1';
													Else ADC_Bit_write <= '0';
			end if;
			IF ((ADC_bit_count >= "000001") AND (ADC_bit_count < "110100")) Then ADCtest_reg_sset <= '0';
																										ADC_SDIO <= ADCtest_SDIO_trig;
																								 Else ADCtest_reg_sset <= '1';
																										ADC_SDIO <= '0';
			END IF;
			IF (((ADC_bit_count >= "000010") AND (ADC_bit_count < "11010")) OR ((ADC_bit_count >= "11100") AND (ADC_bit_count < "110100")))Then 
				ADC_CSB_trig <= '0';
			ELSE 
				ADC_CSB_trig <= '1';
			END IF;
		end if;
	end process;
	
--	signal s_fadc_sdio_test	: STD_LOGIC_VECTOR(49 downto 0) := "000000000000110100001100 00 000000001111111100000001";
--											--									  "set	addr		 data			 set	addr		  data "
--											--									   3bit	 13bit	 8bit			 3bit	13bit		  8bit

	ADC_CSB <= ADC_CSB_trig;
	ADC_SCLK <= Clk20;

	ShiftReg_test : entity work.ShiftReg 
		generic map (WIDTH => 50) 
		port map(clock	=> clk20,
				d		=> s_fadc_sdio_test,
				sset	=> ADCtest_reg_sset,
				q		=> ADCtest_SDIO_trig
		);

--******** Test part ********--

	CntTest : entity work.V_Counter 
	generic map(
				WIDTH => 26
			)
	port map (
				clock 	=> Quarts,--CLK40,
				clk_en	=>	'1',
				q			=> TestCnt
				);

	Test(0) <= InDataReg(0)(0);
	Test(1) <= InDataReg(0)(1);
	Test(2) <= InDataReg(0)(2);
	Test(3) <= InDataReg(0)(3);
	Test(4) <= InDataReg(0)(4);
	Test(5) <= InDataReg(0)(5);
	Test(6) <= InDataReg(0)(6);
	Test(7) <= InDataReg(0)(7);
	Test(8) <= test_out(0);
	Test(9) <= Clk80;

end Behavioral;
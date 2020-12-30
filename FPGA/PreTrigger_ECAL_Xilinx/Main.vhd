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
	Sw_Quartz	: out std_logic := '1';	-- connects Quartz to PLL ref.Input			-> Pin 
	Sw_FCTClk	: out std_logic := '0';	-- connects Link's Clock to PLL ref.Input	-> Pin 

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
	ADC_DCO_LVDSPrev	: in std_logic;	-- 
	ADC_DCO_LVDSPrev_n: in std_logic;	-- 
	ADC_FCO_LVDSPrev	: in std_logic;	-- 
	ADC_DCO_LVDSNext	: out std_logic;	-- 
	ADC_DCO_LVDSNext_n: out std_logic;	-- 
	ADC_FCO_LVDSNext	: out std_logic;	-- 

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
	signal ResultClock_sys	: std_logic;
	signal Resultclock1		: std_logic;
	signal Clock_in			: std_logic;
	signal Clk40				: std_logic;
	signal CLK40_90d			: std_logic;
	signal Clk20				: std_logic;
	signal Clk80				: std_logic;
	signal Clk80_o				: std_logic;
	signal Clk160				: std_logic;
	signal Clk160_o			: std_logic;
	signal Clk200				: std_logic;
	signal Clk320				: std_logic;
	signal FCT160				: std_logic;
	signal Phase				: std_logic;
	signal Clk_Selected		: std_logic := '1';
	signal s_clock_locked	: std_logic;
	signal sys_clock_locked	: std_logic;
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

	signal ADCDataTest		: std_logic_vector(NUM_TrigCell-1 downto 0);
	signal ADCDataTest_Ok	: std_logic;
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
	---
	
	--- Processing data
	signal InDataReg_p		: array_adc;
	signal InDataReg_n		: array_adc;
	signal InDataReg			: array_adc;
	signal InDataPrevReg_p	: array_prev_adc;
	signal InDataPrevReg_n	: array_prev_adc;
	signal InDataPrevReg		: array_prev_adc;

	signal MaxAmp_o			: std_logic_vector (Sum_Bits-1 downto 0);
	signal MaxCellNumber_o  : std_logic_vector (BitNumGroup downto 0);
	signal ThrNum1_o			: std_logic_vector (3 downto 0);
	signal ThrNum2_o			: std_logic_vector (3 downto 0);
	signal ThrNum3_o			: std_logic_vector (3 downto 0);
	signal ThrNum4_o			: std_logic_vector (3 downto 0);
	signal ThrNum5_o			: std_logic_vector (3 downto 0);
	---
	
	--- TriggerDes
	signal TrigIn	: std_logic;
	signal TrigDes_o	: std_logic;
	signal FastTrigDes_o	: std_logic;

	--- Read/Write to/from DAQ
	signal RW				: std_logic := '0';

	--- Test
	signal TestCnt				: std_logic_vector(25 downto 0);
	signal test_adc_deser	: std_logic_vector(15 downto 0);
	signal test_adc_deser_o	: std_logic_vector(15 downto 0);
	signal test_FindMaxAmp	: std_logic_vector(15 downto 0);
	signal TestNext			: std_logic_vector(7 downto 0);

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

--DLL: entity work.DLL
--	port map (
--		CLK0_OUT => Clk40,					-- 0 degree DCM CLK output
--		CLKDV_OUT => Clk20,					-- 0 degree DCM CLK output
--		CLK2X_OUT => Clk80,				-- 2X DCM CLK output
--		CLK90_OUT => Clk40_90d,			-- 90 degree DCM CLK output
--		CLKFX_OUT => Clk160,				-- DCM CLK synthesis out (M/D)
--		LOCKED_OUT => s_clock_locked,	-- DCM LOCK status output
--		CLKIN_IN => ResultClock,			-- Clock input (from IBUFG, BUFG or DCM)
----		CLKIN_IN => MuxClock_in,			-- Clock input (from IBUFG, BUFG or DCM)
--		RST_IN => Reset					-- DCM asynchronous reset input
--	);

Sys_clk: entity work.Sys_dll
	port map (
		U1_CLKIN_IN				=> ResultClock,
		U1_RST_IN				=> Reset,

		CLK90_OUT				=> Clk40_90d,
		U1_CLKDV_OUT			=> Clk20,
		U1_CLKFX_OUT			=> Clk160,
		U1_CLKIN_IBUFG_OUT	=> open,
		U1_CLK0_OUT				=> Clk40,

		U2_CLK2X_OUT			=> Clk80,
		U2_CLK2X180_OUT		=> open, 
		U2_CLKFX_OUT			=> Clk200,
		U2_CLK0_OUT				=> open,

		U2_LOCKED_OUT			=> s_clock_locked
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

	o_red_led <= '0' when (PwrUpReset = '1') else--((s_clock_locked = '1') OR (TestCnt(24)='1' and Clk_Selected = '0')) else
					 '1';

	LED3 <= o_green_led;
	LED2 <= ADCDataTest_Ok;--not o_blue_led;
	LED1 <= o_red_led;

	LED4 <= '1' when TestCnt(21)='1' else
				'0' when TestCnt(21)='0' else
				'0';
	LED5 <= '1' when TestCnt(23)='1' else
				'0' when TestCnt(23)='0' else
				'0';

--******** In/Out LVDS ADC Data ********--

	adc_deser_i: entity work.adc_deser
	port map(
		Clock_i		=> Clk80,
		Clock_ctrl	=> Clk200,
		SDATAP		=> ADCInDataLVDS,
		SDATAN		=> ADCInDataLVDS_n,

		SDATAPrevP	=> ADCInDataLVDSPrev,
		SDATAPrevN	=> ADCInDataLVDSPrev_n,

		DCOP			=> ADC_DCO_LVDS,
		DCON			=> ADC_DCO_LVDS_n,
		FCO			=> ADC_FCO,
		DCOPrevP		=> ADC_DCO_LVDSPrev,
		DCOPrevN		=> ADC_DCO_LVDSPrev_n,
		FCOPrev		=> ADC_FCO_LVDSPrev,
		
		o_adc_data	=> InDataReg,
--		o_dco			=> test_adc_deser,
		o_adc_data_prev	=> InDataPrevReg,
		
		SetReset		=> PwrUpReset,
		
		test			=> test_adc_deser
	);
	
	process (Clk80)
	begin
		if rising_edge(TestCnt(16)) then
			ADCDataNext(0) <= InDataReg(56);
			ADCDataNext(1) <= InDataReg(57);
			ADCDataNext(2) <= InDataReg(58);
			ADCDataNext(3) <= InDataReg(59);
			ADCDataNext(4) <= InDataReg(60);
			ADCDataNext(5) <= InDataReg(61);
			ADCDataNext(6) <= InDataReg(62);
			ADCDataNext(7) <= InDataReg(63);
			ADCDataNext(8) <= "00001000";--InDataReg(108);
			ADCDataNext(9) <= "00001001";--InDataReg(109);
			ADCDataNext(10) <= "00001010";--InDataReg(110);
			ADCDataNext(11) <= "00001011";--InDataReg(111);
		end if;
	end process;
	
	adc_deser_o: entity work.adc_deser_o
	port map(
		Clock_i		=> Clk40,
		Clock_div	=> Clk160,
		DATA_i		=> ADCDataNext,
		
		SDATANextP	=> ADCOutDataLVDSNext,
		SDATANextN	=> ADCOutDataLVDSNext_n,
		DCOP			=> ADC_DCO_LVDSNext,
		DCON			=> ADC_DCO_LVDSNext_n,
		FCO			=> ADC_FCO_LVDSNext,
		test			=> test_adc_deser_o
	);
	
--******** Processing data ********--

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

		test				=> test_FindMaxAmp
	);

--******** TriggerData Out ********--

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
		
	ADC_Data_test: for i in 0 to 7 generate 
		process (Clk80)
		begin
			if rising_edge(Clk80) then
				if ((InDataReg(i)(0) = '1') and (InDataReg(i)(1) = '1') and (InDataReg(i)(2) = '0') and (InDataReg(i)(3) = '0') and 
				    (InDataReg(i)(4) = '0') and (InDataReg(i)(5) = '1') and (InDataReg(i)(6) = '0') and (InDataReg(i)(7) = '1')) then ADCDataTest(i) <= '1';
					else ADCDataTest(i) <= '0';
				end if;
			end if;
		end process;
	end generate ADC_Data_test;

--	process(Clk80)
--	begin
--		if rising_edge(Clk80) then
--			if ((ADCDataTest(0) = '1') or (ADCDataTest(1) = '1') or (ADCDataTest(2) = '1') or 
--				 (ADCDataTest(3) = '1') or (ADCDataTest(4) = '1') or (ADCDataTest(5) = '1') or 
--				 (ADCDataTest(6) = '1') or (ADCDataTest(7) = '1')) then ADCDataTest_Ok <= '0';
--																				   else ADCDataTest_Ok <= '1';
--			end if;
--		end if;
--	end process;

	process(Clk80)
	begin
		if rising_edge(Clk80) then
			if ((InDataReg(0) = "10100011") or (InDataReg(1) = "10100011") or (InDataReg(2) = "10100011") or (InDataReg(3) = "10100011") or 
				 (InDataReg(4) = "10100011") or (InDataReg(5) = "10100011") or (InDataReg(6) = "10100011") or (InDataReg(7) = "10100011")) then ADCDataTest_Ok <= '1';
																																													else ADCDataTest_Ok <= '0';
			end if;
		end if;
	end process;

--******** Test part ********--

	CntTest : entity work.V_Counter 
	generic map(
				WIDTH => 26
			)
	port map (
				clock 	=> CLK40,--Quarts,--
				clk_en	=>	'1',
				q			=> TestCnt
				);

	Test(0) <= InDataReg(1)(0);
	Test(1) <= InDataReg(1)(1);
	Test(2) <= InDataReg(1)(2);
	Test(3) <= InDataReg(1)(3);
	Test(4) <= InDataReg(1)(4);
	Test(5) <= InDataReg(1)(5);
	Test(6) <= InDataReg(1)(6);
	Test(7) <= InDataReg(1)(7);
	Test(8) <= ADCDataTest_Ok;--test_adc_deser(0);
	Test(9) <= Clk40;

end Behavioral;
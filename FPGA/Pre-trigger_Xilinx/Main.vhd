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
	FCT_40_n		: in std_logic; -- system clock
	FCT_160		: in std_logic; -- clock
	FCT_160_n	: in std_logic; -- clock
-- In Trigger module Link's Clock is checked inside Altera but switched outside 
	Sw_Quartz	: out std_logic;	-- connects Quartz to PLL ref.Input			-> Pin 
	Sw_FCTClk	: out std_logic;	-- connects Link's Clock to PLL ref.Input	-> Pin 

	PLL_in		: in std_logic;	-- Ref.clock for PLL (dedicated)			<- Pin G1

-- Outputs for Indicators on LED's

	Led1			: out std_logic;	-- drives the Green LED						-> Pin 
	Led2			: out std_logic := '0';	-- drives the Blue LED						-> Pin 
	Led3			: out std_logic := '0';	-- drives the Red LED						-> Pin 
	Led4			: out std_logic := '0';	-- drives the Blue(Yellow) LED			-> Pin 
	Led5			: out std_logic := '0';	-- drives the Blue(Yellow) LED			-> Pin 

-- 2. Channel  

	ADCInDataLVDS		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDS_n	: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev_n: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 

	ADC_CSB				: out std_logic := '0';	-- Pin 
	ADC_SDIO				: out std_logic := '0';	-- Pin 
	ADC_SCLK				: out std_logic := '0';	-- Pin 

	ADC_CLK				: out std_logic;	-- Pin 
	ADC_DCO_LVDS		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_DCO_LVDS_n		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_FCO_LVDS		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_FCO_LVDS_n		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_DCO_LVDSPrev	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	ADC_DCO_LVDSPrev_n: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 

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
	Test			: out std_logic_vector(9 downto 0):= (others => '0'));

end Main;

architecture Behavioral of Main is

	--- clocking
	signal Quarts				: std_logic;
	signal FCT40				: std_logic;
	signal Clk40				: std_logic;
	signal Clk80				: std_logic;
	signal FCT160				: std_logic;
	signal Phase				: std_logic;
	signal Clk_Selected		: std_logic;
	signal s_clock_locked	: std_logic := '0';
	---

	--- system
	signal Reset				: std_logic;
	---

	--- ADC SPI interface signals
	signal s_fadc_sdio : std_logic := '0'; 
	signal s_fadc_sclk : std_logic := '0';
	signal s_fadc_csb  : std_logic_vector(3 downto 0) := (others => '1');
	---
	
	--- Input ADC data
	signal ADCInData	: std_logic_vector(NUM_TrigCell-1 downto 0);
	signal ADCInDataPrev: std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	signal ADC_DCO		: std_logic_vector(NUM_TrigCell/4-1 downto 0);
	signal ADC_FCO		: std_logic_vector(NUM_TrigCell/4-1 downto 0);
	signal ADC_DCOPrev	: std_logic_vector(NUM_TrigCellPrev-1 downto 0);

	signal InDataReg_p	: std_logic_vector(NUM_TrigCell-1 downto 0);
	signal InDataReg_n	: std_logic_vector(NUM_TrigCell-1 downto 0);
	signal InDataReg		: array_adc;
	signal InDataPrevReg_p	: std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	signal InDataPrevReg_n	: std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	signal InDataPrevReg		: array_prev_adc;

	--- TriggerDes
	signal TrigIn	: std_logic;
	signal TrigDes_o	: std_logic;
	signal FastTrigDes_o	: std_logic;

	--- Read/Write to/from DAQ
	signal RW				: std_logic := '0';

	--- Test
	signal TestCnt	: std_logic_vector(23 downto 0);

begin

--=================Inicialization of input LVDS signals=================--
--******** 1. Reference clock's & Frequency Control ********--
BUFG_inst : IBUFG
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE"   
		IOSTANDARD => "DEFAULT")
	port map (
		O => Quarts,     -- Clock buffer output
		I => Qclock      -- Clock buffer input
	);

LVDS_Clk40 : IBUFGDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		DIFF_TERM => TRUE, -- Differential Termination 
		IOSTANDARD => "DEFAULT")
	port map (
		O => FCT40,  -- Clock buffer output
		I => FCT_40,  -- Diff_p clock buffer input
		IB => FCT_40_n -- Diff_n clock buffer input
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
	
PLL : IBUFG
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE"   
		IOSTANDARD => "DEFAULT")
	port map (
		O => Clk40,     -- Clock buffer output
		I => PLL_in      -- Clock buffer input
	);

--**************** Automatic Clock Switch for PLL reference ******************

PhaseSwitch: entity work.PhaseSW 
	generic map(
				Fmax				=> 42000, -- Upper limit in kHz
				Fmin				=> 38000, -- Lower limit in kHz
				RefClock			=> 40000  -- Local Quartz Freq(kHz) used as the reference
				)
	port map ( Clock				=> Quarts,
				  SysClk				=> FCT40,
				  Reset				=> Reset,
				  Phase				=> Phase,
				  SysClk_Selected	=> Clk_Selected
				);
Sw_FCTClk <= Clk_Selected;
Sw_Quartz <= not Clk_Selected;

DivClk: BUFR 
	generic map (
		BUFR_DIVIDE => "2",   -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8" 
		SIM_DEVICE => "VIRTEX4")   -- Specify target device, "VIRTEX4", "VIRTEX5", "VIRTEX6" 
	port map (
		O => Clk80,     -- Clock buffer output
		CE => '1',   -- Clock enable input
		CLR => '0', -- Clock buffer reset input
		I => Clk40      -- Clock buffer input
	);

--******** 2. Input LVDS ADC buffer ********--
-- Input LVDS ADC buffer
LVDS_buf_ADC: for i in 0 to NUM_TrigCell-1 generate 
	LVDS_signal : IBUFDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => ADCInData(i),  -- Buffer output
			I => ADCInDataLVDS(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADCInDataLVDS_n(i) -- Diff_n buffer input (connect directly to top-level port)
		);

	SERDES : entity work.ISERDES_8bit 
	port map  (
		DataIn 	=> ADCInData(i),	-- input of data from ADC by bits
		Clock		=> CLK80,
		ClkDiv	=> ADC_DCO(i/4),
		DataOut	=> InDataReg(i)
				 );

end generate LVDS_buf_ADC;

-- Input LVDS ADC buffer from prev.board
LVDS_buf_ADCPrev: for i in 0 to NUM_TrigCellPrev-1 generate 
	LVDS_signal : IBUFDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => ADCInDataPrev(i),  -- Buffer output
			I => ADCInDataLVDSPrev(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADCInDataLVDSPrev_n(i) -- Diff_n buffer input (connect directly to top-level port)
		);
	SERDES : entity work.ISERDES_8bit 
	port map  (
		DataIn 	=> ADCInDataPrev(i),	-- input of data from ADC by bits
		Clock		=> CLK80,
		ClkDiv	=> ADC_DCOPrev(i/4),
		DataOut	=> InDataPrevReg(i)
				 );

end generate LVDS_buf_ADCPrev;

-- Input LVDS ADC DCO buffer
LVDS_ADC_DCO: for i in 0 to NUM_TrigCell/4-1 generate 
	LVDS_signal : IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => ADC_DCO(i),  -- Buffer output
			I => ADC_DCO_LVDS(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADC_DCO_LVDS_n(i) -- Diff_n buffer input (connect directly to top-level port)
		);
end generate LVDS_ADC_DCO;

-- Input LVDS ADC FCO buffer
LVDS_ADC_FCO: for i in 0 to NUM_TrigCell/4-1 generate 
	LVDS_signal : IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => ADC_FCO(i),  -- Buffer output
			I => ADC_FCO_LVDS(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADC_FCO_LVDS_n(i) -- Diff_n buffer input (connect directly to top-level port)
		);
end generate LVDS_ADC_FCO;

-- Input LVDS ADC DCO buffer from prev.board
LVDS_ADC_DCOPrev: for i in 0 to NUM_TrigCellPrev-1 generate 
	LVDS_signal : IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => ADC_DCOPrev(i),  -- Buffer output
			I => ADC_DCO_LVDSPrev(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADC_DCO_LVDSPrev_n(i) -- Diff_n buffer input (connect directly to top-level port)
		);
end generate LVDS_ADC_DCOPrev;

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

FindMaxAmp_i: entity work.FindMaxAmp

port map(

	In_Data			=> InDataReg,
	In_DataPrev		=> InDataPrevReg,
	RegInit			=> '0',
	MaxAmp			=> TriggerData(9 downto 0),
	MaxCellNumber	=> TriggerData(19 downto 10),
	ThrNum1			=> TriggerData(23 downto 20),
	ThrNum2			=> TriggerData(27 downto 24),
	ThrNum3			=> TriggerData(31 downto 28),
	FastTrig			=> FastTrigDes_o,
	Trig				=> TrigDes_o,
--	SaveTrigData	=> '0',

	Clock				=> CLK40,
	Clock160			=> CLK160,

	Reset				=> Reset
--	ResetAll			=> '0',
--	Error				=> '0',

--	test				=> 
	);
	
--******** LED ********--
	LED1 <= '1' when TestCnt(22)='1' else
				'0' when TestCnt(22)='0' else
				'0';
	Led_B : entity work.Light_Pulser 
		generic map ( DIV	=> 2,
						  DUR	=> 100)
		port map( 
					 clock => CLK80,
					 i_event => FastTrigDes,
					 o_flash => LED2
					);

	LED3 <= '1' when TestCnt(21)='1' else
				'0' when TestCnt(21)='0' else
				'0';

	
	ADC_CLK <= CLK40;
	TriggerData(32) <= FastTrigDes_o;
	TriggerData(33) <= TrigDes_o;
	
	FastTrigDes <= FastTrigDes_o;
	TrigDes <= TrigDes_o;

--******** Test part ********--

	CntTest : entity work.V_Counter 
	generic map(
				WIDTH => 24
			)
	port map (
				clock 	=> CLK40,
				clk_en	=>	'1',
				q			=> TestCnt
				);

end Behavioral;
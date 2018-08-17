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
	Qclock      : in std_logic; -- system clock
	FCT_40		: in std_logic; -- system clock
	FCT_40_n		: in std_logic; -- system clock
	FCT_160		: in std_logic; -- clock
	FCT_160_n	: in std_logic; -- clock
-- In Trigger module Link's Clock is checked inside Altera but switched outside 
	Sw_Quartz	: in std_logic;	-- connects Quartz to PLL ref.Input			-> Pin 
	Sw_FCTClk	: in std_logic;	-- connects Link's Clock to PLL ref.Input	-> Pin 

	PLL_in		: in std_logic;	-- Ref.clock for PLL (dedicated)			<- Pin G1

-- Outputs for Indicators on LED's

	Led1			: out std_logic;	-- drives the Green LED						-> Pin 
	Led2			: out std_logic;	-- drives the Blue LED						-> Pin 
	Led3			: out std_logic;	-- drives the Red LED						-> Pin 
	Led4			: out std_logic;	-- drives the Blue(Yellow) LED			-> Pin 
	Led5			: out std_logic;	-- drives the Blue(Yellow) LED			-> Pin 

-- 2. Channel  

	ADCInDataLVDS		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDS_n	: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev_n: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 

	ADC_CSB				: out std_logic;	-- Pin 
	ADC_SDIO				: out std_logic;	-- Pin 
	ADC_SCLK				: out std_logic;	-- Pin 

	ADC_CLK				: out std_logic;	-- Pin 
	ADC_DCO_LVDS		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_DCO_LVDS_n		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_FCO_LVDS		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_FCO_LVDS_n		: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_DCO_LVDSPrev	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	ADC_DCO_LVDSPrev_n: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 

-- 3. Trig_in-out_FCT

	TrigInLVDS		: in std_logic;	-- Внешний триггер					<- Pin 
	TrigInLVDS_n	: in std_logic;	-- Внешний триггер					<- Pin 
	FastTrigDes		: out std_logic;	-- Fast trigger desition to EROS/ROESTI	<- Pin
	TrigDes			: out std_logic;	-- Trigger desition to FC7			<- Pin
	TriggerData		: out std_logic_vector(TrigBits-1 downto 0);	-- Trigger data to FCT

-- 4. Ethernet Phy device ports     LXT972
	RxClk			: in std_logic; --					-> Pin
	Crs			: in std_logic;-- Carrier Sense
	RxDv			: in std_logic;-- Data Valid
	RxD			: in std_logic_vector(3 downto 0); 
--RxEr			: input; -- RxEr not in use!!!! pin...-corner

	TxClk			: in std_logic; --					-> Pin
	TxEn			: out std_logic; --					-> Pin
	TxD			: out std_logic_vector(3 downto 0); --					-> Pin
	Col 			: in std_logic; -- Collision_Detect not used	-> Pin

-- 5. 
--ExtStart		: input = GND;  -- external Start						<- Pin
	ExtReset		: in std_logic;  -- external Reset (tied to GND --VCC)	<- Pin

-- 6. Test
	Test			: out std_logic_vector(9 downto 0));

end Main;

architecture Behavioral of Main is

	--- system
	signal Reset				: std_logic;
	---

	--- clocking
	signal Clk40				: std_logic;
	signal Clk80				: std_logic;
	signal Clk160				: std_logic;
	signal s_clock_locked	: std_logic := '0';
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
	signal InDataPrev		: array_prev_adc;

	signal TrigIn	: std_logic;
--	signal 
--	signal 
	signal TestCnt	: std_logic_vector(24 downto 0);

begin

--=================Inicialization of input LVDS signals=================--
--******** 1. Reference clock's & Frequency Control ********--
LVDS_Clk40 : IBUFGDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		DIFF_TERM => TRUE, -- Differential Termination 
		IOSTANDARD => "DEFAULT")
	port map (
		O => Clk40,  -- Clock buffer output
		I => FCT_40,  -- Diff_p clock buffer input
		IB => FCT_40_n -- Diff_n clock buffer input
	);
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

LVDS_FCT_160 : IBUFGDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		DIFF_TERM => TRUE, -- Differential Termination 
		IOSTANDARD => "DEFAULT")
	port map (
		O => Clk160,		-- Buffer output
		I => FCT_160,	-- Diff_p buffer input (connect directly to top-level port)
		IB => FCT_160_n	-- Diff_n buffer input (connect directly to top-level port)
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

	In_Data        => InDataReg,
	RegInit			=> '0',
	MaxAmp			=> TriggerData(9 downto 0),
	MaxCellNumber	=> TriggerData(18 downto 10),
	ThrNum1			=> TriggerData(22 downto 18),
	ThrNum2			=> TriggerData(26 downto 22),
	ThrNum3			=> TriggerData(30 downto 26),
	FastTrig			=> TriggerData(30),
	Trig				=> TriggerData(31),
	SaveTrigData	=> '0',

	Clock				=> CLK40,
	Clock160			=> CLK160,

	Reset				=> Reset,
	ResetAll			=> '0',
	Error				=> '0',

	test				=> (others => '0')
	);

--******** Test part ********--

	CntTest : entity work.V_Counter 
	generic map(
				DATA_WIDTH => 24
			)
	port map (
				clock 	=> CLK40,
				clk_en	=>	'1',
				q			=> TestCnt
				);

	LED1 <= '1' when TestCnt(22)='1' else
				'0' when TestCnt(22)='0' else
				'0';

end Behavioral;
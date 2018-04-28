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

	LedR			: out std_logic;	-- drives the Red LED						-> Pin 
	LedG			: out std_logic;	-- drives the Green LED						-> Pin 
	LedB			: out std_logic;	-- drives the Blue(Yellow) LED				-> Pin 

-- 2. Channel  

	ADCInDataLVDS		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDS_n	: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev_n: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 

	ADC_CSB		: out std_logic;	-- Pin 
	ADC_SDIO		: out std_logic;	-- Pin 
	ADC_SCLK		: out std_logic;	-- Pin 

	ADC_CLK		: out std_logic;	-- Pin 
	ADC_DCO_LVDS	: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_DCO_LVDS_n	: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	ADC_DCO_LVDSPrev	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	ADC_DCO_LVDSPrev_n: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 

-- 3. Trig_in-out_FCT

	TrigInLVDS		: in std_logic;	-- Внешний триггер					<- Pin 
	TrigInLVDS_n	: in std_logic;	-- Внешний триггер					<- Pin 
	FastTrigDes		: out std_logic;	-- Fast trigger desition to EROS/ROESTI	<- Pin
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

	signal 		Clk40		: std_logic;
	signal 		Clk160	: std_logic;
	signal 		ADCInData	: std_logic_vector(NUM_TrigCell-1 downto 0);
	signal 		ADCInDataPrev: std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	signal		ADC_DCO		: std_logic_vector(NUM_TrigCell-1 downto 0);
	signal		ADC_DCOPrev	: std_logic_vector(NUM_TrigCellPrev-1 downto 0);
	signal 		TrigIn	: std_logic;
--	signal 
--	signal 
--	signal 
--	signal 

component FindMaxAmp is
port(

	In_Data        		: in array_t;
	RegInit					: in std_logic;
	MaxAmp					: out std_logic_vector(Sum_Bits-1 downto 0);
	MaxCellNumber			: out std_logic_vector(3 downto 0);
	ThrNum1					: out std_logic_vector(3 downto 0);
	ThrNum2					: out std_logic_vector(3 downto 0);
	ThrNum3					: out std_logic_vector(3 downto 0);
	FastTrig					: out std_logic;
	Trig						: out std_logic;
	SaveTrigData			: out std_logic;

	Clock						: in std_logic;
	Clock160					: in std_logic;

	Reset						: in std_logic;
	ResetAll					: out std_logic;
	Error						: out std_logic;

	test						: out std_logic_vector(15 downto 0));
end component;

begin

--=================Inicialization of input LVDS signals=================--
--******** 1. Reference clock's & Frequency Control ********--
LVDS_Clk40 : IBUFDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		DIFF_TERM => TRUE, -- Differential Termination 
		IOSTANDARD => "DEFAULT")
	port map (
		O => Clk40,		-- Buffer output
		I => FCT_40,	-- Diff_p buffer input (connect directly to top-level port)
		IB => FCT_40_n	-- Diff_n buffer input (connect directly to top-level port)
	);

LVDS_FCT_160 : IBUFDS
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
	LVDS_signal : IBUFDS
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

-- Input LVDS ADC DCO buffer from prev.board
LVDS_ADC_DCOPrev: for i in 0 to NUM_TrigCellPrev-1 generate 
	LVDS_signal : IBUFDS
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

--=================Deserialization of input LVDS signals=================--
--******** 1. Input LVDS ADC buffer ********--
DDR_buf_ADC: for i in 0 to NUM_TrigCell-1 generate 
	IDDR_inst : IDDR 
		generic map (
			DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE", "SAME_EDGE" 
														-- or "SAME_EDGE_PIPELINED" 
			INIT_Q1 => '0', -- Initial value of Q1: '0' or '1'
			INIT_Q2 => '0', -- Initial value of Q2: '0' or '1'
			SRTYPE => "SYNC") -- Set/Reset type: "SYNC" or "ASYNC" 
		port map (
			Q1 => Q1, -- 1-bit output for positive edge of clock 
			Q2 => Q2, -- 1-bit output for negative edge of clock
			C => C,   -- 1-bit clock input
			CE => CE, -- 1-bit clock enable input
			ADCInData => D,   -- 1-bit DDR data input
			R => R,   -- 1-bit reset
			S => S    -- 1-bit set
			);
end generate DDR_buf_ADC;

DDR_buf_ADCPrev: for i in 0 to NUM_TrigCellPrev-1 generate 
	IDDR_inst : IDDR 
		generic map (
			DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE", "SAME_EDGE" 
														-- or "SAME_EDGE_PIPELINED" 
			INIT_Q1 => '0', -- Initial value of Q1: '0' or '1'
			INIT_Q2 => '0', -- Initial value of Q2: '0' or '1'
			SRTYPE => "SYNC") -- Set/Reset type: "SYNC" or "ASYNC" 
		port map (
			Q1 => Q1, -- 1-bit output for positive edge of clock 
			Q2 => Q2, -- 1-bit output for negative edge of clock
			C => C,   -- 1-bit clock input
			CE => CE, -- 1-bit clock enable input
			ADCInData => D,   -- 1-bit DDR data input
			R => R,   -- 1-bit reset
			S => S    -- 1-bit set
			);
end generate DDR_buf_ADCPrev;

end Behavioral;


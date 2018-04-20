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

generic (Masks_Offset 		: integer := X"20";   -- MasksReg #32
			ADC_Bits				: integer := 8;	-- Number of ADC bits in one channel
			NUM_ADCboard		: integer := 16;	-- Number of ADC boards in the trigger
			NUM_TrigCell		: integer := 128;	-- Number of channels in the trigger
			NUM_Trig_get_ch	: integer := 12;	-- Number of channels in the trigger from prev.board
			ThresholdData_0	: integer := 100;
			ThresholdData_1	: integer := 150;
			ThresholdData_2	: integer := 243;
			TrigBits				: integer := 64		-- Number of triggerg bits to FCT
);

port(
-- 1. Clocks
	Qclock      : in std_logic; -- system clock
	FCT_40		: in std_logic; -- system clock
	FCT_160		: in std_logic; -- clock
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
	PreviousInDataLVDS: in std_logic_vector(NUM_Trig_get_ch-1 downto 0);	-- input of data from ADC	<- Pin 
--	ADCInDataLVDS		: in std_logic_vector(128-1 downto 0);	-- input of data from ADC	<- Pin 
--	PreviousInDataLVDS: in std_logic_vector(12-1 downto 0);	-- input of data from ADC	<- Pin 

	ADC_CSB		: out std_logic;	-- Pin 
	ADC_SDIO		: out std_logic;	-- Pin 
	ADC_SCLK		: out std_logic;	-- Pin 

	ADC_CLK		: out std_logic;	-- Pin 
	ADC_DCO		: in std_logic_vector(31 downto 0);	-- 
	ADC_DCOprev	: in std_logic_vector(11 downto 0);	-- 
--ADC_channel_shift_clk : input;	-- Pin AB10

-- 3. Trig_in-out_FCT

	TrigIn			: in std_logic;	-- Внешний триггер					<- Pin 
--FastTrigDes		: output;	-- Fast trigger desition to EROS/ROESTI	<- Pin
	TriggerData		: out std_logic_vector(63 downto 0);	-- Trigger data to FCT

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
--ADCInDataLVDS_p[126,127]: bidir;
--ADCInDataLVDS_n[126,127]: bidir;

end Main;

architecture Behavioral of Main is

component FindMaxAmp is
port(

	In_Data					: in std_logic_vector(NumTrigCh-1 downto 0)(ADC_Bits-1 downto 0); -- ??????? ??????
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

	test						: out std_logic_vector(15 downto 0);

end component;

begin




end Behavioral;


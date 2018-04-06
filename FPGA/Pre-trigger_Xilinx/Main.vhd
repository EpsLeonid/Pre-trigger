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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

CONSTANT Masks_Offset 		:= H"20";   -- MasksReg #32

CONSTANT ADC_Bits				:= 8;	-- Number of ADC bits in one channel
CONSTANT NUM_ADCboard		:= 16;	-- Number of ADC boards in the trigger
CONSTANT NUM_TrigCell		:= 128;	-- Number of channels in the trigger
CONSTANT NUM_Trig_get_ch	:= 12;	-- Number of channels in the trigger from prev.board
CONSTANT ThresholdData_0	:= 100;
CONSTANT ThresholdData_1	:= 150;
CONSTANT ThresholdData_2	:= 243;
CONSTANT TrigBits				:= 64;		-- Number of triggerg bits to FCT

entity Main is
port(
-- 1. Clocks
	Qclock      : in std_logic; -- system clock
	FCT_40		: in std_logic; -- system clock
	FCT_160		: in std_logic; -- clock
-- In Trigger module Link's Clock is checked inside Altera but switched outside 
	Sw_Quartz	: in std_logic;	-- connects Quartz to PLL ref.Input			-> Pin B5
	Sw_FCTClk	: in std_logic;	-- connects Link's Clock to PLL ref.Input	-> Pin B8

	PLL_in		: in std_logic;	-- Ref.clock for PLL (dedicated)			<- Pin G1

-- Outputs for Indicators on LED's

	LedR			: out std_logic;	-- drives the Red LED						-> Pin 
	LedG			: out std_logic;	-- drives the Green LED						-> Pin 
	LedB			: out std_logic;	-- drives the Blue(Yellow) LED				-> Pin 

-- 2. Channel  

	ADCInDataLVDS		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	PreviousInDataLVDS: in std_logic_vector(NUM_Trig_get_ch-1 downto 0);	-- input of data from ADC	<- Pin 

	ADC_CSB		: out std_logic;	-- Pin AA4
	ADC_SDIO		: out std_logic;	-- Pin AA1
	ADC_SCLK		: out std_logic;	-- Pin AB4

	ADC_CLK		: out std_logic;	-- Pin AA3/AB3
	ADC_DCO		: in std_logic_vector(31 downto 0);	-- 
	ADC_DCOprev	: in std_logic_vector(11 downto 0);	-- 
--ADC_channel_shift_clk : input;	-- Pin AB10

-- 3. Trig_in-out_FCT

	TrigIn			: in std_logic;	-- Внешний триггер					<- Pin W10/Y10
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

begin


end Behavioral;


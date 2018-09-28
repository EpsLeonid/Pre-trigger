----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:04 08/15/2018 
-- Design Name: 
-- Module Name:    ISERDES_8bit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.parameters.all;

entity ISERDES_8bit is
port (

	DataIn 	: in std_logic;	-- input of data from ADC by bits
	Clock		: in std_logic;
	ClkDiv	: in std_logic;
	Rst		: in std_logic := '0';
	
	DataOut	: out std_logic_vector(ADC_Bits-1 downto 0)
	
	);
end ISERDES_8bit;

architecture Behavioral of ISERDES_8bit is

	signal shift1	: std_logic; 
	signal shift2	: std_logic;
--	signal clkdiv	: std_logic;
	signal Data		: std_logic_vector(ADC_Bits-1 downto 0);

begin

--	DivClk: BUFR generic map (
--      BUFR_DIVIDE => "4",   -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8" 
--      SIM_DEVICE => "VIRTEX4")   -- Specify target device, "VIRTEX4", "VIRTEX5", "VIRTEX6" 
--   port map (
--      O => clkdiv,     -- Clock buffer output
--      CE => '1',   -- Clock enable input
--      CLR => '0', -- Clock buffer reset input
--      I => Clock      -- Clock buffer input
--   );	

	adc_serdes_1: ISERDES generic map (
      BITSLIP_ENABLE => TRUE, -- TRUE/FALSE to enable bitslip controller
                                 -- Must be "FALSE" in interface type is "MEMORY" 
      DATA_RATE => "DDR", -- Specify data rate of "DDR" or "SDR" 
      DATA_WIDTH => 8, -- Specify data width - For DDR 4,6,8, or 10 
                       -- For SDR 2,3,4,5,6,7, or 8 
      INTERFACE_TYPE => "NETWORKING", -- Use model - "MEMORY" or "NETWORKING" 
      IOBDELAY => "NONE", -- Specify outputs where delay chain will be applied
                          -- "NONE", "IBUF", "IFD", or "BOTH" 
      IOBDELAY_TYPE => "DEFAULT", -- Set tap delay "DEFAULT", "FIXED", or "VARIABLE" 
      IOBDELAY_VALUE => 0, -- Set initial tap delay to an integer from 0 to 63
      NUM_CE => 1, -- Define number or clock enables to an integer of 1 or 2
      SERDES_MODE => "MASTER") --Set SERDES mode to "MASTER" or "SLAVE" 
   port map (
      O => Open,    -- 1-bit output
      Q1 => Data(0),  -- 1-bit output
      Q2 => Data(1),  -- 1-bit output
      Q3 => Data(2),  -- 1-bit output
      Q4 => Data(3),  -- 1-bit output
      Q5 => Data(4),  -- 1-bit output
      Q6 => Data(5),  -- 1-bit output
      SHIFTOUT1 => shift1, -- 1-bit output
      SHIFTOUT2 => shift2, -- 1-bit output
      BITSLIP => '0',     -- 1-bit input
      CE1 => '1',        -- 1-bit input
      CE2 => '1',        -- 1-bit input
      CLK => Clock,        -- 1-bit input
      CLKDIV => ClkDiv,  -- 1-bit input
      D => DataIn,            -- 1-bit input
      DLYCE => '0',    -- 1-bit input
      DLYINC => '0',  -- 1-bit input
      DLYRST => '0',  -- 1-bit input
      OCLK => '0',      -- 1-bit input
      REV => '0',        -- Must be tied to logic zero
      SHIFTIN1 => '0', -- 1-bit input
      SHIFTIN2 => '0', -- 1-bit input
      SR => Rst           -- 1-bit input
   );

	adc_serdes_2: ISERDES generic map (
      BITSLIP_ENABLE => TRUE, -- TRUE/FALSE to enable bitslip controller
                                 -- Must be "FALSE" in interface type is "MEMORY" 
      DATA_RATE => "DDR", -- Specify data rate of "DDR" or "SDR" 
      DATA_WIDTH => 8, -- Specify data width - For DDR 4,6,8, or 10 
                       -- For SDR 2,3,4,5,6,7, or 8 
      INTERFACE_TYPE => "NETWORKING", -- Use model - "MEMORY" or "NETWORKING" 
      IOBDELAY => "NONE", -- Specify outputs where delay chain will be applied
                          -- "NONE", "IBUF", "IFD", or "BOTH" 
      IOBDELAY_TYPE => "DEFAULT", -- Set tap delay "DEFAULT", "FIXED", or "VARIABLE" 
      IOBDELAY_VALUE => 0, -- Set initial tap delay to an integer from 0 to 63
      NUM_CE => 1, -- Define number or clock enables to an integer of 1 or 2
      SERDES_MODE => "SLAVE") --Set SERDES mode to "MASTER" or "SLAVE" 
   port map (
      O => Open,    -- 1-bit output
      Q1 => Open,  -- 1-bit output
      Q2 => Open,  -- 1-bit output
      Q3 => Open,  -- 1-bit output
      Q4 => Open,  -- 1-bit output
      Q5 => Data(6),  -- 1-bit output
      Q6 => Data(7),  -- 1-bit output
      SHIFTOUT1 => Open, -- 1-bit output
      SHIFTOUT2 => Open, -- 1-bit output
      BITSLIP => '0',     -- 1-bit input
      CE1 => '1',        -- 1-bit input
      CE2 => '1',        -- 1-bit input
      CLK => Clock,        -- 1-bit input
      CLKDIV => ClkDiv,  -- 1-bit input
      D => '0',            -- 1-bit input
      DLYCE => '0',    -- 1-bit input
      DLYINC => '0',  -- 1-bit input
      DLYRST => '0',  -- 1-bit input
      OCLK => '0',      -- 1-bit input
      REV => '0',        -- Must be tied to logic zero
      SHIFTIN1 => shift1, -- 1-bit input
      SHIFTIN2 => shift2, -- 1-bit input
      SR => Rst           -- 1-bit input
   );

	DataOut(0) <= not Data(0);
	DataOut(1) <= Data(1);
	DataOut(2) <= not Data(2);
	DataOut(3) <= Data(3);
	DataOut(4) <= not Data(4);
	DataOut(5) <= Data(5);
	DataOut(6) <= not Data(6);
	DataOut(7) <= Data(7);

end Behavioral;


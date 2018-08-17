----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.constants.all;



entity Top is
    Port ( SW0 : in  STD_LOGIC;
           SW1 : in  STD_LOGIC;
           LD0 : out  STD_LOGIC;
           LD1 : out  STD_LOGIC;
           clock : in  STD_LOGIC);
end Top;

architecture Behavioral of Top is
			signal tmp 		: STD_LOGIC_VECTOR (31 downto 0);
			signal flash 	: STD_LOGIC;
			signal CLK0 	: STD_LOGIC;
			signal CLK125 	: STD_LOGIC;
			
			signal o_flash_LD1 	: STD_LOGIC;
			
			component PLL100 port (	CLK_IN1  : in  STD_LOGIC;
											CLK_OUT1 : out  STD_LOGIC);
			end component;
			
begin

--	BUFG_i : BUFG
--   port map (
--      I => clock,     -- Clock buffer output
--      O => CLK125      -- Clock buffer input
--   );
	BUFG_i : PLL100
   port map (
      CLK_IN1 => clock,     -- Clock buffer output
      CLK_OUT1 => CLK125      -- Clock buffer input
   );
	
	Cnt : entity work.V_Counter 
	GENERIC MAP ( WIDTH => 32) 
	port map  (
	           	clock 	=> CLK125,
					clk_en	=>	'1',
					q			=> tmp
				 );
	LPulserLD1 : entity work.Light_Pulser 
	GENERIC MAP (
			 DIV => 1000,
			 DUR => 10000)
	port map  (
	           	clock 	=> CLK125,
					i_event	=>	tmp(25),
					o_flash	=> o_flash_LD1
				 );
				 
				 
				 
	flash <= '1' when tmp(24)='1' and SW0='1' else
				'0' when tmp(24)='0' else
				'0';
				
				 

	LD0 <= flash;
	LD1 <= o_flash_LD1;
end Behavioral;


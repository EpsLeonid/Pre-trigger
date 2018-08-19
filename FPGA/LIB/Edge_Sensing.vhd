----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:39:57 08/13/2018 
-- Design Name: 
-- Module Name:    Edge_Sensing - Behavioral 
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
library work;
use work.parameters.all;

entity Edge_Sensing is
    Port ( D : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           CLR : in  STD_LOGIC := '0';
           Q : out  STD_LOGIC);
end Edge_Sensing;

architecture Utility of Edge_Sensing is
	signal Trig0 : STD_LOGIC := '0';
	signal Trig1 : STD_LOGIC := '1';
	
begin
		process (CLK,CLR)
			begin
				if (CLR='1') then 
						Trig0 <= '0';
						Trig1 <= '1'; 
								 elsif rising_edge(CLK) then   --  
			 			Trig0 <= D;
						Trig1 <= Trig0;
				end if;
		end process; 
	   Q <= Trig0 AND (NOT Trig1);	      
end Utility;


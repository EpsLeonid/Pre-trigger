----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:04:04 10/10/2018 
-- Design Name: 
-- Module Name:    ClkDiv - Behavioral 
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
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.parameters.all;

entity ClkDiv is
	Port (i_clk			: in  STD_LOGIC;
			o_clk_div2	: out std_logic;
			o_clk_div4	: out std_logic;
			o_clk_div8	: out std_logic;
			o_clk_div16	: out std_logic;
			o_clk			: out std_logic);
end ClkDiv;

architecture Behavioral of ClkDiv is

	signal clk_divider	: unsigned(3 downto 0);

begin

	p_clk_divider: process(i_clk)
	begin
		if(rising_edge(i_clk)) then
			clk_divider <= clk_divider + '1';
		end if;
	end process p_clk_divider;
	o_clk_div2	<= clk_divider(0);
	o_clk_div4	<= clk_divider(1);
	o_clk_div8	<= clk_divider(2);
	o_clk_div16	<= clk_divider(3);
	
	o_clk <=  clk_divider(1);

end Behavioral;


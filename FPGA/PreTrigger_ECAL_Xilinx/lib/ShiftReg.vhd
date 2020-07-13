----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:44:10 08/23/2018 
-- Design Name: 
-- Module Name:    ShiftReg - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ShiftReg is
		GENERIC (WIDTH  : NATURAL := 16); 
		port(clock	: in std_logic;
			  clk_en	: in STD_LOGIC := '1';
				d		: in std_logic_vector(WIDTH-1 downto 0);
				sset	: in std_logic;
				sclr	: in std_logic := '0';
				q		: out std_logic);
end ShiftReg;

architecture Behavioral of ShiftReg is

	signal tmp: std_logic_vector(WIDTH-1 downto 0);

begin

	process (clock,sclr)
	begin
		if sclr ='1' then 
			tmp <= (others => '0'); 
		elsif sset = '1' then 
			tmp <= d; 
		elsif clock'event and clock='1' then  
			if clk_en = '1' then 
				tmp <= tmp(WIDTH-2 downto 0) & '0';
			end if; 
		end if;
	end process;
	q <= tmp(WIDTH-1);

end Behavioral;

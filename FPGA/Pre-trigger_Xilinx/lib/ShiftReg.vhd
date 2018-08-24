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
		port(CLK	: in std_logic;
				SI : in std_logic_vector(WIDTH-1 downto 0);
				SO : out std_logic);
end ShiftReg;

architecture Behavioral of ShiftReg is

	signal tmp: std_logic_vector(WIDTH-1 downto 0);

begin

	process (CLK)
	begin
	  if (CLK'event and CLK='1') then
			tmp <= SI;
			for i in 0 to WIDTH-2 loop
				 tmp(i+1) <= tmp(i);
			end loop;
			SO <= tmp(WIDTH-1);
	  end if;
	end process;

end Behavioral;

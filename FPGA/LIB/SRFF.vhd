----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;

entity SRFF is
	Port ( S		: in  STD_LOGIC;
			 CLK	: in  STD_LOGIC;
			 R		: in  STD_LOGIC;
			 CLRN	: in  STD_LOGIC := '1';
			 Q 	: out STD_LOGIC);
end SRFF;

architecture Utility of SRFF is
	signal Trig : STD_LOGIC := '0';

begin
	process (CLK,S,R,CLRN)
		begin
			if CLRN = '0' then
				Q <= '0';
				else 
				if rising_edge(CLK) then
					if S='1' and R='0' then Trig <= '1';
						elsif S='0' and R='1' then Trig <= '0';
							elsif S='0' and R='0' then Trig <= Trig;
								elsif S='1' and R='1' then Trig <= not Trig;
					end if;
				end if;
			end if;
	end process; 
	Q <= Trig;
end Utility;


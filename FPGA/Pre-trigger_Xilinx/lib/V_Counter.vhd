----------------------------------------------------------------------------------
-- Module Name:    V_Counter - Utility 
-- Target Devices: Up/Down, clock_enable, sync reset
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
library work;
use work.parameters.all;


entity V_Counter is
	generic (
		DATA_WIDTH	: integer := 16
				);
    Port ( clock 	: in  STD_LOGIC;
           clk_en : in  STD_LOGIC := '1';
           cnt_en : in  STD_LOGIC := '1';
           sclr 	: in  STD_LOGIC := '0'; -- "1" Clear
			  dir 	: in  STD_LOGIC := '1'; -- "1" Up, "0" Down
           q 		: out  STD_LOGIC_VECTOR (DATA_WIDTH downto 0));
end V_Counter;

architecture Utility of V_Counter is
		signal count : STD_LOGIC_VECTOR (DATA_WIDTH downto 0) := (others => '0'); -- init data
begin
      
		process (clock) 
			begin
				if rising_edge(clock) then
					if sclr='1' then 
						count <= (others => '0');
					elsif clk_en='1' then
						if dir='1' 	then   
							count <= count + 1;
										else
							count <= count - 1;
						end if;
					end if;
				end if;
		end process; 
		Q <= count;

end Utility;
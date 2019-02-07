----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;
library work;
use work.parameters.all;

entity Light_LED is
		Port ( clock 	: in  STD_LOGIC;
				 i_event : in  STD_LOGIC;
				 o_flash : out STD_LOGIC
			  );
		constant DUR_WIDTH : integer := 21;
--		constant DUR		 : integer := 
end Light_LED;

architecture Utility of Light_LED is
		signal Timer_out : STD_LOGIC_VECTOR (DUR_WIDTH-1 downto 0) := (others => '0');
		signal Timer_clk_en : STD_LOGIC;

		signal Q_Trig_SRFF : STD_LOGIC;
		signal S_Trig_SRFF : STD_LOGIC;
		signal R_Trig_SRFF : STD_LOGIC;
		
begin
	
	ES1 : entity work.Edge_Sensing port map  (
											 CLK 	=> clock,
											 D		=>	i_event,
											 Q 	=>	S_Trig_SRFF);
	
	Timer : entity work.V_Counter 
	GENERIC map ( WIDTH  => DUR_WIDTH ) 
	port map  (
					clock 	=> clock,
					clk_en	=>	Timer_clk_en,
					sclr		=>	not Q_Trig_SRFF,
					q			=> Timer_out
				 );
	
	Timer_clk_en <= Q_Trig_SRFF and clock;
	
	DurTrig_SRFF : entity work.SRFF port map  (
											 CLK 	=> clock,
											 S		=>	S_Trig_SRFF,
											 R		=>	R_Trig_SRFF,
											 Q 	=>	Q_Trig_SRFF);
											 
-- prescaler 				

	process (Timer_out)
			begin
				if Timer_out(15) = '1' then R_Trig_SRFF <= '1';
											  else R_Trig_SRFF <= '0';
				end if;
	end process; 	
	
	o_flash	<= Q_Trig_SRFF;

end Utility;


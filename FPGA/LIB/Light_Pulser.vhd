----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;
library work;
use work.parameters.all;

entity Light_Pulser is
		GENERIC ( DIV       : integer := 2; 
					 DUR       : integer := 100);
		Port ( clock 	: in  STD_LOGIC;
				 i_event : in  STD_LOGIC;
				 o_flash : out STD_LOGIC
			  );
		constant DIV_WIDTH : integer := integer(ceil(log2(real(DIV))));
		constant DUR_WIDTH : integer := integer(ceil(log2(real(DUR))));
end Light_Pulser;
--integer result = integer(ceil(log2(DIV)));

architecture Utility of Light_Pulser is

		signal Flah_Freq : STD_LOGIC;
		signal Prescaler_out : STD_LOGIC_VECTOR ( DIV_WIDTH-1 downto 0) := (others => '0');
		signal Timer_out : STD_LOGIC_VECTOR (DUR_WIDTH-1 downto 0) := (others => '0');
		
		signal Timer_clk_en: STD_LOGIC;
		
		signal Q_Trig_SRFF : STD_LOGIC;
		signal S_Trig_SRFF : STD_LOGIC;
		signal R_Trig_SRFF : STD_LOGIC;

		
begin
	Prescaler : entity work.V_Counter 
	GENERIC map ( WIDTH  => DIV_WIDTH ) 
	port map  (
					clock 	=> clock,
					clk_en	=>	'1',
					sclr		=>	Flah_Freq,
					q			=> Prescaler_out
				 );
	Timer : entity work.V_Counter 
	GENERIC map ( WIDTH  => DUR_WIDTH ) 
	port map  (
					clock 	=> clock,
					clk_en	=>	Timer_clk_en,
					sclr		=>	not Q_Trig_SRFF,
					q			=> Timer_out
				 );
	Timer_clk_en <= Q_Trig_SRFF and Flah_Freq;
	ES1 : entity work.Edge_Sensing port map  (
											 CLK 	=> clock,
											 D		=>	i_event,
											 Q 	=>	S_Trig_SRFF);
	DurTrig_SRFF : entity work.SRFF port map  (
											 CLK 	=> clock,
											 S		=>	S_Trig_SRFF,
											 R		=>	R_Trig_SRFF,
											 Q 	=>	Q_Trig_SRFF);
											 
-- prescaler 				
	process (clock)
			begin
				if rising_edge(clock) then 
					if Prescaler_out = DIV then Flah_Freq <= '1';
												  else Flah_Freq <= '0';
					end if;
				end if;
	end process; 	

	process (Timer_out)
			begin
			   if Timer_out = DUR then R_Trig_SRFF <= '1';
										 else R_Trig_SRFF <= '0';
				end if;
	end process; 	
	
	o_flash	<= Q_Trig_SRFF;

end Utility;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:48:18 08/19/2018 
-- Design Name: 
-- Module Name:    PhaseSW - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity PhaseSW is
	Generic (
				Fmax				: integer := 42000; -- Upper limit in kHz
				Fmin				: integer := 38000; -- Lower limit in kHz
				RefClock			: integer := 40000 -- Local Quartz Freq(kHz) used as the reference
				);
	Port ( Clock				: in  STD_LOGIC;
			 SysClk				: in  STD_LOGIC;
			 Reset				: in  STD_LOGIC := '0';
			 Phase				: out  STD_LOGIC;
			 SysClk_Selected	: out  STD_LOGIC := '0';
			 Test					: out  STD_LOGIC_VECTOR (4 downto 1));
end PhaseSW;

architecture Behavioral of PhaseSW is

	signal RefTimeCt		: STD_LOGIC_VECTOR (15 downto 0);
	signal SysClkCt		: STD_LOGIC_VECTOR (15 downto 0);
	signal SysClkCt_sclr	: STD_LOGIC;

	signal RefTimeZero	: STD_LOGIC;
	signal SysClkZero		: STD_LOGIC;

	signal CycleEnd		: STD_LOGIC;
	signal EndTrig			: STD_LOGIC_VECTOR (4 downto 1);
	signal Fnorm			: STD_LOGIC;
	signal FnormTrig		: STD_LOGIC;
	signal FnormTrig_ena	: STD_LOGIC;
	signal Clk_Selected	: STD_LOGIC;

begin

	RefTime_Ct : entity work.V_Counter 
	generic map ( WIDTH => 16 ) 
	port map (
				clock 	=> Clock,
				sclr		=>	EndTrig(4) OR Reset,
				q			=> RefTimeCt
				);

	process (RefTimeCt)
	begin
			if (RefTimeCt = RefClock)  then CycleEnd <= '1'; 
												else CycleEnd <= '0';-- Base time interval, 25000 <=> 1ms 
		end if;
	end process;

	EndTrig1_SRFF : entity work.SRFF 
	port map (
					CLK 	=> Clock,
					S		=>	CycleEnd,
					R		=>	(not RefTimeZero AND not SysClkZero),
					CLRN	=>	not Reset,
					Q		=>	EndTrig(1)
				);

	process (Clock)
	begin
		if rising_edge(Clock) then  
			if Reset='1' then   
				EndTrig(2) <= '0';
				EndTrig(3) <= '0';
				EndTrig(4) <= '0';
			else
				EndTrig(2) <= EndTrig(1);
				EndTrig(3) <= EndTrig(2);
				EndTrig(4) <= EndTrig(3);
			end if;
		end if;
	end process;

	process (Clock)
	begin
		if rising_edge(Clock) then  
			if Reset='1' then 
				RefTimeZero <= '0';
				SysClkZero  <= '0';
			else
				RefTimeZero <= (RefTimeCt(15) or RefTimeCt(14) or RefTimeCt(13) or RefTimeCt(12) 
									or RefTimeCt(11) or RefTimeCt(10) or RefTimeCt(9)  or RefTimeCt(8) 
									or RefTimeCt(7)  or RefTimeCt(6)  or RefTimeCt(5)  or RefTimeCt(4) 
									or RefTimeCt(3)  or RefTimeCt(2)  or RefTimeCt(1)  or RefTimeCt(0));
				SysClkZero  <= (SysClkCt(15) or SysClkCt(14) or SysClkCt(13) or SysClkCt(12) 
									or SysClkCt(11) or SysClkCt(10) or SysClkCt(9)  or SysClkCt(8) 
									or SysClkCt(7)  or SysClkCt(6)  or SysClkCt(5)  or SysClkCt(4) 
									or SysClkCt(3)  or SysClkCt(2)  or SysClkCt(1)  or SysClkCt(0));
			end if;
		end if;
	end process;

	-- Count the external clock frequency, in Base time interval :
	SysClk_Ct : entity work.V_Counter 
	generic map ( WIDTH => 16 ) 
	port map (
				clock 	=> SysClk,
				clk_en	=> '1',
				sclr		=> SysClkCt_sclr,
				q			=> SysClkCt
				);

	process (SysClk)
	begin
		if rising_edge(SysClk) then 
			SysClkCt_sclr <= EndTrig(4) OR Reset;
		end if;
	end process;

	process (SysClk)
	begin
			if ((SysClkCt > Fmin) AND (SysClkCt < Fmax)) then Fnorm <= '1';
																		else Fnorm <= '0'; -- important: to avoid registration of an improper value, ..
		end if;
	end process;

	process (SysClk)
	begin
		if rising_edge(SysClk) then 
			if Reset = '1' then 
				FnormTrig <= '0';
			elsif FnormTrig_ena ='1' then
				FnormTrig <= Fnorm;
			end if;
		end if;
	end process;

	process (Clock)
	begin
		if rising_edge(SysClk) then 
			FnormTrig_ena <= not EndTrig(1);
		end if;
	end process;

	process (EndTrig(3))
	begin
		if rising_edge(EndTrig(3)) then 
			if Reset='1' then   
				SysClk_Selected <= '0';
				Clk_Selected <= '0';
			else
				SysClk_Selected <= FnormTrig;
				Clk_Selected <= FnormTrig;
			end if;
		end if;
	end process;

	--============================================================================
	-- MUX of clock signals : 
	Phase <= ((SysClk and Clk_Selected) OR (Clock and not Clk_Selected));

	Test(1) <= FnormTrig;
	Test(2) <= EndTrig(1);
	Test(3) <= EndTrig(3);
	Test(4) <= SysClkZero;

end Behavioral;
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
			 Test					: out  STD_LOGIC_VECTOR (3 downto 0):= (others => '0'));
end PhaseSW;

architecture Behavioral of PhaseSW is

--	signal TimingCnt_out		: STD_LOGIC_VECTOR (15 downto 0);
--	signal SysClkCnt_out		: STD_LOGIC_VECTOR (15 downto 0);
--
--	signal Sync_TRG1			: STD_LOGIC;
--	signal Sync_TRG2			: STD_LOGIC;
--
--	signal Cycle_End			: STD_LOGIC;
--	signal MUX_Control		: STD_LOGIC;
--	signal Clk_Selected		: STD_LOGIC;
--
--	signal AllReset			: STD_LOGIC;
	
--*************************************

	signal RefTimeCnt_sclr	: STD_LOGIC;
	signal TrigEnd_R			: STD_LOGIC;
	signal SysClkCt_sclr		: STD_LOGIC;

	signal RefTimeCnt_o		: STD_LOGIC_VECTOR (15 downto 0);
	signal RefTimeZero		: STD_LOGIC := '0';
	signal SysClkCnt_o		: STD_LOGIC_VECTOR (15 downto 0);
	signal SysClkZero			: STD_LOGIC := '0';
	signal EndTrig				: STD_LOGIC_VECTOR (4 downto 1);
	signal Fnorm				: STD_LOGIC;
	signal FnormTrig			: STD_LOGIC;
	signal CycleEnd			: STD_LOGIC;
	signal MUX_Control		: STD_LOGIC;

begin
--
--	TimingCnt : entity work.V_Counter 
--	generic map (WIDTH => 16)
--	port map (
--				clock		=> Clock,
--				clk_en	=> '1',
--				sclr		=> AllReset,
--				q			=> TimingCnt_out
--				);
--
--	process (clock, Reset)
--	begin
--		if Reset='1' then 
--			Sync_TRG1 <= '0';
--		elsif (Clock'event and Clock='1') then 
--			if (TimingCnt_out = RefClock) then Sync_TRG1 <= '1' ;
--													else Sync_TRG1 <= '0';
--			end if;
--		end if;
--	end process;
--
--	Cycle_End <= Sync_TRG1;
--	AllReset <= Cycle_End OR Reset;
--
--	SysClkCnt : entity work.V_Counter 
--	generic map (WIDTH => 16)
--	port map (
--				clock		=> SysClk,
--				clk_en	=> '1',
--				sclr		=> AllReset,
--				q			=> SysClkCnt_out
--				);
--
--	-- Pulse counter & CMP
--	process (Cycle_End, Reset)
--	begin
--		if Reset='1' then 
--			Sync_TRG2 <= '0';
--		elsif (Cycle_End'event and Cycle_End='1') then 
--			if ((SysClkCnt_out > Fmin) or (SysClkCnt_out < Fmax)) then Sync_TRG2 <= '1' ;
--																					else Sync_TRG2 <= '0';
--			end if;
--		end if;
--	end process;
--
--	MUX_Control <= Sync_TRG2;
--	-- Frequency diskriminator section end 
--
--	-- Mux section begin 
--	Phase <= ((SysClk and MUX_Control) OR (Clock and not MUX_Control));
--	-- Mux section end 
--
--	SysClk_Selected <= not MUX_Control;

--*****************************************

	RefTimeCnt_sclr <= (EndTrig(4) OR Reset);
	RefTimeCnt : entity work.V_Counter 
	GENERIC map ( WIDTH  => 16 ) 
	port map (
				 clock 	=> clock,
				 clk_en	=>	'1',
				 sclr		=>	RefTimeCnt_sclr,
				 q			=> RefTimeCnt_o
				);

	process (clock)
	begin
		if rising_edge(clock) then 
			if (RefTimeCnt_o = RefClock) then CycleEnd <= '1';    -- Base time interval, 40000 <=> 1ms 
												 else CycleEnd <= '0';
			end if;
		end if;
	end process;

	TrigEnd_R <= (not (RefTimeZero AND SysClkZero));
	TrigEnd : entity work.SRFF 
	port map (
				 CLK 	=> clock,
				 S		=> CycleEnd,
				 R		=> TrigEnd_R,
				 CLRN	=> not Reset,
				 Q 	=> EndTrig(1)
				);
	
	process (clock)
	begin
		if rising_edge(clock) then 
			if Reset = '1' then
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

	process (clock)
	begin
		if rising_edge(clock) then 
			RefTimeZero <= (RefTimeCnt_o(0) OR RefTimeCnt_o(1) OR RefTimeCnt_o(2) OR RefTimeCnt_o(3) 
							 OR RefTimeCnt_o(4) OR RefTimeCnt_o(5) OR RefTimeCnt_o(6) OR RefTimeCnt_o(7) 
							 OR RefTimeCnt_o(8) OR RefTimeCnt_o(9) OR RefTimeCnt_o(10) OR RefTimeCnt_o(11) 
							 OR RefTimeCnt_o(12) OR RefTimeCnt_o(13) OR RefTimeCnt_o(14) OR RefTimeCnt_o(15));
		end if;
	end process;

	process (SysClk)
	begin
		if rising_edge(SysClk) then 
			SysClkZero <= (SysClkCnt_o(0) OR SysClkCnt_o(1) OR SysClkCnt_o(2) OR SysClkCnt_o(3) 
							OR SysClkCnt_o(4) OR SysClkCnt_o(5) OR SysClkCnt_o(6) OR SysClkCnt_o(7) 
							OR SysClkCnt_o(8) OR SysClkCnt_o(9) OR SysClkCnt_o(10) OR SysClkCnt_o(11) 
							OR SysClkCnt_o(12) OR SysClkCnt_o(13) OR SysClkCnt_o(14) OR SysClkCnt_o(15));
		end if;
	end process;

-- Count the external clock frequency, in Base time interval :
	SysClkCt_sclr <= (EndTrig(4) OR Reset);
	SysClkCt : entity work.V_Counter 
	GENERIC map ( WIDTH  => 16 ) 
	port map (
				 clock 	=> SysClk,
				 clk_en	=>	'1',
				 sclr		=>	SysClkCt_sclr,
				 q			=> SysClkCnt_o
				);

	process (SysClk)
	begin
		if rising_edge(SysClk) then 
			if ((SysClkCnt_o > Fmin) AND (SysClkCnt_o < Fmax) ) then Fnorm <= '1';
																				 else Fnorm <= '0';
			end if;                 -- important: to avoid registration of an improper value, ..
			
			if Reset = '1' then 
				FnormTrig <= '0';
			else 
				if (not EndTrig(1) = '1') then 
					FnormTrig <= Fnorm;
				end if;
			end if;
		end if;
	end process;
	
	process (EndTrig(3))
	begin
		if rising_edge(EndTrig(3)) then 
			if Reset = '1' then 
				MUX_Control <= '0';
			else
				MUX_Control <= FnormTrig;
			end if;
		end if;
	end process;
--============================================================================
-- MUX of clock signals : 

	SysClk_Selected <= MUX_Control;

	Phase <= ((SysClk and MUX_Control) OR (Clock and not MUX_Control));
	
	Test(0) <= CycleEnd;
	Test(1) <= SysClkZero;
	Test(2) <= EndTrig(4);
	Test(3) <= SysClk;

end Behavioral;
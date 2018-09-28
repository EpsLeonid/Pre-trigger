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
			 Test					: out  STD_LOGIC_VECTOR (4 downto 1):= (others => '0'));
end PhaseSW;

architecture Behavioral of PhaseSW is

	signal TimingCnt_out		: STD_LOGIC_VECTOR (15 downto 0);
	signal SysClkCnt_out		: STD_LOGIC_VECTOR (15 downto 0);

	signal Sync_TRG1			: STD_LOGIC;
	signal Sync_TRG2			: STD_LOGIC;

	signal Cycle_End			: STD_LOGIC;
	signal MUX_Control		: STD_LOGIC;
	signal Clk_Selected		: STD_LOGIC;

	signal AllReset			: STD_LOGIC;

begin

	TimingCnt : entity work.V_Counter 
	generic map (WIDTH => 16)
	port map (
				clock		=> Clock,
				clk_en	=> '1',
				sclr		=> AllReset,
				q			=> TimingCnt_out
				);

	process (clock, Reset)
	begin
		if Reset='1' then 
			Sync_TRG1 <= '0';
		elsif (Clock'event and Clock='1') then 
			if (TimingCnt_out = RefClock) then Sync_TRG1 <= '1' ;
													else Sync_TRG1 <= '0';
			end if;
		end if;
	end process;

	Cycle_End <= Sync_TRG1;
	AllReset <= Cycle_End OR Reset;

	SysClkCnt : entity work.V_Counter 
	generic map (WIDTH => 16)
	port map (
				clock		=> SysClk,
				clk_en	=> '1',
				sclr		=> AllReset,
				q			=> SysClkCnt_out
				);

	-- Pulse counter & CMP
	process (Cycle_End, Reset)
	begin
		if Reset='1' then 
			Sync_TRG2 <= '0';
		elsif (Cycle_End'event and Cycle_End='1') then 
			if ((SysClkCnt_out > Fmin) or (SysClkCnt_out < Fmax)) then Sync_TRG2 <= '1' ;
																					else Sync_TRG2 <= '0';
			end if;
		end if;
	end process;

	MUX_Control <= Sync_TRG2;
	-- Frequency diskriminator section end 

	-- Mux section begin 
	Phase <= ((SysClk and MUX_Control) OR (Clock and not MUX_Control));
	-- Mux section end 

	SysClk_Selected <= not MUX_Control;

end Behavioral;
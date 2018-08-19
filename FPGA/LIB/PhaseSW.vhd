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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PhaseSW is
	Generic (
				Fmax				: NATURAL := 42000; -- Upper limit in kHz
				Fmin				: NATURAL := 38000; -- Lower limit in kHz
				RefClock			: NATURAL := 40000 -- Local Quartz Freq(kHz) used as the reference
				);
	Port ( Clock				: in  STD_LOGIC;
			 SysClk				: in  STD_LOGIC;
			 Reset				: in  STD_LOGIC;
			 Phase				: out  STD_LOGIC;
			 SysClk_Selected	: out  STD_LOGIC;
			 Test					: out  STD_LOGIC_VECTOR (3 downto 0));
end PhaseSW;

architecture Behavioral of PhaseSW is

	signal RefTimeCt		: STD_LOGIC_VECTOR (15 downto 0);
	signal SysClkCt		: STD_LOGIC_VECTOR (15 downto 0);
	
	signal RefTimeZero	: STD_LOGIC;
	signal SysClkZero		: STD_LOGIC;
	
	signal CycleEnd		: STD_LOGIC;
	signal EndTrig			: STD_LOGIC_VECTOR (4 downto 1);
	signal Fnorm			: STD_LOGIC;
	signal FnormTrig		: STD_LOGIC;
	
begin

	RefTimeCt_ : entity work.V_Counter 
	generic map ( WIDTH  => 16 ) 
	port map (
				clock 	=> clock,
				clk_en	=>	'1',
				sclr		=>	EndTrig(4) OR Reset,
				q			=> RefTimeCt
				);
	RefTimeCt.sclr  = EndTrig4 OR Reset ;

	CycleEnd <= '1' when (RefTimeCt = RefClock) else -- Base time interval, 25000 <=> 1ms 
					'0';
	
	EndTrig1= SRFF(.S=CycleEnd, .clk=clock, -- 2-clk _/^^\_ on "End of Cycle"
						 --.R=EndTrig4, .clrn=!Reset);
						 .R=(!RefTimeZero AND !SysClkZero), .clrn=!Reset);

   if <clock>'event and <clock>='1' then  
      if <reset>='1' then   
         <output> <= '0';
      else
         <output> <= <input>;
      end if;
   end if;

	
	EndTrig2= DFF (.D=EndTrig1, .clk=clock, .clrn=!Reset);
	EndTrig3= DFF (.D=EndTrig2, .clk=clock, .clrn=!Reset);
	EndTrig4= DFF (.D=EndTrig3, .clk=clock, .clrn=!Reset);

	RefTimeZero = DFF(.D=(RefTimeCt.q15 # RefTimeCt.q14 # RefTimeCt.q13 # RefTimeCt.q12 
							  # RefTimeCt.q11 # RefTimeCt.q10 # RefTimeCt.q9  # RefTimeCt.q8  
							  # RefTimeCt.q7  # RefTimeCt.q6  # RefTimeCt.q5  # RefTimeCt.q4  
							  # RefTimeCt.q3  # RefTimeCt.q2  # RefTimeCt.q1  # RefTimeCt.q0 ),
							.clk=Clock );

	SysClkZero = DFF(.D=(SysClkCt.q15 # SysClkCt.q14 # SysClkCt.q13 # SysClkCt.q12 
							  # SysClkCt.q11 # SysClkCt.q10 # SysClkCt.q9  # SysClkCt.q8  
							  # SysClkCt.q7  # SysClkCt.q6  # SysClkCt.q5  # SysClkCt.q4  
							  # SysClkCt.q3  # SysClkCt.q2  # SysClkCt.q1  # SysClkCt.q0 ),
							.clk=SysClk );

	-- Count the external clock frequency, in Base time interval :
	SysClkCt.clock = SysClk ;
	SysClkCt.sclr  = DFF(.D=(EndTrig4 OR Reset), .clk=SysClk) ;

	IF ( (SysClkCt.q[15..0] > Fmin) AND (SysClkCt.q[15..0] < Fmax) )
		 Then  Fnorm = VCC;
		 Else  Fnorm = GND;
	End IF;                 -- important: to avoid registration of an improper value, ..
	FnormTrig   = DFFE(.D=Fnorm, .clk=SysClk,            -- .. clock must be = SysClk !
						 .ena=DFF(.D=!EndTrig1, .clk=SysClk), -- .. clock must be = SysClk !
						 .clrn=!Reset); 

	SysClk_Selected = DFF(.D=FnormTrig, .clk = EndTrig3, .clrn=!Reset);

	--============================================================================
	-- MUX of clock signals : 
	Phase25 <= ((SysClk and SysClk_Selected) OR (Clock and !SysClk_Selected));

	Test(1) <= FnormTrig;
	Test(2) <= EndTrig(1);
	Test(3) <= EndTrig(3);
	Test(4) <= SysClkZero;

end Behavioral;
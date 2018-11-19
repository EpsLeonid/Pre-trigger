library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

package parameters is

--Main
	
--	constant Masks_Offset 		: integer := X"20";   -- MasksReg #32
	constant ADC_Bits				: integer := 8;	-- Number of ADC bits in one channel
	constant NUM_ADCboard		: integer := 16;	-- Number of ADC boards in the trigger -- For tests!!!
	constant NUM_TrigCell		: integer := 128;	-- Number of channels in the trigger -- For tests!!!
	constant NUM_TrigCellPrev	: integer := 12;	-- Number of channels in the trigger from prev.board
	constant TrigBits				: integer := 64;		-- Number of triggerg bits to FCT
	
	type array_adc is array (0 to NUM_TrigCell) of std_logic_vector (ADC_Bits-1 downto 0);
	type array_prev_adc is array (0 to NUM_TrigCellPrev) of std_logic_vector (ADC_Bits-1 downto 0);
	
--FindAmp

	constant Sum_Bits 			: integer := 10; 
	constant NumTrigCh 			: integer := 16;
	constant NumInReg 			: integer := 4; 
	constant NumGroup 			: integer := 9;
	constant BitNumGroup 		: integer := integer(floor(log2(real(NumGroup))));
	constant NumAmpGroup 		: integer := 9;	-- Number of reg for find MaxAmp
--	constant NumAmpGroup 		: integer := integer(NumGroup/2+NumGroup/4+NumGroup/8+(NumGroup rem 2)); -- Number of reg for find MaxAmp
	constant Piedistal_def 		: integer := 100; 
	constant Piedistal_def_2 	: integer := 125;
	constant ThresholdData_0	: integer := 240;
	constant ThresholdData_1	: integer := 150;
	constant ThresholdData_2	: integer := 243;
	constant MaxTime 				: integer := 160;  -- Maximal Valid time (750ns)
	constant ResetTime 			: integer := 240;
	
	type array_group_sum is array (0 to NumGroup) of std_logic_vector (ADC_Bits+1 downto 0);
	type array_group_amp is array (0 to NumAmpGroup) of std_logic_vector (Sum_Bits-1 downto 0);
	type array_group_num is array (0 to NumAmpGroup) of std_logic_vector (BitNumGroup downto 0);

end parameters;

package body parameters is
end parameters;

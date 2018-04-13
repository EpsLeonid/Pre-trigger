library ieee;
use ieee.std_logic_1164.all;

package parameters is
	
	constant Masks_Offset 		: integer := X"20";   -- MasksReg #32

	constant ADC_Bits				: integer := 8;	-- Number of ADC bits in one channel
	constant NUM_ADCboard		: integer := 16;	-- Number of ADC boards in the trigger
	constant NUM_TrigCell		: integer := 128;	-- Number of channels in the trigger
	constant NUM_Trig_get_ch	: integer := 12;	-- Number of channels in the trigger from prev.board
	constant ThresholdData_0	: integer := 100;
	constant ThresholdData_1	: integer := 150;
	constant ThresholdData_2	: integer := 243;
	constant TrigBits				: integer := 64;		-- Number of triggerg bits to FCT
	
end parameters;

package body parameters is
end parameters;

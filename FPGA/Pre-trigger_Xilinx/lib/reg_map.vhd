-- registers mapping
-- naming convention:
-- REG_REGNAME_INDEX         - index of register data in the array
-- REG_REGNAME_NUMBER        - register number to access from mictoblaze cpu
-- REG_REGNAME_DEFAULT_VALUE - default value, 0 if not set

library ieee;
use ieee.std_logic_1164.all;

package reg_map is




--	type REG_INFO_REC is record
--		name    : string;
--		index   : integer;
--		address : std_logic_vector(16 downto 0);
--		def_val : std_logic_vector(REGISTERS_WIDTH-1 downto 0);
	--end record;

	--type reg_info_array_t is array(0 to NUMBER_OF_REGISTERS-1) of REG_INFO_REC;

	--constant REGISTERS_MAP : reg_info_array := (
	--(name => "STATUS", index => 0, address => X"0001", def_val => X"0000")
	--);

    -- total number of available registers	
	constant NUMBER_OF_REGISTERS           : integer := 264;
	-- registers width
	constant REGISTERS_WIDTH               : integer := 16;

	constant REG_STATUS_INDEX              : integer := 0; -- INDEX IN ARRAY 
	constant REG_STATUS_NUMBER             : std_logic_vector(15 downto 0) := X"0020"; 
	constant REG_STATUS_DEFAULT_VALUE      : std_logic_vector(15 downto 0) := X"0001";

	constant REG_NEVT_INDEX                : integer := 1; -- INDEX IN ARRAY
	constant REG_NEVT_NUMBER               : std_logic_vector(15 downto 0) := X"0010"; 
	constant REG_NEVT_DEFAULT_VALUE        : std_logic_vector(15 downto 0) := X"0000";

	constant REG_CLKCNT_HIGH_INDEX          : integer := 2; -- INDEX IN ARRAY   
	constant REG_CLKCNT_HIGH_NUMBER        : std_logic_vector(15 downto 0) := X"0011"; 
	constant REG_CLKCNT_HIGH_DEFAULT_VALUE : std_logic_vector(15 downto 0) := X"0000";

	constant REG_CLKCNT_LOW_INDEX          : integer := 3; -- INDEX IN ARRAY 
	constant REG_CLKCNT_LOW_NUMBER         : std_logic_vector(15 downto 0) := X"0012"; 
	constant REG_CLKCNT_LOW_DEFAULT_VALUE  : std_logic_vector(15 downto 0) := X"0000";

	constant REG_ADCCNT_INDEX              : integer := 4; -- INDEX IN ARRAY 
	constant REG_ADCCNT_NUMBER             : std_logic_vector(15 downto 0) := X"0013"; 
	constant REG_ADCCNT_DEFAULT_VALUE      : std_logic_vector(15 downto 0) := X"0000";

	constant REG_ADCSEL_INDEX               : integer := 5; -- INDEX IN ARRAY 
	constant REG_ADCSEL_NUMBER              : std_logic_vector(15 downto 0) := X"0030"; 
	constant REG_ADCSEL_DEFAULT_VALUE       : std_logic_vector(15 downto 0) := X"0001";

	constant REG_BITSHIFT1_INDEX           : integer := 6; -- INDEX IN ARRAY 
	constant REG_BITSHIFT1_NUMBER          : std_logic_vector(15 downto 0) := X"0041"; 
	constant REG_BITSHIFT1_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0000";

	constant REG_BITSHIFT2_INDEX           : integer := 7; -- INDEX IN ARRAY 
	constant REG_BITSHIFT2_NUMBER          : std_logic_vector(15 downto 0) := X"0042"; 
	constant REG_BITSHIFT2_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0000";

	constant REG_INFO_INDEX                : integer := 8; -- INDEX IN ARRAY 
	constant REG_INFO_NUMBER               : std_logic_vector(15 downto 0) := X"000F"; 
	constant REG_INFO_DEFAULT_VALUE        : std_logic_vector(15 downto 0) := X"0007";

	constant REG_TESTREG0_INDEX            : integer := 10; -- INDEX IN ARRAY 
	constant REG_TESTREG0_NUMBER           : std_logic_vector(15 downto 0) := X"0000"; 
	constant REG_TESTREG1_INDEX            : integer := 11; -- INDEX IN ARRAY 
	constant REG_TESTREG1_NUMBER           : std_logic_vector(15 downto 0) := X"0001"; 
	constant REG_TESTREG2_INDEX            : integer := 12; -- INDEX IN ARRAY 
	constant REG_TESTREG2_NUMBER           : std_logic_vector(15 downto 0) := X"0002"; 
	constant REG_TESTREG3_INDEX            : integer := 13; -- INDEX IN ARRAY 
	constant REG_TESTREG3_NUMBER           : std_logic_vector(15 downto 0) := X"0003"; 
	constant REG_TESTREG4_INDEX            : integer := 14; -- INDEX IN ARRAY 
	constant REG_TESTREG4_NUMBER           : std_logic_vector(15 downto 0) := X"0004"; 
	constant REG_TESTREG5_INDEX            : integer := 15; -- INDEX IN ARRAY 
	constant REG_TESTREG5_NUMBER           : std_logic_vector(15 downto 0) := X"0005"; 
	constant REG_TESTREG6_INDEX            : integer := 16; -- INDEX IN ARRAY 
	constant REG_TESTREG6_NUMBER           : std_logic_vector(15 downto 0) := X"0006"; 
	constant REG_TESTREG7_INDEX            : integer := 17; -- INDEX IN ARRAY 
	constant REG_TESTREG7_NUMBER           : std_logic_vector(15 downto 0) := X"0007"; 
	constant REG_TESTREG8_INDEX            : integer := 18; -- INDEX IN ARRAY 
	constant REG_TESTREG8_NUMBER           : std_logic_vector(15 downto 0) := X"0008"; 
	constant REG_TESTREG9_INDEX            : integer := 19; -- INDEX IN ARRAY 
	constant REG_TESTREG9_NUMBER           : std_logic_vector(15 downto 0) := X"0009"; 


	constant REG_ADCTHRESH_INDEX             : integer := 20; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_NUMBER            : std_logic_vector(15 downto 0) := X"0050"; 
	constant REG_ADCTHRESH_DEFAULT_VALUE     : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_1_INDEX           : integer := 21; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_1_NUMBER          : std_logic_vector(15 downto 0) := X"0051"; 
	constant REG_ADCTHRESH_1_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_2_INDEX           : integer := 22; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_2_NUMBER          : std_logic_vector(15 downto 0) := X"0052"; 
	constant REG_ADCTHRESH_2_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";
	
	constant REG_ADCTHRESH_3_INDEX           : integer := 23; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_3_NUMBER          : std_logic_vector(15 downto 0) := X"0053"; 
	constant REG_ADCTHRESH_3_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";
	
	constant REG_ADCTHRESH_4_INDEX           : integer := 24; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_4_NUMBER          : std_logic_vector(15 downto 0) := X"0054"; 
	constant REG_ADCTHRESH_4_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";
	
	constant REG_ADCTHRESH_5_INDEX           : integer := 25; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_5_NUMBER          : std_logic_vector(15 downto 0) := X"0055"; 
	constant REG_ADCTHRESH_5_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_6_INDEX           : integer := 26; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_6_NUMBER          : std_logic_vector(15 downto 0) := X"0056"; 
	constant REG_ADCTHRESH_6_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_7_INDEX           : integer := 27; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_7_NUMBER          : std_logic_vector(15 downto 0) := X"0057"; 
	constant REG_ADCTHRESH_7_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_8_INDEX           : integer := 28; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_8_NUMBER          : std_logic_vector(15 downto 0) := X"0058"; 
	constant REG_ADCTHRESH_8_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_9_INDEX           : integer := 29; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_9_NUMBER          : std_logic_vector(15 downto 0) := X"0059"; 
	constant REG_ADCTHRESH_9_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_10_INDEX           : integer := 30; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_10_NUMBER          : std_logic_vector(15 downto 0) := X"005A"; 
	constant REG_ADCTHRESH_10_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_11_INDEX           : integer := 31; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_11_NUMBER          : std_logic_vector(15 downto 0) := X"005B"; 
	constant REG_ADCTHRESH_11_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_12_INDEX           : integer := 32; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_12_NUMBER          : std_logic_vector(15 downto 0) := X"005C"; 
	constant REG_ADCTHRESH_12_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_13_INDEX           : integer := 33; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_13_NUMBER          : std_logic_vector(15 downto 0) := X"005D"; 
	constant REG_ADCTHRESH_13_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_14_INDEX           : integer := 34; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_14_NUMBER          : std_logic_vector(15 downto 0) := X"005E"; 
	constant REG_ADCTHRESH_14_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_15_INDEX           : integer := 35; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_15_NUMBER          : std_logic_vector(15 downto 0) := X"005F"; 
	constant REG_ADCTHRESH_15_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_16_INDEX           : integer := 36; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_16_NUMBER          : std_logic_vector(15 downto 0) := X"0060"; 
	constant REG_ADCTHRESH_16_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_17_INDEX           : integer := 37; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_17_NUMBER          : std_logic_vector(15 downto 0) := X"0061"; 
	constant REG_ADCTHRESH_17_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_18_INDEX           : integer := 38; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_18_NUMBER          : std_logic_vector(15 downto 0) := X"0062"; 
	constant REG_ADCTHRESH_18_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_19_INDEX           : integer := 39; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_19_NUMBER          : std_logic_vector(15 downto 0) := X"0063"; 
	constant REG_ADCTHRESH_19_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_20_INDEX           : integer := 40; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_20_NUMBER          : std_logic_vector(15 downto 0) := X"0064"; 
	constant REG_ADCTHRESH_20_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_21_INDEX           : integer := 41; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_21_NUMBER          : std_logic_vector(15 downto 0) := X"0065"; 
	constant REG_ADCTHRESH_21_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_22_INDEX           : integer := 42; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_22_NUMBER          : std_logic_vector(15 downto 0) := X"0066"; 
	constant REG_ADCTHRESH_22_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_23_INDEX           : integer := 43; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_23_NUMBER          : std_logic_vector(15 downto 0) := X"0067"; 
	constant REG_ADCTHRESH_23_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_24_INDEX           : integer := 44; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_24_NUMBER          : std_logic_vector(15 downto 0) := X"0068"; 
	constant REG_ADCTHRESH_24_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_25_INDEX           : integer := 45; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_25_NUMBER          : std_logic_vector(15 downto 0) := X"0069"; 
	constant REG_ADCTHRESH_25_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_26_INDEX           : integer := 46; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_26_NUMBER          : std_logic_vector(15 downto 0) := X"006A"; 
	constant REG_ADCTHRESH_26_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_27_INDEX           : integer := 47; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_27_NUMBER          : std_logic_vector(15 downto 0) := X"006B"; 
	constant REG_ADCTHRESH_27_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_28_INDEX           : integer := 48; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_28_NUMBER          : std_logic_vector(15 downto 0) := X"006C"; 
	constant REG_ADCTHRESH_28_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_29_INDEX           : integer := 49; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_29_NUMBER          : std_logic_vector(15 downto 0) := X"006D"; 
	constant REG_ADCTHRESH_29_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_30_INDEX           : integer := 50; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_30_NUMBER          : std_logic_vector(15 downto 0) := X"006E"; 
	constant REG_ADCTHRESH_30_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_31_INDEX           : integer := 51; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_31_NUMBER          : std_logic_vector(15 downto 0) := X"006F"; 
	constant REG_ADCTHRESH_31_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";

	constant REG_ADCTHRESH_32_INDEX           : integer := 52; -- INDEX IN ARRAY 
	constant REG_ADCTHRESH_32_NUMBER          : std_logic_vector(15 downto 0) := X"0070"; 
	constant REG_ADCTHRESH_32_DEFAULT_VALUE   : std_logic_vector(15 downto 0) := X"0FFF";
	
	constant REG_ADCSTOP_INDEX                : integer := 53; -- INDEX IN ARRAY 
	constant REG_ADCSTOP_NUMBER               : std_logic_vector(15 downto 0) := X"0071"; 
	constant REG_ADCSTOP_DEFAULT_VALUE        : std_logic_vector(15 downto 0) := X"0080"; -- 128

	constant OPCODE_STOP                   : std_logic_vector(15 downto 0) := X"0100"; 
	constant OPCODE_START                  : std_logic_vector(15 downto 0) := X"0101"; 
	constant OPCODE_RESET                  : std_logic_vector(15 downto 0) := X"0200"; 

end reg_map;

package body reg_map is
end reg_map;


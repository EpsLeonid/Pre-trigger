library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;

use work.types.all;

package regs_info is
	constant REG_NUM_WIDTH : integer := 16;

	constant ECHO_REG_NUM     : integer := 0;
	constant ECHO_REG_WIDTH   : integer := 16;
	constant ECHO_REG_DEFAULT : integer := 165;
	
	constant COMMAND_REG0_NUM    		  : integer := 2048; -- 0x0800
		constant CMD_REG0_RESET_ADC     : integer := 0;

	constant ADC_DEL_COMP_REG_WIDTH    : integer := 3;

	constant ADC1_DEL_COMP_REG_NUM     : integer := 32; -- 0x0020
	constant ADC1_DEL_COMP_REG_DEFAULT : integer := 5;
	
	constant ADC2_DEL_COMP_REG_NUM     : integer := 33; -- 0x0021
	constant ADC2_DEL_COMP_REG_DEFAULT : integer := 5;
	
	constant ADC3_DEL_COMP_REG_NUM     : integer := 34; -- 0x0022
	constant ADC3_DEL_COMP_REG_DEFAULT : integer := 5;
	
	constant ADC4_DEL_COMP_REG_NUM     : integer := 35; -- 0x0023
	constant ADC4_DEL_COMP_REG_DEFAULT : integer := 5;
	
	constant ADC5_DEL_COMP_REG_NUM     : integer := 36; -- 0x0024
	constant ADC5_DEL_COMP_REG_DEFAULT : integer := 5;
	
	constant ADC6_DEL_COMP_REG_NUM     : integer := 37; -- 0x0025
	constant ADC6_DEL_COMP_REG_DEFAULT : integer := 5;
	
	constant ADC7_DEL_COMP_REG_NUM     : integer := 38; -- 0x0026
	constant ADC7_DEL_COMP_REG_DEFAULT : integer := 5;
	
	constant ADC8_DEL_COMP_REG_NUM     : integer := 39; -- 0x0027
	constant ADC8_DEL_COMP_REG_DEFAULT : integer := 5;
	
--	constant ADC9_DEL_COMP_REG_NUM     : integer := 40; -- 0x0028
--	constant ADC9_DEL_COMP_REG_DEFAULT : integer := 182;
--	
--	constant ADC10_DEL_COMP_REG_NUM     : integer := 41; -- 0x0029
--	constant ADC10_DEL_COMP_REG_DEFAULT : integer := 182;
--	
--	constant ADC11_DEL_COMP_REG_NUM     : integer := 42; -- 0x002A
--	constant ADC11_DEL_COMP_REG_DEFAULT : integer := 182;
--	
--	constant ADC12_DEL_COMP_REG_NUM     : integer := 43; -- 0x002B
--	constant ADC12_DEL_COMP_REG_DEFAULT : integer := 182;
--	
--	constant ADC13_DEL_COMP_REG_NUM     : integer := 44; -- 0x002C
--	constant ADC13_DEL_COMP_REG_DEFAULT : integer := 182;
--	
--	constant ADC14_DEL_COMP_REG_NUM     : integer := 45; -- 0x002D
--	constant ADC14_DEL_COMP_REG_DEFAULT : integer := 182;
--	
--	constant ADC15_DEL_COMP_REG_NUM     : integer := 46; -- 0x002E
--	constant ADC15_DEL_COMP_REG_DEFAULT : integer := 182;
--	
--	constant ADC16_DEL_COMP_REG_NUM     : integer := 47; -- 0x002F
--	constant ADC16_DEL_COMP_REG_DEFAULT : integer := 182;
	
	constant ATNR_DATA_REG_NUM     : integer := 48; -- 0x0030;
	constant ATNR_DATA_REG_WIDTH   : integer := 8;
	constant ATNR_DATA_REG_DEFAULT : integer := 0;
	
	constant ATNR_ADDR_REG_NUM     : integer := 49; -- 0x0031;
	constant ATNR_ADDR_REG_WIDTH   : integer := 6;
	constant ATNR_ADDR_REG_DEFAULT : integer := 0;
	
	constant RELAY_REG_NUM     : integer := 64; -- 0x0040;
	constant RELAY_REG_WIDTH   : integer := 16;

	constant TMPR1_REG_NUM     : integer := 72; -- 0x0048;
	constant TMPR1_REG_WIDTH   : integer := 10;
	
	constant TMPR2_REG_NUM     : integer := 73; -- 0x0049;
	constant TMPR2_REG_WIDTH   : integer := 10;

	constant SDRAM_COMMAND_REG_NUM   : integer := 256; -- 0x0100;
	constant SDRAM_COMMAND_REG_WIDTH : integer := 3;
		constant SDRAM_CMD_REG_READ   : integer := 0;
		constant SDRAM_CMD_REG_WRITE  : integer := 1;
		constant SDRAM_CMD_REG_RESET  : integer := 2;
		
	constant SDRAM_STATUS_REG_NUM   : integer := 264; -- 0x0108
	constant SDRAM_STATUS_REG_WIDTH : integer := 4;
	
	constant CH_PROC_MASK_REG_NUM     : integer := 512; -- 0x0200;
	constant CH_PROC_MASK_REG_WIDTH   : integer := 16;
	constant CH_PROC_MASK_DEFAULT     : integer := 0;

	constant CH_RAW_MASK_REG_NUM     : integer := 520; -- 0x0208;
	constant CH_RAW_MASK_REG_WIDTH   : integer := 16;
	constant CH_RAW_MASK_DEFAULT     : integer := 0;

	constant CH_HIGH_MASK_REG_NUM     : integer := 524; -- 0x020C;
	constant CH_HIGH_MASK_REG_WIDTH   : integer := 16;
	constant CH_HIGH_MASK_DEFAULT     : integer := 0;

	constant CH_PROC_NUM_REG_NUM   : integer := 528; -- 0x0210
	constant CH_PROC_NUM_REG_WIDTH : integer := 5;
	constant CH_PROC_NUM_DEFAULT   : integer := 0;
	
	constant CH_RAW_NUM_REG_NUM   : integer := 536; -- 0x0218
	constant CH_RAW_NUM_REG_WIDTH : integer := 5;
	constant CH_RAW_NUM_DEFAULT   : integer := 0;

	constant CH_HIGH_NUM_REG_NUM   : integer := 540; -- 0x021C
	constant CH_HIGH_NUM_REG_WIDTH : integer := 5;
	constant CH_HIGH_NUM_DEFAULT   : integer := 0;

	constant TRG2ADC_DATA_END_REG_NUM   : integer := 544; -- 0x0220
	constant TRG2ADC_DATA_END_REG_WIDTH : integer := 14;
	constant TRG2ADC_DATA_END_DEFAULT   : integer := 0;

	constant READ_OUT_MODE_REG_NUM   : integer := 545; -- 0x0221
	constant READ_OUT_MODE_REG_WIDTH : integer := 2;
	constant READ_OUT_MODE_DEFAULT   : integer := 0;

	constant ADC_DATA_START_REG_NUM   : integer := 546; -- 0x0222
	constant ADC_DATA_START_REG_WIDTH : integer := 6;
	constant ADC_DATA_START_DEFAULT   : integer := 0;

	constant ADC_DATA_LEN_REG_NUM   : integer := 547; -- 0x0223
	constant ADC_DATA_LEN_REG_WIDTH : integer := 6;
	constant ADC_DATA_LEN_DEFAULT   : integer := 0;

	constant Y0_START_ADDR_REG_NUM   : integer := 768; -- 0x300
	constant Y0_START_ADDR_REG_WIDTH : integer := 4;
	constant Y0_START_ADDR_DEFAULT   : integer := 0;

	constant K_X_REG_NUM   : integer := 769; -- 0x301
	constant K_X_REG_WIDTH : integer := 6;
	constant K_X_DEFAULT   : integer := 0;

	constant K_CHI_REG_NUM   : integer := 770; -- 0x302
	constant K_CHI_REG_WIDTH : integer := 4;
	constant K_CHI_DEFAULT   : integer := 0;

	constant CHI_THRESHOLD_REG_NUM   : integer := 771; -- 0x303
	constant CHI_THRESHOLD_REG_WIDTH : integer := 16;
	constant CHI_THRESHOLD_DEFAULT   : integer := 0;
	
	constant STAT_POINTER_REG_NUM   : integer := 1024; -- 0x400
	constant STAT_POINTER_REG_WIDTH : integer := 8;
	constant STAT_POINTER_DEFAULT   : integer := 0;
	
	constant STAT_CMD_REG_NUM   : integer := 1025; -- 0x401
	constant STAT_CMD_REG_WIDTH : integer := 1;
	
	constant STAT_INFO_REG_NUM   : integer := 1026; -- 0x402
	constant STAT_INFO_REG_WIDTH : integer := 16;
	
	constant BOARD_ID_REG_NUM : integer := 65520; -- 0xFFF0
	constant BOARD_ID_VALUE   : integer := 6;
	
	constant HARDWARE_VERSION_REG_NUM : integer := 65521; -- 0xFFF1
	constant HARDWARE_VERSION_VALUE    : integer := 257;  -- 0x0101 (01.01)
	
	constant FIRMWARE_VERSION_REG_NUM : integer := 65522; -- 0xFFF2
	constant FIRMWARE_VERSION_VALUE    : integer := (4096*1 + 256*1 + 3); -- 0x1103 (1.1.3)
	
	constant HW_ID0_REG_NUM     : integer := 65528; -- 0xFFF8;
	constant HW_ID0_REG_WIDTH   : integer := 16;

	constant HW_ID1_REG_NUM     : integer := 65529; -- 0xFFF9;
	constant HW_ID1_REG_WIDTH   : integer := 16;

	constant HW_ID2_REG_NUM     : integer := 65530; -- 0xFFFA;
	constant HW_ID2_REG_WIDTH   : integer := 16;

	constant HW_ID_MISC_REG_NUM     : integer := 65531; -- 0xFFFB;
	constant HW_ID_MISC_REG_WIDTH   : integer := 16;

end regs_info;

package body regs_info is
end regs_info;

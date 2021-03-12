----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19/11/2020 
-- Design Name: 
-- Module Name:    adc_deser_o - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.parameters.all;

entity adc_deser_o is
	Port ( 
		Clock_i		: in	std_logic;
		Clock_div	: in	std_logic;
		
		DATA_i		: array_next_adc;--in std_logic_vector(NUM_TrigCellNext-1 downto 0);	-- input of ADC data from Prev board
		
		SDATANextP	: out std_logic_vector(NUM_TrigCellNext-1 downto 0);	-- output of ADC data to Next board
		SDATANextN	: out std_logic_vector(NUM_TrigCellNext-1 downto 0);	-- output of ADC data to Next board
		DCOP			: out std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
		DCON			: out std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
		FCO			: out std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
		
		test			: out	std_logic_vector (15 downto 0)
	);
end adc_deser_o;

architecture Behavioral of adc_deser_o is

	signal DataShiftNext1	: std_logic_vector(NUM_TrigCellNext-1 downto 0);
	signal DataShiftNext2	: std_logic_vector(NUM_TrigCellNext-1 downto 0);
	signal ADCOutDataNext_o	: std_logic_vector(NUM_TrigCellNext-1 downto 0);

begin

	OSERDES_ADCNext: for i in 0 to NUM_TrigCellNext-1 generate 
		
		OSERDES_master : OSERDES
		generic map (
			DATA_RATE_OQ => "DDR", -- Specify data rate to "DDR" or "SDR" 
			DATA_RATE_TQ => "DDR", -- Specify data rate to "DDR", "SDR", or "BUF" 
			DATA_WIDTH => 8, -- Specify data width - For DDR: 4,6,8, or 10 
								  -- For SDR or BUF: 2,3,4,5,6,7, or 8 
			INIT_OQ => '1',  -- INIT for Q1 register - '1' or '0' 
			INIT_TQ => '0',  -- INIT for Q2 register - '1' or '0' 
			SERDES_MODE => "MASTER", --Set SERDES mode to "MASTER" or "SLAVE" 
			SRVAL_OQ => '0', -- Define Q1 output value upon SR assertion - '1' or '0' 
			SRVAL_TQ => '0', -- Define Q1 output value upon SR assertion - '1' or '0' 
			TRISTATE_WIDTH => 2) -- Specify parallel to serial converter width 
										-- When DATA_RATE_TQ = DDR: 2 or 4 
										-- When DATA_RATE_TQ = SDR or BUF: 1 " 
		port map (
			OQ => ADCOutDataNext_o(i),    -- 1-bit output
--			SHIFTOUT1 => SHIFTOUT1, -- 1-bit data expansion output
--			SHIFTOUT2 => SHIFTOUT2, -- 1-bit data expansion output
--			TQ => TQ,    -- 1-bit 3-state control output
			CLK => Clock_i,  -- 1-bit clock input
			CLKDIV => Clock_div,  -- 1-bit divided clock input
			D1 => '1',--DATA_i(i)(0),    -- 1-bit parallel data input
			D2 => '0',--DATA_i(i)(1),    -- 1-bit parallel data input
			D3 => '1',--DATA_i(i)(2),    -- 1-bit parallel data input
			D4 => '0',--DATA_i(i)(3),    -- 1-bit parallel data input
			D5 => '0',--DATA_i(i)(4),    -- 1-bit parallel data input
			D6 => '0',--DATA_i(i)(5),    -- 1-bit parallel data input
			OCE => '1',  -- 1-bit clcok enable input
			REV => '0',  -- Must be tied to logic zero
			SHIFTIN1 => DataShiftNext1(i), -- 1-bit data expansion input
			SHIFTIN2 => DataShiftNext2(i), -- 1-bit data expansion input
			SR => '0',   -- 1-bit set/reset input
			T1 => '0',   -- 1-bit parallel 3-state input
			T2 => '0',   -- 1-bit parallel 3-state input
			T3 => '0',   -- 1-bit parallel 3-state input
			T4 => '0',   -- 1-bit parallel 3-state input
			TCE => '0'  -- 1-bit 3-state signal clock enable input
		);
		
		OSERDES_slave : OSERDES
		generic map (
			DATA_RATE_OQ => "DDR", -- Specify data rate to "DDR" or "SDR" 
			DATA_RATE_TQ => "DDR", -- Specify data rate to "DDR", "SDR", or "BUF" 
			DATA_WIDTH => 8, -- Specify data width - For DDR: 4,6,8, or 10 
								  -- For SDR or BUF: 2,3,4,5,6,7, or 8 
			INIT_OQ => '1',  -- INIT for Q1 register - '1' or '0' 
			INIT_TQ => '0',  -- INIT for Q2 register - '1' or '0' 
			SERDES_MODE => "SLAVE", --Set SERDES mode to "MASTER" or "SLAVE" 
			SRVAL_OQ => '0', -- Define Q1 output value upon SR assertion - '1' or '0' 
			SRVAL_TQ => '0', -- Define Q1 output value upon SR assertion - '1' or '0' 
			TRISTATE_WIDTH => 2) -- Specify parallel to serial converter width 
										-- When DATA_RATE_TQ = DDR: 2 or 4 
										-- When DATA_RATE_TQ = SDR or BUF: 1 " 
		port map (
--			OQ => ADCOutDataNext_o(i),    -- 1-bit output
			SHIFTOUT1 => DataShiftNext1(i), -- 1-bit data expansion output
			SHIFTOUT2 => DataShiftNext2(i), -- 1-bit data expansion output
--			TQ => TQ,    -- 1-bit 3-state control output
			CLK => Clock_i,  -- 1-bit clock input
			CLKDIV => Clock_div,  -- 1-bit divided clock input
			D1 => '0',    -- 1-bit parallel data input
			D2 => '0',    -- 1-bit parallel data input
			D3 => '1',--DATA_i(i)(6),    -- 1-bit parallel data input
			D4 => '1',--DATA_i(i)(7),    -- 1-bit parallel data input
			D5 => '0',    -- 1-bit parallel data input
			D6 => '0',    -- 1-bit parallel data input
			OCE => '1',  -- 1-bit clcok enable input
			REV => '0',  -- Must be tied to logic zero
			SHIFTIN1 => '0', -- 1-bit data expansion input
			SHIFTIN2 => '0', -- 1-bit data expansion input
			SR => '0',   -- 1-bit set/reset input
			T1 => '0',   -- 1-bit parallel 3-state input
			T2 => '0',   -- 1-bit parallel 3-state input
			T3 => '0',   -- 1-bit parallel 3-state input
			T4 => '0',   -- 1-bit parallel 3-state input
			TCE => '0'  -- 1-bit 3-state signal clock enable input
		);

	end generate OSERDES_ADCNext;
	
--	ADCOutDataLVDSNext(0) <= ADCOutDataNext_o(0);
--	ADCOutDataLVDSNext_n(0) <= not ADCOutDataNext_o(0);
--	ADCOutDataLVDSNext(1) <= ADCOutDataNext_o(1);
--	ADCOutDataLVDSNext_n(1) <= not ADCOutDataNext_o(1);
--	ADCOutDataLVDSNext(3) <= ADCOutDataNext_o(3);
--	ADCOutDataLVDSNext_n(3) <= not ADCOutDataNext_o(3);
	
	LVDS_ADCNext : OBUFDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		IOSTANDARD => "DEFAULT")
	port map (
		O => SDATANextP(2),		-- Diff_p output (connect directly to top-level port)
		OB => SDATANextN(2),	-- Diff_n output (connect directly to top-level port)
		I => ADCOutDataNext_o(2)--TestCnt(2)--				-- Buffer input 
	);
	
	LVDS_buf_ADCNext: for i in 4 to NUM_TrigCellNext-1 generate 
		OBUFDS_inst : OBUFDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			IOSTANDARD => "DEFAULT")
		port map (
			O => SDATANextP(i),		-- Diff_p output (connect directly to top-level port)
			OB => SDATANextN(i),	-- Diff_n output (connect directly to top-level port)
			I => ADCOutDataNext_o(i)--TestCnt(i)--				-- Buffer input 
		);
	end generate LVDS_buf_ADCNext;
	
	FCO <= Clock_div;
	
	OBUFDS_inst : OBUFDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		IOSTANDARD => "DEFAULT")
	port map (
		O => DCOP,		-- Diff_p output (connect directly to top-level port)
		OB => DCON,	-- Diff_n output (connect directly to top-level port)
		I => Clock_i				-- Buffer input 
	);
	
end Behavioral;
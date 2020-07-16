----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:47:55 08/24/2018 
-- Design Name: 
-- Module Name:    adc_deser - Behavioral 
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

entity adc_ser_o is
	Port ( 
		Clock_i		: in	std_logic;
		
		adc_data		: in array_next_adc;
		
		DCOPrevP		: out std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
		DCOPrevN		: out std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
		
		SDATAPrevP	: out std_logic_vector(NUM_TrigCellNext-1 downto 0);	-- input of ADC data from Prev board
		SDATAPrevN	: out std_logic_vector(NUM_TrigCellNext-1 downto 0);	-- input of ADC data from Prev board
		
		test 				: out	std_logic_vector (15 downto 0)
	);
end adc_deser;

architecture Behavioral of adc_deser is

	signal DCO			: std_logic;	-- 
	signal FCO			: std_logic;	-- 
	signal SDATA		: std_logic_vector(NUM_TrigCellNext-1 downto 0);	-- input of data from ADC	

begin

-- Input LVDS ADC DCO buffer
LVDS_ADC_DCO: for i in 0 to NUM_TrigCellNext-1 generate 
	LVDS_signal : IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => DCO(i),  -- Buffer output
			I => DCOP(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => DCON(i) -- Diff_n buffer input (connect directly to top-level port)
		);
	o_dco(i) <= DCO(i);
end generate LVDS_ADC_DCO;

-- Input LVDS ADC FCO buffer
LVDS_ADC_FCO: for i in 0 to NUM_TrigCellNext-1 generate 
	LVDS_signal : IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => FCO(i),  -- Buffer output
			I => FCOP(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => FCON(i) -- Diff_n buffer input (connect directly to top-level port)
		);
end generate LVDS_ADC_FCO;

-- Input LVDS ADC buffer

LVDS_buf_ADC: for i in 0 to NUM_TrigCell-1 generate 

	LVDS_signal : IBUFDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => SDATA(i),  -- Buffer output
			I => SDATAP(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => SDATAN(i) -- Diff_n buffer input (connect directly to top-level port)
		);

	SERDES : entity work.ISERDES_8bit 
	port map (
				DataIn 	=> SDATA(i),	-- input of data from ADC by bits
				Clock		=> DCO(i/4),--Clock_i,
--				ClkDiv	=> DCODiv(i/4),
				DataOut	=> o_adc_data(i)
				);

end generate LVDS_buf_ADC;

LVDS_buf_ADC: for i in 0 to NUM_TrigCell-1 generate 

	SERDES : entity work.ISERDES_8bit 
	port map (
				DataIn 	=> SDATA(i),	-- input of data from ADC by bits
				Clock		=> DCO(i/4),--Clock_i,
--				ClkDiv	=> DCODiv(i/4),
				DataOut	=> o_adc_data(i)
				);

	OBUFDS_inst : OBUFDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		IOSTANDARD => "LVDS_25")
	port map (
		O => O,     -- Diff_p output (connect directly to top-level port)
		OB => OB,   -- Diff_n output (connect directly to top-level port)
		I => I      -- Buffer input 
	);

end generate LVDS_buf_ADC;

end Behavioral;
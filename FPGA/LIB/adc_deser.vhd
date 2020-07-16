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

entity adc_deser is
	Port ( 
	Clock_i		: in	std_logic;
	
	SDATAP		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	
	SDATAN		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	
	SDATAPrevP	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of ADC data from Prev board
	SDATAPrevN	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of ADC data from Prev board

	DCOP			: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	DCON			: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	FCOP			: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	FCON			: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	DCOPrevP		: in std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	DCOPrevN		: in std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	
	o_adc_data	: out array_adc;
	o_dco			: out std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	o_adc_data_prev	: out array_prev_adc;
	o_dco_prev			: out std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0)	-- 
	)
end adc_deser;

architecture Behavioral of adc_deser is

	signal DCO			: std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
--	signal DCODiv		: std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	signal FCO			: std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	signal SDATA		: std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	

	signal DCOPrev		: std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	signal SDATAPrev	: std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of ADC data from Prev board 

begin

-- Input LVDS ADC DCO buffer
LVDS_ADC_DCO: for i in 0 to NUM_TrigCell/4-1 generate 
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
LVDS_ADC_FCO: for i in 0 to NUM_TrigCell/4-1 generate 
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

-- Input LVDS ADC DCO buffer from prev.board
LVDS_ADC_DCOPrev: for i in 0 to NUM_TrigCellPrev-1 generate 
	LVDS_signal : IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => DCOPrev(i),  -- Buffer output
			I => DCOPrevP(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => DCOPrevN(i) -- Diff_n buffer input (connect directly to top-level port)
		);
	o_dco_prev(i) <= DCOPrev(i);
end generate LVDS_ADC_DCOPrev;

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

-- Input LVDS ADC buffer from prev.board
LVDS_buf_ADCPrev: for i in 0 to NUM_TrigCellPrev-1 generate 
	LVDS_signal : IBUFDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => SDATAPrev(i),  -- Buffer output
			I => SDATAPrevP(i),  -- Diff_p buffer input (connect directly to top-level port)
			IB => SDATAPrevN(i) -- Diff_n buffer input (connect directly to top-level port)
		);

	SERDES : entity work.ISERDES_8bit 
	port map  (
		DataIn 	=> SDATAPrev(i),	-- input of data from ADC by bits
		Clock		=> DCOPrev(i),--Clock_i,
--		ClkDiv	=> DCODivPrev(i/4),
		DataOut	=> o_adc_data_prev(i)
				 );

end generate LVDS_buf_ADCPrev;

end Behavioral;


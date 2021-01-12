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
		Clock_ctrl	: in	std_logic;
		
		SDATAP		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	
		SDATAN		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	
		SDATAPrevP	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of ADC data from Prev board
		SDATAPrevN	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of ADC data from Prev board

		DCOP			: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
		DCON			: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
		FCO			: in std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
		DCOPrevP		: in std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
		DCOPrevN		: in std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
		FCOPrev		: in std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
		
		o_adc_data	: out array_adc;
		o_dco			: out std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
		o_adc_data_prev	: out array_prev_adc;
		o_dco_prev			: out std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0)	-- 
		
		SetReset		: in  std_logic;
		
		test 			: out	std_logic_vector (15 downto 0)
	);
	

end adc_deser;

architecture Behavioral of adc_deser is

	signal ctrl_rdy	: std_logic;
	signal set_ctrl_rdy: std_logic;

	signal DCO			: std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
--	signal DCODiv		: std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
--	signal FCO			: std_logic_vector(NUM_TrigCell/4-1 downto 0);	-- 
	signal SDATA		: std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	
	signal ShiftSData1: std_logic_vector(NUM_TrigCell-1 downto 0);--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	signal ShiftSData2: std_logic_vector(NUM_TrigCell-1 downto 0);--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	signal adc_data	: array_adc;
	signal adc_data_sh : array_adc;
	
	signal DlyCE		: std_logic_vector(NUM_TrigCell-1 downto 0) := (others => '0');

	signal DCOPrev		: std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
--	signal FCOPrev		: std_logic;--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	signal SDATAPrev	: std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of ADC data from Prev board 
	signal ShiftSDATAPrev1		: std_logic_vector(NUM_TrigCell-1 downto 0);--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	signal ShiftSDATAPrev2		: std_logic_vector(NUM_TrigCell-1 downto 0);--std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- 
	
--	attribute IODELAY_GROUP : string;
--	attribute IODELAY_GROUP of IDELAYCTRL_ADC : label is "IDELAYCTRL_ADC_i";
	

begin

	IDELAYCTRL_ADC : IDELAYCTRL
	port map (
		RDY => ctrl_rdy,       -- 1-bit output indicates validity of the REFCLK
		REFCLK => Clock_ctrl, -- 1-bit reference clock input
		RST => SetReset        -- 1-bit reset input
	);
	Set_ctrl : entity work.SRFF 
	port map (
		S		=> ctrl_rdy,
		CLK	=> Clock_ctrl,
		R		=> SetReset,
		q		=> set_ctrl_rdy
	);

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

--		FCO_i : IBUFG
--		generic map (
--			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE"   
--			IOSTANDARD => "DEFAULT")
--		port map (
--			O => o_fco(i), -- Clock buffer output
--			I => FCO(i)  -- Clock buffer input (connect directly to top-level port)
--		);

	end generate LVDS_ADC_DCO;

	-- Input LVDS ADC DCO buffer from prev.board
	LVDS_ADC_DCOPrev: IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => DCOPrev,  -- Buffer output
			I => DCOPrevP,  -- Diff_p buffer input (connect directly to top-level port)
			IB => DCOPrevN -- Diff_n buffer input (connect directly to top-level port)
		);
	o_dco_prev <= DCOPrev;

	-- Input LVDS ADC buffer

	process(Clock_i)
--		variable j : integer range 0 to 10;
	begin
		if rising_edge(Clock_i) then
			for i in 0 to NUM_TrigCell-1 loop 
--			j := 0;
				for j in 0 to 64 loop
					if (adc_data_sh(i) /= "10100011") then DlyCE(i) <= '1';
																 else DlyCE(i) <= '0';
					end if;
--					j := j+1;
				end loop;
			end loop;
		end if;
	end process;

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
--	end generate;

--		ShiftADCData: for j in 0 to 63 generate 
			ISERDES_master : ISERDES
			generic map (
				BITSLIP_ENABLE => TRUE, -- TRUE/FALSE to enable bitslip controller
													-- Must be "FALSE" in interface type is "MEMORY" 
				DATA_RATE => "DDR", -- Specify data rate of "DDR" or "SDR" 
				DATA_WIDTH => 8, -- Specify data width - For DDR 4,6,8, or 10 
									  -- For SDR 2,3,4,5,6,7, or 8 
				INTERFACE_TYPE => "NETWORKING", -- Use model - "MEMORY" or "NETWORKING" 
				IOBDELAY => "BOTH", -- Specify outputs where delay chain will be applied
										  -- "NONE", "IBUF", "IFD", or "BOTH" 
				IOBDELAY_TYPE => "VARIABLE", -- Set tap delay "DEFAULT", "FIXED", or "VARIABLE" 
				IOBDELAY_VALUE => 0, -- Set initial tap delay to an integer from 0 to 63
				NUM_CE => 1, -- Define number or clock enables to an integer of 1 or 2
				SERDES_MODE => "MASTER") --Set SERDES mode to "MASTER" or "SLAVE" 
			port map (
				Q1 => adc_data(i)(7),  -- 1-bit output
				Q2 => adc_data(i)(6),  -- 1-bit output
				Q3 => adc_data(i)(5),  -- 1-bit output
				Q4 => adc_data(i)(4),  -- 1-bit output
				Q5 => adc_data(i)(3),  -- 1-bit output
				Q6 => adc_data(i)(2),  -- 1-bit output
				SHIFTOUT1 => ShiftSData1(i), -- 1-bit output
				SHIFTOUT2 => ShiftSData2(i), -- 1-bit output
				BITSLIP => '0',     -- 1-bit input
				CE1 => set_ctrl_rdy,        -- 1-bit input
				CE2 => '1',        -- 1-bit input
				CLK => DCO(i/4),        -- 1-bit input
				CLKDIV => FCO(i/4),  -- 1-bit input
				D => SDATA(i),            -- 1-bit input
				DLYCE => DlyCE(i),    -- 1-bit input
				DLYINC => '1',  -- 1-bit input
				DLYRST => '0',  -- 1-bit input
				OCLK => '0',      -- 1-bit input
				REV => '0',        -- Must be tied to logic zero
				SHIFTIN1 => '0', -- 1-bit input
				SHIFTIN2 => '0', -- 1-bit input
				SR => '0'           -- 1-bit input
			);
			ISERDES_slave : ISERDES
			generic map (
				BITSLIP_ENABLE => TRUE, -- TRUE/FALSE to enable bitslip controller
													-- Must be "FALSE" in interface type is "MEMORY" 
				DATA_RATE => "DDR", -- Specify data rate of "DDR" or "SDR" 
				DATA_WIDTH => 8, -- Specify data width - For DDR 4,6,8, or 10 
									  -- For SDR 2,3,4,5,6,7, or 8 
				INTERFACE_TYPE => "NETWORKING", -- Use model - "MEMORY" or "NETWORKING" 
				IOBDELAY => "BOTH", -- Specify outputs where delay chain will be applied
										  -- "NONE", "IBUF", "IFD", or "BOTH" 
				IOBDELAY_TYPE => "FIXED", -- Set tap delay "DEFAULT", "FIXED", or "VARIABLE" 
				IOBDELAY_VALUE => 0, -- Set initial tap delay to an integer from 0 to 63
				NUM_CE => 1, -- Define number or clock enables to an integer of 1 or 2
				SERDES_MODE => "SLAVE") --Set SERDES mode to "MASTER" or "SLAVE" 
			port map (
				Q1 => open,  -- 1-bit output
				Q2 => open,  -- 1-bit output
				Q3 => adc_data(i)(1),  -- 1-bit output
				Q4 => adc_data(i)(0),  -- 1-bit output
				Q5 => open,  -- 1-bit output
				Q6 => open,  -- 1-bit output
				SHIFTOUT1 => open, -- 1-bit output
				SHIFTOUT2 => open, -- 1-bit output
				BITSLIP => '0',     -- 1-bit input
				CE1 => set_ctrl_rdy,        -- 1-bit input
				CE2 => '1',        -- 1-bit input
				CLK => DCO(i/4),        -- 1-bit input
				CLKDIV => FCO(i/4),  -- 1-bit input
				D => '0',            -- 1-bit input
				DLYCE => '1',    -- 1-bit input
				DLYINC => '1',  -- 1-bit input
				DLYRST => '0',  -- 1-bit input
				OCLK => '0',      -- 1-bit input
				REV => '0',        -- Must be tied to logic zero
				SHIFTIN1 => ShiftSData1(i), -- 1-bit input
				SHIFTIN2 => ShiftSData2(i), -- 1-bit input
				SR => '0'           -- 1-bit input
			);
			
--			case o_adc_data(i) is 
--				when "10100011" => ADCDataDelay(i) <= j;
--				when others 	 => ADCDataDelay(i) <= "000000";
--			end case;
--		end generate ShiftADCData;
		
--		SERDES : entity work.ISERDES_8bit 
--		port map (
--					DataIn 	=> SDATA(i),	-- input of data from ADC by bits
--					Clock		=> DCO(i/4),--Clock_i,
--	--				ClkDiv	=> DCODiv(i/4),
--					DataOut	=> o_adc_data(i)
--					);
	end generate LVDS_buf_ADC;
	
	adc_data_sh <= adc_data;
	o_adc_data <= adc_data;
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

		ISERDES_master : ISERDES
		generic map (
			BITSLIP_ENABLE => TRUE, -- TRUE/FALSE to enable bitslip controller
												-- Must be "FALSE" in interface type is "MEMORY" 
			DATA_RATE => "DDR", -- Specify data rate of "DDR" or "SDR" 
			DATA_WIDTH => 8, -- Specify data width - For DDR 4,6,8, or 10 
								  -- For SDR 2,3,4,5,6,7, or 8 
			INTERFACE_TYPE => "NETWORKING", -- Use model - "MEMORY" or "NETWORKING" 
			IOBDELAY => "NONE", -- Specify outputs where delay chain will be applied
									  -- "NONE", "IBUF", "IFD", or "BOTH" 
			IOBDELAY_TYPE => "DEFAULT", -- Set tap delay "DEFAULT", "FIXED", or "VARIABLE" 
			IOBDELAY_VALUE => 0, -- Set initial tap delay to an integer from 0 to 63
			NUM_CE => 1, -- Define number or clock enables to an integer of 1 or 2
			SERDES_MODE => "MASTER") --Set SERDES mode to "MASTER" or "SLAVE" 
		port map (
			Q1 => o_adc_data_prev(i)(7),  -- 1-bit output
			Q2 => o_adc_data_prev(i)(6),  -- 1-bit output
			Q3 => o_adc_data_prev(i)(5),  -- 1-bit output
			Q4 => o_adc_data_prev(i)(4),  -- 1-bit output
			Q5 => o_adc_data_prev(i)(3),  -- 1-bit output
			Q6 => o_adc_data_prev(i)(2),  -- 1-bit output
			SHIFTOUT1 => ShiftSDATAPrev1(i), -- 1-bit output
			SHIFTOUT2 => ShiftSDATAPrev2(i), -- 1-bit output
			BITSLIP => '0',     -- 1-bit input
			CE1 => '1',        -- 1-bit input
			CE2 => '1',        -- 1-bit input
			CLK => DCOPrev,        -- 1-bit input
			CLKDIV => FCOPrev,  -- 1-bit input
			D => SDATAPrev(i),            -- 1-bit input
			DLYCE => '0',    -- 1-bit input
			DLYINC => '0',  -- 1-bit input
			DLYRST => '0',  -- 1-bit input
			OCLK => '0',      -- 1-bit input
			REV => '0',        -- Must be tied to logic zero
			SHIFTIN1 => '0', -- 1-bit input
			SHIFTIN2 => '0', -- 1-bit input
			SR => '0'           -- 1-bit input
		);
		ISERDES_slave : ISERDES
		generic map (
			BITSLIP_ENABLE => TRUE, -- TRUE/FALSE to enable bitslip controller
												-- Must be "FALSE" in interface type is "MEMORY" 
			DATA_RATE => "DDR", -- Specify data rate of "DDR" or "SDR" 
			DATA_WIDTH => 8, -- Specify data width - For DDR 4,6,8, or 10 
								  -- For SDR 2,3,4,5,6,7, or 8 
			INTERFACE_TYPE => "NETWORKING", -- Use model - "MEMORY" or "NETWORKING" 
			IOBDELAY => "NONE", -- Specify outputs where delay chain will be applied
									  -- "NONE", "IBUF", "IFD", or "BOTH" 
			IOBDELAY_TYPE => "DEFAULT", -- Set tap delay "DEFAULT", "FIXED", or "VARIABLE" 
			IOBDELAY_VALUE => 0, -- Set initial tap delay to an integer from 0 to 63
			NUM_CE => 1, -- Define number or clock enables to an integer of 1 or 2
			SERDES_MODE => "SLAVE") --Set SERDES mode to "MASTER" or "SLAVE" 
		port map (
			Q1 => open,  -- 1-bit output
			Q2 => open,  -- 1-bit output
			Q3 => o_adc_data_prev(i)(1),  -- 1-bit output
			Q4 => o_adc_data_prev(i)(0),  -- 1-bit output
			Q5 => open,  -- 1-bit output
			Q6 => open,  -- 1-bit output
			SHIFTOUT1 => open, -- 1-bit output
			SHIFTOUT2 => open, -- 1-bit output
			BITSLIP => '0',     -- 1-bit input
			CE1 => '1',        -- 1-bit input
			CE2 => '1',        -- 1-bit input
			CLK => DCOPrev,        -- 1-bit input
			CLKDIV => FCOPrev,  -- 1-bit input
			D => '0',            -- 1-bit input
			DLYCE => '0',    -- 1-bit input
			DLYINC => '0',  -- 1-bit input
			DLYRST => '0',  -- 1-bit input
			OCLK => '0',      -- 1-bit input
			REV => '0',        -- Must be tied to logic zero
			SHIFTIN1 => ShiftSDATAPrev1(i), -- 1-bit input
			SHIFTIN2 => ShiftSDATAPrev2(i), -- 1-bit input
			SR => '0'           -- 1-bit input
		);

	--	SERDES : entity work.ISERDES_8bit 
	--	port map  (
	--		DataIn 	=> SDATAPrev(i),	-- input of data from ADC by bits
	--		Clock		=> DCOPrev,--Clock_i,
	----		ClkDiv	=> DCODivPrev(i/4),
	--		DataOut	=> o_adc_data_prev(i)
	--				 );

	end generate LVDS_buf_ADCPrev;

end Behavioral;
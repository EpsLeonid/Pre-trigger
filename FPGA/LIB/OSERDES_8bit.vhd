----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:
-- Design Name: 
-- Module Name:		OSERDES_8bit - Behavioral 
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

entity OSERDES_8bit is
port (

	DataIn	: in std_logic_vector(ADC_Bits-1 downto 0):= (others => '0');
	Clock		: in std_logic;
--	Clk_Div	: in std_logic;
	Rst		: in std_logic := '0';
	
	DataOut 	: out std_logic := '0';	-- input of data from ADC by bits
	Test_ods	: out std_logic_vector(1 downto 0):= (others => '0')
	
	);
end OSERDES_8bit;

architecture Behavioral of OSERDES_8bit is

	signal clkdiv	: std_logic_vector(1 downto 0):= (others => '0');
	signal clkdiv_es: std_logic;
	signal clkdiv_a: std_logic;
	signal clkdiv_b: std_logic;
	signal Data_p	: std_logic := '0';
	signal Data_n	: std_logic := '0';
	signal DataP	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal DataN	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal Data		: std_logic;

begin

	Clk_div_es: process(Clock)
	begin
		if(rising_edge(Clock)) then
			clkdiv <= clkdiv + '1';
			clkdiv_a <= (clkdiv(0) and not clkdiv(1));
			clkdiv_b <= clkdiv_a;
			if clkdiv_a = '1' and clkdiv_b = '0' then
				clkdiv_es <= '1';
			else clkdiv_es <= '0';
			end if;
		end if;
	end process Clk_div_es;
	
	adc_data: process(Clock)
	begin
		if(rising_edge(Clock)) then
			if clkdiv_es = '1' then
				DataN(0) <= DataIn(0) ;
				DataP(0) <= DataIn(1);
				DataN(1) <= DataIn(2);
				DataP(1) <= DataIn(3);
				DataN(2) <= DataIn(4);
				DataP(2) <= DataIn(5);
				DataN(3) <= DataIn(6);
				DataP(3) <= DataIn(7);
			end if;
		end if;
	end process adc_data;

	DDR_Reg_P: for i in 0 to 2 generate
		DDR_Reg_pos: process(Clock)
		begin
			if(rising_edge(Clock)) then
				if Rst ='1' then 
					DataP(i+1) <= '0';
				else 
					DataP(i+1) <= DataP(i);
				end if;
			end if;
		end process DDR_Reg_pos;
	end generate;

	DDR_Reg_N: for i in 0 to 2 generate
		DDR_Reg_neg: process(Clock)
		begin
			if(rising_edge(Clock)) then
				if Rst ='1' then 
					DataN(i+1) <= '0';
				else 
					DataN(i+1) <= DataN(i);
				end if;
			end if;
		end process DDR_Reg_neg;
	end generate;
	
	DDR_Reg: process(Clock)
	begin
		if(rising_edge(Clock)) then
			if Rst ='1' then 
				Data_p <= '0';
				Data_n <= '0';
			else 
				Data_p <= DataP(0);
				Data_n <= DataN(0);
			end if;
		end if;
	end process;
	
	ODDR_inst : ODDR
	generic map(
		DDR_CLK_EDGE => "OPPOSITE_EDGE",	-- "OPPOSITE_EDGE" or "SAME_EDGE" 
		INIT => '0',							-- Initial value for Q port ('1' or '0')
		SRTYPE => "SYNC")						-- Reset Type ("ASYNC" or "SYNC")
	port map (
		Q => Data,	-- 1-bit DDR output
		C => Clock,	-- 1-bit clock input
		CE => '1',		-- 1-bit clock enable input
		D1 => Data_p,	-- 1-bit data input (positive edge)
		D2 => Data_n,	-- 1-bit data input (negative edge)
		R => '0',		-- 1-bit reset input
		S => '1'			-- 1-bit set input
	);
	
	DataOut <= Data;
	
	Test_ods(0) <= DataP(0);--Clock;
	Test_ods(1) <= DataN(0);--clkdiv_es;
--	Test_ods(2) <= DataP(0);
--	Test_ods(3) <= DataN(0);
--	Test_ods(4) <= Data;
	
end Behavioral;
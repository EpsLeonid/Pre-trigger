----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:04 08/15/2018 
-- Design Name: 
-- Module Name:    ISERDES_8bit - Behavioral 
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

entity ISERDES_8bit is
port (

	DataIn 	: in std_logic := '0';	-- input of data from ADC by bits
	Clock		: in std_logic;
	Clk_Div	: out std_logic;
	Rst		: in std_logic := '0';
	Test		: in std_logic := '0';
	DataOut	: out std_logic_vector(ADC_Bits-1 downto 0):= (others => '0')
	
--	Test		: out std_logic_vector(15 downto 0):= (others => '0')
	
	);
end ISERDES_8bit;

architecture Behavioral of ISERDES_8bit is

	signal shift	: std_logic_vector(2 downto 0):= (others => '0');
--	signal shift2	: std_logic;
	signal clkdiv	: std_logic_vector(1 downto 0):= (others => '0');
	signal clkdiv_es: std_logic;
	signal clkdiv_a: std_logic;
	signal clkdiv_b: std_logic;
	signal Data_p	: std_logic := '0';
	signal Data_n	: std_logic := '0';
	signal DataP	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal DataN	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal Data		: std_logic_vector(ADC_Bits-1 downto 0):= (others => '0');

begin

--	DivClk: BUFR generic map (
--      BUFR_DIVIDE => "4",   -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8" 
--      SIM_DEVICE => "VIRTEX4")   -- Specify target device, "VIRTEX4", "VIRTEX5", "VIRTEX6" 
--   port map (
--      O => clkdiv,     -- Clock buffer output
--      CE => '1',   -- Clock enable input
--      CLR => '0', -- Clock buffer reset input
--      I => Clock      -- Clock buffer input
--   );	

	IDDR_inst : IDDR 
	generic map (
		DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE", "SAME_EDGE" 
													-- or "SAME_EDGE_PIPELINED" 
		INIT_Q1 => '0', -- Initial value of Q1: '0' or '1'
		INIT_Q2 => '0', -- Initial value of Q2: '0' or '1'
		SRTYPE => "SYNC") -- Set/Reset type: "SYNC" or "ASYNC" 
	port map (
		Q1 => Data_p,	-- 1-bit output for positive edge of clock 
		Q2 => Data_n,	-- 1-bit output for negative edge of clock
		C => Clock,		-- 1-bit clock input
		CE => '1',		-- 1-bit clock enable input
		D => DataIn,	-- 1-bit DDR data input
		R => Rst,		-- 1-bit reset
		S => '0'			-- 1-bit set
	);

	DDR_Reg: process(Clock)
	begin
		if(rising_edge(Clock)) then
			if Rst ='1' then 
				DataP(0) <= '0';
				DataN(0) <= '0';
			else 
				DataP(0) <= Data_p;
				DataN(0) <= Data_n;
			end if;
		end if;
	end process;

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
	
--	DivClk : entity work.ClkDiv
--	port map (
--				i_clk => Clock,	-- input of data clock from ADC 
--				o_clk	=> clkdiv	-- output of data clock divided by 4 and delay to 3125 ps (frame clock)
--				);
	
	Clk_Div <= clkdiv(1);
	
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
	
--	shift_frame: process (clkdiv, shift)
--		begin
--		case shift is 
--			when "000" => clkdiv_a <= (not Clock and not clkdiv(0) and not clkdiv(1));
--			when "001" => clkdiv_a <= (Clock and not clkdiv(0) and not clkdiv(1));
--			when "010" => clkdiv_a <= (not Clock and clkdiv(0) and not clkdiv(1));
--			when "011" => clkdiv_a <= (Clock and clkdiv(0) and not clkdiv(1));
--			when "100" => clkdiv_a <= (not Clock and not clkdiv(0) and clkdiv(1));
--			when "101" => clkdiv_a <= (Clock and not clkdiv(0) and clkdiv(1));
--			when "110" => clkdiv_a <= (not Clock and clkdiv(0) and clkdiv(1));
--			when "111" => clkdiv_a <= (Clock and clkdiv(0) and clkdiv(1));
--			when others => clkdiv_a <= (not Clock and not clkdiv(0) and not clkdiv(1));
--		end case;
--	end process shift_frame;
	
	adc_data: process(Clock)
	begin
		if(rising_edge(Clock)) then
			if clkdiv_es = '1' then
				DataOut(0) <= DataN(0);
				DataOut(1) <= DataP(0);
				DataOut(2) <= DataN(1);
				DataOut(3) <= DataP(1);
				DataOut(4) <= DataN(2);
				DataOut(5) <= DataP(2);
				DataOut(6) <= DataN(3);
				DataOut(7) <= DataP(3);
			end if;
		end if;
	end process adc_data;

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:21:18 08/15/2018 
-- Design Name: 
-- Module Name:    adc_ctrl_i - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity adc_ctrl_i is
	port (
			
			Clock			: in	std_logic;			-- Pin 
			ADC_Test		: in	std_logic := '0';	-- Pin 
			ADC_Reset	: in	std_logic := '0';	-- Pin 

			ADC_CSB		: out std_logic := '1';	-- Pin 
			ADC_SDIO		: out std_logic := '0';	-- Pin 
			ADC_SCLK		: out std_logic := '0'	-- Pin 
			
			);
end adc_ctrl_i;

architecture Behavioral of adc_ctrl_i is

	signal s_fadc_csb			: std_logic := '1';
	signal s_fadc_sdio_test	: STD_LOGIC_VECTOR(49 downto 0) := "00000000000011010000110000000000001111111100000001";
--																			     "set	addr		  data	set  addr			 data "
--																				   3bit 13bit		  8bit	3bit 13bit			 8bit
-- Data from ADC must be 10 0110 0011 for 10-bits ADC
-- Data from ADC must be	1010 0011 for 8-bits ADC
	signal s_fadc_sdio_reset: STD_LOGIC_VECTOR(49 downto 0) := "00000000000011010000000000000000001111111100000001";
--																			     "set	addr		  data	set  addr			 data "
	signal s_fadc_sclk		: std_logic := '0';
	signal test					: std_logic := '0';
	signal shift_sdio_test	: std_logic;
	signal reset				: std_logic := '0';
	signal shift_sdio_reset	: std_logic;

begin

	s_fadc_sclk <= Clock;

	process(s_fadc_sclk)
	begin
		if rising_edge(s_fadc_sclk) then
			if 	test = '1' 			 then ADC_SDIO <= shift_sdio_test;
													ADC_CSB <= '0';
													ADC_SCLK <= s_fadc_sclk;
			elsif reset = '1' 		 then ADC_SDIO <= shift_sdio_reset;
													ADC_CSB <= '0';
													ADC_SCLK <= s_fadc_sclk;
											 else ADC_SDIO <= '0';
													ADC_CSB <= '1';
													ADC_SCLK <= '0';
			end if;
		end if;
	end process;

	ShiftReg_test : entity work.ShiftReg 
		generic map (WIDTH => 50) 
		port map (
			CLK	=> Clock,
			SI		=> s_fadc_sdio_test,
			SO		=> shift_sdio_test
		);

	ShiftReg_reset : entity work.ShiftReg 
		generic map (WIDTH => 50) 
		port map (
			CLK	=> Clock,
			SI		=> s_fadc_sdio_reset,
			SO		=> shift_sdio_reset
		);

end Behavioral;


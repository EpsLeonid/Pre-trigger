library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.parameters.all;

entity adc_phase_delay_ROM is
	generic (data_width : natural := 6;
				word_width : natural := 5); 
	port (clock_i	: in std_logic;
			ena		: in std_logic;
			addr		: in std_logic_vector(4 downto 0);
			data_o	: out std_logic_vector(5 downto 0));
end adc_phase_delay_ROM;

architecture syn of adc_phase_delay_ROM is
	type rom_type is array (31 downto 0) of std_logic_vector (5 downto 0);
	signal ROM : rom_type:= (b"000000", b"000000", b"000000", b"000000", b"000000", b"000000", b"000000", b"000000",
									 b"000000", b"000000", b"000000", b"000000", b"000000", b"000000", b"000000", b"000000",
									 b"000000", b"000000", b"000000", b"000000", b"000000", b"000000", b"000000", b"000000",
									 b"000000", b"000000", b"000000", b"000000", b"000000", b"000000", b"000000", b"000000");

	signal rdata : std_logic_vector(5 downto 0);

begin

	rdata <= ROM(conv_integer(addr));

	process (clock_i)
	begin
		if (clock_i'event and clock_i = '1') then
			if (ena = '1') then
				 data_o <= rdata;
			end if;
		end if;
	end process;

end syn;

				
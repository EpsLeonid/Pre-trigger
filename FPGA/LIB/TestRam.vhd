----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:46:34 12/06/2018 
-- Design Name: 
-- Module Name:    TestRam - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;

library UNISIM;
use UNISIM.VComponents.all;

entity TestRam is
	GENERIC (Size  : NATURAL := 256;
				WIDTH	: NATURAL := 16); 
	port (CLK	: in std_logic;
			WE		: in std_logic;
			EN		: in std_logic;
			Load	: in std_logic;
			ADDR	: in std_logic_vector(7 downto 0);
			DI		: in std_logic_vector(WIDTH-1 downto 0);
			DO		: out std_logic_vector(WIDTH-1 downto 0));
end TestRam;

architecture Behavioral of TestRam is
	type ram_type is array (Size-1 downto 0) of std_logic_vector (WIDTH-1 downto 0);
	signal RamData : ram_type:=(X"0000", X"0001", X"0002", X"0003", X"0004", X"0005", X"0006", X"0007", 
									  X"0008", X"0009", X"000A", X"000B", X"000C", X"000D", X"000E", X"000F", 
									  X"0010", X"0011", X"0012", X"0013", X"0014", X"0015", X"0016", X"0017", 
									  X"0018", X"0019", X"001A", X"001B", X"001C", X"001D", X"001E", X"001F", 
									  X"0020", X"0021", X"0022", X"0023", X"0024", X"0025", X"0026", X"0027", 
									  X"0028", X"0029", X"002A", X"002B", X"002C", X"002D", X"002E", X"002F", 
									  X"0030", X"0031", X"0032", X"0033", X"0034", X"0035", X"0036", X"0037", 
									  X"0038", X"0039", X"003A", X"003B", X"003C", X"003D", X"003E", X"003F", 
									  X"0040", X"0041", X"0042", X"0043", X"0044", X"0045", X"0046", X"0047", 
									  X"0048", X"0049", X"004A", X"004B", X"004C", X"004D", X"004E", X"004F", 
									  X"0050", X"0051", X"0052", X"0053", X"0054", X"0055", X"0056", X"0057", 
									  X"005A", X"005D", X"0060", X"0063", X"0066", X"0069", X"006C", X"006F", 
									  X"0072", X"0075", X"0078", X"007B", X"007E", X"0081", X"0084", X"0087", 
									  X"008A", X"008D", X"0090", X"0093", X"0096", X"0099", X"009C", X"009F", 
									  X"00A2", X"00A5", X"00A8", X"00AB", X"00AE", X"00B1", X"00B4", X"00B7", 
									  X"00B4", X"00B2", X"00B0", X"00AE", X"00AC", X"00AA", X"00A8", X"00A6", 
									  X"00A4", X"00A2", X"00A0", X"009E", X"009C", X"009A", X"0098", X"0096", 
									  X"0094", X"0092", X"0090", X"008E", X"008C", X"008A", X"0088", X"0086", 
									  X"0084", X"0082", X"0080", X"007E", X"007C", X"007A", X"0078", X"0076", 
									  X"0074", X"0072", X"0070", X"006E", X"006C", X"006A", X"0068", X"0066", 
									  X"0064", X"0063", X"0062", X"0061", X"0060", X"005F", X"005E", X"005D", 
									  X"005C", X"005B", X"005A", X"0059", X"0058", X"0057", X"0056", X"0055", 
									  X"0054", X"0053", X"0052", X"0051", X"0050", X"004F", X"004E", X"004D", 
									  X"004C", X"004B", X"004A", X"0049", X"0048", X"0047", X"0046", X"0045", 
									  X"0044", X"0043", X"0042", X"0041", X"0040", X"003F", X"003E", X"003D", 
									  X"003C", X"003B", X"003A", X"0039", X"0038", X"0037", X"0036", X"0035", 
									  X"0034", X"0033", X"0032", X"0031", X"0030", X"002F", X"002E", X"002D", 
									  X"002C", X"002B", X"002A", X"0029", X"0028", X"0027", X"0026", X"0025", 
									  X"0024", X"0023", X"0022", X"0021", X"0020", X"001F", X"001E", X"001D", 
									  X"001C", X"001B", X"001A", X"0019", X"0018", X"0017", X"0016", X"0015", 
									  X"0014", X"0013", X"0012", X"0011", X"0010", X"000F", X"000E", X"000D", 
									  X"000C", X"000B", X"000A", X"0009", X"0008", X"0007", X"0006", X"0005");
	signal rdata : std_logic_vector(WIDTH-1 downto 0);

begin

	process (CLK)
		begin
		if CLK'event and CLK = '1' then
			if Load = '1' then 
				rdata <= RamData(conv_integer(ADDR));
				if EN = '1' then
					DO <= rdata;
				end if;
			else
				if EN = '1' then
					if WE = '1' then
						RamData(conv_integer(ADDR)) <= DI;
					end if;
					DO <= RamData(conv_integer(ADDR));
				end if;
			end if;
		end if;
	end process;

end Behavioral;

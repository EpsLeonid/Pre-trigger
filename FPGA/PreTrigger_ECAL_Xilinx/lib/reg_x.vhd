library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;

library unisim;
use unisim.vcomponents.all;

entity reg_x is
	generic(
		REG_NUMBER : std_logic_vector(15 downto 0);
		REG_WIDTH  : integer;
		REG_DEFAULT_VALUE : std_logic_vector(15 downto 0) := (others => '0') 
	);
    port ( 
		i_clock     : in  std_logic;
        i_reg_we    : in  std_logic;
        i_reg_num   : in  std_logic_vector(15 downto 0);
        i_reg_wdata : in  std_logic_vector(15 downto 0);

		i_set_value : in  std_logic_vector(15 downto 0);
		i_direct_set_enable : in std_logic;

        o_reg_rdata : out  std_logic_vector(15 downto 0);
        o_reg_value : out  std_logic_vector(REG_WIDTH-1 downto 0)
	);
end reg_x;

architecture Behavioral of reg_x is

	signal s_reg_value : std_logic_vector(REG_WIDTH-1 downto 0) := REG_DEFAULT_VALUE(REG_WIDTH-1 downto 0); 
	signal s_reg_rdata : std_logic_vector(REG_WIDTH-1 downto 0) := (others => '0');
	signal s_reg_match : std_logic := '0';
	signal s_reg_we    : std_logic := '0';
	signal s_reg_num   : std_logic_vector(15 downto 0) := (others => '0');

begin

clock_process : process(i_clock)
begin
	if rising_edge(i_clock) then
		s_reg_match <= '0';

		if i_reg_num = REG_NUMBER then
			s_reg_match <= '1';
		end if;

		s_reg_we    <= i_reg_we;
		s_reg_rdata <= (others => '0');

		if s_reg_match = '1' then
			s_reg_rdata <= s_reg_value;
			if s_reg_we = '1' then
				s_reg_value <= i_reg_wdata(REG_WIDTH-1 downto 0); 
			end if;
		end if;

		if i_direct_set_enable = '1' then
			s_reg_value <= i_set_value(REG_WIDTH-1 downto 0);
		end if;

	end if;
end process;


process(s_reg_rdata)
begin
	o_reg_rdata <= (others => '0');
	o_reg_rdata(REG_WIDTH-1 downto 0) <= s_reg_rdata;
end process;

o_reg_value <= s_reg_value;


end Behavioral;


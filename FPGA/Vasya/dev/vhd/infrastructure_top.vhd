library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;


entity infrastructure_top is
port(
	i_clock   : in std_logic;
	RESET_N   : in std_logic;
	clock_locked : in  std_logic;

	hb25ns       : out std_logic;
	hb5mks       : out std_logic;
	hb50mks      : out std_logic);
end infrastructure_top;

architecture behavioral of infrastructure_top is

	signal s_reset : std_logic := '0';


	signal hb50mks_cnt    : std_logic_vector(12 downto 0) := (others=>'0');
	signal hb50mks_reg    : std_logic := '0';
	signal hb5mks_cnt : std_logic_vector(9 downto 0) := (others=>'0');
	signal hb5mks_reg : std_logic := '0';

	signal clock40MHz_tggl_r : std_logic := '0';
	signal clock_tggl_r      : std_logic := '0';
	
	signal hb25ns_cnt : std_logic_vector(1 downto 0) := (others=>'0');
	signal hb25ns_r : std_logic := '0';
	signal s_clock : std_logic := '0';
	signal s_clock_locked : std_logic := '0';
	
	signal s_cnt : std_logic_vector(1 downto 0) := (others=>'0');
	signal s_bgn : std_logic := '0';


begin	

  s_clock <= i_clock;
  s_clock_locked <= clock_locked;

  -- generate heartbeats 
  process(s_clock, s_clock_locked)
  begin

    if s_clock_locked = '1' and rising_edge(s_clock) then
      hb25ns_r <= '0';
      if s_cnt = B"00" then
        hb25ns_r <= '1';
      end if;
      s_cnt <= s_cnt + 1;
    end if;

    if s_clock'event and s_clock='1' and s_clock_locked='1' then
      if hb5mks_cnt  = B"00_0000_0000" then
        hb5mks_cnt <= B"11_0001_1111";
        hb5mks_reg <= '1';
      else
        hb5mks_cnt <= hb5mks_cnt-'1';
        hb5mks_reg <= '0';
      end if;

      if hb50mks_cnt=X"000" and s_clock_locked='1' then
        hb50mks_cnt <= B"1_1111_0011_1111";
        hb50mks_reg <= '1';
      else
        hb50mks_cnt <= hb50mks_cnt - '1';
        hb50mks_reg <= '0';
      end if;
    end if;

  end process;

	hb25ns  <= hb25ns_r;
	hb50mks <= hb50mks_reg;
	hb5mks  <= hb5mks_reg;

	s_reset <= not RESET_N;

	hb50mks <= hb50mks_reg;
	hb5mks  <= hb5mks_reg;
  ---

end behavioral;



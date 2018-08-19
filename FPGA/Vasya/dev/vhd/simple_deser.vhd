library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.types.all;

entity simple_deser is
port(
  
	dco_ib_p  : in std_logic;
	dco_ib_n  : in std_logic;
  clock_adc : in std_logic;
  
  reset     : in std_logic;

	rx_data_in : in std_logic;
--  fco_ib     : in std_logic;

  framestart : in std_logic;
  o_data   : out t_adc_data;

  data_we : out std_logic;

  --SDATAP  : in std_logic;
  --SDATAN  : in std_logic;
  shift   : std_logic_vector(7 downto 0)

);

end simple_deser;

architecture iddr2_arch of simple_deser is
  signal s_frame_r      : t_adc_data := (others => '0');
  signal s_frame        : t_adc_data := (others => '0');
                         
  signal dco_div2       : std_logic := '0';
  --signal rx_data_in     : std_logic;
  signal s_data_long    : std_logic_vector(63 downto 0) := (others=>'0');
  signal s_data_long_r  : std_logic_vector(63 downto 0) := (others=>'0');
  signal s_data_0       : std_logic_vector(11 downto 0) := (others=>'0');
  signal s_data_0_r     : std_logic_vector(11 downto 0) := (others=>'0');
  signal s_data_0_dr    : std_logic_vector(11 downto 0) := (others=>'0');
  signal s_data_r       : std_logic_vector(11 downto 0) := (others=>'0');
  signal s_data_dr      : std_logic_vector(11 downto 0) := (others=>'0');
  signal s_data_ddr     : std_logic_vector(11 downto 0) := (others=>'0');

  signal s_ddr2_data_q  : std_logic_vector(1 downto 0)  := (others => '0');

  signal s_data_fco     : t_adc_data := (others => '0');
  signal s_data_fco_r   : t_adc_data := (others => '0');
  signal s_data_we      : std_logic := '0';
  signal s_data_q       : std_logic_vector(1 downto 0);
  signal s_data_q_r     : std_logic_vector(1 downto 0);

  signal s_match        : std_logic := '0';
  signal s_match_r      : std_logic := '0';
  signal s_cnt          : std_logic_vector(1 downto 0) := (others => '0');
  
  --signal fco_ib : std_logic;
  signal s_max          : std_logic_vector(11 downto 0) := (others => '1');

  signal s_framestart        : std_logic;
  signal s_framestart_r        : std_logic;
  signal s_framestart_dr       : std_logic;
begin



    IDDR2_data : IDDR2
    generic map(
      DDR_ALIGNMENT => "C0", -- Sets output alignment to "NONE", "C0", "C1" 
      INIT_Q0 => '0',   -- Sets initial state of the Q0 output to '0' or '1'
      INIT_Q1 => '0',   -- Sets initial state of the Q1 output to '0' or '1'
      SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
    port map (
      Q0 => s_ddr2_data_q(0),         -- 1-bit output captured with C0 clock
      Q1 => s_ddr2_data_q(1),         -- 1-bit output captured with C1 clock
      C0 => dco_ib_p,     -- 1-bit clock input
      C1 => dco_ib_n,   -- 1-bit clock input
      CE => '1',        -- 1-bit clock enable input
      D  => rx_data_in,           -- 1-bit data input 
      R  => reset,        -- 1-bit reset input
      S  => open);       -- 1-bit set input


    process(dco_ib_p)
    begin
      if rising_edge(dco_ib_p) then
        s_data_q      <= s_ddr2_data_q;
        s_data_q_r    <= s_data_q;
      end if;
    end process;

    process(dco_ib_p)
    begin
      if rising_edge(dco_ib_p) then
        s_data_long    <= s_data_long(61 downto 0) & s_data_q_r;
        s_data_long_r  <= s_data_long;
      end if;
    end process;

  process(dco_ib_p)
  begin
    if rising_edge(dco_ib_p) then
      s_framestart <= '0';
      s_framestart_r <= framestart;
      s_framestart_dr <= s_framestart_r;

      if s_framestart_r = '1' and s_framestart_dr = '0' then
        s_framestart <= '1';
      end if;
    end if;
  end process;

  -- compare frame clock data to pattern 111111000000 = X"FC0"
  -- if so, direct the deserialized data to output
  process(dco_ib_p)
  begin
    if rising_edge(dco_ib_p) then
        s_data_0_r   <= s_data_0;
        s_data_0_dr  <= s_data_0_r;
    end if;
  end process;

  s_data_0  <= s_data_long(11 downto 0) when shift = X"00" else
              s_data_long(11 downto 0) when shift = X"01" else
              s_data_long(12 downto 1) when shift = X"02" else
              s_data_long(13 downto 2) when shift = X"03" else
              s_data_long(14 downto 3) when shift = X"04" else
              s_data_long(15 downto 4) when shift = X"05" else
              s_data_long(16 downto 5) when shift = X"06" else
              s_data_long(17 downto 6) when shift = X"07" else
              s_data_long(18 downto 7) when shift = X"08" else
              s_data_long(19 downto 8) when shift = X"09" else
              s_data_long(20 downto 9) when shift = X"0A" else
              s_data_long(21 downto 10) when shift = X"0B" else
              s_data_long(22 downto 11) when shift = X"0C" else
              s_data_long(23 downto 12) when shift = X"0D" else
              s_data_long(24 downto 13) when shift = X"0E" else
              s_data_long(25 downto 14) when shift = X"0F" else
              s_data_long(26 downto 15) when shift = X"10" else
              s_data_long(27 downto 16) when shift = X"11" else
              s_data_long(28 downto 17) when shift = X"12" else
              s_data_long(29 downto 18) when shift = X"13" else
              s_data_long(30 downto 19) when shift = X"14" else
              s_data_long(31 downto 20) when shift = X"15" else
              s_data_long(32 downto 21) when shift = X"16" else
              s_data_long(33 downto 22) when shift = X"17" else
              s_data_long(34 downto 23) when shift = X"18" else
              s_data_long(35 downto 24) when shift = X"19" else
              s_data_long(36 downto 25) when shift = X"1A" else
              s_data_long(37 downto 26) when shift = X"1B" else
              s_data_long(38 downto 27) when shift = X"1C" else
              s_data_long(39 downto 28) when shift = X"1D" else
              s_data_long(40 downto 29) when shift = X"1E" else
              s_data_long(41 downto 30) when shift = X"1E" else
              s_data_long(42 downto 31) when shift = X"1E" else
              s_data_long(43 downto 32) when shift = X"1E" else
              s_data_long(44 downto 33) when shift = X"1E" else
              s_data_long(45 downto 34) when shift = X"1E" else
              s_data_long(46 downto 35);

  process(clock_adc)
  begin
    if rising_edge(clock_adc) then
      s_data_r   <= s_data_0_dr;
      s_data_dr  <= s_data_r;
      s_data_ddr  <= s_data_dr;
      o_data <= s_data_ddr;
    end if;
  end process;
  
  -- other outputs
  data_we   <= s_data_we;

end iddr2_arch; 

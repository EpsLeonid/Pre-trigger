library ieee;
use ieee.std_logic_1164.all;

package mytypes is
subtype byte_t      is std_logic_vector (7 downto 0);
subtype word_t      is std_logic_vector (15 downto 0);
subtype long_t      is std_logic_vector (31 downto 0);
type    byte_vector is array (natural range <>) of byte_t;
type    word_vector is array (natural range <>) of word_t;
type    long_vector is array (natural range <>) of long_t;

subtype std_logic2  is std_logic_vector (1 downto 0);
subtype std_logic3  is std_logic_vector (2 downto 0);
subtype std_logic4  is std_logic_vector (3 downto 0);
subtype std_logic5  is std_logic_vector (4 downto 0);
subtype std_logic6  is std_logic_vector (5 downto 0);
subtype std_logic7  is std_logic_vector (6 downto 0);
subtype std_logic8  is std_logic_vector (7 downto 0);
subtype std_logic9  is std_logic_vector (8 downto 0);
subtype std_logic10 is std_logic_vector (9 downto 0);
subtype std_logic11 is std_logic_vector (10 downto 0);
subtype std_logic12 is std_logic_vector (11 downto 0);
subtype std_logic13 is std_logic_vector (12 downto 0);
subtype std_logic14 is std_logic_vector (13 downto 0);
subtype std_logic15 is std_logic_vector (14 downto 0);
subtype std_logic16 is std_logic_vector (15 downto 0);
subtype std_logic17 is std_logic_vector (16 downto 0);
subtype std_logic18 is std_logic_vector (17 downto 0);
subtype std_logic19 is std_logic_vector (18 downto 0);
subtype std_logic20 is std_logic_vector (19 downto 0);
subtype std_logic24 is std_logic_vector (23 downto 0);
subtype std_logic25 is std_logic_vector (24 downto 0);
subtype std_logic27 is std_logic_vector (26 downto 0);
subtype std_logic28 is std_logic_vector (27 downto 0);
subtype std_logic48 is std_logic_vector (47 downto 0);
subtype std_logic64 is std_logic_vector (63 downto 0);

type std_logic2_vector  is array (natural range <>) of std_logic2;
type std_logic3_vector  is array (natural range <>) of std_logic3;
type std_logic6_vector  is array (natural range <>) of std_logic6;
type std_logic9_vector  is array (natural range <>) of std_logic9;
type std_logic16_vector is array (natural range <>) of std_logic16;
type std_logic17_vector is array (natural range <>) of std_logic17;
type std_logic18_vector is array (natural range <>) of std_logic18;

constant KWORD_IDLE : word_t := x"7cbc";  -- K28.3 / K28.5
constant KWORD_LEID : word_t := x"bc7c";  -- wrong byte boundary for IDLE
constant KWORD_SCP  : word_t := x"5cfb";  -- K28.2 / K27.7
constant KWORD_ECP  : word_t := x"fdfe";  -- K29.2 / K30.7
constant KWORD_EOD  : word_t := x"dcdc";  -- K28.6 / K28.6
constant KWORD_UFC  : word_t := x"9c00";  -- K28.4 / (size=000, 2 octets)
constant KWORD_STA  : word_t := x"9c20";  -- K28.4 / (size=001, 4 octets)
constant KCHAR_CMD  : byte_t := x"9c";    -- K28.4

subtype cmd_t is std_logic_vector (3 downto 0);
constant CMD_IDLE     : cmd_t := x"0";
constant CMD_CLR      : cmd_t := x"1";
constant CMD_SEND     : cmd_t := x"2";
constant CMD_RECV     : cmd_t := x"3";
constant CMD_COPYMODE : cmd_t := x"4";
constant CMD_COMPMODE : cmd_t := x"5";
constant CMD_STATON   : cmd_t := x"6";
constant CMD_STATOFF  : cmd_t := x"7";

subtype state_t is std_logic_vector (2 downto 0);
constant STATE_IDLE  : state_t := "000";
constant STATE_HEAD  : state_t := "001";
constant STATE_DATA  : state_t := "011";
constant STATE_TAIL  : state_t := "010";
constant STATE_ECP   : state_t := "110";
constant STATE_UFC   : state_t := "100";
constant STATE_STA   : state_t := "101";
constant STATE_SCP   : state_t := "111";
  
constant NWORD_HEAD  : integer := 264;  -- 8+256
constant NWORD_TAIL  : integer := 4;
--type    head_t is array (NWORD_HEAD-1 downto 0) of word_t;

end package mytypes;

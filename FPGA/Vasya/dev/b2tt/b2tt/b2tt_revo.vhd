-- b2tt_revo.vhd
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_revo is
  port (
    clock      : in  std_logic;
    cntpacket  : in  std_logic_vector (7  downto 0);
    frameloc   : in  std_logic_vector (10 downto 0);
    sigpayload : in  std_logic;
    payload    : in  std_logic_vector (76 downto 0);
    revoloc    : out std_logic_vector (10 downto 0);
    revosig    : out std_logic;
    abortgap   : out std_logic );
end b2tt_revo;
  
architecture implementation of b2tt_revo is

  subtype plus1_t is std_logic_vector (11 downto 0);
  subtype bunch_t is std_logic_vector (10 downto 0);
  subtype frame_t is std_logic_vector (9 downto 0);
  function add_mod1280
    ( a: in bunch_t; b: in bunch_t ) return bunch_t is
    variable aa : plus1_t;
    variable bb : plus1_t;
    variable cc : plus1_t;
  begin
    aa := '0' & a;
    bb := '0' & b;
    cc := aa + bb;
    if cc >= 1280 then
      cc := cc - 1280;
    end if;
    return cc(10 downto 0);
  end function add_mod1280;
      
  signal buf_ttpkt   : std_logic_vector (11 downto 0) := (others => '0');
  signal buf_bdata   : std_logic_vector (63 downto 0) := (others => '0');
  
  signal buf_beggap  : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_endgap  : std_logic_vector (10 downto 0) := (others => '0');
  signal sig_gap     : std_logic := '0';
  signal sig_revo    : std_logic := '0';
  signal buf_revoloc : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_revosav : std_logic_vector (10 downto 0) := (others => '0');
begin

  -- in
  buf_ttpkt <= payload(75 downto 64);
  buf_bdata <= payload(63 downto 0);

  -- proc
  proc: process(clock)
  begin
    if rising_edge(clock) then
      -- start seq_kick
      if sigpayload = '1' and cntpacket = 13 then
        if buf_ttpkt = TTPKT_REVO then
          buf_revoloc <= buf_bdata(10 downto 0);
          buf_beggap  <= add_mod1280(buf_bdata(22 downto 12),
                                     buf_bdata(10 downto 0));
          buf_endgap  <= add_mod1280(buf_bdata(34 downto 24),
                                     buf_bdata(10 downto 0));
        else
          buf_revoloc <= (others => '0');
          buf_beggap  <= (others => '0');
          buf_endgap  <= (others => '0');
        end if;
      end if;

      -- sig_revo
      if frameloc = buf_revoloc and buf_revoloc = buf_revosav then
        sig_revo <= '1';
      else
        sig_revo <= '0';
      end if;

      -- buf_revosav
      if frameloc = buf_revoloc then
        buf_revosav <= buf_revoloc;
      end if;

      -- sig_gap
      if frameloc = buf_endgap then
        sig_gap <= '0';
      elsif frameloc = buf_beggap then
        sig_gap <= '1';
      end if;
      
    end if;
  end process;

  -- out
  revoloc  <= buf_revosav;
  revosig  <= sig_revo;
  abortgap <= sig_gap;
  
end implementation;

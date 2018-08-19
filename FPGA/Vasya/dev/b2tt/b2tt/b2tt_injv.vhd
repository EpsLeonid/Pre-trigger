-- b2tt_injv.vhd
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_injv is
  port (
    clock      : in  std_logic;
    cntpacket  : in  std_logic_vector (7  downto 0);
    frameloc   : in  std_logic_vector (10 downto 0);
    revoloc    : in  std_logic_vector (10 downto 0);
    sigpayload : in  std_logic;
    payload    : in  std_logic_vector (76 downto 0);
    injkick    : out std_logic;
    injveto    : out std_logic;
    injvpos    : out std_logic_vector (10 downto 0);
    injvpre    : out std_logic_vector (10 downto 0);
    injvlen    : out std_logic_vector (10 downto 0);
    injvfull   : out std_logic_vector (9  downto 0);
    injvgate   : out std_logic_vector (9  downto 0) );
end b2tt_injv;
  
architecture implementation of b2tt_injv is

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
      
  function sub_mod1280
    ( a: in bunch_t; b: in bunch_t ) return bunch_t is
    variable aa : plus1_t;
    variable bb : plus1_t;
    variable cc : plus1_t;
  begin
    aa := '0' & a;
    bb := '0' & b;
    if aa < bb then
      cc := aa + 1280 - bb;
    else
      cc := aa - bb;
    end if;
    return cc(10 downto 0);
  end function sub_mod1280;

  signal buf_ttpkt   : std_logic_vector (11 downto 0) := (others => '0');
  signal buf_bdata   : std_logic_vector (63 downto 0) := (others => '0');
  signal seq_kick    : std_logic_vector (3  downto 0) := (others => '0');
  signal sig_kick    : std_logic := '0';
  signal buf_kick    : std_logic := '0';
  signal sig_injv    : std_logic := '0';
  
  signal buf_begloc  : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_injloc  : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_endloc  : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_kicksub : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_kickloc : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_vpos    : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_vloc    : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_vpre    : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_vlen    : std_logic_vector (10 downto 0) := (others => '0');
  signal buf_vfull   : std_logic_vector (9  downto 0) := (others => '0');
  signal buf_vgate   : std_logic_vector (9  downto 0) := (others => '0');
  signal cnt_frame   : std_logic_vector (9  downto 0) := (others => '0');
  signal buf_state   : std_logic_vector (1  downto 0) := (others => '0');
begin

  -- in
  buf_ttpkt <= payload(75 downto 64);
  buf_bdata <= payload(63 downto 0);

  -- proc
  proc: process(clock)
  begin
    if clock'event and clock = '1' then
      -- start seq_kick
      if (sigpayload = '1' and cntpacket = 14 and
          buf_ttpkt = TTPKT_INJV and buf_state = 0) then
        seq_kick <= seq_kick(seq_kick'left-1 downto 0) & buf_bdata(63);
      else
        seq_kick <= seq_kick(seq_kick'left-1 downto 0) & '0';
      end if;

      -- sig_kick, buf_kick, all buf_*** from bdata
      if seq_kick(0) = '1' then
        buf_kicksub <= '0' & buf_bdata(9 downto 0);
        buf_vpos    <= buf_bdata(20 downto 10);
        buf_vpre    <= buf_bdata(31 downto 21);
        buf_vlen    <= buf_bdata(42 downto 32);
        buf_vfull   <= buf_bdata(52 downto 43);
        buf_vgate   <= buf_bdata(62 downto 53);
      end if;
      if seq_kick(1) = '1' then
        buf_injloc <= add_mod1280(buf_vpos, revoloc);
      end if;
      if seq_kick(2) = '1' then
        buf_begloc <= sub_mod1280(buf_injloc, buf_vpre);
        buf_endloc <= add_mod1280(buf_injloc, buf_vlen);
        --buf_kicksub <= add_mod1280(buf_kicksub, "00000000001");
      end if;
      if seq_kick(3) = '1' then
        buf_vloc <= sub_mod1280(buf_begloc, "00000000001");
        buf_kickloc <= sub_mod1280(buf_begloc, buf_kicksub);
        buf_kick    <= '1';
      elsif frameloc = buf_kickloc then
        sig_kick    <= buf_kick;
        buf_kick    <= '0';
      else
        sig_kick    <= '0';
      end if;

      -- buf_state, cnt_frame
      if seq_kick(3) = '1' then
        buf_state <= "01";
        cnt_frame <= "0000000011"; -- 3
      elsif frameloc = buf_vloc then
        if cnt_frame /= 0 then
          cnt_frame <= cnt_frame - 1;
        elsif buf_state = 1 and buf_vfull /= 0 then
          cnt_frame <= buf_vfull - 1;
          buf_state <= "10";
        elsif buf_state = 1 and buf_vgate /= 0 then
          cnt_frame <= buf_vgate - 1;
          buf_state <= "11";
        elsif buf_state = 2 and buf_vgate /= 0 then
          cnt_frame <= buf_vgate;
          buf_state <= "11";
        else
          buf_state <= "00";
        end if;
      end if;

      -- sig_injv
      if buf_state(1) = '1' and frameloc = buf_begloc then
        sig_injv <= '1';
      elsif buf_state(1) = buf_state(0) and frameloc = buf_endloc then
        sig_injv <= '0';
      end if;

    end if;
  end process;

  -- out
  injkick <= sig_kick;
  injveto <= sig_injv;
  injvpos <= buf_vpos;
  injvpre <= buf_vpre;
  injvlen <= buf_vlen;
  injvfull <= buf_vfull;
  injvgate <= buf_vgate;
  
  
end implementation;

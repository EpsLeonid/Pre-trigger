------------------------------------------------------------------------
--
--  b2tt_decode.vhd -- TT-link decoder for Belle2link frontend
--
--  Mikihiko Nakao, KEK IPNS
--
--  20120325 first version
--  20120528 fixes based on c-model
--  20120603 restructured
--  20131002 many changes, b2tt_iddr separated out
--  20131012 unifying with v6 code
--  20131101 no more std_logic_arith
--  20131126 tagerr fix (debug with c-model)
--  20140102 ini.value of detag:buf_cnttrg / detrig:cnt_trig to -1
--  20141128 address setting
--  20150103 clkfreq
--  20150110 jtag
--  20150207 no tagerr if masked
--  20150319 clraddr, runreset, longer stareset
--  20150526 tagset/tagin (tested with ft3f)
--  20150528 divclk1 fix (divclk2 was forgotten)
--  20150614 clkfreq to 24-bit, running, longer frame3/frame9
--           (but reverted back to 20150319)
--  20150718 fix revert of 20150319
--  20150722 cnt_trig is one clock delayed to relax timing constraint
--  20160315 trgmask when masked in the upstream
--  20160407 trgmask undefined initial value fix
--  20160627 no more sig_triginc
--  20160831 regsel (cmd 8)
--  20170713 regsel at cmd 7, usrreg, rstmask
--  20170724 semreset at RST bit 32
--
--  eout bit 9 is first transmitted, bit 0 is last transmitted
--  ein  bit 9 is first received,    bit 0 is last received
--
--  data structure
--     bit2       2-bit input at every clock
--     bit10      10-bit input before 8b10b
--     octet/isk  8-bit decoded data and flag for K-character
--     packet     16-octet container starting with a comma
--     payload    77-bit data inserted in a packet
--     frame      16-packet container synchronized to beam revolution
--
--  counters
--    cntbit2
--      0 to 4  incremented every clock to make an octet to 8b10b
--      5       octet boundary is not found or found at wrong place
--              When a comma is found at a wrong place, "newcomma" is
--              asserted.  When another comma is found when cntbit2 is 5,
--              cntbit2 cycle immediately goes into 0 to 4 cycle.
--    cntoctet
--      0  to 15 incremented every 5 clocks to make a packet (16 octet)
--      16      packet boundary is found with alternative comma
--      17      packet boundary is not found or found at wrong place
--              When a packet boundary is found at a wrong place,
--              "newframe" is asserted.  When another comma is found
--              when cntbit2 is 5, cntbit2 cycle immediately goes into
--              0 to 4 cycle.
--
--    cnt_packet
--      0  to 15 incremented every 16 octet to make a frame
--      16       reset because of incorrect octet/packet
--      17 to 255  link yet to be established, incremented until round
--                 up to 0
--  
------------------------------------------------------------------------

------------------------------------------------------------------------
-- - b2tt_decomma
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_decomma is
  port (
    ckup      : in std_logic;
    bit2      : in std_logic_vector (1 downto 0);
    prev8     : in std_logic_vector (7 downto 0);
    cntbit2   : in std_logic_vector (2 downto 0);
    comma     : out std_logic;
    newcomma  : out std_logic );
end b2tt_decomma;
------------------------------------------------------------------------
architecture implementation of b2tt_decomma is
  signal sig_bit10 : std_logic_vector (9 downto 0) := "0000000000";
  signal sig_comma : std_logic := '0';
begin
  -- in
  sig_bit10 <= prev8 & bit2 when ckup = '1' else (others => '0');

  -- comma detection (before clock cycle)
  sig_comma <= '1' when
    sig_bit10 = K28_5P or sig_bit10 = K28_5N or
    sig_bit10 = K28_1P or sig_bit10 = K28_1N else '0';

  -- misaligned comma detection (before clock cycle)
  -- out (async)
  newcomma <= '1' when sig_comma = '1' and
                       cntbit2 /= 0 and cntbit2 /= 5 else '0';
  comma <= sig_comma;
  
end implementation;
------------------------------------------------------------------------
-- - b2tt_debit2
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_debit2 is
  port (
    clock     : in  std_logic;
    ckup      : in  std_logic;
    nocomma   : in  std_logic;
    newcomma  : in  std_logic;
    comma     : in  std_logic;
    bit2      : in  std_logic_vector (1 downto 0);
    bit10     : out std_logic_vector (9 downto 0);
    cntbit2   : out std_logic_vector (2 downto 0); -- 0 to 4
    sigslip   : out std_logic );
end b2tt_debit2;
------------------------------------------------------------------------
architecture implementation of b2tt_debit2 is

  signal buf_slip10 : std_logic_vector (9 downto 0) := "0000000000";
  signal buf_slip   : std_logic := '0';
  signal buf_bit10  : std_logic_vector (9 downto 0) := "0000000000";

  signal cnt_bit2   : std_logic_vector (2 downto 0) := "101";
begin
  -- process
  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      -- search for a shifted comma charactor for bit slip
      if ckup = '0' or
         buf_slip10 = K28_5P or buf_slip10 = K28_5N or
         buf_slip10 = K28_1P or buf_slip10 = K28_1N then
        buf_slip10 <= (others => '0');
        buf_slip   <= '0';
        sigslip    <= ckup;
      else
        buf_slip10 <= buf_slip10(7 downto 0) & buf_slip & bit2(1);
        buf_slip   <= bit2(0);
        sigslip    <= '0';
      end if;

      -- decode counter to align octet boundary (==5 when not aligned)
      if ckup = '0' or nocomma = '1' or newcomma = '1' then
        cnt_bit2 <= "101"; -- 5
      --elsif newcomma = '1' then
      --  cnt_bit2 <= "101"; -- 5
      elsif comma = '1' then
        cnt_bit2 <= "001"; -- 1
      elsif cnt_bit2 = 4 then
        cnt_bit2 <= "000"; -- 0
      elsif cnt_bit2 /= 5 then
        cnt_bit2 <= cnt_bit2 + 1;
      end if;

      -- standard buffer
      if ckup = '1' then
        buf_bit10 <= buf_bit10(7 downto 0) & bit2;
      else
        buf_bit10 <= (others => '0');
      end if;
    end if;
  end process;

  -- out
  bit10     <= buf_bit10;
  cntbit2   <= cnt_bit2;

end implementation;
------------------------------------------------------------------------
-- - b2tt_debit10
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_debit10 is
  port (
    clock     : in  std_logic;
    cntbit2   : in  std_logic_vector (2 downto 0);
    bit2      : in  std_logic_vector (1 downto 0);
    bit10     : in  std_logic_vector (9 downto 0);
    octet     : out std_logic_vector (7 downto 0);  -- out/async
    isk       : out std_logic );                    -- out/async
end b2tt_debit10;
------------------------------------------------------------------------
architecture implementation of b2tt_debit10 is

  signal sig_10b  : std_logic_vector (9 downto 0) := "0000000000";
  signal sig_en   : std_logic := '0';
  signal sig_isk  : std_logic := '0';
  signal buf_isk  : std_logic := '0';
  signal sig_8b   : std_logic_vector (7 downto 0) := x"00";
  signal buf_8b   : std_logic_vector (7 downto 0) := x"00";

  signal open_err : std_logic_vector (4 downto 0) := (others => '0');
  signal open_rdp : std_logic := '0';
begin

  -- in
  sig_10b <= bit10(7 downto 0) & bit2;
  sig_en  <= '1' when cntbit2 = 4 else '0';

  -- almost async (except for rdp)
  map_de: entity work.b2tt_de8b10b
    port map ( reset => '0',
               clock => clock,
               en    => sig_en,
               ein   => sig_10b,
               dout  => sig_8b,
               isk   => sig_isk,
               err   => open_err,  -- out
               rdp   => open_rdp); -- out
  
  -- out (async)
  octet   <= sig_8b  when cntbit2 = 0 or cntbit2 = 5 else buf_8b;
  isk     <= sig_isk when cntbit2 = 0 or cntbit2 = 5 else buf_isk;

  proc: process (clock)
  begin
    if clock'event and clock = '1' then
      if cntbit2 = 0 or cntbit2 = 5 then
        buf_8b  <= sig_8b;
        buf_isk <= sig_isk;
      end if;
    end if;
  end process;

end implementation;
------------------------------------------------------------------------
-- - b2tt_detrig
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_detrig is
  port (
    clock      : in  std_logic;
    ttup       : in  std_logic;
    mask       : in  std_logic;
    runreset   : in  std_logic;
    cntbit2    : in  std_logic_vector (2  downto 0);
    octet      : in  std_logic_vector (7  downto 0);
    isk        : in  std_logic;
    tagset     : in  std_logic;
    tagin      : in  std_logic_vector (31 downto 0);
    jtag       : out std_logic_vector (2  downto 0);
    jtagdbg    : out std_logic_vector (9  downto 0);
    trgout     : out std_logic;
    trgtyp     : out std_logic_vector (3  downto 0);
    trgtag     : out std_logic_vector (31 downto 0);
    trgshort   : out std_logic );
end b2tt_detrig;
------------------------------------------------------------------------
architecture implementation of b2tt_detrig is
  signal sta_en          : std_logic := '0';
  signal sig_trgoctet    : std_logic := '0';
  signal sig_trgout      : std_logic := '0';
  signal sig_trgtim      : std_logic_vector (2  downto 0) := "111";
  signal buf_trgtim      : std_logic_vector (2  downto 0) := "111";
  signal cnt_trginterval : std_logic_vector (4  downto 0) := "11000";  -- 24
  signal cnt_trig        : std_logic_vector (31 downto 0) := (others => '1');
  signal cnt_delta       : std_logic_vector (7  downto 0) := (others => '0');
  --signal sig_triginc     : std_logic := '0';

  signal seq_tck         : std_logic_vector (3 downto 0) := "0000";
  signal sig_tck         : std_logic := '0';
  signal sig_tms         : std_logic := '0';
  signal sig_tdi         : std_logic := '0';
begin

  -- in
  sta_en  <= ttup and (not mask);
  sig_trgtim   <= octet(6 downto 4);
  sig_trgoctet <= octet(7) and (not isk) when cntbit2 = 1 else '0';
  sig_tck <= (sta_en and isk) when octet(7 downto 4) = "1111" and
                                   octet(1 downto 0) /= 0     and
                                   cntbit2 = 1                else
             '0';
  sig_tms <= sig_tck and octet(3) and octet(2) and (octet(1) xor octet(0));
  sig_tdi <= sig_tck and octet(3) and octet(1) and (octet(2) xor octet(0));

  jtagdbg(9) <= '0';
  jtagdbg(8 downto 4) <= cnt_trginterval;
  jtagdbg(3) <= seq_tck(3);
  jtagdbg(2) <= sig_tck;
  jtagdbg(1) <= sig_tms;
  jtagdbg(0) <= sig_tdi;
  
  proc: process (clock)
  begin
    if clock'event and clock = '1' then
      if (sig_trgout = '1' or sig_tck = '1') and cnt_trginterval + 1 >= 24 then
        cnt_trginterval <= "00001";
      elsif cnt_trginterval < 23 then
        cnt_trginterval <= cnt_trginterval + 1;
      end if;
      
      -- search for trigger octet
      -- sig_trgout: time-recovered trigger signal
      -- buf_trgtim: for delayed trigger generation
      -- trgshort:   trigger comes in a too short interval (held until reset)

      -- trgshort
      if sta_en = '0' or runreset = '1' then
        trgshort <= '0';
      elsif (sig_trgoctet = '1' or sig_tck = '1') and
            cnt_trginterval + sig_trgtim < 24 then
        trgshort <= '1';
      end if;

      -- jtag
      jtag(2) <= seq_tck(3);
      seq_tck(3 downto 1) <= seq_tck(2 downto 0);
      if sig_tck = '1' then
        jtag(1 downto 0) <= sig_tms & sig_tdi;
      end if;
      if sig_tck = '1' and cnt_trginterval + 1 >= 24 then
        seq_tck(0) <= '1';
      elsif cnt_trginterval >= 16 then
        seq_tck(0) <= '0';
      end if;
      
      -- trgout
      if sta_en = '0' or runreset = '1' then
        sig_trgout <= '0';
      elsif sig_trgoctet = '1' and sig_trgtim = 1 then
        if cnt_trginterval + 1 >= 24 then
          sig_trgout <= '1';
        else
          sig_trgout <= '0';
        end if;
      elsif cntbit2 = buf_trgtim then
        sig_trgout <= '1';
      else
        sig_trgout <= '0';
      end if;

      -- cnt_trig / cnt_delta (without sig_triginc)
      if sta_en = '0' or runreset = '1' then
        cnt_trig <= (others => '1');
        cnt_delta <= (others => '0');
      elsif tagset = '1' then
        -- tagset is issued twice when mask is released,
        -- to properly include cnt_delta
        cnt_trig <= tagin + (x"000000" & cnt_delta);
      elsif sig_trgoctet = '1' and sig_trgtim = 1 then
        if cnt_trginterval + 1 >= 24 then
          cnt_trig  <= cnt_trig  + 1;
          cnt_delta <= cnt_delta + 1;
        end if;
      elsif cntbit2 = buf_trgtim then
        cnt_trig  <= cnt_trig  + 1;
        cnt_delta <= cnt_delta + 1;
      end if;
      
      -- buf_trgtyp
      if sta_en = '0' or runreset = '1' then
        trgtyp <= TTYP_NONE;
      elsif cntbit2 = 1 and sig_trgoctet = '1' then
        trgtyp <= octet(3 downto 0);
      end if;

      -- buf_trgtim
      if sta_en = '0' or runreset = '1' then
        buf_trgtim <= "111";
      elsif sig_trgoctet = '1' then
        if sig_trgtim <= 1 or sig_trgtim > 5 then
          buf_trgtim <= "111"; -- 1: immediate trgout, 0,6,7: invalid
        elsif sig_trgtim = 5 then
          buf_trgtim <= "000"; -- 5: wrap-around to 0
        else
          buf_trgtim <= sig_trgtim; -- 2,3,4: as it is
        end if;
      elsif cntbit2 = 0 then
        buf_trgtim <= "111";
      end if;

    end if; -- event
  end process;

  -- out
  trgout <= sig_trgout;
  trgtag <= cnt_trig;

end implementation;
------------------------------------------------------------------------
-- - b2tt_deoctet
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_deoctet is
  port (
    clock      : in  std_logic;
    cntbit2    : in  std_logic_vector (2 downto 0);
    octet      : in  std_logic_vector (7 downto 0);
    isk        : in  std_logic;
    nocomma    : out std_logic;
    staoctet   : out std_logic;
    stacrc8ok  : out std_logic;
    sigpayload : out std_logic;
    sigidle    : out std_logic;
    incdelay   : out std_logic;
    cntlinkrst : out std_logic_vector (7  downto 0);
    payload    : out std_logic_vector (76 downto 0);
    cntoctet   : out std_logic_vector (4  downto 0);
    cntdato    : out std_logic_vector (3  downto 0);
    rxerr      : out std_logic_vector (5  downto 0);
    crcdbg     : out std_logic_vector (8  downto 0) );
end b2tt_deoctet;
------------------------------------------------------------------------
architecture implementation of b2tt_deoctet is
  signal cnt_octet    : std_logic_vector (4  downto 0) := "00000";
  signal sta_octet    : std_logic := '0';
  signal seq_octet    : std_logic := '0';
  signal cnt_invalid  : std_logic_vector (11 downto 0) := x"000";
  signal cnt_incdelay : std_logic_vector (7  downto 0) := x"00";

  signal sig_datoctet : std_logic := '0';
  signal cnt_datoctet : std_logic_vector (3  downto 0) := (others => '0');
  signal buf_payload  : std_logic_vector (76 downto 0) := (others => '0');

  signal sig_rxerr    : std_logic_vector (5 downto 0) := (others => '0');

  signal sta_crc8     : std_logic_vector (7 downto 0) := x"00";
  signal sta_crc8ok   : std_logic := '0';

  -- from crc8.vhd and comlib.vhd of
  -- http://opencores.org/project,w11
  -- 0x4d (x8 + x6 + x3 + x2 + 1)   [ shr 1 makes 0xa6 ]
  subtype byte_t is  std_logic_vector (7 downto 0);
  function crc8_update
    ( crc:  in byte_t; data: in byte_t ) return byte_t is
    variable t : byte_t := (others => '0');
    variable n : byte_t := (others => '0');
  begin
    t := data xor crc;
    n(0) := t(5) xor t(4) xor t(2) xor t(0);
    n(1) := t(6) xor t(5) xor t(3) xor t(1);
    n(2) := t(7) xor t(6) xor t(5) xor t(0);
    n(3) := t(7) xor t(6) xor t(5) xor t(4) xor t(2) xor t(1) xor t(0);
    n(4) := t(7) xor t(6) xor t(5) xor t(3) xor t(2) xor t(1);
    n(5) := t(7) xor t(6) xor t(4) xor t(3) xor t(2);
    n(6) := t(7) xor t(3) xor t(2) xor t(0);
    n(7) := t(4) xor t(3) xor t(1);
    return n;
  end function crc8_update;
  
begin
  -- in
  sig_datoctet <= (not octet(7)) and (not isk);
  
  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      seq_octet <= sta_octet;
      if seq_octet = '1' and sta_octet = '0' then
        nocomma <= '1';
      else
        nocomma <= '0';
      end if;

      -- check invalid packet
      -- - cnt_invalid: number of invalid octet
      -- - sig_indelay: signal to increment delay
      if cnt_invalid(cnt_invalid'left) = '1' then
        cnt_invalid  <= (others => '0');
        incdelay <= '1';  -- out
        cnt_incdelay <= cnt_incdelay + 1;
      else
        if sta_octet = '0' then
          cnt_invalid  <= cnt_invalid + 1;
        end if;
        incdelay <= '0';  -- out
      end if;

      -- search for a packet boundary
      -- - cnt_octet: to align octet to packet boundary
      -- - sta_octet: octet is aligned to packet boundary
      if cntbit2 = 5 then
        if sta_octet = '1' then
          sig_rxerr(0) <= '1';
        end if;
        sta_octet <= '0';
        cnt_octet <= "11111";
        sta_crc8ok <= '0';
          
      elsif cntbit2 = 1 then
        -- and all the octets are checked only at cntbit2 = 1 (2?)

        if cnt_octet = 15 or cnt_octet = 31 then
          sta_crc8 <= crc8_update(x"00", octet);
          sta_crc8ok <= '1';
        elsif cnt_octet = 14 and octet(7) = '0' and isk = '0' and
              sta_crc8(6 downto 0) /= octet(6 downto 0) then
          sta_crc8ok <= '0';
        else
          sta_crc8 <= crc8_update(sta_crc8, octet);
        end if;
        
        if isk = '1' and octet = K28_1 then
          -- valid comma if cnt_octet = 15
          if cnt_octet = 15 or cnt_octet = 31 then
            sta_octet <= '1';
            cnt_octet <= "00000";
          else
            sta_octet <= '0';
            cnt_octet <= "10000";
            sig_rxerr(1) <= '1';
          end if;
        elsif isk = '1' and octet = K28_5 then
          -- valid alternative comma if cnt_octet = 16
          if cnt_octet = 16 then
            sta_octet <= '1';
            cnt_octet <= "00001";
          else
            -- invalid K28_5
            sta_octet <= '0';
            cnt_octet <= "10001";
            sig_rxerr(2) <= '1';
          end if;
        elsif (cnt_datoctet = 0 or cnt_datoctet = 11) and
               isk = '1' and octet = K28_3 then
          -- valid idle
          cnt_octet <= cnt_octet + 1;
        elsif isk = '1' and
          ((not octet(7 downto 4)) /= 0 or octet(1 downto 0) = 0) then
          --
          -- invalid K symbol (none of comma, acomma, idle, jtag)
          --
          -- valid jtag symbols are (tms,tdi)
          --   00 => K23.7 1111 0111
          --   01 => K27.7 1111 1011
          --   10 => K29.7 1111 1101
          --   11 => K30.7 1111 1110
          --
          sta_octet <= '0';
          cnt_octet <= "11111";
          sig_rxerr(3) <= '1';
        elsif octet(7) = '0' and (cnt_octet = 14 or cnt_octet = 30) then
          -- valid data or crc8
          cnt_octet <= cnt_octet + 1;
        elsif cnt_datoctet = 11 and octet(7) = '0' then
          -- invalid (too long) data payload
          sta_octet <= '0';
          cnt_octet <= "11111";
          sig_rxerr(4) <= '1';
        elsif cnt_octet = 15 and octet(7) = '1' then
          -- valid trigger octet at the beginning of packet
          cnt_octet <= "10000";
        elsif cnt_octet < 15 then
          -- valid data or trigger octet
          cnt_octet <= cnt_octet + 1;
        else
          -- invalid data payload
          sta_octet <= '0';
          cnt_octet <= "00000";
          sig_rxerr(5) <= '1';
        end if;
      else
        sig_rxerr <= (others => '0');
      end if;
      
      -- payload reconstruction
      if cntbit2 = 5 then
        buf_payload  <= (others => '0');
        cnt_datoctet <= (others => '0');
      elsif cntbit2 = 2 then
        if cnt_octet = 0 or cnt_octet(4) = '1' then
          buf_payload  <= (others => '0');
          cnt_datoctet <= (others => '0');
        elsif cnt_octet = 15 and
          cnt_datoctet = 0 and sig_datoctet = '1' then
          -- do not increment cnt_datoctet for crc8 octet
        elsif cnt_datoctet < 11 and sig_datoctet = '1' then
          buf_payload  <= buf_payload(7*10-1 downto 0) & octet(6 downto 0);
          cnt_datoctet <= cnt_datoctet + 1;
        end if;
      end if;

      -- sig_payload and sig_idle
      if cntbit2 = 3 and cnt_octet = 15 then
        if cnt_datoctet = 11 then
          sigpayload <= '1';  -- out
          payload    <= buf_payload;
        end if;
        if cnt_datoctet = 0 then
          sigidle    <= '1';  -- out
        end if;
      else
        sigpayload   <= '0';  -- out
        sigidle      <= '0';  -- out
      end if;

    end if;
  end process;

  -- out
  cntoctet   <= cnt_octet;
  cntdato    <= cnt_datoctet;
  rxerr      <= sig_rxerr;
  staoctet   <= sta_octet;
  stacrc8ok  <= sta_crc8ok;
  cntlinkrst <= cnt_incdelay;
  crcdbg     <= sta_crc8ok & sta_crc8;

end implementation;
------------------------------------------------------------------------
-- - b2tt_depacket
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_depacket is
  generic (
    PROTOCOL : integer := 0;
    COMPAT   : integer := 0;
    CLKDIV1  : integer range 0 to 72;
    CLKDIV2  : integer range 0 to 72;
    DEFADDR  : std_logic_vector (19 downto 0) := x"00000";
    SIM_SPEEDUP : std_logic := '0' );
  port (
    clock      : in  std_logic;
    staiddr    : in  std_logic_vector (1  downto 0);
    staoctet   : in  std_logic;
    sigpayload : in  std_logic;
    sigidle    : in  std_logic;
    payload    : in  std_logic_vector (76 downto 0);
    regsel     : out std_logic_vector (4  downto 0);
    usrreg     : out std_logic_vector (7  downto 0);
    badver     : out std_logic;
    clraddr    : out std_logic;
    myaddr     : out std_logic_vector (19 downto 0);
    frame      : out std_logic;
    frame3     : out std_logic;
    frame9     : out std_logic;
    divclk1    : out std_logic_vector (1  downto 0);
    divclk2    : out std_logic_vector (1  downto 0);
    cntpacket  : out std_logic_vector (7  downto 0);
    utime      : out std_logic_vector (31 downto 0);
    ctime      : out std_logic_vector (26 downto 0);
    clkfreq    : out std_logic_vector (23 downto 0);
    frameloc   : out std_logic_vector (10 downto 0);
    runreset   : out std_logic;
    errreset   : out std_logic; -- only inside b2tt
    bsyreset   : out std_logic; -- only inside b2tt
    semreset   : out std_logic; -- only inside b2tt
    feereset   : out std_logic;
    b2lreset   : out std_logic;
    gtpreset   : out std_logic;
    incdelay   : out std_logic;
    caldelay   : out std_logic;
    entagerr   : out std_logic;
    running    : out std_logic;
    trgmask    : out std_logic;
    rstmask    : out std_logic;
    dismask    : out std_logic; -- only for FTSW, not for FEE
    ttup       : out std_logic;
    timerr     : out std_logic := '0';
    --timerr0    : out std_logic_vector (26 downto 0);
    --timerr1    : out std_logic_vector (26 downto 0);
    --timerr2    : out std_logic_vector (31 downto 0);
    --timerr3    : out std_logic_vector (31 downto 0);
    sigerr     : out std_logic_vector (2 downto 0) );

end b2tt_depacket;
------------------------------------------------------------------------
architecture implementation of b2tt_depacket is
  signal sta_ttup     : std_logic := '0';
  signal cnt_packet   : std_logic_vector (7  downto 0) := (others => '0');
  signal buf_bcast    : std_logic := '0';
  signal buf_ttpkt    : std_logic_vector (11 downto 0) := (others => '0');
  signal buf_bdata    : std_logic_vector (63 downto 0) := (others => '0');
  signal buf_adata    : std_logic_vector (43 downto 0) := (others => '0');
  signal buf_addr     : std_logic_vector (19 downto 0) := (others => '0');
  signal sig_frame    : std_logic := '0';
  signal sig_frame3   : std_logic := '0';
  signal sig_frame9   : std_logic := '0';
  signal sta_dismask  : std_logic := '0';
  signal buf_utime    : std_logic_vector (31 downto 0) := (others => '0');
  signal buf_ctime    : std_logic_vector (26 downto 0) := (others => '0');
  signal buf_clkfreq  : std_logic_vector (23 downto 0) := x"952980";
  signal cnt_utime    : std_logic_vector (31 downto 0) := (others => '0');
  signal cnt_ctime    : std_logic_vector (26 downto 0) := (others => '0');
  signal cnt_timer    : std_logic_vector (3  downto 0) := "0000";
  signal cnt_frameloc : std_logic_vector (10 downto 0) := "10100000000";
  signal sig_runreset : std_logic := '0';
  signal sig_errreset : std_logic := '0';
  signal sta_running  : std_logic := '0';
  signal cnt_divseq1  : std_logic_vector (6  downto 0) := (others => '0');
  signal cnt_divseq2  : std_logic_vector (6  downto 0) := (others => '0');
  signal buf_myaddr   : std_logic_vector (19 downto 0) := DEFADDR;
  signal buf_cmd      : std_logic_vector (7  downto 0) := (others => '0');
  signal reg_clkfreq  : std_logic_vector (26 downto 0) := "111" & x"95297f";
  signal seq_runreset : std_logic := '0';
  signal sig_payload  : std_logic := '0';
  signal sta_trgmask  : std_logic := '0';
  signal buf_trgmask  : std_logic := '0';
  signal sta_rstmask  : std_logic := '0';
  signal buf_rstmask  : std_logic := '0';
  signal sta_notagerr : std_logic := '0';
  signal buf_notagerr : std_logic := '0';
  signal sta_badver   : std_logic := '0';

  -- code below means CNTLIMIT := x"1f" when SIM_SPEEDUP = '1' else x"ff";
  constant CNTLIMIT : std_logic_vector (7 downto 0) :=
    (not SIM_SPEEDUP) & (not SIM_SPEEDUP) & (not SIM_SPEEDUP) & "11111";

  --signal buf_timerr : std_logic := '0';
begin
  -- in
  buf_bcast   <= payload(76);
  buf_ttpkt   <= payload(75 downto 64);
  buf_bdata   <= payload(63 downto 0);
  buf_adata   <= payload(43 downto 0);
  buf_addr    <= payload(63 downto 44);
  buf_cmd     <= payload(43 downto 36);
  reg_clkfreq <= ("111" & buf_clkfreq) - 1;
  sig_payload <= sigpayload and sta_ttup;

  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      -- check valid payload
      if staoctet = '0' or staiddr /= 3 then
        cnt_packet <= "00010000";
        sta_ttup   <= '0';
        sigerr(2)  <= '1';
      elsif sigidle = '1' and cnt_packet /= CNTLIMIT then
        cnt_packet <= cnt_packet + 1;
      elsif sigpayload = '1' then
        if buf_bcast = '1' and buf_ttpkt = TTPKT_SYNC then
          if cnt_packet = 15 or cnt_packet = CNTLIMIT then
            cnt_packet <= (others => '0');
            sta_ttup   <= '1';
            sigerr <= "000";
          elsif cnt_packet(3 downto 0) = 15 then
            cnt_packet <= cnt_packet + 1;
            sta_ttup   <= '0';
            sigerr(1)  <= '1';
          else
            cnt_packet <= "00010000";
            sta_ttup   <= '0';
            sigerr(0)  <= '1';
          end if;
        elsif cnt_packet /= CNTLIMIT then
          cnt_packet <= cnt_packet + 1;
        end if;
      end if;

      -- buf_myaddr
      if sig_payload = '1' and buf_ttpkt = TTPKT_RST and
          buf_adata(38) = '1' and (buf_myaddr = 0 or buf_addr = 0) then
        buf_myaddr <= buf_addr;
        clraddr    <= '1';
      elsif sig_payload = '1' and buf_ttpkt = TTPKT_RST and
          buf_adata(35) = '1' then
        buf_myaddr <= (others => '0');
        clraddr    <= '1';
      else
        clraddr    <= '0';
      end if;

      -- buf_clkfreq
      if sig_payload = '1' and buf_ttpkt = TTPKT_FREQ then
        -- version in buf_adata(33 downto 24) of TTPKT_FREQ
        if buf_adata(33 downto 24) = PROTOCOL or
           buf_adata(33 downto 24) = COMPAT then
          sta_badver <= '0';
        else
          sta_badver <= '1';
        end if;
        buf_clkfreq <= buf_adata(23 downto 0);
      end if;
      
      -- feereset, gtpreset
      if sig_payload = '1' and buf_ttpkt = TTPKT_RST and
         (buf_bcast = '1' or buf_addr = buf_myaddr) then
        feereset <= buf_adata(43);
        b2lreset <= buf_adata(42);
        gtpreset <= buf_adata(41);
        incdelay <= buf_adata(40);
        caldelay <= buf_adata(39);
        sig_errreset <= buf_adata(36);
        sta_running  <= buf_adata(34);
        bsyreset <= buf_adata(33);
        semreset <= buf_adata(32);
      else
        feereset <= '0';
        b2lreset <= '0';
        gtpreset <= '0';
        incdelay <= '0';
        caldelay <= '0';
        sig_errreset <= '0';
        bsyreset <= '0';
        semreset <= '0';
      end if;

      -- entagerr (don't care bcast or myaddr)
      if sig_payload = '1' and buf_ttpkt = TTPKT_RST then
        entagerr <= buf_adata(37) and (not sta_notagerr);
      end if;
      seq_runreset <= sig_runreset;

      -- sig_runreset, sig_frame, sig_frame3, sig_frame9
      if sig_payload = '1' and buf_bcast = '1' and buf_ttpkt = TTPKT_SYNC and
           (cnt_packet = 15 or cnt_packet = CNTLIMIT) then
        sig_runreset  <= buf_bdata(63);
        sig_frame  <= '1';
        sig_frame3 <= buf_bdata(62);
        sig_frame9 <= buf_bdata(61);
        sta_dismask <= buf_bdata(59);
      else
        sig_frame  <= '0';
        -- runreset, frame3, frame9 are not a single clock pulse
        --sig_runreset  <= '0';
        --sig_frame3 <= '0';
        --sig_frame9 <= '0';
      end if;

      -- divclk1
      if (sig_payload = '1' and buf_bcast = '1' and buf_ttpkt = TTPKT_SYNC and
          buf_bdata(61) = '1' and cnt_packet(3 downto 0) = 15) or
         cnt_divseq1 = 0 then
        cnt_divseq1 <= std_logic_vector(to_unsigned(CLKDIV1 - 1, 7));
        if CLKDIV1 = 0 then
          divclk1 <= "00";
        elsif CLKDIV1 = 1 then
          divclk1 <= "10";
        else
          divclk1 <= "11";
        end if;
      else
        if cnt_divseq1 <= (CLKDIV1 + 0) / 2 then
          divclk1(1) <= '0';
        end if;
        if cnt_divseq1 <= (CLKDIV1 + 1) / 2 then
          divclk1(0) <= '0';
        end if;
        
        cnt_divseq1 <= cnt_divseq1 - 1;
      end if;
          
      -- divclk2
      if (sig_payload = '1' and buf_bcast = '1' and buf_ttpkt = TTPKT_SYNC and
          buf_bdata(61) = '1' and cnt_packet(3 downto 0) = 15) or
         cnt_divseq2 = 0 then
        cnt_divseq2 <= std_logic_vector(to_unsigned(CLKDIV2 - 1, 7));
        if CLKDIV2 = 0 then
          divclk2 <= "00";
        elsif CLKDIV2 = 1 then
          divclk2 <= "10";
        else
          divclk2 <= "11";
        end if;
      else
        if cnt_divseq2 <= (CLKDIV2 + 0) / 2 then
          divclk2(1) <= '0';
        end if;
        if cnt_divseq2 <= (CLKDIV2 + 1) / 2 then
          divclk2(0) <= '0';
        end if;
        
        cnt_divseq2 <= cnt_divseq2 - 1;
      end if;
          
      -- buf_utime, buf_ctime, cnt_timer
      if sig_payload = '1' and buf_bcast = '1' and buf_ttpkt = TTPKT_SYNC and
        (cnt_packet = 15 or cnt_packet = CNTLIMIT) then
        buf_utime <= buf_bdata(58 downto 27);
        buf_ctime <= buf_bdata(26 downto  0);
        cnt_timer <= "0111";
      elsif cnt_timer /= 0 then
        cnt_timer <= cnt_timer - 1;
      end if;

      -- cnt_utime, cnt_ctime
      if cnt_timer = 2 then
        cnt_utime <= buf_utime;
        cnt_ctime <= buf_ctime;
      elsif buf_utime /= 0 then
        if cnt_ctime = reg_clkfreq then
          cnt_utime <= cnt_utime + 1;
          cnt_ctime <= (others => '0');
        else
          cnt_ctime <= cnt_ctime + 1;
        end if;
      end if;

      -- sta_timerr
      if sig_runreset = '1' or sig_errreset = '1' then
        timerr <= '0';
        --buf_timerr <= '0';
      elsif cnt_timer = 1 and
        (cnt_utime /= buf_utime or cnt_ctime /= buf_ctime) then
        timerr <= '1';
        --buf_timerr <= '1';
        --if buf_timerr = '0' then
        --  timerr0 <= cnt_ctime;
        --  timerr1 <= buf_ctime;
        --  timerr2 <= cnt_utime;
        --  timerr3 <= buf_utime;
        --end if;
      end if;
      
      -- cnt_frameloc
      if cnt_timer = 2 then
        cnt_frameloc <= (others => '0');
      elsif cnt_frameloc /= 1280 then
        cnt_frameloc <= cnt_frameloc + 1;
      end if;

      -- trgmask, rstmask
      --  use TTPKT_RST at cnt_packet = 3, which is circulated all the time
      --  on the other hand, TTPKT_CMD at cnt_packet = 4 is circulated only
      --  when there is a command.
      --
      -- 20170709 trgmask bit is moved from bit 0 to bit 20, and will not be
      --          set in broadcast mode (clear only in broadcast mode)
      if sigidle = '1' and cnt_packet = 3 then -- TTPKT_RST is masked
        sta_trgmask <= '1';
      elsif sig_payload = '1' and buf_ttpkt = TTPKT_CMD then
        if ((buf_bcast = '1' and payload(20) = '0') or buf_addr = buf_myaddr) and
             buf_cmd = x"01" then
          sta_trgmask <= payload(20);
          buf_trgmask <= payload(20);
          sta_rstmask <= payload(21);
          buf_rstmask <= payload(21);
          sta_notagerr <= payload(22);
          buf_notagerr <= payload(22);
        else
          sta_trgmask <= buf_trgmask;
          sta_rstmask <= buf_rstmask;
          sta_notagerr <= buf_notagerr;
        end if;
      end if;

      -- regsel
      if sig_runreset = '1' or sig_errreset = '1' then
        regsel <= (others => '0');
      elsif sig_payload = '1' and buf_ttpkt = TTPKT_CMD and
        (buf_bcast = '1' or buf_addr = buf_myaddr) and buf_cmd = x"07" then
        regsel <= payload(4 downto 0);
        if payload(4 downto 0) = 1 then
          usrreg <= payload(15 downto 8);
        end if;
      end if;
      
    end if; -- event
  end process;

  -- out
  ttup       <= sta_ttup;
  trgmask    <= sta_trgmask;
  rstmask    <= sta_rstmask;
  cntpacket  <= cnt_packet;
  clkfreq    <= buf_clkfreq;
  utime      <= cnt_utime;
  ctime      <= cnt_ctime;
  frameloc   <= cnt_frameloc;
  runreset   <= sig_runreset and not sta_rstmask;
  errreset   <= sig_errreset and not sta_rstmask;
  frame      <= sig_frame;
  frame3     <= sig_frame3;
  frame9     <= sig_frame9;
  dismask    <= (sta_running or sta_dismask) and sta_ttup;
  running    <= sta_running and sta_ttup;
  myaddr     <= buf_myaddr;
  badver     <= sta_badver and sta_ttup;
  
end implementation;
------------------------------------------------------------------------
-- - b2tt_detag
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_detag is
  port (
    -- input
    clock      : in  std_logic;
    frameloc   : in  std_logic_vector (10 downto 0);
    ttup       : in  std_logic;
    runreset   : in  std_logic;
    entagerr   : in  std_logic;
    mask       : in  std_logic;
    trgtag     : in  std_logic_vector (31 downto 0);
    sigpayload : in  std_logic;
    payload    : in  std_logic_vector (76 downto 0);
    exprun     : out std_logic_vector (31 downto 0);
    tagset     : out std_logic;
    tagin      : out std_logic_vector (31 downto 0);
    tagerr     : out std_logic );
end b2tt_detag;

architecture implementation of b2tt_detag is
  signal sig_bcast    : std_logic := '0';
  signal buf_ttpkt    : std_logic_vector (11 downto 0) := (others => '0');
  signal buf_bdata    : std_logic_vector (63 downto 0) := (others => '0');
  signal buf_cnttrig  : std_logic_vector (31 downto 0) := (others => '1');
  signal buf_exprun   : std_logic_vector (31 downto 0) := x"87654321"; --dbg
  signal seq_mask     : std_logic_vector (1  downto 0) := "00";
  signal seq_tagerr   : std_logic := '0';
  signal sta_tagerr   : std_logic := '0';
begin
  
  -- in
  sig_bcast <= payload(76) and ttup and sigpayload;
  buf_ttpkt <= payload(75 downto 64);
  buf_bdata <= payload(63 downto 0);

  -- proc
  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      -- buf_cnttrig
      if runreset = '1' then
        buf_cnttrig <= (others => '1');
      elsif frameloc = 1278 then
        -- (1279 => 1278 at 0.46 => 0.48 to fix tagerr)
        buf_cnttrig <= trgtag;
      end if;

      -- tagset
      if frameloc = 1278 and seq_mask /= 0 and mask = '0' then
        tagset <= '1';
      else
        tagset <= '0';
      end if;

      -- tagerr / exprun
      -- [buf_data: (8-bit expno) (12-bit runno) (12-bit subno) (32-bit tag)]
      if runreset = '1' then
        buf_exprun <= (others => '0');
        seq_tagerr <= '0';
        sta_tagerr <= '0';
      elsif sig_bcast = '1' and buf_ttpkt = TTPKT_TTAG then
        buf_exprun <= buf_bdata(63 downto 32);
        seq_mask <= seq_mask(0) & mask;
        tagin <= buf_bdata(31 downto 0);
        if buf_bdata(31 downto 0) /= buf_cnttrig and seq_mask = 0 then
          ---sta_tagerr <= entagerr and (not mask);
          seq_tagerr <= entagerr and (not mask);
        end if;
        -- tagerr is issued if entagerr is not cleared within one turn,
        -- i.e., at next TTPKT_RST
        sta_tagerr <= entagerr and (not mask) and seq_tagerr;
      end if;
      
    end if; -- event
  end process;

  -- out
  exprun <= buf_exprun;
  tagerr <= sta_tagerr;

end implementation;

------------------------------------------------------------------------
-- - b2tt_decode
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_decode is
  generic (
    PROTOCOL : integer := 0;
    COMPAT   : integer := 0;
    FLIPTRG  : std_logic := '0';
    DEFADDR  : std_logic_vector (19 downto 0) := x"00000";
    CLKDIV1  : integer range 0 to 72;
    CLKDIV2  : integer range 0 to 72;
    SIM_SPEEDUP : std_logic := '0' );
  port (
    -- input
    clock      : in  std_logic; -- 127 MHz
    invclock   : in  std_logic; -- 127 MHz inverted
    dblclock   : in  std_logic; -- 254 MHz
    dblclockb  : in  std_logic; -- 254 MHz inverted
    ckup       : in  std_logic; -- clock is locked
    trgp       : in  std_logic; -- directly from RJ-45 or SFP
    trgn       : in  std_logic;
    
    -- system time
    utime      : out std_logic_vector (31 downto 0); -- unit: second
    ctime      : out std_logic_vector (26 downto 0); -- unit: clock
    clkfreq    : out std_logic_vector (23 downto 0); -- unit: clock
    timerr     : out std_logic;
    --timerr0    : out std_logic_vector (26 downto 0);
    --timerr1    : out std_logic_vector (26 downto 0);
    --timerr2    : out std_logic_vector (31 downto 0);
    --timerr3    : out std_logic_vector (31 downto 0);
    
    -- exp- / run-number, my address
    exprun     : out std_logic_vector (31 downto 0);
    running    : out std_logic;
    clraddr    : out std_logic;
    myaddr     : out std_logic_vector (19 downto 0);
    
    -- reset out
    runreset   : out std_logic; -- one clock long
    errreset   : out std_logic; -- one clock long
    bsyreset   : out std_logic; -- one clock long
    feereset   : out std_logic; -- one clock long
    b2lreset   : out std_logic; -- one clock long
    gtpreset   : out std_logic; -- one clock long
    semreset   : out std_logic; -- one clock long
    rstmask    : out std_logic; -- for runreset and errreset

    -- disable mask while running, jtag and ttaddr -p
    dismask    : out std_logic;
    
    -- jtag out
    jtag       : out std_logic_vector (2  downto 0);
    jtagdbg    : out std_logic_vector (9  downto 0);
    
    -- trigger out
    trgout     : out std_logic; -- one clock long
    trgtyp     : out std_logic_vector (3  downto 0); -- available at trgout
    trgtag     : out std_logic_vector (31 downto 0); -- available at trgout
    tagerr     : out std_logic; -- error, held until runreset
    trgshort   : out std_logic; -- error, held until runreset
    trgmask    : out std_logic;
    entagerr   : out std_logic;
    
    -- status out
    staoctet   : out std_logic; -- H: valid K-symbols found for 80 clocks
    ttup       : out std_logic; -- H: valid packet found for 256*1280 clocks
    cntlinkrst : out std_logic_vector (7  downto 0); -- number of link reset
    badver     : out std_logic;
    
    -- revolution signal and reduced clock output
    frame      : out std_logic;
    frame3     : out std_logic;
    frame9     : out std_logic;
    frameloc   : out std_logic_vector (10 downto 0);
    divclk1    : out std_logic_vector (1  downto 0);
    divclk2    : out std_logic_vector (1  downto 0);
    
    -- data out (may be or may not be useful)
    octet      : out std_logic_vector (7  downto 0);
    isk        : out std_logic;
    payload    : out std_logic_vector (76 downto 0);
    sigpayload : out std_logic;
    sigidle    : out std_logic;
    cntbit2    : out std_logic_vector (2  downto 0);
    cntoctet   : out std_logic_vector (4  downto 0);
    cntdato    : out std_logic_vector (3  downto 0);
    cntpacket  : out std_logic_vector (7  downto 0);

    -- regsel out
    regsel     : out std_logic_vector (4  downto 0);
    usrreg     : out std_logic_vector (7  downto 0);
    
    -- debug input to investigate link condition
    manual     : in  std_logic;
    clrdelay   : in  std_logic;
    incdelay   : in  std_logic;
    caldelay   : in  std_logic;
    
    -- debug output to investigate link condition
    bit2       : out std_logic_vector (1  downto 0);
    bit10      : out std_logic_vector (9  downto 0);
    cntdelay   : out std_logic_vector (6  downto 0);
    cntwidth   : out std_logic_vector (5  downto 0);
    staiddr    : out std_logic_vector (1  downto 0);
    starxerr   : out std_logic_vector (8  downto 0);
    comma      : out std_logic;
    iddrdbg    : out std_logic_vector (9  downto 0);
    crcdbg     : out std_logic_vector (8  downto 0) );
  
end b2tt_decode;
------------------------------------------------------------------------
architecture implementation of b2tt_decode is
  -- cnt_bit2:  (3-bit) 0..4 if in sync, 5 if out of sync
  -- cnt_octet:  (5-bit) 0..16 to count any octet in a packet (=16 alt.comma)
  -- cnt_packet: (8-bit) 0..15 to count packet in a revo frame (>15 not sync)
  -- cnt_frameloc: (11-bit) 0..1279 to locate position in a frame
  signal cnt_bit2      : std_logic_vector (2  downto 0) := "101";
  signal cnt_packet    : std_logic_vector (7  downto 0) := "00010000";
  signal cnt_frameloc  : std_logic_vector (10 downto 0) := "10100000000";

  signal buf_octet     : std_logic_vector (7  downto 0) := x"00";
  signal buf_isk       : std_logic := '0';
  signal sig_comma     : std_logic := '0';
  signal sta_ttup      : std_logic := '0';
  signal sta_octet     : std_logic := '0';
  signal sig_nocomma   : std_logic := '0';

  signal sig_bit2      : std_logic_vector (1  downto 0) := "00";
  signal sig_bit10     : std_logic_vector (9  downto 0) := (others => '0');
  signal sig_slip      : std_logic := '0';

  signal sig_incdelay  : std_logic := '0';
  signal sig_inccmd    : std_logic := '0';
  signal sig_calcmd    : std_logic := '0';  -- spartan6 only
  signal sig_caldelay  : std_logic := '0';  -- spartan6 only
  
  signal sig_newcomma  : std_logic := '0';

  signal sig_payload   : std_logic := '0';
  signal sig_idle      : std_logic := '0';
  signal buf_payload   : std_logic_vector (76 downto 0) := (others => '0');
  
  signal sig_trig      : std_logic := '0';
  signal sta_trgtag    : std_logic_vector (31 downto 0) := (others => '0');
  signal sig_utime     : std_logic_vector (31 downto 0) := (others => '0');
  signal sig_ctime     : std_logic_vector (26 downto 0) := (others => '0');
  
  signal sig_runreset  : std_logic := '0';
  signal sig_errreset  : std_logic := '0';
  
  signal sta_entagerr  : std_logic := '0';

  signal sta_trgmask   : std_logic := '0';
  signal sta_rstmask   : std_logic := '0';
  signal sig_tagset    : std_logic := '0';
  signal buf_tagin     : std_logic_vector (31 downto 0) := (others => '0');

  signal cnt_octet     : std_logic_vector (4  downto 0) := (others => '0');
  signal cnt_datoctet  : std_logic_vector (3  downto 0) := (others => '0');
  signal sig_ocerr     : std_logic_vector (5  downto 0) := (others => '0');
  signal sig_paerr     : std_logic_vector (2  downto 0) := (others => '0');

  signal sta_iddr      : std_logic_vector (1  downto 0) := "00";
  signal sta_crc8ok    : std_logic := '0';
begin

  -- in
  sig_caldelay <= caldelay or sig_calcmd;

  map_is: entity work.b2tt_iddr
    generic map ( FLIPIN  => FLIPTRG,
                  SIM_SPEEDUP => SIM_SPEEDUP )
    port map ( clock      => clock,
               invclock   => invclock,
               dblclock   => dblclock,
               dblclockb  => dblclockb,
               inp        => trgp,
               inn        => trgn,
               staoctet   => sta_octet,
               stacrc8ok  => sta_crc8ok,
               manual     => manual,
               incdelay   => incdelay,
               clrdelay   => clrdelay,
               caldelay   => sig_caldelay,  -- spartan6 only
               staiddr    => sta_iddr,      -- out
               bit2       => sig_bit2,      -- out
               cntdelay   => cntdelay,      -- out
               cntwidth   => cntwidth,      -- out
               iddrdbg    => iddrdbg );     -- out

  map_nd: entity work.b2tt_decomma
    port map ( ckup      => ckup,
               bit2      => sig_bit2,
               prev8     => sig_bit10(7 downto 0),
               cntbit2   => cnt_bit2,
               comma     => sig_comma,      -- out/async for debit2
               newcomma  => sig_newcomma ); -- out/async for debit2
  
  map_2b: entity work.b2tt_debit2
    port map ( clock      => clock,
               ckup       => ckup,
               nocomma    => sig_nocomma,
               newcomma   => sig_newcomma,
               comma      => sig_comma,
               bit2       => sig_bit2,
               bit10      => sig_bit10,    -- out
               cntbit2    => cnt_bit2,     -- out
               sigslip    => sig_slip );   -- out

  map_10: entity work.b2tt_debit10
    port map ( clock      => clock,
               cntbit2    => cnt_bit2,
               bit2       => sig_bit2,     -- to skip one clock wait for 10b
               bit10      => sig_bit10,
               octet      => buf_octet,    -- out/async for detrig/deoctet
               isk        => buf_isk );    -- out/async for detrig/deoctet

  map_tr: entity work.b2tt_detrig
    port map ( clock      => clock,
               ttup       => sta_ttup,
               mask       => sta_trgmask,
               runreset   => sig_runreset,
               cntbit2    => cnt_bit2,
               octet      => buf_octet,
               isk        => buf_isk,
               tagset     => sig_tagset,
               tagin      => buf_tagin,
               jtag       => jtag,         -- out
               jtagdbg    => jtagdbg,      -- out
               trgout     => sig_trig,     -- out
               trgtyp     => trgtyp,       -- out
               trgtag     => sta_trgtag,   -- out
               trgshort   => trgshort );   -- out

  map_oc: entity work.b2tt_deoctet
    port map ( clock      => clock,
               cntbit2    => cnt_bit2,
               octet      => buf_octet,
               isk        => buf_isk,
               nocomma    => sig_nocomma,  -- out
               staoctet   => sta_octet,    -- out
               stacrc8ok  => sta_crc8ok,   -- out
               sigpayload => sig_payload,  -- out
               sigidle    => sig_idle,     -- out
               incdelay   => sig_incdelay, -- out
               cntlinkrst => cntlinkrst,   -- out
               payload    => buf_payload,  -- out
               cntoctet   => cnt_octet,    -- out
               cntdato    => cnt_datoctet, -- out
               rxerr      => sig_ocerr,    -- out
               crcdbg     => crcdbg );     -- out

  map_pa: entity work.b2tt_depacket
    generic map ( PROTOCOL => PROTOCOL,
                  COMPAT   => COMPAT,
                  CLKDIV1  => CLKDIV1,
                  CLKDIV2  => CLKDIV2,
                  DEFADDR  => DEFADDR,
                  SIM_SPEEDUP => SIM_SPEEDUP )
    port map ( clock      => clock,
               staiddr    => sta_iddr,
               staoctet   => sta_octet,
               sigpayload => sig_payload,
               sigidle    => sig_idle,
               payload    => buf_payload,
               regsel     => regsel,       -- out 4 downto 0
               usrreg     => usrreg,       -- out 7 downto 0
               badver     => badver,       -- out
               clraddr    => clraddr,      -- out
               myaddr     => myaddr,       -- out
               frame      => frame,        -- out
               frame3     => frame3,       -- out
               frame9     => frame9,       -- out
               divclk1    => divclk1,      -- out
               divclk2    => divclk2,      -- out
               cntpacket  => cnt_packet,   -- out
               clkfreq    => clkfreq,      -- out
               utime      => sig_utime,    -- out
               ctime      => sig_ctime,    -- out
               frameloc   => cnt_frameloc, -- out
               runreset   => sig_runreset, -- out
               errreset   => sig_errreset, -- out
               bsyreset   => bsyreset,     -- out
               feereset   => feereset,     -- out
               b2lreset   => b2lreset,     -- out
               gtpreset   => gtpreset,     -- out
               semreset   => semreset,     -- out
               incdelay   => sig_inccmd,   -- out
               caldelay   => sig_calcmd,   -- out
               entagerr   => sta_entagerr, -- out
               running    => running,      -- out
               trgmask    => sta_trgmask,  -- out
               rstmask    => sta_rstmask,  -- out
               dismask    => dismask,      -- out
               ttup       => sta_ttup,     -- out
               timerr     => timerr,       -- out
               --timerr0    => timerr0,      -- out
               --timerr1    => timerr1,      -- out
               --timerr2    => timerr2,      -- out
               --timerr3    => timerr3,      -- out
               sigerr     => sig_paerr );  -- out
  
  map_tt: entity work.b2tt_detag
    port map ( clock      => clock,
               frameloc   => cnt_frameloc,
               ttup       => sta_ttup,
               entagerr   => sta_entagerr,
               mask       => sta_trgmask,
               runreset   => sig_runreset,
               trgtag     => sta_trgtag,
               sigpayload => sig_payload,
               payload    => buf_payload,
               exprun     => exprun,       -- out
               tagset     => sig_tagset,   -- out
               tagin      => buf_tagin,    -- out
               tagerr     => tagerr );     -- out

  -- out (async)
  isk        <= buf_isk;
  octet      <= buf_octet;
  
  -- out

  -- staoctet='1' when a valid comma is found
  -- ttup='1'  when >255 continuously valid packets are found
  staoctet   <= sta_octet;
  ttup       <= sta_ttup;
  runreset   <= sig_runreset;
  errreset   <= sig_errreset;
  staiddr    <= sta_iddr;
  starxerr   <= sig_paerr & sig_ocerr;
  
  cntbit2    <= cnt_bit2;
  cntoctet   <= cnt_octet;
  cntdato    <= cnt_datoctet;
  cntpacket  <= cnt_packet;
  comma      <= sig_comma;
  bit2       <= sig_bit2;
  bit10      <= sig_bit10;
  payload    <= buf_payload;
  sigpayload <= sig_payload;
  sigidle    <= sig_idle;

  trgout     <= sig_trig;
  trgtag     <= sta_trgtag;
  utime      <= sig_utime;
  ctime      <= sig_ctime;
  frameloc   <= cnt_frameloc;
  trgmask    <= sta_trgmask;
  rstmask    <= sta_rstmask;
  entagerr   <= sta_entagerr;
  
end implementation;

-- - emacs outline mode setup
-- Local Variables: ***
-- mode:outline-minor ***
-- outline-regexp:"-- -+" ***
-- End: ***

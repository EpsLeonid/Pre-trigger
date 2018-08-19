------------------------------------------------------------------------
--
--  b2tt_encode.vhd -- TT-link encoder for Belle2link frontend
--
--  Mikihiko Nakao, KEK IPNS
--
--  20130528 first version
--  20131002 oddr is separated out
--  20131101 no more std_logic_arith
--  20131126 hold "err" until runreset
--  20150406 ttup error study
--  20150406 fix busy 1 -> 0 -> 0 -> 1 sequence
--  20150330 b2tt_enoctet fully rewritten
--  20150611 err is not bsy, signal renamed: busyup -> bsyup etc
--  20170628 disparity fix for embedded bsyup/bsydn
--
--  eout bit 9 is first transmitted, bit 0 is last transmitted
--  ein  bit 9 is first received,    bit 0 is last received
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- b2tt_encounter
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity b2tt_encounter is
  port (
    clock      : in  std_logic;
    frame      : in  std_logic;
    staframe   : out std_logic;
    cntbit2    : out std_logic_vector (2 downto 0);
    cntoctet   : out std_logic_vector (3 downto 0);
    cntpacket  : out std_logic_vector (7 downto 0) );
end b2tt_encounter;
------------------------------------------------------------------------
architecture implementation of b2tt_encounter is
  signal sta_frame  : std_logic := '0';
  signal cnt_bit2   : std_logic_vector (2 downto 0) := "101";
  signal cnt_octet  : std_logic_vector (3 downto 0) := "0000";
  signal cnt_packet : std_logic_vector (7 downto 0) := x"00";
begin
  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      -- sta_frame
      if frame = '1' then
        if cnt_bit2 = 4 and cnt_octet = 15 and cnt_packet = 255 then
          sta_frame <= '1';
        else
          sta_frame <= '0';
        end if;
      end if;

      -- cnt_bit2
      if frame = '1' or cnt_bit2 = 4 then
        cnt_bit2 <= "000";
      else
        cnt_bit2 <= cnt_bit2 + 1;
      end if;

      -- cnt_octet
      if frame = '1' then
        cnt_octet <= x"0";
      elsif cnt_bit2 = 4 then
        cnt_octet <= cnt_octet + 1;
      end if;

      -- cnt_packet
      if frame = '1' then
        cnt_packet <= x"00";
      elsif cnt_bit2 = 4 and cnt_octet = 15 then
        cnt_packet <= cnt_packet + 1;
      end if;
      
    end if;
  end process;

  -- out
  staframe  <= sta_frame;
  cntbit2   <= cnt_bit2;
  cntoctet  <= cnt_octet;
  cntpacket <= cnt_packet;

end implementation;
------------------------------------------------------------------------
-- b2tt_enoctet
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

entity b2tt_enoctet is
  port (
    clock      : in  std_logic;
    inbsy      : in  std_logic;
    cntbit2    : in  std_logic_vector (2 downto 0);
    cntoctet   : in  std_logic_vector (3 downto 0);
    payload    : in  std_logic_vector (111 downto 0); -- 14 bytes
    octet      : out std_logic_vector (7 downto 0);
    isk        : out std_logic );
end b2tt_enoctet;
------------------------------------------------------------------------
architecture implementation of b2tt_enoctet is
  signal buf_payload : std_logic_vector (111 downto 0) := (others => '0');
  signal cnt_enoctet : std_logic_vector (3   downto 0) := (others => '0');
  signal sta_crc8    : std_logic_vector (7   downto 0) := x"00";
  subtype byte_t is  std_logic_vector (7 downto 0);

  -- from crc8.vhd and comlib.vhd of
  -- http://opencores.org/project,w11
  -- 0x4d (x8 + x6 + x3 + x2 + 1)   [ shr 1 makes 0xa6 ]
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
  proc: process (clock)
  begin
    if clock'event and clock = '1' then
      -- cnt_datoctet
      if cntbit2 /= 2 then
        -- nothing
      elsif cntoctet = 15 then
        cnt_enoctet <= (others => '0');
      elsif inbsy = '0' then
        cnt_enoctet <= cnt_enoctet + 1;
      end if;
      
      -- buf_payload
      if cntbit2 /= 2 then
        -- nothing
      elsif cnt_enoctet = 0 then
        buf_payload <= payload;
      elsif inbsy = '0' then
        buf_payload <= buf_payload(103 downto 0) & x"00";
      end if;
      
      -- sta_crc8
      --   this code doesn't care about inbsy, but it will not be
      --   sent anyway if inbsy occurs
      if cntbit2 /= 2 then
        -- nothing
      elsif cnt_enoctet = 0 then
        sta_crc8 <= (others => '0');
      else
        sta_crc8 <= crc8_update(sta_crc8, buf_payload(111 downto 104));
      end if;

      -- octet/isk (data to encode)
      if cntbit2 /= 2 then
        -- nothing
      elsif cnt_enoctet = 0 then
        octet <= K28_1;
        isk   <= '1';
      elsif cnt_enoctet = 15 then
        octet <= sta_crc8;
        isk   <= '0';
      elsif inbsy = '0' then
        octet <= buf_payload(111 downto 104);
        isk <= '0';
      end if;
    end if;
  end process;
end implementation;
------------------------------------------------------------------------
-- b2tt_enbit2
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity b2tt_enbit2 is
  port (
    clock    : in  std_logic;
    errreset : in  std_logic;
    cntbit2  : in  std_logic_vector (2 downto 0);
    octet    : in  std_logic_vector (7 downto 0);
    isk      : in  std_logic;
    bsyin    : in  std_logic;
    --errin    : in  std_logic;
    inbsy    : out std_logic;
    bsyup    : out std_logic; -- for debug
    bsydn    : out std_logic; -- for debug
    bit2     : out std_logic_vector (1 downto 0);
    validk   : out std_logic;
    rdnext   : out std_logic;
    rd6p     : out std_logic;
    rd4p     : out std_logic );
end b2tt_enbit2;
------------------------------------------------------------------------
architecture implementation of b2tt_enbit2 is
  signal sig_en     : std_logic := '0';
  signal buf_10b    : std_logic_vector (9 downto 0) := "0000000000";
  signal seq_10b    : std_logic_vector (7 downto 0) := "00000000";
  signal seq_bsy    : std_logic_vector (1 downto 0) := "00";
  --signal seq_err    : std_logic_vector (1 downto 0) := "00";
  --signal sta_err    : std_logic := '0';
  signal sig_bsyup  : std_logic := '0';
  signal sig_bsydn  : std_logic := '0';
  signal cnt_k285   : std_logic_vector (2 downto 0) := "000";
  signal seq_k285   : std_logic_vector (7 downto 0) := "00000000";
begin
  -- in
  sig_bsyup  <= '1' when seq_bsy = "01" and cnt_k285 = 0 else '0';
  sig_bsydn  <= '1' when seq_bsy = "10" and cnt_k285 = 0 else '0';
  sig_en     <= '1' when cntbit2  = 3 and
                sig_bsyup = '0' and sig_bsydn = '0' and cnt_k285 = 0 else '0';
  --sig_bsydn  <= '1' when seq_bsy = "10" and cnt_k285 = 0
  --                                      and sta_err = '0' else '0';
  map_en8b10b: entity work.b2tt_en8b10b
    port map (
      reset  => '0',
      clock  => clock,
      en     => sig_en,
      isk    => isk,
      din    => octet,
      eout   => buf_10b, -- out/async
      validk => validk,  -- out
      rdnext => rdnext,  -- out
      rd6psav => rd6p,   -- out
      rd4psav => rd4p ); -- out

  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      -- seq_bsy to detect busy up/down
      if errreset = '1' then
        seq_bsy <= "00";
      elsif cnt_k285 = 0 then
        seq_bsy <= seq_bsy(0) & bsyin;
      else
        seq_bsy <= seq_bsy(0) & seq_bsy(0); -- 2017.0623.0621 
      end if;

      -- seq_k285, cnt_k285 (to intercept the bit stream with K28.5)
      -- inbsy (to suspend other tasks for 5 clocks of K28.5 sending)
      -- seq_10b (bit 7..0 of 8b10b data, bit 9..8 directly goes to bit2)
      if sig_bsyup = '1' then
        seq_k285 <= "00000101";
        cnt_k285 <= "100";
        inbsy    <= '1';
        bsyup    <= '1';
      elsif sig_bsydn = '1' then
        seq_k285 <= "11111010";
        cnt_k285 <= "100";
        inbsy    <= '1';
        bsydn    <= '1';
      elsif cnt_k285 /= 0 then
        cnt_k285 <= cnt_k285 - 1;
        seq_k285 <= seq_k285(5 downto 0) & "00";
        inbsy    <= '1';
      elsif cntbit2 = 3 then
        seq_10b  <= buf_10b(7 downto 0);
        inbsy    <= '0';
        bsyup    <= '0';
        bsydn    <= '0';
      else
        seq_10b  <= seq_10b(5 downto 0) & "00";
        inbsy    <= '0';
        bsyup    <= '0';
        bsydn    <= '0';
      end if;

    end if;
  end process;

  -- out (partially async)
  -- busy-begin: K28.5+ 1100000101
  -- busy-end:   K28.5- 0011111010
  bit2   <= "11" when seq_bsy = "01" and cnt_k285 = 0 else
            "00" when seq_bsy = "10" and cnt_k285 = 0 else
            seq_k285(7 downto 6) when cnt_k285 /= 0 else
            buf_10b(9 downto 8) when cntbit2 = 3 else -- async
            seq_10b(7 downto 6);

end implementation;
------------------------------------------------------------------------
-- b2tt_encode
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity b2tt_encode is
  generic (
    constant FLIPACK : std_logic := '0' );
  port (
    clock     : in  std_logic;
    invclock  : in  std_logic;
    frame     : in  std_logic;
    errreset  : in  std_logic;
    bsyin     : in  std_logic;
    --errin     : in  std_logic;
    payload   : in  std_logic_vector (111 downto 0);
    fillsig   : out std_logic;
    ackp      : out std_logic;
    ackn      : out std_logic;
    cntbit2   : out std_logic_vector (2  downto 0);
    cntoctet  : out std_logic_vector (3  downto 0);
    isk       : out std_logic;
    octet     : out std_logic_vector (7  downto 0);
    bsyup     : out std_logic;
    bsydn     : out std_logic;
    bit2      : out std_logic_vector (1  downto 0) );
end b2tt_encode;
------------------------------------------------------------------------
architecture implementation of b2tt_encode is
  signal sta_frame   : std_logic := '0';
  signal sig_inbsy   : std_logic := '0';
  signal cnt_bit2    : std_logic_vector (2 downto 0) := "101";
  signal cnt_octet   : std_logic_vector (3 downto 0) := "0000";
  signal cnt_packet  : std_logic_vector (7 downto 0) := x"00";
  signal sig_bit2    : std_logic_vector (1 downto 0) := "00";
  signal buf_isk     : std_logic := '0';
  signal buf_octet   : std_logic_vector (7 downto 0) := x"00";
  signal buf_rdnext  : std_logic := '0';
  signal buf_rd6p    : std_logic := '0';
  signal buf_rd4p    : std_logic := '0';
  signal sig_validk  : std_logic := '0';
begin

  map_co: entity work.b2tt_encounter
    port map (
      clock     => clock,
      frame     => frame,
      staframe  => sta_frame,    -- out
      cntbit2   => cnt_bit2,     -- out
      cntoctet  => cnt_octet,    -- out
      cntpacket => cnt_packet ); -- out

  map_oc: entity work.b2tt_enoctet
    port map (
      clock     => clock,
      inbsy     => sig_inbsy,
      cntbit2   => cnt_bit2,
      cntoctet  => cnt_octet,
      payload   => payload,
      octet     => buf_octet, -- out
      isk       => buf_isk ); -- out

  map_b2: entity work.b2tt_enbit2
    port map (
      clock     => clock,
      errreset  => errreset,
      cntbit2   => cnt_bit2,
      octet     => buf_octet,
      isk       => buf_isk,
      bsyin     => bsyin,
      --errin     => errin,
      inbsy     => sig_inbsy,  -- out
      bsyup     => bsyup,      -- out
      bsydn     => bsydn,      -- out
      bit2      => sig_bit2,   -- out/async
      validk    => sig_validk, -- out/async
      rdnext    => buf_rdnext, -- out
      rd6p      => buf_rd6p,   -- out
      rd4p      => buf_rd4p ); -- out

  map_od: entity work.b2tt_oddr
    generic map (
      FLIPOUT   => FLIPACK )
    port map (
      clock     => clock,
      invclock  => invclock,
      mask      => '0',  -- for ftsw only
      bit2      => sig_bit2,
      outp      => ackp,    -- out
      outn      => ackn );  -- out
  
  -- async-out
  bit2     <= sig_bit2;
  
  -- out
  octet    <= buf_octet;
  isk      <= buf_isk;
  cntbit2  <= cnt_bit2;
  cntoctet <= cnt_octet;
  fillsig  <= '1' when cnt_bit2 = 4 and cnt_octet = 15 else '0';
  
end implementation;

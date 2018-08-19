------------------------------------------------------------------------
-- b2tt_fifo component
--
-- 20131127 duplicated header fix (sta_drd was not properly cleared)
--
-- RAMB18 usage
--
-- - V5LX30(FTSW) has 64 ramb18
--   V5LX30T(MGTF) has 72 ramb18
--   V5LX50T(HSLB) has 120 ramb18
--
-- - each ramb18 has address space of
--    (13 downto 0) for 16384 bit
--    (13 downto 3) for 2048 byte
--    (13 downto 4) for 1024 word (16-bit)
--
-- - one event uses 64-bit, i.e., 4 16-bit words
--
-- - one ramb18 can store up to 255 event
--   (256th event is not used to distinguish full and empty)
--
-- (RAMB36 is not used)
-- RAMB36 usage (ug190 v4.3 p111)
--  port A - 8-bit I/O, auto incrementing address
--  port B - 8 or 16 or 32-bit I/O, read only
--
-- - 21 bit address space (20 downto 0) to cover 2 Mbit space,
--   or up to 64 ramb36 blocks (each ramb36 has 4096 bytes).
--
-- - V5LX30(FTSW) has 32 ramb36
--   V5LX30T(MGTF) has 36 ramb36
--   V5LX50T(HSLB) has 60 ramb36
--
-- - each ramb36 has address space of
--    (14 downto 0) for 32768 bit
--    (14 downto 3) for 4096 byte
--    (14 downto 4) for 2048 word (16-bit)
--    (14 downto 5) for 1024 long (32-bit)
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.ALL;

entity b2tt_fifo is
  port (
    clock  : in  std_logic;
    enfifo : in  std_logic;
    clr    : in  std_logic;
    wr     : in  std_logic;
    din    : in  std_logic_vector (95 downto 0);
    rd     : in  std_logic;
    ready  : out std_logic;
    dout   : out std_logic_vector (95 downto 0);
    drd    : out std_logic_vector (95 downto 0);
    errs   : out std_logic_vector (3  downto 0);
    dbg    : out std_logic_vector (17 downto 0);
    err    : out std_logic;
    empty  : out std_logic;
    full   : out std_logic );
end b2tt_fifo;

architecture implementation of b2tt_fifo is

  signal buf_addra  : std_logic_vector (9  downto 0) := (others => '0');
  signal buf_addrb  : std_logic_vector (9  downto 0) := (others => '0');
  signal sta_adiff  : std_logic_vector (9  downto 0) := (others => '0');

  signal seq_wr     : std_logic := '0';
  signal seq_rd     : std_logic_vector (1  downto 0) := (others => '0');

  signal seq_dwr    : std_logic_vector (5  downto 0) := (others => '0');
  signal buf_dwr    : std_logic_vector (95 downto 0) := (others => '0');
  
  signal sta_drd    : std_logic := '0';
  signal sig_drd    : std_logic_vector (15 downto 0) := (others => '0');
  signal seq_drd    : std_logic_vector (5  downto 0) := (others => '0');
  signal buf_drd    : std_logic_vector (95 downto 0) := (others => '0');
  signal sta_dout   : std_logic := '0';
  signal sta_ready  : std_logic := '0';
  signal buf_dout   : std_logic_vector (95 downto 0) := (others => '0');
  
  signal sta_orun   : std_logic := '0';
  signal sta_empty  : std_logic := '0';
  signal sta_empty2 : std_logic := '0';
  signal sta_half   : std_logic := '0';
  signal sta_full   : std_logic := '0';
  signal cnt_skip   : std_logic_vector (1  downto 0) := (others => '0');
  signal sta_err    : std_logic_vector (2  downto 0) := (others => '0');
  signal sig_dbg    : std_logic_vector (23 downto 0) := (others => '0');

  signal open_doa   : std_logic_vector (31 downto 0) := (others => '0');
  signal open_dob   : std_logic_vector (15 downto 0) := (others => '0');
  signal open_dopa  : std_logic_vector (3  downto 0) := (others => '0');
  signal open_dopb  : std_logic_vector (3  downto 0) := (others => '0');
begin
  -- in
  sta_adiff  <= buf_addra - buf_addrb when buf_addra >= buf_addrb else
                buf_addra + 1024 - buf_addrb;
  sta_empty  <= '1' when sta_adiff < (seq_drd'left+1) else '0';
  sta_empty2 <= '1' when sta_adiff < (seq_drd'left+2) else '0';
  
  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      -- sta_err
      if clr = '1' or enfifo = '0' then
        sta_err <= (others => '0');
      else
        if wr = '1' and seq_dwr /= 0 then
          sta_err(0) <= '1';
        end if;
        if wr = '1' and sta_full = '1' then
          sta_err(1) <= '1';
        end if;
        if wr = '1' and seq_wr = '1' then
          sta_err(2) <= '1';
        end if;
      end if;
      
      -- buf_dout, sta_dout, sta_ready
      if clr = '1' then
        buf_dout <= (others => '1');
        sta_dout <= '0';
        sta_ready <= '0';
      elsif rd = '1' then
        sta_ready <= '0'; -- need at least one clock gap
      elsif (seq_rd = "01" or sta_dout = '0') and sta_drd = '1' then
        buf_dout <= buf_drd; -- from cache buffer
        sta_dout <= '1';
        sta_ready <= '1';
      elsif sta_dout = '0' and sta_drd = '0' and  -- not in cache buffer
            sta_empty2 = '1' and (cnt_skip /= 0 or seq_drd = 0) and
            seq_wr = '0' and wr = '1' then        -- and at write timing
        buf_dout <= din;
        sta_dout <= '1';
        sta_ready <= '1';
      elsif seq_rd = "01" then
        buf_dout(buf_dout'left downto 8) <= (others => '1');
        buf_dout(7             downto 0) <= x"f2";
        sta_dout <= '0';
      end if;

      -- cnt_skip
      if clr = '1' then
        cnt_skip <= (others => '0');
      elsif (seq_rd = "01" or sta_dout = '0') and sta_drd = '1' then
        --
      elsif sta_dout = '0' and sta_drd = '0' and  -- not in cache buffer
            sta_empty2 = '1' and (cnt_skip /= 0 or seq_drd = 0) and
            seq_wr = '0' and wr = '1' then        -- and at write timing
        cnt_skip <= cnt_skip + 1;
        if cnt_skip = 0 then
          sig_dbg <= "00" & buf_addra & "00" & buf_addrb;
        end if;
      elsif seq_drd(seq_drd'left) = '1' and
            seq_drd(seq_drd'left-1 downto 0) = 0 and cnt_skip /= 0 then
        cnt_skip <= cnt_skip - 1;
      end if;
      
      -- buf_dwr, seq_dwr
      if seq_wr = '0' and wr = '1' and seq_dwr = 0 and sta_full = '0' then
        buf_dwr <= din;
        seq_dwr <= (others => '1');
      else
        buf_dwr <= buf_dwr(buf_dwr'left-16 downto 0) & x"0000";
        seq_dwr <= seq_dwr(seq_dwr'left-1  downto 0) & '0';
      end if;

      -- seq_drd
      if clr = '1' then
        seq_drd <= (others => '0');
      elsif sta_drd = '0' and sta_empty = '0' and seq_drd = 0 then
        seq_drd <= (others => '1');
      else
        seq_drd <= seq_drd(seq_drd'left-1 downto 0) & '0';
      end if;

      -- sta_drd
      if clr = '1' then
        sta_drd <= '0';
      elsif (seq_rd = "01" or sta_dout = '0') and sta_drd = '1' then
        sta_drd <= '0';
      elsif seq_drd(seq_drd'left) = '1' and
            seq_drd(seq_drd'left-1 downto 0) = 0 and cnt_skip = 0 then
        sta_drd <= '1';
      end if;

      -- buf_drd
      if clr = '1' then
        buf_drd <= (others => '1');
      elsif cnt_skip /= 0 then
        --buf_drd <= (others => '1');
        buf_drd(buf_drd'left downto 40) <= (others => '1');
        buf_drd(39           downto 16) <= sig_dbg;
        buf_drd(15           downto 12) <= "00" & cnt_skip;
        buf_drd(11           downto  8) <= '0' & sta_err;
        buf_drd(7            downto  0) <= x"f1";
      elsif seq_drd(seq_drd'left) = '1' then
        buf_drd <= buf_drd(buf_drd'left - 16 downto 0) & sig_drd;
      elsif seq_rd = "01" then
        --buf_drd <= (others => '1');
        buf_drd(buf_drd'left downto 8) <= (others => '1');
        buf_drd(7            downto 0) <= x"f0";
      end if;

      -- seq_rd, seq_wr
      seq_wr <= wr;
      seq_rd <= seq_rd(0) & rd;

      -- buf_addra
      if clr = '1' then
        buf_addra <= (others => '0');
      elsif seq_dwr(seq_dwr'left) = '1' then
        buf_addra <= buf_addra + 1;  -- turn over to 0
      end if;

      -- buf_addrb
      if clr = '1' then
        buf_addrb <= (others => '0');
      elsif sta_drd = '0' and sta_empty = '0' and seq_drd = 0 then
        buf_addrb <= buf_addrb + 1;  -- condition to set seq_drd all '1'
      elsif seq_drd(seq_drd'left-1) = '1' then
        buf_addrb <= buf_addrb + 1;  -- turns over to 0
      end if;
      
      -- sta_orun
      if clr = '1' or enfifo = '0' then
        sta_orun <= '0';
      elsif sta_dout = '0' and seq_rd = "01" then
        sta_orun <= '1';
      end if;
      
      -- sta_full
      --  one event consumes 6 16-bit words
      --  fifo size : 1024x16-bit word = 170 x (16-bit x 6) event
      --  full limit set at 168 event
      --  half limit set at 150 event, 18 trigger may still come
      if clr = '1' or enfifo = '0' then
        sta_full <= '0';
        sta_half <= '0';
      elsif sta_adiff >= 150*6 and sta_orun = '0' then
        sta_half <= '1';
      elsif sta_adiff >= 168*6 and sta_orun = '0' then
        sta_full <= '1';
      else
        sta_half <= '0';
      end if;
    end if; -- event
  end process;

  -- RAMB16BWER
  map_ram: ramb16bwer
    generic map (
      DATA_WIDTH_A => 18, DATA_WIDTH_B => 18 )
    
    port map (
      -- port A
      addra(13 downto 4)  => buf_addra,
      addra(3  downto 0)  => "0000",
      dia(31 downto 16)   => x"0000",
      dia(15 downto 0)    => buf_dwr(buf_dwr'left downto buf_dwr'left-15),
      dipa                => "0000",
      doa                 => open_doa,
      dopa                => open_dopa,
      wea(3 downto 2)     => "00",
      wea(1)              => seq_dwr(seq_dwr'left),
      wea(0)              => seq_dwr(seq_dwr'left),
      ena                 => '1',
      regcea              => '1',
      rsta                => '0',
      clka                => clock,
      
      -- port B
      addrb(13 downto 4)  => buf_addrb,
      addrb(3  downto 0)  => "0000",
      dib                 => x"00000000",
      dipb                => "0000",
      dob(31 downto 16)   => open_dob,
      dob(15 downto 0)    => sig_drd,
      dopb                => open_dopb,
      web                 => "0000",
      enb                 => '1',
      regceb              => '1',
      rstb                => '0',
      clkb                => clock );
     
  -- out (async)
  empty <= sta_empty;
  
  -- out
  ready <= sta_ready;
  errs  <= sta_orun & sta_err;
  err   <= '1' when sta_err /= 0 else (sta_full or sta_orun);
  full  <= sta_half;
  dout  <= buf_dout;
  drd   <= buf_drd;
  dbg <= sta_dout & sta_drd & buf_addrb(7 downto 0) & buf_addra(7 downto 0);
  
end implementation;

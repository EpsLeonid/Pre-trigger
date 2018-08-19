------------------------------------------------------------------------
-- entity
--
-- address space
--  00..3f  regular 8-bit read/write
--  40..6d  regular 8-bit set (one-shot) registers
--  6e..6f  RAM interface and 32-bit register interface
--  70..7f  FINESSE special
--  80..bf  regular 32-bit read/write
--  c0..ff  regular 32-bit read-only (write=clear)
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.ALL;
library work;
use work.mytypes.all;

entity myregs is
  generic (
    constant MAX_RW8   : integer := 8;
    constant MAX_RO8   : integer := 8;
    constant MAX_RW32  : integer := 8;
    constant MAX_RO32  : integer := 8;
    constant VERSION   : integer := 0 );
  
  port (
    -- from/to outside of the FPGA
    dat    : inout std_logic_vector (7 downto 0);
    adr    : in    std_logic_vector (6 downto 0);
    csb    : in    std_logic;
    rd     : in    std_logic;
    sck    : in    std_logic;

    -- from/to other part of FPGA
    inib   : in    byte_vector      (MAX_RW8-1  + 16#00# downto 16#00#);
    regb   : out   byte_vector      (MAX_RW8-1  + 16#00# downto 16#00#);
    setb   : out   std_logic_vector (MAX_RW8-1  + 16#00# downto 16#00#);
    stab   : in    byte_vector      (MAX_RO8-1  + 16#40# downto 16#40#);
    getb   : out   std_logic_vector (MAX_RO8-1  + 16#40# downto 16#40#);
    inil   : in    long_vector      (MAX_RW32-1 + 16#80# downto 16#80#);
    regl   : out   long_vector      (MAX_RW32-1 + 16#80# downto 16#80#);
    setl   : out   std_logic_vector (MAX_RW32-1 + 16#80# downto 16#80#);
    stal   : in    long_vector      (MAX_RO32-1 + 16#c0# downto 16#c0#);
    getl   : out   std_logic_vector (MAX_RO32-1 + 16#c0# downto 16#c0#) );
end myregs;

architecture implementation of myregs is

  signal seq_csb    : std_logic_vector (3 downto 0) := "0001";
  signal st_32data  : long_t;
  signal st_32byte  : byte_t;
  signal st_32read  : std_logic;
  signal st_32write : std_logic;
  signal st_32shift : std_logic;

  signal seq_setb   : std_logic_vector (MAX_RW8-1  + 16#00# downto 16#00#);
  signal seq_getb   : std_logic_vector (MAX_RO8-1  + 16#40# downto 16#40#);
  signal seq_setl   : std_logic_vector (MAX_RW32-1 + 16#80# downto 16#80#);
  signal seq_getl   : std_logic_vector (MAX_RO32-1 + 16#c0# downto 16#c0#);

  signal first      : std_logic := '1';

  signal reg_b      : byte_vector      (MAX_RW8-1  + 16#00# downto 16#00#);
  signal reg_l      : long_vector      (MAX_RW32-1 + 16#80# downto 16#80#);

  signal cnt_rdbg : byte_t := x"00";
  signal cnt_wdbg : byte_t := x"00";
  
begin
  readwrite_proc: process(sck)
    variable ahi   : std_logic;
    variable alo   : integer;
    variable rd32  : std_logic;
    variable a32hi : std_logic;
    variable a32lo : integer;
  begin
    regb <= reg_b;
    regl <= reg_l;
    
    ahi := adr(6);
    alo := conv_integer(adr(5 downto 0));

    rd32  := not dat(7);
    a32hi := dat(6);
    a32lo := conv_integer(dat(5 downto 0));

    if sck'event and sck = '1' then

      seq_csb <= seq_csb(2 downto 0) & csb;

      if seq_csb(2 downto 1) = "01" then
        setb     <= seq_setb;
        getb     <= seq_getb;
        setl     <= seq_setl;
        getl     <= seq_getl;
        seq_setb <= (others => '0');
        seq_getb <= (others => '0');
        seq_setl <= (others => '0');
        seq_getl <= (others => '0');
      else
        setb <= (others => '0');
        getb <= (others => '0');
        setl <= (others => '0');
        getl <= (others => '0');
      end if;

      if first = '1' then
        reg_l  <= inil;
        reg_b  <= inib;
        first <= '0';
      elsif seq_csb(3 downto 0) = "0111" then
        dat <= (others => 'Z');
        
      elsif seq_csb(2 downto 1) = "01" then  -- end of I/O cycle
        dat <= (others => 'Z');

        -- 32-bit I/O handling
        if st_32write = '1' then
          st_32write <= '0';
          st_32data <= st_32data(23 downto 0) & st_32byte;
          st_32shift <= '0';
        elsif st_32read = '1' then
          st_32shift <= '1';
          st_32read <= '0';
          st_32data <= x"00" & st_32data(31 downto 8);
        else
          st_32shift <= '0';
        end if;

      elsif seq_csb(1 downto 0) /= "10" then
        -- do nothing unless falling edge of csb

      elsif adr = 16#68# then ------------------------- D07_00 16#68# --
        if rd = '0' then
          st_32data(7 downto 0) <= dat;
        elsif rd = '1' then
          dat <= st_32data(7 downto 0);
        end if;
        
      elsif adr = 16#69# then ------------------------- D15_08 16#69# --
        if rd = '0' then
          st_32data(15 downto 8) <= dat;
        elsif rd = '1' then
          dat <= st_32data(15 downto 8);
        end if;
        
      elsif adr = 16#6a# then ------------------------- D23_16 16#6a# --
        if rd = '0' then
          st_32data(23 downto 16) <= dat;
        elsif rd = '1' then
          dat <= st_32data(23 downto 16);
        end if;
        
      elsif adr = 16#6b# then ------------------------- D31_24 16#6b# --
        if rd = '0' then
          st_32data(31 downto 24) <= dat;
        elsif rd = '1' then
          dat <= st_32data(31 downto 24);
        end if;
        
      elsif adr = 16#6c# then -------------------------- RDBG 16#6c# --
        if rd = '1' then
          dat <= cnt_rdbg;
          cnt_rdbg <= cnt_rdbg + 1;
        end if;
        
      elsif adr = 16#6d# then -------------------------- WDBG 16#6d# --
        if rd = '0' then
          cnt_wdbg <= cnt_wdbg + 1;
        else
          dat <= cnt_wdbg;
        end if;
        
      elsif adr = 16#77# and rd = '1' then -------------- REV 16#77# --
        dat <= conv_std_logic_vector(VERSION mod 65536, 8);
        
      elsif adr = 16#7a# and rd = '1' then -------------- VER 16#7a# --
        dat <= conv_std_logic_vector(VERSION / 65536, 8);

      elsif ahi = '0' and alo < MAX_RW8 and rd = '1' then
        dat <= reg_b(alo + 16#00#);
      elsif ahi = '0' and alo < MAX_RW8 and rd = '0' then
        reg_b(alo + 16#00#) <= dat;
        seq_setb(alo + 16#00#) <= '1';
      elsif ahi = '1' and alo < MAX_RO8 and rd = '1' then
        dat <= stab(alo + 16#40#);
        seq_getb(alo + 16#40#) <= '1';
        
      elsif adr = 16#6e# then ---------------------------- D32 16#6e# --
        if rd = '0' then
          st_32byte  <= dat;
          st_32write <= '1';
        elsif rd = '1' then
          dat <= st_32data(7 downto 0);
          st_32read <= '1';
        end if;
        
      elsif adr = 16#6f# and rd = '0' then --------------- A32 16#6f# --

        if a32hi = '0' and a32lo < MAX_RW32 and rd32 = '1' then
          st_32data <= reg_l(a32lo + 16#80#);  -- 0x80..0xbf read
        elsif a32hi = '0' and a32lo < MAX_RW32 and rd32 = '0' then
          reg_l(a32lo + 16#80#) <= st_32data;  -- 0x80..0xbf write
          seq_setl(a32lo + 16#80#) <= '1';
        elsif a32hi = '1' and a32lo < MAX_RO32 and rd32 = '1' then
          st_32data <= stal(a32lo + 16#c0#);  -- 0xc0..0xff read
          seq_getl(a32lo + 16#c0#) <= '1';
          
        else
          st_32data <= (others => '0');
        end if;

      elsif adr = 16#74# or adr = 16#75# or adr = 16#77# or
            adr = 16#7d# or adr = 16#7e# then
        dat <= (others => 'Z');
      elsif seq_csb(1) = '1' then ------- only at falling edge of csb --
        dat <= (others => '0'); ---------------- for unused addresses --

      end if; ------------------------------- end of read/write cases --
    end if;
  end process;
end implementation;

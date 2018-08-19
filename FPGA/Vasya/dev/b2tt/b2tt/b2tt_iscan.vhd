------------------------------------------------------------------------
--
--  b2tt_iscan.vhd -- b2tt delay scan
--
--  Mikihiko Nakao, KEK IPNS
--
--  20140711 split from b2tt_ddr_v6.vhd
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- - b2tt_iscan
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity b2tt_iscan is
  generic (
    FLIPIN    : std_logic := '0';
    REFFREQ   : real      := 203.546;
    SLIPBIT   : integer   := 1;     -- 0 for v5/s6, 1 for v6
    FULLBIT   : integer   := 9;     -- 7 for v5/v6, 9 for s6
    WRAPCOUNT : integer   := 25;    -- 51 for v5, 25 for v6, 170 for s6
    FULLCOUNT : integer   := 100; -- WC*4 for v6, WC*2 for v5/s6
    SIM_SPEEDUP : std_logic := '0' );
  --
  -- Virtex-5 and Virtex-6 (both):
  --   1 tap = 7.8 ns / ((8/5*64)) = 78 ps
  --   [for V5, idelayctrl clock tick = 7.8 ns / (8/5)]
  -- Virtex-5: 51 taps to cover the delay range (V5)
  -- Virtex-6: there is no way to cover half clock width of 3.9ns
  --   since 31 is the max tap which is about 2.4ns
  --   => oversample with iserdes for 1.95ns period to be covered
  --      by 25 taps (cnt_islip=0..3)
  --
  port (
    -- from/to b2tt_decode
    clock     : in  std_logic;
    staoctet  : in  std_logic;
    stacrc8ok : in  std_logic;
    manual    : in  std_logic;
    incdelay  : in  std_logic;
    clrdelay  : in  std_logic;
    staiddr   : out std_logic_vector (1  downto 0);
    cntdelay  : out std_logic_vector (6  downto 0);
    cntwidth  : out std_logic_vector (5  downto 0);
    iddrdbg   : out std_logic_vector (9  downto 0);
    -- from/to b2tt_iddr
    siginc    : out std_logic;
    sigislip  : out std_logic;
    clrinc   : out std_logic;
    clrislip   : out std_logic );

end b2tt_iscan;
------------------------------------------------------------------------
architecture implementation of b2tt_iscan is

  function aorb ( c : std_logic; a : integer; b : integer ) return integer is
  begin
    if c = '1' then
      return a;
    else
      return b;
    end if;
  end function aorb;

  constant FMAX  : integer := aorb(SIM_SPEEDUP, 3, FULLCOUNT);
  constant IMAX  : integer := FMAX - 1;
  constant CMAX  : integer := aorb(SIM_SPEEDUP, 7, 19);  -- cnt_cycle'left
  
  signal seq_inc     : std_logic_vector (1  downto 0) := "00";
  signal sig_inc     : std_logic := '0';
  signal clr_inc     : std_logic := '0';
  signal clr_islip   : std_logic := '0';
  signal sig_islip   : std_logic := '0';
  signal cnt_islip   : std_logic_vector (0 downto 0)  := (others => '0');
  signal cnt_delay   : std_logic_vector (7 downto 0)  := (others => '0');
  signal sta_iddr    : std_logic_vector (1  downto 0) := "00";
  signal sta_ioctet  : std_logic_vector (IMAX downto 0) := (others => '0');
  signal sta_icrc8   : std_logic_vector (IMAX downto 0) := (others => '0');
  signal cnt_cycle   : std_logic_vector (CMAX downto 0) := (others => '0');

  signal cnt_iddr    : std_logic_vector (9  downto 0) := (others => '0');
  signal sta_spos    : std_logic_vector (9  downto 0) := (others => '1');
  signal sta_smax    : std_logic_vector (9  downto 0) := (others => '0');
  signal sta_ezero   : std_logic_vector (9  downto 0) := (others => '0');
  signal sta_lenmax  : std_logic_vector (9  downto 0) := (others => '0');
  signal sta_lenhalf : std_logic_vector (9  downto 0) := (others => '0');
  signal sta_ibest   : std_logic_vector (9  downto 0) := (others => '0');
  signal sta_iok     : std_logic := '0';

  -- dbg
  signal seq_iddr    : std_logic_vector (1 downto 0) := (others => '0');
  signal cnt_dbg     : std_logic_vector (5 downto 0) := (others => '0');
begin
  -- in
  sta_iok     <= sta_ioctet(0) and sta_icrc8(0);
  sta_lenhalf <= '0' & sta_lenmax(sta_lenmax'left downto 1);
  
  process (clock)
  begin
    if clock'event and clock = '1' then

      -- sta_iddr = 0 : no stable delay
      --            1 : scan mode
      --            2 : setting mode to the found scan
      --            3 : stable delay
      if clrdelay = '1' then
        sta_iddr <= "00";
      elsif manual = '1' then
        sta_iddr <= "11";
      elsif sta_iddr = 0 then
        sta_iddr <= "01";
      elsif sta_iddr = 1 and cnt_iddr = FMAX then
        sta_iddr <= "10";
      elsif sta_iddr = 2 and sta_lenmax < 3 then
        sta_iddr <= "00";
      elsif sta_iddr = 2 and cnt_iddr = sta_ibest and (not cnt_cycle) = 1 then
        sta_iddr <= "11";
      elsif sta_iddr = 3 and (staoctet = '0' or stacrc8ok = '0') then
        sta_iddr <= "00";
      end if;

      -- cnt_iddr  = iodelay during scan
      -- cnt_cycle = length of one scan during scan
      --             to loop over scan result when stable
      if sta_iddr = 0 then
        cnt_iddr  <= (others => '0');
        cnt_cycle <= (others => '0');
      elsif sta_iddr = 1 or sta_iddr = 2 then
        if (not cnt_cycle) = 0 then
          cnt_iddr <= cnt_iddr + 1;
        elsif cnt_iddr = FMAX then
          cnt_iddr <= (others => '0');
        end if;
        cnt_cycle <= cnt_cycle + 1;
      elsif sta_iddr = 3 then
        if cnt_cycle = FMAX - 1 then
          cnt_cycle <= (others => '0');
        else
          cnt_cycle <= cnt_cycle + 1;
        end if;
      end if;

      -- sta_ioctet = scan pattern of staoctet
      -- sta_icrc8  = scan pattern of stacrc8ok
      if sta_iddr = 0 then
        sta_ioctet <= (others => '0');
        sta_icrc8  <= (others => '0');
      elsif sta_iddr = 1 then
        if cnt_cycle(cnt_cycle'left) = '0' then
          sta_ioctet(0) <= '1';
          sta_icrc8(0)  <= '1';
        elsif (not cnt_cycle) /= 0 then
          sta_ioctet(0) <= sta_ioctet(0) and staoctet;
          sta_icrc8(0)  <= sta_icrc8(0)  and stacrc8ok;
        else
          sta_ioctet <= sta_ioctet(0) & sta_ioctet(sta_ioctet'left downto 1);
          sta_icrc8  <= sta_icrc8(0)  & sta_icrc8(sta_icrc8'left   downto 1);
        end if;
      elsif sta_iddr = 3 then
        sta_ioctet <= sta_ioctet(0) & sta_ioctet(sta_ioctet'left downto 1);
        sta_icrc8  <= sta_icrc8(0)  & sta_icrc8(sta_icrc8'left   downto 1);
      end if;

      -- from delaysearch.c
      --   sta_spos   = temporary starting position of stable range
      --   sta_smax   = best start position of stable range
      --   sta_ezero  = range from the first edge (to wrap around)
      --   sta_lenmax = length of longest range
      if sta_iddr = 0 then
        sta_spos   <= (others => '1');
        sta_smax   <= (others => '0');
        sta_ezero  <= (others => '0');
        sta_lenmax <= (others => '0');
      elsif sta_iddr = 1 and (not cnt_cycle) = 0 then
        if sta_iok = '1' and cnt_iddr = sta_ezero then
          sta_ezero <= sta_ezero + 1;
        end if;
          
        if sta_iok = '1' and (not sta_spos) = 0 then
          sta_spos <= cnt_iddr;
        elsif sta_iok = '0' and (not sta_spos) /= 0 then
          if cnt_iddr - sta_spos > sta_lenmax then
            sta_lenmax <= cnt_iddr - sta_spos;
            sta_smax   <= sta_spos;
          end if;
          sta_spos   <= (others => '1');
        end if;
      elsif sta_iddr = 1 and cnt_iddr = FMAX and cnt_cycle = 0 then
        if sta_ezero = FMAX - 1 then
          sta_lenmax <= cnt_iddr + 1;
          sta_smax   <= (others => '0');
        elsif (not sta_spos) /= 0 and
          sta_lenmax < sta_ezero + FMAX - sta_spos then
          sta_lenmax <= sta_ezero + FMAX - sta_spos;
          sta_smax   <= sta_spos;
        end if;
      end if;

      -- sta_ibest = best delay
      if sta_smax + sta_lenhalf >= FMAX then
        sta_ibest <= sta_smax + sta_lenhalf - FMAX;
      else
        sta_ibest <= sta_smax + sta_lenhalf;
      end if;
          
      --  seq_inc
      if (sta_iddr = 1 or sta_iddr = 2) and (not cnt_cycle) = 0 then
        seq_inc <= "01";
      elsif sta_iddr /= 3 then
        seq_inc <= "00";
      else
        seq_inc <= seq_inc(0) & incdelay;
      end if;

      -- sig_inc, sig_islip
      if seq_inc = "01" then
        if cnt_delay = WRAPCOUNT-1 then
          sig_islip <= '1';
        else
          sig_inc   <= '1';
        end if;
      else
        sig_islip   <= '0';
        sig_inc     <= '0';
      end if;

      -- cnt_islip
      if clrdelay = '1' or sta_iddr = 0 then
        cnt_islip <= (others => '0');
      elsif seq_inc = "01" and cnt_delay = WRAPCOUNT-1 then
        cnt_islip <= cnt_islip + 1;
      end if;

      -- clr_islip
      if sta_iddr = 0 then
        clr_islip <= '1';
      else
        clr_islip <= clrdelay;
      end if;

      -- clr_inc
      if sta_iddr = 0 then
        clr_inc  <= '1';
      elsif seq_inc = "01" and cnt_delay = WRAPCOUNT-1 then
        clr_inc  <= '1';
      else
        clr_inc  <= '0';
      end if;

      -- cnt_delay
      if clr_inc = '1' then
        cnt_delay <= (others => '0');
      elsif sig_inc = '1' then
        cnt_delay <= cnt_delay + 1;
      end if;

      -- for debug
      seq_iddr <= sta_iddr;
      if seq_iddr /= sta_iddr then
        cnt_dbg <= (others => '0');
      else
        cnt_dbg <= cnt_dbg + 1;
      end if;
      
      if cnt_dbg(cnt_dbg'left downto 3) = 0 then
        iddrdbg(9 downto 3) <=
          sta_ibest(sta_ibest'left-1 downto sta_ibest'left-7);
      elsif cnt_dbg(cnt_dbg'left downto 3) = 1 then
        iddrdbg(9 downto 3)
          <= sta_smax(sta_smax'left-1 downto sta_smax'left-7);
      elsif cnt_dbg(cnt_dbg'left downto 3) = 2 then
        iddrdbg(9 downto 3)
          <= sta_ezero(sta_ezero'left-1 downto sta_ezero'left-7);
      elsif cnt_dbg(cnt_dbg'left downto 3) = 3 then
        iddrdbg(9 downto 3)
          <= sta_lenmax(sta_lenmax'left-1 downto sta_lenmax'left-7);
      elsif cnt_dbg(cnt_dbg'left downto 3) = 4 then
        iddrdbg(9 downto 3)
          <= sta_spos(sta_spos'left-1 downto sta_spos'left-7);
      else
        iddrdbg(9 downto 3) <= cnt_cycle(6 downto 0);
      end if;
      
    end if; -- event
  end process;
  
  -- out
  cntdelay <= cnt_islip & cnt_delay(cnt_delay'left downto cnt_delay'left-5);
  cntwidth <= sta_lenmax(sta_lenmax'left-2 downto sta_lenmax'left-7)
              when sta_lenmax(sta_lenmax'left-1) = '0' else
              (others => '1');
  
  staiddr  <= sta_iddr;
  
  iddrdbg(0) <= '1' when sta_iddr = 3 and cnt_cycle = 0 else '0';
  iddrdbg(1) <= sta_ioctet(0);
  iddrdbg(2) <= sta_icrc8(0);

  siginc   <= sig_inc;
  sigislip <= sig_islip;
  clrinc   <= clr_inc;
  clrislip <= clr_islip;
  
end implementation;

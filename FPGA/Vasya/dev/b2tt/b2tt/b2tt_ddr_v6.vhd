------------------------------------------------------------------------
--
--  b2tt_ddr_v6.vhd -- TT-link DDR and delay hander for Belle2link
--                     frontend for Virtex-6
--
--  Mikihiko Nakao, KEK IPNS
--
--  20131002 separated from b2tt_decode.vhd and b2tt_encode.vhd
--  20131013 Spartan-6 support
--  20131028 slip fix, no auto wrap, separate Virtex-6 support
--  20131101 no more std_logic_arith
--  20140614 dbg added for chipscope
--  20140709 new scheme to find the stable delay
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- - b2tt_iddr
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.ALL;

entity b2tt_iddr is
  generic (
    FLIPIN    : std_logic := '0';
    REFFREQ   : real      := 203.546;
    SLIPBIT   : integer   := 1;     -- 0 for v5/s6, 1 for v6
    WRAPCOUNT : integer   := 25;    -- 51 for v5, 25 for v6, 170 for s6
    FULLCOUNT : integer   := 100;   -- WC*4 for v6, WC*2 for v5/s6
    SIM_SPEEDUP : std_logic := '0' ); -- to speedup simulation
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
    clock     : in  std_logic;
    invclock  : in  std_logic; -- spartan6 only
    dblclock  : in  std_logic;
    dblclockb : in  std_logic;
    inp       : in  std_logic;
    inn       : in  std_logic;
    staoctet  : in  std_logic;
    stacrc8ok : in  std_logic;
    manual    : in  std_logic;
    incdelay  : in  std_logic;
    clrdelay  : in  std_logic;
    caldelay  : in  std_logic; -- spartan6 only (or for v6 iserdes bitflip)
    staiddr   : out std_logic_vector (1  downto 0);
    bit2      : out std_logic_vector (1  downto 0);
    cntdelay  : out std_logic_vector (6  downto 0);
    cntwidth  : out std_logic_vector (5  downto 0);
    iddrdbg   : out std_logic_vector (9  downto 0) );

end b2tt_iddr;
------------------------------------------------------------------------
architecture implementation of b2tt_iddr is
  signal sig_i       : std_logic := '0';
  signal sig_q       : std_logic := '0';
  signal sig_inc     : std_logic := '0';
  signal clr_inc     : std_logic := '0';
  signal sig_islip   : std_logic := '0';
  signal clr_islip   : std_logic := '0';
  signal sig_raw4    : std_logic_vector (3  downto 0) := "0000";
  signal open_bitddr : std_logic := '0';
begin
  mpa_ibufds: ibufds
    port map ( o => sig_i, i => inp, ib => inn );

  map_idelay: iodelay
    generic map (
      REFCLK_FREQUENCY => REFFREQ,
      HIGH_PERFORMANCE_MODE => FALSE,
      IDELAY_TYPE => "VARIABLE",
      ODELAY_VALUE => 0,
      DELAY_SRC   => "I" )
    port map (
      idatain => sig_i,
      odatain => '0',
      datain  => '0',
      dataout => sig_q,
      ce  => sig_inc,
      rst => clr_inc,
      t   => '0',
      inc => '1',
      c   => clock );
  
  map_id: iserdese1
    generic map (
      -- BITSLIP_ENABLE => TRUE, -- not in v6
      DATA_RATE         => "DDR",
      DATA_WIDTH        => 4,
      DYN_CLKDIV_INV_EN => FALSE,
      DYN_CLK_INV_EN    => FALSE,
      INTERFACE_TYPE    => "NETWORKING",
      IOBDELAY          => "BOTH", -- BOTH to use O, IFD if not
      NUM_CE            => 1, -- not so clear 1 or 2
      OFB_USED          => FALSE,
      SERDES_MODE       => "MASTER" )
    port map (
      q1   => sig_raw4(0),
      q2   => sig_raw4(1),
      q3   => sig_raw4(2),
      q4   => sig_raw4(3),
      d    => '0',
      o    => open_bitddr,
      ddly => sig_q,
      ce1  => '1',
      ce2  => '1',
      clk  => dblclock,
      clkb => dblclockb,
      rst  => clr_islip,
      clkdiv => clock,
      oclk    => '0',
      bitslip => sig_islip,
      dynclkdivsel => '0',
      dynclksel => '0',
      ofb => '0',
      shiftin1 => '0',
      shiftin2 => '0' );

  bit2(0) <= sig_raw4(0) xor FLIPIN;
  bit2(1) <= sig_raw4(2) xor FLIPIN;

  map_iscan: entity work.b2tt_iscan
    generic map (
      FLIPIN => FLIPIN,
      REFFREQ => REFFREQ,
      SLIPBIT => SLIPBIT,
      WRAPCOUNT => WRAPCOUNT,
      FULLCOUNT => FULLCOUNT,
      SIM_SPEEDUP => SIM_SPEEDUP )
    port map (
      -- from/to b2tt_decode
      clock     => clock,
      staoctet  => staoctet,
      stacrc8ok => stacrc8ok,
      manual    => manual,
      incdelay  => incdelay,
      clrdelay  => clrdelay,
      staiddr   => staiddr,     -- out
      cntdelay  => cntdelay,    -- out
      cntwidth  => cntwidth,    -- out
      iddrdbg   => iddrdbg,     -- out
      -- from/to b2tt_iddr
      siginc    => sig_inc,     -- out
      sigislip  => sig_islip,   -- out
      clrinc    => clr_inc,     -- out
      clrislip  => clr_islip) ; --  out
  
end implementation;

------------------------------------------------------------------------
-- - b2tt_oddr
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.ALL;

entity b2tt_oddr is
  generic (
    FLIPOUT  : std_logic := '0';
    REFFREQ  : real      := 203.546 );
  port (
    clock    : in  std_logic;
    invclock : in  std_logic; -- only for s6
    mask     : in  std_logic;
    bit2     : in  std_logic_vector (1 downto 0);
    outp     : out std_logic;
    outn     : out std_logic );

end b2tt_oddr;
------------------------------------------------------------------------
architecture implementation of b2tt_oddr is
  signal sig_o    : std_logic := '0';
  signal sig_oq   : std_logic := '0';
  signal sig_bit2 : std_logic_vector (1 downto 0) := "00";
begin
  -- in
  sig_bit2(0) <= bit2(0) xor FLIPOUT;
  sig_bit2(1) <= bit2(1) xor FLIPOUT;
  
  map_obufdst: obuftds
    port map ( i => sig_o, o => outp, ob => outn, t => mask );

  map_odelay: iodelay
    generic map (
      REFCLK_FREQUENCY => 203.546,
      HIGH_PERFORMANCE_MODE => FALSE,
      IDELAY_TYPE => "FIXED",
      DELAY_SRC   => "O" )
    port map (
      odatain => sig_oq,
      idatain => '0',
      datain  => '0',
      dataout => sig_o,
      ce  => '0',
      rst => '0',
      t   => '0',
      inc => '1',
      c   => '0' );

  map_od: oddr
    generic map (
      DDR_CLK_EDGE => "SAME_EDGE"
      )
    port map (
      s => '0',
      d1 => sig_bit2(1), -- order: d1 first, d2 second
      d2 => sig_bit2(0), -- (10b: left-most-bit first, right-most last)
      ce => '1',
      c  => clock,
      r  => '0',
      q  => sig_oq );

end implementation;


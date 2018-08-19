------------------------------------------------------------------------
--
--  b2tt_ddr_s6.vhd -- TT-link DDR and delay hander for Belle2link
--                     frontend for Spartan-6
--
--  Mikihiko Nakao, KEK IPNS
--
--  20131002 separated from b2tt_decode.vhd and b2tt_encode.vhd
--  20131013 Spartan-6 support
--  20131101 no more std_logic_arith
--  20131113 merging changes to ddr_v5 into ddr_s6
--  20131119 bitddr output from dataout2, sig_inc was forgotten
--  20131120 cal to be asserted with data - once in 1024 times of sig_inc
--  20140614 dbg added for chipscope
--  20140711 new scheme to find the stable delay
--  20150722 "not clock" instead of 180 deg shifted invclock
--    (somehow ise14 could not build sp605_b2l006)
--
--  tap calibration based on SP605 (sp605_b2tt09.bit)
--    2.32 ns per 100 inc => about 170 inc to cover (7.86ns/2)
--
--   VARIABLE_FROM_HALF_MAX resets to somewhere not zero
--   DIFF_PHASE_DETECTOR does not increment
--   VARIABLE_FROM_ZERO resets to zero at 163 inc (maybe internally measured)
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
    SLIPBIT   : integer   := 0;     -- 0 for v5/s6, 1 for v6
    WRAPCOUNT : integer   := 170;   -- 51 for v5, 25 for v6, 170 for s6
    FULLCOUNT : integer   := 340;   -- *2 for v5/s6, *4 for v6
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
    dblclock  : in  std_logic; -- virtex6 only
    dblclockb : in  std_logic; -- virtex6 only
    inp       : in  std_logic;
    inn       : in  std_logic;
    staoctet  : in  std_logic;
    stacrc8ok : in  std_logic;
    manual    : in  std_logic;
    incdelay  : in  std_logic;
    clrdelay  : in  std_logic;
    caldelay  : in  std_logic; -- spartan6 only
    staiddr   : out std_logic_vector (1  downto 0);
    bitddr    : out std_logic;
    bit2      : out std_logic_vector (1  downto 0);
    cntdelay  : out std_logic_vector (6  downto 0);
    cntwidth  : out std_logic_vector (5  downto 0);
    iddrdbg   : out std_logic_vector (9  downto 0) );

end b2tt_iddr;
------------------------------------------------------------------------
architecture implementation of b2tt_iddr is
  signal sig_i      : std_logic := '0';
  signal sig_q      : std_logic := '0';
  signal sig_inc     : std_logic := '0';
  signal clr_inc     : std_logic := '0';
  signal sig_islip   : std_logic := '0';
  signal clr_islip   : std_logic := '0';

  signal sig_bit2   : std_logic_vector (1 downto 0) := "00";
  signal sig_raw2   : std_logic_vector (1 downto 0) := "00";
  signal sta_slip   : std_logic := '0';
  signal buf_bit    : std_logic := '0';

  -- spartan6 only
  signal open_do    : std_logic := '0';
  signal open_to    : std_logic := '0';
  signal sig_busy   : std_logic := '0';
  signal sig_caldelay : std_logic := '0';
  signal seq_caldelay : std_logic_vector (1 downto 0) := "01";
  signal sig_invclock : std_logic := '0';
begin
  -- in
  sig_invclock <= not clock;
  
  map_ibufds: ibufds
    port map ( o => sig_i, i => inp, ib => inn );

  map_idelay: iodelay2
    generic map (
      IDELAY_VALUE       => 0,
      IDELAY2_VALUE      => 0,
      IDELAY_MODE        => "NORMAL",
      IDELAY_TYPE        => "VARIABLE_FROM_ZERO",
      DATA_RATE          => "DDR",
      COUNTER_WRAPAROUND => "WRAPAROUND",
      DELAY_SRC          => "IDATAIN" )
    port map (
      idatain  => sig_i,
      odatain  => '0',
      dataout  => sig_q,
      ioclk0   => clock,
      ioclk1   => sig_invclock,
      clk      => clock,
      ce       => sig_inc,
      rst      => clr_inc,
      inc      => '1',
      t        => '1',       -- 1 for input only / 0 for output only
      cal      => sig_caldelay,  -- no auto-caldelay
      dataout2 => bitddr,
      busy     => sig_busy,
      dout     => open_do,
      tout     => open_to );

  map_id: iddr2
    generic map (
      DDR_ALIGNMENT => "C0" )
    port map (
      s  => '0',
      d  => sig_q,
      ce => '1',
      c0 => clock,
      c1 => sig_invclock,
      r  => '0',
      q0 => sig_raw2(0),
      q1 => sig_raw2(1) );

  sig_bit2(0) <= sig_raw2(0) xor FLIPIN;
  sig_bit2(1) <= sig_raw2(1) xor FLIPIN;

  process(clock)
  begin
    if rising_edge(clock) then
      -- slipped bit is generated upon clock,
      -- as asynchronous bit2 was timing-tight
      if sta_slip = '0' then
        bit2 <= sig_bit2;
      else
        bit2 <= buf_bit & sig_bit2(1);
      end if;
      buf_bit <= sig_bit2(0);

      -- sta_slip
      if clr_islip = '1' then
        sta_slip <= '0';
      elsif sig_islip = '1' then
        sta_slip <= not sta_slip;
      end if;

      -- sig_caldelay
      sig_caldelay <= caldelay or seq_caldelay(1);
      seq_caldelay <= seq_caldelay(0) & '0';
      
    end if; -- clock
  end process;
  
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
      clrislip  => clr_islip) ; -- out
  
end implementation;

------------------------------------------------------------------------
-- b2tt_oddr
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.ALL;

entity b2tt_oddr is
  generic (
    FLIPOUT : std_logic := '0';
    REFFREQ : real      := 203.546 );
  port (
    clock    : in  std_logic;
    invclock : in  std_logic;
    mask     : in  std_logic;
    bit2     : in  std_logic_vector (1 downto 0);
    bitddr   : out std_logic;
    outp     : out std_logic;
    outn     : out std_logic
  );
end b2tt_oddr;
------------------------------------------------------------------------
architecture implementation of b2tt_oddr is
  signal sig_o    : std_logic := '0';
  signal sig_oq   : std_logic := '0';
  signal sig_bit2 : std_logic_vector (1 downto 0) := "00";
  signal sig_invclock : std_logic := '0';
begin
  -- in
  sig_invclock <= not clock;
  sig_bit2(0) <= bit2(0) xor FLIPOUT;
  sig_bit2(1) <= bit2(1) xor FLIPOUT;
  
  map_obufds: obuftds
    port map ( i => sig_o, o => outp, ob => outn, t => mask );

  map_odelay: iodelay2
    generic map (
      ODELAY_VALUE       => 0,
      DELAY_SRC          => "ODATAIN" )
    port map (
      idatain => '0',
      t       => '0',
      odatain => sig_oq,
      cal    => '0',
      ioclk0 => '0',
      ioclk1 => '0',
      clk => '0',
      inc => '1',
      ce  => '0',
      rst => '0',
      dataout2 => bitddr,
      dout => sig_o );

  map_od: oddr2
    generic map (
      DDR_ALIGNMENT => "C0",
      SRTYPE        => "ASYNC" )
    port map (
      s => '0',
      d0 => sig_bit2(1), -- order: d1 first, d2 second
      d1 => sig_bit2(0), -- (10b: left-most-bit first, right-most last)
      ce => '1',
      c0 => clock,
      c1 => sig_invclock,
      r  => '0',
      q  => sig_oq );

  -- out
  --bitddr <= sig_o;
  --bitddr <= '0';
  
end implementation;

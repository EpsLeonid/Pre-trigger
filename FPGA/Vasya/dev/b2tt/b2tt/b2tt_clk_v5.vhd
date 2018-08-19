------------------------------------------------------------------------
--
-- b2tt_clk_v5.vhd --- clock for Virtex 5
--
-- Mikihiko Nakao, KEK IPNS
--
-- 20120409 0.01  new
-- 20130411 0.02  renamed from mnictrl
-- 20130718 0.03  packed into b2tt_clk
-- 20131011 0.04  renamed to b2tt_clk_v5 for virtex5
-- 20131012 0.05  unification with v6 as much as possible
-- 20131013 0.06  unification with s6 as much as possible
-- 20131101 0.07  no more std_logic_arith
-- 20141008 0.08  rawclkg
-- 20150105 0.09  rawclk after bufg (no more rawclkg) / no more FLIPCLK
-- 20150630 0.10  dummy USE254IN generic
------------------------------------------------------------------------

------------------------------------------------------------------------
-- b2tt_clk
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity b2tt_clk is
  generic (
    USEPLL   : std_logic := '0'; -- PLL is unused in v5 by default
    USEICTRL : std_logic := '1';
    USE254IN : std_logic := '0' ); -- dummy for v5 (only used by v6/DHH)
  port (
    clkp     : in  std_logic;
    clkn     : in  std_logic;
    reset    : in  std_logic;
    rawclk   : out std_logic;
    clock    : out std_logic;
    invclock : out std_logic;  -- (only for Spartan-6)
    dblclock : out std_logic;  -- (only for Virtex-6)
    dblclockb : out std_logic; -- (only for Virtex-6)
    locked   : out std_logic;
    stat     : out std_logic_vector (1 downto 0) );
end b2tt_clk;

architecture implementation of b2tt_clk is
  signal clk_127      : std_logic := '0';
  signal sig_127      : std_logic := '0';

  signal sig_fbout    : std_logic := '0';
  signal sig_xcm203   : std_logic := '0';
  signal clk_fb       : std_logic := '0';
  signal clk_203      : std_logic := '0';

  signal sta_xcm      : std_logic := '0';
  signal clr_xcm      : std_logic := '0';
  signal sta_ictrl    : std_logic := '0';
  signal clr_ictrl    : std_logic := '0';
  signal cnt_xcmreset : std_logic_vector (3  downto 0) := (others => '0');
  signal cnt_xcmlock  : std_logic_vector (13 downto 0) := (others => '0');
  signal cnt_ictrl    : std_logic_vector (9  downto 0) := (others => '0');

  signal sig_xcm127   : std_logic := '0';
  --signal sig_xcm254   : std_logic := '0';

  signal sta_dcm      : std_logic := '0';
  signal sta_pll      : std_logic := '0';
  signal sig_fbpll    : std_logic := '0';
  signal clk_fbpll    : std_logic := '0';
begin
  ------------------------------------------------------------------------
  -- clock buffers
  ------------------------------------------------------------------------
  rawclk  <= clk_127;
  map_ick: ibufds port map ( o => sig_127,    i => clkp, ib => clkn );
  map_ig:   bufg  port map ( i => sig_127,    o => clk_127 );

  map_fb:   bufg  port map ( i => sig_fbout,  o => clk_fb  );
  map_203g: bufg  port map ( i => sig_xcm203, o => clk_203 );
  
  ------------------------------------------------------------------------
  -- PLL
  ------------------------------------------------------------------------
  invclock  <= '0';
  dblclock  <= '0';
  dblclockb <= '0';
  
  gen_pll0: if USEPLL = '0' generate
    clock   <= clk_127;
    sta_xcm <= sta_dcm;
  end generate;
  gen_pll1: if USEPLL = '1' generate
    sta_xcm <= sta_dcm and sta_pll;
    map_127g: bufg  port map ( i => sig_xcm127, o => clock );
    --map_254g: bufg  port map ( i => sig_xcm254, o => clk254 );
  
    map_fbpll:   bufg  port map ( i => sig_fbpll,  o => clk_fbpll );
    map_pll: pll_base
      generic map (
        CLKIN_PERIOD   => 7.8,  -- F_VCO has to be between 400 - 1000 MHz
        CLKFBOUT_MULT  => 4,    -- F_VCO = F_CLKIN * CLKFBOUT_MULT
        DIVCLK_DIVIDE  => 1,    --         / DIVCLK_DIVIDE
        CLKOUT0_DIVIDE => 4,    -- F_OUT = F_VCO / CLKOUTn_DIVIDE
        --CLKOUT1_DIVIDE => 2,
        BANDWIDTH => "OPTIMIZED" )
      port map (
        clkin    => clk_127,
        rst      => clr_xcm,
        clkfbout => sig_fbpll,
        clkout0  => sig_xcm127,
        --clkout1  => sig_xcm254,
        locked   => sta_pll,
        clkfbin  => clk_fbpll );
  end generate;

  ------------------------------------------------------------------------
  -- DCM
  ------------------------------------------------------------------------
  map_xcm: dcm_base
    generic map (
      CLKFX_MULTIPLY => 8,
      CLKFX_DIVIDE   => 5,
      DFS_FREQUENCY_MODE => "HIGH",
      DLL_FREQUENCY_MODE => "HIGH",
      DCM_PERFORMANCE_MODE => "MAX_SPEED" )
    port map (
      rst    => clr_xcm,
      locked => sta_dcm,
      clkin  => clk_127,
      clk0   => sig_fbout,
      clkfx  => sig_xcm203,
      clkfb  => clk_fb );

  ------------------------------------------------------------------------
  -- idelayctrl (refclk: 200+-10 MHz)
  ------------------------------------------------------------------------
  gen1: if USEICTRL = '1' generate
    map_ic: idelayctrl
      port map ( refclk => clk_203, rst => clr_ictrl, rdy => sta_ictrl );
  end generate;
  gen0: if USEICTRL = '0' generate
    sta_ictrl <= '1';
  end generate;

  ------------------------------------------------------------------------
  -- reset
  --  idelayctrl initial reset (>3us or >385clk)
  --  XCM at least 3 clkin to reset, several thousand clocks to lock
  ------------------------------------------------------------------------
  proc_reset: process (clk_127)
  begin
    if clk_127'event and clk_127 = '1' then
      -- XCM reset
      if cnt_xcmreset(3) = '0' then
        clr_xcm      <= '1';
        cnt_xcmreset <= cnt_xcmreset + 1;
        cnt_xcmlock  <= (others => '0');
      elsif cnt_xcmlock(13) = '0' then
        clr_xcm      <= '0';
        cnt_xcmlock  <= cnt_xcmlock + 1;
      elsif reset = '1' or sta_xcm = '0' then
        cnt_xcmreset <= (others => '0');
      end if;

      -- IDELAYCTRL reset
      if clr_xcm = '1' or sta_xcm = '0' then
        cnt_ictrl <= (others => '0');
      elsif cnt_ictrl(9) = '0' then
        clr_ictrl <= '1';
        cnt_ictrl <= cnt_ictrl + 1;
      else
        clr_ictrl <= '0';
      end if;
    end if;
  end process;

  -- out
  stat   <= sta_ictrl &   sta_xcm;
  locked <= sta_ictrl and sta_xcm;

end implementation;

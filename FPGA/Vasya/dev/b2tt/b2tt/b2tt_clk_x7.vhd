------------------------------------------------------------------------
--
-- b2tt_clk_k7.vhd --- clock for Kintex 7
--
-- Mikihiko Nakao, KEK IPNS
--
-- 20131001 0.04  from 20130830 virtex 5 version
-- 20131012 0.05  unification with v5 as much as possible
-- 20131013 0.06  unification with s6 as much as possible
-- 20131101 0.07  no more std_logic_arith
-- 20140715 0.26  USEPLL is no more used
-- 20140925       forked by Kurtis from b2tt_clk_v6.vhd, updated for k7
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
    USEPLL   : std_logic := '1'; -- unused (MMCM is anyway needed)
    USEICTRL : std_logic := '1';
    USE254IN : std_logic := '0' ); -- only for v6 / DHH
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
  signal clk_in       : std_logic := '0';
  signal sig_clkin    : std_logic := '0';

  signal sig_fbout    : std_logic := '0';
  signal sig_xcmictrl : std_logic := '0';
  signal clk_fb       : std_logic := '0';
  signal clk_ictrl    : std_logic := '0';

  signal sta_xcm      : std_logic := '0';
  signal clr_xcm      : std_logic := '0';
  signal sta_ictrl    : std_logic := '0';
  signal clr_ictrl    : std_logic := '0';
  signal cnt_xcmreset : std_logic_vector (3  downto 0) := (others => '0');
  signal cnt_xcmlock  : std_logic_vector (13 downto 0) := (others => '0');
  signal cnt_ictrl    : std_logic_vector (9  downto 0) := (others => '0');

  signal sig_xcm127   : std_logic := '0';
  signal sig_xcm254   : std_logic := '0';
  signal sig_xcm254b  : std_logic := '0';

  signal open_clk3    : std_logic := '0';
  signal open_clk4    : std_logic := '0';
begin
  ------------------------------------------------------------------------
  -- clock buffers
  ------------------------------------------------------------------------
  rawclk <= clk_in;
  map_ick: ibufds port map ( o => sig_clkin,  i => clkp, ib => clkn );
  map_ig:   bufg  port map ( i => sig_clkin,  o => clk_in );

  map_fb:   bufg  port map ( i => sig_fbout,    o => clk_fb  );
  map_ictg: bufg  port map ( i => sig_xcmictrl, o => clk_ictrl );

  invclock <= '0';
  
  map_127g: bufg  port map ( i => sig_xcm127, o => clock );
  map_254g: bufg  port map ( i => sig_xcm254, o => dblclock );
  map_254b: bufg  port map ( i => sig_xcm254b, o => dblclockb );
  
  ------------------------------------------------------------------------
  -- MMCM
  ------------------------------------------------------------------------
  map_xcm: mmcme2_base
    generic map (
      CLKIN1_PERIOD    => 7.8, -- F_VCO has to be between 600 - 1440 MHz
      CLKFBOUT_MULT_F  => 8.0, -- F_VCO = F_CLKIN * CLKFBOUT_MULT_F
      DIVCLK_DIVIDE    => 1,   --         / DIVCLK_DIVIDE (= 1017 MHz)
      CLKOUT0_DIVIDE_F => 8.0, -- 127.2MHz (only this one is real)
      CLKOUT1_DIVIDE   => 4,   -- 254.4MHz (others are integers)
      CLKOUT2_DIVIDE   => 5,   -- 203.5MHz
      CLKOUT3_DIVIDE   => 4,   -- 254.4MHz
      CLKOUT3_PHASE    => 180.0,
      BANDWIDTH => "LOW" )
    port map (
      clkin1   => clk_in,
      rst      => clr_xcm,
      clkfbout => sig_fbout,
      clkout0  => sig_xcm127,
      clkout1  => sig_xcm254,
      clkout2  => sig_xcmictrl,
      clkout3  => sig_xcm254b,
      clkout4  => open_clk4,
      locked   => sta_xcm,
      pwrdwn   => '0',
      clkfbin  => clk_fb );

  ------------------------------------------------------------------------
  -- idelayctrl (refclk: 200+-10 MHz)
  ------------------------------------------------------------------------
  gen_ictrl1: if USEICTRL = '1' generate
    map_ic: idelayctrl
      port map ( refclk => clk_ictrl, rst => clr_ictrl, rdy => sta_ictrl );
  end generate;
  gen_ictrl0: if USEICTRL = '0' generate
    sta_ictrl <= '1';
  end generate;

  ------------------------------------------------------------------------
  -- reset
  --  idelayctrl initial reset (>3us or >385clk)
  --  XCM at least 3 clkin to reset, several thousand clocks to lock
  --  (periods are taken from V5 DCM, not sure OK for V6 MMCM)
  ------------------------------------------------------------------------
  proc_reset: process (clk_in)
  begin
    if clk_in'event and clk_in = '1' then
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

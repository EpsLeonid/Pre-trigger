------------------------------------------------------------------------
--
-- b2tt_clk_v6.vhd --- clock for Virtex 6
--
-- Mikihiko Nakao, KEK IPNS
--
-- 20131001 0.04  from 20130830 virtex 5 version
-- 20131012 0.05  unification with v5 as much as possible
-- 20131013 0.06  unification with s6 as much as possible
-- 20131101 0.07  no more std_logic_arith
-- 20140715 0.26  USEPLL is no more used
-- 20141008 0.08  rawclkg
-- 20150105 0.09  rawclk after bufg (no more rawclkg) / no more FLIPCLK
-- 20150630 0.10  254 MHz input option for DHH
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
  signal cnt_xcmreset : std_logic_vector (4  downto 0) := (others => '0');
  signal cnt_xcmlock  : std_logic_vector (14 downto 0) := (others => '0');
  signal cnt_ictrl    : std_logic_vector (10 downto 0) := (others => '0');

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
  gen_254in: if USE254IN = '1' generate
    map_xcm: mmcm_base
      generic map (
        CLKIN1_PERIOD    => 3.9, -- F_VCO has to be between 600 - 1440 MHz
        CLKFBOUT_MULT_F  => 5.0, -- F_VCO = F_CLKIN * CLKFBOUT_MULT_F
        DIVCLK_DIVIDE    => 1,   --         / DIVCLK_DIVIDE (= 1017 MHz)
        CLKOUT0_DIVIDE_F => 10.0, -- 127.2MHz (only this one is real)
        CLKOUT1_DIVIDE   => 5,   -- 254.4MHz (others are integers)
        CLKOUT2_DIVIDE   => 6,   -- 212.0MHz (a bit high for idelayctrl)
        CLKOUT3_DIVIDE   => 5,   -- 254.4MHz
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
  end generate;
  gen_127in: if USE254IN = '0' generate
    map_xcm: mmcm_base
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
  end generate;
  
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
  --
  --  XCM at least 3 clkin to reset, several thousand clocks to lock
  --  (periods are taken from V5 DCM, not sure OK for V6 MMCM)
  --
  --  should work for both 254MHz clock and 127MHz clock
  ------------------------------------------------------------------------
  proc_reset: process (clk_in)
    variable BIT1OR2 : std_logic_vector (1 downto 0);
    variable ADD1OR2 : integer;
  begin

    -- a bit tricky way to change the counter increment
    -- (probably there should be a better way which I don't know yet)
    --
    BIT1OR2 := (not USE254IN) & USE254IN;
    ADD1OR2 := to_integer(unsigned(BIT1OR2));
               
    if clk_in'event and clk_in = '1' then
      -- XCM reset
      if cnt_xcmreset(cnt_xcmreset'left) = '0' then
        clr_xcm      <= '1';
        cnt_xcmreset <= cnt_xcmreset + ADD1OR2;
        cnt_xcmlock  <= (others => '0');
      elsif cnt_xcmlock(cnt_xcmlock'left) = '0' then
        clr_xcm      <= '0';
        cnt_xcmlock  <= cnt_xcmlock + ADD1OR2;
      elsif reset = '1' or sta_xcm = '0' then
        cnt_xcmreset <= (others => '0');
      end if;

      -- IDELAYCTRL reset
      if clr_xcm = '1' or sta_xcm = '0' then
        cnt_ictrl <= (others => '0');
      elsif cnt_ictrl(cnt_ictrl'left) = '0' then
        clr_ictrl <= '1';
        cnt_ictrl <= cnt_ictrl + ADD1OR2;
      else
        clr_ictrl <= '0';
      end if;
    end if;
  end process;

  -- out
  stat   <= sta_ictrl &   sta_xcm;
  locked <= sta_ictrl and sta_xcm;

end implementation;

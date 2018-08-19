------------------------------------------------------------------------
--
--- hslb_b2tt.vhd --- HSLB Virtex5 for fun
--- 
--  Mikihiko Nakao, KEK IPNS
--  20131013 0.01  first version
--  20131028 0.02  updated b2tt (ddr)
--  20131108 0.03  final(?) header format with 3 words from b2tt
--  20131118 0.04  updated b2tt (no open in b2tt)
--  20131121 0.05  including fixes for sp605_b2tt11
--  20131127 0.06  tagerr fix and duplicated header fix
--  20131213 0.07  b2tt 0.12 (entagerr flag)
--  20140715 0.08  b2tt 0.26
--  20140722 0.09  b2tt 0.27
--  20140808 0.10  b2tt 0.29
--  20140917 0.11  b2tt 0.31
--  20150105 0.12  b2tt 0.33
--  20160318 0.13  b2tt 0.45
--  20160407 0.14  b2tt 0.46
--  20170725 0.15  b2tt 0.52
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;
library work;
use work.mytypes.all;

entity hslb_b2tt is
  generic (
    VERSION : integer := 15;
    ID : std_logic_vector (31 downto 0) := x"42325448"; -- "B2TH"
    USE_CHIPSCOPE : std_logic := '1' );
  port (
    f_ld     : inout std_logic_vector (7 downto 0);  -- localbus data
    f_la     : in    std_logic_vector (6 downto 0);  -- localbus address
    c_lwr    : in    std_logic;                      -- 0: read, 1: write
    c_csb    : in    std_logic;                      -- 0: chip selected
    --f_ff     : out   std_logic_vector (31 downto 0); -- fifo data
    --f_frstb  : out   std_logic;                      -- fifo reset
    --f_fwenb  : out   std_logic;                      -- fifo write enable
    --f_fwclk  : out   std_logic;                      -- fifo write clock
    f_nwff   : in    std_logic;                      -- no.-word fifo full
    f_fwful  : in    std_logic;                      -- data fifo full
    f_tag    : in    std_logic_vector (7 downto 0);  -- trig tag from TT-RX
    f_typ    : in    std_logic_vector (3 downto 0);  -- trig type from TT-RX
    f_abrt   : in    std_logic;                      -- abort from TT-RX
    f_iena   : in    std_logic;                      -- enable from TT-RX
    f_irstb  : in    std_logic;                      -- reset from TT-RX
    f_io     : in    std_logic;                      -- reset from TT-RX
    f_gate   : in    std_logic;                      -- reset from TT-RX
    f_bsy    : out   std_logic;                      -- busy to TT-RX
    f_trg_p  : in    std_logic;
    f_trg_n  : in    std_logic;
    f_rev_p  : in    std_logic;
    f_rev_n  : in    std_logic;
    f_rck_p  : in    std_logic;
    f_rck_n  : in    std_logic;
    v_sck_p  : in    std_logic;  -- 42.3 MHz
    v_sck_n  : in    std_logic;  -- 42.3 MHz

    ledl     : out   std_logic;
    ledr     : out   std_logic;
    led      : out   std_logic_vector (7 downto 0);
    test     : out   std_logic_vector (7 downto 0);

    r_ackb_p : out   std_logic;
    r_ackb_n : out   std_logic;
    r_rsv_p  : out   std_logic;
    r_rsv_n  : out   std_logic;
    r_trg_p  : in    std_logic;
    r_trg_n  : in    std_logic;
    r_clkb_p : in    std_logic;
    r_clkb_n : in    std_logic;

    mode0    : in    std_logic;
    mode1    : in    std_logic;
    mode2    : in    std_logic;
    los      : in    std_logic;
    ratesel  : out   std_logic;
    txfault  : in    std_logic;
    txdis    : out   std_logic );

    --rx_p     : in    std_logic;
    --rx_n     : in    std_logic;
    --tx_p     : out   std_logic;
    --tx_n     : out   std_logic;

    --dumrx_p  : in    std_logic;
    --dumrx_n  : in    std_logic;
    --dumtx_p  : out   std_logic;
    --dumtx_n  : out   std_logic );
end hslb_b2tt;

architecture implementation of hslb_b2tt is
  -- B2TT clock (clk_127) domain signals
  signal sig_2Hz  : std_logic := '0';
  signal sig_raw127 : std_logic := '0';
  signal clk_127  : std_logic := '0';
  signal cnt_127  : std_logic_vector (26 downto 0) := (others => '0');
  signal sig_trig : std_logic := '0';
  signal sig_revo : std_logic := '0';

  signal sig_runreset : std_logic := '0';
  signal sta_runreset : std_logic := '0';
  
  -- FINESSE clock (clk_s) domain signals
  signal sig_sck  : std_logic := '0';
  signal clk_s    : std_logic := '0';
  signal seq_test : std_logic_vector (3  downto 0) := "0001";
  signal cnt_test : std_logic_vector (25 downto 0) := (others => '0');
  signal sig_test : std_logic_vector (7  downto 0) := (others => '0');

  -- REGISTERS
  constant MAX_RW8       : integer := 64;
  constant MAX_RO8       : integer := 32;
  constant MAX_RW32      : integer := 32;
  constant MAX_RO32      : integer := 64;
  signal reg_b : byte_vector      (MAX_RW8-1  + 16#00# downto 16#00#);
  signal set_b : std_logic_vector (MAX_RW8-1  + 16#00# downto 16#00#);
  signal sta_b : byte_vector      (MAX_RO8-1  + 16#40# downto 16#40#);
  signal get_b : std_logic_vector (MAX_RO8-1  + 16#40# downto 16#40#);
  signal reg_l : long_vector      (MAX_RW32-1 + 16#80# downto 16#80#);
  signal set_l : std_logic_vector (MAX_RW32-1 + 16#80# downto 16#80#);
  signal sta_l : long_vector      (MAX_RO32-1 + 16#c0# downto 16#c0#);
  signal get_l : std_logic_vector (MAX_RO32-1 + 16#c0# downto 16#c0#);

  -- REGISTER initial values
  signal ini_l : long_vector    (MAX_RW32-1 + 16#80# downto 16#80#) :=
    (16#80# => ID,
     others => x"00000000");
  signal ini_b : byte_vector    (MAX_RW8-1 + 16#00# downto 16#00#) :=
    (others => x"00");

  -- REGISTER assignment
  alias reg_boardid : word_t      is reg_l(16#81#)(15 downto 0);
  alias sig_trgtag  : long_t      is sta_l(16#c1#);
  alias sig_utime   : long_t      is sta_l(16#c2#);
  alias sig_ctime   : std_logic27 is sta_l(16#c3#)(26 downto 0);
  alias sta_dbg     : long_t      is sta_l(16#c4#);

  alias sig_clkup   : std_logic is sta_b(16#40#)(0);
  alias sig_ttup    : std_logic is sta_b(16#40#)(1);

  -- for chipscope
  signal sig_ilacontrol : std_logic_vector (35 downto 0) := (others => '0');
  signal sig_dbg        : std_logic_vector (95 downto 0) := (others => '0');
  
begin
  ----------------------------------------------------------------------
  -- Belle II Trigger Timing interface example implementation
  ----------------------------------------------------------------------
  test(0) <= sig_raw127;
  test(1) <= sig_trig;
  test(2) <= sig_revo;

  ledr   <= sig_2Hz;
  ledl   <= sta_runreset;
  led(0) <= sig_clkup;
  led(1) <= sig_ttup;
  led(3 downto 2) <= sig_trgtag(1 downto 0);

  proc_127: process (clk_127)
  begin
    if clk_127'event and clk_127 = '1' then
      if cnt_127 = (127216000/4-1) then
        cnt_127 <= (others => '0');
        sig_2Hz <= sig_2Hz;
      else
        cnt_127 <= cnt_127 + 1;
      end if;
      if sig_runreset = '1' then
        sta_runreset <= not sta_runreset;
      end if;
    end if; -- event
  end process;
  
  map_b2tt: entity work.b2tt
    generic map (
      SUBSYSTEM => TTFEE_DEMO, --     same as B2LFEE_DEMO
      FWTYPE    => 1,  -- 1 for HSLB, same as B2LDEMO_HSLB
      VERSION   => VERSION,
      FLIPACK   => '1',
      USEICTRL  => '1',
      USEPLL    => '0',
      USEFIFO   => '0' )
    port map (
      -- b2tt version
      b2ttver  => open, -- out 15:0
      
      -- RJ-45
      clkp     => r_clkb_p,
      clkn     => r_clkb_n,
      trgp     => r_trg_p,
      trgn     => r_trg_n,
      ackp     => r_ackb_p,
      ackn     => r_ackb_n,
      rsvp     => r_rsv_p,
      rsvn     => r_rsv_n,

      -- alternative external clock source
      extclk    => '0',
      extclkinv => '0',
      extclkdbl => '0',
      extdblinv => '0',
      extclklck => '0',

      -- board id
      id        => reg_boardid,
      
      -- user register
      usrreg   => open,
      usrdat   => x"0000",
       
      -- link status
      b2clkup  => sig_clkup,
      b2ttup   => sig_ttup,

      -- system clock and time
      sysclk   => clk_127,
      rawclk   => sig_raw127,
      dblclk   => open,      -- out
      utime    => sig_utime,
      ctime    => sig_ctime,

      -- divided clock
      divclk1  => open,
      divclk2  => open,

      -- run reset
      exprun   => open,
      runreset => sig_runreset,
      feereset => open,
      b2lreset => open,
      gtpreset => open,

      -- trigger
      trgout   => sig_trig,
      trgtyp   => open,
      trgtag   => sig_trgtag,
      
      -- revolution
      frame    => open, -- out
      frame9   => open, -- out
      revoloc  => open, -- out 10:0
      revosig  => sig_revo, -- out
      abortgap => open, -- out
      injveto  => open, -- out
      injkick  => open, -- out
      injvpos  => open, -- out 10:0;
      injvpre  => open, -- out 10:0;
      injvlen  => open, -- out 10:0;
      injvfull => open, -- out 9:0;
      injvgate => open, -- out 9:0;

      -- busy and status return
      busysrc  => x"00",
      feeerr   => x"00",

      -- Belle2link status
      b2plllk  => '1', -- dummy
      b2linkup => '1', -- dummy
      b2linkwe => '0',
      b2lclk   => clk_127,

      -- SEU status
      semscan  => '0',
      semdet   => '0',
      semmbe   => '0',
      semcrc   => '0',

      -- data for Belle2link header
      fifordy  => open,
      fifodata => open,
      fifonext => '0',

      -- b2tt-link status
      regdbg   => (others => '0'),
      octet    => open,
      isk      => open,
      cntbit2  => open,
      sigbit2  => open,
      dbglink  => sig_dbg,
      dbgerr   => open );
      --dbgerr   => sig_dbg,
      --dbglink  => open );
  
  ----------------------------------------------------------------------
  -- dummy input / output
  ----------------------------------------------------------------------
  f_bsy   <= '0';
  gen_led: for i in 0 to 3 generate
    led(4+i) <= seq_test(i);
  end generate;
  ratesel <= '0';
  txdis   <= '0';

  test(4 downto 3) <= (others => '0');
  map_ftrg: ibufds port map ( i => f_trg_p, ib => f_trg_n, o => test(5) );
  map_frev: ibufds port map ( i => f_rev_p, ib => f_rev_n, o => test(6) );
  map_frck: ibufds port map ( i => f_rck_p, ib => f_rck_n, o => test(7) );
  
  ----------------------------------------------------------------------
  -- COPPER system clock from TT-RX
  ----------------------------------------------------------------------
  map_scki: ibufds port map ( i => v_sck_p, ib => v_sck_n, o => sig_sck );
  map_sckg: bufg   port map ( i => sig_sck, o  => clk_s );
  proc: process (clk_s)
  begin
    if clk_s'event and clk_s = '1' then
      if cnt_test = (42333300/4)-1 then
        cnt_test <= (others => '0');
        seq_test <= seq_test(seq_test'left - 1 downto 0) &
                    seq_test(seq_test'left);
      else
        cnt_test <= cnt_test + 1;
      end if;
    end if; -- event
  end process;

  ----------------------------------------------------------------------
  -- readwrite
  ----------------------------------------------------------------------
  map_regs: entity myregs
    generic map (
      MAX_RW8  => MAX_RW8,  MAX_RO8  => MAX_RO8,
      MAX_RW32 => MAX_RW32, MAX_RO32 => MAX_RO32, VERSION  => VERSION )
    port map (
      dat => f_ld, adr => f_la, csb => c_csb, rd  => c_lwr, sck => clk_s,
      inib => ini_b, inil => ini_l,
      regb => reg_b, setb => set_b, stab => sta_b, getb => get_b,
      regl => reg_l, setl => set_l, stal => sta_l, getl => get_l );

  ----------------------------------------------------------------------
  -- chipscope
  ----------------------------------------------------------------------
  gen_cs: if USE_CHIPSCOPE = '1' generate
    map_icon: entity work.b2tt_icon port map ( control0 => sig_ilacontrol );
    map_ila:  entity work.b2tt_ila
      port map (
        control => sig_ilacontrol,
        clk     => clk_127,
        trig0   => sig_dbg );

  end generate;

end implementation;

--- (emacs outline mode setup)
-- Local Variables: ***
-- mode:outline-minor ***
-- outline-regexp:"^\\( *--- \\|begin\\|end\\|entity\\|architecture\\)" ***
-- End: ***

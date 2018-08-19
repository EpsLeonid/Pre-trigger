-- ---------------------------------------------------------------------
--
--- b2tt_payload.vhd -- TT-link payload filler
--
--  Mikihiko Nakao, KEK IPNS
--
--- revisions
--  20140806 first version, split from b2tt_encode.vhd
--  20160316 SEU mitigation bits rearranged
--  20160831 major payload rearrangement
--  20170713 ver, id, rstmask, ebit
--  20170724 semreset
--
-- ---------------------------------------------------------------------

--- b2tt_payload: library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.b2tt_symbols.all;

--- b2tt_payload: entity
entity b2tt_payload is
  port (
    clock     : in  std_logic;
    id        : in  std_logic_vector (23 downto 0);
    ver       : in  std_logic_vector (23 downto 0);
    utime     : in  std_logic_vector (31 downto 0);
    myaddr    : in  std_logic_vector (19 downto 0);
    b2clkup   : in  std_logic;
    b2ttup    : in  std_logic;
    b2plllk   : in  std_logic;
    b2linkup  : in  std_logic;
    b2linkwe  : in  std_logic;
    b2ttnext  : in  std_logic;
    b2lclk    : in  std_logic;
    staictrl  : in  std_logic_vector (1  downto 0);
    runreset  : in  std_logic;
    errreset  : in  std_logic;
    semreset  : in  std_logic;
    busysrc   : in  std_logic_vector (7  downto 0);
    feeerr    : in  std_logic_vector (7  downto 0);
    timerr    : in  std_logic;
    tag       : in  std_logic_vector (31 downto 0);
    tagerr    : in  std_logic;
    fifoerr   : in  std_logic;
    fifoful   : in  std_logic;
    badver    : in  std_logic;
    trgmask   : in  std_logic;
    rstmask   : in  std_logic;
    semscan   : in  std_logic;
    semdet    : in  std_logic;
    semmbe    : in  std_logic;
    semcrc    : in  std_logic;
    idly      : in  std_logic_vector (23 downto 0);
    fillsig   : in  std_logic;
    regsel    : in  ttreg_t;
    usrreg    : in  std_logic_vector (7  downto 0);
    usrdat    : in  std_logic_vector (15 downto 0);
    cntb2lwe  : out std_logic_vector (15 downto 0);
    cntftag   : out std_logic_vector (15 downto 0);
    payload   : out std_logic_vector (111 downto 0) );
end b2tt_payload;

--- b2tt_payload: architecture
architecture implementation of b2tt_payload is
  signal buf_btime    : std_logic_vector (23 downto 0) := (others => '0');
  signal buf_etime    : std_logic_vector (23 downto 0) := (others => '0');
  signal cnt_b2lwe    : std_logic_vector (47 downto 0) := (others => '0');
  signal cnt_ftag     : std_logic_vector (23 downto 0) := (others => '0');
  signal seq_seudet   : std_logic_vector (1  downto 0) := (others => '0');
  signal cnt_seudet   : std_logic_vector (9  downto 0) := (others => '0');
  signal seq_seuscan  : std_logic_vector (1  downto 0) := (others => '0');
  signal cnt_seuscan  : std_logic_vector (7  downto 0) := (others => '0');
  signal cnt_payload  : std_logic_vector (7  downto 0) := (others => '0');
  signal sta_feeerr   : std_logic_vector (7  downto 0) := (others => '0');
  signal sta_fifoerr  : std_logic := '0';
  --signal sta_fifoful  : std_logic := '0';
  signal sta_tagerr   : std_logic := '0';
  signal sta_timerr   : std_logic := '0';
  signal sta_clkup    : std_logic := '0';
  signal sta_ttup     : std_logic := '0';
  signal sta_b2lup    : std_logic := '0';
  signal sta_b2pll    : std_logic := '0';
  signal sig_clklost  : std_logic := '0';
  signal sig_ttlost   : std_logic := '0';
  signal sig_b2llost  : std_logic := '0';
  signal sig_plllost  : std_logic := '0';
  signal sta_clklost  : std_logic := '0';
  signal sta_ttlost   : std_logic := '0';
  signal sta_b2llost  : std_logic := '0';
  signal sta_plllost  : std_logic := '0';
  signal sig_errreset : std_logic := '0';
  signal sta_anyerr   : std_logic := '0';
  signal seq_anyerr   : std_logic := '0';
  signal seq_ereg     : std_logic := '0';
  signal seq_b2lwe    : std_logic_vector (1  downto 0) := (others => '0');

  signal sta_clost    : std_logic := '0';
  signal sta_terr     : std_logic := '0';
  signal sta_rerr     : std_logic := '0';
  signal sta_ebit     : std_logic_vector (5  downto 0) := (others => '0');

  signal cnt_cklost   : std_logic_vector (2  downto 0) := (others => '0');
  signal cnt_ttlost   : std_logic_vector (2  downto 0) := (others => '0');
  signal cnt_lklost   : std_logic_vector (2  downto 0) := (others => '0');
  
  signal sta_anybsy   : std_logic := '0';

  signal buf_ereg     : std_logic_vector (31  downto 0) := (others => '0');
  signal buf_payload  : std_logic_vector (111 downto 0) := (others => '0');
  alias rega : std_logic_vector (31 downto 0) is buf_payload(63 downto 32);
  alias regb : std_logic_vector (31 downto 0) is buf_payload(31 downto 0);

  function setsta
    ( sta: std_logic; rst: std_logic; sig: std_logic ) return std_logic is
  begin
    if rst = '1' then
      return sig;
    else
      return sta or sig;
    end if;
  end function setsta;
  
--- b2tt_payload: begin
begin
  --- in
  sig_errreset <= errreset or runreset;

  sta_clost  <= '1' when staictrl /= "11" else (sta_clklost or sta_plllost);
  sta_terr   <= '1' when sta_ebit   /= 0 else '0';
  sta_rerr   <= '1' when sta_feeerr /= 0 else '0';
  sta_anyerr <= sta_terr or sta_clost or (not b2ttup) or sta_ttlost or
                sta_rerr or (not b2linkup) or sta_b2llost;
  sta_anybsy <= '1' when busysrc /= 0 else fifoful;

  --- proc_b2l
  proc_b2l: process (b2lclk)
  begin
    if rising_edge(b2lclk) then
      if b2clkup = '0' or b2linkup = '0' or runreset = '1' then
        cnt_b2lwe <= (others => '0');
        cnt_ftag  <= (others => '0');
      else
        if b2linkwe = '1' then
          cnt_b2lwe <= cnt_b2lwe + 1;
        end if;
        if b2ttnext = '1' then
          cnt_ftag <= cnt_ftag + 1;
        end if;
      end if;
    end if;
  end process;

  --- proc_main
  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      --- seq_seudet, cnt_seudet
      seq_seudet <= seq_seudet(0) & semdet;
      if semreset = '1' then
        cnt_seudet <= (others => '0');
      elsif seq_seudet = "01" then
        cnt_seudet <= cnt_seudet + 1;
      end if;
      
      --- seq_seuscan, cnt_seuscan
      seq_seuscan <= seq_seuscan(0) & semscan;
      if semreset = '1' then
        cnt_seuscan <= (others => '0');
      elsif seq_seuscan = "01" then
        cnt_seuscan <= cnt_seuscan + 1;
      end if;

      --- lost
      sta_clkup   <= b2clkup;
      sta_ttup    <= b2ttup;
      sta_b2lup   <= b2linkup;
      sta_b2pll   <= b2plllk;

      sig_clklost <= sta_clkup and (not b2clkup);
      sig_ttlost  <= sta_ttup  and (not b2ttup);
      sig_b2llost <= sta_b2lup and (not b2linkup);
      sig_plllost <= sta_b2pll and (not b2plllk);
      
      sta_clklost <= setsta(sta_clklost, sig_errreset, sig_clklost);
      sta_ttlost  <= setsta(sta_ttlost,  sig_errreset, sig_ttlost);
      sta_b2llost <= setsta(sta_b2llost, sig_errreset, sig_b2llost);
      sta_plllost <= setsta(sta_plllost, sig_errreset, sig_plllost);

      --- error
      if sig_errreset = '1' then
        sta_feeerr <= (others => '0');
      else
        sta_feeerr <= sta_feeerr or feeerr;
      end if;
      sta_fifoerr <= setsta(sta_fifoerr, sig_errreset, fifoerr);
      sta_tagerr  <= setsta(sta_tagerr,  sig_errreset, tagerr);
      sta_timerr  <= setsta(sta_timerr,  sig_errreset, timerr);

      sta_ebit <= sta_tagerr &
                  sta_timerr &
                  badver &
                  sta_fifoerr &
                  semmbe &
                  semcrc;
      
      --- utime
      if buf_btime = 0 then
        buf_btime <= utime(23 downto 0);
      end if;

      -- etime (event time)
      seq_anyerr <= sta_anyerr;
      seq_b2lwe  <= seq_b2lwe(0) & b2linkwe;
      if sta_anyerr /= seq_anyerr or seq_b2lwe(1) /= seq_b2lwe(0) then
        buf_etime <= utime(23 downto 0);
        seq_ereg <= '1';
      else
        seq_ereg <= '0';
      end if;
      if seq_ereg = '1' then
        buf_ereg <= rega;
      end if;

      -- "count" lost transitions
      if sig_errreset = '1' then
        cnt_cklost <= "000";
        cnt_ttlost <= "000";
        cnt_lklost <= "000";
      else
        -- 2017.0708.0721 no limit to detect frequent lost
        if sig_clklost = '1' then
          cnt_cklost(2) <= cnt_cklost(2) or (cnt_cklost(1) and cnt_cklost(0));
          cnt_cklost(1 downto 0) <= cnt_cklost(1 downto 0) + 1;
        end if;
        if sig_ttlost = '1' then
          cnt_ttlost(2) <= cnt_ttlost(2) or (cnt_ttlost(1) and cnt_ttlost(0));
          cnt_ttlost(1 downto 0) <= cnt_ttlost(1 downto 0) + 1;
        end if;
        if sig_b2llost = '1' then
          cnt_lklost(2) <= cnt_lklost(2) or (cnt_lklost(1) and cnt_lklost(0));
          cnt_lklost(1 downto 0) <= cnt_lklost(1 downto 0) + 1;
        end if;
      end if;
      
      --- payload sticky
      buf_payload(91  downto 84) <= cnt_payload;
      buf_payload(83) <= '0'; -- dsel is always 0 at FEE
      buf_payload(82) <= not b2ttup;
      buf_payload(81) <= sta_anybsy;
      buf_payload(80) <= sta_anyerr;
      buf_payload(79 downto 70) <= (others => '0'); -- 10 bit reserved
      
      --- payload
      if b2clkup = '0' then
        buf_payload(111 downto 92) <= x"feeee";  -- impossible address
        rega <= "000" & TTREG_CLOST & "0010" & x"0dead";
      elsif fillsig = '1' then
        buf_payload(111 downto 92) <= myaddr;
        
        -- here we don't care overflow, it is watched in the upstream
        buf_payload(69 downto 64) <= cnt_seudet(5 downto 0);

        --- payload rega
        --  trigger will be blocked if rega /= TTREG_FTAG
        if sta_clklost = '1' or sta_plllost = '1' or staictrl /= "11" then
          rega <= "000" & TTREG_CLOST & "000"
                  & sta_clklost & (not b2plllk) & sta_plllost
                  & (not staictrl) & cnt_cklost & "0" & x"000"; -- 1d
        elsif b2ttup = '0' then
          rega <= "000" & TTREG_TDOWN & '0' & cnt_ttlost & x"00000"; -- 1c
        elsif sta_ttlost = '1' then
          rega <= "000" & TTREG_TLOST & '0' & cnt_ttlost & x"00000"; -- 1b
        elsif sta_ebit /= 0 then
          rega <= "000" & TTREG_TERR  & sta_ebit & "00" & x"0000"; -- 1a
        elsif feeerr /= 0 then
          rega <= "000" & TTREG_FERR & feeerr & x"0000"; -- 19
        elsif sta_feeerr /= 0 then
          rega <= "000" & TTREG_RERR & sta_feeerr & x"0000"; -- 18
        elsif b2linkup = '0' then
          rega <= "000" & TTREG_LDOWN & '0' & cnt_lklost & x"00000"; -- 17
        elsif sta_b2llost = '1' then
          rega <= "000" & TTREG_LLOST & '0' & cnt_lklost & x"00000"; -- 16
        else
          -- always showing "tagdone" unless there is an error
          -- which unrecoverable without runreset
          rega <= "000" & TTREG_FTAG & cnt_ftag; -- 0c
        end if;

        --- payload regb
        --  if regb is not selected by regsel, error bit is sent, which
        --  will be merged in upstream
        --
        --  registers used for rega has not much meaning for regsel at FEE
        --  and has no effect here, but they makes sense at intemediate FTSWs
        if regsel = TTREG_USR then -- 01
          regb <= "000" & regsel & usrreg & usrdat;
        elsif regsel = TTREG_VER then -- 02
          regb <= "000" & regsel & ver;
        elsif regsel = TTREG_ID then -- 03
          regb <= "000" & regsel & id;
        elsif regsel = TTREG_PREG then -- 04
          regb <= rega;
        elsif regsel = TTREG_EREG then -- 05
          regb <= "000" & buf_ereg(28 downto 0);
        elsif regsel = TTREG_BTIME then -- 06
          regb <= "000" & regsel & buf_btime(23 downto 0);
        elsif regsel = TTREG_ETIME then -- 07
          regb <= "000" & regsel & buf_etime;
        elsif regsel = TTREG_WCNTL then -- 08
          regb <= "000" & regsel & cnt_b2lwe(23 downto 0);
        elsif regsel = TTREG_WCNTH then -- 09
          regb <= "000" & regsel & cnt_b2lwe(47 downto 24);
        elsif regsel = TTREG_FTAG then -- 0a
          regb <= "000" & regsel & cnt_ftag;
        elsif regsel = TTREG_TTAG then -- 0b
          regb <= "000" & regsel & tag(23 downto 0);
        elsif regsel = TTREG_SEM then -- 0c
          regb <= "000" & regsel &
                  semmbe & semcrc & semdet & semscan & "00" &
                  cnt_seudet & cnt_seuscan;
        elsif regsel = TTREG_IDLY then -- 13
          regb <= "000" & regsel & idly;
        elsif regsel = TTREG_EBIT then -- 15
          regb <= "000" & regsel  &
                  sta_ebit & -- 6 bit
                  "00000" & -- 5 bit
                  sta_clost & (not b2ttup) & sta_ttlost &  -- 3 bit
                  (not b2linkup) & sta_b2llost & -- 2 bit
                  sta_feeerr; -- 8 bit
        elsif regsel = TTREG_FERR then -- 19
          regb <= "000" & regsel & feeerr & x"0000";
        elsif regsel = TTREG_TMASK or
             (regsel /= TTREG_BUSY and trgmask = '1') then -- 0f
          regb <= "000" & TTREG_TMASK & sta_anyerr & sta_anybsy &
                  rstmask & trgmask & (not b2ttup) & "000" & x"0000";
        elsif regsel = TTREG_BUSY or busysrc /= 0 then -- 14
          regb <= "000" & TTREG_BUSY & busysrc & fifoful & "000" & x"000";
        else
          regb <= rega;
        end if;
        
        cnt_payload <= cnt_payload + 1;
      end if;
    end if;
  end process;

  --- out
  payload  <= buf_payload;
  cntftag  <= cnt_ftag(cntftag'left downto 0);
  cntb2lwe <= cnt_b2lwe(cntb2lwe'left downto 0);
  
--- b2tt_payload: end
end implementation;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.types.all;
use work.constants.all;

entity adc_deser_8ch_12bits is
  generic (
    ADCNUM        : integer := 1
  );
  port(
    i_clock         : in std_logic;
    
    reset         : in std_logic;
    bitslip_reset : in std_logic;

    --temporary
    shift       : in std_logic_vector(7 downto 0);

    o_clock_adc     : out std_logic;
                   
    o_data        : out t_adc_data_8_array;

    o_data_we       : out std_logic;
                 
    -- PINS      
    SDATAP        : in std_logic_vector(8 downto 1);
    SDATAN        : in std_logic_vector(8 downto 1);

    DCOP          : in std_logic;
    DCON          : in std_logic;
                 
    FCOP          : in std_logic;
    FCON          : in std_logic );

end adc_deser_8ch_12bits;

architecture original of adc_deser_8ch_12bits is

  type   t_serdes_q_arr is array(1 to 8) of std_logic_vector(3 downto 0);

	signal dco_ib            : std_logic := '0';
	signal dco_strobe        : std_logic := '0';
	signal dco_divclk        : std_logic := '0';
	signal dco_ioclkp        : std_logic := '0';
	signal dco_ioclkn        : std_logic := '0';

	signal buf_dco_ioclkp        : std_logic := '0';
	signal buf_dco_ioclkn        : std_logic := '0';

	signal s_clock_adc       : std_logic := '0';
	
	signal vec_sdata_ib      : std_logic_vector(7 downto 0) := (others => '0');
	signal fco_ib            : std_logic := '0';
	
	signal serdes_q          : t_serdes_q_arr := (others => (others=>'0'));
	
	signal fco_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal fco_serdes_q_r    : std_logic_vector(3 downto 0) := (others=>'0');
	signal fco_serdes_q_dr   : std_logic_vector(3 downto 0) := (others=>'0');

	signal data_sr           : t_adc_data_array(1 to 8) := (others => (others=>'0'));
	                        
	signal fco_data_sr       : t_adc_data := (others=>'0');

	signal adc_data_bad      : t_adc_data := (others=>'0');
	
	signal adc_data_r        : t_adc_data_array(1 to 8) := (others => (others=>'0'));
	signal frame_start_r     : std_logic := '0';
	
	signal bit_slip_reset_r  : std_logic := '0';
	signal bit_slip_r        : std_logic := '0';
	signal bit_slip_finished : std_logic := '0';
	signal bit_slip_sr       : std_logic_vector(3 downto 0) := (others=>'0');
	
	signal data_we_cnt       : std_logic_vector(2 downto 0) := (others=>'0');
	signal data_we_sr        : std_logic_vector(6 downto 0) := (others=>'0');
	signal data_we_r         : std_logic := '0';
  signal s_data_we_bad     : std_logic := '0';

  signal dco_ioclkn_div1    : std_logic;
  signal dco_ioclkp_div1    : std_logic;
  signal fco_ioclkp_div1    : std_logic;
  signal buf_fco_ioclkp    : std_logic;
  signal rx_data_in         : std_logic;

  signal clkfb : std_logic;
  signal locked : std_logic;
  signal frfr   : std_logic; -- without this frfr signal PLL doesn't work

begin


------ CLOCKING ----------

dco_ibufgds : IBUFGDS
generic map(
	DIFF_TERM => TRUE)
port map(
	O  => dco_ib,
	I  => DCOP,
	IB => DCON);

dco_bufio2p : BUFIO2
generic map(
	DIVIDE => 4,
	DIVIDE_BYPASS => FALSE,
	I_INVERT => FALSE,
	USE_DOUBLER => TRUE)
port map(
	DIVCLK       => dco_divclk,
	IOCLK        => dco_ioclkp,
	SERDESSTROBE => dco_strobe,
	I            => dco_ib);
	
dco_bufio2n : BUFIO2
generic map(
	DIVIDE => 4,
	DIVIDE_BYPASS => FALSE,
	I_INVERT    => TRUE,
	USE_DOUBLER => FALSE)
port map(
	IOCLK => dco_ioclkn,
	I     => dco_ib);
	
dco_bufg : BUFG
port map(
	I => dco_divclk,
	O => s_clock_adc);

  ----------------------------------
  SERDES_GEN : for iADC in 1 to 8 generate


    BAD_CHANNEL : if SIMPLE_DESER_CHAN = (ADCNUM-1)*8+iADC generate

    iob_data_in : IBUFDS 
    generic map( DIFF_TERM => TRUE )
    port map   (
      I               => SDATAP(iADC),
      IB              => SDATAN(iADC),
      O               => rx_data_in );

  PLL_BASE_inst : PLL_BASE
   generic map (
      BANDWIDTH => "OPTIMIZED",             -- "HIGH", "LOW" or "OPTIMIZED" 
      CLKFBOUT_MULT => 16,                   -- Multiply value for all CLKOUT clock outputs (1-64)
      CLKFBOUT_PHASE => 0.0,                -- Phase offset in degrees of the clock feedback output
                                            -- (0.0-360.0).
      CLKIN_PERIOD => 5.552,                  -- Input clock period in ns to ps resolution (i.e. 33.333 is 30
                                            -- MHz).
      -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for CLKOUT# clock output (1-128)
      CLKOUT0_DIVIDE => 4,
      CLKOUT1_DIVIDE => 4,
      CLKOUT2_DIVIDE => 13,
      -- CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for CLKOUT# clock output (0.01-0.99).
      CLKOUT0_DUTY_CYCLE => 0.5,
      CLKOUT1_DUTY_CYCLE => 0.5,
      CLKOUT2_DUTY_CYCLE => 0.5,
      -- CLKOUT0_PHASE - CLKOUT5_PHASE: Output phase relationship for CLKOUT# clock output (-360.0-360.0).
      CLKOUT0_PHASE => 0.0,
      CLKOUT1_PHASE => 180.0,
      CLK_FEEDBACK => "CLKFBOUT",           -- Clock source to drive CLKFBIN ("CLKFBOUT" or "CLKOUT0")
      COMPENSATION => "SYSTEM_SYNCHRONOUS", -- "SYSTEM_SYNCHRONOUS", "SOURCE_SYNCHRONOUS", "EXTERNAL" 
      DIVCLK_DIVIDE => 4,                   -- Division value for all output clocks (1-52)
      REF_JITTER => 0.1,                    -- Reference Clock Jitter in UI (0.000-0.999).
      RESET_ON_LOSS_OF_LOCK => FALSE        -- Must be set to FALSE
   )
   port map (
      CLKFBOUT => clkfb, -- 1-bit output: PLL_BASE feedback output
      -- CLKOUT0 - CLKOUT5: 1-bit (each) output: Clock outputs
      CLKOUT0 => dco_ioclkp_div1,
      CLKOUT1 => dco_ioclkn_div1,
      CLKOUT2 => frfr,
      LOCKED => locked,     -- 1-bit output: PLL_BASE lock status output
      CLKFBIN => clkfb,   -- 1-bit input: Feedback clock input
      CLKIN => dco_ib,       -- 1-bit input: Clock input
      RST => reset           -- 1-bit input: Reset input
   );

    dco_bufbufgp : BUFG
    port map(
      I => dco_ioclkp_div1,
      O => buf_dco_ioclkp);


    dco_bufbufgn : BUFG
    port map(
      I => dco_ioclkn_div1,
      O => buf_dco_ioclkn);


      SIMPLEDES : entity work.simple_deser
      port map (
        dco_ib_p   => buf_dco_ioclkp,
        dco_ib_n   => buf_dco_ioclkn,
        framestart => frame_start_r,
        clock_adc  => s_clock_adc,
        reset      => reset,
        shift      => shift, 
        rx_data_in => rx_data_in, 
        o_data     => adc_data_bad,
        data_we    => s_data_we_bad
        --SDATAP     => SDATAP(iADC),
        --SDATAN     => SDATAN(iADC)
      );

      process(s_clock_adc)
      begin
        if rising_edge(s_clock_adc) then
          adc_data_r(iADC) <= adc_data_r(iADC);
          if frame_start_r = '1' then
            adc_data_r(iADC) <= adc_data_bad;
          end if;
        end if;
      end process;

    end generate BAD_CHANNEL;

    GOOD_CHANNEL : if SIMPLE_DESER_CHAN /= (ADCNUM-1)*8+iADC generate

      sdata_ibufds : IBUFDS
      port map(
        O  => vec_sdata_ib(iADC-1),
        I  => SDATAP(iADC),
        IB => SDATAN(iADC));

      iserdes2_i : ISERDES2
      generic map(
        BITSLIP_ENABLE => TRUE,
        DATA_RATE => "DDR",
        DATA_WIDTH => 4,
        INTERFACE_TYPE => "RETIMED",
        SERDES_MODE => "NONE")
      port map (
        CE0 => '1',
        BITSLIP => bit_slip_r,
        SHIFTIN => '0',
        Q1 => serdes_q(iADC)(3),
        Q2 => serdes_q(iADC)(2),
        Q3 => serdes_q(iADC)(1),
        Q4 => serdes_q(iADC)(0),
        CLK0 => dco_ioclkp,
        CLK1 => dco_ioclkn,
        CLKDIV => s_clock_adc,
        D => vec_sdata_ib(iADC-1),
        IOCE => dco_strobe,
        RST  => bit_slip_reset_r);

        process(s_clock_adc)
        begin
          if s_clock_adc'event and s_clock_adc='1' then
            data_sr(iADC) <= data_sr(iADC)(7 downto 0) & serdes_q(iADC);
            if frame_start_r='1' then
              adc_data_r(iADC) <= data_sr(iADC)(11 downto 0);
            end if;
          end if;
        end process;

      end generate GOOD_CHANNEL;

    o_data(iADC) <= adc_data_r(iADC);

  end generate SERDES_GEN;

----------------------------------

  fco_ibufds : IBUFDS
  port map(
    O  => fco_ib,
    I  => FCOP,
    IB => FCON);

  fco_iserdes2 : ISERDES2
  generic map(
    BITSLIP_ENABLE => TRUE,
    DATA_RATE => "DDR",
    DATA_WIDTH => 4,
    INTERFACE_TYPE => "RETIMED",
    SERDES_MODE => "NONE")
  port map (
    CE0 => '1',
    BITSLIP => bit_slip_r,
    SHIFTIN => '0',
    Q1 => fco_serdes_q(3),
    Q2 => fco_serdes_q(2),
    Q3 => fco_serdes_q(1),
    Q4 => fco_serdes_q(0),
    CLK0 => dco_ioclkp,
    CLK1 => dco_ioclkn,
    CLKDIV => s_clock_adc,
    D => fco_ib,
    IOCE => dco_strobe,
    RST  => bit_slip_reset_r);

  process(s_clock_adc)
  begin
    if s_clock_adc'event and s_clock_adc='1' then
      
      fco_serdes_q_r <= fco_serdes_q;
      fco_serdes_q_dr <= fco_serdes_q_r;
      
      bit_slip_r <= '0';
      bit_slip_sr <= bit_slip_sr(2 downto 0) & '0';

      if fco_serdes_q_r(3)='0' and fco_serdes_q_r(0)='1' and bit_slip_sr=B"0000" then
        bit_slip_r <= '1';
        bit_slip_sr <= "1111";
      end if;
      
      bit_slip_reset_r <= bitslip_reset;
      
      frame_start_r <= '0';
      if fco_serdes_q_dr = B"1111" then
        frame_start_r <= '1';
      end if;
      
      data_we_r <= frame_start_r;
      
    end if; -- s_clock_adc
  end process;


  o_data_we    <= data_we_r;
  o_clock_adc  <= s_clock_adc;

end original;

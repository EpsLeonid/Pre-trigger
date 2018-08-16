-- original deserializers from V.Zhulanov
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.types.all;

entity adc_deser_8ch_12bits is
port(
	clock         : in std_logic;
	
	bitslip_reset : in std_logic;
	--temporary
	shift_1       : in std_logic_vector(3 downto 0);
	shift_2       : in std_logic_vector(3 downto 0);

	clock_adc     : out std_logic;
                 
	o_data_fco    : out std_logic_vector(11 downto 0);
	o_data        : out stdlv_array_8x12_t;

	data_we       : out std_logic;
	             
	-- PINS      
	SDATAP        : in std_logic_vector(8 downto 1);
	SDATAN        : in std_logic_vector(8 downto 1);

	DCOP          : in std_logic;
	DCON          : in std_logic;
	             
	FCOP          : in std_logic;
	FCON          : in std_logic);

end adc_deser_8ch_12bits;

architecture original of adc_deser_8ch_12bits is

	signal dco_ib            : std_logic := '0';
	signal dco_strobe        : std_logic := '0';
	signal dco_divclk        : std_logic := '0';
	signal dco_ioclkp        : std_logic := '0';
	signal dco_ioclkn        : std_logic := '0';

	signal s_clock_adc       : std_logic := '0';
	
	signal sdata1_ib         : std_logic := '0';
	signal sdata2_ib         : std_logic := '0';
	signal sdata3_ib         : std_logic := '0';
	signal sdata4_ib         : std_logic := '0';
	signal sdata5_ib         : std_logic := '0';
	signal sdata6_ib         : std_logic := '0';
	signal sdata7_ib         : std_logic := '0';
	signal sdata8_ib         : std_logic := '0';
	signal fco_ib            : std_logic := '0';
	
	signal ch1_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal ch2_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal ch3_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal ch4_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal ch5_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal ch6_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal ch7_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal ch8_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	
	signal fco_serdes_q      : std_logic_vector(3 downto 0) := (others=>'0');
	signal fco_serdes_q_r    : std_logic_vector(3 downto 0) := (others=>'0');
	signal fco_serdes_q_dr   : std_logic_vector(3 downto 0) := (others=>'0');

	signal ch1_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	signal ch2_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	signal ch3_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	signal ch4_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	signal ch5_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	signal ch6_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	signal ch7_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	signal ch8_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	                        
	signal fco_data_sr       : std_logic_vector(11 downto 0) := (others=>'0');
	
	signal adc_data_ch1_r    : std_logic_vector(11 downto 0) := (others=>'0');
	signal adc_data_ch2_r    : std_logic_vector(11 downto 0) := (others=>'0');
	signal adc_data_ch3_r    : std_logic_vector(11 downto 0) := (others=>'0');
	signal adc_data_ch4_r    : std_logic_vector(11 downto 0) := (others=>'0');
	signal adc_data_ch5_r    : std_logic_vector(11 downto 0) := (others=>'0');
	signal adc_data_ch6_r    : std_logic_vector(11 downto 0) := (others=>'0');
	signal adc_data_ch7_r    : std_logic_vector(11 downto 0) := (others=>'0');
	signal adc_data_ch8_r    : std_logic_vector(11 downto 0) := (others=>'0');
	signal adc_data_fco_r    : std_logic_vector(11 downto 0) := (others=>'0');

	signal frame_start_r     : std_logic := '0';
	
	signal bit_slip_reset_r  : std_logic := '0';
	signal bit_slip_r        : std_logic := '0';
	signal bit_slip_finished : std_logic := '0';
	signal bit_slip_sr       : std_logic_vector(3 downto 0) := (others=>'0');
	
	signal data_we_cnt       : std_logic_vector(2 downto 0) := (others=>'0');
	signal data_we_sr        : std_logic_vector(6 downto 0) := (others=>'0');
	signal data_we_r         : std_logic := '0';
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

------ ADC1 ----------------------
sdata1_ibufds : IBUFDS
port map(
	O  => sdata1_ib,
	I  => SDATAP(1),
	IB => SDATAN(1));

ch1_iserdes2 : ISERDES2
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
	Q1 => ch1_serdes_q(3),
	Q2 => ch1_serdes_q(2),
	Q3 => ch1_serdes_q(1),
	Q4 => ch1_serdes_q(0),
	CLK0 => dco_ioclkp,
	CLK1 => dco_ioclkn,
	CLKDIV => s_clock_adc,
	D => sdata1_ib,
	IOCE => dco_strobe,
	RST  => bit_slip_reset_r);
----------------------------------

------ ADC2 ----------------------
sdata2_ibufds : IBUFDS
port map(
	O  => sdata2_ib,
	I  => SDATAP(2),
	IB => SDATAN(2));

ch2_iserdes2 : ISERDES2
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
	Q1 => ch2_serdes_q(3),
	Q2 => ch2_serdes_q(2),
	Q3 => ch2_serdes_q(1),
	Q4 => ch2_serdes_q(0),
	CLK0 => dco_ioclkp,
	CLK1 => dco_ioclkn,
	CLKDIV => s_clock_adc,
	D => sdata2_ib,
	IOCE => dco_strobe,
	RST  => bit_slip_reset_r);

sdata3_ibufds : IBUFDS
port map(
	O  => sdata3_ib,
	I  => SDATAP(3),
	IB => SDATAN(3));

ch3_iserdes2 : ISERDES2
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
	Q1 => ch3_serdes_q(3),
	Q2 => ch3_serdes_q(2),
	Q3 => ch3_serdes_q(1),
	Q4 => ch3_serdes_q(0),
	CLK0 => dco_ioclkp,
	CLK1 => dco_ioclkn,
	CLKDIV => s_clock_adc,
	D => sdata3_ib,
	IOCE => dco_strobe,
	RST  => bit_slip_reset_r);

sdata4_ibufds : IBUFDS
port map(
	O  => sdata4_ib,
	I  => SDATAP(4),
	IB => SDATAN(4));

ch4_iserdes2 : ISERDES2
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
	Q1 => ch4_serdes_q(3),
	Q2 => ch4_serdes_q(2),
	Q3 => ch4_serdes_q(1),
	Q4 => ch4_serdes_q(0),
	CLK0 => dco_ioclkp,
	CLK1 => dco_ioclkn,
	CLKDIV => s_clock_adc,
	D => sdata4_ib,
	IOCE => dco_strobe,
	RST  => bit_slip_reset_r);

sdata5_ibufds : IBUFDS
port map(
	O  => sdata5_ib,
	I  => SDATAP(5),
	IB => SDATAN(5));

ch5_iserdes2 : ISERDES2
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
	Q1 => ch5_serdes_q(3),
	Q2 => ch5_serdes_q(2),
	Q3 => ch5_serdes_q(1),
	Q4 => ch5_serdes_q(0),
	CLK0 => dco_ioclkp,
	CLK1 => dco_ioclkn,
	CLKDIV => s_clock_adc,
	D => sdata5_ib,
	IOCE => dco_strobe,
	RST  => bit_slip_reset_r);

sdata6_ibufds : IBUFDS
port map(
	O  => sdata6_ib,
	I  => SDATAP(6),
	IB => SDATAN(6));

ch6_iserdes2 : ISERDES2
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
	Q1 => ch6_serdes_q(3),
	Q2 => ch6_serdes_q(2),
	Q3 => ch6_serdes_q(1),
	Q4 => ch6_serdes_q(0),
	CLK0 => dco_ioclkp,
	CLK1 => dco_ioclkn,
	CLKDIV => s_clock_adc,
	D => sdata6_ib,
	IOCE => dco_strobe,
	RST  => bit_slip_reset_r);

sdata7_ibufds : IBUFDS
port map(
	O  => sdata7_ib,
	I  => SDATAP(7),
	IB => SDATAN(7));

ch7_iserdes2 : ISERDES2
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
	Q1 => ch7_serdes_q(3),
	Q2 => ch7_serdes_q(2),
	Q3 => ch7_serdes_q(1),
	Q4 => ch7_serdes_q(0),
	CLK0 => dco_ioclkp,
	CLK1 => dco_ioclkn,
	CLKDIV => s_clock_adc,
	D => sdata7_ib,
	IOCE => dco_strobe,
	RST  => bit_slip_reset_r);

sdata8_ibufds : IBUFDS
port map(
	O  => sdata8_ib,
	I  => SDATAP(8),
	IB => SDATAN(8));

ch8_iserdes2 : ISERDES2
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
	Q1 => ch8_serdes_q(3),
	Q2 => ch8_serdes_q(2),
	Q3 => ch8_serdes_q(1),
	Q4 => ch8_serdes_q(0),
	CLK0 => dco_ioclkp,
	CLK1 => dco_ioclkn,
	CLKDIV => s_clock_adc,
	D => sdata8_ib,
	IOCE => dco_strobe,
	RST  => bit_slip_reset_r);

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
		ch1_data_sr <= ch1_data_sr(7 downto 0) & ch1_serdes_q;
		ch2_data_sr <= ch2_data_sr(7 downto 0) & ch2_serdes_q;
		ch3_data_sr <= ch3_data_sr(7 downto 0) & ch3_serdes_q;
		ch4_data_sr <= ch4_data_sr(7 downto 0) & ch4_serdes_q;
		ch5_data_sr <= ch5_data_sr(7 downto 0) & ch5_serdes_q;
		ch6_data_sr <= ch6_data_sr(7 downto 0) & ch6_serdes_q;
		ch7_data_sr <= ch7_data_sr(7 downto 0) & ch7_serdes_q;
		ch8_data_sr <= ch8_data_sr(7 downto 0) & ch8_serdes_q;
		fco_data_sr <= fco_data_sr(7 downto 0) & fco_serdes_q;
		
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
		
		if frame_start_r='1' then
			adc_data_ch1_r <= ch1_data_sr(11 downto 0);
			adc_data_ch2_r <= ch2_data_sr(11 downto 0);
			adc_data_ch3_r <= ch3_data_sr(11 downto 0);
			adc_data_ch4_r <= ch4_data_sr(11 downto 0);
			adc_data_ch5_r <= ch5_data_sr(11 downto 0);
			adc_data_ch6_r <= ch6_data_sr(11 downto 0);
			adc_data_ch7_r <= ch7_data_sr(11 downto 0);
			adc_data_ch8_r <= ch8_data_sr(11 downto 0);
			adc_data_fco_r <= fco_data_sr(11 downto 0);
		end if;

	end if; -- s_clock_adc
end process;

o_data(1) <= adc_data_ch1_r;
o_data(2) <= adc_data_ch2_r;
o_data(3) <= adc_data_ch3_r;
o_data(4) <= adc_data_ch4_r;
o_data(5) <= adc_data_ch5_r;
o_data(6) <= adc_data_ch6_r;
o_data(7) <= adc_data_ch7_r;
o_data(8) <= adc_data_ch8_r;

o_data_fco <= adc_data_fco_r;

data_we <= data_we_r;

clock_adc <= s_clock_adc;


end original;

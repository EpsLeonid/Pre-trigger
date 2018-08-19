library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use ieee.std_logic_arith.all; -- conv_std_logic_vector
use ieee.numeric_bit.all;

use std.textio.all;

entity tb_adc_8ch_12bits is
generic(
	module_name : string;
	ch1_file : string;
	ch2_file : string;
	ch3_file : string;
	ch4_file : string;
	ch5_file : string;
	ch6_file : string;
	ch7_file : string;
	ch8_file : string);
port(
	CLKP : in std_logic;
	CLKN : in std_logic;
	
	DCOP : out std_logic;
	DCON : out std_logic;
	
	FCOP : out std_logic;
	FCON : out std_logic;
	
	DOAP : out std_logic;
	DOAN : out std_logic;

	DOBP : out std_logic;
	DOBN : out std_logic;

	DOCP : out std_logic;
	DOCN : out std_logic;

	DODP : out std_logic;
	DODN : out std_logic;

	DOEP : out std_logic;
	DOEN : out std_logic;

	DOFP : out std_logic;
	DOFN : out std_logic;

	DOGP : out std_logic;
	DOGN : out std_logic;

	DOHP : out std_logic;
	DOHN : out std_logic;

	CSN     : in std_logic;
	SDIO    : inout std_logic;
	SCLK    : in std_logic);
end tb_adc_8ch_12bits;

architecture behavioral of tb_adc_8ch_12bits is
	signal dco : std_logic := '0';
	signal fco : std_logic := '0';
	
	signal doa : std_logic := '0';
	signal dob : std_logic := '0';
	signal doc : std_logic := '0';
	signal dod : std_logic := '0';
	signal doe : std_logic := '0';
	signal dof : std_logic := '0';
	signal dog : std_logic := '0';
	signal doh : std_logic := '0';

	signal dcop_s : std_logic := '0';
	signal dcon_s : std_logic := '1';

	signal fcop_s : std_logic := '0';
	signal fcon_s : std_logic := '1';

	signal doap_s : std_logic := '0';
	signal doan_s : std_logic := '1';

	signal dobp_s : std_logic := '0';
	signal dobn_s : std_logic := '1';

	signal docp_s : std_logic := '0';
	signal docn_s : std_logic := '1';

	signal dodp_s : std_logic := '0';
	signal dodn_s : std_logic := '1';

	signal doep_s : std_logic := '0';
	signal doen_s : std_logic := '1';

	signal dofp_s : std_logic := '0';
	signal dofn_s : std_logic := '1';

	signal dogp_s : std_logic := '0';
	signal dogn_s : std_logic := '1';

	signal dohp_s : std_logic := '0';
	signal dohn_s : std_logic := '1';

	signal dbg_a : std_logic_vector(11 downto 0) := (others=>'0');
	signal dbg_b : std_logic_vector(11 downto 0) := (others=>'0');
	signal dbg_c : std_logic_vector(11 downto 0) := (others=>'0');
	signal dbg_d : std_logic_vector(11 downto 0) := (others=>'0');
	signal dbg_e : std_logic_vector(11 downto 0) := (others=>'0');
	signal dbg_f : std_logic_vector(11 downto 0) := (others=>'0');
	signal dbg_g : std_logic_vector(11 downto 0) := (others=>'0');
	signal dbg_h : std_logic_vector(11 downto 0) := (others=>'0');

--	constant adc_del_time : time := 16100 ps; -- PAR
	constant adc_del_time : time := 0 ps; -- PAR
	
begin

clk_proc : process

	variable no_first_front_v : boolean := false;
--	variable clk_period_v : time := 23622 ps;
	variable clk_period_v : time := 35000 ps;
	variable clk_front_time_v : time := 0 ps;
	variable tick_time_v : time := 0 ps;

	file ch1_file: TEXT open read_mode is ch1_file;
	file ch2_file: TEXT open read_mode is ch2_file;
	file ch3_file: TEXT open read_mode is ch3_file;
	file ch4_file: TEXT open read_mode is ch4_file;
	file ch5_file: TEXT open read_mode is ch5_file;
	file ch6_file: TEXT open read_mode is ch6_file;
	file ch7_file: TEXT open read_mode is ch7_file;
	file ch8_file: TEXT open read_mode is ch8_file;
	
	variable ilin : line;
	variable ch_i : integer := 0;
	variable cha_s, chb_s, chc_s, chd_s, che_s, chf_s, chg_s, chh_s : std_logic_vector(11 downto 0) := (others=>'0');

begin
	wait on CLKP until CLKP'event and CLKP='1';

	if no_first_front_v = false then
		no_first_front_v := true;
		clk_front_time_v := now;
		--report "CLK edge detected at " & time'image(clk_front_time_v);
	else
		clk_period_v     := now - clk_front_time_v;
		tick_time_v      := clk_period_v / 24.01;
		clk_front_time_v := now;

		--report "CLK period is" & time'image(clk_period_v);

		readline(ch1_file, ilin); 
		read(ilin, ch_i);
		cha_s := conv_std_logic_vector(ch_i,12);
		
		readline(ch2_file, ilin); 
		read(ilin, ch_i);
		chb_s := conv_std_logic_vector(ch_i,12);

		readline(ch3_file, ilin); 
		read(ilin, ch_i);
		chc_s := conv_std_logic_vector(ch_i,12);

		readline(ch4_file, ilin); 
		read(ilin, ch_i);
		chd_s := conv_std_logic_vector(ch_i,12);

		readline(ch5_file, ilin); 
		read(ilin, ch_i);
		che_s := conv_std_logic_vector(ch_i,12);

		readline(ch6_file, ilin); 
		read(ilin, ch_i);
		chf_s := conv_std_logic_vector(ch_i,12);

		readline(ch7_file, ilin); 
		read(ilin, ch_i);
		chg_s := conv_std_logic_vector(ch_i,12);

		readline(ch8_file, ilin); 
		read(ilin, ch_i);
		chh_s := conv_std_logic_vector(ch_i,12);

		dbg_a <= cha_s;
		dbg_b <= chb_s;
		dbg_c <= chc_s;
		dbg_d <= chd_s;
		dbg_e <= che_s;
		dbg_f <= chf_s;
		dbg_g <= chg_s;
		dbg_h <= chh_s;
		
		dco <= '0';
		
		-- D11 (MSB)
		fco <= '1';
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';

		wait for tick_time_v;
		dco <= '1';
		wait for tick_time_v;


		-- D10
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '0';
		wait for tick_time_v;
		-- D9
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '1';
		wait for tick_time_v;
		
		-- D8
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '0';
		wait for tick_time_v;
		
		-- D7
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '1';
		wait for tick_time_v;
		
		-- D6
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '0';
		wait for tick_time_v;
		
		-- D5
		fco <= '0';
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '1';
		wait for tick_time_v;
		
		-- D4
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '0';
		wait for tick_time_v;
		
		-- D3
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '1';
		wait for tick_time_v;
		
		-- D2
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '0';
		wait for tick_time_v;
		
		-- D1
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '1';
		wait for tick_time_v;
		
		-- D0
		doa <= cha_s(11);		cha_s := cha_s(10 downto 0) & '0';
		dob <= chb_s(11);		chb_s := chb_s(10 downto 0) & '0';
		doc <= chc_s(11);		chc_s := chc_s(10 downto 0) & '0';
		dod <= chd_s(11);		chd_s := chd_s(10 downto 0) & '0';
		doe <= che_s(11);		che_s := che_s(10 downto 0) & '0';
		dof <= chf_s(11);		chf_s := chf_s(10 downto 0) & '0';
		dog <= chg_s(11);		chg_s := chg_s(10 downto 0) & '0';
		doh <= chh_s(11);		chh_s := chh_s(10 downto 0) & '0';
		
		wait for tick_time_v;
		dco <= '0';
		wait for tick_time_v;
	end if; -- no_first_front_v

end process;

	dcop_s <= transport     dco after adc_del_time;
	dcon_s <= transport not dco after adc_del_time;

	fcop_s <= transport     fco after adc_del_time;
	fcon_s <= transport not fco after adc_del_time;

	doap_s <= transport     doa after adc_del_time;
	doan_s <= transport not doa after adc_del_time;

	dobp_s <= transport     dob after adc_del_time;
	dobn_s <= transport not dob after adc_del_time;

	docp_s <= transport     doc after adc_del_time;
	docn_s <= transport not doc after adc_del_time;

	dodp_s <= transport     dod after adc_del_time;
	dodn_s <= transport not dod after adc_del_time;

	doep_s <= transport     doe after adc_del_time;
	doen_s <= transport not doe after adc_del_time;

	dofp_s <= transport     dof after adc_del_time;
	dofn_s <= transport not dof after adc_del_time;

	dogp_s <= transport     dog after adc_del_time;
	dogn_s <= transport not dog after adc_del_time;

	dohp_s <= transport     doh after adc_del_time;
	dohn_s <= transport not doh after adc_del_time;

	DCOP <= dcop_s;
	DCON <= dcon_s;
	
	FCOP <= fcop_s;
	FCON <= fcon_s;

	DOAP <= doap_s;
	DOAN <= doan_s;

	DOBP <= dobp_s;
	DOBN <= dobn_s;

	DOCP <= docp_s;
	DOCN <= docn_s;

	DODP <= dodp_s;
	DODN <= dodn_s;

	DOEP <= doep_s;
	DOEN <= doen_s;

	DOFP <= dofp_s;
	DOFN <= dofn_s;

	DOGP <= dogp_s;
	DOGN <= dogn_s;

	DOHP <= dohp_s;
	DOHN <= dohn_s;

end;

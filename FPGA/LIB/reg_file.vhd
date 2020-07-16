library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;

library unisim;
use unisim.vcomponents.all;
use work.reg_map.all;

entity reg_file is
	port ( 
		i_clock                : in  std_logic;

		----- registers data

		i_status_reg_set_enable  : in  std_logic;
		i_status_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_status_reg_val         : out std_logic_vector(15 downto 0);

		i_nevt_reg_set_enable  : in  std_logic;
		i_nevt_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_nevt_reg_val         : out std_logic_vector(15 downto 0);

		i_clkcnt_high_reg_set_enable  : in  std_logic;
		i_clkcnt_high_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_clkcnt_high_reg_val         : out std_logic_vector(15 downto 0);

		i_clkcnt_low_reg_set_enable  : in  std_logic;
		i_clkcnt_low_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_clkcnt_low_reg_val         : out std_logic_vector(15 downto 0);


		i_adccnt_reg_set_enable  : in  std_logic;
		i_adccnt_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_adccnt_reg_val         : out std_logic_vector(15 downto 0);

		i_adcsw_reg_set_enable  : in  std_logic;
		i_adcsw_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_adcsw_reg_val         : out std_logic_vector(15 downto 0);

		i_bitshift1_reg_set_enable  : in  std_logic;
		i_bitshift1_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_bitshift1_reg_val         : out std_logic_vector(15 downto 0);

		i_bitshift2_reg_set_enable  : in  std_logic;
		i_bitshift2_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_bitshift2_reg_val         : out std_logic_vector(15 downto 0);

		i_threshold_reg_set_enable  : in  std_logic;
		i_threshold_reg_set_value   : in  std_logic_vector(15 downto 0);
		o_threshold_reg_val         : out std_logic_vector(15 downto 0);

		o_testreg1_val         : out std_logic_vector(15 downto 0);
		o_testreg2_val         : out std_logic_vector(15 downto 0);
		o_testreg3_val         : out std_logic_vector(15 downto 0);
		o_testreg4_val        : out std_logic_vector(15 downto 0);
		o_testreg5_val        : out std_logic_vector(15 downto 0);
		o_testreg6_val        : out std_logic_vector(15 downto 0);
		o_testreg7_val        : out std_logic_vector(15 downto 0);

		i_testreg1_set_enable  : in  std_logic;
		i_testreg1_set_value   : in  std_logic_vector(15 downto 0);
		i_testreg2_set_enable  : in  std_logic;
		i_testreg2_set_value   : in  std_logic_vector(15 downto 0);
		i_testreg3_set_enable  : in  std_logic;
		i_testreg3_set_value   : in  std_logic_vector(15 downto 0);

		i_testreg4_set_enable : in  std_logic;
		i_testreg4_set_value  : in  std_logic_vector(15 downto 0);
		i_testreg5_set_enable : in  std_logic;
		i_testreg5_set_value  : in  std_logic_vector(15 downto 0);
		i_testreg6_set_enable : in  std_logic;
		i_testreg6_set_value  : in  std_logic_vector(15 downto 0);
		i_testreg7_set_enable : in  std_logic;
		i_testreg7_set_value  : in  std_logic_vector(15 downto 0);

		----- ethernet interface 
		eth_reg_we            : in  std_logic;
		eth_reg_num           : in  std_logic_vector (15 downto 0);
		eth_reg_wdata         : in  std_logic_vector (15 downto 0);
		eth_reg_rdata         : out std_logic_vector (15 downto 0));
end reg_file;

architecture Behavioral of reg_file is
	signal eth_status_reg_rdata      : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_nevt_reg_rdata        : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_adcsw_reg_rdata       : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_bitshift1_reg_rdata   : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_bitshift2_reg_rdata   : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_clkcnt_high_reg_rdata : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_clkcnt_low_reg_rdata  : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_adccnt_reg_rdata      : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_threshold_reg_rdata      : std_logic_vector(15 downto 0) := (others => '0');

	signal eth_testreg1_rdata : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_testreg2_rdata : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_testreg3_rdata : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_testreg4_rdata : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_testreg5_rdata : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_testreg6_rdata : std_logic_vector(15 downto 0) := (others => '0');
	signal eth_testreg7_rdata : std_logic_vector(15 downto 0) := (others => '0');
begin


	process(i_clock)
	begin
		if rising_edge(i_clock) then
			eth_reg_rdata  <=   eth_status_reg_rdata or
								eth_adcsw_reg_rdata  or
								eth_clkcnt_high_reg_rdata or
								eth_clkcnt_low_reg_rdata or
								eth_adccnt_reg_rdata or
								eth_bitshift1_reg_rdata or
								eth_bitshift2_reg_rdata or
								eth_threshold_reg_rdata or
								eth_nevt_reg_rdata   or
			                    eth_testreg1_rdata   or
								eth_testreg2_rdata   or
								eth_testreg3_rdata   or 
								eth_testreg4_rdata  or
								eth_testreg5_rdata  or
								eth_testreg6_rdata  or
								eth_testreg7_rdata;
		end if;
	end process;

---- STATUS -------------
	status_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_STATUS_NUMBER,
		REG_WIDTH         => REG_STATUS_WIDTH,
		REG_DEFAULT_VALUE => REG_STATUS_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_status_reg_set_enable,
		i_set_value         => i_status_reg_set_value,

		o_reg_rdata => eth_status_reg_rdata,
		o_reg_value => o_status_reg_val);
-------------------------

---- CLKCNT -------------
	clkcnt_high_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_CLKCNT_HIGH_NUMBER,
		REG_WIDTH         => REG_CLKCNT_HIGH_WIDTH,
		REG_DEFAULT_VALUE => REG_CLKCNT_HIGH_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_clkcnt_high_reg_set_enable,
		i_set_value         => i_clkcnt_high_reg_set_value,

		o_reg_rdata => eth_clkcnt_high_reg_rdata,
		o_reg_value => o_clkcnt_high_reg_val);
-------------------------

---- CLKCNT -------------
	clkcnt_low_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_CLKCNT_LOW_NUMBER,
		REG_WIDTH         => REG_CLKCNT_LOW_WIDTH,
		REG_DEFAULT_VALUE => REG_CLKCNT_LOW_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_clkcnt_low_reg_set_enable,
		i_set_value         => i_clkcnt_low_reg_set_value,

		o_reg_rdata => eth_clkcnt_low_reg_rdata,
		o_reg_value => o_clkcnt_low_reg_val);
-------------------------

---- ADCCNT -------------
	adccnt_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_ADCCNT_NUMBER,
		REG_WIDTH         => REG_ADCCNT_WIDTH,
		REG_DEFAULT_VALUE => REG_ADCCNT_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_adccnt_reg_set_enable,
		i_set_value         => i_adccnt_reg_set_value,

		o_reg_rdata => eth_adccnt_reg_rdata,
		o_reg_value => o_adccnt_reg_val);
-------------------------

---- NEVT -------------
	nevt_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_NEVT_NUMBER,
		REG_WIDTH         => REG_NEVT_WIDTH,
		REG_DEFAULT_VALUE => REG_NEVT_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_nevt_reg_set_enable,
		i_set_value         => i_nevt_reg_set_value,

		o_reg_rdata => eth_nevt_reg_rdata,
		o_reg_value => o_nevt_reg_val);
-------------------------

---- ADCSEL -------------
	adcsw_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_ADCSEL_NUMBER,
		REG_WIDTH         => REG_ADCSEL_WIDTH,
		REG_DEFAULT_VALUE => REG_ADCSEL_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_adcsw_reg_set_enable,
		i_set_value         => i_adcsw_reg_set_value,

		o_reg_rdata => eth_adcsw_reg_rdata,
		o_reg_value => o_adcsw_reg_val);
-------------------------

---- BITSHIFT1 -------------
	bitshift1_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_BITSHIFT1_NUMBER,
		REG_WIDTH         => REG_BITSHIFT1_WIDTH,
		REG_DEFAULT_VALUE => REG_BITSHIFT1_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_bitshift1_reg_set_enable,
		i_set_value         => i_bitshift1_reg_set_value,

		o_reg_rdata => eth_bitshift1_reg_rdata,
		o_reg_value => o_bitshift1_reg_val);
-------------------------

---- BITSHIFT2 -------------
	bitshift2_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_BITSHIFT2_NUMBER,
		REG_WIDTH         => REG_BITSHIFT2_WIDTH,
		REG_DEFAULT_VALUE => REG_BITSHIFT2_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_bitshift2_reg_set_enable,
		i_set_value         => i_bitshift2_reg_set_value,

		o_reg_rdata => eth_bitshift2_reg_rdata,
		o_reg_value => o_bitshift2_reg_val);
-------------------------

---- ADCTHRESH -------------
	threshold_reg : entity work.reg_x
	generic map(
		REG_NUMBER        => REG_ADCTHRESH_NUMBER,
		REG_WIDTH         => REG_ADCTHRESH_WIDTH,
		REG_DEFAULT_VALUE => REG_ADCTHRESH_DEFAULT_VALUE)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_threshold_reg_set_enable,
		i_set_value         => i_threshold_reg_set_value,

		o_reg_rdata => eth_threshold_reg_rdata,
		o_reg_value => o_threshold_reg_val);
-------------------------

----TESTREG1-------------
	test_reg1 : entity work.reg_x
	generic map(
		REG_NUMBER => B"0000_0000_0000_0001",
		REG_WIDTH  => 16,
		REG_DEFAULT_VALUE => B"0000_0000_0000_1111")
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_testreg1_set_enable,
		i_set_value         => i_testreg1_set_value,

		o_reg_rdata => eth_testreg1_rdata,
		o_reg_value => o_testreg1_val);
-------------------------


----TESTREG2-------------
	test_reg2 : entity work.reg_x
	generic map(
		REG_NUMBER => B"0000_0000_0000_0010",
		REG_WIDTH  => 16)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_testreg2_set_enable,
		i_set_value         => i_testreg2_set_value,

		o_reg_rdata => eth_testreg2_rdata,
		o_reg_value => o_testreg2_val);

----TESTREG3------------
	test_reg3 : entity work.reg_x
	generic map(
		REG_NUMBER => B"0000_0000_0000_0011",
		REG_WIDTH  => 16)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_testreg3_set_enable,
		i_set_value         => i_testreg3_set_value,

		o_reg_rdata => eth_testreg3_rdata,
		o_reg_value => o_testreg3_val);
-------------------------

----COUNTER1------------
	test_reg4 : entity work.reg_x
	generic map(
		REG_NUMBER => B"0000_0000_0000_0100",
		REG_WIDTH  => 16,
		REG_DEFAULT_VALUE => B"0000_0000_0000_0100")
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_testreg4_set_enable,
		i_set_value         => i_testreg4_set_value,

		o_reg_rdata => eth_testreg4_rdata,
		o_reg_value => o_testreg4_val);
-------------------------

----COUNTER2------------
	test_reg5 : entity work.reg_x
	generic map(
		REG_NUMBER => B"0000_0000_0000_0101",
		REG_WIDTH  => 16,
		REG_DEFAULT_VALUE => B"0000_0000_0000_0101")
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_testreg5_set_enable,
		i_set_value         => i_testreg5_set_value,

		o_reg_rdata => eth_testreg5_rdata,
		o_reg_value => o_testreg5_val);
-------------------------

----COUNTER3------------
	test_reg6 : entity work.reg_x
	generic map(
		REG_NUMBER => B"0000_0000_0000_0110",
		REG_WIDTH  => 16,
		REG_DEFAULT_VALUE => B"0000_0000_0000_0110")
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_testreg6_set_enable,
		i_set_value         => i_testreg6_set_value,

		o_reg_rdata => eth_testreg6_rdata,
		o_reg_value => o_testreg6_val);
-------------------------

----COUNTER4------------
	test_reg7 : entity work.reg_x
	generic map(
		REG_NUMBER => B"0000_0000_0000_0111",
		REG_WIDTH  => 16)
	port map(
		i_clock     => i_clock,
		i_reg_we    => eth_reg_we,
		i_reg_num   => eth_reg_num,
		i_reg_wdata => eth_reg_wdata,
		
		i_direct_set_enable => i_testreg7_set_enable,
		i_set_value         => i_testreg7_set_value,

		o_reg_rdata => eth_testreg7_rdata,
		o_reg_value => o_testreg7_val);
-------------------------

end Behavioral;


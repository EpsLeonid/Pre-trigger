library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.reg_map.all;
use work.types.all;

entity reg_file_m is
	port ( 
		i_clock, reset       : in  std_logic;

		-- enable accessing of corresponding registers directly
		i_direct_set_enable  : in  std_logic_vector(NUMBER_OF_REGISTERS-1 downto 0);
		i_direct_set_values  : in  reg_array_t;

		-- output values of the registers
		o_reg_data           : out reg_array_t;
		
		----- ethernet interface 
		eth_reg_we           : in  std_logic;
		eth_reg_num          : in  std_logic_vector (15 downto 0);
		eth_reg_wdata        : in  std_logic_vector (15 downto 0);
		eth_reg_rdata        : out std_logic_vector (15 downto 0) );
end reg_file_m;

architecture behavorial of reg_file_m is
	-- default values to be initialized 
	signal s_eth_reg_rdata : std_logic_vector (15 downto 0) := (others => '0');
	signal s_eth_reg_we    : std_logic := '0';
	signal s_eth_reg_wdata : std_logic_vector (15 downto 0) := (others => '0');
	signal s_en_reg        : std_logic_vector(NUMBER_OF_REGISTERS downto 0) := (others => '0');

	-- current register values
	signal s_reg_data      : reg_array_t := (REG_STATUS_INDEX        => REG_STATUS_DEFAULT_VALUE,
											 REG_NEVT_INDEX          => REG_NEVT_DEFAULT_VALUE,
											 REG_CLKCNT_HIGH_INDEX   => REG_CLKCNT_HIGH_DEFAULT_VALUE,
											 REG_CLKCNT_LOW_INDEX    => REG_CLKCNT_LOW_DEFAULT_VALUE,
											 REG_ADCCNT_INDEX        => REG_ADCCNT_DEFAULT_VALUE,
											 REG_ADCSEL_INDEX        => REG_ADCSEL_DEFAULT_VALUE,
											 REG_BITSHIFT1_INDEX     => REG_BITSHIFT1_DEFAULT_VALUE,
											 REG_BITSHIFT2_INDEX     => REG_BITSHIFT2_DEFAULT_VALUE,
											 REG_INFO_INDEX          => REG_INFO_DEFAULT_VALUE,
											 REG_ADCTHRESH_INDEX     => REG_ADCTHRESH_DEFAULT_VALUE,
											 REG_ADCTHRESH_1_INDEX   => REG_ADCTHRESH_1_DEFAULT_VALUE,
											 REG_ADCTHRESH_2_INDEX   => REG_ADCTHRESH_2_DEFAULT_VALUE,
											 REG_ADCTHRESH_3_INDEX   => REG_ADCTHRESH_3_DEFAULT_VALUE,
											 REG_ADCTHRESH_4_INDEX   => REG_ADCTHRESH_4_DEFAULT_VALUE,
											 REG_ADCTHRESH_5_INDEX   => REG_ADCTHRESH_5_DEFAULT_VALUE,
											 REG_ADCTHRESH_6_INDEX   => REG_ADCTHRESH_6_DEFAULT_VALUE,
											 REG_ADCTHRESH_7_INDEX   => REG_ADCTHRESH_7_DEFAULT_VALUE,
											 REG_ADCTHRESH_8_INDEX   => REG_ADCTHRESH_8_DEFAULT_VALUE,
											 REG_ADCTHRESH_9_INDEX   => REG_ADCTHRESH_9_DEFAULT_VALUE,
											 REG_ADCTHRESH_10_INDEX  => REG_ADCTHRESH_10_DEFAULT_VALUE,
											 REG_ADCTHRESH_11_INDEX  => REG_ADCTHRESH_11_DEFAULT_VALUE,
											 REG_ADCTHRESH_12_INDEX  => REG_ADCTHRESH_12_DEFAULT_VALUE,
											 REG_ADCTHRESH_13_INDEX  => REG_ADCTHRESH_13_DEFAULT_VALUE,
											 REG_ADCTHRESH_14_INDEX  => REG_ADCTHRESH_14_DEFAULT_VALUE,
											 REG_ADCTHRESH_15_INDEX  => REG_ADCTHRESH_15_DEFAULT_VALUE,
											 REG_ADCTHRESH_16_INDEX  => REG_ADCTHRESH_16_DEFAULT_VALUE,
											 REG_ADCTHRESH_17_INDEX  => REG_ADCTHRESH_17_DEFAULT_VALUE,
											 REG_ADCTHRESH_18_INDEX  => REG_ADCTHRESH_18_DEFAULT_VALUE,
											 REG_ADCTHRESH_19_INDEX  => REG_ADCTHRESH_19_DEFAULT_VALUE,
											 REG_ADCTHRESH_20_INDEX  => REG_ADCTHRESH_20_DEFAULT_VALUE,
											 REG_ADCTHRESH_21_INDEX  => REG_ADCTHRESH_21_DEFAULT_VALUE,
											 REG_ADCTHRESH_22_INDEX  => REG_ADCTHRESH_22_DEFAULT_VALUE,
											 REG_ADCTHRESH_23_INDEX  => REG_ADCTHRESH_23_DEFAULT_VALUE,
											 REG_ADCTHRESH_24_INDEX  => REG_ADCTHRESH_24_DEFAULT_VALUE,
											 REG_ADCTHRESH_25_INDEX  => REG_ADCTHRESH_25_DEFAULT_VALUE,
											 REG_ADCTHRESH_26_INDEX  => REG_ADCTHRESH_26_DEFAULT_VALUE,
											 REG_ADCTHRESH_27_INDEX  => REG_ADCTHRESH_27_DEFAULT_VALUE,
											 REG_ADCTHRESH_28_INDEX  => REG_ADCTHRESH_28_DEFAULT_VALUE,
											 REG_ADCTHRESH_29_INDEX  => REG_ADCTHRESH_29_DEFAULT_VALUE,
											 REG_ADCTHRESH_30_INDEX  => REG_ADCTHRESH_30_DEFAULT_VALUE,
											 REG_ADCTHRESH_31_INDEX  => REG_ADCTHRESH_31_DEFAULT_VALUE,
											 REG_ADCTHRESH_32_INDEX  => REG_ADCTHRESH_32_DEFAULT_VALUE,
											 REG_ADCSTOP_INDEX       => REG_ADCSTOP_DEFAULT_VALUE,
											 others => (others => '0'));
	-- defaults to be set after reset
	signal s_reg_defaults  : reg_array_t := (REG_STATUS_INDEX        => REG_STATUS_DEFAULT_VALUE,
											 REG_NEVT_INDEX          => REG_NEVT_DEFAULT_VALUE,
											 REG_CLKCNT_HIGH_INDEX   => REG_CLKCNT_HIGH_DEFAULT_VALUE,
											 REG_CLKCNT_LOW_INDEX    => REG_CLKCNT_LOW_DEFAULT_VALUE,
											 REG_ADCCNT_INDEX        => REG_ADCCNT_DEFAULT_VALUE,
											 REG_ADCSEL_INDEX        => REG_ADCSEL_DEFAULT_VALUE,
											 REG_BITSHIFT1_INDEX     => REG_BITSHIFT1_DEFAULT_VALUE,
											 REG_BITSHIFT2_INDEX     => REG_BITSHIFT2_DEFAULT_VALUE,
											 REG_INFO_INDEX          => REG_INFO_DEFAULT_VALUE,
											 REG_ADCTHRESH_INDEX     => REG_ADCTHRESH_DEFAULT_VALUE,
											 REG_ADCTHRESH_1_INDEX   => REG_ADCTHRESH_1_DEFAULT_VALUE,
											 REG_ADCTHRESH_2_INDEX   => REG_ADCTHRESH_2_DEFAULT_VALUE,
											 REG_ADCTHRESH_3_INDEX   => REG_ADCTHRESH_3_DEFAULT_VALUE,
											 REG_ADCTHRESH_4_INDEX   => REG_ADCTHRESH_4_DEFAULT_VALUE,
											 REG_ADCTHRESH_5_INDEX   => REG_ADCTHRESH_5_DEFAULT_VALUE,
											 REG_ADCTHRESH_6_INDEX   => REG_ADCTHRESH_6_DEFAULT_VALUE,
											 REG_ADCTHRESH_7_INDEX   => REG_ADCTHRESH_7_DEFAULT_VALUE,
											 REG_ADCTHRESH_8_INDEX   => REG_ADCTHRESH_8_DEFAULT_VALUE,
											 REG_ADCTHRESH_9_INDEX   => REG_ADCTHRESH_9_DEFAULT_VALUE,
											 REG_ADCTHRESH_10_INDEX  => REG_ADCTHRESH_10_DEFAULT_VALUE,
											 REG_ADCTHRESH_11_INDEX  => REG_ADCTHRESH_11_DEFAULT_VALUE,
											 REG_ADCTHRESH_12_INDEX  => REG_ADCTHRESH_12_DEFAULT_VALUE,
											 REG_ADCTHRESH_13_INDEX  => REG_ADCTHRESH_13_DEFAULT_VALUE,
											 REG_ADCTHRESH_14_INDEX  => REG_ADCTHRESH_14_DEFAULT_VALUE,
											 REG_ADCTHRESH_15_INDEX  => REG_ADCTHRESH_15_DEFAULT_VALUE,
											 REG_ADCTHRESH_16_INDEX  => REG_ADCTHRESH_16_DEFAULT_VALUE,
											 REG_ADCTHRESH_17_INDEX  => REG_ADCTHRESH_17_DEFAULT_VALUE,
											 REG_ADCTHRESH_18_INDEX  => REG_ADCTHRESH_18_DEFAULT_VALUE,
											 REG_ADCTHRESH_19_INDEX  => REG_ADCTHRESH_19_DEFAULT_VALUE,
											 REG_ADCTHRESH_20_INDEX  => REG_ADCTHRESH_20_DEFAULT_VALUE,
											 REG_ADCTHRESH_21_INDEX  => REG_ADCTHRESH_21_DEFAULT_VALUE,
											 REG_ADCTHRESH_22_INDEX  => REG_ADCTHRESH_22_DEFAULT_VALUE,
											 REG_ADCTHRESH_23_INDEX  => REG_ADCTHRESH_23_DEFAULT_VALUE,
											 REG_ADCTHRESH_24_INDEX  => REG_ADCTHRESH_24_DEFAULT_VALUE,
											 REG_ADCTHRESH_25_INDEX  => REG_ADCTHRESH_25_DEFAULT_VALUE,
											 REG_ADCTHRESH_26_INDEX  => REG_ADCTHRESH_26_DEFAULT_VALUE,
											 REG_ADCTHRESH_27_INDEX  => REG_ADCTHRESH_27_DEFAULT_VALUE,
											 REG_ADCTHRESH_28_INDEX  => REG_ADCTHRESH_28_DEFAULT_VALUE,
											 REG_ADCTHRESH_29_INDEX  => REG_ADCTHRESH_29_DEFAULT_VALUE,
											 REG_ADCTHRESH_30_INDEX  => REG_ADCTHRESH_30_DEFAULT_VALUE,
											 REG_ADCTHRESH_31_INDEX  => REG_ADCTHRESH_31_DEFAULT_VALUE,
											 REG_ADCTHRESH_32_INDEX  => REG_ADCTHRESH_32_DEFAULT_VALUE,
											 REG_ADCSTOP_INDEX       => REG_ADCSTOP_DEFAULT_VALUE,
											 others => (others => '0'));
	-- next registers state
	signal s_reg_data_eth  : reg_array_t := (others => (others => '0'));
	signal s_reg_data_dir  : reg_array_t := (others => (others => '0'));
begin

	-- process clock
	CLOCK : process(i_clock, reset)
	begin
		
		-- set default values for registers when reset rised
		if reset = '1' then
			s_reg_data     <= s_reg_defaults;
		
		elsif rising_edge(i_clock) then
			s_eth_reg_we   <= eth_reg_we;
			s_reg_data_eth <= s_reg_data;
				-- acess register index by given register number through eth interface
			case eth_reg_num is
				when REG_STATUS_NUMBER      =>
					s_reg_data_eth(REG_STATUS_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_STATUS_INDEX);

				-- counters
				when REG_NEVT_NUMBER        =>
					s_reg_data_eth(REG_NEVT_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_NEVT_INDEX);
				
				when REG_CLKCNT_LOW_NUMBER =>
					s_reg_data_eth(REG_CLKCNT_LOW_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_CLKCNT_LOW_INDEX);
				
				when REG_CLKCNT_HIGH_NUMBER => 
					s_reg_data_eth(REG_CLKCNT_HIGH_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_CLKCNT_HIGH_INDEX);

				when REG_ADCCNT_NUMBER      => 
					s_reg_data_eth(REG_ADCCNT_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCCNT_INDEX);
				
				-- select ADC buffer
				when REG_ADCSEL_NUMBER      => 
					s_reg_data_eth(REG_ADCSEL_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCSEL_INDEX);

				when REG_BITSHIFT1_NUMBER   => 
					s_reg_data_eth(REG_BITSHIFT1_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_BITSHIFT1_INDEX);

				when REG_BITSHIFT2_NUMBER   => 
					s_reg_data_eth(REG_BITSHIFT2_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_BITSHIFT2_INDEX);
				
				when REG_INFO_NUMBER   => 
					s_reg_data_eth(REG_INFO_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_INFO_INDEX);

				-- Test registers for debugging
				when REG_TESTREG0_NUMBER   => 
					s_reg_data_eth(REG_TESTREG0_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG0_INDEX);

				when REG_TESTREG1_NUMBER   => 
					s_reg_data_eth(REG_TESTREG1_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG1_INDEX);

				when REG_TESTREG2_NUMBER   => 
					s_reg_data_eth(REG_TESTREG2_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG2_INDEX);

				when REG_TESTREG3_NUMBER   => 
					s_reg_data_eth(REG_TESTREG3_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG3_INDEX);

				when REG_TESTREG4_NUMBER   => 
					s_reg_data_eth(REG_TESTREG4_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG4_INDEX);

				when REG_TESTREG5_NUMBER   => 
					s_reg_data_eth(REG_TESTREG5_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG5_INDEX);

				when REG_TESTREG6_NUMBER   => 
					s_reg_data_eth(REG_TESTREG6_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG6_INDEX);

				when REG_TESTREG7_NUMBER   => 
					s_reg_data_eth(REG_TESTREG7_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG7_INDEX);

				when REG_TESTREG8_NUMBER   => 
					s_reg_data_eth(REG_TESTREG8_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG8_INDEX);

				when REG_TESTREG9_NUMBER   => 
					s_reg_data_eth(REG_TESTREG9_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_TESTREG9_INDEX);

				-- ADC Thresholds	
				when REG_ADCTHRESH_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_INDEX);

				when REG_ADCTHRESH_1_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_1_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_1_INDEX);

				when REG_ADCTHRESH_2_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_2_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_2_INDEX);

				when REG_ADCTHRESH_3_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_3_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_3_INDEX);

				when REG_ADCTHRESH_4_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_4_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_4_INDEX);

				when REG_ADCTHRESH_5_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_5_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_5_INDEX);

				when REG_ADCTHRESH_6_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_6_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_6_INDEX);

				when REG_ADCTHRESH_7_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_7_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_7_INDEX);

				when REG_ADCTHRESH_8_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_8_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_8_INDEX);

				when REG_ADCTHRESH_9_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_9_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_9_INDEX);

				when REG_ADCTHRESH_10_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_10_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_10_INDEX);

				when REG_ADCTHRESH_11_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_11_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_11_INDEX);

				when REG_ADCTHRESH_12_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_12_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_12_INDEX);

				when REG_ADCTHRESH_13_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_13_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_13_INDEX);

				when REG_ADCTHRESH_14_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_14_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_14_INDEX);

				when REG_ADCTHRESH_15_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_15_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_15_INDEX);

				when REG_ADCTHRESH_16_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_16_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_16_INDEX);

				when REG_ADCTHRESH_17_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_17_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_17_INDEX);

				when REG_ADCTHRESH_18_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_18_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_18_INDEX);

				when REG_ADCTHRESH_19_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_19_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_19_INDEX);

				when REG_ADCTHRESH_20_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_20_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_20_INDEX);

				when REG_ADCTHRESH_21_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_21_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_21_INDEX);

				when REG_ADCTHRESH_22_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_22_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_22_INDEX);

				when REG_ADCTHRESH_23_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_23_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_23_INDEX);

				when REG_ADCTHRESH_24_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_24_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_24_INDEX);

				when REG_ADCTHRESH_25_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_25_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_25_INDEX);

				when REG_ADCTHRESH_26_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_26_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_26_INDEX);

				when REG_ADCTHRESH_27_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_27_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_27_INDEX);

				when REG_ADCTHRESH_28_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_28_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_28_INDEX);

				when REG_ADCTHRESH_29_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_29_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_29_INDEX);

				when REG_ADCTHRESH_30_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_30_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_30_INDEX);

				when REG_ADCTHRESH_31_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_31_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_31_INDEX);

				when REG_ADCTHRESH_32_NUMBER   => 
					s_reg_data_eth(REG_ADCTHRESH_32_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCTHRESH_32_INDEX);

				when REG_ADCSTOP_NUMBER        => 
					s_reg_data_eth(REG_ADCSTOP_INDEX) <= eth_reg_wdata;
					s_eth_reg_rdata <= s_reg_data(REG_ADCSTOP_INDEX);

				when others => 
					s_reg_data_eth  <= s_reg_data_eth;
					s_eth_reg_rdata <= (others => '0');
			end case;
			
			if s_eth_reg_we = '1' then
				s_reg_data <= s_reg_data_eth;
			else
				-- if the register is not accessed by the eth interface,
				-- keep its value or change it directly if this operation is enabled
				-- by i_direct_set_enable vector
				s_reg_data <= s_reg_data_dir;
			end if;
		
			eth_reg_rdata  <= s_eth_reg_rdata;
			o_reg_data     <= s_reg_data;
		end if;
	end process CLOCK;

	-- change next registers value if direct change of register is enabled
	REG_SET_GEN : for i_REG in 0 to NUMBER_OF_REGISTERS - 1 generate
		s_reg_data_dir(i_REG) <= i_direct_set_values(i_REG) when i_direct_set_enable(i_REG) = '1' 
			else s_reg_data(i_REG); 
	end generate REG_SET_GEN;

end behavorial;



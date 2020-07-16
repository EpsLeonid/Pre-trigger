library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

--entity adc_deser_8ch_12bits is
--port(
	--clock : in std_logic;
	
	--bitslip_reset : in std_logic;

	--clock_adc : out std_logic;

	--data_fco : out std_logic_vector(11 downto 0);
	--o_data  : out stdlv_array_8x12_t;

	--data_we : out std_logic;
	
	---- PINS
	--SDATAP : in std_logic_vector(8 downto 1);
	--SDATAN : in std_logic_vector(8 downto 1);

	--DCOP : in std_logic;
	--DCON : in std_logic;
	
	--FCOP : in std_logic;
	--FCON : in std_logic);

--end adc_deser_8ch_12bits;

architecture simple_arch of adc_deser_8ch_12bits is
	signal s_frame_r      : std_logic_vector(11 downto 0) := (others => '0');
	signal s_frame        : std_logic_vector(11 downto 0) := (others => '0');
                         
	signal fco_ib         : std_logic := '0';
	signal dco_ib         : std_logic := '0';
	signal rx_data_in     : std_logic_vector(7 downto 0) := (others => '0');
	signal s_data_1       : stdlv_array_8x12_t  := (others => (others=>'0')); -- starts from MSB
	signal s_data_1_r     : stdlv_array_8x12_t  := (others => (others=>'0')); -- starts from MSB
	signal s_data_2       : stdlv_array_8x12_t  := (others => (others=>'0')); -- starts from MSB-1
	signal s_data_2_r     : stdlv_array_8x12_t  := (others => (others=>'0')); -- starts from MSB-1
	signal s_data_2_dr    : stdlv_array_8x12_t  := (others => (others=>'0')); -- starts from MSB-1
	signal s_data         : stdlv_array_8x12_t := (others => (others=>'0'));
	signal s_data_r       : stdlv_array_8x12_t := (others => (others=>'0'));
	
	signal s_data_fco     : std_logic_vector(11 downto 0) := (others => '0');
	signal s_data_fco_1   : std_logic_vector(5 downto 0) := (others => '0');
	signal s_data_fco_1_r : std_logic_vector(5 downto 0) := (others => '0');
	signal s_data_fco_2   : std_logic_vector(5 downto 0) := (others => '0');
	signal s_data_fco_2_r : std_logic_vector(5 downto 0) := (others => '0');
	signal s_data_we      : std_logic := '0';

	signal s_match        : std_logic := '0';
	signal s_cnt          : std_logic_vector(1 downto 0) := (others => '0');
begin


	-- imput buffer for data clock
	dco_ibufgds : IBUFGDS
	generic map( IBUF_LOW_PWR => FALSE, DIFF_TERM => TRUE )
	port map   ( O  => dco_ib, I  => DCOP, IB => DCON );


	-- input buffer for frame clock
	iob_data_in : IBUFGDS 
	generic map( IBUF_LOW_PWR => FALSE, DIFF_TERM => TRUE)
	port map   ( I => FCOP, IB => FCON, O => fco_ib );

	-- deserialize frame clock data 
	FRAME_CLOCK: process(dco_ib, fco_ib)
	begin
		if rising_edge(dco_ib) then
			s_data_fco_1   <= s_data_fco_1(4 downto 0) & fco_ib;
			s_data_fco_1_r <= s_data_fco_1;
		elsif falling_edge(dco_ib) then
			s_data_fco_2    <= s_data_fco_2(4 downto 0) & fco_ib;
			s_data_fco_2_r  <= s_data_fco_2;
		end if;
	end process;

	process(dco_ib)
	begin
		if rising_edge(dco_ib) then
			s_match <= '0';
			s_data_we <= '0';
			if s_data_fco_1 = B"111000" then
				s_match <= '1';
			end if;
			if s_match = '1' then
				s_data_we <= '1';
			end if;
		end if;
	end process;

	clock_adc <= dco_ib;
	data_we   <= s_data_we;
	data_fco  <= s_data_fco;
	o_data    <= s_data;

	-- input buffer for data
	ADC_GEN_LOOP: for i_ADC in 1 to 8 generate

		iob_data_in : IBUFGDS 
		generic map( IBUF_LOW_PWR => FALSE, DIFF_TERM => TRUE )
		port map   (
			I               => SDATAP(i_ADC),
			IB              => SDATAN(i_ADC),
			O               => rx_data_in(i_ADC-1) );

		-- capture data 
		process(dco_ib, rx_data_in(i_ADC-1))
		begin
			if rising_edge(dco_ib) then
				s_data_1(i_ADC)   <= s_data_1(i_ADC)(10 downto 0) & rx_data_in(i_ADC-1);
				s_data_1_r(i_ADC) <= s_data_1(i_ADC);
				if s_match = '1' then
					if shift_1 = X"0" then
						s_data(i_ADC)(11) <= s_data_1_r(i_ADC)(5);
						s_data(i_ADC)(9)  <= s_data_1_r(i_ADC)(4);
						s_data(i_ADC)(7)  <= s_data_1_r(i_ADC)(3);
						s_data(i_ADC)(5)  <= s_data_1_r(i_ADC)(2);
						s_data(i_ADC)(3)  <= s_data_1_r(i_ADC)(1);
						s_data(i_ADC)(1)  <= s_data_1_r(i_ADC)(0);
					elsif shift_1 = X"1" then
						s_data(i_ADC)(11) <= s_data_1_r(i_ADC)(6);
						s_data(i_ADC)(9)  <= s_data_1_r(i_ADC)(5);
						s_data(i_ADC)(7)  <= s_data_1_r(i_ADC)(4);
						s_data(i_ADC)(5)  <= s_data_1_r(i_ADC)(3);
						s_data(i_ADC)(3)  <= s_data_1_r(i_ADC)(2);
						s_data(i_ADC)(1)  <= s_data_1_r(i_ADC)(1);
					elsif shift_1 = X"2" then
						s_data(i_ADC)(11) <= s_data_1_r(i_ADC)(7);
						s_data(i_ADC)(9)  <= s_data_1_r(i_ADC)(6);
						s_data(i_ADC)(7)  <= s_data_1_r(i_ADC)(5);
						s_data(i_ADC)(5)  <= s_data_1_r(i_ADC)(4);
						s_data(i_ADC)(3)  <= s_data_1_r(i_ADC)(3);
						s_data(i_ADC)(1)  <= s_data_1_r(i_ADC)(2);
					elsif shift_1 = X"3" then
						s_data(i_ADC)(11) <= s_data_1_r(i_ADC)(8);
						s_data(i_ADC)(9)  <= s_data_1_r(i_ADC)(7);
						s_data(i_ADC)(7)  <= s_data_1_r(i_ADC)(6);
						s_data(i_ADC)(5)  <= s_data_1_r(i_ADC)(5);
						s_data(i_ADC)(3)  <= s_data_1_r(i_ADC)(4);
						s_data(i_ADC)(1)  <= s_data_1_r(i_ADC)(3);
					elsif shift_1 = X"4" then
						s_data(i_ADC)(11) <= s_data_1_r(i_ADC)(9);
						s_data(i_ADC)(9)  <= s_data_1_r(i_ADC)(8);
						s_data(i_ADC)(7)  <= s_data_1_r(i_ADC)(7);
						s_data(i_ADC)(5)  <= s_data_1_r(i_ADC)(6);
						s_data(i_ADC)(3)  <= s_data_1_r(i_ADC)(5);
						s_data(i_ADC)(1)  <= s_data_1_r(i_ADC)(4);
					else
						s_data(i_ADC)(11) <= s_data_1_r(i_ADC)(5);
						s_data(i_ADC)(9)  <= s_data_1_r(i_ADC)(4);
						s_data(i_ADC)(7)  <= s_data_1_r(i_ADC)(3);
						s_data(i_ADC)(5)  <= s_data_1_r(i_ADC)(2);
						s_data(i_ADC)(3)  <= s_data_1_r(i_ADC)(1);
						s_data(i_ADC)(1)  <= s_data_1_r(i_ADC)(0);
					end if;
					
					if shift_2 = X"0" then
						s_data(i_ADC)(10) <= s_data_2_r(i_ADC)(5);
						s_data(i_ADC)(8)  <= s_data_2_r(i_ADC)(4);
						s_data(i_ADC)(6)  <= s_data_2_r(i_ADC)(3);
						s_data(i_ADC)(4)  <= s_data_2_r(i_ADC)(2);
						s_data(i_ADC)(2)  <= s_data_2_r(i_ADC)(1);
						s_data(i_ADC)(0)  <= s_data_2_r(i_ADC)(0);
					elsif shift_2 = X"1" then
						s_data(i_ADC)(10) <= s_data_2_r(i_ADC)(6);
						s_data(i_ADC)(8)  <= s_data_2_r(i_ADC)(5);
						s_data(i_ADC)(6)  <= s_data_2_r(i_ADC)(4);
						s_data(i_ADC)(4)  <= s_data_2_r(i_ADC)(3);
						s_data(i_ADC)(2)  <= s_data_2_r(i_ADC)(2);
						s_data(i_ADC)(0)  <= s_data_2_r(i_ADC)(1);
					elsif shift_2 = X"2" then
						s_data(i_ADC)(10) <= s_data_2_r(i_ADC)(7);
						s_data(i_ADC)(8)  <= s_data_2_r(i_ADC)(6);
						s_data(i_ADC)(6)  <= s_data_2_r(i_ADC)(5);
						s_data(i_ADC)(4)  <= s_data_2_r(i_ADC)(4);
						s_data(i_ADC)(2)  <= s_data_2_r(i_ADC)(3);
						s_data(i_ADC)(0)  <= s_data_2_r(i_ADC)(2);
					elsif shift_2 = X"3" then
						s_data(i_ADC)(10) <= s_data_2_r(i_ADC)(8);
						s_data(i_ADC)(8)  <= s_data_2_r(i_ADC)(7);
						s_data(i_ADC)(6)  <= s_data_2_r(i_ADC)(6);
						s_data(i_ADC)(4)  <= s_data_2_r(i_ADC)(5);
						s_data(i_ADC)(2)  <= s_data_2_r(i_ADC)(4);
						s_data(i_ADC)(0)  <= s_data_2_r(i_ADC)(3);
					elsif shift_2 = X"4" then
						s_data(i_ADC)(10) <= s_data_2_r(i_ADC)(9);
						s_data(i_ADC)(8)  <= s_data_2_r(i_ADC)(8);
						s_data(i_ADC)(6)  <= s_data_2_r(i_ADC)(7);
						s_data(i_ADC)(4)  <= s_data_2_r(i_ADC)(6);
						s_data(i_ADC)(2)  <= s_data_2_r(i_ADC)(5);
						s_data(i_ADC)(0)  <= s_data_2_r(i_ADC)(4);
					else
						s_data(i_ADC)(10) <= s_data_2_r(i_ADC)(5);
						s_data(i_ADC)(8)  <= s_data_2_r(i_ADC)(4);
						s_data(i_ADC)(6)  <= s_data_2_r(i_ADC)(3);
						s_data(i_ADC)(4)  <= s_data_2_r(i_ADC)(2);
						s_data(i_ADC)(2)  <= s_data_2_r(i_ADC)(1);
						s_data(i_ADC)(0)  <= s_data_2_r(i_ADC)(0);
					end if;
				end if;
			end if;
		end process;

		process(dco_ib)
		begin
			if falling_edge(dco_ib) then
				s_data_2(i_ADC)    <= s_data_2(i_ADC)(10 downto 0) & rx_data_in(i_ADC-1);
				s_data_2_r(i_ADC)  <= s_data_2(i_ADC);
				s_data_2_dr(i_ADC) <= s_data_2_r(i_ADC);
			end if;
		end process;

	end generate ADC_GEN_LOOP;
end simple_arch; 



architecture iddr2_arch of adc_deser_8ch_12bits is
	signal s_frame_r      : std_logic_vector(11 downto 0) := (others => '0');
	signal s_frame        : std_logic_vector(11 downto 0) := (others => '0');
                         
	signal fco_ib         : std_logic := '0';
	signal dco_ib         : std_logic := '0';
	signal dco_ib_i       : std_logic := '0';
	signal dco_div2       : std_logic := '0';
	signal cnt_2bit       : std_logic_vector(1 downto 0) := (others => '0');
	signal rx_data_in     : std_logic_vector(7 downto 0) := (others => '0');
	signal s_data         : stdlv_array_8x12_t := (others => (others=>'0'));
	signal s_data_r       : stdlv_array_8x12_t := (others => (others=>'0'));

	signal s_ddr2_data_q  : stdlv_array_8x2_t  := (others => (others=>'0'));
	signal s_ddr2_frame_q : std_logic_vector(1 downto 0) := (others=>'0');
	
	signal s_data_fco     : std_logic_vector(11 downto 0) := (others => '0');
	signal s_data_fco_r   : std_logic_vector(11 downto 0) := (others => '0');
	signal s_data_we      : std_logic := '0';

	signal s_match        : std_logic := '0';
	signal s_cnt          : std_logic_vector(1 downto 0) := (others => '0');
begin


	-- imput buffer for data clock
	dco_ibufgds : IBUFGDS
	generic map( IBUF_LOW_PWR => FALSE, DIFF_TERM => TRUE )
	port map   ( O  => dco_ib, I  => DCOP, IB => DCON );
	dco_ib_i <= not dco_ib;

	-- input buffer for frame clock
	iob_data_in : IBUFGDS 
	generic map( IBUF_LOW_PWR => FALSE, DIFF_TERM => TRUE)
	port map   ( I => FCOP, IB => FCON, O => fco_ib );

	IDDR2_FCO   : IDDR2
	generic map(
		DDR_ALIGNMENT => "C1", -- Sets output alignment to "NONE", "C0", "C1" 
		INIT_Q0 => '0',   -- Sets initial state of the Q0 output to '0' or '1'
		INIT_Q1 => '0',   -- Sets initial state of the Q1 output to '0' or '1'
		SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
	port map (
		Q0 => s_ddr2_frame_q(0),         -- 1-bit output captured with C0 clock
		Q1 => s_ddr2_frame_q(1),         -- 1-bit output captured with C1 clock
		C0 => dco_ib,     -- 1-bit clock input
		C1 => dco_ib_i,  -- 1-bit clock input
		CE => '1',        -- 1-bit clock enable input
		D  => fco_ib,     -- 1-bit data input 
		R  => open,        -- 1-bit reset input
		S  => open);       -- 1-bit set input

	-- input buffers for ADC data -----------------------------
	ADC_IOBUF_LOOP: for i_ADC in 1 to 8 generate

		iob_data_in : IBUFGDS 
		generic map( IBUF_LOW_PWR => FALSE, DIFF_TERM => TRUE )
		port map   (
			I               => SDATAP(i_ADC),
			IB              => SDATAN(i_ADC),
			O               => rx_data_in(i_ADC-1) );


		IDDR2_data : IDDR2
		generic map(
			DDR_ALIGNMENT => "C1", -- Sets output alignment to "NONE", "C0", "C1" 
			INIT_Q0 => '0',   -- Sets initial state of the Q0 output to '0' or '1'
			INIT_Q1 => '0',   -- Sets initial state of the Q1 output to '0' or '1'
			SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
		port map (
			Q0 => s_ddr2_data_q(i_ADC)(0),         -- 1-bit output captured with C0 clock
			Q1 => s_ddr2_data_q(i_ADC)(1),         -- 1-bit output captured with C1 clock
			C0 => dco_ib,     -- 1-bit clock input
			C1 => dco_ib_i,   -- 1-bit clock input
			CE => '1',        -- 1-bit clock enable input
			D  => rx_data_in(i_ADC-1),           -- 1-bit data input 
			R  => open,        -- 1-bit reset input
			S  => open);       -- 1-bit set input

	end generate ADC_IOBUF_LOOP;
	-----------------------------------------------------------


	-- deserialize frame clock data 
	FRAME_CLOCK: process(dco_ib, fco_ib)
	begin
		if rising_edge(dco_ib) then
			s_data_fco   <= s_data_fco(9 downto 0) & s_ddr2_frame_q;
			s_data_fco_r <= s_data_fco;
		end if;
	end process;

	-- deserialize ADC data
	ADC_GEN_LOOP: for i_ADC in 1 to 8 generate

		process(dco_ib)
		begin
			if rising_edge(dco_ib) then
				s_data(i_ADC)   <= s_data(i_ADC)(9 downto 0) & s_ddr2_data_q(i_ADC);
				s_data_r(i_ADC) <= s_data(i_ADC);
			end if;
		end process;
	end generate ADC_GEN_LOOP;

	-- compare frame clock data to pattern 111111000000 = X"FC0"
	-- if so, direct the deserialized data to output
	process(dco_ib)
	begin
		if rising_edge(dco_ib) then
			s_match <= '0';
			s_data_we <= '0';
			if s_data_fco_r = X"FC0" then
				s_match <= '1';
				o_data <= s_data_r;
			end if;
			if s_match = '1' then
				s_data_we <= '1';
			end if;
		end if;
	end process;

	process(dco_ib)
	begin
		if rising_edge(dco_ib) then
			cnt_2bit <= cnt_2bit + '1';	
		end if;
	end process;
	--clock_adc <= cnt_2bit(0); -- dco devided by 2
	clock_adc <= dco_ib;

	-- other outputs
	data_we   <= s_data_we;
	data_fco  <= s_data_fco_r;

end iddr2_arch; 

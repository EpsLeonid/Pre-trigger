library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

use work.types.all;
use work.constants.all;

------------------------------------------------------------------
---- ADC CONTROL ENTITY ------------------------------------------
------------------------------------------------------------------

entity adc_ctrl is
port(
		i_clock, reset       : in std_logic;
		                    
		clock_locked         : in std_logic;
		                    
		bitslip_reset        : in std_logic;
    addr_reset           : in std_logic;                                     -- remove ?

		shift                : in std_logic_vector(7 downto 0);                  -- for bad channel / temporary
		                                                                        
    i_adc_mask           : in std_logic_vector(31 downto 0); -- mask for ADCs
		i_adc_buf_run        : in std_logic;                                     -- start/stop filling the ADC waveform data into the buffer
		
		i_raddr              : in std_logic_vector(LOM_ADCBUF_DEPTH-1 downto 0); -- read out by CPU
		                                                                        
    i_injveto            : in std_logic;                                     -- SUPERKEKB injection veto signal

    i_testbuf_mode       : in std_logic;                                     -- when high, the data from lomtest buffer are used instead of ADC data
    i_testbuf_data       : in t_adc_data_32_array;                           -- data from lomtest buffer
    o_testbuf_enable     : out std_logic;                                    -- signal to increment test buffer address
    i_bufsize            : in std_logic_vector(LOM_ADCBUF_DEPTH-1 downto 0);

		o_rdata              : out t_adc_data_32_array;                          -- read out by CPU
    o_rdata_sum          : out t_adc_sum_array(1 to N_ADC); 
		o_adc_data           : out t_adc_data_32_array;                          -- output data
    o_addr               : out t_reg_data;                                   -- current address in the adc buffer
		
		-- external ports
		CLKP                 : out std_logic_vector(4 downto 1);
		CLKN                 : out std_logic_vector(4 downto 1);
		
		SDATAP               : in std_logic_vector(32 downto 1);
		SDATAN               : in std_logic_vector(32 downto 1);
		DCOP                 : in std_logic_vector(4 downto 1);
		DCON                 : in std_logic_vector(4 downto 1);
		FCOP                 : in std_logic_vector(4 downto 1);
		FCON                 : in std_logic_vector(4 downto 1));
end adc_ctrl;

architecture behavioral of adc_ctrl is

	
	-- deserializator component --------
	component adc_deser_8ch_12bits
  generic (
    ADCNUM        : integer
  );
	port(
		i_clock       : in std_logic;
	  reset         : in std_logic;

		bitslip_reset : in std_logic;
		shift         : in std_logic_vector(7 downto 0);

		o_clock_adc   : out std_logic;

		o_data        : out t_adc_data_8_array;
		o_data_we     : out std_logic;
		
		-- PINS
		SDATAP        : in std_logic_vector(8 downto 1);
		SDATAN        : in std_logic_vector(8 downto 1);
                     
		DCOP          : in std_logic;
		DCON          : in std_logic;
		      
		FCOP          : in std_logic;
		FCON          : in std_logic);
	end component;
	--------------------------------------
	
	-- select component implementation ---
	for ALL : adc_deser_8ch_12bits use entity
		work.adc_deser_8ch_12bits(xapp);
	--------------------------------------

	signal s_clk_cnt           : std_logic_vector(1 downto 0) := (others => '0');
	signal s_clk_cnt_next      : std_logic_vector(1 downto 0) := (others => '0');
	signal s_vec_clk_div4      : std_logic_vector(4 downto 1) := (others => '0'); --divided clock frequency
  signal s_out_strobe        : std_logic := '0';
  signal s_out_strobe_ctrl   : std_logic := '0';
  signal s_out_strobe_pre    : std_logic := '0';

  signal s_arr_adc_data      : t_adc_data_32_array;  -- ADC data from deserializers
  signal s_arr_adc_data_sel  : t_adc_data_32_array;  -- selected data: from ADC of from the test buffer
  signal s_arr_adc_data_w    : t_adc_data_32_array;  
  signal s_arr_adc_data_dw   : t_adc_data_32_array;  
  signal s_adc_data_out      : t_adc_data_32_array; 
  signal s_adc_data_out_r    : t_adc_data_32_array; 
  signal s_adc_data_out_dr   : t_adc_data_32_array; 
  signal s_arr_rdata         : t_adc_data_32_array;  -- for read out to CPU
  signal s_testbuf_data      : t_adc_data_32_array;  -- data from test buffer
  signal s_testbuf_data_r    : t_adc_data_32_array;  -- data from test buffer

	signal s_adc_buf_we        : std_logic_vector(4 downto 1) := (others=>'0');
	signal s_adc_buf_we_pre    : std_logic_vector(4 downto 1) := (others=>'0');
	signal s_adc_buf_we_ctrl   : std_logic_vector(4 downto 1) := (others=>'0'); -- wena & run
	signal s_adc_buf_wclk      : std_logic_vector(4 downto 1) := (others=>'0'); -- adc buffer write clock

  ---
  subtype t_bufaddr is std_logic_vector(LOM_ADCBUF_DEPTH-1 downto 0);
  type    t_bufaddr_array is array(1 to N_ADC_CHIPS) of t_bufaddr;
  ---

  --signal s_arr_waddr         : t_bufaddr_array   := (others => (others => '0')); -- current address in the ADC buffer
  signal s_waddr             : t_bufaddr         := (others => '0'); -- current address in the ADC buffer
  signal s_waddr_next        : t_bufaddr         := (others => '0'); -- next address in the ADC buffer
  signal s_addr              : t_reg_data        := (others => '0');
  signal s_addr_dr           : t_reg_data        := (others => '0');
  signal s_addr_sysclk_r     : t_reg_data        := (others => '0');
  signal s_addr_sysclk_dr    : t_reg_data        := (others => '0');

  signal s_bufsize           : std_logic_vector(LOM_ADCBUF_DEPTH-1 downto 0) := (others => '0');
  constant c_zeroaddr        : std_logic_vector(LOM_ADCBUF_DEPTH-1 downto 0) := (others => '0');

  signal s_arr_adc_sums      : t_adc_sum_array(1 to N_ADC)  := (others => (others => '0')); 
  signal s_arr_rdata_sum     : t_adc_sum_array(1 to N_ADC)  := (others => (others => '0')); 
  signal s_adc_mask          : std_logic_vector(31 downto 0) := (others => '0'); 

begin

	process(i_clock)
	begin
		if rising_edge(i_clock) then
      s_adc_mask <= i_adc_mask;
      s_bufsize  <= i_bufsize;
    end if;
  end process;

  -- clock/4 frequency for ADC sampling
	process(i_clock)
	begin
		if rising_edge(i_clock) then
			s_clk_cnt <= s_clk_cnt_next;
    end if; 
	end process;
	s_clk_cnt_next <= s_clk_cnt + 1 when clock_locked = '1' else B"00"; 
  s_vec_clk_div4 <= s_clk_cnt(1) & s_clk_cnt(1) & s_clk_cnt(1) & s_clk_cnt(1);
  -- 

  -- generate enable signal for selftester module
	process(i_clock)
	begin
		if rising_edge(i_clock) then
      if s_clk_cnt = X"1" then
        o_testbuf_enable <= '1';
        s_out_strobe     <= '1';
      else
        o_testbuf_enable <= '0';
        s_out_strobe     <= '0';
		  end if;
    end if; 
	end process;
  --

  --=================================================== 
  GEN_ADC_DESER : for nADC in 1 to 4 generate

		----------- ADC sampling clock  -------------------
		clkp_obufds : OBUFDS
		port map(
		  I  => s_vec_clk_div4(nADC),
		  O  => CLKP(nADC),
		  OB => CLKN(nADC));
		------------------------------------------

	  --------------- DESERIALIZERS-----------------------
		adc_deser : adc_deser_8ch_12bits
    generic map (
      ADCNUM => nADC
    )
		port map(
      i_clock       => i_clock,

      reset         => reset,
      
      bitslip_reset => bitslip_reset,

      o_clock_adc   => s_adc_buf_wclk(nADC),
      o_data_we     => s_adc_buf_we(nADC),
                         
      o_data        => s_arr_adc_data((nADC-1)*8+1 to 8*nADC),
                         
      shift         => shift,  -- for bad channel
                         
      -- PINS      
      SDATAP        => SDATAP(nADC*8 downto (nADC-1)*8+1),
      SDATAN        => SDATAN(nADC*8 downto (nADC-1)*8+1),
                     
      DCOP          => DCOP(nADC),
      DCON          => DCON(nADC),
                   
      FCOP          => FCOP(nADC),
      FCON          => FCON(nADC)
		);
	  ------------------------------------------------------

    --------------------------------------------------------
    -- select whether input signal is from test buffer 
    -- or from real ADC 
    --------------------------------------------------------
    SRC_SEL : process(s_adc_buf_wclk(nADC)) 
    begin 
      if rising_edge(s_adc_buf_wclk(nADC)) then
        
        s_testbuf_data((nADC-1)*8+1 to 8*nADC)   <= i_testbuf_data((nADC-1)*8+1 to 8*nADC);
        s_testbuf_data_r((nADC-1)*8+1 to 8*nADC) <= s_testbuf_data((nADC-1)*8+1 to 8*nADC);

        if i_testbuf_mode = '1' then
          s_arr_adc_data_sel((nADC-1)*8+1 to 8*nADC) <= s_testbuf_data_r((nADC-1)*8+1 to 8*nADC);
        elsif i_injveto = '0' then
          s_arr_adc_data_sel((nADC-1)*8+1 to 8*nADC) <= s_arr_adc_data((nADC-1)*8+1 to 8*nADC);
        else
          s_arr_adc_data_sel((nADC-1)*8+1 to 8*nADC) <= (others => (others => '0'));
        end if;

        s_arr_adc_data_w((nADC-1)*8+1 to 8*nADC)  <= s_arr_adc_data_sel((nADC-1)*8+1 to 8*nADC);
        s_arr_adc_data_dw((nADC-1)*8+1 to 8*nADC) <= s_arr_adc_data_w((nADC-1)*8+1 to 8*nADC);
      end if;
    end process SRC_SEL;
    --------------------------------------------------------

    --------------------------------------------------------
    --BUF_WE_PROC : process(s_adc_buf_wclk(nADC))
    --begin
      --if rising_edge(s_adc_buf_wclk(nADC)) then
        --if reset = '1' then
          --s_adc_buf_we_ctrl(nADC) <= '1';
          --s_adc_buf_we_pre(nADC) <= '1';
          --s_arr_waddr(nADC) <=  (others => '0');
        --else
          --s_adc_buf_we_pre(nADC) <= s_adc_buf_we(nADC);
          --if i_adc_buf_run = '1' and s_adc_buf_we_pre(nADC) = '1' then
            --s_adc_buf_we_ctrl(nADC) <= '1';
            --s_arr_waddr(nADC) <= s_arr_waddr(nADC) + '1';
          --else
            --s_adc_buf_we_ctrl(nADC) <= '1';
            --s_arr_waddr(nADC) <= s_arr_waddr(nADC);
          --end if;
          
          --if addr_reset = '1' then 
            --s_arr_waddr(nADC)    <= (others => '0');
          --end if;

        --end if;
      --end if;
    --end process BUF_WE_PROC;
    --------------------------------------------------------

  end generate GEN_ADC_DESER;
  --=================================================== 


  s_addr(s_addr'length-1 downto LOM_ADCBUF_DEPTH ) <= (others => '0');
  

  -- Redirect output data
  ODATA_PROC : process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_adc_data_out <= s_arr_adc_data_dw; 
      if s_out_strobe = '1' then
        s_adc_data_out_r   <= s_adc_data_out; 
      end if;
      s_adc_data_out_dr   <= s_adc_data_out_r; 

      o_adc_data         <= s_adc_data_out_dr;

    end if;
  end process ODATA_PROC;

  -- read out ADC buffer from CPU
  o_rdata <= s_arr_rdata;
  
  --------------------------------------------------------
  BUF_WE_PROC : process(i_clock)
  begin
    if rising_edge(i_clock) then
      if reset = '1' then
        s_out_strobe_ctrl <= '0';
        s_out_strobe_pre  <= '0';
        s_waddr       <=  (others => '0');
      else
        s_out_strobe_pre <= s_out_strobe;
        if i_adc_buf_run = '1' and s_out_strobe_pre = '1' and i_injveto = '0' then
          s_out_strobe_ctrl <= '1';
          s_waddr <= s_waddr_next;
        else
          s_out_strobe_ctrl <= '0';
          s_waddr <= s_waddr;
        end if;

        
        if addr_reset = '1' then 
          s_waddr <= (others => '0');
        end if;

      end if;
    end if;
  end process BUF_WE_PROC;
  s_waddr_next <= s_waddr + '1'   when s_bufsize = c_zeroaddr or s_waddr /= s_bufsize else
                  (others => '0') ; 
  --------------------------------------------------------

  process(i_clock)
  begin
    if rising_edge(i_clock) then
      s_addr(LOM_ADCBUF_DEPTH-1 downto 0) <= s_waddr; -- TODO: different for all buffers 
      s_addr_dr <= s_addr;
    end if;
  end process;

  o_addr <= s_addr_dr;
  --------------------------------------------------------

  --=================================================== 
  -- Block memory for ADC samples
  --=================================================== 
  GEN_ADC_CHIP : for nADC in 1 to 4 generate
 
    GEN_ADC_CHAN : for nCH in 1 to 8 generate

      adc_buf_ram_i : entity work.bram_sdp
      generic map (
        DATA => ADC_BIT_WIDTH,
      --  DATA => 16, 
        ADDR => LOM_ADCBUF_DEPTH
      )
      port map (
        clka   => i_clock,   -- TODO: for each buffer use its own write clock
        wea    => s_out_strobe_ctrl,
        addra  => s_waddr,
        dina   => s_adc_data_out_dr(nCH + (nADC-1)*8),

        clkb   => i_clock,
        addrb  => i_raddr,
        doutb  => s_arr_rdata(nCH + (nADC-1)*8)
      );

		end generate GEN_ADC_CHAN;
  
  end generate GEN_ADC_CHIP;
  --=================================================== 


  --=================================================== 
  -- calculate running sums
  --=================================================== 
  SUM_GEN : for nSum in 1 to N_ADC generate
    function func_chan16_plus_x(IADC : integer; x : integer) return integer is
      variable chan  : integer := 0;
      variable chan0 : integer := 0;
    begin
      
      -- chan0 - channel number inside single endcap
      if IADC > 16 then
        chan0 := IADC - 16;
      else 
        chan0 := IADC;
      end if;

      chan := chan0 + x;
      
      -- cycling inside endcap (16 channels)
      if chan > 16 then
        chan := chan - 16;
      end if;

      -- recalculate to 1-32 channel number
      if IADC > 16 then
        chan := chan + 16;
      end if;

      return chan;

    end function func_chan16_plus_x;
  begin
    process(i_clock)
      variable v_adc1 : t_adc_sum  := (others => '0');
      variable v_adc2 : t_adc_sum  := (others => '0');

      constant v_i1 : integer := nSum;
      constant v_i2 : integer := func_chan16_plus_x(nSum, 1);
    begin
      if rising_edge(i_clock) then
        
        if s_adc_mask(v_i1 - 1) = '1' then
          v_adc1 := '0' & s_adc_data_out_r(v_i1);
        else 
          v_adc1 := (others => '0');
        end if;

        if s_adc_mask(v_i2 - 1) = '1' then
          v_adc2 := '0' & s_adc_data_out_r(v_i2);
        else 
          v_adc2 := (others => '0');
        end if;
        
        s_arr_adc_sums(nSum) <= v_adc1 + v_adc2;

      end if;
    end process; 

  end generate SUM_GEN;

  --=================================================== 
  -- Block memory for running sum samples
  --=================================================== 
    GEN_SUM : for nSum in 1 to 32 generate

      adc_buf_ram_i : entity work.bram_sdp
      generic map (
        DATA => ADC_BIT_WIDTH+1,
        ADDR => LOM_ADCBUF_DEPTH
      )
      port map (
        clka   => i_clock,   -- TODO: for each buffer use its own write clock
        wea    => s_out_strobe_ctrl,
        addra  => s_waddr,
        dina   => s_arr_adc_sums(nSum),

        clkb   => i_clock,
        addrb  => i_raddr,
        doutb  => s_arr_rdata_sum(nSum)
      );

		end generate GEN_SUM;
  --=================================================== 

  o_rdata_sum <= s_arr_rdata_sum;
  


end behavioral;



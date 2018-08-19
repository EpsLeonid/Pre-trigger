------------------------------------------------------------------------------
-- ECL Online Luminosity Monitor TOP
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.types.all;
use work.reg_map.all;
use work.constants.all;

entity top is
  generic (
    VERSION : integer := 400 -- version * 1000
    --ID : std_logic_vector (31 downto 0) := x"53363035" );  -- "S605"
    );
  port(

  -- SYSTEM
    OSC_50MHZ      : in std_logic; 
    RESET_P        : in std_logic; 
    SYS_RST        : in std_logic;
                  
    TP             : out std_logic_vector(8 downto 3);
    PG             : in  std_logic_vector(5 downto 1);
    CPU_LED        : out std_logic; 
                  
  -- Jumpers      
    CPU_JMP        : in std_logic_vector(0 to 1); 
    CLK_MODE       : in std_logic; 
                  
  -- ADC SPI      
    FADC_SDIR      : out   std_logic;
    FADC_SDIO      : inout std_logic; 
    FADC_SCLK      : out   std_logic; 
    FADC_CSB       : out   std_logic_vector(4 downto 1); 
                  
  -- ADC          
    ADC_CLKP       : out std_logic_vector(4 downto 1); 
    ADC_CLKN       : out std_logic_vector(4 downto 1); 
                  
    SDATAP         : in std_logic_vector(32 downto 1); 
    SDATAN         : in std_logic_vector(32 downto 1); 
    DCOP           : in std_logic_vector(4  downto 1); 
    DCON           : in std_logic_vector(4  downto 1); 
    FCOP           : in std_logic_vector(4  downto 1); 
    FCON           : in std_logic_vector(4  downto 1); 
    
    VETO           : in std_logic; 

    -- TTD

    TTD_CLK_P : in std_logic; -- ***
    TTD_CLK_N : in std_logic; -- ***
    TTD_TRG_P : in std_logic; -- ***
    TTD_TRG_N : in std_logic; -- ***
    TTD_ACK_P : in std_logic; -- ***
    TTD_ACK_N : in std_logic; -- ***
    TTD_RSV_P : out std_logic; -- ***
    TTD_RSV_N : out std_logic; -- ***

  -- SPI flash memory
    II_SPI_SCK     : out std_logic; 
    II_SPI_MISO    : in std_logic;
    II_SPI_MOSI    : out std_logic;
    II_SPI_CS_B    : out std_logic;

  -- I2C
    IIC_SDA        : inout std_logic; 
    IIC_SCL        : inout std_logic;

  -- Ethernet	
    ETH_RST_B      : out   std_logic;
    ETH_TX_EN      : out   std_logic;
    ETH_TX_ER      : out   std_logic;
    ETH_MII_TX_CLK : in    std_logic;
    ETH_TX_CLK     : out   std_logic;
    ETH_RX_DV      : in    std_logic;
    ETH_RX_ER      : in    std_logic;
    ETH_RX_CLK     : in    std_logic; 
    ETH_MDC        : out   std_logic; 
    ETH_MDIO       : inout std_logic; 
    ETH_MDINT      : in    std_logic; 
    ETH_RXD        : in    std_logic_vector(7 downto 0); 
    ETH_TXD        : out   std_logic_vector(7 downto 0);

    -- for simulation only
    -- synthesis translate_off
    SIM_ETH_REG_WE    : in  std_logic;
    SIM_ETH_REG_NUM   : in  std_logic_vector(15 downto 0);
    SIM_ETH_REG_WDATA : in  std_logic_vector(15 downto 0);
    SIM_ETH_REG_RDATA : out std_logic_vector(15 downto 0);
    SIM_SYS_CLK       : out std_logic;
    -- synthesis translate_on

  -- DDR
    DDR3_LDQS_P  : inout std_logic;
    DDR3_LDQS_N  : inout std_logic;
    DDR3_UDQS_P  : inout std_logic;
    DDR3_UDQS_N  : inout std_logic;
    DDR3_RZQ     : inout std_logic;
    DDR3_ZIO     : inout  std_logic;
    DDR3_DQ      : inout std_logic_vector(15 downto 0);
    DDR3_CLK_P   : out   std_logic;
    DDR3_CLK_N   : out   std_logic;
    DDR3_CKE     : out   std_logic;
    DDR3_WE_B    : out   std_logic;	
    DDR3_CAS_B   : out   std_logic;
    DDR3_RAS_B   : out   std_logic;
    DDR3_LDM     : out   std_logic;
    DDR3_UDM     : out   std_logic;
    DDR3_BA      : out   std_logic_vector( 2 downto 0);
    DDR3_A       : out   std_logic_vector(12 downto 0);
    DDR3_ODT     : out   std_logic;
    DDR3_RST_B   : out   std_logic  
  );
end top;

architecture behavioral of top is

	component system is
		port (
			OSC_50MHZ      : in std_logic; 
			SYS_RST        : in std_logic;
                    
			ETH_RST_B      : out std_logic;
			ETH_TXD        : out std_logic_vector(7 downto 0);
			ETH_TX_EN      : out std_logic;
			ETH_TX_ER      : out std_logic;
			ETH_TX_CLK     : out std_logic;
			ETH_RXD        : in std_logic_vector(7 downto 0);
			ETH_RX_DV      : in std_logic;
			ETH_RX_ER      : in std_logic;
			ETH_RX_CLK     : in std_logic;
			ETH_MDC        : out std_logic;
			ETH_MDIO       : inout std_logic;
			ETH_MDINT      : in std_logic;
			ETH_MII_TX_CLK : in std_logic;

			CPU_JMP        : in std_logic_vector(0 to 1);
			DDR3_A         : out std_logic_vector(12 downto 0);
			DDR3_BA        : out std_logic_vector(2 downto 0);
			DDR3_RAS_B     : out std_logic;
			DDR3_CAS_B     : out std_logic;
			DDR3_WE_B      : out std_logic;
			DDR3_CKE       : out std_logic;
			DDR3_CLK_P     : out std_logic;
			DDR3_CLK_N     : out std_logic;
			DDR3_DQ        : inout std_logic_vector(15 downto 0);
			DDR3_LDQS_P    : inout std_logic;
			DDR3_LDQS_N    : inout std_logic;
			DDR3_UDQS_P    : inout std_logic;
			DDR3_UDQS_N    : inout std_logic;
			DDR3_UDM       : out std_logic;
			DDR3_LDM       : out std_logic;
			DDR3_ODT       : out std_logic;
			DDR3_RST_B     : out std_logic;
			DDR3_RZQ       : inout std_logic;
			DDR3_ZIO       : inout std_logic;
			CPU_LED        : out std_logic_vector(0 to 31);
			IIC_SDA        : inout std_logic;
			IIC_SCL        : inout std_logic;

			-- flash memory SPI
			II_SPI_SCK     : out std_logic;
			II_SPI_MISO    : in std_logic;
			II_SPI_MOSI    : out std_logic;
			II_SPI_CS_B    : out std_logic;

			-- ADC SPI interface
			xps_spi_0_SCK_O  : out std_logic;
			xps_spi_0_MOSI_O : out std_logic;
			xps_spi_0_SS_O   : out std_logic_vector(3 downto 0);

			-- clocks
			sys_clock    : out std_logic;
			clock        : in std_logic;
			clock_locked : out std_logic;

			-- MB_ETH_IFC

			-- memory
			mem_addr  : out std_logic_vector(31 downto 0);
			mem_wdata : out std_logic_vector(15 downto 0);
			mem_rdata : in  std_logic_vector(15 downto 0);
			mem_we    : out std_logic;
			-- registers
			reg_we    : out std_logic;
			reg_num   : out std_logic_vector(15 downto 0);
			reg_wdata : out std_logic_vector(15 downto 0);
			reg_rdata : in std_logic_vector(15 downto 0)  
    );

	end component;

  --------------------------------------------------------------------------------
  -- B2TT SIGNALS
  --------------------------------------------------------------------------------
  signal sig_raw127    : std_logic := '0';
  signal clk_127       : std_logic := '0';
  signal clk_254       : std_logic := '0';
  
  signal sig_clkup     : std_logic := '0';
  signal sig_ttup      : std_logic := '0';
  signal s_trg       : std_logic := '0';

  signal sig_revo      : std_logic := '0';

  signal s_trgtag    : std_logic_vector (31 downto 0) := (others => '0');

  signal reg_dbg       : std_logic_vector (7  downto 0) := (others => '0');
  
  signal s_injveto   : std_logic := '0';

  signal open_utime    : std_logic_vector (31 downto 0) := (others => '0');
  signal open_ctime    : std_logic_vector (26 downto 0) := (others => '0');
  signal open_divclk1  : std_logic_vector (1  downto 0) := (others => '0');
  signal open_divclk2  : std_logic_vector (1  downto 0) := (others => '0');
  signal open_exprun   : std_logic_vector (31 downto 0) := (others => '0');
  signal open_runreset : std_logic := '0';
  signal open_feereset : std_logic := '0';
  signal open_b2lreset : std_logic := '0';
  signal open_gtpreset : std_logic := '0';
  signal open_trgtyp   : std_logic_vector (3  downto 0) := (others => '0');
  signal open_fifordy  : std_logic := '0';
  signal open_fifodata : std_logic_vector (95 downto 0) := (others => '0');
  signal open_octet    : std_logic_vector (7  downto 0) := (others => '0');
  signal open_isk      : std_logic := '0';
  signal open_cntbit2  : std_logic_vector (2  downto 0) := (others => '0');
  signal open_sigbit2  : std_logic_vector (1  downto 0) := (others => '0');
  signal sig_dbg       : std_logic_vector (95 downto 0) := (others => '0');
  signal open_running  : std_logic := '0';
  
  signal ttd_busy    : std_logic := '0';

  -- ttd signals in the LOM clock domain
  signal s_ttd_utime          : std_logic_vector (31 downto 0) := (others => '0');
  signal s_ttd_utime_d        : std_logic_vector (31 downto 0) := (others => '0');

  signal s_exp_is_running     : std_logic := '0';
  signal s_exp_run_reset      : std_logic := '0';
  signal s_b2tt_is_up         : std_logic := '0';
  signal s_b2clk_is_up        : std_logic := '0';
  signal s_exp_is_running_d   : std_logic := '0';
  signal s_exp_run_reset_d    : std_logic := '0';
  signal s_b2tt_is_up_d       : std_logic := '0';
  signal s_b2clk_is_up_d      : std_logic := '0';
  signal s_ttd_busy    : std_logic := '0';
  signal s_ttd_busy_d  : std_logic := '0';
--------------------------------------------------------------------------------


	--- reset
	signal s_reset             : std_logic := '0';
	signal s_reset_n           : std_logic := '0';
	signal s_sys_reset         : std_logic := '0';
	signal s_sys_reset_n       : std_logic := '0';
	signal s_soft_reset        : std_logic := '0';
	---

	--- clocking
  --  clock from Microblaze clock generator
	signal s_clock             : std_logic := '0';
	signal s_clock_locked      : std_logic := '0';
	---

	-- heartbeats
	signal hb25ns              : std_logic := '0';
	signal hb5mks              : std_logic := '0';
	signal hb50mks             : std_logic := '0';
	---

	-- adc
  signal s_adc_buf_addr_rst  : std_logic := '0';
	signal s_adc_buf_raddr     : std_logic_vector(LOM_ADCBUF_DEPTH-1 downto 0) := (others=>'0');
	signal s_bitslip_reset     : std_logic := '0';
	signal s_adc_buf_rdata     : t_adc_data_32_array  := (others=>(others=>'0'));
	signal s_sum_buf_rdata     : t_adc_sum_array(1 to N_ADC)  := (others=>(others=>'0'));
  signal s_arr_adc_amp       : t_adc_data_32_array  := (others=>(others=>'0'));
  signal s_arr_sum_amp       : t_adc_sum_32_array   := (others=>(others=>'0'));
  signal s_arr_adc_amp_r     : t_reg_array(0 to 31) := (others=>(others=>'0'));
  signal s_arr_sum_amp_r     : t_reg_array(0 to 31) := (others=>(others=>'0'));
	---
	
	attribute BOX_TYPE : STRING;
	attribute BOX_TYPE of system : component is "user_black_box";
	
	constant XVERSION  : std_logic_vector (15 downto 0) := conv_std_logic_vector(VERSION, 16);

	signal s_cpu_led   : std_logic_vector(0 to 31);

	-- CPU mem interface
	signal s_cpu_mem_addr      : std_logic_vector(31 downto 0) := (others => '0');
	signal s_cpu_mem_wdata     : std_logic_vector(15 downto 0) := (others => '0');
	signal s_cpu_mem_rdata     : std_logic_vector(15 downto 0) := (others => '0');
	signal s_cpu_mem_we        : std_logic := '0';	
	---

	--- CPU registers interface
	signal s_cpu_reg_we        : std_logic := '0';
	signal s_cpu_reg_num       : std_logic_vector(15 downto 0) := (others => '0');
	signal s_cpu_reg_wdata     : std_logic_vector(15 downto 0) := (others => '0');
	signal s_cpu_reg_rdata     : std_logic_vector(15 downto 0) := (others => '0');
	---

	-- select adc buffer (should be moved to mem_file)
	signal s_adc_data          : t_adc_data_32_array;
	signal s_fco_data          : t_adc_data_4_array   := (others=>(others=>'0'));
	---                        
                             
	--- registers signals      
	signal s_reg_set_values    : t_reg_array(0 to NREG-1) := (others => (others => '0')); 
	signal s_reg_data          : t_reg_array(0 to NREG-1) := (others => (others => '0')); 
	---
	
  -- temporary!!
	signal s_clk_cnt           : std_logic_vector(31 downto 0) := (others => '0');
	signal s_clk_cnt_next      : std_logic_vector(31 downto 0) := (others => '0');
	--

	-- test points
	signal tp2_r               : std_logic := '0';
	---
  signal s_bitshift          : std_logic_vector(7 downto 0) := (others => '0');
	-- ADC SPI interface signals
	signal s_fadc_sdio         : std_logic := '0'; 
	signal s_fadc_sclk         : std_logic := '0';
	signal s_fadc_csb          : std_logic_vector(3 downto 0) := (others => '1');

  -- mask bits for ADC
  signal s_adc_buf_mask      : std_logic_vector(31 downto 0) := (others => '0');
  signal s_adc_lom_mask      : std_logic_vector(31 downto 0) := (others => '0');

	-- trigger signals
--	signal s_adc_trig_vec      : std_logic_vector(31 downto 0) := (others => '0');
	signal s_adc_trig          : std_logic := '0';
	signal s_counter           : std_logic_vector(17 downto 0) := (others => '0');
                            
  -- Histograms             
  signal s_hread_index       : std_logic_vector(7 downto 0)  := (others => '0');
  signal s_hread_baddr       : std_logic_vector(15 downto 0) := (others => '0');
  signal s_hread_data        : std_logic_vector(LOM_HISTO_VAL_BITS-1  downto 0) := (others => '0');
  
  -- thresholds
  signal s_adc_thresholds    : t_reg_32_array := (others => (others => '0')); 
  signal s_sum_thresholds    : t_reg_32_array := (others => (others => '0')); 
  signal s_adc_qthresholds   : t_reg_32_array := (others => (others => '0')); 

  signal s_clkmax            : std_logic_vector(31 downto 0);

  -- LOM
  signal s_Bhabha_CNT        : std_logic_vector(31 downto 0) := (others => '0');
  signal s_dead_time_max     : std_logic_vector(31 downto 0) := (others => '0');
  signal s_discr_expand      : t_reg_data                    := (others => '0');
  signal s_nevt              : t_reg_data                    := (others => '0');

  signal s_buf_trg           : std_logic                     := '0';
  signal s_buf_trgtype       : std_logic_vector(2 downto 0)  := (others => '0');
  signal s_adc_bufsize       : t_reg_data := (others => '0');
  signal s_set_bufsize       : t_reg_data := (others => '0');

  -- temporary
  signal s_EMU_CPU_MEM_ADDR  : std_logic_vector(31 downto 0) := (others => '0');

  -- for lomtest / self_tester component to connect it with adc_ctrl
  signal s_lomtest_mode      : std_logic                    := '0';
  signal s_lomtest_enable    : std_logic                    := '0';
  signal s_lomtest_buf_we    : std_logic                    := '0';
  signal s_lomtest_buf_index : std_logic_vector(4 downto 0) := (others => '0');
  signal s_lomtest_buf_raddr : t_testbuf_addr               := (others => '0');
  signal s_lomtest_buf_waddr : t_testbuf_addr               := (others => '0');
  signal s_lomtest_buf_rdata : t_adc_data                   := (others => '0');
  signal s_lomtest_buf_wdata : t_adc_data                   := (others => '0');
  signal s_lomtest_data      : t_adc_data_32_array          := (others => (others => '0'));

  signal s_push_mode         : std_logic                    := '0';
  signal s_reg_push          : std_logic                    := '0';

  -- operation control
    -- histograms
  signal s_hrun_enable       : std_logic := '0'; -- enable signal for histograms
  signal s_htest_mode        : std_logic := '0'; -- test mode on/off for histograms
  signal s_hclear_ctrl       : std_logic := '0'; -- clear histograms
  signal s_testrun           : std_logic := '0'; -- testbufer mode

    -- counters
  signal s_crun_enable       : std_logic := '0';  -- enable counters
  signal s_cclear_ctrl       : std_logic := '0';  -- clear counters signal
  
    -- adc buffer
  signal s_brun_enable       : std_logic := '0';  -- enable/disable filling of ADC buffer
  signal s_buf_run_ctrl      : std_logic := '0';  -- start filling of ADC buffer
  signal s_buf_run_stop      : std_logic := '0';  -- stop filling ADC buffer
  signal s_buf_run           : std_logic := '1';  -- current status of ADC buffer process

  -- status of lom logic module
  signal s_lom_stat          : t_reg_data        := (others => '0');            -- status register

  -- counters data
  signal s_lom_adc_cnt       :  t_reg_32_array   := (others => (others => '0')); -- adc hits counters
  signal s_lom_sum_cnt       :  t_reg_32_array   := (others => (others => '0')); -- hits counter for sum signals
  signal s_lom_coi_cnt       :  t_reg_16_array   := (others => (others => '0')); -- coincidence counters for sum signals
  signal s_lom_roi_cnt       :  t_reg_16_array   := (others => (others => '0')); -- coincidence counters for raw signals
  --signal s_lom_coi_256_cnt   :  t_reg_array(0 to 255)   := (others => (others => '0'));
  signal s_lom_cmx_cnt       :  t_reg_array(0 to 255)   := (others => (others => '0')); 
  signal s_lom_evt_cnt       :  t_reg_data       := (others => '0'); -- events counter

  signal s_lom_clk_cnt       : std_logic_vector(31 downto 0) := (others => '0'); -- number of clocks counter
  signal s_lom_bha_raw_cnt   : std_logic_vector(31 downto 0) := (others => '0'); -- raw bhabha counter (without quality signal)
  signal s_lom_bha_qua_cnt   : std_logic_vector(31 downto 0) := (others => '0'); -- bhabha counter (with quality signal)
  signal s_lom_fke_cnt      : std_logic_vector(31 downto 0) := (others => '0'); -- bhabha counter (with quality signal)
  signal s_lom_ded_cnt       : std_logic_vector(31 downto 0) := (others => '0'); -- dead time counter
  signal s_lom_inj_cnt       : std_logic_vector(31 downto 0) := (others => '0'); -- injection time counter
  signal s_lom_bsy_cnt       : std_logic_vector(31 downto 0) := (others => '0'); -- injection time counter

  -- histograms/counters overflow
  signal s_hist_overflow     : std_logic       := '0';
  signal s_cnt_overflow      : t_reg_data      := (others => '0');


begin

  --===========================================================
	--               MICROBLAZE 
  --===========================================================
	system_i : entity work.system
	port map (
		OSC_50MHZ      => OSC_50MHZ,
		SYS_RST        => SYS_RST,
                  
		ETH_RST_B      => ETH_RST_B,
		ETH_TXD        => ETH_TXD,
		ETH_TX_EN      => ETH_TX_EN,
		ETH_TX_ER      => ETH_TX_ER,
		ETH_TX_CLK     => ETH_TX_CLK,
		ETH_RXD        => ETH_RXD,
		ETH_RX_DV      => ETH_RX_DV,
		ETH_RX_ER      => ETH_RX_ER,
		ETH_RX_CLK     => ETH_RX_CLK,
		ETH_MDC        => ETH_MDC,
		ETH_MDIO       => ETH_MDIO,
		ETH_MDINT      => ETH_MDINT,
		ETH_MII_TX_CLK => ETH_MII_TX_CLK,

		CPU_JMP        => CPU_JMP,

  -- DDR3 RAM  
		DDR3_A         => DDR3_A,
		DDR3_BA        => DDR3_BA,
		DDR3_RAS_B     => DDR3_RAS_B,
		DDR3_CAS_B     => DDR3_CAS_B,
		DDR3_WE_B      => DDR3_WE_B,
		DDR3_CKE       => DDR3_CKE,
		DDR3_CLK       => DDR3_CLK_P,
		DDR3_CLK_B     => DDR3_CLK_N,
		DDR3_DQ        => DDR3_DQ,
		DDR3_LDQS_P    => DDR3_LDQS_P,
		DDR3_LDQS_N    => DDR3_LDQS_N,
		DDR3_UDQS_P    => DDR3_UDQS_P,
		DDR3_UDQS_N    => DDR3_UDQS_N,
		DDR3_UDM       => DDR3_UDM,
		DDR3_LDM       => DDR3_LDM,
		DDR3_ODT       => DDR3_ODT,
		DDR3_RST_B     => DDR3_RST_B,
		DDR3_RZQ       => DDR3_RZQ,
		DDR3_ZIO       => DDR3_ZIO,

	-- Flash memory SPI interface
		II_SPI_SCK       => II_SPI_SCK,
		II_SPI_MISO      => II_SPI_MISO,
		II_SPI_MOSI      => II_SPI_MOSI,
		II_SPI_CS_B      => II_SPI_CS_B,

	-- ADC SPI interface
		FADC_SPI_SCK_O  => s_fadc_sclk,
		FADC_SPI_MOSI_O => s_fadc_sdio,
		FADC_SPI_SS_O   => s_fadc_csb,
		
		CPU_LED => s_cpu_led,

		IIC_SDA => IIC_SDA,
		IIC_SCL => IIC_SCL,

	-- clocking
		sys_clock    => s_clock,
		clock        => s_clock,
		clock_locked => s_clock_locked,
		
	-- Memory infrastructure	
		mem_addr  => s_cpu_mem_addr,
		mem_wdata => s_cpu_mem_wdata,
		mem_rdata => s_cpu_mem_rdata,
		mem_we    => s_cpu_mem_we,
			
	-- Registers interface
		reg_we    => s_cpu_reg_we,
		reg_num   => s_cpu_reg_num,
		reg_wdata => s_cpu_reg_wdata,
		reg_rdata => s_cpu_reg_rdata
	);
  --===========================================================

  -- synthesis translate_off
    s_cpu_reg_we      <= SIM_ETH_REG_WE;
    s_cpu_reg_num     <= SIM_ETH_REG_NUM;
    s_cpu_reg_wdata   <= SIM_ETH_REG_WDATA;
    SIM_ETH_REG_RDATA <= s_cpu_reg_rdata;
    SIM_SYS_CLK       <= s_clock;
  -- synthesis translate_on
	
  s_reg_set_values(REG_VERSION) <= XVERSION;

	-- CLOCKING INFRASTRUCTURE --------------------------
  -- TODO : remove
	infrastructure_top_i : entity work.infrastructure_top
	port map(
		i_clock      => s_clock,
		clock_locked => s_clock_locked,
		RESET_N      => s_reset_n,
		
		hb25ns       => hb25ns,
		hb5mks       => hb5mks,
		hb50mks      => hb50mks
	);
	-----------------------------------------------------

	-- redirect ADC SPI interface signals to output pins
	FADC_SDIR <= (not s_fadc_csb(3)) or (not s_fadc_csb(2)) or (not s_fadc_csb(1)) or (not s_fadc_csb(0));
	--FADC_SDIR <= '1';
	FADC_SDIO <= s_fadc_sdio;
	FADC_SCLK <= s_fadc_sclk;
	FADC_CSB  <= s_fadc_csb;
	--

  --===========================================================
	--             ADC CONTROL 
  --===========================================================
	adc_ctrl_i : entity work.adc_ctrl
	port map(
	  -- system
		i_clock             => s_clock,
		reset               => s_reset,
    addr_reset          => s_adc_buf_addr_rst,

		clock_locked        => s_clock_locked,

		bitslip_reset       => s_bitslip_reset,

		--temporary
		shift               => s_bitshift,
    
    i_adc_mask          => s_adc_buf_mask,
    i_bufsize          =>  s_adc_bufsize(LOM_ADCBUF_DEPTH-1 downto 0),

    -- injection veto
    i_injveto           => s_injveto,
		
		-- start/stop write adc data
		i_adc_buf_run       => s_buf_run,
	
    i_testbuf_mode      => s_lomtest_mode,
    i_testbuf_data      => s_lomtest_data,
    o_testbuf_enable    => s_lomtest_enable,

		-- read data
		i_raddr             => s_adc_buf_raddr,
		o_rdata             => s_adc_buf_rdata,
		o_rdata_sum         => s_sum_buf_rdata,

		-- output array of ADC samples
		o_adc_data          => s_adc_data,
    -- current address in the buffer
    o_addr              => s_reg_set_values(REG_ADCADDR0),

		-- I/O
		CLKP                => ADC_CLKP,
		CLKN                => ADC_CLKN,
		SDATAP              => SDATAP,
		SDATAN              => SDATAN,
		DCOP                => DCOP, 
		DCON                => DCON, 
		FCOP                => FCOP, 
		FCON                => FCON   
	);
  --===========================================================

  process(s_clock)
  begin
    if rising_edge(s_clock) then
      s_set_bufsize          <= 
            std_logic_vector(to_unsigned(0, t_reg_data'length-LOM_ADCBUF_DEPTH)) & 
            s_reg_data(REG_SETADCBUFSIZE)(LOM_ADCBUF_DEPTH-1 downto 0);
      s_reg_set_values(REG_ADCBUFSIZE) <= s_adc_bufsize;
    end if;
  end process;

  process(s_clock)
    constant MAXBUFSIZE : t_reg_data := std_logic_vector(to_unsigned(2**LOM_ADCBUF_DEPTH,t_reg_data'length));
  begin
    if rising_edge(s_clock) then
      if s_set_bufsize = 0 then
        s_adc_bufsize <= MAXBUFSIZE; 
      else 
        s_adc_bufsize <= s_set_bufsize;
      end if;
    end if;
  end process;

  --===========================================================
	--           REG_FILE 
  --===========================================================
	reg_file_m_i : entity work.reg_file_m
	port map(
		i_clock                      => s_clock,
		reset                        => s_reset,

		i_set_values                 => s_reg_set_values,
		
		o_reg_data                   => s_reg_data,

		----- ethernet interface
		eth_reg_we                   => s_cpu_reg_we,
		eth_reg_num                  => s_cpu_reg_num,
		eth_reg_wdata                => s_cpu_reg_wdata,
		eth_reg_rdata                => s_cpu_reg_rdata
	);
  --===========================================================

  -- take ADC threshold values from corresponding registers
  ADC_THRESH_GEN : for iCHAN in 0 to 31 generate
    process(s_clock)
    begin
      if rising_edge(s_clock) then
        s_adc_thresholds(iCHAN) <= s_reg_data(REG_ADCTHRESH_1+iCHAN);
        s_sum_thresholds(iCHAN) <= s_reg_data(REG_ADC_S_THRESH_1+iCHAN);
      end if;
    end process;
  end generate ADC_THRESH_GEN; 
  
  process(s_clock)
  begin
    if rising_edge(s_clock) then
      s_adc_qthresholds <= s_reg_data(REG_ADC_Q_THRESH_1 to REG_ADC_Q_THRESH_1 + 31);
      s_bitshift        <= s_reg_data(REG_BITSHIFT1)(7 downto 0); -- for bad channel
      s_adc_lom_mask    <= s_reg_data(REG_ADC2_LOM_MASK) & s_reg_data(REG_ADC1_LOM_MASK) ;
      s_adc_buf_mask    <= s_reg_data(REG_ADC2_BUF_MASK) & s_reg_data(REG_ADC1_BUF_MASK) ;
    end if;
  end process; 
  --

  --===========================================================
	--          LOM ALGO
  --===========================================================
  lom_i : entity work.lom 
  port map (
    -- input ports
    i_clock            =>  s_clock,
    i_reset            =>  s_reset,
                      
    i_hrun_ext         =>  s_hrun_enable,        -- run/stop histograms
    i_hclear           =>  s_hclear_ctrl,        -- clear histograms
                                             
    i_crun_ext         =>  s_crun_enable,        -- run/stop counters
    i_cclear           =>  s_cclear_ctrl,        -- clear counters
                                             
    i_htest_mode       =>  s_htest_mode,         -- fill histograms with test values TODO: remove it
                                             
    i_adc_data         =>  s_adc_data,           -- input adc data
                                             
    i_adc_mask         =>  s_adc_lom_mask,       -- ADC mask 

    i_injveto          =>  s_injveto,
                                                
    i_adc_thresholds   =>  s_adc_thresholds,     -- discriminator thresholds
    i_sum_thresholds   =>  s_sum_thresholds,     -- discriminator thresholds
    i_adc_qthresholds  =>  s_adc_qthresholds,    -- thresholds for bhabha wuality signal
    i_discr_expand     =>  s_discr_expand,       -- duration of the signal from discriminator
    i_nevt             =>  s_nevt, -- number of events before stop
    i_dead_time_max    =>  s_dead_time_max,      -- duration of dead time signal
    i_clkmax           =>  s_clkmax,             -- measurement time
    i_trgtype          =>  s_buf_trgtype,

    o_trg              =>  s_buf_trg,

    o_lom_stat         =>  s_lom_stat,           -- output status

    o_arr_adc_amp      => s_arr_adc_amp,
    o_arr_sum_amp      => s_arr_sum_amp,
                          
    -- output counters    
    o_adc_cnt          =>  s_lom_adc_cnt,         
    o_sum_cnt          =>  s_lom_sum_cnt,         
    o_coi_cnt          =>  s_lom_coi_cnt,
    o_roi_cnt          =>  s_lom_roi_cnt,
    o_cmx_cnt          =>  s_lom_cmx_cnt,
    o_evt_cnt          =>  s_lom_evt_cnt,
    o_clk_cnt          =>  s_lom_clk_cnt,
    o_ded_cnt          =>  s_lom_ded_cnt,
    o_inj_cnt          =>  s_lom_inj_cnt,
    o_bha_raw_cnt      =>  s_lom_bha_raw_cnt, -- bhabha counter without quality flag
    o_bha_qua_cnt      =>  s_lom_bha_qua_cnt, -- bhabha counter with quality flag
    o_fake_cnt         =>  s_lom_fke_cnt,    -- fake bhabha counter

    -- read amplitude histograms from cpu
    i_hread_index      =>  s_hread_index,       
    i_hread_addr       =>  s_hread_baddr,
    o_hread_data       =>  s_hread_data,
                          
                          
    -- overflow flags     
    o_hist_overflow    =>  s_hist_overflow,
    o_cnt_overflow     =>  s_cnt_overflow
  );
  --===========================================================
  
  process(s_clock)
  begin
    if rising_edge(s_clock) then
      s_reg_set_values(REG_CNTOVERFLOW) <= s_cnt_overflow;
      s_dead_time_max        <= s_reg_data(REG_DEADTIME_H) & s_reg_data(REG_DEADTIME_L);
      s_discr_expand         <= s_reg_data(REG_TEXPAND);
      s_nevt                 <= s_reg_data(REG_NEVT);
      s_clkmax(31 downto 16) <= s_reg_data(REG_CLKMAX_H);
      s_clkmax(15 downto  0) <= s_reg_data(REG_CLKMAX_L);
    end if;
  end process;


  -----------------------------------------------------
  -- redirect counter values to CPU accessible registers
  -----------------------------------------------------

  process(s_clock)
  begin
    if rising_edge(s_clock) then
      -- "events" counter
      if s_push_mode = '0' or s_reg_push = '1' then
        s_reg_set_values(REG_EVTCNT)      <= s_lom_evt_cnt;

        -- clocks counter
        s_reg_set_values(REG_CLKCNT_LOW)  <= s_lom_clk_cnt(15 downto 0);
        s_reg_set_values(REG_CLKCNT_HIGH) <= s_lom_clk_cnt(31 downto 16);
        
        -- bhabha without quality
        s_reg_set_values(REG_BHARAW_CNT_L)    <= s_lom_bha_raw_cnt(15 downto 0);
        s_reg_set_values(REG_BHARAW_CNT_H)    <= s_lom_bha_raw_cnt(31 downto 16);
        
        -- bhabha with quality
        s_reg_set_values(REG_BHACNT_L)    <= s_lom_bha_qua_cnt(15 downto 0);
        s_reg_set_values(REG_BHACNT_H)    <= s_lom_bha_qua_cnt(31 downto 16);
        s_reg_set_values(REG_FAKECNT_L)   <= s_lom_fke_cnt(15 downto 0);
        s_reg_set_values(REG_FAKECNT_H)   <= s_lom_fke_cnt(31 downto 16);
        
        -- dead time
        s_reg_set_values(REG_DTCNT_L)     <= s_lom_ded_cnt(15 downto 0);
        s_reg_set_values(REG_DTCNT_H)     <= s_lom_ded_cnt(31 downto 16);

        -- injection time
        s_reg_set_values(REG_INJCNT_L)     <= s_lom_inj_cnt(15 downto 0);
        s_reg_set_values(REG_INJCNT_H)     <= s_lom_inj_cnt(31 downto 16);
      end if;
    end if;
  end process;

  ADCWIDTH_GEN : for i in 0 to 31 generate
    process(s_clock)
    begin
      if rising_edge(s_clock) then
        s_arr_adc_amp_r(i) <= B"0000" & s_arr_adc_amp(i+1);
        s_arr_sum_amp_r(i) <= B"000"  & s_arr_sum_amp(i+1);
      end if;
    end process;
  end generate ADCWIDTH_GEN;

  ADCREG_GEN : for i in 0 to 31 generate
    process(s_clock)
    begin
      if rising_edge(s_clock) then
        if s_push_mode = '0' or s_reg_push = '1' then
          s_reg_set_values(REG_ADCCNT_1 + i)  <= s_lom_adc_cnt(i);
          s_reg_set_values(REG_SUMCNT_1 + i)  <= s_lom_sum_cnt(i);
          s_reg_set_values(REG_ADCAMP_1 + i)  <= s_arr_adc_amp_r(i);
        end if;
      end if;
    end process;
  end generate ADCREG_GEN;

  COICNT_GEN : for j in 0 to 15 generate
    process(s_clock)
    begin
      if rising_edge(s_clock) then
        if s_push_mode = '0' or s_reg_push = '1' then
          s_reg_set_values(REG_COICNT_1 + j)  <= s_lom_coi_cnt(j);
          s_reg_set_values(REG_ROICNT_1 + j)  <= s_lom_roi_cnt(j);
        end if;
      end if;
    end process;
  end generate COICNT_GEN;
  
  --COIMATRIX_GEN : for j in 0 to 255 generate
    --process(s_clock)
    --begin
      --if rising_edge(s_clock) then
        --s_reg_set_values(REG_COIMATRIX_1 + j)  <= s_lom_cmx_cnt(j);
      --end if;
    --end process;
  --end generate COIMATRIX_GEN;
  -----------------------------------------------------


	-----------------------------------------------------
  -- control registers redirect
  CTRL_REG_PROC : process(s_clock)
  begin

    if rising_edge(s_clock) then
      s_buf_run_ctrl  <= s_reg_data(REG_LOMCTRL)(0);  -- start ADC buffer
      s_buf_run_stop  <= s_reg_data(REG_LOMCTRL)(1);  -- stop ADC buffer
      s_hclear_ctrl   <= s_reg_data(REG_LOMCTRL)(5);  -- clear histograms
      s_cclear_ctrl   <= s_reg_data(REG_LOMCTRL)(6) or s_reg_push ;  -- clear counters
      s_reg_push      <= s_reg_data(REG_LOMCTRL)(7);  -- clear counters
      s_bitslip_reset <= s_reg_data(REG_LOMCTRL)(14); -- bitslip reset (N/A)
      s_soft_reset    <= s_reg_data(REG_LOMCTRL)(15); -- reset signal to all components
      
    end if;
  end process CTRL_REG_PROC;

  -- operation mode register redirect
  MODE_REG_PROC : process(s_clock)
  begin

    if rising_edge(s_clock) then
      s_brun_enable   <= s_reg_data(REG_LOMMODE)(0);  -- enable/disable filling of ADC buffer
      s_hrun_enable   <= s_reg_data(REG_LOMMODE)(1);  -- enable/disable histograms filling
      s_crun_enable   <= s_reg_data(REG_LOMMODE)(2);  -- enable/disable counters
      s_htest_mode    <= s_reg_data(REG_LOMMODE)(3);  -- histograms are in test mode
      s_lomtest_mode  <= s_reg_data(REG_LOMMODE)(4);  -- test buffer mode
      s_testrun       <= s_reg_data(REG_LOMMODE)(5);  -- enable/disable test buffer
      s_push_mode     <= s_reg_data(REG_LOMMODE)(6);  -- output registers are updated only by command 
      s_buf_trgtype   <= s_reg_data(REG_LOMMODE)(15 downto 13); -- events type to be stored in the buffer
    end if;
  end process MODE_REG_PROC;

  -- status register redirect
  STATUS_REG_PROC : process(s_clock)
  begin
    if rising_edge(s_clock) then
      s_reg_set_values(REG_STATUS)(0) <= s_buf_run;          -- filling buffer running/stopped
      s_reg_set_values(REG_STATUS)(1) <= s_lom_stat(0);      --hrun_int
      s_reg_set_values(REG_STATUS)(2) <= s_lom_stat(1);      --crun_int
      s_reg_set_values(REG_STATUS)(3) <= s_htest_mode;       -- histograms are filled with test values (TODO remove)
      s_reg_set_values(REG_STATUS)(4) <= s_lomtest_mode;     -- setlf test mode on/off
      s_reg_set_values(REG_STATUS)(5) <= s_hrun_enable;      -- histograms enabled disabled
      s_reg_set_values(REG_STATUS)(6) <= s_crun_enable;      -- counters enabled/disabled
      s_reg_set_values(REG_STATUS)(7) <= s_brun_enable;      -- adc buffer enabled/disabled
      s_reg_set_values(REG_STATUS)(8) <= s_hist_overflow;    -- histograms overflow flag
      s_reg_set_values(REG_STATUS)(9) <= s_cnt_overflow(15); -- counters overflow flag
      -- ttd status
      s_reg_set_values(REG_STATUS)(13) <= s_b2clk_is_up;     -- 
      s_reg_set_values(REG_STATUS)(14) <= s_b2tt_is_up;      -- 
      s_reg_set_values(REG_STATUS)(15) <= s_exp_is_running;  -- 
    end if;
  end process STATUS_REG_PROC;


  --===========================================================
  -- LOM TESTER ---------------------------------------
  -- provides test waveform samples to the input 
  -- of adc_ctrl component
  --===========================================================
  self_tester_i : entity work.self_tester 
  port map (
    i_clock          =>  s_clock,
    i_reset          =>  s_reset,
    i_run            =>  s_testrun,                -- on/off tester

    i_enable         =>  s_lomtest_enable,         -- enable signal to increment address 
    i_nevents        =>  s_reg_data(REG_NTESTEVT), -- number events to generate
    i_cntclear       =>  s_cclear_ctrl,            -- clear counter of generated events
    
    -- output data
    o_testbuf_data   =>  s_lomtest_data,
    
    -- read/write from CPU
    i_testbuf_index  =>  s_lomtest_buf_index,
    i_testbuf_we     =>  s_lomtest_buf_we,
    i_testbuf_wdata  =>  s_lomtest_buf_wdata,
    i_testbuf_addr   =>  s_lomtest_buf_raddr,
    o_testbuf_rdata  =>  s_lomtest_buf_rdata
  );
  --===========================================================



  --===========================================================
	--          MEMORY FILE 
  --===========================================================
  mem_file_i : entity work.mem_file
	port map ( 
		i_clock          => s_clock, 
    i_reset          => s_reset,
    -- cpu eth interface 
    i_mem_addr       => s_cpu_mem_addr,
    i_mem_wdata      => s_cpu_mem_wdata,
    o_mem_rdata      => s_cpu_mem_rdata,
    i_mem_wena       => s_cpu_mem_we,
    -- access to the adc buffer
		o_adcbuf_raddr   => s_adc_buf_raddr,
		i_adcbuf_rdata   => s_adc_buf_rdata,
		i_sumbuf_rdata   => s_sum_buf_rdata,
    -- access to the histograms
    o_histo_index    => s_hread_index,   -- index of the histogram 
    o_histo_baddr    => s_hread_baddr,   -- bin address
    i_histo_rdata    => s_hread_data,
    -- access to the lomtest fuffer
    o_lomtest_raddr  => s_lomtest_buf_raddr,
    o_lomtest_index  => s_lomtest_buf_index,
    i_lomtest_rdata  => s_lomtest_buf_rdata,
    o_lomtest_we     => s_lomtest_buf_we,
    o_lomtest_wdata  => s_lomtest_buf_wdata
  );
  --===========================================================

	---- TEST POINTS
	TP(3) <= s_fadc_sclk;
	TP(4) <= s_fadc_sdio;
	TP(5) <= s_fadc_csb(0);
	TP(6) <= (not s_fadc_csb(3)) or (not s_fadc_csb(2)) or (not s_fadc_csb(1)) or (not s_fadc_csb(0));
	TP(7) <= s_adc_data(4)(0);
	TP(8) <= '0'; 
	-------------------

  -- TEMPORARY
	process(s_clock)
	begin
		if s_clock'event and s_clock='1' then
			if PG = B"10101" then
				tp2_r <= CLK_MODE and not tp2_r;
			end if;
		end if;
	end process;
	

	CPU_LED <= s_cpu_led(31);


  -- RESET ------------------------------------------
	s_sys_reset   <= RESET_P;
	s_sys_reset_n <= not s_sys_reset;
  
  RESET : process(s_clock)
  begin
    if rising_edge(s_clock) then
      s_reset <= s_soft_reset or s_sys_reset;
    end if;
  end process RESET;
  ---------------------------------------------------



  -- trigger for adc buffers
	TRG_PROC : process(s_clock)
	begin
		if rising_edge(s_clock) then
			s_buf_run <= s_buf_run;
      if s_buf_trg = '1' then
        s_adc_trig <= '1';
        s_counter <= (others => '0');
			end if;
      if s_adc_trig = '1' then
				s_counter <= s_counter + '1';
      else
        s_counter <= (others => '0');
      end if;
      -- 1 sample_clock = 4 x sys_clock
			if s_counter(17 downto 2) = s_reg_data(REG_ADCSTOP) then
				s_counter  <= (others => '0');
				s_buf_run  <= '0';
        s_adc_trig <= '0';
			end if;
      if s_buf_run_ctrl = '1' then
        s_buf_run <= '1';
        s_adc_trig <= '0'; --FIXME
      end if;
      if s_buf_run_stop = '1' then
        s_buf_run <= '0';
        s_adc_trig <= '0'; -- FIXME
      end if;
      if s_brun_enable = '0' then
        s_buf_run <= '0';
        s_adc_trig <= '0'; -- FIXME
      end if;
		end if;
	end process TRG_PROC;
  ----------------------------------------------------------------------

  ----------------------------------------------------------------------
  -- b2tt
  ----------------------------------------------------------------------
  map_b2tt: entity work.b2tt
    generic map (
--      SUBSYSTEM => TTFEE_ECL, --      same as B2LFEE_ECL
      FWTYPE    => 15,  -- 4-bit
      VERSION   => VERSION,
      FLIPACK   => '0',
      USEICTRL  => '0',
      USEPLL    => '1',
      USEFIFO   => '0' )
    port map (
      -- b2tt version
      b2ttver  => open, -- out 15:0

      -- RJ-45
      clkp     => TTD_CLK_P,
      clkn     => TTD_CLK_N,
      trgp     => TTD_TRG_P,
      trgn     => TTD_TRG_N,
      ackp     => open,  -- LOM is in read only mode
      ackn     => open,  -- LOM is in read only mode
      rsvp     => open,
      rsvn     => open,

      -- alternative external clock source
      extclk    => '0',
      extclkinv => '0',
      extclkdbl => '0',
      extdblinv => '0',
      extclklck => '0',

      -- board id
      id       => (others => '0'),
      
      -- user register
      usrreg   => open,
      usrdat   => x"0000",
       
      -- link status
      b2clkup  => sig_clkup,
      b2ttup   => sig_ttup,

      -- system clock and time
      sysclk   => clk_127,
      rawclk   => sig_raw127,
      dblclk   => clk_254,
      utime    => open_utime,
      ctime    => open_ctime,

      -- divided clock
      divclk1  => open_divclk1,
      divclk2  => open_divclk2,

      -- run reset
      exprun   => open_exprun,
      running  => open_running,
      runreset => open_runreset,
      feereset => open_feereset,
      b2lreset => open_b2lreset,
      gtpreset => open_gtpreset,

      -- trigger
      trgout   => s_trg,
      trgtyp   => open_trgtyp,
      trgtag   => s_trgtag,
      
      -- revolution
      frame    => open, -- out
      frame9   => open, -- out
      revoloc  => open, -- out 10:0
      revosig  => sig_revo, -- out
      abortgap => open, -- out
      injveto  => s_injveto,
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
      regdbg   => reg_dbg,
      octet    => open_octet,
      isk      => open_isk,
      cntbit2  => open_cntbit2,
      sigbit2  => open_sigbit2,
      dbglink  => sig_dbg,
      dbgerr   => open );


  --- REDIRECT B2TT DATA TO REGISTERS
  process(s_clock)
  begin
    if rising_edge(s_clock) then
      
      s_reg_set_values(REG_TTDRUN)(15 downto 14)   <= B"00";
      s_reg_set_values(REG_TTDRUN)(13 downto 0)    <= open_exprun(21 downto 8);
      s_reg_set_values(REG_TTDEXP)(15 downto 10)   <= B"000000";
      s_reg_set_values(REG_TTDEXP)(9 downto 0)     <= open_exprun(31 downto 22);

      s_reg_set_values(REG_TTDUTIME_H) <= s_ttd_utime_d(31 downto 16);
      s_reg_set_values(REG_TTDUTIME_L) <= s_ttd_utime_d(15 downto 0);

      -- data to insert in the status register
      s_exp_is_running                  <= open_running;
      s_exp_run_reset                   <= open_runreset;
      s_b2tt_is_up                      <= sig_ttup;
      s_b2clk_is_up                     <= sig_clkup;
      s_ttd_utime                       <= open_utime;
      s_ttd_utime_d                     <= s_ttd_utime;

    end if;
  end process;

  -- receive DAQ busy signal through TTD_ACK pair of lines
  mod3rx_i : entity work.o_mod3rx 
    port map (
      clock => clk_127,
      reset => s_reset,
      inp   => TTD_ACK_P,
      inn   => TTD_ACK_N,
      state => ttd_busy );

  process(s_clock)
  begin
    if rising_edge(s_clock) then
      s_ttd_busy   <= ttd_busy;
      s_ttd_busy_d <= s_ttd_busy;
    end if;
  end process;

end behavioral;






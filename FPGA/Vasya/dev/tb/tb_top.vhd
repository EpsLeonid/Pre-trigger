--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:13:51 02/22/2014
-- Design Name:   
-- Module Name:   C:/work/KEK/Hardware/LOM/v1.0/FPGA_Designs/v1.0/tb_top.vhd
-- Project Name:  LOM
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
   

   --Inputs
   signal CLK_50MHZ : std_logic := '0';
   signal OSC_50MHZ : std_logic := '0';
   signal RESET_P : std_logic := '0';
   signal SYS_RST : std_logic := '0';
   signal SDATAP : std_logic_vector(32 downto 1) := (others => '0');
   signal SDATAN : std_logic_vector(32 downto 1) := (others => '0');
   signal DCOP : std_logic_vector(4 downto 1) := (others => '0');
   signal DCON : std_logic_vector(4 downto 1) := (others => '0');
   signal FCOP : std_logic_vector(4 downto 1) := (others => '0');
   signal FCON : std_logic_vector(4 downto 1) := (others => '0');

   --signal EMU_CPU_MEM_ADDR : std_logic_vector(31 downto 0) := (others => '0');

	signal PG       : std_logic_vector(5 downto 1) := (others=>'0');
	signal CLK_MODE : std_logic := '0';
	signal VETO     : std_logic := '0';
	

	--BiDirs
   signal ADC_SDIO : std_logic := '0';
   signal DDR3_LDQS_P : std_logic := '0';
   signal DDR3_LDQS_N : std_logic := '0';
   signal DDR3_UDQS_P : std_logic := '0';
   signal DDR3_UDQS_N : std_logic := '0';
   signal DDR3_DQ : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal TP : std_logic_vector(8 downto 3) := (others => '0');
   signal ADC_SCLK : std_logic := '0';
   signal ADC_CSB : std_logic_vector(4 downto 1) := (others => '0');
   signal ADC_CLKP : std_logic_vector(4 downto 1) := (others=>'0');
   signal ADC_CLKN : std_logic_vector(4 downto 1) := (others=>'1');
   signal DDR3_CLK_P : std_logic := '0';
   signal DDR3_CLK_N : std_logic := '0';
   signal DDR3_CKE : std_logic := '0';
   signal DDR3_WE_B : std_logic := '0';
   signal DDR3_CAS_B : std_logic := '0';
   signal DDR3_RAS_B : std_logic := '0';
   signal DDR3_LDM : std_logic := '0';
   signal DDR3_UDM : std_logic := '0';
   signal DDR3_BA : std_logic_vector(2 downto 0) := (others => '0');
   signal DDR3_A : std_logic_vector(12 downto 0) := (others => '0');
   signal DDR3_ODT : std_logic := '0';
   signal DDR3_RST_B : std_logic := '0';

   signal II_SPI_SCK : std_logic := '0';
   signal II_SPI_MISO : std_logic := '0';
   signal II_SPI_MOSI : std_logic := '0';
   signal II_SPI_CS_B : std_logic := '0';

-- I2C
   signal IIC_SDA : std_logic := '0';
   signal IIC_SCL : std_logic := '0';

-- Ethernet	
   signal ETH_RST_B : std_logic := '0';
   signal ETH_TXD : std_logic_vector(7 downto 0) := (others => '0');
   signal ETH_TX_EN : std_logic := '0';
   signal ETH_TX_ER : std_logic := '0';
   signal ETH_MII_TX_CLK : std_logic := '0';
   signal ETH_TX_CLK : std_logic := '0';
   signal ETH_RXD : std_logic_vector(7 downto 0) := (others => '0');
   signal ETH_RX_DV : std_logic := '0';
   signal ETH_RX_ER : std_logic := '0';
   signal ETH_RX_CLK : std_logic := '0';
   signal ETH_MDC :    std_logic := '0';
   signal ETH_MDIO :   std_logic := '0';
   signal ETH_MDINT :  std_logic := '0';
	
   signal CPU_LED :  std_logic := '0';
   signal CPU_JMP :  std_logic_vector(0 to 1) := (others=>'0');

    signal s_sim_eth_reg_we     : std_logic := '0';
    signal s_sim_eth_reg_num    : std_logic_vector(15 downto 0) := (others => '0'); 
    signal s_sim_eth_reg_wdata  : std_logic_vector(15 downto 0) := (others => '0');
    signal s_sim_eth_reg_rdata  : std_logic_vector(15 downto 0) := (others => '0');

  signal s_ttd_clk_p : std_logic := '0';
  signal s_ttd_clk_n : std_logic := '0';
  signal s_ttd_trg_p : std_logic := '0';
  signal s_ttd_trg_n : std_logic := '0';

   -- Clock period definitions
   constant CLK_50MHz_period : time := 20 ns;
   constant ADC_SCLK_period : time := 10 ns;


  signal sys_clock : std_logic;
   signal clk_cnt : integer := 0;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.top 
	PORT MAP (
    OSC_50MHZ => OSC_50MHZ,
  -- 		 	 osc_50mhz => osc_50mhz,
    RESET_P => RESET_P,
    SYS_RST => SYS_RST,
    TP => TP,
    ADC_CLKP => ADC_CLKP,
    ADC_CLKN => ADC_CLKN,
    SDATAP => SDATAP,
    SDATAN => SDATAN,
    DCOP => DCOP,
    DCON => DCON,
    FCOP => FCOP,
    FCON => FCON,
    VETO => VETO,
    PG => PG,
    CLK_MODE => CLK_MODE,
			 
      --EMU_CPU_MEM_ADDR => EMU_CPU_MEM_ADDR, --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- SPI flash memory
    II_SPI_SCK  => II_SPI_SCK,
    II_SPI_MISO => II_SPI_MISO,
    II_SPI_MOSI => II_SPI_MOSI,
    II_SPI_CS_B => II_SPI_CS_B,

-- I2C
			IIC_SDA => IIC_SDA,
			IIC_SCL => IIC_SCL,

-- Ethernet	
			ETH_RST_B  => ETH_RST_B,
			ETH_TXD    => ETH_TXD,
			ETH_TX_EN  => ETH_TX_EN,
			ETH_TX_ER  => ETH_TX_ER,
			ETH_MII_TX_CLK => ETH_MII_TX_CLK,
			ETH_TX_CLK => ETH_TX_CLK,
			ETH_RXD    => ETH_RXD,
			ETH_RX_DV  => ETH_RX_DV,
			ETH_RX_ER  => ETH_RX_ER,
			ETH_RX_CLK => ETH_RX_CLK,
			ETH_MDC    => ETH_MDC,
			ETH_MDIO   => ETH_MDIO,
			ETH_MDINT  => ETH_MDINT,

      TTD_CLK_P => s_ttd_clk_p,
      TTD_CLK_N => s_ttd_clk_n,
      TTD_TRG_P => s_ttd_trg_p,
      TTD_TRG_N => s_ttd_trg_n,
      TTD_ACK_P => open,
      TTD_ACK_N => open,
      TTD_RSV_P => open,
      TTD_RSV_N => open,
			 
			 
      DDR3_LDQS_P => DDR3_LDQS_P,
      DDR3_LDQS_N => DDR3_LDQS_N,
      DDR3_UDQS_P => DDR3_UDQS_P,
      DDR3_UDQS_N => DDR3_UDQS_N,
      DDR3_DQ => DDR3_DQ,
      DDR3_CLK_P => DDR3_CLK_P,
      DDR3_CLK_N => DDR3_CLK_N,
      DDR3_CKE => DDR3_CKE,
      DDR3_WE_B => DDR3_WE_B,
      DDR3_CAS_B => DDR3_CAS_B,
      DDR3_RAS_B => DDR3_RAS_B,
      DDR3_LDM => DDR3_LDM,
      DDR3_UDM => DDR3_UDM,
      DDR3_BA => DDR3_BA,
      DDR3_A => DDR3_A,
      DDR3_ODT => DDR3_ODT,
      DDR3_RST_B => DDR3_RST_B,
			 
      CPU_LED => CPU_LED,
      CPU_JMP => CPU_JMP,

      SIM_ETH_REG_WE    => s_sim_eth_reg_we,
      SIM_ETH_REG_NUM   => s_sim_eth_reg_num,
      SIM_ETH_REG_WDATA => s_sim_eth_reg_wdata,
      SIM_ETH_REG_RDATA => s_sim_eth_reg_rdata,
      SIM_SYS_CLK       => sys_clock
  );


 tb_adc1 : entity work.tb_adc_8ch_12bits
generic map(
	module_name => "adc1",
	ch1_file => "../tb/../tb/tb_inout/adc_ch1.txt",
	ch2_file => "../tb/../tb/tb_inout/adc_ch2.txt",
	ch3_file => "../tb/../tb/tb_inout/adc_ch3.txt",
	ch4_file => "../tb/../tb/tb_inout/adc_ch4.txt",
	ch5_file => "../tb/../tb/tb_inout/adc_ch5.txt",
	ch6_file => "../tb/../tb/tb_inout/adc_ch6.txt",
	ch7_file => "../tb/../tb/tb_inout/adc_ch7.txt",
	ch8_file => "../tb/../tb/tb_inout/adc_ch8.txt")
port map(
	CLKP => ADC_CLKP(1),
	CLKN => ADC_CLKN(1),
	
	DCOP => DCOP(1),
	DCON => DCON(1),
	
	FCOP => FCOP(1),
	FCON => FCON(1),
	
	DOAP => SDATAP(1),
	DOAN => SDATAN(1),

	DOBP => SDATAP(2),
	DOBN => SDATAN(2),

	DOCP => SDATAP(3),
	DOCN => SDATAN(3),

	DODP => SDATAP(4),
	DODN => SDATAN(4),

	DOEP => SDATAP(5),
	DOEN => SDATAN(5),

	DOFP => SDATAP(6),
	DOFN => SDATAN(6),
	
	DOGP => SDATAP(7),
	DOGN => SDATAN(7),

	DOHP => SDATAP(8),
	DOHN => SDATAN(8),

	CSN  => ADC_CSB(1),
	SDIO => ADC_SDIO,
	SCLK => ADC_SCLK);

tb_adc2 : entity work.tb_adc_8ch_12bits
generic map(
	module_name => "adc2",
	ch1_file => "../tb/tb_inout/adc_ch9.txt",
	ch2_file => "../tb/tb_inout/adc_ch10.txt",
	ch3_file => "../tb/tb_inout/adc_ch11.txt",
	ch4_file => "../tb/tb_inout/adc_ch12.txt",
	ch5_file => "../tb/tb_inout/adc_ch13.txt",
	ch6_file => "../tb/tb_inout/adc_ch14.txt",
	ch7_file => "../tb/tb_inout/adc_ch15.txt",
	ch8_file => "../tb/tb_inout/adc_ch16.txt")
port map(
	CLKP => ADC_CLKP(2),
	CLKN => ADC_CLKN(2),
	
	DCOP => DCOP(2),
	DCON => DCON(2),
	
	FCOP => FCOP(2),
	FCON => FCON(2),
	
	DOAP => SDATAP(9),
	DOAN => SDATAN(9),

	DOBP => SDATAP(10),
	DOBN => SDATAN(10),

	DOCP => SDATAP(11),
	DOCN => SDATAN(11),

	DODP => SDATAP(12),
	DODN => SDATAN(12),

	DOEP => SDATAP(13),
	DOEN => SDATAN(13),

	DOFP => SDATAP(14),
	DOFN => SDATAN(14),
	
	DOGP => SDATAP(15),
	DOGN => SDATAN(15),

	DOHP => SDATAP(16),
	DOHN => SDATAN(16),

	CSN  => ADC_CSB(2),
	SDIO => ADC_SDIO,
	SCLK => ADC_SCLK);

tb_adc3 : entity work.tb_adc_8ch_12bits
generic map(
	module_name => "adc3",
	ch1_file => "../tb/tb_inout/adc_ch17.txt",
	ch2_file => "../tb/tb_inout/adc_ch18.txt",
	ch3_file => "../tb/tb_inout/adc_ch19.txt",
	ch4_file => "../tb/tb_inout/adc_ch20.txt",
	ch5_file => "../tb/tb_inout/adc_ch21.txt",
	ch6_file => "../tb/tb_inout/adc_ch22.txt",
	ch7_file => "../tb/tb_inout/adc_ch23.txt",
	ch8_file => "../tb/tb_inout/adc_ch24.txt")
port map(
	CLKP => ADC_CLKP(3),
	CLKN => ADC_CLKN(3),
	
	DCOP => DCOP(3),
	DCON => DCON(3),
	
	FCOP => FCOP(3),
	FCON => FCON(3),
	
	DOAP => SDATAP(17),
	DOAN => SDATAN(17),

	DOBP => SDATAP(18),
	DOBN => SDATAN(18),

	DOCP => SDATAP(19),
	DOCN => SDATAN(19),

	DODP => SDATAP(20),
	DODN => SDATAN(20),

	DOEP => SDATAP(21),
	DOEN => SDATAN(21),

	DOFP => SDATAP(22),
	DOFN => SDATAN(22),
	
	DOGP => SDATAP(23),
	DOGN => SDATAN(23),

	DOHP => SDATAP(24),
	DOHN => SDATAN(24),

	CSN  => ADC_CSB(3),
	SDIO => ADC_SDIO,
	SCLK => ADC_SCLK);

tb_adc4 : entity work.tb_adc_8ch_12bits
generic map(
	module_name => "adc4",
	ch1_file => "../tb/tb_inout/adc_ch25.txt",
	ch2_file => "../tb/tb_inout/adc_ch26.txt",
	ch3_file => "../tb/tb_inout/adc_ch27.txt",
	ch4_file => "../tb/tb_inout/adc_ch28.txt",
	ch5_file => "../tb/tb_inout/adc_ch29.txt",
	ch6_file => "../tb/tb_inout/adc_ch30.txt",
	ch7_file => "../tb/tb_inout/adc_ch31.txt",
	ch8_file => "../tb/tb_inout/adc_ch32.txt")
port map(
	CLKP => ADC_CLKP(4),
	CLKN => ADC_CLKN(4),
	
	DCOP => DCOP(4),
	DCON => DCON(4),
	
	FCOP => FCOP(4),
	FCON => FCON(4),
	
	DOAP => SDATAP(25),
	DOAN => SDATAN(25),

	DOBP => SDATAP(26),
	DOBN => SDATAN(26),

	DOCP => SDATAP(27),
	DOCN => SDATAN(27),

	DODP => SDATAP(28),
	DODN => SDATAN(28),

	DOEP => SDATAP(29),
	DOEN => SDATAN(29),

	DOFP => SDATAP(30),
	DOFN => SDATAN(30),
	
	DOGP => SDATAP(31),
	DOGN => SDATAN(31),

	DOHP => SDATAP(32),
	DOHN => SDATAN(32),

	CSN  => ADC_CSB(4),
	SDIO => ADC_SDIO,
	SCLK => ADC_SCLK);


 -- Clock process definitions
 CLK_50MHz_process :process
 begin
  CLK_50MHz <= '0';
  OSC_50MHZ <= '0';
  wait for CLK_50MHz_period/2;
  CLK_50MHz <= '1';
  OSC_50MHZ <= '1';
  wait for CLK_50MHz_period/2;
 end process;

process(sys_clock)
begin
  if rising_edge(sys_clock) then
    clk_cnt <= clk_cnt + 1;
    
    s_sim_eth_reg_we <= '0';
    if clk_cnt = 100 then
      s_sim_eth_reg_we <= '1';
      s_sim_eth_reg_num   <= X"0002";
      s_sim_eth_reg_wdata <= X"0000";
    end if;
  
  end if;
end process;
 
process
begin

  --EMU_CPU_MEM_ADDR <= X"8000_0000"; 
	RESET_P <= '0';
	SYS_RST <= '0';
	wait for 1 us;
	RESET_P <= '1';
	SYS_RST <= '1';
  --EMU_CPU_MEM_ADDR <= X"8000_0008"; 
	wait for 1 us;
	RESET_P <= '0';
	SYS_RST <= '0';
  --EMU_CPU_MEM_ADDR <= X"8000_0008"; 
	--wait for 1 us;
  wait;
end process;

 
END;

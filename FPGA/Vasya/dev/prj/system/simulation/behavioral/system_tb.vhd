-------------------------------------------------------------------------------
-- system_tb.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

-- START USER CODE (Do not remove this line)

-- User: Put your libraries here. Code in this
--       section will not be overwritten.

-- END USER CODE (Do not remove this line)

entity system_tb is
end system_tb;

architecture STRUCTURE of system_tb is

  constant OSC_50MHZ_PERIOD : time := 20000.000000 ps;
  constant SYS_RST_LENGTH : time := 320000 ps;

  component system is
    port (
      ETH_RST_B : out std_logic;
      ETH_TXD : out std_logic_vector(7 downto 0);
      ETH_TX_EN : out std_logic;
      ETH_TX_ER : out std_logic;
      ETH_TX_CLK : out std_logic;
      ETH_RXD : in std_logic_vector(7 downto 0);
      ETH_RX_DV : in std_logic;
      ETH_RX_ER : in std_logic;
      ETH_RX_CLK : in std_logic;
      ETH_MDC : out std_logic;
      ETH_MDIO : inout std_logic;
      ETH_MDINT : in std_logic;
      CPU_JMP : in std_logic_vector(0 to 1);
      DDR3_A : out std_logic_vector(12 downto 0);
      DDR3_BA : out std_logic_vector(2 downto 0);
      DDR3_RAS_B : out std_logic;
      DDR3_CAS_B : out std_logic;
      DDR3_WE_B : out std_logic;
      DDR3_CKE : out std_logic;
      DDR3_CLK : out std_logic;
      DDR3_CLK_B : out std_logic;
      DDR3_DQ : inout std_logic_vector(15 downto 0);
      DDR3_LDQS_P : inout std_logic;
      DDR3_LDQS_N : inout std_logic;
      DDR3_UDQS_P : inout std_logic;
      DDR3_UDQS_N : inout std_logic;
      DDR3_UDM : out std_logic;
      DDR3_LDM : out std_logic;
      DDR3_ODT : out std_logic;
      DDR3_RST_B : out std_logic;
      DDR3_RZQ : inout std_logic;
      DDR3_ZIO : inout std_logic;
      II_SPI_SCK : out std_logic;
      II_SPI_MISO : in std_logic;
      II_SPI_MOSI : out std_logic;
      II_SPI_CS_B : out std_logic;
      OSC_50MHZ : in std_logic;
      SYS_RST : in std_logic;
      ETH_MII_TX_CLK : in std_logic;
      CPU_LED : out std_logic_vector(0 to 31);
      IIC_SDA : inout std_logic;
      IIC_SCL : inout std_logic;
      mem_addr : out std_logic_vector(31 downto 0);
      mem_wdata : out std_logic_vector(15 downto 0);
      mem_rdata : in std_logic_vector(15 downto 0);
      mem_we : out std_logic;
      reg_we : out std_logic;
      reg_num : out std_logic_vector(15 downto 0);
      reg_wdata : out std_logic_vector(15 downto 0);
      reg_rdata : in std_logic_vector(15 downto 0);
      clock : in std_logic;
      clock_locked : out std_logic;
      sys_clock : out std_logic;
      clock_generator_0_CLKOUT4_pin : out std_logic;
      FADC_SPI_SCK_O : out std_logic;
      FADC_SPI_MOSI_O : out std_logic;
      FADC_SPI_SS_O : out std_logic_vector(0 to 3)
    );
  end component;

  -- Internal signals

  signal CPU_JMP : std_logic_vector(0 to 1);
  signal CPU_LED : std_logic_vector(0 to 31);
  signal DDR3_A : std_logic_vector(12 downto 0);
  signal DDR3_BA : std_logic_vector(2 downto 0);
  signal DDR3_CAS_B : std_logic;
  signal DDR3_CKE : std_logic;
  signal DDR3_CLK : std_logic;
  signal DDR3_CLK_B : std_logic;
  signal DDR3_DQ : std_logic_vector(15 downto 0);
  signal DDR3_LDM : std_logic;
  signal DDR3_LDQS_N : std_logic;
  signal DDR3_LDQS_P : std_logic;
  signal DDR3_ODT : std_logic;
  signal DDR3_RAS_B : std_logic;
  signal DDR3_RST_B : std_logic;
  signal DDR3_RZQ : std_logic;
  signal DDR3_UDM : std_logic;
  signal DDR3_UDQS_N : std_logic;
  signal DDR3_UDQS_P : std_logic;
  signal DDR3_WE_B : std_logic;
  signal DDR3_ZIO : std_logic;
  signal ETH_MDC : std_logic;
  signal ETH_MDINT : std_logic;
  signal ETH_MDIO : std_logic;
  signal ETH_MII_TX_CLK : std_logic;
  signal ETH_RST_B : std_logic;
  signal ETH_RXD : std_logic_vector(7 downto 0);
  signal ETH_RX_CLK : std_logic;
  signal ETH_RX_DV : std_logic;
  signal ETH_RX_ER : std_logic;
  signal ETH_TXD : std_logic_vector(7 downto 0);
  signal ETH_TX_CLK : std_logic;
  signal ETH_TX_EN : std_logic;
  signal ETH_TX_ER : std_logic;
  signal FADC_SPI_MOSI_O : std_logic;
  signal FADC_SPI_SCK_O : std_logic;
  signal FADC_SPI_SS_O : std_logic_vector(0 to 3);
  signal IIC_SCL : std_logic;
  signal IIC_SDA : std_logic;
  signal II_SPI_CS_B : std_logic;
  signal II_SPI_MISO : std_logic;
  signal II_SPI_MOSI : std_logic;
  signal II_SPI_SCK : std_logic;
  signal OSC_50MHZ : std_logic;
  signal SYS_RST : std_logic;
  signal clock : std_logic;
  signal clock_generator_0_CLKOUT4_pin : std_logic;
  signal clock_locked : std_logic;
  signal mem_addr : std_logic_vector(31 downto 0);
  signal mem_rdata : std_logic_vector(15 downto 0);
  signal mem_wdata : std_logic_vector(15 downto 0);
  signal mem_we : std_logic;
  signal reg_num : std_logic_vector(15 downto 0);
  signal reg_rdata : std_logic_vector(15 downto 0);
  signal reg_wdata : std_logic_vector(15 downto 0);
  signal reg_we : std_logic;
  signal sys_clock : std_logic;

  -- START USER CODE (Do not remove this line)

  -- User: Put your signals here. Code in this
  --       section will not be overwritten.

  -- END USER CODE (Do not remove this line)

begin

  dut : system
    port map (
      ETH_RST_B => ETH_RST_B,
      ETH_TXD => ETH_TXD,
      ETH_TX_EN => ETH_TX_EN,
      ETH_TX_ER => ETH_TX_ER,
      ETH_TX_CLK => ETH_TX_CLK,
      ETH_RXD => ETH_RXD,
      ETH_RX_DV => ETH_RX_DV,
      ETH_RX_ER => ETH_RX_ER,
      ETH_RX_CLK => ETH_RX_CLK,
      ETH_MDC => ETH_MDC,
      ETH_MDIO => ETH_MDIO,
      ETH_MDINT => ETH_MDINT,
      CPU_JMP => CPU_JMP,
      DDR3_A => DDR3_A,
      DDR3_BA => DDR3_BA,
      DDR3_RAS_B => DDR3_RAS_B,
      DDR3_CAS_B => DDR3_CAS_B,
      DDR3_WE_B => DDR3_WE_B,
      DDR3_CKE => DDR3_CKE,
      DDR3_CLK => DDR3_CLK,
      DDR3_CLK_B => DDR3_CLK_B,
      DDR3_DQ => DDR3_DQ,
      DDR3_LDQS_P => DDR3_LDQS_P,
      DDR3_LDQS_N => DDR3_LDQS_N,
      DDR3_UDQS_P => DDR3_UDQS_P,
      DDR3_UDQS_N => DDR3_UDQS_N,
      DDR3_UDM => DDR3_UDM,
      DDR3_LDM => DDR3_LDM,
      DDR3_ODT => DDR3_ODT,
      DDR3_RST_B => DDR3_RST_B,
      DDR3_RZQ => DDR3_RZQ,
      DDR3_ZIO => DDR3_ZIO,
      II_SPI_SCK => II_SPI_SCK,
      II_SPI_MISO => II_SPI_MISO,
      II_SPI_MOSI => II_SPI_MOSI,
      II_SPI_CS_B => II_SPI_CS_B,
      OSC_50MHZ => OSC_50MHZ,
      SYS_RST => SYS_RST,
      ETH_MII_TX_CLK => ETH_MII_TX_CLK,
      CPU_LED => CPU_LED,
      IIC_SDA => IIC_SDA,
      IIC_SCL => IIC_SCL,
      mem_addr => mem_addr,
      mem_wdata => mem_wdata,
      mem_rdata => mem_rdata,
      mem_we => mem_we,
      reg_we => reg_we,
      reg_num => reg_num,
      reg_wdata => reg_wdata,
      reg_rdata => reg_rdata,
      clock => clock,
      clock_locked => clock_locked,
      sys_clock => sys_clock,
      clock_generator_0_CLKOUT4_pin => clock_generator_0_CLKOUT4_pin,
      FADC_SPI_SCK_O => FADC_SPI_SCK_O,
      FADC_SPI_MOSI_O => FADC_SPI_MOSI_O,
      FADC_SPI_SS_O => FADC_SPI_SS_O
    );

  -- Clock generator for OSC_50MHZ

  process
  begin
    OSC_50MHZ <= '0';
    loop
      wait for (OSC_50MHZ_PERIOD/2);
      OSC_50MHZ <= not OSC_50MHZ;
    end loop;
  end process;

  -- Reset Generator for SYS_RST

  process
  begin
    SYS_RST <= '1';
    wait for (SYS_RST_LENGTH);
    SYS_RST <= not SYS_RST;
    wait;
  end process;

  -- START USER CODE (Do not remove this line)

  -- User: Put your stimulus here. Code in this
  --       section will not be overwritten.

  -- END USER CODE (Do not remove this line)

end architecture STRUCTURE;


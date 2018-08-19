-------------------------------------------------------------------------------
-- system_top.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_top is
  port (
    FLASH_A : out std_logic_vector(0 to 31);
    FLASH_RST_N : out std_logic;
    FLASH_CE_B : out std_logic_vector(0 to 3);
    FLASH_OE_B : out std_logic_vector(0 to 3);
    FLASH_WE_B : out std_logic;
    FLASH_DQ : inout std_logic_vector(0 to 15);
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
    CPU_LED : out std_logic_vector(0 to 2);
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
    FLASH_ADV_B : out std_logic
  );
end system_top;

architecture STRUCTURE of system_top is

  component system is
    port (
      FLASH_A : out std_logic_vector(0 to 31);
      FLASH_RST_N : out std_logic;
      FLASH_CE_B : out std_logic_vector(0 to 3);
      FLASH_OE_B : out std_logic_vector(0 to 3);
      FLASH_WE_B : out std_logic;
      FLASH_DQ : inout std_logic_vector(0 to 15);
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
      CPU_LED : out std_logic_vector(0 to 2);
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
      FLASH_ADV_B : out std_logic
    );
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system : component is "user_black_box";

begin

  system_i : system
    port map (
      FLASH_A => FLASH_A,
      FLASH_RST_N => FLASH_RST_N,
      FLASH_CE_B => FLASH_CE_B,
      FLASH_OE_B => FLASH_OE_B,
      FLASH_WE_B => FLASH_WE_B,
      FLASH_DQ => FLASH_DQ,
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
      CPU_LED => CPU_LED,
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
      FLASH_ADV_B => FLASH_ADV_B
    );

end architecture STRUCTURE;


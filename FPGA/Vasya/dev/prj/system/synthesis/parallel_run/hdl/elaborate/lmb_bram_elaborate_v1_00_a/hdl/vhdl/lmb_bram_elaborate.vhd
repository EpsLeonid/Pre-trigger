-------------------------------------------------------------------------------
-- lmb_bram_elaborate.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity lmb_bram_elaborate is
  generic (
    C_MEMSIZE : integer;
    C_PORT_DWIDTH : integer;
    C_PORT_AWIDTH : integer;
    C_NUM_WE : integer;
    C_FAMILY : string
    );
  port (
    BRAM_Rst_A : in std_logic;
    BRAM_Clk_A : in std_logic;
    BRAM_EN_A : in std_logic;
    BRAM_WEN_A : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_A : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_A : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_A : in std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Rst_B : in std_logic;
    BRAM_Clk_B : in std_logic;
    BRAM_EN_B : in std_logic;
    BRAM_WEN_B : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_B : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_B : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_B : in std_logic_vector(0 to C_PORT_DWIDTH-1)
  );

  attribute keep_hierarchy : STRING;
  attribute keep_hierarchy of lmb_bram_elaborate : entity is "yes";

end lmb_bram_elaborate;

architecture STRUCTURE of lmb_bram_elaborate is

  component RAMB16BWER is
    generic (
      INIT_FILE : string;
      DATA_WIDTH_A : integer;
      DATA_WIDTH_B : integer
    );
    port (
      ADDRA : in std_logic_vector(13 downto 0);
      CLKA : in std_logic;
      DIA : in std_logic_vector(31 downto 0);
      DIPA : in std_logic_vector(3 downto 0);
      DOA : out std_logic_vector(31 downto 0);
      DOPA : out std_logic_vector(3 downto 0);
      ENA : in std_logic;
      REGCEA : in std_logic;
      RSTA : in std_logic;
      WEA : in std_logic_vector(3 downto 0);
      ADDRB : in std_logic_vector(13 downto 0);
      CLKB : in std_logic;
      DIB : in std_logic_vector(31 downto 0);
      DIPB : in std_logic_vector(3 downto 0);
      DOB : out std_logic_vector(31 downto 0);
      DOPB : out std_logic_vector(3 downto 0);
      ENB : in std_logic;
      REGCEB : in std_logic;
      RSTB : in std_logic;
      WEB : in std_logic_vector(3 downto 0)
    );
  end component;

  attribute BMM_INFO : STRING;

  attribute BMM_INFO of ramb16bwer_0: label is " ";
  attribute BMM_INFO of ramb16bwer_1: label is " ";
  attribute BMM_INFO of ramb16bwer_2: label is " ";
  attribute BMM_INFO of ramb16bwer_3: label is " ";
  attribute BMM_INFO of ramb16bwer_4: label is " ";
  attribute BMM_INFO of ramb16bwer_5: label is " ";
  attribute BMM_INFO of ramb16bwer_6: label is " ";
  attribute BMM_INFO of ramb16bwer_7: label is " ";
  attribute BMM_INFO of ramb16bwer_8: label is " ";
  attribute BMM_INFO of ramb16bwer_9: label is " ";
  attribute BMM_INFO of ramb16bwer_10: label is " ";
  attribute BMM_INFO of ramb16bwer_11: label is " ";
  attribute BMM_INFO of ramb16bwer_12: label is " ";
  attribute BMM_INFO of ramb16bwer_13: label is " ";
  attribute BMM_INFO of ramb16bwer_14: label is " ";
  attribute BMM_INFO of ramb16bwer_15: label is " ";
  attribute BMM_INFO of ramb16bwer_16: label is " ";
  attribute BMM_INFO of ramb16bwer_17: label is " ";
  attribute BMM_INFO of ramb16bwer_18: label is " ";
  attribute BMM_INFO of ramb16bwer_19: label is " ";
  attribute BMM_INFO of ramb16bwer_20: label is " ";
  attribute BMM_INFO of ramb16bwer_21: label is " ";
  attribute BMM_INFO of ramb16bwer_22: label is " ";
  attribute BMM_INFO of ramb16bwer_23: label is " ";
  attribute BMM_INFO of ramb16bwer_24: label is " ";
  attribute BMM_INFO of ramb16bwer_25: label is " ";
  attribute BMM_INFO of ramb16bwer_26: label is " ";
  attribute BMM_INFO of ramb16bwer_27: label is " ";
  attribute BMM_INFO of ramb16bwer_28: label is " ";
  attribute BMM_INFO of ramb16bwer_29: label is " ";
  attribute BMM_INFO of ramb16bwer_30: label is " ";
  attribute BMM_INFO of ramb16bwer_31: label is " ";
  -- Internal signals

  signal net_gnd0 : std_logic;
  signal net_gnd4 : std_logic_vector(3 downto 0);
  signal pgassign1 : std_logic_vector(0 to 30);
  signal pgassign2 : std_logic_vector(31 downto 0);
  signal pgassign3 : std_logic_vector(31 downto 0);
  signal pgassign4 : std_logic_vector(3 downto 0);
  signal pgassign5 : std_logic_vector(31 downto 0);
  signal pgassign6 : std_logic_vector(31 downto 0);
  signal pgassign7 : std_logic_vector(3 downto 0);
  signal pgassign8 : std_logic_vector(31 downto 0);
  signal pgassign9 : std_logic_vector(31 downto 0);
  signal pgassign10 : std_logic_vector(3 downto 0);
  signal pgassign11 : std_logic_vector(31 downto 0);
  signal pgassign12 : std_logic_vector(31 downto 0);
  signal pgassign13 : std_logic_vector(3 downto 0);
  signal pgassign14 : std_logic_vector(31 downto 0);
  signal pgassign15 : std_logic_vector(31 downto 0);
  signal pgassign16 : std_logic_vector(3 downto 0);
  signal pgassign17 : std_logic_vector(31 downto 0);
  signal pgassign18 : std_logic_vector(31 downto 0);
  signal pgassign19 : std_logic_vector(3 downto 0);
  signal pgassign20 : std_logic_vector(31 downto 0);
  signal pgassign21 : std_logic_vector(31 downto 0);
  signal pgassign22 : std_logic_vector(3 downto 0);
  signal pgassign23 : std_logic_vector(31 downto 0);
  signal pgassign24 : std_logic_vector(31 downto 0);
  signal pgassign25 : std_logic_vector(3 downto 0);
  signal pgassign26 : std_logic_vector(31 downto 0);
  signal pgassign27 : std_logic_vector(31 downto 0);
  signal pgassign28 : std_logic_vector(3 downto 0);
  signal pgassign29 : std_logic_vector(31 downto 0);
  signal pgassign30 : std_logic_vector(31 downto 0);
  signal pgassign31 : std_logic_vector(3 downto 0);
  signal pgassign32 : std_logic_vector(31 downto 0);
  signal pgassign33 : std_logic_vector(31 downto 0);
  signal pgassign34 : std_logic_vector(3 downto 0);
  signal pgassign35 : std_logic_vector(31 downto 0);
  signal pgassign36 : std_logic_vector(31 downto 0);
  signal pgassign37 : std_logic_vector(3 downto 0);
  signal pgassign38 : std_logic_vector(31 downto 0);
  signal pgassign39 : std_logic_vector(31 downto 0);
  signal pgassign40 : std_logic_vector(3 downto 0);
  signal pgassign41 : std_logic_vector(31 downto 0);
  signal pgassign42 : std_logic_vector(31 downto 0);
  signal pgassign43 : std_logic_vector(3 downto 0);
  signal pgassign44 : std_logic_vector(31 downto 0);
  signal pgassign45 : std_logic_vector(31 downto 0);
  signal pgassign46 : std_logic_vector(3 downto 0);
  signal pgassign47 : std_logic_vector(31 downto 0);
  signal pgassign48 : std_logic_vector(31 downto 0);
  signal pgassign49 : std_logic_vector(3 downto 0);
  signal pgassign50 : std_logic_vector(31 downto 0);
  signal pgassign51 : std_logic_vector(31 downto 0);
  signal pgassign52 : std_logic_vector(3 downto 0);
  signal pgassign53 : std_logic_vector(31 downto 0);
  signal pgassign54 : std_logic_vector(31 downto 0);
  signal pgassign55 : std_logic_vector(3 downto 0);
  signal pgassign56 : std_logic_vector(31 downto 0);
  signal pgassign57 : std_logic_vector(31 downto 0);
  signal pgassign58 : std_logic_vector(3 downto 0);
  signal pgassign59 : std_logic_vector(31 downto 0);
  signal pgassign60 : std_logic_vector(31 downto 0);
  signal pgassign61 : std_logic_vector(3 downto 0);
  signal pgassign62 : std_logic_vector(31 downto 0);
  signal pgassign63 : std_logic_vector(31 downto 0);
  signal pgassign64 : std_logic_vector(3 downto 0);
  signal pgassign65 : std_logic_vector(31 downto 0);
  signal pgassign66 : std_logic_vector(31 downto 0);
  signal pgassign67 : std_logic_vector(3 downto 0);
  signal pgassign68 : std_logic_vector(31 downto 0);
  signal pgassign69 : std_logic_vector(31 downto 0);
  signal pgassign70 : std_logic_vector(3 downto 0);
  signal pgassign71 : std_logic_vector(31 downto 0);
  signal pgassign72 : std_logic_vector(31 downto 0);
  signal pgassign73 : std_logic_vector(3 downto 0);
  signal pgassign74 : std_logic_vector(31 downto 0);
  signal pgassign75 : std_logic_vector(31 downto 0);
  signal pgassign76 : std_logic_vector(3 downto 0);
  signal pgassign77 : std_logic_vector(31 downto 0);
  signal pgassign78 : std_logic_vector(31 downto 0);
  signal pgassign79 : std_logic_vector(3 downto 0);
  signal pgassign80 : std_logic_vector(31 downto 0);
  signal pgassign81 : std_logic_vector(31 downto 0);
  signal pgassign82 : std_logic_vector(3 downto 0);
  signal pgassign83 : std_logic_vector(31 downto 0);
  signal pgassign84 : std_logic_vector(31 downto 0);
  signal pgassign85 : std_logic_vector(3 downto 0);
  signal pgassign86 : std_logic_vector(31 downto 0);
  signal pgassign87 : std_logic_vector(31 downto 0);
  signal pgassign88 : std_logic_vector(3 downto 0);
  signal pgassign89 : std_logic_vector(31 downto 0);
  signal pgassign90 : std_logic_vector(31 downto 0);
  signal pgassign91 : std_logic_vector(3 downto 0);
  signal pgassign92 : std_logic_vector(31 downto 0);
  signal pgassign93 : std_logic_vector(31 downto 0);
  signal pgassign94 : std_logic_vector(3 downto 0);
  signal pgassign95 : std_logic_vector(31 downto 0);
  signal pgassign96 : std_logic_vector(31 downto 0);
  signal pgassign97 : std_logic_vector(3 downto 0);
  signal pgassign98 : std_logic_vector(31 downto 0);
  signal pgassign99 : std_logic_vector(31 downto 0);
  signal pgassign100 : std_logic_vector(3 downto 0);
  signal pgassign101 : std_logic_vector(31 downto 0);
  signal pgassign102 : std_logic_vector(31 downto 0);
  signal pgassign103 : std_logic_vector(3 downto 0);
  signal pgassign104 : std_logic_vector(31 downto 0);
  signal pgassign105 : std_logic_vector(31 downto 0);
  signal pgassign106 : std_logic_vector(3 downto 0);
  signal pgassign107 : std_logic_vector(31 downto 0);
  signal pgassign108 : std_logic_vector(31 downto 0);
  signal pgassign109 : std_logic_vector(3 downto 0);
  signal pgassign110 : std_logic_vector(31 downto 0);
  signal pgassign111 : std_logic_vector(31 downto 0);
  signal pgassign112 : std_logic_vector(3 downto 0);
  signal pgassign113 : std_logic_vector(31 downto 0);
  signal pgassign114 : std_logic_vector(31 downto 0);
  signal pgassign115 : std_logic_vector(3 downto 0);
  signal pgassign116 : std_logic_vector(31 downto 0);
  signal pgassign117 : std_logic_vector(31 downto 0);
  signal pgassign118 : std_logic_vector(3 downto 0);
  signal pgassign119 : std_logic_vector(31 downto 0);
  signal pgassign120 : std_logic_vector(31 downto 0);
  signal pgassign121 : std_logic_vector(3 downto 0);
  signal pgassign122 : std_logic_vector(31 downto 0);
  signal pgassign123 : std_logic_vector(31 downto 0);
  signal pgassign124 : std_logic_vector(3 downto 0);
  signal pgassign125 : std_logic_vector(31 downto 0);
  signal pgassign126 : std_logic_vector(31 downto 0);
  signal pgassign127 : std_logic_vector(3 downto 0);
  signal pgassign128 : std_logic_vector(31 downto 0);
  signal pgassign129 : std_logic_vector(31 downto 0);
  signal pgassign130 : std_logic_vector(3 downto 0);
  signal pgassign131 : std_logic_vector(31 downto 0);
  signal pgassign132 : std_logic_vector(31 downto 0);
  signal pgassign133 : std_logic_vector(3 downto 0);
  signal pgassign134 : std_logic_vector(31 downto 0);
  signal pgassign135 : std_logic_vector(31 downto 0);
  signal pgassign136 : std_logic_vector(3 downto 0);
  signal pgassign137 : std_logic_vector(31 downto 0);
  signal pgassign138 : std_logic_vector(31 downto 0);
  signal pgassign139 : std_logic_vector(3 downto 0);
  signal pgassign140 : std_logic_vector(31 downto 0);
  signal pgassign141 : std_logic_vector(31 downto 0);
  signal pgassign142 : std_logic_vector(3 downto 0);
  signal pgassign143 : std_logic_vector(31 downto 0);
  signal pgassign144 : std_logic_vector(31 downto 0);
  signal pgassign145 : std_logic_vector(3 downto 0);
  signal pgassign146 : std_logic_vector(31 downto 0);
  signal pgassign147 : std_logic_vector(31 downto 0);
  signal pgassign148 : std_logic_vector(3 downto 0);
  signal pgassign149 : std_logic_vector(31 downto 0);
  signal pgassign150 : std_logic_vector(31 downto 0);
  signal pgassign151 : std_logic_vector(3 downto 0);
  signal pgassign152 : std_logic_vector(31 downto 0);
  signal pgassign153 : std_logic_vector(31 downto 0);
  signal pgassign154 : std_logic_vector(3 downto 0);
  signal pgassign155 : std_logic_vector(31 downto 0);
  signal pgassign156 : std_logic_vector(31 downto 0);
  signal pgassign157 : std_logic_vector(3 downto 0);
  signal pgassign158 : std_logic_vector(31 downto 0);
  signal pgassign159 : std_logic_vector(31 downto 0);
  signal pgassign160 : std_logic_vector(3 downto 0);
  signal pgassign161 : std_logic_vector(31 downto 0);
  signal pgassign162 : std_logic_vector(31 downto 0);
  signal pgassign163 : std_logic_vector(3 downto 0);
  signal pgassign164 : std_logic_vector(31 downto 0);
  signal pgassign165 : std_logic_vector(31 downto 0);
  signal pgassign166 : std_logic_vector(3 downto 0);
  signal pgassign167 : std_logic_vector(31 downto 0);
  signal pgassign168 : std_logic_vector(31 downto 0);
  signal pgassign169 : std_logic_vector(3 downto 0);
  signal pgassign170 : std_logic_vector(31 downto 0);
  signal pgassign171 : std_logic_vector(31 downto 0);
  signal pgassign172 : std_logic_vector(3 downto 0);
  signal pgassign173 : std_logic_vector(31 downto 0);
  signal pgassign174 : std_logic_vector(31 downto 0);
  signal pgassign175 : std_logic_vector(3 downto 0);
  signal pgassign176 : std_logic_vector(31 downto 0);
  signal pgassign177 : std_logic_vector(31 downto 0);
  signal pgassign178 : std_logic_vector(3 downto 0);
  signal pgassign179 : std_logic_vector(31 downto 0);
  signal pgassign180 : std_logic_vector(31 downto 0);
  signal pgassign181 : std_logic_vector(3 downto 0);
  signal pgassign182 : std_logic_vector(31 downto 0);
  signal pgassign183 : std_logic_vector(31 downto 0);
  signal pgassign184 : std_logic_vector(3 downto 0);
  signal pgassign185 : std_logic_vector(31 downto 0);
  signal pgassign186 : std_logic_vector(31 downto 0);
  signal pgassign187 : std_logic_vector(3 downto 0);
  signal pgassign188 : std_logic_vector(31 downto 0);
  signal pgassign189 : std_logic_vector(31 downto 0);
  signal pgassign190 : std_logic_vector(3 downto 0);
  signal pgassign191 : std_logic_vector(31 downto 0);
  signal pgassign192 : std_logic_vector(31 downto 0);
  signal pgassign193 : std_logic_vector(3 downto 0);

begin

  -- Internal assignments

  pgassign1(0 to 30) <= B"0000000000000000000000000000000";
  pgassign2(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign2(0 downto 0) <= BRAM_Dout_A(0 to 0);
  BRAM_Din_A(0 to 0) <= pgassign3(0 downto 0);
  pgassign4(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign4(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign4(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign4(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign5(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign5(0 downto 0) <= BRAM_Dout_B(0 to 0);
  BRAM_Din_B(0 to 0) <= pgassign6(0 downto 0);
  pgassign7(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign7(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign7(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign7(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign8(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign8(0 downto 0) <= BRAM_Dout_A(1 to 1);
  BRAM_Din_A(1 to 1) <= pgassign9(0 downto 0);
  pgassign10(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign10(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign10(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign10(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign11(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign11(0 downto 0) <= BRAM_Dout_B(1 to 1);
  BRAM_Din_B(1 to 1) <= pgassign12(0 downto 0);
  pgassign13(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign13(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign13(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign13(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign14(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign14(0 downto 0) <= BRAM_Dout_A(2 to 2);
  BRAM_Din_A(2 to 2) <= pgassign15(0 downto 0);
  pgassign16(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign16(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign16(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign16(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign17(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign17(0 downto 0) <= BRAM_Dout_B(2 to 2);
  BRAM_Din_B(2 to 2) <= pgassign18(0 downto 0);
  pgassign19(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign19(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign19(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign19(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign20(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign20(0 downto 0) <= BRAM_Dout_A(3 to 3);
  BRAM_Din_A(3 to 3) <= pgassign21(0 downto 0);
  pgassign22(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign22(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign22(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign22(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign23(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign23(0 downto 0) <= BRAM_Dout_B(3 to 3);
  BRAM_Din_B(3 to 3) <= pgassign24(0 downto 0);
  pgassign25(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign25(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign25(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign25(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign26(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign26(0 downto 0) <= BRAM_Dout_A(4 to 4);
  BRAM_Din_A(4 to 4) <= pgassign27(0 downto 0);
  pgassign28(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign28(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign28(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign28(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign29(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign29(0 downto 0) <= BRAM_Dout_B(4 to 4);
  BRAM_Din_B(4 to 4) <= pgassign30(0 downto 0);
  pgassign31(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign31(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign31(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign31(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign32(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign32(0 downto 0) <= BRAM_Dout_A(5 to 5);
  BRAM_Din_A(5 to 5) <= pgassign33(0 downto 0);
  pgassign34(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign34(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign34(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign34(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign35(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign35(0 downto 0) <= BRAM_Dout_B(5 to 5);
  BRAM_Din_B(5 to 5) <= pgassign36(0 downto 0);
  pgassign37(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign37(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign37(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign37(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign38(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign38(0 downto 0) <= BRAM_Dout_A(6 to 6);
  BRAM_Din_A(6 to 6) <= pgassign39(0 downto 0);
  pgassign40(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign40(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign40(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign40(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign41(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign41(0 downto 0) <= BRAM_Dout_B(6 to 6);
  BRAM_Din_B(6 to 6) <= pgassign42(0 downto 0);
  pgassign43(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign43(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign43(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign43(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign44(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign44(0 downto 0) <= BRAM_Dout_A(7 to 7);
  BRAM_Din_A(7 to 7) <= pgassign45(0 downto 0);
  pgassign46(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign46(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign46(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign46(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign47(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign47(0 downto 0) <= BRAM_Dout_B(7 to 7);
  BRAM_Din_B(7 to 7) <= pgassign48(0 downto 0);
  pgassign49(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign49(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign49(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign49(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign50(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign50(0 downto 0) <= BRAM_Dout_A(8 to 8);
  BRAM_Din_A(8 to 8) <= pgassign51(0 downto 0);
  pgassign52(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign52(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign52(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign52(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign53(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign53(0 downto 0) <= BRAM_Dout_B(8 to 8);
  BRAM_Din_B(8 to 8) <= pgassign54(0 downto 0);
  pgassign55(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign55(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign55(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign55(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign56(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign56(0 downto 0) <= BRAM_Dout_A(9 to 9);
  BRAM_Din_A(9 to 9) <= pgassign57(0 downto 0);
  pgassign58(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign58(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign58(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign58(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign59(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign59(0 downto 0) <= BRAM_Dout_B(9 to 9);
  BRAM_Din_B(9 to 9) <= pgassign60(0 downto 0);
  pgassign61(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign61(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign61(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign61(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign62(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign62(0 downto 0) <= BRAM_Dout_A(10 to 10);
  BRAM_Din_A(10 to 10) <= pgassign63(0 downto 0);
  pgassign64(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign64(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign64(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign64(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign65(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign65(0 downto 0) <= BRAM_Dout_B(10 to 10);
  BRAM_Din_B(10 to 10) <= pgassign66(0 downto 0);
  pgassign67(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign67(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign67(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign67(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign68(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign68(0 downto 0) <= BRAM_Dout_A(11 to 11);
  BRAM_Din_A(11 to 11) <= pgassign69(0 downto 0);
  pgassign70(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign70(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign70(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign70(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign71(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign71(0 downto 0) <= BRAM_Dout_B(11 to 11);
  BRAM_Din_B(11 to 11) <= pgassign72(0 downto 0);
  pgassign73(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign73(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign73(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign73(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign74(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign74(0 downto 0) <= BRAM_Dout_A(12 to 12);
  BRAM_Din_A(12 to 12) <= pgassign75(0 downto 0);
  pgassign76(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign76(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign76(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign76(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign77(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign77(0 downto 0) <= BRAM_Dout_B(12 to 12);
  BRAM_Din_B(12 to 12) <= pgassign78(0 downto 0);
  pgassign79(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign79(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign79(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign79(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign80(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign80(0 downto 0) <= BRAM_Dout_A(13 to 13);
  BRAM_Din_A(13 to 13) <= pgassign81(0 downto 0);
  pgassign82(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign82(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign82(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign82(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign83(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign83(0 downto 0) <= BRAM_Dout_B(13 to 13);
  BRAM_Din_B(13 to 13) <= pgassign84(0 downto 0);
  pgassign85(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign85(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign85(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign85(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign86(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign86(0 downto 0) <= BRAM_Dout_A(14 to 14);
  BRAM_Din_A(14 to 14) <= pgassign87(0 downto 0);
  pgassign88(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign88(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign88(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign88(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign89(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign89(0 downto 0) <= BRAM_Dout_B(14 to 14);
  BRAM_Din_B(14 to 14) <= pgassign90(0 downto 0);
  pgassign91(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign91(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign91(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign91(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign92(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign92(0 downto 0) <= BRAM_Dout_A(15 to 15);
  BRAM_Din_A(15 to 15) <= pgassign93(0 downto 0);
  pgassign94(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign94(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign94(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign94(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign95(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign95(0 downto 0) <= BRAM_Dout_B(15 to 15);
  BRAM_Din_B(15 to 15) <= pgassign96(0 downto 0);
  pgassign97(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign97(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign97(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign97(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign98(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign98(0 downto 0) <= BRAM_Dout_A(16 to 16);
  BRAM_Din_A(16 to 16) <= pgassign99(0 downto 0);
  pgassign100(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign100(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign100(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign100(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign101(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign101(0 downto 0) <= BRAM_Dout_B(16 to 16);
  BRAM_Din_B(16 to 16) <= pgassign102(0 downto 0);
  pgassign103(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign103(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign103(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign103(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign104(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign104(0 downto 0) <= BRAM_Dout_A(17 to 17);
  BRAM_Din_A(17 to 17) <= pgassign105(0 downto 0);
  pgassign106(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign106(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign106(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign106(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign107(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign107(0 downto 0) <= BRAM_Dout_B(17 to 17);
  BRAM_Din_B(17 to 17) <= pgassign108(0 downto 0);
  pgassign109(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign109(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign109(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign109(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign110(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign110(0 downto 0) <= BRAM_Dout_A(18 to 18);
  BRAM_Din_A(18 to 18) <= pgassign111(0 downto 0);
  pgassign112(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign112(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign112(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign112(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign113(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign113(0 downto 0) <= BRAM_Dout_B(18 to 18);
  BRAM_Din_B(18 to 18) <= pgassign114(0 downto 0);
  pgassign115(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign115(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign115(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign115(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign116(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign116(0 downto 0) <= BRAM_Dout_A(19 to 19);
  BRAM_Din_A(19 to 19) <= pgassign117(0 downto 0);
  pgassign118(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign118(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign118(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign118(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign119(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign119(0 downto 0) <= BRAM_Dout_B(19 to 19);
  BRAM_Din_B(19 to 19) <= pgassign120(0 downto 0);
  pgassign121(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign121(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign121(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign121(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign122(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign122(0 downto 0) <= BRAM_Dout_A(20 to 20);
  BRAM_Din_A(20 to 20) <= pgassign123(0 downto 0);
  pgassign124(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign124(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign124(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign124(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign125(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign125(0 downto 0) <= BRAM_Dout_B(20 to 20);
  BRAM_Din_B(20 to 20) <= pgassign126(0 downto 0);
  pgassign127(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign127(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign127(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign127(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign128(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign128(0 downto 0) <= BRAM_Dout_A(21 to 21);
  BRAM_Din_A(21 to 21) <= pgassign129(0 downto 0);
  pgassign130(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign130(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign130(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign130(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign131(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign131(0 downto 0) <= BRAM_Dout_B(21 to 21);
  BRAM_Din_B(21 to 21) <= pgassign132(0 downto 0);
  pgassign133(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign133(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign133(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign133(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign134(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign134(0 downto 0) <= BRAM_Dout_A(22 to 22);
  BRAM_Din_A(22 to 22) <= pgassign135(0 downto 0);
  pgassign136(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign136(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign136(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign136(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign137(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign137(0 downto 0) <= BRAM_Dout_B(22 to 22);
  BRAM_Din_B(22 to 22) <= pgassign138(0 downto 0);
  pgassign139(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign139(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign139(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign139(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign140(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign140(0 downto 0) <= BRAM_Dout_A(23 to 23);
  BRAM_Din_A(23 to 23) <= pgassign141(0 downto 0);
  pgassign142(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign142(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign142(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign142(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign143(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign143(0 downto 0) <= BRAM_Dout_B(23 to 23);
  BRAM_Din_B(23 to 23) <= pgassign144(0 downto 0);
  pgassign145(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign145(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign145(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign145(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign146(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign146(0 downto 0) <= BRAM_Dout_A(24 to 24);
  BRAM_Din_A(24 to 24) <= pgassign147(0 downto 0);
  pgassign148(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign148(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign148(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign148(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign149(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign149(0 downto 0) <= BRAM_Dout_B(24 to 24);
  BRAM_Din_B(24 to 24) <= pgassign150(0 downto 0);
  pgassign151(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign151(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign151(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign151(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign152(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign152(0 downto 0) <= BRAM_Dout_A(25 to 25);
  BRAM_Din_A(25 to 25) <= pgassign153(0 downto 0);
  pgassign154(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign154(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign154(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign154(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign155(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign155(0 downto 0) <= BRAM_Dout_B(25 to 25);
  BRAM_Din_B(25 to 25) <= pgassign156(0 downto 0);
  pgassign157(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign157(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign157(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign157(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign158(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign158(0 downto 0) <= BRAM_Dout_A(26 to 26);
  BRAM_Din_A(26 to 26) <= pgassign159(0 downto 0);
  pgassign160(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign160(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign160(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign160(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign161(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign161(0 downto 0) <= BRAM_Dout_B(26 to 26);
  BRAM_Din_B(26 to 26) <= pgassign162(0 downto 0);
  pgassign163(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign163(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign163(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign163(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign164(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign164(0 downto 0) <= BRAM_Dout_A(27 to 27);
  BRAM_Din_A(27 to 27) <= pgassign165(0 downto 0);
  pgassign166(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign166(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign166(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign166(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign167(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign167(0 downto 0) <= BRAM_Dout_B(27 to 27);
  BRAM_Din_B(27 to 27) <= pgassign168(0 downto 0);
  pgassign169(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign169(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign169(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign169(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign170(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign170(0 downto 0) <= BRAM_Dout_A(28 to 28);
  BRAM_Din_A(28 to 28) <= pgassign171(0 downto 0);
  pgassign172(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign172(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign172(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign172(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign173(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign173(0 downto 0) <= BRAM_Dout_B(28 to 28);
  BRAM_Din_B(28 to 28) <= pgassign174(0 downto 0);
  pgassign175(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign175(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign175(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign175(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign176(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign176(0 downto 0) <= BRAM_Dout_A(29 to 29);
  BRAM_Din_A(29 to 29) <= pgassign177(0 downto 0);
  pgassign178(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign178(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign178(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign178(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign179(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign179(0 downto 0) <= BRAM_Dout_B(29 to 29);
  BRAM_Din_B(29 to 29) <= pgassign180(0 downto 0);
  pgassign181(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign181(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign181(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign181(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign182(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign182(0 downto 0) <= BRAM_Dout_A(30 to 30);
  BRAM_Din_A(30 to 30) <= pgassign183(0 downto 0);
  pgassign184(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign184(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign184(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign184(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign185(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign185(0 downto 0) <= BRAM_Dout_B(30 to 30);
  BRAM_Din_B(30 to 30) <= pgassign186(0 downto 0);
  pgassign187(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign187(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign187(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign187(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign188(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign188(0 downto 0) <= BRAM_Dout_A(31 to 31);
  BRAM_Din_A(31 to 31) <= pgassign189(0 downto 0);
  pgassign190(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign190(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign190(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign190(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign191(31 downto 1) <= B"0000000000000000000000000000000";
  pgassign191(0 downto 0) <= BRAM_Dout_B(31 to 31);
  BRAM_Din_B(31 to 31) <= pgassign192(0 downto 0);
  pgassign193(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign193(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign193(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign193(0 downto 0) <= BRAM_WEN_B(3 to 3);
  net_gnd0 <= '0';
  net_gnd4(3 downto 0) <= B"0000";

  ramb16bwer_0 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_0.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign2,
      DIPA => net_gnd4,
      DOA => pgassign3,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign4,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign5,
      DIPB => net_gnd4,
      DOB => pgassign6,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign7
    );

  ramb16bwer_1 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_1.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign8,
      DIPA => net_gnd4,
      DOA => pgassign9,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign10,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign11,
      DIPB => net_gnd4,
      DOB => pgassign12,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign13
    );

  ramb16bwer_2 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_2.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign14,
      DIPA => net_gnd4,
      DOA => pgassign15,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign16,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign17,
      DIPB => net_gnd4,
      DOB => pgassign18,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign19
    );

  ramb16bwer_3 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_3.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign20,
      DIPA => net_gnd4,
      DOA => pgassign21,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign22,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign23,
      DIPB => net_gnd4,
      DOB => pgassign24,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign25
    );

  ramb16bwer_4 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_4.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign26,
      DIPA => net_gnd4,
      DOA => pgassign27,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign28,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign29,
      DIPB => net_gnd4,
      DOB => pgassign30,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign31
    );

  ramb16bwer_5 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_5.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign32,
      DIPA => net_gnd4,
      DOA => pgassign33,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign34,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign35,
      DIPB => net_gnd4,
      DOB => pgassign36,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign37
    );

  ramb16bwer_6 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_6.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign38,
      DIPA => net_gnd4,
      DOA => pgassign39,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign40,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign41,
      DIPB => net_gnd4,
      DOB => pgassign42,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign43
    );

  ramb16bwer_7 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_7.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign44,
      DIPA => net_gnd4,
      DOA => pgassign45,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign46,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign47,
      DIPB => net_gnd4,
      DOB => pgassign48,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign49
    );

  ramb16bwer_8 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_8.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign50,
      DIPA => net_gnd4,
      DOA => pgassign51,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign52,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign53,
      DIPB => net_gnd4,
      DOB => pgassign54,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign55
    );

  ramb16bwer_9 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_9.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign56,
      DIPA => net_gnd4,
      DOA => pgassign57,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign58,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign59,
      DIPB => net_gnd4,
      DOB => pgassign60,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign61
    );

  ramb16bwer_10 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_10.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign62,
      DIPA => net_gnd4,
      DOA => pgassign63,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign64,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign65,
      DIPB => net_gnd4,
      DOB => pgassign66,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign67
    );

  ramb16bwer_11 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_11.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign68,
      DIPA => net_gnd4,
      DOA => pgassign69,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign70,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign71,
      DIPB => net_gnd4,
      DOB => pgassign72,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign73
    );

  ramb16bwer_12 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_12.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign74,
      DIPA => net_gnd4,
      DOA => pgassign75,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign76,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign77,
      DIPB => net_gnd4,
      DOB => pgassign78,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign79
    );

  ramb16bwer_13 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_13.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign80,
      DIPA => net_gnd4,
      DOA => pgassign81,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign82,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign83,
      DIPB => net_gnd4,
      DOB => pgassign84,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign85
    );

  ramb16bwer_14 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_14.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign86,
      DIPA => net_gnd4,
      DOA => pgassign87,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign88,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign89,
      DIPB => net_gnd4,
      DOB => pgassign90,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign91
    );

  ramb16bwer_15 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_15.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign92,
      DIPA => net_gnd4,
      DOA => pgassign93,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign94,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign95,
      DIPB => net_gnd4,
      DOB => pgassign96,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign97
    );

  ramb16bwer_16 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_16.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign98,
      DIPA => net_gnd4,
      DOA => pgassign99,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign100,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign101,
      DIPB => net_gnd4,
      DOB => pgassign102,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign103
    );

  ramb16bwer_17 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_17.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign104,
      DIPA => net_gnd4,
      DOA => pgassign105,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign106,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign107,
      DIPB => net_gnd4,
      DOB => pgassign108,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign109
    );

  ramb16bwer_18 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_18.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign110,
      DIPA => net_gnd4,
      DOA => pgassign111,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign112,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign113,
      DIPB => net_gnd4,
      DOB => pgassign114,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign115
    );

  ramb16bwer_19 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_19.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign116,
      DIPA => net_gnd4,
      DOA => pgassign117,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign118,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign119,
      DIPB => net_gnd4,
      DOB => pgassign120,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign121
    );

  ramb16bwer_20 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_20.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign122,
      DIPA => net_gnd4,
      DOA => pgassign123,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign124,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign125,
      DIPB => net_gnd4,
      DOB => pgassign126,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign127
    );

  ramb16bwer_21 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_21.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign128,
      DIPA => net_gnd4,
      DOA => pgassign129,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign130,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign131,
      DIPB => net_gnd4,
      DOB => pgassign132,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign133
    );

  ramb16bwer_22 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_22.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign134,
      DIPA => net_gnd4,
      DOA => pgassign135,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign136,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign137,
      DIPB => net_gnd4,
      DOB => pgassign138,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign139
    );

  ramb16bwer_23 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_23.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign140,
      DIPA => net_gnd4,
      DOA => pgassign141,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign142,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign143,
      DIPB => net_gnd4,
      DOB => pgassign144,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign145
    );

  ramb16bwer_24 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_24.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign146,
      DIPA => net_gnd4,
      DOA => pgassign147,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign148,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign149,
      DIPB => net_gnd4,
      DOB => pgassign150,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign151
    );

  ramb16bwer_25 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_25.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign152,
      DIPA => net_gnd4,
      DOA => pgassign153,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign154,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign155,
      DIPB => net_gnd4,
      DOB => pgassign156,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign157
    );

  ramb16bwer_26 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_26.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign158,
      DIPA => net_gnd4,
      DOA => pgassign159,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign160,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign161,
      DIPB => net_gnd4,
      DOB => pgassign162,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign163
    );

  ramb16bwer_27 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_27.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign164,
      DIPA => net_gnd4,
      DOA => pgassign165,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign166,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign167,
      DIPB => net_gnd4,
      DOB => pgassign168,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign169
    );

  ramb16bwer_28 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_28.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign170,
      DIPA => net_gnd4,
      DOA => pgassign171,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign172,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign173,
      DIPB => net_gnd4,
      DOB => pgassign174,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign175
    );

  ramb16bwer_29 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_29.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign176,
      DIPA => net_gnd4,
      DOA => pgassign177,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign178,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign179,
      DIPB => net_gnd4,
      DOB => pgassign180,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign181
    );

  ramb16bwer_30 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_30.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign182,
      DIPA => net_gnd4,
      DOA => pgassign183,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign184,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign185,
      DIPB => net_gnd4,
      DOB => pgassign186,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign187
    );

  ramb16bwer_31 : RAMB16BWER
    generic map (
      INIT_FILE => "lmb_bram_combined_31.mem",
      DATA_WIDTH_A => 1,
      DATA_WIDTH_B => 1
    )
    port map (
      ADDRA => BRAM_Addr_A(16 to 29),
      CLKA => BRAM_Clk_A,
      DIA => pgassign188,
      DIPA => net_gnd4,
      DOA => pgassign189,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign190,
      ADDRB => BRAM_Addr_B(16 to 29),
      CLKB => BRAM_Clk_B,
      DIB => pgassign191,
      DIPB => net_gnd4,
      DOB => pgassign192,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign193
    );

end architecture STRUCTURE;


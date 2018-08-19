------------------------------------------------------------------------
-- b2tt_8b10b.vhd --- 8b10b encoder (b2tt_en8b10b) and decoder (b2tt_de8b10b)
--
-- 20030624 data part is confirmed to work with a FPGA setup
--          (code: ftest_en v0.10)
-- 20110102 rewritten
--          based on http://en.wikipedia.org/wiki/8b/10b_encoding
-- 20130411 renamed from b2tt_8b10b to tt_8b10b
-- 20130507 renamed back to b2tt_8b10b from tt_8b10b
-- 20130522 fixed err[4]
-- 20131101 no more std_logic_arith
--
-- eout bit 9 is first transmitted, bit 0 is last transmitted
-- ein  bit 9 is first received,    bit 0 is last received
--
-- Mikihiko Nakao, KEK IPNS
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity b2tt_en8b10b is
  port ( 
    reset   : in  std_logic;
    clock   : in  std_logic;
    en      : in  std_logic;
    isk     : in  std_logic;
    din     : in  std_logic_vector(7 downto 0);
    eout    : out std_logic_vector(9 downto 0);
    validk  : out std_logic;
    rdnext  : out std_logic;
    rd6psav : out std_logic;
    rd4psav : out std_logic );

end b2tt_en8b10b;

architecture implementation of b2tt_en8b10b is

  alias  din5 : std_logic_vector(4 downto 0) is din(4 downto 0);
  alias  din3 : std_logic_vector(2 downto 0) is din(7 downto 5);

  signal eout6  : std_logic_vector(5 downto 0) := "111111";
  signal eout6m : std_logic_vector(5 downto 0) := "111111";
  signal eout6p : std_logic_vector(5 downto 0) := "111111";
  signal eout4  : std_logic_vector(3 downto 0) := "1111";
  signal eout4m : std_logic_vector(3 downto 0) := "1111";
  signal eout4p : std_logic_vector(3 downto 0) := "1111";

  signal rd6p   : std_logic := '0';
  signal rd4p   : std_logic := '0';
  signal rdplus : std_logic := '1';

begin
  -- 5b6b table for RD-
  eout6m <=
    "100111" when din5 = "00000" else -- D0.x
    "011101" when din5 = "00001" else -- D1.x
    "101101" when din5 = "00010" else -- D2.x
    "110001" when din5 = "00011" else -- D3.x
    "110101" when din5 = "00100" else -- D4.x
    "101001" when din5 = "00101" else -- D5.x
    "011001" when din5 = "00110" else -- D6.x
    "111000" when din5 = "00111" else -- D7.x
    "111001" when din5 = "01000" else -- D8.x
    "100101" when din5 = "01001" else -- D9.x
    "010101" when din5 = "01010" else -- D10.x
    "110100" when din5 = "01011" else -- D11.x
    "001101" when din5 = "01100" else -- D12.x
    "101100" when din5 = "01101" else -- D13.x
    "011100" when din5 = "01110" else -- D14.x
    "010111" when din5 = "01111" else -- D15.x
    "011011" when din5 = "10000" else -- D16.x
    "100011" when din5 = "10001" else -- D17.x
    "010011" when din5 = "10010" else -- D18.x
    "110010" when din5 = "10011" else -- D19.x
    "001011" when din5 = "10100" else -- D20.x
    "101010" when din5 = "10101" else -- D21.x
    "011010" when din5 = "10110" else -- D22.x
    "111010" when din5 = "10111" else -- D23.x and K23.7
    "110011" when din5 = "11000" else -- D24.x
    "100110" when din5 = "11001" else -- D25.x
    "010110" when din5 = "11010" else -- D26.x
    "110110" when din5 = "11011" else -- D27.x and K27.7
    "001111" when din5 = "11100" and isk = '1' else  -- K28.x
    "001110" when din5 = "11100" and isk = '0' else  -- D28.x
    "101110" when din5 = "11101" else -- D29.x and K29.7
    "011110" when din5 = "11110" else -- D30.x and K30.7
    "101011";                         -- D31.x
  
  -- RD+ table from RD- table
  -- RD+ = RD- if equal number of 0 and 1 else not RD-.
     
  --  following have unequal number of 0 and 1:
  --   K28, (note D28 has equal number of 0 and 1)
  --   D0,  D8,  D16, D24  (lowest 3-bit 000)
  --   D7,  D15, D23, D31  (lowest 3-bit 111)
  --   D1,  D2,  D4,       (only one 1 in din5)
  --   D27, D29, D30       (only one 0 in din5) */
  rd6p <= rdplus;
  eout6p <= not eout6m when
                       ((isk = '1' and din5 = "11100") or
                        din5(2 downto 0) = "000" or
                        din5(2 downto 0) = "111" or
                        (din5(4 downto 3) = "00"
                         and (din5(2) xor din5(1) xor din5(0)) = '1'
                         and (din5(2) and din5(1) and din5(0)) = '0') or
                        (din5(4 downto 3) = "11"
                         and (din5(2) xor din5(1) xor din5(0)) = '0'
                         and (din5(2) or  din5(1) or  din5(0)) = '1')) else
            eout6m;
  
  rd4p <= not rd6p when
                   ((isk = '1' and din5 = "11100") or
                    din5(2 downto 0) = "000" or
                    (din5(2 downto 0) = "111" and din5(4 downto 3) /= "00") or
                    (din5(4 downto 3) = "00"
                     and (din5(2) xor din5(1) xor din5(0)) = '1'
                     and (din5(2) and din5(1) and din5(0)) = '0') or
                    (din5(4 downto 3) = "11"
                     and (din5(2) xor din5(1) xor din5(0)) = '0'
                     and (din5(2) or  din5(1) or  din5(0)) = '1')) else
          rd6p;

  -- 3b4b RD+ table
  -- RD+ table is the same for D and K, but RD- is not
  eout4p <= "0100" when din3 = "000" else
            "1001" when din3 = "001" else
            "0101" when din3 = "010" else
            "0011" when din3 = "011" else
            "0010" when din3 = "100" else
            "1010" when din3 = "101" else
            "0110" when din3 = "110" else
             -- alternative RD+ for D11.7, D13.7, D24.7 and Kxx.7
            "1000" when isk = '1'
                   or din5 = "01011" or din5 = "01101" or din5 = "01110" else
            "0001";
  
  -- 3b4b RD- table
  -- following have unequal number of 0 and 1:
  --   Dxx.0, Dxx.4, Dxx.7, K28.0, K28.4, Kxx.7
  -- alternative RD- for D17.7, D18.7, D20.7 and Kxx.7
  -- alternative RD- for D11.7, D13.7, D14.7 and Kxx.7
  eout4m <= not eout4p when din3 = "000" or din3 = "100" else
            "0111" when din3 = "111" and (isk = '1' or
                   din5 = "10001" or din5 = "10010" or din5 = "10100") else
            "1110" when din3 = "111" else
            not eout4p when isk = '1' or din3 = "011" else
            eout4p;

  eout6 <= eout6m when rd6p = '0' else eout6p;
  eout4 <= eout4m when rd4p = '0' else eout4p;
  eout  <= eout6 & eout4;
  
  process(clock)
  begin
    if clock'event and clock = '1' then
      if reset = '1' then
        rdplus <= '1';
        validk <= '1';

      elsif en = '1' then
        
        -- valid K character check
        if isk = '1' then
          if din5 = "11100" then
            validk <= '1';
          elsif din3 = "111" and din5(4) = '1' and
            (din5(3) xor din5(2) xor din5(1) xor din5(0)) = '1' and
            ((din5(3) and din5(2)) or (din5(1) and din5(0))) = '1' then
            validk <= '1';
          else
            validk <= '0';
          end if;
        else
          validk <= '1';
        end if;

        -- RD for the next cycle
        if din3 = "000" or din3 = "100" or din3 = "111" then
          rdplus <= not rd4p;
        else
          rdplus <= rd4p;
        end if;
        rd6psav <= rd6p;
        rd4psav <= rd4p;
      end if;
    end if;
  end process;

  -- output
  rdnext <= rdplus;  -- for debug

end implementation;
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity b2tt_de8b10b is
  port ( 
    reset : in std_logic;
    clock : in std_logic;
    en    : in std_logic;
    ein   : in std_logic_vector(9 downto 0);
    dout  : out std_logic_vector(7 downto 0);
    isk   : out std_logic;
    err   : out std_logic_vector(4 downto 0);
    rdp   : out std_logic );

end b2tt_de8b10b;

architecture implementation of b2tt_de8b10b is

  signal rdplus : std_logic := '1';
  signal dout3  : std_logic_vector (2 downto 0) := "000";
  signal dout5  : std_logic_vector (4 downto 0) := "00000";
  alias  ein4   : std_logic_vector (3 downto 0) is ein(3 downto 0);
  alias  ein6   : std_logic_vector (5 downto 0) is ein(9 downto 4);
  signal rd_defined  : std_logic := '0';
  signal bad_ein4    : std_logic := '0';
  signal bad_ein6    : std_logic := '0';
  signal bad_rd4     : std_logic := '0';
  signal bad_rd6     : std_logic := '0';
  signal expect_rd4m : std_logic := '0';
  signal expect_rd4p : std_logic := '0';
  signal expect_rd6m : std_logic := '0';
  signal expect_rd6p : std_logic := '0';
  signal rd6flip     : std_logic := '0';
  signal rd4flip     : std_logic := '0';
  signal rd4p        : std_logic := '0';

begin

  -- 3b4b table
  dout3 <= "000" when ein4 = "1011" or  ein4  = "0100" else
           "001" when ein4 = "1001" and ein6 /= "110000" else
           "001" when ein4 = "0110" and ein6  = "110000" else
           "010" when ein4 = "0101" and ein6 /= "110000" else
           "010" when ein4 = "1010" and ein6  = "110000" else
           "011" when ein4 = "1100" or  ein4  = "0011" else
           "100" when ein4 = "1101" or  ein4  = "0010" else
           "101" when ein4 = "1010" and ein6 /= "110000" else
           "101" when ein4 = "0101" and ein6  = "110000" else
           "110" when ein4 = "0110" and ein6 /= "110000" else
           "110" when ein4 = "1001" and ein6  = "110000" else
           "111";

  -- invalid 3b4b
  bad_ein4 <= '1' when ein4 = "0000" or ein4 = "1111" else '0';
  
  -- 5b6b table
  dout5 <= "00000" when ein6 = "100111" or ein6 = "011000" else
           "00001" when ein6 = "011101" or ein6 = "100010" else
           "00010" when ein6 = "101101" or ein6 = "010010" else
           "00011" when ein6 = "110001"                    else
           "00100" when ein6 = "110101" or ein6 = "001010" else
           "00101" when ein6 = "101001"                    else
           "00110" when ein6 = "011001"                    else
           "00111" when ein6 = "111000" or ein6 = "000111" else
           "01000" when ein6 = "111001" or ein6 = "000110" else
           "01001" when ein6 = "100101"                    else
           "01010" when ein6 = "010101"                    else
           "01011" when ein6 = "110100"                    else
           "01100" when ein6 = "001101"                    else
           "01101" when ein6 = "101100"                    else
           "01110" when ein6 = "011100"                    else
           "01111" when ein6 = "010111" or ein6 = "101000" else
           "10000" when ein6 = "011011" or ein6 = "100100" else
           "10001" when ein6 = "100011"                    else
           "10010" when ein6 = "010011"                    else
           "10011" when ein6 = "110010"                    else
           "10100" when ein6 = "001011"                    else
           "10101" when ein6 = "101010"                    else
           "10110" when ein6 = "011010"                    else
           "10111" when ein6 = "111010" or ein6 = "000101" else
           "11000" when ein6 = "110011" or ein6 = "001100" else
           "11001" when ein6 = "100110"                    else
           "11010" when ein6 = "010110"                    else
           "11011" when ein6 = "110110" or ein6 = "001001" else
           "11100" when ein6 = "001110"                    else
           "11101" when ein6 = "101110" or ein6 = "010001" else
           "11110" when ein6 = "011110" or ein6 = "100001" else
           "11100" when ein6 = "001111" or ein6 = "110000" else
           "11111";


  -- invalid 5b6b - all 0, five 0 or 000011 and comlements
  bad_ein6 <= '1' when
              ein6 = "000000" or ein6 = "111111" or
              ein6 = "000001" or ein6 = "000010" or ein6 = "000100" or
              ein6 = "001000" or ein6 = "010000" or ein6 = "100000" or
              ein6 = "111110" or ein6 = "111101" or ein6 = "111011" or
              ein6 = "110111" or ein6 = "101111" or ein6 = "011111" or
              ein6 = "000011" or ein6 = "111100" else
              '0';

  -- must be rd- to receive 11xx or yy11 with yy /= 00,
  -- must be rd+ to receive 00xx or yy00 with yy /= 11
  expect_rd4m <= (ein4(3) and ein4(2)) or
                 ((ein4(3) or ein4(2)) and ein4(1) and ein4(0));
  expect_rd4p <= not ((ein4(3) or ein4(2)) and
                      ((ein4(3) and ein4(2)) or ein4(1) or ein4(0)));
  -- must be RD- if 111aaa or bb1111 or
  --                xxyyzz with all xx,yy,zz /= 00 and one of them = 11,
  -- must be RD+ if xxyyzz with all xx,yy,zz /= 11 and one of them = 00
  expect_rd6m <=
    (ein6(5) and ein6(4) and ein6(3)) or             -- 111aaa
    (ein6(3) and ein6(2) and ein6(1) and ein6(0)) or -- bb1111
    (ein6(5) and ein6(4) and ein6(1) and ein6(0)) or -- 11cc11
    ((ein6(5) or ein6(4)) and                        -- all xx,yy,zz /= 00
     (ein6(3) or ein6(2)) and (ein6(1) or ein6(0)) and 
     ((ein6(5) and ein6(4)) or                       -- one of xx,yy,zz = 11
      (ein6(3) and ein6(2)) or (ein6(1) and ein6(0))));
  expect_rd6p <= not (
    (ein6(5) or ein6(4) or ein6(3)) and              -- ! 000aaa
    (ein6(3) or ein6(2) or ein6(1) or ein6(0)) and   -- ! bb0000
    (ein6(5) or ein6(4) or ein6(1) or ein6(0)) and   -- ! 00cc00
    ((ein6(5) and ein6(4)) or                        -- ! all xx,yy,zz /= 11
     (ein6(3) and ein6(2)) or (ein6(1) and ein6(0)) or
     ((ein6(5) or ein6(4)) and                       -- ! one of xx,yy,zz = 00
      (ein6(3) or ein6(2)) and (ein6(1) or ein6(0)))));

  -- RD flips after 6b with even (2 or 4) number of 0s/1s
  --      and after 4b with odd  (1 or 3) number of 0s/1s,
  -- since there's no 6b with 0,1,5,6 0s/1s and no 4b with 0,4 0s/1s
  rd6flip <=
    not (ein6(5) xor ein6(4) xor ein6(3) xor ein6(2) xor ein6(1) xor ein6(0));
  rd4flip <= ein4(3) xor ein4(2) xor ein4(1) xor ein4(0);

  -- next RD
  rd4p <= not rd6flip when expect_rd6p = '1' else
          rd6flip     when expect_rd6m = '1' else
          rdplus;
  
  -- K character (K23,K27,K29,K30) 
  -- RD+ ein6(1:0) = 01 and only one 1 in din(5:2)
  -- RD- ein6(1:0) = 10 and only one 0 in din(5:2)
  isk <= '1' when ein6 = "001111" or ein6 = "110000" else
         (ein6(0) xor ein6(1)) and                  -- ein6(1:0) = 01 or 10
         (ein6(5) xor ein6(4) xor ein6(3) xor ein6(2)) and -- ein6(5:2) odd
         (((ein6(5) or ein6(4)) and (ein6(3) or ein6(2))) xor ein6(0)) and 
         (ein4(3) xor ein4(2)) and                  -- 0111 or 1000
         (ein4(3) xor ein4(1)) and 
         (not (ein4(1) xor ein4(0)));

  -- check valid RD
  bad_rd6 <= rd_defined and 
    ((rdplus and expect_rd6m) or ((not rdplus) and expect_rd6p));
  bad_rd4 <= (rd_defined) and 
    ((rd4p   and expect_rd4m) or ((not rd4p)   and expect_rd4p));

  dout <= dout3 & dout5;

  -- process
  process(clock)
  begin
    if clock = '1' and clock'event then
      if reset = '1' then
      elsif en = '1' then
        if expect_rd4p = '1' then
          rdplus <= not rd4flip;
        elsif expect_rd4m = '1' then
          rdplus <= rd4flip;
        else
          rdplus <= rd4p;
        end if;

        if (bad_rd4 or bad_rd6 or bad_ein6 or bad_ein4) = '1' then
          rd_defined <= '0';
        else
          rd_defined <= '1';
        end if;
        err <= (not rd_defined) & bad_rd4 & bad_rd6 & bad_ein6 & bad_ein4;
      end if;
    end if;
  end process;

  -- out signal
  rdp <= rdplus;
  
end implementation;

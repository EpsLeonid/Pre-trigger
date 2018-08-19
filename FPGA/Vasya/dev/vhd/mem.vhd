------------------------------------------------------------------------
---- SIMPLE DUAL PORT BRAM WITH COMMON CLOCK ---------------------------
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity bram_sdp_cc is
generic (
    DATA     : integer := 16;
    ADDR     : integer := 10
);
port (
    -- Port A
    clka   : in  std_logic;
    wea    : in  std_logic;
    addra  : in  std_logic_vector(ADDR-1 downto 0);
    dina   : in  std_logic_vector(DATA-1 downto 0);
    -- Port B
    addrb  : in  std_logic_vector(ADDR-1 downto 0);
    doutb  : out std_logic_vector(DATA-1 downto 0)
);
end bram_sdp_cc;
 
architecture rtl of bram_sdp_cc is
    -- Shared memory
    type mem_type is array ( (2**ADDR)-1 downto 0 ) of std_logic_vector(DATA-1 downto 0);
    signal mem : mem_type := (others => (others => '0'));
begin
 
process(clka)
begin
    if(clka'event and clka='1') then
        if(wea='1') then
            mem(conv_integer(addra)) <= dina;
        end if;
        doutb <= mem(conv_integer(addrb));
    end if;
end process;
 
end rtl;
------------------------------------------------------------------------

------------------------------------------------------------------------
---- SIMPLE DUAL PORT BRAM ---------------------------------------------
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity bram_sdp is
generic (
    DATA     : integer := 16;
    ADDR     : integer := 10
);
port (
    -- Port A
    clka   : in  std_logic;
    wea    : in  std_logic;
    addra  : in  std_logic_vector(ADDR-1 downto 0);
    dina   : in  std_logic_vector(DATA-1 downto 0);
    -- Port B
    clkb   : in  std_logic;
    addrb  : in  std_logic_vector(ADDR-1 downto 0);
    doutb  : out std_logic_vector(DATA-1 downto 0)
);
end bram_sdp;
 
architecture rtl of bram_sdp is
    -- Shared memory
    type mem_type is array ( (2**ADDR)-1 downto 0 ) of std_logic_vector(DATA-1 downto 0);
    signal mem : mem_type := (others => (others => '0'));
begin
 
process(clka)
begin
    if(clka'event and clka='1') then
        if(wea='1') then
            mem(conv_integer(addra)) <= dina;
        end if;
    end if;
end process;

process(clkb)
begin
    if(clkb'event and clkb='1') then
        doutb <= mem(conv_integer(addrb));
    end if;
end process;
 
end rtl;
------------------------------------------------------------------------


------------------------------------------------------------------------
---- SIMPLE DUAL PORT BRAM 12x5 WITH INITIAL DATA ----------------------
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.types.all;

entity bram_12x5_sdp is
generic(
  DEFAULTS : t_mem_12x32_array := (others => (others => '0'))
);
port (
    -- Port A
    clka   : in  std_logic;
    wea    : in  std_logic;
    addra  : in  std_logic_vector(4 downto 0);
    dina   : in  std_logic_vector(11 downto 0);
     
    -- Port B
    addrb  : in  std_logic_vector(4 downto 0);
    doutb  : out std_logic_vector(11 downto 0)
);
end bram_12x5_sdp;
 
architecture rtl of bram_12x5_sdp is
    signal mem : t_mem_12x32_array := DEFAULTS;

    attribute ram_style : string;
    attribute ram_style of mem : signal is "block";
begin
 
process(clka)
begin
    if(clka'event and clka='1') then
        if(wea='1') then
            mem(conv_integer(addra)) <= dina;
        end if;
        doutb <= mem(conv_integer(addrb));
    end if;
end process;
 
end rtl;

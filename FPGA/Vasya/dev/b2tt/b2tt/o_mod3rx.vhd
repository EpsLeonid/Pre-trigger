--- --------------------------------------------------------------------
--
--- o_mod3rx.vhd -- modulated signal receiver at 42 MHz
--
--  Mikihiko Nakao, KEK IPNS
--
--  - o_mod3tx generates 5 clock series of 0 or 1 to send a state and
--    no more than 2 clock series of 0 or 1 otherwise
--  - since no clock synchronization is made, 5 clock series may be
--    decoded as 4 clock series, or 2 clock series as 3 clock series
--  - at least finding a 4 clock series guarantees that the state is
--    received
--  - in o_mod3tx, state change occurs only once in three clocks, or
--    effectively at 42 MHz when the system is driven by 127 MHz
--
--- revision
--  20180320  new
--
--- --------------------------------------------------------------------

--- o_mod3rx: libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

--- o_mod3rx: entity
entity o_mod3rx is
  port (
    clock     : in  std_logic;
    reset     : in  std_logic;
    inp       : in  std_logic;
    inn       : in  std_logic;
    state     : out std_logic );
end o_mod3rx;

--- o_mod3rx: architecture
architecture implementation of o_mod3rx is

  signal sig_raw   : std_logic;
  signal seq_raw   : std_logic_vector (3 downto 0) := (others => '0');
  
--- o_mod3rx: begin
begin

  map_i: ibufds port map
    ( o => sig_raw, i => inp, ib => inn );

  proc: process (clock)
  begin
    if rising_edge(clock) then
      seq_raw <= seq_raw(seq_raw'left - 1 downto 0) & sig_raw;
      if reset = '1' then
        state <= '0';
      elsif seq_raw = "1111" then
        state <= '1';
      elsif seq_raw = "0000" then
        state <= '0';
      end if;
    end if;
  end process;
  
end implementation;

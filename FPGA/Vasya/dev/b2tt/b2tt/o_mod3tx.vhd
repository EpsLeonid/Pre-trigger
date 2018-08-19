--- --------------------------------------------------------------------
--
--- o_mod3tx.vhd -- modulated signal transmitter at 42 Mbps
--
--  Mikihiko Nakao, KEK IPNS
--
--- revision
--  20180320  new
--
--- --------------------------------------------------------------------

--- o_mod3tx: libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--- o_mod3tx: entity
entity o_mod3tx is
  port (
    clock     : in  std_logic;
    reset     : in  std_logic;
    state     : in  std_logic;
    modout    : out std_logic );
end o_mod3tx;

--- o_mod3tx: architecture
architecture implementation of o_mod3tx is

  signal cnt_clock : std_logic_vector (1 downto 0) := (others => '0');
  signal cnt_state : std_logic_vector (5 downto 0) := (others => '0');
  signal seq_state : std_logic_vector (1 downto 0) := "00";
  signal seq_out   : std_logic_vector (2 downto 0) := (others => '0');
  signal seq_hi    : std_logic := '0';

--- o_mod3tx: begin
begin

  proc_oddr: process (clock)
  begin
    if rising_edge(clock) then
      
      -- to make the phase deterministic
      if reset = '1' or cnt_clock = 2 then
        cnt_clock <= (others => '0');
      else
        cnt_clock <= cnt_clock + 1;
      end if;
      
      -- only once in 3 clocks
      if cnt_clock = 0 then
        cnt_state <= cnt_state + 1;
        seq_state <= seq_state(0) & state; -- state is sampled only here
        if seq_state = "01" or (cnt_state = 0 and seq_state(0) = '1') then
          seq_out <= "111";
          seq_hi  <= '1';
        elsif seq_state = "10" or (cnt_state = 0 and seq_state(0) = '0') then
          seq_out <= "000";
          seq_hi  <= '0';
        else
          -- if no state transition,
          --   111 --> 110  (5x bit 1)
          --   000 --> 001  (5x bit 0)
          --   110 --> 100  (only up to 2x bit 0 or 1)
          --   100 --> 110  (only up to 2x bit 0 or 1)
          seq_out <= seq_state(0) & seq_hi & (not seq_state(0));
          seq_hi  <= not seq_hi;
        end if;
      else
        seq_out <= seq_out(seq_out'left - 1 downto 0) & seq_out(seq_out'left);
      end if;
      
    end if;
  end process;

  modout <= seq_out(seq_out'left);

end implementation;

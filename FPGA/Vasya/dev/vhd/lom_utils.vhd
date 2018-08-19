------------------------------------------
-- COINCIDENCE UNIT 
------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.types.all;

entity coincidence is
  generic (
    INPUT_BITS  : integer := 12;
    COIDUR_BITS : integer := 16
  );
  port (
    i_clock            :  in std_logic;
    i_reset            :  in std_logic; 
    i_data_1           :  in std_logic;
    i_data_2           :  in std_logic;
    
    o_coin_hit         :  out std_logic;
    o_coin             :  out std_logic
  );
end coincidence;

architecture coin_arch of coincidence is

  signal s_data_1          : std_logic := '0';
  signal s_data_2          : std_logic := '0';
  signal s_coin            : std_logic := '0';
  signal s_coin_prev       : std_logic := '0';
  signal s_coin_meta       : std_logic := '0';
  signal s_coidur_hit       : std_logic := '0';


begin
  COIN : process(i_clock, i_reset)
  begin
    if i_reset = '1' then
      
      s_coin            <= '0';
      s_coin_meta       <= '0';
      s_coin_prev       <= '0';
      s_coidur_hit       <= '0';
      s_data_1           <= '0';
      s_data_2           <= '0';
    elsif rising_edge(i_clock) then

      s_coidur_hit <= '0';
      s_coin_meta  <= s_coin;
      s_coin_prev  <= s_coin_meta;
      s_data_1 <= i_data_1;
      s_data_2 <= i_data_2;

      o_coin_hit <= '0';
      if s_data_1 = '1' and s_data_2 = '1' then
        if s_coin = '0' then
          o_coin_hit <= '1'; -- raise for one clock cycle
        end if;
        s_coin   <= '1';
      else
        s_coin   <= '0';
      end if;

      o_coin <= s_coin;

    end if;

  end process COIN;


end coin_arch;
------------------------------------------

------------------------------------------
-- DISCRIMINATOR
------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
library work;
use work.types.all;

entity discriminator is
  generic (
    INPUT_BITS  : integer := 12
  );
  port (
    i_clock     : in std_logic;
    i_reset     : in std_logic;
    i_enable    : in std_logic;
    
    i_threshold : in std_logic_vector(INPUT_BITS-1 downto 0); 
    i_texp      : in t_reg_data;

    i_input     : in std_logic_vector(INPUT_BITS-1 downto 0);

    o_texp      : out std_logic;
    o_gate      : out std_logic; 
    o_hit       : out std_logic
  );
end discriminator;

architecture discr_arch of discriminator is
  signal s_tcnt   : t_reg_data := (others => '0');
  signal s_gate   : std_logic  := '0';
  signal s_gate_pre : std_logic  := '0';
  signal s_start  : std_logic  := '0';
  signal s_texp   : std_logic  := '0';
  signal s_hit    : std_logic  := '0';
begin

  process(i_clock) 
  begin
    IF_EDGE : if rising_edge(i_clock) then

      if i_reset = '1' then
        s_tcnt   <= (others => '0');
        s_gate   <= '0';
        s_gate_pre <= '0';
        s_start  <= '0';
        s_texp   <= '0';
      elsif i_enable = '1' then

        s_hit  <= '0';
        if i_input > i_threshold then
          s_gate <= '1';
          if s_gate = '0' and s_texp = '0' then
            s_hit  <= '1';
            s_texp <= '1'; 
            s_tcnt <= s_tcnt + '1';
          end if;
        else
          s_gate <= '0';
        end if;

        if s_texp = '1' and s_tcnt < i_texp then
          s_tcnt <= s_tcnt + '1';
          s_texp <= '1';
        else 
          s_tcnt <= (others => '0');
        end if;
        if s_tcnt = i_texp then
          s_texp <= '0';
        end if;
        
        s_gate_pre <= s_gate or s_texp;

      else -- NOT_ENA
        s_texp <= '0';
        s_gate <= '0';
      end if;

    end if IF_EDGE;
  end process;

  
  o_hit  <= s_hit;
  o_texp <= s_texp;
  o_gate <= s_gate_pre;

end discr_arch;
------------------------------------------


------------------------------------------
--  PEAK DETECTOR
------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.types.all;

entity peak_detector is
  generic (
    INPUT_BITS  : integer := 12
  );
  port(
    i_clock  : in std_logic;
    i_rst    : in std_logic;
    i_gate   : in std_logic;
    i_data   : in std_logic_vector(INPUT_BITS-1 downto 0);

    o_wena   : out std_logic; -- high for one clock cycle at the end of gate signal
    o_ampl   : out std_logic_vector(INPUT_BITS-1 downto 0)
  );
end peak_detector;

architecture ampl_arch of peak_detector is
  signal s_ampl      : std_logic_vector(INPUT_BITS-1 downto 0) := (others => '0');
  signal s_ampl_r    : std_logic_vector(INPUT_BITS-1 downto 0) := (others => '0');
  signal s_data      : std_logic_vector(INPUT_BITS-1 downto 0) := (others => '0');
  signal s_gate      : std_logic := '0';
  signal s_gate_prev : std_logic := '0';
  signal s_gate_next : std_logic := '0';
  signal s_wena      : std_logic := '0';
begin
  process(i_clock, i_rst)
  begin

    if i_rst = '1' then 
      s_ampl      <= (others => '0');
      s_data      <= (others => '0');
      s_gate      <= '0';
      s_gate_prev <= '0';
      s_gate_next <= '0';
      s_wena      <= '0';
      s_ampl_r    <= (others => '0');

    elsif rising_edge(i_clock) then -- RISING EDGE

      s_data <= i_data;
      if i_gate = '0' and s_wena = '1' then
        s_ampl <= (others => '0');
      elsif s_data > s_ampl then
        s_ampl <= s_data;
      else
        s_ampl <= s_ampl;
      end if;
      
      s_gate_next <= i_gate;
      s_gate_prev <= s_gate_next;
      
      if s_gate_next = '0' and s_gate_prev = '1' then
        s_ampl_r <= s_ampl;
        s_wena <= '1';
      else 
        s_wena <= '0';
      end if;
    end if;

  end process;

  o_ampl <= s_ampl_r;
  o_wena <= s_wena;

end ampl_arch;

------------------------------------------


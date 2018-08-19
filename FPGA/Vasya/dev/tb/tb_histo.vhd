LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity tb_histo is
end tb_histo;

architecture behavorial of tb_histo is
begin
  histo : entity work.histo 
  port map (
    i_clock     => s_clock,     
    i_reset     => s_reset,
    i_clear     => s_clear,

    i_run       => s_run,
    i_test_mode => s_test_mode,

    i_wena      => s_wena, 
    i_data      => s_idata,

    i_raddr     => s_raddr,
    o_rdata     => s_rdata,
    o_overflow  => s_overflow
  )

end behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library work;
use work.constants.all;
use work.types.all;
use work.utils.all;
use work.reg_map.all;
 
ENTITY tb_my IS
END tb_my;
 
ARCHITECTURE behavior OF tb_my IS 
  signal s_index_0      : integer := get_reg_index("STATUS", REG_MAPPER); 

BEGIN
 
END;


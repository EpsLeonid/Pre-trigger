---------------------------------------------------------------------
-- set of functions for registers mapping
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;
use work.types.all;

package utils is

  -- get index of the register in the array by its name
  function get_reg_index
  (NAME : string; INREC : t_reg_info_array) return integer;
  
  -- generate array of registers by given array of registers parameters
  function get_reg_from_rec (INREC : t_reg_info_array) return t_reg_array;
  
  -- generate array of the register parameters for iterable registers
  function gen_rec_array 
    (BASENAME : string; BASEADDR : t_reg_addr; DEFVAL : t_reg_data; ACCT : t_reg_acc; N : integer) 
      return t_reg_info_array;

end package utils;

package body utils is
  
  -------------------------------------------------------------------
  --- generate registers info by given template
  -------------------------------------------------------------------
  function gen_rec_array 
  (BASENAME : string; BASEADDR : t_reg_addr; DEFVAL : t_reg_data; ACCT : t_reg_acc; N : integer)
  return t_reg_info_array is
    variable v_regInfo_array : t_reg_info_array(0 to N-1);
    variable v_zero_rec      : t_reg_info := ((others => ' '), (others => '0'), (others => '0'), (others => '0'));
    variable v_name : string(1 to 20) := (others=>' ');
    variable v_addr : t_reg_addr;
    variable v_defv : t_reg_data := DEFVAL;
    variable v_acct : t_reg_acc  := ACCT;
    variable v_len  : integer    := 0;
  begin
    for ii in 0 to N-1 loop 
      v_len := integer'IMAGE(ii+1)'length;
      v_name(1 to v_len + BASENAME'length) := BASENAME & integer'IMAGE(ii+1);
      v_addr := BASEADDR + std_logic_vector(to_unsigned(ii,t_reg_addr'length));
      v_regInfo_array(ii) := (v_name(1 to v_zero_rec.NAME'length), v_addr, v_defv, v_acct);
    end loop;
    return v_regInfo_array;
  end function gen_rec_array;
  -------------------------------------------------------------------

  -------------------------------------------------------------------
  -- get index of the register by given name
  -------------------------------------------------------------------
  function get_reg_index 
  (NAME : string; INREC : t_reg_info_array) return integer is
    variable index     : integer := 0;
    variable v_name    : string(1 to NAME'length) := NAME;
    variable v_reginfo : t_reg_info;
    variable v_reginfo_arr : t_reg_info_array(0 to INREC'length-1) := INREC;
  begin
    -- for simulation
    report "LENGTH :: " & integer'image(INREC'length);
    v_reginfo := v_reginfo_arr(1);
    for ii in 0 to INREC'length-1 loop
      if v_reginfo_arr(ii).NAME(1 to v_name'length) = v_name then
        index := ii;
      end if;
    end loop;
    -- for simulation
    report "REG NAME :: " & NAME(1 to NAME'length) & " INDEX :: " & integer'image(index);
    return index;
  end function get_reg_index;
  -------------------------------------------------------------------

  -------------------------------------------------------------------
  -- generate array of default registers data from registers info array
  -------------------------------------------------------------------
  function get_reg_from_rec (INREC : t_reg_info_array) return t_reg_array is
    variable v_data : t_reg_array(0 to INREC'length-1) := (others => (others => '0'));
    variable v_reginfo_arr : t_reg_info_array(0 to INREC'length-1) := INREC;
  begin
    for ii in 0 to v_reginfo_arr'length-1 loop 
      v_data(ii) := v_reginfo_arr(ii).DEFVAL;
    end loop;
    return v_data;
  end function get_reg_from_rec;
  -------------------------------------------------------------------

end package body utils;


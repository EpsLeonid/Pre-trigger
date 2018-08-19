proc pnsimmodel {} {
  if { [ catch { xload xmp /home/shebalin/lom/fpga/dev/prj/system/system.xmp } result ] } {
    exit 10
  }
  set simulator_bak [xget simulator]
  set sim_model_bak [xget sim_model]
  set sim_x_lib_bak [xget sim_x_lib]
  set xps_hdl_bak   [xget hdl]
  set xps_gen_sim_tb_bak [xget gen_sim_tb]
  xset gen_sim_tb true
  xset simulator mgm
  xset sim_model behavioral
  xset hdl       vhdl
  xset sim_x_lib /home/shebalin/Xilinx/14.7/ISE_DS/ISE/mti_se/10.1c/lin
  if { [catch {run simmodel} result] } {
    return -1
  }
  xset simulator $simulator_bak
  xset sim_model $sim_model_bak
  xset sim_x_lib $sim_x_lib_bak
  xset hdl       $xps_hdl_bak
  xset gen_sim_tb $xps_gen_sim_tb_bak
  return $result
}
if { [catch {pnsimmodel} result] } {
  exit -1
}
exit $result

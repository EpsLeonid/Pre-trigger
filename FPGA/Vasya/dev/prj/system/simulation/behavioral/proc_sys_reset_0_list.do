#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     proc_sys_reset_0_list.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_proc_sys_reset_0_wrapper
#  Instance proc_sys_reset_0
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Slowest_sync_clk
  eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Ext_Reset_In
  eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Aux_Reset_In
  eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}MB_Debug_Sys_Rst
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Core_Reset_Req_0
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Chip_Reset_Req_0
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}System_Reset_Req_0
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Core_Reset_Req_1
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Chip_Reset_Req_1
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}System_Reset_Req_1
  eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Dcm_locked
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}RstcPPCresetcore_0
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}RstcPPCresetchip_0
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}RstcPPCresetsys_0
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}RstcPPCresetcore_1
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}RstcPPCresetchip_1
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}RstcPPCresetsys_1
  eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}MB_Reset
  eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Bus_Struct_Reset
  eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Peripheral_Reset
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Interconnect_aresetn
# eval add list $binopt $tbpath${ps}proc_sys_reset_0${ps}Peripheral_aresetn


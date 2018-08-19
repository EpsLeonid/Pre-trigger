#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     ilmb_list.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_ilmb_wrapper
#  Instance ilmb
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

# eval add list $binopt $tbpath${ps}ilmb${ps}LMB_Clk
# eval add list $binopt $tbpath${ps}ilmb${ps}SYS_Rst
  eval add list $binopt $tbpath${ps}ilmb${ps}LMB_Rst
# eval add list $hexopt $tbpath${ps}ilmb${ps}M_ABus
# eval add list $binopt $tbpath${ps}ilmb${ps}M_ReadStrobe
# eval add list $binopt $tbpath${ps}ilmb${ps}M_WriteStrobe
# eval add list $binopt $tbpath${ps}ilmb${ps}M_AddrStrobe
# eval add list $hexopt $tbpath${ps}ilmb${ps}M_DBus
# eval add list $hexopt $tbpath${ps}ilmb${ps}M_BE
# eval add list $hexopt $tbpath${ps}ilmb${ps}Sl_DBus
# eval add list $binopt $tbpath${ps}ilmb${ps}Sl_Ready
# eval add list $binopt $tbpath${ps}ilmb${ps}Sl_Wait
# eval add list $binopt $tbpath${ps}ilmb${ps}Sl_UE
# eval add list $binopt $tbpath${ps}ilmb${ps}Sl_CE
  eval add list $hexopt $tbpath${ps}ilmb${ps}LMB_ABus
  eval add list $binopt $tbpath${ps}ilmb${ps}LMB_ReadStrobe
  eval add list $binopt $tbpath${ps}ilmb${ps}LMB_WriteStrobe
  eval add list $binopt $tbpath${ps}ilmb${ps}LMB_AddrStrobe
  eval add list $hexopt $tbpath${ps}ilmb${ps}LMB_ReadDBus
  eval add list $hexopt $tbpath${ps}ilmb${ps}LMB_WriteDBus
  eval add list $binopt $tbpath${ps}ilmb${ps}LMB_Ready
  eval add list $binopt $tbpath${ps}ilmb${ps}LMB_Wait
  eval add list $binopt $tbpath${ps}ilmb${ps}LMB_UE
  eval add list $binopt $tbpath${ps}ilmb${ps}LMB_CE
  eval add list $hexopt $tbpath${ps}ilmb${ps}LMB_BE


#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     dlmb_wave.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_dlmb_wrapper
#  Instance dlmb
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  eval add wave -noupdate -divider {"dlmb"}
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}SYS_Rst
  eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_Rst
# eval add wave -noupdate $hexopt $tbpath${ps}dlmb${ps}M_ABus
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}M_ReadStrobe
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}M_WriteStrobe
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}M_AddrStrobe
# eval add wave -noupdate $hexopt $tbpath${ps}dlmb${ps}M_DBus
# eval add wave -noupdate $hexopt $tbpath${ps}dlmb${ps}M_BE
# eval add wave -noupdate $hexopt $tbpath${ps}dlmb${ps}Sl_DBus
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}Sl_Ready
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}Sl_Wait
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}Sl_UE
# eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}Sl_CE
  eval add wave -noupdate $hexopt $tbpath${ps}dlmb${ps}LMB_ABus
  eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_ReadStrobe
  eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_WriteStrobe
  eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_AddrStrobe
  eval add wave -noupdate $hexopt $tbpath${ps}dlmb${ps}LMB_ReadDBus
  eval add wave -noupdate $hexopt $tbpath${ps}dlmb${ps}LMB_WriteDBus
  eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_Ready
  eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_Wait
  eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_UE
  eval add wave -noupdate $binopt $tbpath${ps}dlmb${ps}LMB_CE
  eval add wave -noupdate $hexopt $tbpath${ps}dlmb${ps}LMB_BE


#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     LEDS_wave.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_leds_wrapper
#  Instance LEDS
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  eval add wave -noupdate -divider {"LEDS"}
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}SPLB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}SPLB_Rst
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_UABus
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_PAValid
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_SAValid
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_rdPrim
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_wrPrim
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_masterID
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_abort
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_busLock
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_RNW
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_MSize
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_size
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_type
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_lockErr
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_wrDBus
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_wrBurst
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_rdBurst
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_wrPendReq
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}PLB_rdPendReq
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_wrPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_rdPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_reqPri
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}PLB_TAttribute
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_addrAck
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}Sl_SSize
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_wait
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_rearbitrate
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_wrDAck
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_wrComp
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_wrBTerm
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}Sl_rdDBus
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}Sl_rdWdAddr
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_rdDAck
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_rdComp
  eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}Sl_rdBTerm
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}Sl_MBusy
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}Sl_MWrErr
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}Sl_MRdErr
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}Sl_MIRQ
# eval add wave -noupdate $binopt $tbpath${ps}LEDS${ps}IP2INTC_Irpt
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}GPIO_IO_I
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}GPIO_IO_O
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}GPIO_IO_T
  eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}GPIO2_IO_I
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}GPIO2_IO_O
# eval add wave -noupdate $hexopt $tbpath${ps}LEDS${ps}GPIO2_IO_T


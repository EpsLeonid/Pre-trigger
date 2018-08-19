#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     LEDS_list.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_leds_wrapper
#  Instance LEDS
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

# eval add list $binopt $tbpath${ps}LEDS${ps}SPLB_Clk
# eval add list $binopt $tbpath${ps}LEDS${ps}SPLB_Rst
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_ABus
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_UABus
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_PAValid
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_SAValid
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_rdPrim
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_wrPrim
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_masterID
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_abort
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_busLock
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_RNW
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_BE
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_MSize
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_size
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_type
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_lockErr
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_wrDBus
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_wrBurst
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_rdBurst
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_wrPendReq
# eval add list $binopt $tbpath${ps}LEDS${ps}PLB_rdPendReq
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_wrPendPri
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_rdPendPri
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_reqPri
# eval add list $hexopt $tbpath${ps}LEDS${ps}PLB_TAttribute
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_addrAck
  eval add list $hexopt $tbpath${ps}LEDS${ps}Sl_SSize
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_wait
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_rearbitrate
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_wrDAck
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_wrComp
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_wrBTerm
  eval add list $hexopt $tbpath${ps}LEDS${ps}Sl_rdDBus
  eval add list $hexopt $tbpath${ps}LEDS${ps}Sl_rdWdAddr
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_rdDAck
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_rdComp
  eval add list $binopt $tbpath${ps}LEDS${ps}Sl_rdBTerm
  eval add list $hexopt $tbpath${ps}LEDS${ps}Sl_MBusy
  eval add list $hexopt $tbpath${ps}LEDS${ps}Sl_MWrErr
  eval add list $hexopt $tbpath${ps}LEDS${ps}Sl_MRdErr
  eval add list $hexopt $tbpath${ps}LEDS${ps}Sl_MIRQ
# eval add list $binopt $tbpath${ps}LEDS${ps}IP2INTC_Irpt
  eval add list $hexopt $tbpath${ps}LEDS${ps}GPIO_IO_I
  eval add list $hexopt $tbpath${ps}LEDS${ps}GPIO_IO_O
# eval add list $hexopt $tbpath${ps}LEDS${ps}GPIO_IO_T
  eval add list $hexopt $tbpath${ps}LEDS${ps}GPIO2_IO_I
# eval add list $hexopt $tbpath${ps}LEDS${ps}GPIO2_IO_O
# eval add list $hexopt $tbpath${ps}LEDS${ps}GPIO2_IO_T


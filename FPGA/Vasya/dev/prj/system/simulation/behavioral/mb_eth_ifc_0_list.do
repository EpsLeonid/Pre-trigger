#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     mb_eth_ifc_0_list.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_mb_eth_ifc_0_wrapper
#  Instance mb_eth_ifc_0
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}SPLB_Clk
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}SPLB_Rst
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_ABus
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_UABus
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_PAValid
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_SAValid
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_rdPrim
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_wrPrim
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_masterID
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_abort
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_busLock
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_RNW
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_BE
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_MSize
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_size
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_type
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_lockErr
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_wrDBus
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_wrBurst
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_rdBurst
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_wrPendReq
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_rdPendReq
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_wrPendPri
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_rdPendPri
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_reqPri
# eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}PLB_TAttribute
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_addrAck
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_SSize
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_wait
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_rearbitrate
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_wrDAck
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_wrComp
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_wrBTerm
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_rdDBus
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_rdWdAddr
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_rdDAck
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_rdComp
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_rdBTerm
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_MBusy
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_MWrErr
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_MRdErr
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}Sl_MIRQ
# eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}IP2INTC_Irpt
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}clock
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}mem_addr
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}mem_wdata
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}mem_rdata
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}mem_we
  eval add list $binopt $tbpath${ps}mb_eth_ifc_0${ps}reg_we
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}reg_num
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}reg_wdata
  eval add list $hexopt $tbpath${ps}mb_eth_ifc_0${ps}reg_rdata


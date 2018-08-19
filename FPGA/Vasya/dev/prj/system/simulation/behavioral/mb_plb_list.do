#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     mb_plb_list.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_mb_plb_wrapper
#  Instance mb_plb
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_Clk
# eval add list $binopt $tbpath${ps}mb_plb${ps}SYS_Rst
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_Rst
  eval add list $hexopt $tbpath${ps}mb_plb${ps}SPLB_Rst
# eval add list $hexopt $tbpath${ps}mb_plb${ps}MPLB_Rst
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_dcrAck
# eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_dcrDBus
# eval add list $hexopt $tbpath${ps}mb_plb${ps}DCR_ABus
# eval add list $hexopt $tbpath${ps}mb_plb${ps}DCR_DBus
# eval add list $binopt $tbpath${ps}mb_plb${ps}DCR_Read
# eval add list $binopt $tbpath${ps}mb_plb${ps}DCR_Write
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_ABus
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_UABus
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_BE
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_RNW
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_abort
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_busLock
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_TAttribute
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_lockErr
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_MSize
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_priority
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_rdBurst
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_request
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_size
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_type
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_wrBurst
# eval add list $hexopt $tbpath${ps}mb_plb${ps}M_wrDBus
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_addrAck
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_MRdErr
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_MWrErr
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_MBusy
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_rdBTerm
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_rdComp
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_rdDAck
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_rdDBus
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_rdWdAddr
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_rearbitrate
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_SSize
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_wait
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_wrBTerm
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_wrComp
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_wrDAck
# eval add list $hexopt $tbpath${ps}mb_plb${ps}Sl_MIRQ
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MIRQ
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_ABus
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_UABus
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_BE
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MAddrAck
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MTimeout
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MBusy
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MRdErr
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MWrErr
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MRdBTerm
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MRdDAck
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MRdDBus
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MRdWdAddr
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MRearbitrate
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MWrBTerm
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MWrDAck
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MSSize
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_PAValid
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_RNW
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_SAValid
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_abort
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_busLock
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_TAttribute
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_lockErr
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_masterID
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_MSize
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_rdPendPri
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_wrPendPri
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_rdPendReq
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_wrPendReq
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_rdBurst
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_rdPrim
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_reqPri
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_size
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_type
  eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_wrBurst
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_wrDBus
  eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_wrPrim
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_SaddrAck
# eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_SMRdErr
# eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_SMWrErr
# eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_SMBusy
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_SrdBTerm
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_SrdComp
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_SrdDAck
# eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_SrdDBus
# eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_SrdWdAddr
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_Srearbitrate
# eval add list $hexopt $tbpath${ps}mb_plb${ps}PLB_Sssize
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_Swait
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_SwrBTerm
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_SwrComp
# eval add list $binopt $tbpath${ps}mb_plb${ps}PLB_SwrDAck
# eval add list $binopt $tbpath${ps}mb_plb${ps}Bus_Error_Det


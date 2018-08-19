#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     DIP_Switches_wave.tcl (Mon Oct  9 10:00:20 2017)
#
#  Module   system_dip_switches_wrapper
#  Instance DIP_Switches
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

# wave add $tbpath${ps}DIP_Switches${ps}SPLB_Clk -into $id
# wave add $tbpath${ps}DIP_Switches${ps}SPLB_Rst -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_ABus -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_UABus -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_PAValid -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_SAValid -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_rdPrim -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_wrPrim -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_masterID -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_abort -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_busLock -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_RNW -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_BE -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_MSize -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_size -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_type -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_lockErr -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_wrDBus -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_wrBurst -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_rdBurst -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_wrPendReq -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_rdPendReq -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_wrPendPri -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_rdPendPri -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_reqPri -into $id
# wave add $tbpath${ps}DIP_Switches${ps}PLB_TAttribute -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_addrAck -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_SSize -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_wait -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_rearbitrate -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_wrDAck -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_wrComp -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_wrBTerm -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_rdDBus -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_rdWdAddr -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_rdDAck -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_rdComp -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_rdBTerm -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_MBusy -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_MWrErr -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_MRdErr -into $id
  wave add $tbpath${ps}DIP_Switches${ps}Sl_MIRQ -into $id
# wave add $tbpath${ps}DIP_Switches${ps}IP2INTC_Irpt -into $id
  wave add $tbpath${ps}DIP_Switches${ps}GPIO_IO_I -into $id
# wave add $tbpath${ps}DIP_Switches${ps}GPIO_IO_O -into $id
# wave add $tbpath${ps}DIP_Switches${ps}GPIO_IO_T -into $id
  wave add $tbpath${ps}DIP_Switches${ps}GPIO2_IO_I -into $id
# wave add $tbpath${ps}DIP_Switches${ps}GPIO2_IO_O -into $id
# wave add $tbpath${ps}DIP_Switches${ps}GPIO2_IO_T -into $id


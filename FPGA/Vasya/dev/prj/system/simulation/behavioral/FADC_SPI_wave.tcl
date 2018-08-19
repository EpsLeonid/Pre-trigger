#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     FADC_SPI_wave.tcl (Mon Oct  9 10:00:20 2017)
#
#  Module   system_fadc_spi_wrapper
#  Instance FADC_SPI
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  wave add $tbpath${ps}FADC_SPI${ps}SCK_I -into $id
  wave add $tbpath${ps}FADC_SPI${ps}SCK_O -into $id
# wave add $tbpath${ps}FADC_SPI${ps}SCK_T -into $id
  wave add $tbpath${ps}FADC_SPI${ps}MISO_I -into $id
# wave add $tbpath${ps}FADC_SPI${ps}MISO_O -into $id
# wave add $tbpath${ps}FADC_SPI${ps}MISO_T -into $id
  wave add $tbpath${ps}FADC_SPI${ps}MOSI_I -into $id
  wave add $tbpath${ps}FADC_SPI${ps}MOSI_O -into $id
# wave add $tbpath${ps}FADC_SPI${ps}MOSI_T -into $id
  wave add $tbpath${ps}FADC_SPI${ps}SPISEL -into $id
  wave add $tbpath${ps}FADC_SPI${ps}SS_I -into $id
  wave add $tbpath${ps}FADC_SPI${ps}SS_O -into $id
# wave add $tbpath${ps}FADC_SPI${ps}SS_T -into $id
# wave add $tbpath${ps}FADC_SPI${ps}SPLB_Clk -into $id
# wave add $tbpath${ps}FADC_SPI${ps}SPLB_Rst -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_ABus -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_PAValid -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_masterID -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_RNW -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_BE -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_size -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_type -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_wrDBus -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_addrAck -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_SSize -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_wait -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_rearbitrate -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_wrDAck -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_wrComp -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_rdDBus -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_rdDAck -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_rdComp -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_MBusy -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_MWrErr -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_MRdErr -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_UABus -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_SAValid -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_rdPrim -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_wrPrim -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_abort -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_busLock -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_MSize -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_lockErr -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_wrBurst -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_rdBurst -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_wrPendReq -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_rdPendReq -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_wrPendPri -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_rdPendPri -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_reqPri -into $id
# wave add $tbpath${ps}FADC_SPI${ps}PLB_TAttribute -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_wrBTerm -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_rdWdAddr -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_rdBTerm -into $id
  wave add $tbpath${ps}FADC_SPI${ps}Sl_MIRQ -into $id
# wave add $tbpath${ps}FADC_SPI${ps}IP2INTC_Irpt -into $id


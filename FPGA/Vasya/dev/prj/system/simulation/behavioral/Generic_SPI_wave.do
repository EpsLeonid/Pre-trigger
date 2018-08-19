#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     Generic_SPI_wave.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_generic_spi_wrapper
#  Instance Generic_SPI
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  eval add wave -noupdate -divider {"Generic_SPI"}
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SCK_I
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SCK_O
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SCK_T
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}MISO_I
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}MISO_O
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}MISO_T
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}MOSI_I
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}MOSI_O
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}MOSI_T
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SPISEL
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SS_I
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SS_O
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SS_T
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SPLB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}SPLB_Rst
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_ABus
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_PAValid
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_masterID
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_RNW
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_size
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_type
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_wrDBus
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_addrAck
  eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}Sl_SSize
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_wait
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_rearbitrate
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_wrDAck
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_wrComp
  eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}Sl_rdDBus
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_rdDAck
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_rdComp
  eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}Sl_MBusy
  eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}Sl_MWrErr
  eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}Sl_MRdErr
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_UABus
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_SAValid
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_rdPrim
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_wrPrim
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_abort
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_busLock
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_MSize
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_lockErr
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_wrBurst
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_rdBurst
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_wrPendReq
# eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}PLB_rdPendReq
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_wrPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_rdPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_reqPri
# eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}PLB_TAttribute
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_wrBTerm
  eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}Sl_rdWdAddr
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}Sl_rdBTerm
  eval add wave -noupdate $hexopt $tbpath${ps}Generic_SPI${ps}Sl_MIRQ
  eval add wave -noupdate $binopt $tbpath${ps}Generic_SPI${ps}IP2INTC_Irpt


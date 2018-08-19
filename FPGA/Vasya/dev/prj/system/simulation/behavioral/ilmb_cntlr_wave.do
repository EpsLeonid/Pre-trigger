#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     ilmb_cntlr_wave.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_ilmb_cntlr_wrapper
#  Instance ilmb_cntlr
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  eval add wave -noupdate -divider {"ilmb_cntlr"}
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB_Rst
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB_WriteDBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB_AddrStrobe
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB_ReadStrobe
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB_WriteStrobe
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB_BE
  eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}Sl_DBus
  eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl_Ready
  eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl_Wait
  eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl_UE
  eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl_CE
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB1_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB1_WriteDBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB1_AddrStrobe
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB1_ReadStrobe
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB1_WriteStrobe
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB1_BE
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}Sl1_DBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl1_Ready
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl1_Wait
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl1_UE
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl1_CE
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB2_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB2_WriteDBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB2_AddrStrobe
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB2_ReadStrobe
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB2_WriteStrobe
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB2_BE
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}Sl2_DBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl2_Ready
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl2_Wait
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl2_UE
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl2_CE
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB3_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB3_WriteDBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB3_AddrStrobe
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB3_ReadStrobe
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}LMB3_WriteStrobe
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}LMB3_BE
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}Sl3_DBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl3_Ready
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl3_Wait
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl3_UE
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Sl3_CE
  eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}BRAM_Rst_A
  eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}BRAM_Clk_A
  eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}BRAM_EN_A
  eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}BRAM_WEN_A
  eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}BRAM_Addr_A
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}BRAM_Din_A
  eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}BRAM_Dout_A
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}Interrupt
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}UE
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}CE
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_ABus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_PAValid
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_masterID
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_RNW
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_size
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_type
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_wrDBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_addrAck
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_SSize
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_wait
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_rearbitrate
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_wrDAck
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_wrComp
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_rdDBus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_rdDAck
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_rdComp
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_MBusy
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_MWrErr
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_MRdErr
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_UABus
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_SAValid
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_rdPrim
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_wrPrim
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_abort
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_busLock
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_MSize
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_lockErr
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_wrBurst
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_rdBurst
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_wrPendReq
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_rdPendReq
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_wrPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_rdPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_reqPri
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_PLB_TAttribute
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_wrBTerm
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_rdWdAddr
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_rdBTerm
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}SPLB_CTRL_Sl_MIRQ
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_ACLK
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_ARESETN
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_AWADDR
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_AWVALID
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_AWREADY
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_WDATA
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_WSTRB
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_WVALID
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_WREADY
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_BRESP
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_BVALID
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_BREADY
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_ARADDR
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_ARVALID
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_ARREADY
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_RDATA
# eval add wave -noupdate $hexopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_RRESP
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_RVALID
# eval add wave -noupdate $binopt $tbpath${ps}ilmb_cntlr${ps}S_AXI_CTRL_RREADY


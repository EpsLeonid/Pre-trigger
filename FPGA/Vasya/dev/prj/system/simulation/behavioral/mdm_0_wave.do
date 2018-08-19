#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     mdm_0_wave.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_mdm_0_wrapper
#  Instance mdm_0
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  eval add wave -noupdate -divider {"mdm_0"}
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Interrupt
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Debug_SYS_Rst
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_BRK
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_NM_BRK
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_ACLK
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_ARESETN
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}S_AXI_AWADDR
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_AWVALID
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_AWREADY
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}S_AXI_WDATA
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}S_AXI_WSTRB
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_WVALID
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_WREADY
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}S_AXI_BRESP
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_BVALID
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_BREADY
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}S_AXI_ARADDR
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_ARVALID
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_ARREADY
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}S_AXI_RDATA
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}S_AXI_RRESP
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_RVALID
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}S_AXI_RREADY
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}SPLB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}SPLB_Rst
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_UABus
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_PAValid
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_SAValid
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_rdPrim
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_wrPrim
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_masterID
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_abort
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_busLock
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_RNW
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_MSize
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_size
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_type
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_lockErr
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_wrDBus
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_wrBurst
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_rdBurst
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_wrPendReq
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}PLB_rdPendReq
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_wrPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_rdPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_reqPri
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}PLB_TAttribute
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_addrAck
  eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Sl_SSize
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_wait
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_rearbitrate
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_wrDAck
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_wrComp
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_wrBTerm
  eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Sl_rdDBus
  eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Sl_rdWdAddr
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_rdDAck
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_rdComp
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Sl_rdBTerm
  eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Sl_MBusy
  eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Sl_MWrErr
  eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Sl_MRdErr
  eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Sl_MIRQ
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_0
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_0
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_0
  eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_0
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_0
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_0
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_0
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_0
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_1
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_1
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_1
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_1
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_1
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_1
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_1
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_1
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_2
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_2
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_2
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_2
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_2
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_2
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_2
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_2
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_3
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_3
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_3
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_3
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_3
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_3
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_3
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_3
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_4
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_4
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_4
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_4
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_4
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_4
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_4
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_4
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_5
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_5
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_5
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_5
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_5
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_5
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_5
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_5
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_6
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_6
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_6
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_6
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_6
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_6
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_6
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_6
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_7
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_7
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_7
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_7
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_7
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_7
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_7
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_7
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_8
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_8
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_8
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_8
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_8
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_8
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_8
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_8
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_9
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_9
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_9
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_9
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_9
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_9
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_9
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_9
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_10
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_10
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_10
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_10
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_10
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_10
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_10
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_10
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_11
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_11
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_11
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_11
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_11
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_11
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_11
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_11
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_12
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_12
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_12
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_12
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_12
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_12
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_12
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_12
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_13
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_13
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_13
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_13
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_13
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_13
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_13
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_13
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_14
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_14
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_14
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_14
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_14
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_14
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_14
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_14
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_15
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_15
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_15
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_15
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_15
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_15
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_15
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_15
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_16
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_16
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_16
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_16
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_16
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_16
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_16
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_16
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_17
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_17
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_17
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_17
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_17
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_17
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_17
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_17
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_18
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_18
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_18
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_18
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_18
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_18
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_18
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_18
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_19
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_19
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_19
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_19
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_19
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_19
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_19
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_19
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_20
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_20
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_20
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_20
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_20
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_20
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_20
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_20
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_21
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_21
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_21
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_21
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_21
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_21
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_21
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_21
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_22
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_22
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_22
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_22
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_22
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_22
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_22
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_22
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_23
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_23
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_23
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_23
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_23
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_23
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_23
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_23
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_24
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_24
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_24
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_24
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_24
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_24
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_24
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_24
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_25
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_25
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_25
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_25
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_25
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_25
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_25
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_25
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_26
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_26
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_26
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_26
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_26
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_26
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_26
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_26
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_27
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_27
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_27
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_27
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_27
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_27
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_27
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_27
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_28
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_28
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_28
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_28
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_28
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_28
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_28
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_28
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_29
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_29
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_29
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_29
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_29
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_29
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_29
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_29
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_30
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_30
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_30
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_30
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_30
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_30
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_30
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_30
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Clk_31
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDI_31
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_TDO_31
# eval add wave -noupdate $hexopt $tbpath${ps}mdm_0${ps}Dbg_Reg_En_31
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Capture_31
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Shift_31
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Update_31
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Dbg_Rst_31
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_tdi
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_reset
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_shift
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_update
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_capture
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_sel1
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_drck1
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_tdo1
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_ext_tdi
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_ext_reset
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_ext_shift
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_ext_update
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_ext_capture
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_ext_sel
  eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_ext_drck
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}bscan_ext_tdo
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_JTAG_DRCK
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_JTAG_RESET
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_JTAG_SEL
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_JTAG_CAPTURE
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_JTAG_SHIFT
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_JTAG_UPDATE
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_JTAG_TDI
# eval add wave -noupdate $binopt $tbpath${ps}mdm_0${ps}Ext_JTAG_TDO


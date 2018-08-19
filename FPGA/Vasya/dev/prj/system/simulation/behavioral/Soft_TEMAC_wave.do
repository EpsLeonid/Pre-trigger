#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     Soft_TEMAC_wave.do (Sat Mar 17 02:06:09 2018)
#
#  Module   system_soft_temac_wrapper
#  Instance Soft_TEMAC
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  eval add wave -noupdate -divider {"Soft_TEMAC"}
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TemacIntc0_Irpt
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TemacIntc1_Irpt
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TemacPhy_RST_n
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GTX_CLK_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MGTCLK_P
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MGTCLK_N
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}REFCLK
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}DCLK
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}SPLB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}SPLB_Rst
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Core_Clk
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_UABus
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_PAValid
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_SAValid
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_rdPrim
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_wrPrim
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_masterID
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_abort
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_busLock
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_RNW
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_MSize
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_size
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_type
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_lockErr
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_wrDBus
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_wrBurst
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_rdBurst
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_wrPendReq
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}PLB_rdPendReq
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_wrPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_rdPendPri
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_reqPri
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}PLB_TAttribute
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_addrAck
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Sl_SSize
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_wait
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_rearbitrate
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_wrDAck
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_wrComp
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_wrBTerm
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Sl_rdDBus
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Sl_rdWdAddr
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_rdDAck
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_rdComp
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Sl_rdBTerm
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Sl_MBusy
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Sl_MWrErr
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Sl_MRdErr
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Sl_MIRQ
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_CLK
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_RST
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_SOP_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_EOP_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_SOF_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_EOF_n
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_REM
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_Data
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_SRC_RDY_n
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_DST_RDY_n
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_SOP_n
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_EOP_n
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_SOF_n
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_EOF_n
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_REM
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_Data
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_SRC_RDY_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_DST_RDY_n
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_CLK
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_RST
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_SOP_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_EOP_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_SOF_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_EOF_n
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_REM
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_Data
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_SRC_RDY_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_DST_RDY_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_SOP_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_EOP_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_SOF_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_EOF_n
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_REM
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_Data
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_SRC_RDY_n
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_DST_RDY_n
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}MII_TXD_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_TX_EN_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_TX_ER_0
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}MII_RXD_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_RX_DV_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_RX_ER_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_RX_CLK_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_TX_CLK_0
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}MII_TXD_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_TX_EN_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_TX_ER_1
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}MII_RXD_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_RX_DV_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_RX_ER_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_RX_CLK_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MII_TX_CLK_1
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}GMII_TXD_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_TX_EN_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_TX_ER_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_TX_CLK_0
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}GMII_RXD_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_RX_DV_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_RX_ER_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_RX_CLK_0
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}GMII_TXD_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_TX_EN_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_TX_ER_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_TX_CLK_1
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}GMII_RXD_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_RX_DV_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_RX_ER_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}GMII_RX_CLK_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TXP_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TXN_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RXP_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RXN_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TXP_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TXN_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RXP_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RXN_1
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}RGMII_TXD_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RGMII_TX_CTL_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RGMII_TXC_0
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}RGMII_RXD_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RGMII_RX_CTL_0
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RGMII_RXC_0
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}RGMII_TXD_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RGMII_TX_CTL_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RGMII_TXC_1
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}RGMII_RXD_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RGMII_RX_CTL_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RGMII_RXC_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MDC_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MDC_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}HostMiimRdy
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}HostRdData
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}HostMiimSel
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}HostReq
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}HostAddr
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}HostEmac1Sel
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0AvbTxClk
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0AvbTxClkEn
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0AvbRxClk
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac0AvbRxClkEn
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Avb2Mac0TxData
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Mac0TxDataValid
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Mac0TxUnderrun
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Mac02AvbTxAck
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Mac02AvbRxData
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Mac02AvbRxDataValid
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Mac02AvbRxFrameGood
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Mac02AvbRxFrameBad
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Temac02AvbTxData
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac02AvbTxDataValid
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac02AvbTxUnderrun
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0TxAck
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0RxData
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0RxDataValid
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0RxFrameGood
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0RxFrameBad
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1AvbTxClk
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1AvbTxClkEn
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1AvbRxClk
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac1AvbRxClkEn
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Avb2Mac1TxData
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Mac1TxDataValid
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Mac1TxUnderrun
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Mac12AvbTxAck
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Mac12AvbRxData
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Mac12AvbRxDataValid
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Mac12AvbRxFrameGood
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Mac12AvbRxFrameBad
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Temac12AvbTxData
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac12AvbTxDataValid
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Temac12AvbTxUnderrun
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1TxAck
  eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1RxData
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1RxDataValid
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1RxFrameGood
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1RxFrameBad
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TxClientClk_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientTxStat_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientTxStatsVld_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientTxStatsByteVld_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RxClientClk_0
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}ClientRxStats_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientRxStatsVld_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientRxStatsByteVld_0
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}TxClientClk_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientTxStat_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientTxStatsVld_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientTxStatsByteVld_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}RxClientClk_1
# eval add wave -noupdate $hexopt $tbpath${ps}Soft_TEMAC${ps}ClientRxStats_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientRxStatsVld_1
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}ClientRxStatsByteVld_1
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MDIO_0_I
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MDIO_0_O
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MDIO_0_T
  eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MDIO_1_I
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MDIO_1_O
# eval add wave -noupdate $binopt $tbpath${ps}Soft_TEMAC${ps}MDIO_1_T


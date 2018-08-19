#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     Soft_TEMAC_wave.tcl (Mon Oct  9 10:00:20 2017)
#
#  Module   system_soft_temac_wrapper
#  Instance Soft_TEMAC
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

  wave add $tbpath${ps}Soft_TEMAC${ps}TemacIntc0_Irpt -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}TemacIntc1_Irpt -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}TemacPhy_RST_n -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GTX_CLK_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MGTCLK_P -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MGTCLK_N -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}REFCLK -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}DCLK -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}SPLB_Clk -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}SPLB_Rst -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Core_Clk -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_ABus -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_UABus -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_PAValid -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_SAValid -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_rdPrim -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_wrPrim -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_masterID -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_abort -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_busLock -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_RNW -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_BE -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_MSize -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_size -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_type -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_lockErr -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_wrDBus -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_wrBurst -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_rdBurst -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_wrPendReq -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_rdPendReq -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_wrPendPri -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_rdPendPri -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_reqPri -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}PLB_TAttribute -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_addrAck -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_SSize -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_wait -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_rearbitrate -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_wrDAck -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_wrComp -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_wrBTerm -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_rdDBus -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_rdWdAddr -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_rdDAck -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_rdComp -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_rdBTerm -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_MBusy -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_MWrErr -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_MRdErr -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Sl_MIRQ -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_CLK -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_RST -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_SOP_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_EOP_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_SOF_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_EOF_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_REM -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_Data -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_SRC_RDY_n -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_DST_RDY_n -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_SOP_n -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_EOP_n -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_SOF_n -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_EOF_n -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_REM -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_Data -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Temac0Llink_SRC_RDY_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac0_DST_RDY_n -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_CLK -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_RST -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_SOP_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_EOP_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_SOF_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_EOF_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_REM -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_Data -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_SRC_RDY_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_DST_RDY_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_SOP_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_EOP_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_SOF_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_EOF_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_REM -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_Data -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1Llink_SRC_RDY_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}LlinkTemac1_DST_RDY_n -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MII_TXD_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MII_TX_EN_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MII_TX_ER_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_RXD_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_RX_DV_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_RX_ER_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_RX_CLK_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_TX_CLK_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MII_TXD_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MII_TX_EN_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MII_TX_ER_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_RXD_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_RX_DV_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_RX_ER_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_RX_CLK_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MII_TX_CLK_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_TXD_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_TX_EN_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_TX_ER_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_TX_CLK_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_RXD_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_RX_DV_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_RX_ER_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_RX_CLK_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}GMII_TXD_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}GMII_TX_EN_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}GMII_TX_ER_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}GMII_TX_CLK_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_RXD_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_RX_DV_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_RX_ER_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}GMII_RX_CLK_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}TXP_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}TXN_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RXP_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RXN_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}TXP_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}TXN_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RXP_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RXN_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_TXD_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_TX_CTL_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_TXC_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_RXD_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_RX_CTL_0 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_RXC_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_TXD_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_TX_CTL_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_TXC_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_RXD_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_RX_CTL_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}RGMII_RXC_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MDC_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MDC_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}HostMiimRdy -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}HostRdData -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}HostMiimSel -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}HostReq -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}HostAddr -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}HostEmac1Sel -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac0AvbTxClk -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac0AvbTxClkEn -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac0AvbRxClk -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac0AvbRxClkEn -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Mac0TxData -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Mac0TxDataValid -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Mac0TxUnderrun -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac02AvbTxAck -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac02AvbRxData -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac02AvbRxDataValid -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac02AvbRxFrameGood -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac02AvbRxFrameBad -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac02AvbTxData -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac02AvbTxDataValid -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac02AvbTxUnderrun -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0TxAck -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0RxData -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0RxDataValid -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0RxFrameGood -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac0RxFrameBad -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1AvbTxClk -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1AvbTxClkEn -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1AvbRxClk -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac1AvbRxClkEn -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Mac1TxData -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Mac1TxDataValid -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Mac1TxUnderrun -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac12AvbTxAck -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac12AvbRxData -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac12AvbRxDataValid -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac12AvbRxFrameGood -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Mac12AvbRxFrameBad -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac12AvbTxData -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac12AvbTxDataValid -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}Temac12AvbTxUnderrun -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1TxAck -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1RxData -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1RxDataValid -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1RxFrameGood -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}Avb2Temac1RxFrameBad -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}TxClientClk_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientTxStat_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientTxStatsVld_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientTxStatsByteVld_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}RxClientClk_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientRxStats_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientRxStatsVld_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientRxStatsByteVld_0 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}TxClientClk_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientTxStat_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientTxStatsVld_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientTxStatsByteVld_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}RxClientClk_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientRxStats_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientRxStatsVld_1 -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}ClientRxStatsByteVld_1 -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MDIO_0_I -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MDIO_0_O -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MDIO_0_T -into $id
  wave add $tbpath${ps}Soft_TEMAC${ps}MDIO_1_I -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MDIO_1_O -into $id
# wave add $tbpath${ps}Soft_TEMAC${ps}MDIO_1_T -into $id


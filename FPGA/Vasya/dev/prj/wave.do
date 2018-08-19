onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/CLK_50MHZ
add wave -noupdate /tb_top/OSC_50MHZ
add wave -noupdate /tb_top/RESET_P
add wave -noupdate /tb_top/SYS_RST
add wave -noupdate /tb_top/SDATAP
add wave -noupdate /tb_top/SDATAN
add wave -noupdate /tb_top/DCOP
add wave -noupdate /tb_top/DCON
add wave -noupdate /tb_top/FCOP
add wave -noupdate /tb_top/FCON
add wave -noupdate /tb_top/PG
add wave -noupdate /tb_top/CLK_MODE
add wave -noupdate /tb_top/VETO
add wave -noupdate /tb_top/ADC_SDIO
add wave -noupdate /tb_top/DDR3_LDQS_P
add wave -noupdate /tb_top/DDR3_LDQS_N
add wave -noupdate /tb_top/DDR3_UDQS_P
add wave -noupdate /tb_top/DDR3_UDQS_N
add wave -noupdate /tb_top/DDR3_DQ
add wave -noupdate /tb_top/TP
add wave -noupdate /tb_top/ADC_SCLK
add wave -noupdate /tb_top/ADC_CSB
add wave -noupdate /tb_top/ADC_CLKP
add wave -noupdate /tb_top/ADC_CLKN
add wave -noupdate /tb_top/DDR3_CLK_P
add wave -noupdate /tb_top/DDR3_CLK_N
add wave -noupdate /tb_top/DDR3_CKE
add wave -noupdate /tb_top/DDR3_WE_B
add wave -noupdate /tb_top/DDR3_CAS_B
add wave -noupdate /tb_top/DDR3_RAS_B
add wave -noupdate /tb_top/DDR3_LDM
add wave -noupdate /tb_top/DDR3_UDM
add wave -noupdate /tb_top/DDR3_BA
add wave -noupdate /tb_top/DDR3_A
add wave -noupdate /tb_top/DDR3_ODT
add wave -noupdate /tb_top/DDR3_RST_B
add wave -noupdate /tb_top/II_SPI_SCK
add wave -noupdate /tb_top/II_SPI_MISO
add wave -noupdate /tb_top/II_SPI_MOSI
add wave -noupdate /tb_top/II_SPI_CS_B
add wave -noupdate /tb_top/IIC_SDA
add wave -noupdate /tb_top/IIC_SCL
add wave -noupdate /tb_top/ETH_RST_B
add wave -noupdate /tb_top/ETH_TXD
add wave -noupdate /tb_top/ETH_TX_EN
add wave -noupdate /tb_top/ETH_TX_ER
add wave -noupdate /tb_top/ETH_MII_TX_CLK
add wave -noupdate /tb_top/ETH_TX_CLK
add wave -noupdate /tb_top/ETH_RXD
add wave -noupdate /tb_top/ETH_RX_DV
add wave -noupdate /tb_top/ETH_RX_ER
add wave -noupdate /tb_top/ETH_RX_CLK
add wave -noupdate /tb_top/ETH_MDC
add wave -noupdate /tb_top/ETH_MDIO
add wave -noupdate /tb_top/ETH_MDINT
add wave -noupdate /tb_top/CPU_LED
add wave -noupdate /tb_top/CPU_JMP
add wave -noupdate /glbl/GSR
add wave -noupdate -divider {top-level ports}
add wave -noupdate /tb_top/uut/system_i/ETH_RST_B
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ETH_TXD
add wave -noupdate /tb_top/uut/system_i/ETH_TX_EN
add wave -noupdate /tb_top/uut/system_i/ETH_TX_ER
add wave -noupdate /tb_top/uut/system_i/ETH_TX_CLK
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ETH_RXD
add wave -noupdate /tb_top/uut/system_i/ETH_RX_DV
add wave -noupdate /tb_top/uut/system_i/ETH_RX_ER
add wave -noupdate /tb_top/uut/system_i/ETH_RX_CLK
add wave -noupdate /tb_top/uut/system_i/ETH_MDC
add wave -noupdate /tb_top/uut/system_i/ETH_MDIO
add wave -noupdate /tb_top/uut/system_i/ETH_MDINT
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/CPU_JMP
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DDR3_A
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DDR3_BA
add wave -noupdate /tb_top/uut/system_i/DDR3_RAS_B
add wave -noupdate /tb_top/uut/system_i/DDR3_CAS_B
add wave -noupdate /tb_top/uut/system_i/DDR3_WE_B
add wave -noupdate /tb_top/uut/system_i/DDR3_CKE
add wave -noupdate /tb_top/uut/system_i/DDR3_CLK
add wave -noupdate /tb_top/uut/system_i/DDR3_CLK_B
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DDR3_DQ
add wave -noupdate /tb_top/uut/system_i/DDR3_LDQS_P
add wave -noupdate /tb_top/uut/system_i/DDR3_LDQS_N
add wave -noupdate /tb_top/uut/system_i/DDR3_UDQS_P
add wave -noupdate /tb_top/uut/system_i/DDR3_UDQS_N
add wave -noupdate /tb_top/uut/system_i/DDR3_UDM
add wave -noupdate /tb_top/uut/system_i/DDR3_LDM
add wave -noupdate /tb_top/uut/system_i/DDR3_ODT
add wave -noupdate /tb_top/uut/system_i/DDR3_RST_B
add wave -noupdate /tb_top/uut/system_i/DDR3_RZQ
add wave -noupdate /tb_top/uut/system_i/DDR3_ZIO
add wave -noupdate /tb_top/uut/system_i/II_SPI_SCK
add wave -noupdate /tb_top/uut/system_i/II_SPI_MISO
add wave -noupdate /tb_top/uut/system_i/II_SPI_MOSI
add wave -noupdate /tb_top/uut/system_i/II_SPI_CS_B
add wave -noupdate /tb_top/uut/system_i/OSC_50MHZ
add wave -noupdate /tb_top/uut/system_i/SYS_RST
add wave -noupdate /tb_top/uut/system_i/ETH_MII_TX_CLK
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/CPU_LED
add wave -noupdate /tb_top/uut/system_i/IIC_SDA
add wave -noupdate /tb_top/uut/system_i/IIC_SCL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mem_addr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mem_wdata
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mem_rdata
add wave -noupdate /tb_top/uut/system_i/mem_we
add wave -noupdate /tb_top/uut/system_i/reg_we
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/reg_num
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/reg_wdata
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/reg_rdata
add wave -noupdate /tb_top/uut/system_i/clock
add wave -noupdate /tb_top/uut/system_i/clock_locked
add wave -noupdate /tb_top/uut/system_i/sys_clock
add wave -noupdate /tb_top/uut/system_i/clock_generator_0_CLKOUT4_pin
add wave -noupdate /tb_top/uut/system_i/FADC_SPI_SCK_O
add wave -noupdate /tb_top/uut/system_i/FADC_SPI_MOSI_O
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI_SS_O
add wave -noupdate -divider mb_plb
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/SPLB_Rst
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MIRQ
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_ABus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_UABus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_BE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MAddrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MTimeout
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MRdErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MRdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MRdDAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MRdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MRdWdAddr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MRearbitrate
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MWrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MWrDAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MSSize
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_PAValid
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_RNW
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_SAValid
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_abort
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_busLock
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_TAttribute
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_lockErr
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_masterID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_MSize
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_rdPendPri
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_wrPendPri
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_rdPendReq
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_wrPendReq
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_rdBurst
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_rdPrim
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_reqPri
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_size
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_type
add wave -noupdate /tb_top/uut/system_i/mb_plb/PLB_wrBurst
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_wrDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_plb/PLB_wrPrim
add wave -noupdate -divider ilmb
add wave -noupdate /tb_top/uut/system_i/ilmb/LMB_Rst
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ilmb/LMB_ABus
add wave -noupdate /tb_top/uut/system_i/ilmb/LMB_ReadStrobe
add wave -noupdate /tb_top/uut/system_i/ilmb/LMB_WriteStrobe
add wave -noupdate /tb_top/uut/system_i/ilmb/LMB_AddrStrobe
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ilmb/LMB_ReadDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ilmb/LMB_WriteDBus
add wave -noupdate /tb_top/uut/system_i/ilmb/LMB_Ready
add wave -noupdate /tb_top/uut/system_i/ilmb/LMB_Wait
add wave -noupdate /tb_top/uut/system_i/ilmb/LMB_UE
add wave -noupdate /tb_top/uut/system_i/ilmb/LMB_CE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ilmb/LMB_BE
add wave -noupdate -divider dlmb
add wave -noupdate /tb_top/uut/system_i/dlmb/LMB_Rst
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/dlmb/LMB_ABus
add wave -noupdate /tb_top/uut/system_i/dlmb/LMB_ReadStrobe
add wave -noupdate /tb_top/uut/system_i/dlmb/LMB_WriteStrobe
add wave -noupdate /tb_top/uut/system_i/dlmb/LMB_AddrStrobe
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/dlmb/LMB_ReadDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/dlmb/LMB_WriteDBus
add wave -noupdate /tb_top/uut/system_i/dlmb/LMB_Ready
add wave -noupdate /tb_top/uut/system_i/dlmb/LMB_Wait
add wave -noupdate /tb_top/uut/system_i/dlmb/LMB_UE
add wave -noupdate /tb_top/uut/system_i/dlmb/LMB_CE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/dlmb/LMB_BE
add wave -noupdate -divider microblaze_0
add wave -noupdate /tb_top/uut/system_i/microblaze_0/CLK
add wave -noupdate /tb_top/uut/system_i/microblaze_0/RESET
add wave -noupdate /tb_top/uut/system_i/microblaze_0/MB_RESET
add wave -noupdate /tb_top/uut/system_i/microblaze_0/INTERRUPT
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/INTERRUPT_ADDRESS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/EXT_BRK
add wave -noupdate /tb_top/uut/system_i/microblaze_0/EXT_NM_BRK
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DBG_STOP
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/WAKEUP
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/LOCKSTEP_SLAVE_IN
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/INSTR
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IWAIT
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICE
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IUE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/INSTR_ADDR
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IFETCH
add wave -noupdate /tb_top/uut/system_i/microblaze_0/I_AS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_M_ABort
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_ABus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_UABus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_BE
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_M_busLock
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_M_lockErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_MSize
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_priority
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_M_rdBurst
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_M_request
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_M_RNW
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_size
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_TAttribute
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_type
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_M_wrBurst
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_M_wrDBus
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MBusy
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MRdErr
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MWrErr
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MIRQ
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MWrBTerm
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MWrDAck
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MAddrAck
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MRdBTerm
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MRdDAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_MRdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_MRdWdAddr
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MRearbitrate
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/IPLB_MSSize
add wave -noupdate /tb_top/uut/system_i/microblaze_0/IPLB_MTimeout
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DATA_READ
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DWAIT
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCE
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DUE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DATA_WRITE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DATA_ADDR
add wave -noupdate /tb_top/uut/system_i/microblaze_0/D_AS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/READ_STROBE
add wave -noupdate /tb_top/uut/system_i/microblaze_0/WRITE_STROBE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/BYTE_ENABLE
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_M_ABort
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_ABus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_UABus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_BE
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_M_busLock
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_M_lockErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_MSize
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_priority
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_M_rdBurst
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_M_request
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_M_RNW
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_size
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_TAttribute
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_type
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_M_wrBurst
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_M_wrDBus
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MBusy
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MRdErr
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MWrErr
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MIRQ
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MWrBTerm
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MWrDAck
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MAddrAck
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MRdBTerm
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MRdDAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_MRdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_MRdWdAddr
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MRearbitrate
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DPLB_MSSize
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DPLB_MTimeout
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IP_AWREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IP_WREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IP_BID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IP_BRESP
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IP_BVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IP_ARREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IP_RID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IP_RDATA
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IP_RRESP
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IP_RLAST
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IP_RVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DP_AWREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DP_WREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DP_BID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DP_BRESP
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DP_BVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DP_ARREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DP_RID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DP_RDATA
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DP_RRESP
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DP_RLAST
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DP_RVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_AWREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_WREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_BID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IC_BRESP
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_BVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_BUSER
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_ARREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_RID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IC_RDATA
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IC_RRESP
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_RLAST
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_RVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_RUSER
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_ACVALID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IC_ACADDR
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IC_ACSNOOP
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_IC_ACPROT
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_CRREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_IC_CDREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_AWREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_WREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_BID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DC_BRESP
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_BVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_BUSER
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_ARREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_RID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DC_RDATA
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DC_RRESP
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_RLAST
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_RVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_RUSER
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_ACVALID
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DC_ACADDR
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DC_ACSNOOP
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/M_AXI_DC_ACPROT
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_CRREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M_AXI_DC_CDREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DBG_CLK
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DBG_TDI
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DBG_TDO
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DBG_REG_EN
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DBG_SHIFT
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DBG_CAPTURE
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DBG_UPDATE
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DEBUG_RST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL0_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL0_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL0_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL0_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL1_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL1_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL1_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL1_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL2_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL2_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL2_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL2_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL3_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL3_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL3_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL3_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL4_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL4_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL4_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL4_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL5_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL5_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL5_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL5_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL6_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL6_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL6_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL6_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL7_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL7_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL7_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL7_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL8_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL8_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL8_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL8_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL9_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL9_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL9_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL9_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL10_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL10_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL10_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL10_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL11_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL11_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL11_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL11_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL12_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL12_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL12_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL12_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL13_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL13_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL13_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL13_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL14_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL14_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL14_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL14_M_FULL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/FSL15_S_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL15_S_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL15_S_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/FSL15_M_FULL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M0_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S0_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S0_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S0_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M1_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S1_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S1_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S1_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M2_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S2_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S2_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S2_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M3_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S3_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S3_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S3_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M4_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S4_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S4_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S4_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M5_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S5_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S5_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S5_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M6_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S6_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S6_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S6_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M7_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S7_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S7_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S7_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M8_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S8_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S8_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S8_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M9_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S9_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S9_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S9_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M10_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S10_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S10_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S10_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M11_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S11_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S11_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S11_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M12_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S12_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S12_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S12_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M13_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S13_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S13_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S13_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M14_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S14_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S14_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S14_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/M15_AXIS_TREADY
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S15_AXIS_TLAST
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/S15_AXIS_TDATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/S15_AXIS_TVALID
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_IN_CLK
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_IN_READ
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_IN_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_IN_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_IN_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_OUT_CLK
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_OUT_WRITE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_OUT_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_OUT_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/ICACHE_FSL_OUT_FULL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_IN_CLK
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_IN_READ
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_IN_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_IN_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_IN_EXISTS
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_OUT_CLK
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_OUT_WRITE
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_OUT_DATA
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_OUT_CONTROL
add wave -noupdate /tb_top/uut/system_i/microblaze_0/DCACHE_FSL_OUT_FULL
add wave -noupdate -divider dlmb_cntlr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/dlmb_cntlr/Sl_DBus
add wave -noupdate /tb_top/uut/system_i/dlmb_cntlr/Sl_Ready
add wave -noupdate /tb_top/uut/system_i/dlmb_cntlr/Sl_Wait
add wave -noupdate /tb_top/uut/system_i/dlmb_cntlr/Sl_UE
add wave -noupdate /tb_top/uut/system_i/dlmb_cntlr/Sl_CE
add wave -noupdate /tb_top/uut/system_i/dlmb_cntlr/BRAM_Rst_A
add wave -noupdate /tb_top/uut/system_i/dlmb_cntlr/BRAM_Clk_A
add wave -noupdate /tb_top/uut/system_i/dlmb_cntlr/BRAM_EN_A
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/dlmb_cntlr/BRAM_WEN_A
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/dlmb_cntlr/BRAM_Addr_A
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/dlmb_cntlr/BRAM_Dout_A
add wave -noupdate -divider ilmb_cntlr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ilmb_cntlr/Sl_DBus
add wave -noupdate /tb_top/uut/system_i/ilmb_cntlr/Sl_Ready
add wave -noupdate /tb_top/uut/system_i/ilmb_cntlr/Sl_Wait
add wave -noupdate /tb_top/uut/system_i/ilmb_cntlr/Sl_UE
add wave -noupdate /tb_top/uut/system_i/ilmb_cntlr/Sl_CE
add wave -noupdate /tb_top/uut/system_i/ilmb_cntlr/BRAM_Rst_A
add wave -noupdate /tb_top/uut/system_i/ilmb_cntlr/BRAM_Clk_A
add wave -noupdate /tb_top/uut/system_i/ilmb_cntlr/BRAM_EN_A
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ilmb_cntlr/BRAM_WEN_A
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ilmb_cntlr/BRAM_Addr_A
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/ilmb_cntlr/BRAM_Dout_A
add wave -noupdate -divider lmb_bram
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/lmb_bram/BRAM_Din_A
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/lmb_bram/BRAM_Din_B
add wave -noupdate -divider Soft_TEMAC
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/TemacIntc0_Irpt
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/TemacPhy_RST_n
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GTX_CLK_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MGTCLK_P
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MGTCLK_N
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/REFCLK
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/DCLK
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Core_Clk
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_wait
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_wrComp
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Sl_rdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_rdComp
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Sl_MRdErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Sl_MIRQ
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/LlinkTemac0_CLK
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Temac0Llink_DST_RDY_n
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Temac0Llink_SOP_n
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Temac0Llink_EOP_n
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Temac0Llink_SOF_n
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Temac0Llink_EOF_n
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Temac0Llink_REM
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Temac0Llink_Data
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Temac0Llink_SRC_RDY_n
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/LlinkTemac1_CLK
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/MII_RXD_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MII_RX_DV_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MII_RX_ER_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MII_RX_CLK_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MII_TX_CLK_0
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/MII_RXD_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MII_RX_DV_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MII_RX_ER_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MII_RX_CLK_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MII_TX_CLK_1
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/GMII_TXD_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_TX_EN_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_TX_ER_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_TX_CLK_0
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/GMII_RXD_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_RX_DV_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_RX_ER_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_RX_CLK_0
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/GMII_RXD_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_RX_DV_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_RX_ER_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/GMII_RX_CLK_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/RXP_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/RXN_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/RXP_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/RXN_1
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/RGMII_RXD_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/RGMII_RX_CTL_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/RGMII_RXC_0
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/RGMII_RXD_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/RGMII_RX_CTL_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/RGMII_RXC_1
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MDC_0
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/HostMiimRdy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/HostRdData
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Avb2Mac0TxData
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Mac0TxDataValid
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Mac0TxUnderrun
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac0TxAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac0RxData
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac0RxDataValid
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac0RxFrameGood
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac0RxFrameBad
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Avb2Mac1TxData
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Mac1TxDataValid
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Mac1TxUnderrun
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac1TxAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac1RxData
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac1RxDataValid
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac1RxFrameGood
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/Avb2Temac1RxFrameBad
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MDIO_0_I
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MDIO_0_O
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MDIO_0_T
add wave -noupdate /tb_top/uut/system_i/Soft_TEMAC/MDIO_1_I
add wave -noupdate -divider LEDS
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_wait
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_wrComp
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/Sl_rdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_rdComp
add wave -noupdate /tb_top/uut/system_i/LEDS/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/Sl_MRdErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/Sl_MIRQ
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/GPIO_IO_I
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/GPIO_IO_O
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/LEDS/GPIO2_IO_I
add wave -noupdate -divider DIP_Switches
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_wait
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_wrComp
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/Sl_rdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_rdComp
add wave -noupdate /tb_top/uut/system_i/DIP_Switches/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/Sl_MRdErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/Sl_MIRQ
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/GPIO_IO_I
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/DIP_Switches/GPIO2_IO_I
add wave -noupdate -divider MCB_DDR3
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/FSL0_M_Full
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/FSL0_S_Data
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/FSL0_S_Control
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/FSL0_S_Exists
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/FSL0_B_M_Full
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/FSL0_B_S_Data
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/FSL0_B_S_Control
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/FSL0_B_S_Exists
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA0_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_Rx_IntOut
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_Tx_IntOut
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_RstOut
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA1_TX_D
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA1_TX_Rem
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_TX_SOF
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_TX_EOF
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_TX_SOP
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_TX_EOP
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_TX_Src_Rdy
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA1_RX_Dst_Rdy
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_SSize
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_wait
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_wrComp
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_rdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_rdComp
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_MRdErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/SDMA_CTRL1_Sl_MIRQ
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA2_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA3_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA4_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA5_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA6_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/SDMA7_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk0
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk0_DIV2
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk90
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk_200MHz
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Rst
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk_Mem
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk_Mem_2x
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk_Mem_2x_180
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk_Mem_2x_CE0
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk_Mem_2x_CE90
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Clk_Rd_Base
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_PLL_Lock
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_Idelayctrl_Rdy_I
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_DCM_PSDONE
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/MPMC_MCB_DRP_Clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/DDR_DQS_Div_I
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/DDR2_DQS_Div_I
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_addr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_ba
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_ras_n
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_cas_n
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_we_n
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_cke
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_clk
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_clk_n
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_dq
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_dqs
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_dqs_n
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_udqs
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_udqs_n
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_udm
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_ldm
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_odt
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/mcbx_dram_ddr3_rst
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/selfrefresh_enter
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/calib_recal
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/rzq
add wave -noupdate /tb_top/uut/system_i/MCB_DDR3/zio
add wave -noupdate -divider Generic_SPI
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/SCK_I
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/SCK_O
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/MISO_I
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/MOSI_I
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/MOSI_O
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/SPISEL
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/SS_I
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/SS_O
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Generic_SPI/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_wait
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_wrComp
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Generic_SPI/Sl_rdDBus
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_rdComp
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Generic_SPI/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Generic_SPI/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Generic_SPI/Sl_MRdErr
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Generic_SPI/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/Generic_SPI/Sl_MIRQ
add wave -noupdate /tb_top/uut/system_i/Generic_SPI/IP2INTC_Irpt
add wave -noupdate -divider clock_generator_0
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/CLKIN
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/CLKOUT0
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/CLKOUT1
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/CLKOUT2
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/CLKOUT3
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/CLKOUT4
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/CLKOUT5
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/CLKFBIN
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/PSCLK
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/PSEN
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/PSINCDEC
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/RST
add wave -noupdate /tb_top/uut/system_i/clock_generator_0/LOCKED
add wave -noupdate -divider mdm_0
add wave -noupdate /tb_top/uut/system_i/mdm_0/Debug_SYS_Rst
add wave -noupdate /tb_top/uut/system_i/mdm_0/Ext_BRK
add wave -noupdate /tb_top/uut/system_i/mdm_0/Ext_NM_BRK
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mdm_0/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_wait
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_wrComp
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mdm_0/Sl_rdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mdm_0/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_rdComp
add wave -noupdate /tb_top/uut/system_i/mdm_0/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mdm_0/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mdm_0/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mdm_0/Sl_MRdErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mdm_0/Sl_MIRQ
add wave -noupdate /tb_top/uut/system_i/mdm_0/Dbg_Clk_0
add wave -noupdate /tb_top/uut/system_i/mdm_0/Dbg_TDI_0
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mdm_0/Dbg_Reg_En_0
add wave -noupdate /tb_top/uut/system_i/mdm_0/Dbg_Capture_0
add wave -noupdate /tb_top/uut/system_i/mdm_0/Dbg_Shift_0
add wave -noupdate /tb_top/uut/system_i/mdm_0/Dbg_Update_0
add wave -noupdate /tb_top/uut/system_i/mdm_0/Dbg_Rst_0
add wave -noupdate /tb_top/uut/system_i/mdm_0/bscan_tdo1
add wave -noupdate /tb_top/uut/system_i/mdm_0/bscan_ext_tdi
add wave -noupdate /tb_top/uut/system_i/mdm_0/bscan_ext_reset
add wave -noupdate /tb_top/uut/system_i/mdm_0/bscan_ext_shift
add wave -noupdate /tb_top/uut/system_i/mdm_0/bscan_ext_update
add wave -noupdate /tb_top/uut/system_i/mdm_0/bscan_ext_capture
add wave -noupdate /tb_top/uut/system_i/mdm_0/bscan_ext_sel
add wave -noupdate /tb_top/uut/system_i/mdm_0/bscan_ext_drck
add wave -noupdate -divider proc_sys_reset_0
add wave -noupdate /tb_top/uut/system_i/proc_sys_reset_0/Slowest_sync_clk
add wave -noupdate /tb_top/uut/system_i/proc_sys_reset_0/Ext_Reset_In
add wave -noupdate /tb_top/uut/system_i/proc_sys_reset_0/Aux_Reset_In
add wave -noupdate /tb_top/uut/system_i/proc_sys_reset_0/MB_Debug_Sys_Rst
add wave -noupdate /tb_top/uut/system_i/proc_sys_reset_0/Dcm_locked
add wave -noupdate /tb_top/uut/system_i/proc_sys_reset_0/MB_Reset
add wave -noupdate /tb_top/uut/system_i/proc_sys_reset_0/Bus_Struct_Reset
add wave -noupdate /tb_top/uut/system_i/proc_sys_reset_0/Peripheral_Reset
add wave -noupdate -divider xps_timer_0
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/CaptureTrig0
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/CaptureTrig1
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Interrupt
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Freeze
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_timer_0/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_wait
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_wrComp
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_timer_0/Sl_rdDBus
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_rdComp
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_timer_0/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_timer_0/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_timer_0/Sl_MRdErr
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_timer_0/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/xps_timer_0/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_timer_0/Sl_MIRQ
add wave -noupdate -divider xps_intc_0
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_intc_0/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_wait
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_wrComp
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_intc_0/Sl_rdDBus
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_rdComp
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_intc_0/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_intc_0/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_intc_0/Sl_MRdErr
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_intc_0/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_intc_0/Sl_MIRQ
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_intc_0/Intr
add wave -noupdate /tb_top/uut/system_i/xps_intc_0/Irq
add wave -noupdate -divider xps_iic_0
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sda_I
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sda_O
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sda_T
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Scl_I
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Scl_O
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Scl_T
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/IIC2INTC_Irpt
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_iic_0/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_wait
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_wrComp
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_iic_0/Sl_rdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_iic_0/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_rdComp
add wave -noupdate /tb_top/uut/system_i/xps_iic_0/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_iic_0/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_iic_0/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_iic_0/Sl_MRdErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/xps_iic_0/Sl_MIRQ
add wave -noupdate -divider mb_eth_ifc_0
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_wait
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_wrComp
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/Sl_rdDBus
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_rdComp
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/Sl_MRdErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/Sl_MIRQ
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/clock
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/mem_addr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/mem_wdata
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/mem_rdata
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/mem_we
add wave -noupdate /tb_top/uut/system_i/mb_eth_ifc_0/reg_we
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/reg_num
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/reg_wdata
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/mb_eth_ifc_0/reg_rdata
add wave -noupdate -divider FADC_SPI
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/SCK_I
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/SCK_O
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/MISO_I
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/MOSI_I
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/MOSI_O
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/SPISEL
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/SS_I
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/SS_O
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_addrAck
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/Sl_SSize
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_wait
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_rearbitrate
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_wrDAck
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_wrComp
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/Sl_rdDBus
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_rdDAck
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_rdComp
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/Sl_MBusy
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/Sl_MWrErr
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/Sl_MRdErr
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_wrBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/Sl_rdWdAddr
add wave -noupdate /tb_top/uut/system_i/FADC_SPI/Sl_rdBTerm
add wave -noupdate -radix hexadecimal /tb_top/uut/system_i/FADC_SPI/Sl_MIRQ
add wave -noupdate /tb_top/CLK_50MHZ
add wave -noupdate /tb_top/OSC_50MHZ
add wave -noupdate /tb_top/RESET_P
add wave -noupdate /tb_top/SYS_RST
add wave -noupdate /tb_top/SDATAP
add wave -noupdate /tb_top/DCOP
add wave -noupdate /tb_top/FCOP
add wave -noupdate /tb_top/ADC_CLKP
add wave -noupdate -divider SYSTEM_I
add wave -noupdate /tb_top/uut/s_clock
add wave -noupdate -divider INFRASTRUCTURE
add wave -noupdate /tb_top/uut/infrastructure_top_i/RESET_N
add wave -noupdate /tb_top/uut/infrastructure_top_i/hb25ns
add wave -noupdate -divider TOP
add wave -noupdate /tb_top/uut/s_clk_cnt
add wave -noupdate /tb_top/uut/s_adc_buf_wnum
add wave -noupdate /tb_top/uut/s_adc_data
add wave -noupdate -divider ADC_CTRL
add wave -noupdate /tb_top/uut/adc_ctrl_i/clock
add wave -noupdate /tb_top/uut/adc_ctrl_i/clock_locked
add wave -noupdate /tb_top/uut/adc_ctrl_i/clkp_cnt
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_clkp_div2
add wave -noupdate /tb_top/uut/adc_ctrl_i/hb25ns
add wave -noupdate /tb_top/uut/adc_ctrl_i/o_adc_data
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_adc_buf_waddr
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_adc_buf_wclk
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_adc_buf_we
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_adc_buf_we_ctrl
add wave -noupdate /tb_top/uut/adc_ctrl_i/i_adc_buf_we_ctrl
add wave -noupdate /tb_top/uut/adc_ctrl_i/bitslip_reset
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_clock40MHz
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_clock40MHz_next
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_adc_data_to_write
add wave -noupdate /tb_top/uut/adc_ctrl_i/s_adc_buf_wclk
add wave -noupdate -divider ADC_DESER
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/clock
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/s_clock_adc
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/DCOP
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/FCOP
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/dco_divclk
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/dco_strobe
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/dco_ib
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/ch1_data_sr
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/ch1_serdes_q
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/fco_serdes_q
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/fco_serdes_q_r
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/bit_slip_r
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/frame_start_r
add wave -noupdate /tb_top/uut/adc_ctrl_i/GEN_DESER(1)/adc_deser/data_we
add wave -noupdate -divider LOM
add wave -noupdate /tb_top/uut/lom_i/i_clock
add wave -noupdate /tb_top/uut/lom_i/i_adc_data
add wave -noupdate /tb_top/uut/lom_i/s_arr_ampl
add wave -noupdate /tb_top/uut/lom_i/s_vec_hist_wena
add wave -noupdate /tb_top/uut/lom_i/s_vec_discr
add wave -noupdate /tb_top/uut/lom_i/s_vec_coin
add wave -noupdate -divider AMPL
add wave -noupdate /tb_top/uut/lom_i/ADC_GEN(1)/AU/i_signal
add wave -noupdate /tb_top/uut/lom_i/ADC_GEN(1)/AU/i_gate
add wave -noupdate /tb_top/uut/lom_i/ADC_GEN(1)/AU/s_gate_prev
add wave -noupdate /tb_top/uut/lom_i/ADC_GEN(1)/AU/s_gate_next
add wave -noupdate -divider HIST
add wave -noupdate /tb_top/uut/lom_i/HM/i_vec_hist_wena
add wave -noupdate /tb_top/uut/lom_i/HM/i_arr_adc_ampl
add wave -noupdate /tb_top/uut/lom_i/HM/ADC_GEN(1)/HU/s_bin_data
add wave -noupdate -divider SELFTEST
add wave -noupdate /tb_top/uut/self_tester_i/i_enable
add wave -noupdate /tb_top/uut/self_tester_i/s_data_buf
add wave -noupdate /tb_top/uut/self_tester_i/s_data
add wave -noupdate /tb_top/uut/self_tester_i/s_data_next
add wave -noupdate /tb_top/uut/self_tester_i/o_testbuf_addr
add wave -noupdate /tb_top/uut/self_tester_i/s_testbuf_addr_next
add wave -noupdate /tb_top/uut/self_tester_i/o_testbuf_data
add wave -noupdate /tb_top/uut/self_tester_i/s_is_initialized
add wave -noupdate /tb_top/uut/self_tester_i/s_init_in_progress
add wave -noupdate /tb_top/uut/lom_i/HM/ADC_GEN(1)/HU/s_bin_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 1
configure wave -snapdistance 15
configure wave -datasetprefix 0
configure wave -rowmargin 10
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {10500 ns} {20500 ns}

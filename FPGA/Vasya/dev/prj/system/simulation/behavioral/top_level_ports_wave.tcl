#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     top_level_ports_wave.tcl (Mon Oct  9 10:00:20 2017)
#
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

wave add $tbpath${ps}ETH_RST_B -into $id 
wave add $tbpath${ps}ETH_TXD -into $id 
wave add $tbpath${ps}ETH_TX_EN -into $id 
wave add $tbpath${ps}ETH_TX_ER -into $id 
wave add $tbpath${ps}ETH_TX_CLK -into $id 
wave add $tbpath${ps}ETH_RXD -into $id 
wave add $tbpath${ps}ETH_RX_DV -into $id 
wave add $tbpath${ps}ETH_RX_ER -into $id 
wave add $tbpath${ps}ETH_RX_CLK -into $id 
wave add $tbpath${ps}ETH_MDC -into $id 
wave add $tbpath${ps}ETH_MDIO -into $id 
wave add $tbpath${ps}ETH_MDINT -into $id 
wave add $tbpath${ps}CPU_JMP -into $id 
wave add $tbpath${ps}DDR3_A -into $id 
wave add $tbpath${ps}DDR3_BA -into $id 
wave add $tbpath${ps}DDR3_RAS_B -into $id 
wave add $tbpath${ps}DDR3_CAS_B -into $id 
wave add $tbpath${ps}DDR3_WE_B -into $id 
wave add $tbpath${ps}DDR3_CKE -into $id 
wave add $tbpath${ps}DDR3_CLK -into $id 
wave add $tbpath${ps}DDR3_CLK_B -into $id 
wave add $tbpath${ps}DDR3_DQ -into $id 
wave add $tbpath${ps}DDR3_LDQS_P -into $id 
wave add $tbpath${ps}DDR3_LDQS_N -into $id 
wave add $tbpath${ps}DDR3_UDQS_P -into $id 
wave add $tbpath${ps}DDR3_UDQS_N -into $id 
wave add $tbpath${ps}DDR3_UDM -into $id 
wave add $tbpath${ps}DDR3_LDM -into $id 
wave add $tbpath${ps}DDR3_ODT -into $id 
wave add $tbpath${ps}DDR3_RST_B -into $id 
wave add $tbpath${ps}DDR3_RZQ -into $id 
wave add $tbpath${ps}DDR3_ZIO -into $id 
wave add $tbpath${ps}II_SPI_SCK -into $id 
wave add $tbpath${ps}II_SPI_MISO -into $id 
wave add $tbpath${ps}II_SPI_MOSI -into $id 
wave add $tbpath${ps}II_SPI_CS_B -into $id 
wave add $tbpath${ps}OSC_50MHZ -into $id 
wave add $tbpath${ps}SYS_RST -into $id 
wave add $tbpath${ps}ETH_MII_TX_CLK -into $id 
wave add $tbpath${ps}CPU_LED -into $id 
wave add $tbpath${ps}IIC_SDA -into $id 
wave add $tbpath${ps}IIC_SCL -into $id 
wave add $tbpath${ps}mem_addr -into $id 
wave add $tbpath${ps}mem_wdata -into $id 
wave add $tbpath${ps}mem_rdata -into $id 
wave add $tbpath${ps}mem_we -into $id 
wave add $tbpath${ps}reg_we -into $id 
wave add $tbpath${ps}reg_num -into $id 
wave add $tbpath${ps}reg_wdata -into $id 
wave add $tbpath${ps}reg_rdata -into $id 
wave add $tbpath${ps}clock -into $id 
wave add $tbpath${ps}clock_locked -into $id 
wave add $tbpath${ps}sys_clock -into $id 
wave add $tbpath${ps}clock_generator_0_CLKOUT4_pin -into $id 
wave add $tbpath${ps}FADC_SPI_SCK_O -into $id 
wave add $tbpath${ps}FADC_SPI_MOSI_O -into $id 
wave add $tbpath${ps}FADC_SPI_SS_O -into $id 


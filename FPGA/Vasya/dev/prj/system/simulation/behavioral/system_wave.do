#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     system_wave.do (Sat Mar 17 02:06:09 2018)
#
#  Wave Window DO Script File
#
#  Wave Window DO script files setup the ModelSim Wave window
#  display for viewing results of the simulation in a graphic
#  format. Comment or uncomment commands to change the set of
#  signals viewed.
#
echo  "Setting up Wave window display ..."

if { ![info exists xcmdc] } {echo "Warning : c compile command was not run"}
if { ![info exists xcmds] } {echo "Warning : s simulate command was not run"}

if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

#
#  Display top-level ports
#
set binopt {-logic}
set hexopt {-literal -hex}
eval add wave -noupdate -divider {"top-level ports"}
eval add wave -noupdate $binopt $tbpath${ps}ETH_RST_B
eval add wave -noupdate $hexopt $tbpath${ps}ETH_TXD
eval add wave -noupdate $binopt $tbpath${ps}ETH_TX_EN
eval add wave -noupdate $binopt $tbpath${ps}ETH_TX_ER
eval add wave -noupdate $binopt $tbpath${ps}ETH_TX_CLK
eval add wave -noupdate $hexopt $tbpath${ps}ETH_RXD
eval add wave -noupdate $binopt $tbpath${ps}ETH_RX_DV
eval add wave -noupdate $binopt $tbpath${ps}ETH_RX_ER
eval add wave -noupdate $binopt $tbpath${ps}ETH_RX_CLK
eval add wave -noupdate $binopt $tbpath${ps}ETH_MDC
eval add wave -noupdate $binopt $tbpath${ps}ETH_MDIO
eval add wave -noupdate $binopt $tbpath${ps}ETH_MDINT
eval add wave -noupdate $hexopt $tbpath${ps}CPU_JMP
eval add wave -noupdate $hexopt $tbpath${ps}DDR3_A
eval add wave -noupdate $hexopt $tbpath${ps}DDR3_BA
eval add wave -noupdate $binopt $tbpath${ps}DDR3_RAS_B
eval add wave -noupdate $binopt $tbpath${ps}DDR3_CAS_B
eval add wave -noupdate $binopt $tbpath${ps}DDR3_WE_B
eval add wave -noupdate $binopt $tbpath${ps}DDR3_CKE
eval add wave -noupdate $binopt $tbpath${ps}DDR3_CLK
eval add wave -noupdate $binopt $tbpath${ps}DDR3_CLK_B
eval add wave -noupdate $hexopt $tbpath${ps}DDR3_DQ
eval add wave -noupdate $binopt $tbpath${ps}DDR3_LDQS_P
eval add wave -noupdate $binopt $tbpath${ps}DDR3_LDQS_N
eval add wave -noupdate $binopt $tbpath${ps}DDR3_UDQS_P
eval add wave -noupdate $binopt $tbpath${ps}DDR3_UDQS_N
eval add wave -noupdate $binopt $tbpath${ps}DDR3_UDM
eval add wave -noupdate $binopt $tbpath${ps}DDR3_LDM
eval add wave -noupdate $binopt $tbpath${ps}DDR3_ODT
eval add wave -noupdate $binopt $tbpath${ps}DDR3_RST_B
eval add wave -noupdate $binopt $tbpath${ps}DDR3_RZQ
eval add wave -noupdate $binopt $tbpath${ps}DDR3_ZIO
eval add wave -noupdate $binopt $tbpath${ps}II_SPI_SCK
eval add wave -noupdate $binopt $tbpath${ps}II_SPI_MISO
eval add wave -noupdate $binopt $tbpath${ps}II_SPI_MOSI
eval add wave -noupdate $binopt $tbpath${ps}II_SPI_CS_B
eval add wave -noupdate $binopt $tbpath${ps}OSC_50MHZ
eval add wave -noupdate $binopt $tbpath${ps}SYS_RST
eval add wave -noupdate $binopt $tbpath${ps}ETH_MII_TX_CLK
eval add wave -noupdate $hexopt $tbpath${ps}CPU_LED
eval add wave -noupdate $binopt $tbpath${ps}IIC_SDA
eval add wave -noupdate $binopt $tbpath${ps}IIC_SCL
eval add wave -noupdate $hexopt $tbpath${ps}mem_addr
eval add wave -noupdate $hexopt $tbpath${ps}mem_wdata
eval add wave -noupdate $hexopt $tbpath${ps}mem_rdata
eval add wave -noupdate $binopt $tbpath${ps}mem_we
eval add wave -noupdate $binopt $tbpath${ps}reg_we
eval add wave -noupdate $hexopt $tbpath${ps}reg_num
eval add wave -noupdate $hexopt $tbpath${ps}reg_wdata
eval add wave -noupdate $hexopt $tbpath${ps}reg_rdata
eval add wave -noupdate $binopt $tbpath${ps}clock
eval add wave -noupdate $binopt $tbpath${ps}clock_locked
eval add wave -noupdate $binopt $tbpath${ps}sys_clock
eval add wave -noupdate $binopt $tbpath${ps}clock_generator_0_CLKOUT4_pin
eval add wave -noupdate $binopt $tbpath${ps}FADC_SPI_SCK_O
eval add wave -noupdate $binopt $tbpath${ps}FADC_SPI_MOSI_O
eval add wave -noupdate $hexopt $tbpath${ps}FADC_SPI_SS_O

#
#  Display bus signal ports
#
do mb_plb_wave.do

do ilmb_wave.do

do dlmb_wave.do

#
#  Display processor ports
#
do microblaze_0_wave.do

#
#  Display processor registers
#

#  Processor registers cannot be displayed for:
#  Module   system_microblaze_0_wrapper
#  Instance microblaze_0
#
#  Display IP and peripheral ports
#
do dlmb_cntlr_wave.do

do ilmb_cntlr_wave.do

do lmb_bram_wave.do

do Soft_TEMAC_wave.do

do LEDS_wave.do

do DIP_Switches_wave.do

do MCB_DDR3_wave.do

do Generic_SPI_wave.do

do clock_generator_0_wave.do

do mdm_0_wave.do

do proc_sys_reset_0_wave.do

do xps_timer_0_wave.do

do xps_intc_0_wave.do

do xps_iic_0_wave.do

do mb_eth_ifc_0_wave.do

do FADC_SPI_wave.do


#  Wave window configuration information
#
configure  wave -justifyvalue          right
configure  wave -signalnamewidth       1

TreeUpdate [SetDefaultTree]

#  Wave window setup complete
#
echo  "Wave window display setup done."

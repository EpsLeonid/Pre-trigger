#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     system_list.do (Sat Mar 17 02:06:09 2018)
#
#  List Window DO Script File
#
#  List Window DO script files setup the ModelSim List window
#  display for viewing results of the simulation in a tabular
#  format. Comment or uncomment commands to change the set of
#  data values viewed.
#
echo  "Setting up List window display ..."

if { ![info exists xcmdc] } {echo "Warning : c compile command was not run"}
if { ![info exists xcmds] } {echo "Warning : s simulate command was not run"}

onerror { resume }

if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

#
#  Display top-level ports
#
set binopt {-bin}
set hexopt {-hex}
eval add list $binopt $tbpath${ps}ETH_RST_B
eval add list $hexopt $tbpath${ps}ETH_TXD
eval add list $binopt $tbpath${ps}ETH_TX_EN
eval add list $binopt $tbpath${ps}ETH_TX_ER
eval add list $binopt $tbpath${ps}ETH_TX_CLK
eval add list $hexopt $tbpath${ps}ETH_RXD
eval add list $binopt $tbpath${ps}ETH_RX_DV
eval add list $binopt $tbpath${ps}ETH_RX_ER
eval add list $binopt $tbpath${ps}ETH_RX_CLK
eval add list $binopt $tbpath${ps}ETH_MDC
eval add list $binopt $tbpath${ps}ETH_MDIO
eval add list $binopt $tbpath${ps}ETH_MDINT
eval add list $hexopt $tbpath${ps}CPU_JMP
eval add list $hexopt $tbpath${ps}DDR3_A
eval add list $hexopt $tbpath${ps}DDR3_BA
eval add list $binopt $tbpath${ps}DDR3_RAS_B
eval add list $binopt $tbpath${ps}DDR3_CAS_B
eval add list $binopt $tbpath${ps}DDR3_WE_B
eval add list $binopt $tbpath${ps}DDR3_CKE
eval add list $binopt $tbpath${ps}DDR3_CLK
eval add list $binopt $tbpath${ps}DDR3_CLK_B
eval add list $hexopt $tbpath${ps}DDR3_DQ
eval add list $binopt $tbpath${ps}DDR3_LDQS_P
eval add list $binopt $tbpath${ps}DDR3_LDQS_N
eval add list $binopt $tbpath${ps}DDR3_UDQS_P
eval add list $binopt $tbpath${ps}DDR3_UDQS_N
eval add list $binopt $tbpath${ps}DDR3_UDM
eval add list $binopt $tbpath${ps}DDR3_LDM
eval add list $binopt $tbpath${ps}DDR3_ODT
eval add list $binopt $tbpath${ps}DDR3_RST_B
eval add list $binopt $tbpath${ps}DDR3_RZQ
eval add list $binopt $tbpath${ps}DDR3_ZIO
eval add list $binopt $tbpath${ps}II_SPI_SCK
eval add list $binopt $tbpath${ps}II_SPI_MISO
eval add list $binopt $tbpath${ps}II_SPI_MOSI
eval add list $binopt $tbpath${ps}II_SPI_CS_B
eval add list $binopt $tbpath${ps}OSC_50MHZ
eval add list $binopt $tbpath${ps}SYS_RST
eval add list $binopt $tbpath${ps}ETH_MII_TX_CLK
eval add list $hexopt $tbpath${ps}CPU_LED
eval add list $binopt $tbpath${ps}IIC_SDA
eval add list $binopt $tbpath${ps}IIC_SCL
eval add list $hexopt $tbpath${ps}mem_addr
eval add list $hexopt $tbpath${ps}mem_wdata
eval add list $hexopt $tbpath${ps}mem_rdata
eval add list $binopt $tbpath${ps}mem_we
eval add list $binopt $tbpath${ps}reg_we
eval add list $hexopt $tbpath${ps}reg_num
eval add list $hexopt $tbpath${ps}reg_wdata
eval add list $hexopt $tbpath${ps}reg_rdata
eval add list $binopt $tbpath${ps}clock
eval add list $binopt $tbpath${ps}clock_locked
eval add list $binopt $tbpath${ps}sys_clock
eval add list $binopt $tbpath${ps}clock_generator_0_CLKOUT4_pin
eval add list $binopt $tbpath${ps}FADC_SPI_SCK_O
eval add list $binopt $tbpath${ps}FADC_SPI_MOSI_O
eval add list $hexopt $tbpath${ps}FADC_SPI_SS_O

#
#  Display bus signal ports
#
do mb_plb_list.do

do ilmb_list.do

do dlmb_list.do

#
#  Display processor ports
#
do microblaze_0_list.do

#
#  Display processor registers
#

#  Processor registers cannot be displayed for:
#  Module   system_microblaze_0_wrapper
#  Instance microblaze_0
#
#  Display IP and peripheral ports
#
do dlmb_cntlr_list.do

do ilmb_cntlr_list.do

do lmb_bram_list.do

do Soft_TEMAC_list.do

do LEDS_list.do

do DIP_Switches_list.do

do MCB_DDR3_list.do

do Generic_SPI_list.do

do clock_generator_0_list.do

do mdm_0_list.do

do proc_sys_reset_0_list.do

do xps_timer_0_list.do

do xps_intc_0_list.do

do xps_iic_0_list.do

do mb_eth_ifc_0_list.do

do FADC_SPI_list.do


#  List window configuration information
#
configure list -delta                 none
configure list -usesignaltriggers     0

#  Define the simulation strobe and period, if used.

configure list -usestrobe             0
configure list -strobestart           {0 ps}  -strobeperiod {0 ps}

configure list -usegating             1

# Configure the gated clock.
# configure list -gateexpr <<signal_name>>

#  List window setup complete
#
echo  "List window display setup done."

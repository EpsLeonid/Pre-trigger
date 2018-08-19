#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     system_wave.tcl (Mon Oct  9 10:00:20 2017)
#
#  ISE Simulator Trace Script File
#
#  Trace script files specify signals to save for later
#  display when viewing results of the simulation a graphic
#  format. Comment or uncomment commands to change the set of
#  signals viewed.
#
puts  "Setting up signal tracing ..."

if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}system_tb${ps}dut" }

#
#  Trace top-level ports
#
set id [group add "Top level ports"]
source top_level_ports_wave.tcl


#
#  Trace Bus signal ports
#
set id [group add "Bus signal ports" ]
source mb_plb_wave.tcl

source ilmb_wave.tcl

source dlmb_wave.tcl

#
#  Trace Processor ports
#
set id [group add "Processor ports" ]
source microblaze_0_wave.tcl

#
#  Trace processor registers
#

set id [group add "Processor registers"]
#  Processor registers cannot be displayed for:
#  Module   system_microblaze_0_wrapper
#  Instance microblaze_0
#
#  Trace IP and peripheral ports
#
set id [group add "IP and peripheral ports" ]
source dlmb_cntlr_wave.tcl

source ilmb_cntlr_wave.tcl

source lmb_bram_wave.tcl

source Soft_TEMAC_wave.tcl

source LEDS_wave.tcl

source DIP_Switches_wave.tcl

source MCB_DDR3_wave.tcl

source Generic_SPI_wave.tcl

source clock_generator_0_wave.tcl

source mdm_0_wave.tcl

source proc_sys_reset_0_wave.tcl

source xps_timer_0_wave.tcl

source xps_intc_0_wave.tcl

source xps_iic_0_wave.tcl

source mb_eth_ifc_0_wave.tcl

source FADC_SPI_wave.tcl

#
#  Trace setup complete. Start tracing the signals.
#

puts  "Signal tracing setup completed."

puts  "Simulate the design with the 'run' command."

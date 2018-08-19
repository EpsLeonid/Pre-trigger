#!/bin/sh
#  Simulation Model Generator
#  Xilinx EDK 14.7 EDK_P.20131013
#  Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
#
#  File     system_fuse.sh (Mon Oct  9 10:00:20 2017)
#
#  ISE Simulator Fuse Script File
#
#  The Fuse script compiles and generates an ISE simulator
#  executable named isim_system that is used to run your
#  simulation. To run a simulation in command line mode,
#  perform the following steps:
#
#  1. Run the ISE Simulator Fuse script file
#     source system_fuse.sh
#  2. Use a text editor to modify the signal wave files,
#     which have the file name <module>_wave.tcl
#  3. Launch the simulator using the following command:
#     isim_system -gui -tclbatch system_setup.tcl
#
fuse -incremental work.system_tb work.glbl  -prj system.prj -L xilinxcorelib_ver -L secureip -L unisims_ver -L unimacro_ver  -o isim_system

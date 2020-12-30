
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name PreTrigger_ECAL_Xilinx -dir "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/planAhead_run_2" -part xc4vlx60ff1148-10
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/planAhead.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {lib/Parameters.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../LIB/V_Counter.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../LIB/SRFF.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../LIB/ISERDES_8bit.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../LIB/Edge_Sensing.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {lib/ShiftReg.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {lib/FindMaxAmp.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {lib/adc_deser.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {DLL.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../LIB/PhaseSW.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../LIB/OSERDES_8bit.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../LIB/Light_Pulser.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Main.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top Main $srcset
add_files [list {Pre.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {PreTrigger.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {planAhead.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc4vlx60ff1148-10

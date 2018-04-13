
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Pre-trigger -dir "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/Pre-trigger_Xilinx/planAhead_run_2" -part xc4vlx60ff1148-10
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "Pre.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {Parameters.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Main.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top Main $srcset
add_files [list {Pre.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc4vlx60ff1148-10

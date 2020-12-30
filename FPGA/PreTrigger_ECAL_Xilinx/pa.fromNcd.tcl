
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name PreTrigger_ECAL_Xilinx -dir "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/planAhead_run_1" -part xc4vlx60ff1148-10
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/Main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx} }
set_property target_constrs_file "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/planAhead.ucf" [current_fileset -constrset]
add_files [list {Pre.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {PreTrigger.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {planAhead.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/Main.ncd"
if {[catch {read_twx -name results_1 -file "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/Main.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/Main.twx\": $eInfo"
}

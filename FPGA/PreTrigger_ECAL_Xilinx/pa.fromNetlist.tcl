
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name PreTrigger_ECAL_Xilinx -dir "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/planAhead_run_1" -part xc4vlx60ff1148-10
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/Main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/PreTrigger_ECAL_Xilinx/Pre.ucf" [current_fileset -constrset]
add_files [list {Pre.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {PreTrigger.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {planAhead.ucf}] -fileset [get_property constrset [current_run]]
link_design


# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name lom_v0.25 -dir "/home/shebalin/lom/fpga/v0.25_dev/prj/planAhead_run_3" -part xc6slx150tfgg900-3
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "/home/shebalin/lom/fpga/v0.25_dev/prj/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/shebalin/lom/fpga/v0.25_dev/prj} {ipcore_dir} {system} {system/implementation} }
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/prj/system_soft_temac_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/prj/system_clock_generator_0_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/prj/system_ilmb_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/prj/system_dlmb_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/prj/system.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/prj/system_microblaze_0_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/prj/system_mcb_ddr3_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/adc_fub_ram.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/lom_test_buf.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/test_ram_buf.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {system/implementation/system_soft_temac_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {system/implementation/system_clock_generator_0_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {system/implementation/system_ilmb_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {system/implementation/system_dlmb_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {system/implementation/system_microblaze_0_wrapper.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {system/implementation/system_mcb_ddr3_wrapper.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "/home/shebalin/lom/fpga/v0.25_dev/ucf/top.ucf" [current_fileset -constrset]
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/ucf/top.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "/home/shebalin/lom/fpga/v0.25_dev/prj/top.ncd"
if {[catch {read_twx -name results_1 -file "/home/shebalin/lom/fpga/v0.25_dev/prj/top.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"/home/shebalin/lom/fpga/v0.25_dev/prj/top.twx\": $eInfo"
}


# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name lom_v0.25 -dir "/home/shebalin/lom/fpga/v0.25_dev/prj/planAhead_run_2" -part xc6slx150tfgg900-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "/home/shebalin/lom/fpga/v0.25_dev/ucf/top.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {ipcore_dir/adc_fub_ram.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/test_ram_buf.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/lom_test_buf.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/constants.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/types.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/myutils.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/reg_map_rec.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/histo_mem.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/histo.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {ipcore_dir/adc_fub_ram.ngc}]
set hdlfile [add_files [list {../vhd/lom_utils.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/histo_manager.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/adc_deser.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/adc_buf.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {ipcore_dir/lom_test_buf.ngc}]
set hdlfile [add_files [list {../vhd/selftest.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/reg_file_m1.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/mem_file.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/lom.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/infrastructure_top.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {../vhd/adc_ctrl.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
add_files [list {ipcore_dir/test_ram_buf.ngc}]
set hdlfile [add_files [list {../vhd/top.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top top $srcset
add_files [list {/home/shebalin/lom/fpga/v0.25_dev/ucf/top.ucf}] -fileset [get_property constrset [current_run]]
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
open_rtl_design -part xc6slx150tfgg900-3

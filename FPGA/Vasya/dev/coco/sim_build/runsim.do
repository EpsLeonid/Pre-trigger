if [file exists work] {vdel -lib work -all}
vlib work
vmap -c
vmap work work
vcom -work work  /home/shebalin/lom/fpga/dev/coco/../vhd/constants.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/types.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/reg_utils.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/reg_map.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/lom_utils.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/counters_manager.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/mem.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/histo.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/histo_manager.vhd /home/shebalin/lom/fpga/dev/coco/../vhd/lom.vhd
vsim -t 1ps -L work -onfinish exit -foreign "cocotb_init libfli.so" lom
onbreak resume
run -all
quit

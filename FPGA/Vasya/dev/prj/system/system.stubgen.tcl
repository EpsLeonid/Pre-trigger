cd C:/work/KEK/Hardware/EclCollector/v2.0/FPGA_Designs/v1.0/system/
if { [ catch { xload xmp system.xmp } result ] } {
  exit 10
}
xset hdl vhdl
run stubgen
exit 0

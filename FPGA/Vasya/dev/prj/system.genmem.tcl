if { [ catch { xload xmp /home/shebalin/lom/fpga/v0.25_dev/prj/system/system.xmp } result ] } {
  exit 10
}
set gotbram [xget hasbram]
if { $gotbram == 1 } {
   #
   # Call the test bench generation
   if { [catch {run memgen -od /home/shebalin/lom/fpga/v0.25_dev/prj /home/shebalin/lom/fpga/v0.25_dev/prj/system/system.mhs} result ] } {
      puts "ERROR: xps 'run memgen' call failed"
      exit -1
   }
}
exit 0

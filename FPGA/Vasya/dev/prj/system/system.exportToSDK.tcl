proc exportToSDK {} {
  cd /home/shebalin/Xilinx/project/LOM/full_bufplay_14.4/system
  if { [ catch { xload xmp system.xmp } result ] } {
    exit 10
  }
  if { [run exporttosdk] != 0 } {
    return -1
  }
  return 0
}

if { [catch {exportToSDK} result] } {
  exit -1
}

exit $result

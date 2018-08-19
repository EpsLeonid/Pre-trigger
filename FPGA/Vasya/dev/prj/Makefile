#
#  Makefile to replace ISE GUI
#
#  M.Nakao
#

ISE = /opt/Xilinx/14.7/ISE_DS/ISE

PATH:=$(ISE)/bin/lin64:$(ISE)/bin/lin:$(PATH)

NAME   = top
PART   = xc6slx150t-fgg900-3

#-- input and outputd
VHDL  = ../vhd/$(NAME).vhd
UCF   = ../ucf/$(NAME).ucf
BIT   = ../bit/lom_dev.bit
NGDDIR = -sd ./prj/coregen
ADD   = \
	../vhd/constants.vhd          \
	../vhd/types.vhd              \
	../vhd/reg_utils.vhd          \
	../vhd/simple_deser.vhd       \
	../vhd/reg_map.vhd            \
	../vhd/mem.vhd          \
	../vhd/histo.vhd              \
	../vhd/adc_deser.vhd          \
	../vhd/lom_utils.vhd          \
  ../vhd/histo_manager.vhd      \
  ../vhd/counters_manager.vhd   \
  ../vhd/adc_serdes_xapp.vhd    \
  ../vhd/selftest.vhd           \
  ../vhd/reg_file.vhd           \
  ../vhd/mem_file.vhd           \
  ../vhd/lom.vhd                \
  ../vhd/infrastructure_top.vhd \
  ../vhd/adc_ctrl.vhd           \
  ../vhd/top.vhd                \



#-- commands
XSTCMD = xst
NGDCMD = ngdbuild
MAPCMD = map
PARCMD = par
RPTCMD = reportgen
TRCCMD = trce
GENCMD = bitgen
ELF    = /home/shebalin/lom/embd/ws_boot/bootloader/Debug/bootloader_0x200000.elf

#-- command options
ISEOPT = -intstyle ise
XSTOPT = $(ISEOPT)
NGDOPT = $(ISEOPT) -dd _ngo $(NGDDIR) -sd system -sd system/implementation -bm edkBmmFile.bmm -nt timestamp -uc $(UCF) -p $(PART)
MAPOPT1 = -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4
MAPOPT2 = -mt 4 -ir off -pr b -lc off -power off
MAPOPT3 =
MAPOPT = $(ISEOPT) -p $(PART) $(MAPOPT1) $(MAPOPT2) $(MAPOPT3)
PAROPT = $(ISEOPT) -w -ol high -mt 4
TRCOPT = $(ISEOPT) -v 3 -s 2 -n 3 -fastpaths
GENOPT = -bd $(ELF)
RPTOPT = $(ISEOPT)

#-- intermediate files
NGC   = $(NAME).ngc
XSTIN = $(NAME).xst
NGD   = $(NAME).ngd
MAP   = $(NAME)_map.ncd
NCD   = $(NAME).ncd
PCF   = $(NAME).pcf
TWR   = $(NAME).twr
NPL   = $(NAME).npl
UTF   = $(NAME).ut

#-- log files
SYR   = $(NAME).syr
BLD   = $(NAME).bld
MRP   = $(NAME).mrp


all: $(BIT)

clean:
	-rm -fr _ngo _xmsgs xlnx_auto_0_xdb iseconfig xst
	-rm -f *.bgn *.bld *.dly *.drc *.lso *.ncd *.ngc *.ngd *.ngr
	-rm -f *.pad *.par *.pcf *.ptwx *.syr *.twx *.unroutes *.xpi
	-rm -f *.map *.mrp *.ngm *.psr *.xrpt *_pad.{csv,txt} *.xml *.log
	-rm -f  *.stx *.xwbt *.html *.cmd_log
	-rm -f *~ *.bak

backup:
	sh make-backup.sh

$(BIT): $(VHDL) $(ADD) $(UCF)
	-mkdir -p xst/projnav.tmp >/dev/null
	$(XSTCMD) $(XSTOPT) -ifn $(XSTIN) -ofn $(SYR)
	$(NGDCMD) $(NGDOPT) $(NGC) $(NGD)
	$(MAPCMD) $(MAPOPT) -o $(MAP) $(NGD) $(PCF)
	$(PARCMD) $(PAROPT) $(MAP) $(NCD) $(PCF)
	$(RPTCMD) $(RPTOPT) -delay $(NCD)
	$(GENCMD) $(GENOPT) -f $(UTF) $(NCD) $(BIT)
	$(TRCCMD) $(TRCOPT) $(NCD) -o $(TWR) $(PCF) -ucf $(UCF)
	grep 'Maximum frequency' $(TWR)
	grep 'failing' $(TWR)

copy:
	scp -oProxyCommand="ssh -W %h:%p bdaq.local.kek.jp" $(BIT) b2ecl09.daqnet:lom/bit/


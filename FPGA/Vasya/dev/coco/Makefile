# Copyright (c) 2016 Technische Universitaet Dresden, Germany
# Chair for VLSI-Design, Diagnostic and Architecture
# Author: Martin Zabel
# All rights reserved.

CWD=$(shell pwd)
COCOTB=$(HOME)/cocotb

TOPDIR=$(PWD)/..

TOPLEVEL_LANG ?=vhdl

ifeq ($(TOPLEVEL_LANG),verilog)
  VERILOG_SOURCES =$(CWD)/../hdl/dff.v
else ifeq ($(TOPLEVEL_LANG),vhdl)
  VHDL_SOURCES+=$(CWD)/../vhd/constants.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/types.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/reg_utils.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/reg_map.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/lom_utils.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/counters_manager.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/mem.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/histo.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/histo_manager.vhd
  VHDL_SOURCES+=$(CWD)/../vhd/lom.vhd
else
  $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif

TOPLEVEL=lom
MODULE=$(TOPLEVEL)_cocotb

CUSTOM_SIM_DEPS=$(CWD)/Makefile

EXTRA_ARGS+=-I$(TOPDIR)/vhd/


VSIM_ARGS=-t 1ps
VSIM_ARGS+=-L work

include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim

# list all required Python files here
sim: $(MODULE).py

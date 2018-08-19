# ==============================================================================
# Authors:		Martin Zabel
# 
# Cocotb Testbench:	For D-FF
# 
# Description:
# ------------------------------------
# Automated testbench for simple D-FF.
#
# License:
# ==============================================================================
# Copyright 2016 Technische Universitaet Dresden - Germany
#		 Chair for VLSI-Design, Diagnostics and Architecture
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#		http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

import random

import cocotb
from cocotb.clock import Clock                              
from cocotb.decorators import coroutine
from cocotb.triggers import Timer, RisingEdge, ReadOnly
from cocotb.monitors import Monitor
from cocotb.drivers import BitDriver
from cocotb.binary import BinaryValue
from cocotb.regression import TestFactory
from cocotb.scoreboard import Scoreboard
from cocotb.result import TestFailure, TestSuccess

# Data generators
from cocotb.generators.byte import random_data, get_bytes
from cocotb.generators.bit import (wave, intermittent_single_cycles,
                                    random_50_percent)                     



# ==============================================================================
class BitMonitor(Monitor):
    """Observes single input or output of DUT."""
    def __init__(self, name, signal, clock, callback=None, event=None):
        self.name = name
        self.signal = signal
        self.clock = clock
        Monitor.__init__(self, callback, event)
        
    @coroutine
    def _monitor_recv(self):
        clkedge = RisingEdge(self.clock)

        while True:
            # Capture signal at rising edge of clock
            yield clkedge
            vec = self.signal.value
            self._recv(vec)

# ==============================================================================
def input_gen():
    """Generator for input data applied by BitDriver"""
    while True:
        yield random.randint(1,5), random.randint(1,5)
        
# ==============================================================================
class LOM_TB(object):
    def __init__(self, dut, init_val):
        """
        Setup testbench.

        init_val signifies the BinaryValue which must be captured by the
        output monitor with the first risign edge. This is actually the initial 
        state of the flip-flop.
        """
        # Some internal state
        self.dut = dut
        self.stopped = False

        # Create input driver and output monitor

        #self.input_drv = BitDriver(dut.d, dut.c, input_gen())
        #self.output_mon = BitMonitor("output", dut.q, dut.c)
        
        # Create a scoreboard on the outputs
        #self.expected_output = [ init_val ]
        #self.scoreboard = Scoreboard(dut)
        #self.scoreboard.add_interface(self.output_mon, self.expected_output)

        # Reconstruct the input transactions from the pins
        # and send them to our 'model'
        
        #self.input_mon = BitMonitor("input", dut.d, dut.c,
    #                            callback=self.model)

    def model(self, transaction):
        """Model the DUT based on the input transaction."""
        # Do not append an output transaction for the last clock cycle of the
        # simulation, that is, after stop() has been called.
        if not self.stopped:
            self.expected_output.append(transaction)

    def start(self):
        """Start generation of input data."""
        self.input_drv.start()

    def stop(self):
        """
        Stop generation of input data. 
        Also stop generation of expected output transactions.
        One more clock cycle must be executed afterwards, so that, output of
        D-FF can be checked.
        """
        self.input_drv.stop()
        self.stopped = True

# ==============================================================================
@cocotb.coroutine
def clock_gen(signal):
    """Generate the clock signal."""
    while True:
        signal <= 0
        yield Timer(5000) # ps
        signal <= 1
        yield Timer(5000) # ps

# ==============================================================================
@cocotb.coroutine
def run_test(dut):
    """Setup testbench and run a test."""
    cocotb.fork(clock_gen(dut.i_clock))
    tb = LOM_TB(dut, BinaryValue(0,1))
    clkedge = RisingEdge(dut.i_clock)

    # Apply random input data by input_gen via BitDriver for 100 clock cycle.
    tb.start()
    for i in range(100):
        yield clkedge

    # Stop generation of input data. One more clock cycle is needed to capture
    # the resulting output of the DUT.
    tb.stop()
    yield clkedge

    # Print result of scoreboard.
    raise tb.scoreboard.result

# ==============================================================================
# Register test.

factory = TestFactory(run_test)

#factory.add_option("data_in",                                                  
#                   [random_packet_sizes])
#factory.add_option("config_coroutine",
#                   [None, randomly_switch_config])
factory.add_option("idle_inserter",
                   [None, wave, intermittent_single_cycles, random_50_percent])
factory.add_option("backpressure_inserter",
                   [None, wave, intermittent_single_cycles, random_50_percent])
factory.generate_tests()

import cocotb.wavedrom

@cocotb.test()
def wavedrom_test(dut):
    """
            Generate a JSON wavedrom diagram of a trace
    """
    cocotb.fork(Clock(dut.i_clock,5000).start())
    yield RisingEdge(dut.i_clock)
    tb = LOM_TB(dut,0)
    #yield tb.reset()

    with cocotb.wavedrom.trace(dut.i_reset, clk=dut.i_clock) as waves:
        yield RisingEdge(dut.i_clock)
        #yield tb.csr.read(0)
        yield RisingEdge(dut.i_clock)
        yield RisingEdge(dut.i_clock)
        dut._log.info(waves.dumpj())                                            


--------------------------------------------------------------------------------
-- Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: M.81d
--  \   \         Application: netgen
--  /   /         Filename: b2tt_icon.vhd
-- /___/   /\     Timestamp: Fri Jul 11 18:25:33 2014
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -w -sim -ofmt vhdl /home/usr/nakao/ise/sp605/sp605_b2tt/coregen/tmp/_cg/b2tt_icon.ngc /home/usr/nakao/ise/sp605/sp605_b2tt/coregen/tmp/_cg/b2tt_icon.vhd 
-- Device	: xc6slx45t-fgg484-3
-- Input file	: /home/usr/nakao/ise/sp605/sp605_b2tt/coregen/tmp/_cg/b2tt_icon.ngc
-- Output file	: /home/usr/nakao/ise/sp605/sp605_b2tt/coregen/tmp/_cg/b2tt_icon.vhd
-- # of Entities	: 1
-- Design Name	: b2tt_icon
-- Xilinx	: /home/xilinx/ise12.4/ISE/
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity b2tt_icon is
  port (
    CONTROL0 : inout STD_LOGIC_VECTOR ( 35 downto 0 ) 
  );
end b2tt_icon;

architecture STRUCTURE of b2tt_icon is
begin
end STRUCTURE;


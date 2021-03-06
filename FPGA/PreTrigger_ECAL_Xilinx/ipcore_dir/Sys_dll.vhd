--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 14.7
--  \   \         Application : xaw2vhdl
--  /   /         Filename : Sys_dll.vhd
-- /___/   /\     Timestamp : 12/11/2020 17:02:08
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: xaw2vhdl-st D:\Users\Leon\Work\Japan\COMET\Electronics\trunk\FPGA\PreTrigger_ECAL_Xilinx\.\Sys_dll.xaw D:\Users\Leon\Work\Japan\COMET\Electronics\trunk\FPGA\PreTrigger_ECAL_Xilinx\.\Sys_dll
--Design Name: Sys_dll
--Device: xc4vlx60-10ff1148
--
-- Module Sys_dll
-- Generated by Xilinx Architecture Wizard
-- Written for synthesis tool: XST
-- Period Jitter (unit interval) for block DCM_ADV_INST1 = 0.049 UI
-- Period Jitter (Peak-to-Peak) for block DCM_ADV_INST1 = 0.309 ns
-- Period Jitter (unit interval) for block DCM_ADV_INST2 = 0.062 UI
-- Period Jitter (Peak-to-Peak) for block DCM_ADV_INST2 = 0.309 ns

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity Sys_dll is
   port ( U1_CLKIN_IN        : in    std_logic; 
          U1_RST_IN          : in    std_logic; 
          U1_CLK90_OUT       : out   std_logic; 
          U1_CLKDV_OUT       : out   std_logic; 
          U1_CLKFX_OUT       : out   std_logic;
          U1_CLK2X_OUT       : out   std_logic;
          U1_CLKIN_IBUFG_OUT : out   std_logic; 
          U1_CLK0_OUT        : out   std_logic; 
          U2_CLKFX_OUT       : out   std_logic; 
          U2_CLK0_OUT        : out   std_logic; 
          U2_CLK90_OUT       : out   std_logic; 
          U2_LOCKED_OUT      : out   std_logic);
end Sys_dll;

architecture BEHAVIORAL of Sys_dll is
   signal GND_BIT            : std_logic;
   signal GND_BUS_7          : std_logic_vector (6 downto 0);
   signal GND_BUS_16         : std_logic_vector (15 downto 0);
   signal U1_CLKDV_BUF       : std_logic;
   signal U1_CLKFX_BUF       : std_logic;
   signal U1_CLK2x_BUF       : std_logic;
   signal U1_CLKIN_IBUFG     : std_logic;
   signal U1_CLK0_BUF        : std_logic;
   signal U1_CLK90_BUF       : std_logic;
   signal U1_LOCKED_INV_IN   : std_logic;
   signal U2_CLKFB_IN        : std_logic;
   signal U2_CLKFX_BUF       : std_logic;
   signal U2_CLKIN_IN        : std_logic;
   signal U2_CLK0_BUF        : std_logic;
   signal U2_CLK90_BUF       : std_logic;
   signal U2_FDS_Q_OUT       : std_logic;
   signal U2_FD1_Q_OUT       : std_logic;
   signal U2_FD2_Q_OUT       : std_logic;
   signal U2_FD3_Q_OUT       : std_logic;
   signal U2_LOCKED_INV_RST  : std_logic;
   signal U2_OR3_O_OUT       : std_logic;
   signal U2_RST_IN          : std_logic;
begin
   GND_BIT <= '0';
   GND_BUS_7(6 downto 0) <= "0000000";
   GND_BUS_16(15 downto 0) <= "0000000000000000";
   U1_CLKIN_IBUFG_OUT <= U1_CLKIN_IBUFG;
   U1_CLK0_OUT <= U2_CLKIN_IN;
   U2_CLK0_OUT <= U2_CLKFB_IN;
   DCM_ADV_INST1 : DCM_ADV
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 2.0,
            CLKFX_DIVIDE => 1,
            CLKFX_MULTIPLY => 4,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 25.000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DCM_AUTOCALIBRATION => TRUE,
            DCM_PERFORMANCE_MODE => "MAX_SPEED",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"F0F0",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
      port map (CLKFB=>U2_CLKIN_IN,
                CLKIN=>U1_CLKIN_IBUFG,
                DADDR(6 downto 0)=>GND_BUS_7(6 downto 0),
                DCLK=>GND_BIT,
                DEN=>GND_BIT,
                DI(15 downto 0)=>GND_BUS_16(15 downto 0),
                DWE=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>U1_RST_IN,
                CLKDV=>U1_CLKDV_BUF,
                CLKFX=>U1_CLKFX_BUF,
                CLKFX180=>open,
                CLK0=>U1_CLK0_BUF,
                CLK2X=>U1_CLK2X_BUF,
                CLK2X180=>open,
                CLK90=>U1_CLK90_BUF,
                CLK180=>open,
                CLK270=>open,
                DO=>open,
                DRDY=>open,
                LOCKED=>U1_LOCKED_INV_IN,
                PSDONE=>open);
   
   DCM_ADV_INST2 : DCM_ADV
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 2.0,
            CLKFX_DIVIDE => 1,
            CLKFX_MULTIPLY => 5,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 25.000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DCM_AUTOCALIBRATION => TRUE,
            DCM_PERFORMANCE_MODE => "MAX_SPEED",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"F0F0",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
      port map (CLKFB=>U2_CLKFB_IN,
                CLKIN=>U2_CLKIN_IN,
                DADDR(6 downto 0)=>GND_BUS_7(6 downto 0),
                DCLK=>GND_BIT,
                DEN=>GND_BIT,
                DI(15 downto 0)=>GND_BUS_16(15 downto 0),
                DWE=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>U2_RST_IN,
                CLKDV=>open,
                CLKFX=>U2_CLKFX_BUF,
                CLKFX180=>open,
                CLK0=>U2_CLK0_BUF,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>U2_CLK90_BUF,
                CLK180=>open,
                CLK270=>open,
                DO=>open,
                DRDY=>open,
                LOCKED=>U2_LOCKED_OUT,
                PSDONE=>open);
   
   U1_CLKDV_BUFG_INST : BUFG
      port map (I=>U1_CLKDV_BUF,
                O=>U1_CLKDV_OUT);

   U1_CLKDV_BUFG_INST : BUFG
      port map (I=>U1_CLK2X_BUF,
                O=>U1_CLK2X_OUT);
 
   U1_CLKFX_BUFG_INST : BUFG
      port map (I=>U1_CLKFX_BUF,
                O=>U1_CLKFX_OUT);
   
   U1_CLKIN_IBUFG_INST : IBUFG
      port map (I=>U1_CLKIN_IN,
                O=>U1_CLKIN_IBUFG);
   
   U1_CLK0_BUFG_INST : BUFG
      port map (I=>U1_CLK0_BUF,
                O=>U2_CLKIN_IN);
   
   U1_CLK90_BUFG_INST : BUFG
      port map (I=>U1_CLK90_BUF,
                O=>U1_CLK90_OUT);
   
   U1_INV_INST : INV
      port map (I=>U1_LOCKED_INV_IN,
                O=>U2_LOCKED_INV_RST);
   
   U2_CLKFX_BUFG_INST : BUFG
      port map (I=>U2_CLKFX_BUF,
                O=>U2_CLKFX_OUT);
   
   U2_CLK0_BUFG_INST : BUFG
      port map (I=>U2_CLK0_BUF,
                O=>U2_CLKFB_IN);
   
   U2_CLK90_BUFG_INST : BUFG
      port map (I=>U2_CLK90_BUF,
                O=>U2_CLK90_OUT);
   
   U2_FDS_INST : FDS
      port map (C=>U2_CLKIN_IN,
                D=>GND_BIT,
                S=>GND_BIT,
                Q=>U2_FDS_Q_OUT);
   
   U2_FD1_INST : FD
      port map (C=>U2_CLKIN_IN,
                D=>U2_FDS_Q_OUT,
                Q=>U2_FD1_Q_OUT);
   
   U2_FD2_INST : FD
      port map (C=>U2_CLKIN_IN,
                D=>U2_FD1_Q_OUT,
                Q=>U2_FD2_Q_OUT);
   
   U2_FD3_INST : FD
      port map (C=>U2_CLKIN_IN,
                D=>U2_FD2_Q_OUT,
                Q=>U2_FD3_Q_OUT);
   
   U2_OR2_INST : OR2
      port map (I0=>U2_LOCKED_INV_RST,
                I1=>U2_OR3_O_OUT,
                O=>U2_RST_IN);
   
   U2_OR3_INST : OR3
      port map (I0=>U2_FD3_Q_OUT,
                I1=>U2_FD2_Q_OUT,
                I2=>U2_FD1_Q_OUT,
                O=>U2_OR3_O_OUT);
   
end BEHAVIORAL;



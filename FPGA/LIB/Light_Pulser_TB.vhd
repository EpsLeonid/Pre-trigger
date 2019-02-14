--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:10:29 08/16/2018
-- Design Name:   
-- Module Name:   /home/alexey/Documents/Alexey/VHDL/ISE/Proba4/ZynqDemoBoard/Light_Pulser_TB.vhd
-- Project Name:  ZynqDemoBoard
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Light_Pulser
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Light_Pulser_TB IS
END Light_Pulser_TB;
 
ARCHITECTURE behavior OF Light_Pulser_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Light_Pulser
	 GENERIC  ( DIV       : NATURAL; 
				   DUR       : NATURAL);
    PORT(
         clock : IN  std_logic;
         i_event : IN  std_logic;
         o_flash : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal i_event : std_logic := '0';
   signal o_flash : std_logic := '0';

   -- Clock period definitions
   constant clock_period : time := 12.5 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Light_Pulser 
		GENERIC MAP (
			 DIV => 2,
			 DUR => 100)
		PORT MAP (
          clock => clock,
          i_event => i_event,
          o_flash => o_flash);

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
       wait for 100 ns;	
			i_event <= '1';
		wait for 50 ns;	
			i_event <= '0';	
			
      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

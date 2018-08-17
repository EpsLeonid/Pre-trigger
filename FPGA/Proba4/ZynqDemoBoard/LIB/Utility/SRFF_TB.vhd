--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:42:23 08/15/2018
-- Design Name:   
-- Module Name:   /home/alexey/Documents/Alexey/VHDL/ISE/LIB/Utility/SRFF_TB.vhd
-- Project Name:  ZynqDemoBoard
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SRFF
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
 
ENTITY SRFF_TB IS
END SRFF_TB;
 
ARCHITECTURE behavior OF SRFF_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SRFF
    PORT(
         S : IN  std_logic;
         CLK : IN  std_logic;
         R : IN  std_logic;
         Q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal S : std_logic := '0';
   signal CLK : std_logic := '0';
   signal R : std_logic := '0';

 	--Outputs
   signal Q : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SRFF PORT MAP (
          S => S,
          CLK => CLK,
          R => R,
          Q => Q
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
			S <= '1';
		wait for 10 ns;	
			S <= '0';
		wait for 100 ns;	
			R <= '1';
		wait for 10 ns;	
			R <= '0';
			
      wait for 100 ns;	
			S <= '1';
		wait for 10 ns;	
			R <= '1';
 --    wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

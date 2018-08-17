--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:19:20 08/14/2018
-- Design Name:   
-- Module Name:   /home/alexey/Documents/Alexey/VHDL/ISE/Proba2/TopModule/TopTB.vhd
-- Project Name:  TopModule
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Top
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
 
ENTITY TopTB IS
END TopTB;
 
ARCHITECTURE behavior OF TopTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top
    PORT(
         SW0 : IN  std_logic;
         SW1 : IN  std_logic;
         LD0 : OUT  std_logic;
         LD1 : OUT  std_logic;
         clock : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SW0 : std_logic := '0';
   signal SW1 : std_logic := '0';
   signal clock : std_logic := '0';

 	--Outputs
   signal LD0 : std_logic;
   signal LD1 : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Top PORT MAP (
          SW0 => SW0,
          SW1 => SW1,
          LD0 => LD0,
          LD1 => LD1,
          clock => clock
        );

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
			SW0 <= '1';
			SW1 <= '1';
     -- wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:22:23 08/20/2018
-- Design Name:   
-- Module Name:   C:/Work/COMET project/trunk/FPGA/LIB/PhaseSW_TB.vhd
-- Project Name:  Pre-trigger
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PhaseSW
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
 
ENTITY PhaseSW_TB IS
END PhaseSW_TB;
 
ARCHITECTURE behavior OF PhaseSW_TB IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
 
	 COMPONENT PhaseSW
	 PORT(
			Clock : IN  std_logic;
			SysClk : IN  std_logic;
			Reset : IN  std_logic;
			Phase : OUT  std_logic;
			SysClk_Selected : OUT  std_logic;
			Test : OUT  std_logic_vector(4 downto 1)
		  );
	 END COMPONENT;
	 

	--Inputs
	signal Clock : std_logic := '0';
	signal SysClk : std_logic := '0';
	signal Reset : std_logic := '0';

	--Outputs
	signal Phase : std_logic;
	signal SysClk_Selected : std_logic := '0';
	signal Test : std_logic_vector(4 downto 1);

	-- Clock period definitions
	constant Clock_period : time := 25 ns;
	constant SysClk_period : time := 25.1 ns;
	constant DUTY_CYCLE : real := 0.5;
	-- Test 
	signal ClkDelay : std_logic;
	signal SysClk_en : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: PhaseSW PORT MAP (
			 Clock => Clock,
			 SysClk => SysClk_en,
			 Reset => Reset,
			 Phase => Phase,
			 SysClk_Selected => SysClk_Selected,
			 Test => Test
		  );

	-- Clock process definitions
	Clock_process :process
	begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 
--	SysClk_process :process
--	begin
--			SysClk <= '0';
--			wait for SysClk_period/2;
--			SysClk <= '1';
--			wait for SysClk_period/2;
--	end process;
	SysClk_process :process
	begin
			SysClk <= '1';
			wait for (SysClk_period - (SysClk_period * DUTY_CYCLE));
			SysClk <= '0';
			wait for (SysClk_period*DUTY_CYCLE);
	end process;

	SysClk_en <= SysClk AND ClkDelay;
	
	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		ClkDelay <= '0';
		wait for 70 ns;	
		ClkDelay <= '1';
		wait for Clock_period*10;

		-- insert stimulus here 

		wait;
	end process;

END;

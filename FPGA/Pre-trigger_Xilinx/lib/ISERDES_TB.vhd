--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:43:12 10/16/2018
-- Design Name:   
-- Module Name:   D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/Pre-trigger_Xilinx/lib/ISERDES_TB.vhd
-- Project Name:  Pre-trigger
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ISERDES_8bit
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
 
ENTITY ISERDES_TB IS
END ISERDES_TB;
 
ARCHITECTURE behavior OF ISERDES_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ISERDES_8bit
    PORT(
         Clock : IN  std_logic;
--			Clk_Div	: out std_logic;
         Rst : IN  std_logic;
         DataIn : IN  std_logic;
         Test : IN  std_logic;
         DataOut : OUT  std_logic_vector(7 downto 0)
--			Test : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal i_clk : std_logic := '0';
   signal ClkDiv : std_logic := '0';
   signal DataIn : std_logic := '0';
   signal Rst : std_logic := '0';

 	--Outputs
--	signal Clk_Div : std_logic;
   signal DataOut : std_logic_vector(7 downto 0);
   signal Test : std_logic := '0';

   -- Clock period definitions
   constant Clock_period : time := 3125 ps;
--   constant Clock_period : time := 5 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ISERDES_8bit PORT MAP (
          DataIn => DataIn,
          Clock => Clock,
--			 Clk_Div	=> Clk_Div,
          Rst => Rst,
          DataOut => DataOut,
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
 
	i_clk <= transport Clock after Clock_period/4;
 
   ClockDiv_process :process
   begin
		ClkDiv <= '0';
		wait for Clock_period*2;
		ClkDiv <= '1';
		wait for Clock_period*2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		DataIn <= '0';
		Test <= '0';
      wait for Clock_period*5;
		
		Rst <= '1';

      wait for Clock_period*2;

		Rst <= '0';
		Test <= '1';
      wait for Clock_period*3;

		DataIn <= '1';
      wait for Clock_period/2;	
		DataIn <= '0';
      wait for Clock_period/2;	
		DataIn <= '1';
      wait for Clock_period/2;	
		DataIn <= '1';
      wait for Clock_period/2;	
		DataIn <= '0';
      wait for Clock_period/2;	
		DataIn <= '1';
      wait for Clock_period/2;	
		DataIn <= '0';
      wait for Clock_period/2;	
		DataIn <= '1';
      wait for Clock_period/2;	
		DataIn <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:46:44 08/28/2018
-- Design Name:   
-- Module Name:   D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/Pre-trigger_Xilinx/lib/FindMaxAmp_TB.vhd
-- Project Name:  Pre-trigger
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FindMaxAmp
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
 
ENTITY FindMaxAmp_TB IS
END FindMaxAmp_TB;
 
ARCHITECTURE behavior OF FindMaxAmp_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FindMaxAmp
    PORT(
         In_Data : IN  std_logic_vector(0 to 128);
         In_DataPrev : IN  std_logic_vector(0 to 12);
         RegInit : IN  std_logic;
         MaxAmp : OUT  std_logic_vector(9 downto 0);
         MaxCellNumber : OUT  std_logic_vector(-9999 to 0);
         ThrNum1 : OUT  std_logic_vector(3 downto 0);
         ThrNum2 : OUT  std_logic_vector(3 downto 0);
         ThrNum3 : OUT  std_logic_vector(3 downto 0);
         ThrNum4 : OUT  std_logic_vector(3 downto 0);
         ThrNum5 : OUT  std_logic_vector(3 downto 0);
         FastTrig : OUT  std_logic;
         Trig : OUT  std_logic;
         SaveTrigData : OUT  std_logic;
         Clock : IN  std_logic;
         Clock160 : IN  std_logic;
         Reset : IN  std_logic;
         Error : OUT  std_logic;
         test : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal In_Data : std_logic_vector(0 to 128) := (others => '0');
   signal In_DataPrev : std_logic_vector(0 to 12) := (others => '0');
   signal RegInit : std_logic := '0';
   signal Clock : std_logic := '0';
   signal Clock160 : std_logic := '0';
   signal Reset : std_logic := '0';

 	--Outputs
   signal MaxAmp : std_logic_vector(9 downto 0);
   signal MaxCellNumber : std_logic_vector(-9999 to 0);
   signal ThrNum1 : std_logic_vector(3 downto 0);
   signal ThrNum2 : std_logic_vector(3 downto 0);
   signal ThrNum3 : std_logic_vector(3 downto 0);
   signal ThrNum4 : std_logic_vector(3 downto 0);
   signal ThrNum5 : std_logic_vector(3 downto 0);
   signal FastTrig : std_logic;
   signal Trig : std_logic;
   signal SaveTrigData : std_logic;
   signal Error : std_logic;
   signal test : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
   constant Clock160_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FindMaxAmp PORT MAP (
          In_Data => In_Data,
          In_DataPrev => In_DataPrev,
          RegInit => RegInit,
          MaxAmp => MaxAmp,
          MaxCellNumber => MaxCellNumber,
          ThrNum1 => ThrNum1,
          ThrNum2 => ThrNum2,
          ThrNum3 => ThrNum3,
          ThrNum4 => ThrNum4,
          ThrNum5 => ThrNum5,
          FastTrig => FastTrig,
          Trig => Trig,
          SaveTrigData => SaveTrigData,
          Clock => Clock,
          Clock160 => Clock160,
          Reset => Reset,
          Error => Error,
          test => test
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 
   Clock160_process :process
   begin
		Clock160 <= '0';
		wait for Clock160_period/2;
		Clock160 <= '1';
		wait for Clock160_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

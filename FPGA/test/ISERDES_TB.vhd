--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:33:58 11/20/2018
-- Design Name:   
-- Module Name:   D:/Users/Leon/Work/Japan/COMET/Electronics/trunk/FPGA/test/ISERDES_TB.vhd
-- Project Name:  test
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
         Qclock : IN  std_logic;
         FCT_40 : IN  std_logic;
         FCT_160 : IN  std_logic;
         FCT_160_n : IN  std_logic;
         Sw_Quartz : OUT  std_logic;
         Sw_FCTClk : OUT  std_logic;
         MuxClock_in : IN  std_logic;
         Led1 : OUT  std_logic;
         Led2 : OUT  std_logic;
         Led3 : OUT  std_logic;
         Led4 : OUT  std_logic;
         Led5 : OUT  std_logic;
         ADCInDataLVDS : IN  std_logic_vector(127 downto 0);
         ADCInDataLVDS_n : IN  std_logic_vector(127 downto 0);
         ADCInDataLVDSPrev : IN  std_logic_vector(11 downto 0);
         ADCInDataLVDSPrev_n : IN  std_logic_vector(11 downto 0);
         ADC_test : IN  std_logic;
         ADC_res : IN  std_logic;
         ADC_CSB : OUT  std_logic;
         ADC_SDIO : OUT  std_logic;
         ADC_SCLK : OUT  std_logic;
         ADC_CLK : OUT  std_logic;
         ADC_DCO_LVDS : IN  std_logic_vector(1 downto 0);
         ADC_DCO_LVDS_n : IN  std_logic_vector(1 downto 0);
         ADC_FCO_LVDS : IN  std_logic_vector(1 downto 0);
         ADC_FCO_LVDS_n : IN  std_logic_vector(1 downto 0);
         ADC_DCO_LVDSPrev : IN  std_logic_vector(11 downto 0);
         ADC_DCO_LVDSPrev_n : IN  std_logic_vector(11 downto 0);
         TrigInLVDS : IN  std_logic;
         TrigInLVDS_n : IN  std_logic;
         FastTrigDes : OUT  std_logic;
         TrigDes : OUT  std_logic;
         TriggerData : OUT  std_logic_vector(63 downto 0);
         RxClk : IN  std_logic;
         Crs : IN  std_logic;
         RxDv : IN  std_logic;
         RxD : IN  std_logic_vector(3 downto 0);
         TxClk : IN  std_logic;
         TxEn : OUT  std_logic;
         TxD : OUT  std_logic_vector(3 downto 0);
         Col : IN  std_logic;
         ExtReset : IN  std_logic;
         Test : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Qclock : std_logic := '0';
   signal FCT_40 : std_logic := '0';
   signal FCT_160 : std_logic := '0';
   signal FCT_160_n : std_logic := '0';
   signal MuxClock_in : std_logic := '0';
   signal ADCInDataLVDS : std_logic_vector(127 downto 0) := (others => '0');
   signal ADCInDataLVDS_n : std_logic_vector(127 downto 0) := (others => '0');
   signal ADCInDataLVDSPrev : std_logic_vector(11 downto 0) := (others => '0');
   signal ADCInDataLVDSPrev_n : std_logic_vector(11 downto 0) := (others => '0');
   signal ADC_test : std_logic := '0';
   signal ADC_res : std_logic := '0';
   signal ADC_DCO_LVDS : std_logic_vector(1 downto 0) := (others => '0');
   signal ADC_FCO_LVDS_n : std_logic_vector(1 downto 0) := (others => '0');
   signal ADC_FCO_LVDS : std_logic_vector(1 downto 0) := (others => '0');
   signal ADC_DCO_LVDS_n : std_logic_vector(1 downto 0) := (others => '0');
   signal ADC_DCO_LVDSPrev : std_logic_vector(11 downto 0) := (others => '0');
   signal ADC_DCO_LVDSPrev_n : std_logic_vector(11 downto 0) := (others => '0');
   signal TrigInLVDS : std_logic := '0';
   signal TrigInLVDS_n : std_logic := '0';
   signal RxClk : std_logic := '0';
   signal Crs : std_logic := '0';
   signal RxDv : std_logic := '0';
   signal RxD : std_logic_vector(3 downto 0) := (others => '0');
   signal TxClk : std_logic := '0';
   signal Col : std_logic := '0';
   signal ExtReset : std_logic := '0';

 	--Outputs
   signal Sw_Quartz : std_logic;
   signal Sw_FCTClk : std_logic;
   signal Led1 : std_logic;
   signal Led2 : std_logic;
   signal Led3 : std_logic;
   signal Led4 : std_logic;
   signal Led5 : std_logic;
   signal ADC_CSB : std_logic;
   signal ADC_SDIO : std_logic;
   signal ADC_SCLK : std_logic;
   signal ADC_CLK : std_logic;
   signal FastTrigDes : std_logic;
   signal TrigDes : std_logic;
   signal TriggerData : std_logic_vector(63 downto 0);
   signal TxEn : std_logic;
   signal TxD : std_logic_vector(3 downto 0);
   signal Test : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant Qclock_period : time := 25 ns;
   constant FCT_40_period : time := 25 ns;
   constant MuxClock_in_period : time := 25 ns;
   constant ADC_SCLK_period : time := 50 ns;
   constant ADC_CLK_period : time := 12500 ps;
   constant FCO_period : time := 12500 ps;
   constant DCO_period : time := 3125 ps;
   constant RxClk_period : time := 40 ns;
   constant TxClk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ISERDES_8bit PORT MAP (
          Qclock => Qclock,
          FCT_40 => FCT_40,
          FCT_160 => FCT_160,
          FCT_160_n => FCT_160_n,
          Sw_Quartz => Sw_Quartz,
          Sw_FCTClk => Sw_FCTClk,
          MuxClock_in => MuxClock_in,
          Led1 => Led1,
          Led2 => Led2,
          Led3 => Led3,
          Led4 => Led4,
          Led5 => Led5,
          ADCInDataLVDS => ADCInDataLVDS,
          ADCInDataLVDS_n => ADCInDataLVDS_n,
          ADCInDataLVDSPrev => ADCInDataLVDSPrev,
          ADCInDataLVDSPrev_n => ADCInDataLVDSPrev_n,
          ADC_test => ADC_test,
          ADC_res => ADC_res,
          ADC_CSB => ADC_CSB,
          ADC_SDIO => ADC_SDIO,
          ADC_SCLK => ADC_SCLK,
          ADC_CLK => ADC_CLK,
          ADC_DCO_LVDS => ADC_DCO_LVDS,
          ADC_DCO_LVDS_n => ADC_DCO_LVDS_n,
          ADC_FCO_LVDS => ADC_FCO_LVDS,
          ADC_FCO_LVDS_n => ADC_FCO_LVDS_n,
          ADC_DCO_LVDSPrev => ADC_DCO_LVDSPrev,
          ADC_DCO_LVDSPrev_n => ADC_DCO_LVDSPrev_n,
          TrigInLVDS => TrigInLVDS,
          TrigInLVDS_n => TrigInLVDS_n,
          FastTrigDes => FastTrigDes,
          TrigDes => TrigDes,
          TriggerData => TriggerData,
          RxClk => RxClk,
          Crs => Crs,
          RxDv => RxDv,
          RxD => RxD,
          TxClk => TxClk,
          TxEn => TxEn,
          TxD => TxD,
          Col => Col,
          ExtReset => ExtReset,
          Test => Test
        );

   -- Clock process definitions
   Qclock_process :process
   begin
		Qclock <= '0';
		wait for Qclock_period/2;
		Qclock <= '1';
		wait for Qclock_period/2;
   end process;
 
   FCT_40_process :process
   begin
		FCT_40 <= '0';
		wait for FCT_40_period/2;
		FCT_40 <= '1';
		wait for FCT_40_period/2;
   end process;

   MuxClock_in_process :process
   begin
		MuxClock_in <= '0';
		wait for MuxClock_in_period/2;
		MuxClock_in <= '1';
		wait for MuxClock_in_period/2;
   end process;
 
   ADC_SCLK_process :process
   begin
		ADC_SCLK <= '0';
		wait for ADC_SCLK_period/2;
		ADC_SCLK <= '1';
		wait for ADC_SCLK_period/2;
   end process;
 
   ADC_CLK_process :process
   begin
		ADC_CLK <= '0';
		wait for ADC_CLK_period/2;
		ADC_CLK <= '1';
		wait for ADC_CLK_period/2;
   end process;
 
   FCO_process :process
   begin
		ADC_FCO_LVDS(0) <= '0';
		ADC_FCO_LVDS_n(0) <= '1';
		wait for FCO_period/2;
		ADC_FCO_LVDS(0) <= '1';
		ADC_FCO_LVDS_n(0) <= '0';
		wait for FCO_period/2;
   end process;

   DCO_process :process
   begin
		ADC_DCO_LVDS(0) <= '0';
		ADC_DCO_LVDS_n(0) <= '1';
		wait for DCO_period/2;
		ADC_DCO_LVDS(0) <= '1';
		ADC_DCO_LVDS_n(0) <= '0';
		wait for DCO_period/2;
   end process;

--   RxClk_process :process
--   begin
--		RxClk <= '0';
--		wait for RxClk_period/2;
--		RxClk <= '1';
--		wait for RxClk_period/2;
--   end process;
-- 
--   TxClk_process :process
--   begin
--		TxClk <= '0';
--		wait for TxClk_period/2;
--		TxClk <= '1';
--		wait for TxClk_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for Qclock_period*5;
		
		ExtReset <= '1';

      wait for Qclock_period*2;

		ExtReset <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;

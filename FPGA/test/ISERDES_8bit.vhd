----------------------------------------------------------------------------------
-- Company: BINP
-- Engineer: Leonid Epshteyn
-- 
-- Create Date:		18:06:04 08/15/2018 
-- Design Name: 
-- Module Name:		ISERDES_8bit - Behavioral 
-- Project Name:		COMET ECAL Trigger
-- Target Devices:	Pre-trigger
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.parameters.all;

entity ISERDES_8bit is
port (

-- 1. Clocks
	Qclock		: in std_logic; -- system clock
	FCT_40		: in std_logic ;--:= '0'; -- system clock
	FCT_160		: in std_logic ;--:= '0'; -- clock
	FCT_160_n	: in std_logic ;--:= '0'; -- clock
-- In Trigger module Link's Clock is checked inside Altera but switched outside 
	Sw_Quartz	: out std_logic := '1';	-- connects Quartz to PLL ref.Input			-> Pin 
	Sw_FCTClk	: out std_logic := '0';	-- connects Link's Clock to PLL ref.Input	-> Pin 

	MuxClock_in		: in std_logic := '0';	-- Ref.clock for PLL (dedicated)			<- Pin 

-- Outputs for Indicators on LED's

	Led1			: out std_logic;	-- drives the Green LED								-> Pin 
	Led2			: out std_logic := '1';	-- drives the Blue LED						-> Pin 
	Led3			: out std_logic := '1';	-- drives the Red LED						-> Pin 
	Led4			: out std_logic := '1';	-- drives the Blue(Yellow) LED			-> Pin 
	Led5			: out std_logic := '1';	-- drives the Blue(Yellow) LED			-> Pin 

-- 2. Channel  

	ADCInDataLVDS		: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDS_n	: in std_logic_vector(NUM_TrigCell-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev	: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 
	ADCInDataLVDSPrev_n: in std_logic_vector(NUM_TrigCellPrev-1 downto 0);	-- input of data from ADC	<- Pin 

	ADC_test				: in std_logic;
	ADC_res				: in std_logic;
	ADC_CSB				: out std_logic := '1';	-- Pin 
	ADC_SDIO				: out std_logic := '0';	-- Pin 
	ADC_SCLK				: out std_logic := '0';	-- Pin 

	ADC_CLK				: out std_logic;	-- Pin 
	ADC_DCO_LVDS		: in std_logic_vector(1 downto 0);	-- 
	ADC_DCO_LVDS_n		: in std_logic_vector(1 downto 0);	-- 
	ADC_FCO_LVDS		: in std_logic_vector(1 downto 0);	-- 
	ADC_FCO_LVDS_n		: in std_logic_vector(1 downto 0);	-- 
	ADC_DCO_LVDSPrev	: in std_logic_vector(11 downto 0);	-- 
	ADC_DCO_LVDSPrev_n: in std_logic_vector(11 downto 0);	-- 

-- 3. Trig_in-out_FCT

	TrigInLVDS		: in std_logic;	-- Trigger from FC7					<- Pin 
	TrigInLVDS_n	: in std_logic;	-- 										<- Pin 
	FastTrigDes		: out std_logic;	-- Fast trigger desition to EROS/ROESTI	<- Pin
	TrigDes			: out std_logic;	-- Trigger desition to FC7			<- Pin
	TriggerData		: out std_logic_vector(TrigBits-1 downto 0):= (others => '0');	-- Trigger data to FCT

-- 4. Ethernet Phy device ports     LXT972
	RxClk			: in std_logic; --					-> Pin
	Crs			: in std_logic;-- Carrier Sense
	RxDv			: in std_logic;-- Data Valid
	RxD			: in std_logic_vector(3 downto 0); 
--RxEr			: input; -- RxEr not in use!!!! pin...-corner

	TxClk			: in std_logic; --					-> Pin
	TxEn			: out std_logic; --					-> Pin
	TxD			: out std_logic_vector(3 downto 0):= (others => '0'); --					-> Pin
	Col 			: in std_logic; -- Collision_Detect not used	-> Pin

-- 5. 
	ExtReset		: in std_logic;  -- external Reset (tied to GND --VCC)	<- Pin

-- 6. Test
	Test			: out std_logic_vector(9 downto 0):= (others => '0')

	);
end ISERDES_8bit;

architecture Behavioral of ISERDES_8bit is

	--- clocking
	signal Quarts				: std_logic;
	signal FCT40				: std_logic;
	signal ResultClock		: std_logic;	-- Ref.clock for PLL (dedicated)
	signal Resultclock1		: std_logic;
	signal Clock_in			: std_logic;
	signal Clk40				: std_logic;
	signal CLK40_90d			: std_logic;
	signal Clk20				: std_logic;
	signal Clk80				: std_logic;
	signal Clk80_o				: std_logic;
	signal Clk160				: std_logic;
	signal Clk160_o			: std_logic;
	signal Clk320				: std_logic;
	signal FCT160				: std_logic;
	signal Phase				: std_logic;
	signal Clk_Selected		: std_logic := '1';
	signal s_clock_locked	: std_logic;
	---

	--- system
	signal PowerUp0			: std_logic;
	signal PowerUp1_s			: std_logic;
	signal PowerUp1_o			: std_logic;
	signal PowerUp2_s			: std_logic;
	signal PowerUp2_o			: std_logic;
	signal PwrUpReset			: std_logic;
	signal Reset				: std_logic := '0';
	signal o_green_led		: std_logic := '1';
	signal o_blue_led			: std_logic := '1';
	signal o_red_led			: std_logic := '1';
	---

	--- Input ADC Data
	signal DCO		: std_logic;
	signal DCO_O	: std_logic;
	signal FCO		: std_logic;
	signal FCO_O	: std_logic;
	signal SDATA	: std_logic;
	signal shift1	: std_logic; 
	signal shift2	: std_logic;
	signal clkdiv	: std_logic_vector(1 downto 0):= (others => '0');
	signal clkdiv_es: std_logic;
	signal clkdiv_a: std_logic;
	signal clkdiv_b: std_logic;
	signal Data_p	: std_logic := '0';
	signal Data_n	: std_logic := '0';
	signal DataP	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal DataN	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal DataP_del	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal DataN_del	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal DataOut	: std_logic_vector(ADC_Bits-1 downto 0):= (others => '0');
	---
	
	--- Processing Data
	signal InData	: std_logic_vector(ADC_Bits-1 downto 0):= (others => '0');
	signal Sub_Ped	: std_logic_vector(ADC_Bits+1 downto 0):= (others => '0');
	signal Sub_ped_delay	: std_logic_vector(ADC_Bits+1 downto 0):= (others => '0');
	signal AverData: std_logic_vector(ADC_Bits+1 downto 0):= (others => '0');
	signal AverData_med: std_logic_vector(ADC_Bits+1 downto 0):= (others => '0');
	signal GroupValue_Up_LT : std_logic := '0';
	signal GroupLT_Trig : std_logic := '0';
	signal GroupSum : std_logic_vector(ADC_Bits+1 downto 0):= (others => '0');
	signal GroupAmp : std_logic_vector(ADC_Bits+1 downto 0):= (others => '0');
	signal DelayGroupAmp	: std_logic_vector(ADC_Bits+1 downto 0):= (others => '0');
	signal DelayGroupAmp_mid	: std_logic_vector(ADC_Bits+1 downto 0):= (others => '0');
	signal GroupValue_Amp_Done : std_logic := '0';
	signal GroupAmp_Trig : std_logic := '0';

	signal DelayReset			: std_logic_vector (9 downto 0);
	signal AllReset			: std_logic := '0';
	signal ResCnt				: std_logic_vector (10 downto 0);
	signal StopReset			: std_logic := '0';
	---
	
	--- TriggerDes
	signal TrigIn	: std_logic;
	signal TrigDes_o	: std_logic;
	signal FastTrigDes_o	: std_logic;
	signal TrigDelayReset: std_logic_vector (9 downto 0);

	---
	--- ADC SPI interface signals
	signal s_fadc_test		: std_logic := '0'; 
	signal s_fadc_sdio_test	: STD_LOGIC_VECTOR(49 downto 0) := "00000000000011010000110000000000001111111100000001";
											--									  "set	addr		 data			 set	addr		  data "
											--									   3bit	 13bit	 8bit			 3bit	13bit		  8bit
	signal shift_sdio_test	: std_logic;
	
	signal s_fadc_reset		: std_logic := '0'; 
	signal s_fadc_sdio_reset: STD_LOGIC_VECTOR(49 downto 0) := "00000000000011010000000000000000001111111100000001";
	signal shift_sdio_reset	: std_logic;
	
	signal s_fadc_csb			: std_logic := '1';
	signal s_fadc_sdio		: std_logic := '0'; 
	signal s_fadc_sclk		: std_logic := '0';
	
	signal ADC_Bit_write: std_logic := '0'; 
	signal ADC_bit_count: STD_LOGIC_VECTOR(5 downto 0);
	
	signal ADCtest_reg_sset	: std_logic := '1'; 
	signal ADCtest_SDIO_trig: std_logic; 
	signal ADCreset_reg_sset	: std_logic := '1'; 
	signal ADCreset_SDIO_trig: std_logic; 
	signal ADC_CSB_trig	: std_logic := '1'; 
	---

	--- Test
	signal TestCnt	: std_logic_vector(25 downto 0);
	signal test_out: std_logic_vector(31 downto 0);
	signal ImRam	: std_logic_vector(15 downto 0);
	signal EnImRam	: std_logic := '0';
	type   ram_type is array (0 to 127) of std_logic_vector (7 downto 0);
	signal RamData : ram_type:=(X"01", X"40", X"70", X"A0", X"BA", X"B4", X"A6", X"A0", 
									  X"9D", X"8C", X"78", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"02", 
									  X"01", X"02", X"02", X"02", X"02", X"02", X"02", X"00");
	signal rdata : std_logic_vector(7 downto 0);

begin
--=================Inicialization of input LVDS signals=================--
--******** 1a. POWER_UP self-Reset pulse *************************************

	process (Clk40)
	begin
		if(rising_edge(Clk40)) then 
			PowerUp0 <= not ExtReset AND s_clock_locked;
		end if;
	end process;
	
--	PowerUp1_s <= '1' when (PowerUp0= '1' and TestCt(25) = '1' and TestCt(0) = '1') else
--					  '0';
	PowerUp1_s <= (PowerUp0 AND (TestCnt(25) and TestCnt(0)));
	PowerUp1 : entity work.SRFF 
		port map (
			S		=> PowerUp1_s,
			CLK	=> Clk40,
			R		=> ExtReset,
			q		=> PowerUp1_o
		);
	PowerUp2_s <= (PowerUp1_o AND TestCnt(2));
	PowerUp2 : entity work.SRFF 
		port map (
			S		=> PowerUp2_s,
			CLK	=> Clk40,
			R		=> ExtReset,
			q		=> PowerUp2_o
		);

	PwrUpReset <= PowerUp1_o AND not PowerUp2_o;   -- ONE pulse ~1sec after powering up

--******** 1. Reference clock's & Frequency Control ********--
BUFG_inst : IBUFG
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE"   
		IOSTANDARD => "DEFAULT")
	port map (
		O => Quarts,     -- Clock buffer output
		I => Qclock      -- Clock buffer input
	);

LVDS_Clk40 : IBUFG
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		IOSTANDARD => "DEFAULT")
	port map (
		O => FCT40,  -- Clock buffer output
		I => FCT_40  -- Diff_p clock buffer input
	);

LVDS_FCT_160 : IBUFGDS
	generic map (
		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
		DIFF_TERM => TRUE, -- Differential Termination 
		IOSTANDARD => "DEFAULT")
	port map (
		O => FCT160,		-- Buffer output
		I => FCT_160,	-- Diff_p buffer input (connect directly to top-level port)
		IB => FCT_160_n	-- Diff_n buffer input (connect directly to top-level port)
	);
	

--**************** Automatic Clock Switch for PLL reference ******************

PhaseSwitch: entity work.PhaseSW 
	generic map(
				Fmax				=> 42000, -- Upper limit in kHz
				Fmin				=> 38000, -- Lower limit in kHz
				RefClock			=> 40000  -- Local Quartz Freq(kHz) used as the reference
				)
	port map ( Clock				=> Quarts,--Qclock,--
				  SysClk				=> FCT40,--FCT_40,
				  Reset				=> Reset,
				  Phase				=> Phase,
				  SysClk_Selected	=> Clk_Selected--Test(9)
				);

--	ResultClock <= ((FCT_40 and Clk_Selected) OR (Qclock and not Clk_Selected));

--Clk_Selected <= '0';

Sw_FCTClk <= Clk_Selected;
Sw_Quartz <= not Clk_Selected;

--process (Quarts)
--begin
--	if rising_edge(Quarts) then
--		if Clk_Selected = '1' then ResultClock <= FCT40;
--									 else ResultClock <= Quarts;
--		end if;
--	end if;
--end process;

--ClockSwitch : BUFGCTRL
--	generic map (
--		INIT_OUT => 0,         -- Inital value of 0 or 1 after configuration
--		PRESELECT_I0 => TRUE, -- TRUE/FALSE set the I0 input after configuration
--		PRESELECT_I1 => FALSE) -- TRUE/FALSE set the I1 input after configuration
--	port map (
--		O => ResultClock,              -- Clock MUX output
--		CE0 => '1',          -- Clock enable0 input
--		CE1 => '1',          -- Clock enable1 input
--		I0 => Quarts,            -- Clock0 input
--		I1 => FCT40,            -- Clock1 input
--		IGNORE0 => '1',  -- Ignore clock select0 input
--		IGNORE1 => '1',  -- Ignore clock select1 input
--		S0 => not ResultClock1,            -- Clock select0 input
--		S1 => ResultClock1             -- Clock select1 input
--	);

ResultClock1 <= '0';
--
	ResultClock <= ((FCT40 and ResultClock1) OR (Quarts and not ResultClock1));

DLL: entity work.DLL_test
	port map (
		CLK0_OUT => Clk40,					-- 0 degree DCM CLK output
		CLKDV_OUT => Clk20,					-- 0 degree DCM CLK output
		CLK2X_OUT => Clk80,				-- 2X DCM CLK output
		CLK90_OUT => Clk40_90d,			-- 90 degree DCM CLK output
		CLKFX_OUT => Clk160,				-- DCM CLK synthesis out (M/D)
		LOCKED_OUT => s_clock_locked,	-- DCM LOCK status output
		CLKIN_IN => ResultClock,			-- Clock input (from IBUFG, BUFG or DCM)
		RST_IN => Reset					-- DCM asynchronous reset input
	);

--	Global_clk80: BUFG
--	port map (
--		O => Clk80,     -- Clock buffer output
--		I => Clk80_o      -- Clock buffer input
--	);
--
--	Global_clk160: BUFG
--	port map (
--		O => Clk160,     -- Clock buffer output
--		I => Clk160_o      -- Clock buffer input
--	);

--******** LED ********--
--	process(Clk80)
--	begin
--		if rising_edge(Clk80) then
--			if ((TestCnt(23)='1' and s_clock_locked = '1' and Clk_Selected = '1') or (s_clock_locked = '1' and Clk_Selected = '0')) then LED1 <= '1';
--																																											else LED1 <= '0';
--			end if;
--		end if;
--	end process;
	o_green_led <= '0' when ((TestCnt(24)='1' and s_clock_locked = '1' and Clk_Selected = '0') or (s_clock_locked = '1' and Clk_Selected = '1'))else
						'1';
	Led_B : entity work.Light_Pulser 
		generic map ( DIV	=> 1000,
						  DUR	=> 10000)
		port map( 
					 clock => CLK80,
					 i_event => FastTrigDes_o,
					 o_flash => o_blue_led
					);

--	Led_R : entity work.Light_Pulser 
--		generic map ( DIV	=> 1000,
--						  DUR	=> 10000)
--		port map( 
--					 clock => CLK80,
--					 i_event => not s_clock_locked,
--					 o_flash => o_red_led
--					);

	o_red_led <= '0' when ((s_clock_locked = '0') OR (TestCnt(24)='1' and Clk_Selected = '0')) else
					 '1';

	LED1 <= o_green_led;
	LED2 <= not o_blue_led;
	LED3 <= o_red_led;

	LED4 <= '1' when TestCnt(22)='1' else
				'0' when TestCnt(22)='0' else
				'0';
	LED5 <= '1' when TestCnt(24)='1' else
				'0' when TestCnt(24)='0' else
				'0';
--********

-- Input LVDS ADC buffer
	DCO_LVDS_signal : IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => DCO,  -- Buffer output
			I => ADC_DCO_LVDS(0),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADC_DCO_LVDS_n(0) -- Diff_n buffer input (connect directly to top-level port)
		);

	FCO_LVDS_signal : IBUFGDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => FCO,  -- Buffer output
			I => ADC_FCO_LVDS(0),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADC_FCO_LVDS_n(0) -- Diff_n buffer input (connect directly to top-level port)
		);

	Data_LVDS_signal : IBUFDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => SDATA,  -- Buffer output
			I => ADCInDataLVDS(4),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADCInDataLVDS_n(4) -- Diff_n buffer input (connect directly to top-level port)
		);

	IDDR_inst : IDDR 
	generic map (
		DDR_CLK_EDGE => "SAME_EDGE_PIPELINED", -- "OPPOSITE_EDGE", "SAME_EDGE" 
													-- or "SAME_EDGE_PIPELINED" 
		INIT_Q1 => '0', -- Initial value of Q1: '0' or '1'
		INIT_Q2 => '0', -- Initial value of Q2: '0' or '1'
		SRTYPE => "SYNC") -- Set/Reset type: "SYNC" or "ASYNC" 
	port map (
		Q1 => Data_p,	-- 1-bit output for positive edge of clock 
		Q2 => Data_n,	-- 1-bit output for negative edge of clock
		C => DCO,		-- Clk320,--		-- 1-bit clock input
		CE => '1',		-- 1-bit clock enable input
		D => SDATA,		-- 1-bit DDR data input
		R => Reset,		-- 1-bit reset
		S => '0'			-- 1-bit set
	);

	DDR_P_null: process(DCO)
	begin
		if(rising_edge(DCO)) then
			if Reset ='1' then 
				DataP(0) <= '0';
			else 
				DataP(0) <= Data_p;
			end if;
		end if;
	end process;

	DDR_N_null: process(DCO)
	begin
		if(rising_edge(DCO)) then
			if Reset ='1' then 
				DataN(0) <= '0';
			else 
				DataN(0) <= Data_n;
			end if;
		end if;
	end process;

	DDR_Reg_P: for i in 0 to 2 generate
		DDR_Reg_pos: process(DCO)
		begin
			if(rising_edge(DCO)) then
				if Reset ='1' then 
					DataP(i+1) <= '0';
				else 
					DataP(i+1) <= DataP(i);
				end if;
			end if;
		end process DDR_Reg_pos;
	end generate;

	DDR_Reg_N: for i in 0 to 2 generate
		DDR_Reg_neg: process(DCO)
		begin
			if(rising_edge(DCO)) then
				if Reset ='1' then 
					DataN(i+1) <= '0';
				else 
					DataN(i+1) <= DataN(i);
				end if;
			end if;
		end process DDR_Reg_neg;
	end generate;
	

	DDR_Reg_P_del: for i in 0 to 3 generate
		DDR_Reg_pos: process(DCO)
		begin
			if(rising_edge(DCO)) then
--				if clkdiv_es = '1' then
					DataP_del(i) <= DataP(i);
--				end if;
			end if;
		end process DDR_Reg_pos;
	end generate;

	DDR_Reg_N_del: for i in 0 to 3 generate
		DDR_Reg_neg: process(DCO)
		begin
			if(rising_edge(DCO)) then
--				if clkdiv_es = '1' then
					DataN_del(i) <= DataN(i);
--				end if;
			end if;
		end process DDR_Reg_neg;
	end generate;

	adc_data: process(FCO)
	begin
		if(rising_edge(FCO)) then
--			if clkdiv_es = '1' then
--				DataOut(2*i) <= DataP(i);
--				DataOut(2*i+1) <= DataN(i);
				DataOut(0) <= DataN_del(0);
				DataOut(1) <= DataP_del(0);
				DataOut(2) <= DataN_del(1);
				DataOut(3) <= DataP_del(1);
				DataOut(4) <= DataN_del(2);
				DataOut(5) <= DataP_del(2);
				DataOut(6) <= DataN_del(3);
				DataOut(7) <= DataP_del(3);
--				DataOut(0) <= DataN(2);
--				DataOut(1) <= DataP(2);
--				DataOut(2) <= DataN(3);
--				DataOut(3) <= DataP(3);
--				DataOut(4) <= DataN(0);
--				DataOut(5) <= DataP(0);
--				DataOut(6) <= DataN(1);
--				DataOut(7) <= DataP(1);
--			end if;
		end if;
	end process adc_data;
	
--	process (Clk80)
--	begin 
--		if (rising_edge(Clk80)) then
--			if (DataOut >= "10000000") then 
--				FastTrigDes_o <= '1';
--			else FastTrigDes_o <= '0';
--			end if;
--		end if;
--	end process;
--	

--	TestRam : entity work.TestRam 
--	generic map(
--				WIDTH =>8,
--				Size => 255)
--	port map (
--				CLK 	=> Clk80,
--				en		=> EnImRam,--'1',
--				Load	=> '1',
--				ADDR	=> TestCnt(7 downto 0),
--				we		=> '0',
--				DI		=> (others => '0'),
--				DO		=> ImRam
--				);
	
	process (Clk80)
	begin 
		if (rising_edge(Clk80)) then
			if (TestCnt(15 downto 7) = X"1FF") then 
				EnImRam <= '1';
			else EnImRam <= '0';
			end if;
		end if;
	end process;

	process (Clk80)
		begin
		if Clk80'event and Clk80 = '1' then
			if EnImRam = '1' then
				rdata <= RamData(conv_integer(TestCnt(6 downto 0)));
			end if;
		end if;
	end process;
	
	InData <= rdata(7 downto 0);--DataOut;--

-- Processing Input ADC data

	ThreshData: process (Clk160)
	begin 
		if (rising_edge(Clk160)) then
			if AllReset = '1' then
				Sub_ped_delay <= (others => '0');
				AverData_med <= (others => '0');
				AverData <= (others => '0');
				GroupValue_Up_LT <= '0';
			else
				Sub_ped(7 downto 0) <= DataOut;-- InData;-- - Piedistal_def;
				Sub_ped_delay <= Sub_ped; 
				AverData_med <= (Sub_ped_delay + Sub_ped);
				AverData(7 downto 0) <= AverData_med(8 downto 1);
				if (AverData >= ThresholdData_0) then GroupValue_Up_LT <= '1';
															else GroupValue_Up_LT <= '0';
				end if;
			end if;
		end if;
	end process;
	
	LT_Trig: entity work.SRFF 
		port map (
			S		=> GroupValue_Up_LT,
			CLK	=> Clk160,
			R		=> AllReset,
			q		=> GroupLT_Trig
		);
	
	AmpData: process (Clk160)
	begin 
		if (rising_edge(Clk160)) then
			if AllReset = '1' then
				DelayGroupAmp_mid <= (others => '0');
				DelayGroupAmp <= (others => '0');
				GroupSum <= (others => '0');
				GroupValue_Amp_Done <='0';
			else
				GroupSum <= AverData + AverData + AverData + AverData;
				DelayGroupAmp_mid <= GroupSum; 
				DelayGroupAmp <= DelayGroupAmp_mid; 
				if ((DelayGroupAmp_mid > GroupSum) and (GroupLT_Trig = '1')) then GroupValue_Amp_Done <= '1';
																								 else GroupValue_Amp_Done <= '0';
				end if;
			end if;
		end if;
	end process;
	
	Amp_Trig: entity work.SRFF 
	port map (
		S		=> GroupValue_Amp_Done,
		CLK	=> Clk160,
		R		=> AllReset,
		q		=> GroupAmp_Trig
	);
	
	GrAmp: process (Clk160)
	begin 
		if (rising_edge(Clk160)) then
			if AllReset = '1' then
				GroupAmp <= (others => '0');
			elsif (GroupLT_Trig = '1' and GroupAmp_Trig = '0') then 
				GroupAmp <= DelayGroupAmp;
			end if;
		end if;
	end process;
	
	TriggerDes: process (Clk160)
	begin 
		if (rising_edge(Clk160)) then
			if AllReset = '1' then 
				FastTrigDes_o <= '0';
			elsif (GroupLT_Trig = '1') then FastTrigDes_o <= '1';
												else FastTrigDes_o <= '0';
			end if;
			if AllReset = '1' then 
				TrigDes_o <= '0';
			elsif (GroupAmp_Trig = '1') then TrigDes_o <= '1';
											 else TrigDes_o <= '0';
			end if;
		end if;
	end process;
	
	FastTrig: process (Clk80)
	begin 
		if (rising_edge(Clk80)) then
			TrigDelayReset(0) <= FastTrigDes_o;
			TrigDelayReset(1) <= TrigDelayReset(0);
			TrigDelayReset(2) <= TrigDelayReset(1);
			TrigDelayReset(3) <= TrigDelayReset(2);
			TrigDelayReset(4) <= TrigDelayReset(3);
			TrigDelayReset(5) <= TrigDelayReset(4);
			TrigDelayReset(6) <= TrigDelayReset(5);
			TrigDelayReset(7) <= TrigDelayReset(6);
			TrigDelayReset(8) <= TrigDelayReset(7);
			TrigDelayReset(9) <= TrigDelayReset(8);
		end if;
	end process;

	FastTrigDes <= FastTrigDes_o;--TrigDelayReset(9);--
	TrigDes <= TrigDes_o;
	
	TrigData: process (Clk40)
	begin 
		if (rising_edge(Clk40)) then
			if (FastTrigDes_o = '1') then 
				TriggerData(9 downto 0) <= GroupAmp;
				TriggerData(13 downto 10) <= b"0100";
				TriggerData(14) <= FastTrigDes_o;
				TriggerData(15) <= TrigDes_o;
				TriggerData(19 downto 16) <= (b"1010");
				TriggerData(63 downto 20) <= (others => '0');
			else TriggerData(63 downto 0) <= (others => '0');
			end if;
		end if;
	end process;
	
	ResetAll: process (Clk80)
	begin 
		if (rising_edge(Clk80)) then
			if ((GroupLT_Trig = '1') and (GroupAmp_Trig = '1') ) then
				DelayReset(0) <= '1';
				else DelayReset(0) <= '0';
			end if;
			DelayReset(1) <= DelayReset(0);
			DelayReset(2) <= DelayReset(1);
			DelayReset(3) <= DelayReset(2);
			DelayReset(4) <= DelayReset(3);
			DelayReset(5) <= DelayReset(4);
--			DelayReset(6) <= DelayReset(5);
--			DelayReset(7) <= DelayReset(6);
--			DelayReset(8) <= DelayReset(7);
--			DelayReset(9) <= DelayReset(8);
		end if;
	end process;

	Reset_Trig: entity work.SRFF 
	port map (
		S		=> DelayReset(5),
		CLK	=> Clk80,
		R		=> StopReset,
		q		=> AllReset
	);

	ResetCnt: entity work.V_Counter 
	generic map(
				WIDTH => 11
			)
	port map (
				clock 	=> clk80,--Quarts,--CLK40,
				clk_en	=>	AllReset,
				q			=> ResCnt
				);

	StopResetAll: process (Clk80)
	begin 
		if (rising_edge(Clk80)) then
			if (ResCnt = X"7FF") then
				StopReset <= '1';
			else 
				StopReset <= '0';
			end if;
		end if;
	end process;


-- ADC Configuration

	s_fadc_test <='1';
	s_fadc_reset <='0';

	ADC_CLK <= CLK80;

	ADC_Cnt : entity work.V_Counter 
	generic map(
				WIDTH => 6
			)
	port map (
				clock 	=> Clk20,
				clk_en	=> ADC_Bit_write,
				sclr		=> PwrUpReset,
				q			=> ADC_bit_count
				);

	ShiftReg_test : entity work.ShiftReg 
		generic map (WIDTH => 50) 
		port map(clock	=> clk20,
				d		=> s_fadc_sdio_test,
				sset	=> ADCtest_reg_sset,
				q		=> ADCtest_SDIO_trig
		);
	ShiftReg_reset : entity work.ShiftReg 
		generic map (WIDTH => 50) 
		port map(clock	=> clk20,
				d		=> s_fadc_sdio_reset,
				sset	=> ADCreset_reg_sset,
				q		=> ADCreset_SDIO_trig
		);

--	ADC_prog: process (Clk20)
--	begin
--		if rising_edge(Clk20) then
----			if (s_fadc_test = '1') then 
----				if (ADC_bit_count < "110100") Then ADC_Bit_write <= '1';
----														Else ADC_Bit_write <= '0';
----				end if;
----				IF ((ADC_bit_count >= "000001") AND (ADC_bit_count < "110100")) Then ADCtest_reg_sset <= '0';
----																									 ADC_SDIO <= ADCtest_SDIO_trig;--'0';--
----																									 Else ADCtest_reg_sset <= '1';
----																									 ADC_SDIO <= '0';
----				END IF;
----				IF (((ADC_bit_count >= "000010") AND (ADC_bit_count < "11010")) OR ((ADC_bit_count >= "11100") AND (ADC_bit_count < "110100")))Then 
----					ADC_CSB_trig <= '0';
----				ELSE 
----					ADC_CSB_trig <= '1';
----				END IF;
----				ADC_CSB <= ADC_CSB_trig;
----			elsif (s_fadc_reset = '1') then 
----				if (ADC_bit_count < "110100") Then ADC_Bit_write <= '1';
----														Else ADC_Bit_write <= '0';
----				end if;
----				IF ((ADC_bit_count >= "000001") AND (ADC_bit_count < "110100")) Then ADCreset_reg_sset <= '0';
----																									 ADC_SDIO <= ADCreset_SDIO_trig;--'0';--
----																									 Else ADCreset_reg_sset <= '1';
----																									 ADC_SDIO <= '0';
----				END IF;
----				IF (((ADC_bit_count >= "000010") AND (ADC_bit_count < "11010")) OR ((ADC_bit_count >= "11100") AND (ADC_bit_count < "110100")))Then 
----					ADC_CSB_trig <= '0';
----				ELSE 
----					ADC_CSB_trig <= '1';
----				END IF;
----				ADC_CSB <= ADC_CSB_trig;
----			else 
----				ADC_CSB <= '1';
----			end if;
--
--			if (ADC_bit_count < "110100") Then ADC_Bit_write <= '1';
--													Else ADC_Bit_write <= '0';
--			end if;
--			IF ((ADC_bit_count >= "000001") AND (ADC_bit_count < "110100")) Then ADCtest_reg_sset <= '0';
--																								 ADC_SDIO <= ADCreset_SDIO_trig;--ADCtest_SDIO_trig;--'0';--
--																								 Else ADCtest_reg_sset <= '1';
--																								 ADC_SDIO <= '0';
--			END IF;
--			IF (((ADC_bit_count >= "000010") AND (ADC_bit_count < "11010")) OR ((ADC_bit_count >= "11100") AND (ADC_bit_count < "110100")))Then 
--				ADC_CSB_trig <= '0';
--			ELSE 
--				ADC_CSB_trig <= '1';
--			END IF;
--		end if;
--	end process;
--
--	ADC_CSB <= ADC_CSB_trig;-- '1';--
--	ADC_SCLK <= Clk20;

--******** Test part ********--

	CntTest : entity work.V_Counter 
	generic map(
				WIDTH => 26
			)
	port map (
				clock 	=> clk40,--clk80,--CLK40,
				clk_en	=>	'1',
				q			=> TestCnt
				);

--   OBUF_inst : OBUF
--   generic map (
--      CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
--      DRIVE => 12,
--      IOSTANDARD => "DEFAULT",
--      SLEW => "SLOW")
--   port map (
--      O => DCO_O,     -- Buffer output (connect directly to top-level port)
--      I => DCO      -- Buffer input 
--   );

	Test(0) <= DataOut(0);
	Test(1) <= DataOut(1);
	Test(2) <= DataOut(2);
	Test(3) <= FCT40;--DataOut(3);
	Test(4) <= Quarts;--DataOut(4);
	Test(5) <= Clk_Selected;--DataOut(5);
	Test(6) <= ResultClock;--DataOut(6);
	Test(7) <= ResultClock1;--DataOut(7);
	Test(8) <= s_clock_locked;
	Test(9) <= Clk40;

end Behavioral;
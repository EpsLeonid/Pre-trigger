----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:04 08/15/2018 
-- Design Name: 
-- Module Name:    ISERDES_8bit - Behavioral 
-- Project Name: 
-- Target Devices: 
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
	FCT_40		: in std_logic; -- system clock
	FCT_160		: in std_logic; -- clock
	FCT_160_n	: in std_logic; -- clock
-- In Trigger module Link's Clock is checked inside Altera but switched outside 
	Sw_Quartz	: out std_logic;	-- connects Quartz to PLL ref.Input			-> Pin 
	Sw_FCTClk	: out std_logic;	-- connects Link's Clock to PLL ref.Input	-> Pin 

	MuxClock_in		: in std_logic;	-- Ref.clock for PLL (dedicated)			<- Pin 

-- Outputs for Indicators on LED's

	Led1			: out std_logic;	-- drives the Green LED								-> Pin 
	Led2			: out std_logic := '0';	-- drives the Blue LED						-> Pin 
	Led3			: out std_logic := '0';	-- drives the Red LED						-> Pin 
	Led4			: out std_logic := '0';	-- drives the Blue(Yellow) LED			-> Pin 
	Led5			: out std_logic := '0';	-- drives the Blue(Yellow) LED			-> Pin 

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
	signal Clock_in			: std_logic;
	signal Clk40				: std_logic;
	signal CLK40_90d			: std_logic;
	signal Clk20				: std_logic;
	signal Clk80				: std_logic;
	signal Clk160				: std_logic;
	signal FCT160				: std_logic;
	signal Phase				: std_logic;
	signal Clk_Selected		: std_logic := '0';
	signal s_clock_locked	: std_logic := '0';
	---

	--- system
	signal PowerUp0			: std_logic;
	signal PowerUp1_s			: std_logic;
	signal PowerUp1_o			: std_logic;
	signal PowerUp2_s			: std_logic;
	signal PowerUp2_o			: std_logic;
	signal PwrUpReset			: std_logic;
	signal Reset				: std_logic := '0';
	---

	signal DCO		: std_logic;
	signal DCO_O	: std_logic;
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
	
	signal DataOut	: std_logic_vector(ADC_Bits-1 downto 0):= (others => '0');
	
	--- TriggerDes
	signal TrigIn	: std_logic;
	signal TrigDes_o	: std_logic;
	signal FastTrigDes_o	: std_logic;

	--- ADC SPI interface signals
	signal s_fadc_test		: std_logic := '0'; 
	signal s_fadc_sdio_test	: STD_LOGIC_VECTOR(49 downto 0) := "00000000000011010000101000000000001111111100000001";
											--									  "set	addr		 data			 set	addr		  data "
											--									   3bit	 13bit	 8bit			 3bit	13bit		  8bit
	signal shift_sdio_test	: std_logic;
	
	signal s_fadc_reset		: std_logic := '0'; 
	signal s_fadc_sdio_reset: STD_LOGIC_VECTOR(49 downto 0) := "00000000000011010000000000000000001111111100000001";
	signal shift_sdio_reset	: std_logic;
	
	signal ADCtest_Bit_write: std_logic := '0'; 
	signal ADCtest_reg_sset	: std_logic := '1'; 
	signal ADCtest_SDIO_trig: std_logic; 
	signal ADCtest_CSB_trig	: std_logic; 
	
	signal ADCtest_bit_count: STD_LOGIC_VECTOR(5 downto 0);
	
	signal s_fadc_csb			: std_logic := '1';
	signal s_fadc_sdio		: std_logic := '0'; 
	signal s_fadc_sclk		: std_logic := '0';

	--- Test
	signal TestCnt	: std_logic_vector(25 downto 0);
	signal test_out: std_logic_vector(31 downto 0);

begin
--=================Inicialization of input LVDS signals=================--
--******** 1a. POWER_UP self-Reset pulse *************************************

	process (Clk40)
	begin
		if Clk40'event and Clk40='1' then  
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
	port map ( Clock				=> Quarts,
				  SysClk				=> FCT40,
				  Reset				=> Reset,
				  Phase				=> Phase,
				  SysClk_Selected	=> Clk_Selected
				);
Sw_FCTClk <= Clk_Selected;
Sw_Quartz <= not Clk_Selected;

--ClockIn_BUF : IBUFG
--	generic map (
--		CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE"   
--		IOSTANDARD => "DEFAULT")
--	port map (
--		O => Clock_in,     -- Clock buffer output
--		I => MuxClock_in      -- Clock buffer input
--	);

DLL: entity work.DLL
	port map (
		CLK0_OUT => Clk40,					-- 0 degree DCM CLK output
		CLKDV_OUT => Clk20,					-- 0 degree DCM CLK output
		CLK2X_OUT => Clk80,				-- 2X DCM CLK output
		CLK90_OUT => Clk40_90d,			-- 90 degree DCM CLK output
		CLKFX_OUT => Clk160,				-- DCM CLK synthesis out (M/D)
		LOCKED_OUT => s_clock_locked,	-- DCM LOCK status output
		CLKIN_IN => MuxClock_in,			-- Clock input (from IBUFG, BUFG or DCM)
		RST_IN => Reset					-- DCM asynchronous reset input
	);

--******** LED ********--
--	process(Clk80)
--	begin
--		if rising_edge(Clk80) then
--			if ((TestCnt(23)='1' and s_clock_locked = '1' and Clk_Selected = '1') or (s_clock_locked = '1' and Clk_Selected = '0')) then LED1 <= '1';
--																																											else LED1 <= '0';
--			end if;
--		end if;
--	end process;
	LED1 <= '1' when ((TestCnt(23)='1' and s_clock_locked = '1' and Clk_Selected = '0') or (s_clock_locked = '1' and Clk_Selected = '1'))else
				'0';
	Led_B : entity work.Light_Pulser 
		generic map ( DIV	=> 2,
						  DUR	=> 100)
		port map( 
					 clock => CLK80,
					 i_event => FastTrigDes_o,
					 o_flash => LED2
					);

	LED3 <= '1' when TestCnt(23)='1' else
				'0' when TestCnt(23)='0' else
				'0';
	LED4 <= '1' when TestCnt(21)='1' else
				'0' when TestCnt(21)='0' else
				'0';
	LED5 <= '1' when TestCnt(23)='1' else
				'0' when TestCnt(23)='0' else
				'0';
--********

-- Input LVDS ADC DCO buffer
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

	Data_LVDS_signal : IBUFDS
		generic map (
			CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
			DIFF_TERM => TRUE, -- Differential Termination 
			IOSTANDARD => "DEFAULT")
		port map (
			O => SDATA,  -- Buffer output
			I => ADCInDataLVDS(0),  -- Diff_p buffer input (connect directly to top-level port)
			IB => ADCInDataLVDS_n(0) -- Diff_n buffer input (connect directly to top-level port)
		);

	IDDR_inst : IDDR 
	generic map (
		DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE", "SAME_EDGE" 
													-- or "SAME_EDGE_PIPELINED" 
		INIT_Q1 => '0', -- Initial value of Q1: '0' or '1'
		INIT_Q2 => '0', -- Initial value of Q2: '0' or '1'
		SRTYPE => "SYNC") -- Set/Reset type: "SYNC" or "ASYNC" 
	port map (
		Q1 => Data_p,	-- 1-bit output for positive edge of clock 
		Q2 => Data_n,	-- 1-bit output for negative edge of clock
		C => DCO,		-- 1-bit clock input
		CE => '1',		-- 1-bit clock enable input
		D => SDATA,	-- 1-bit DDR data input
		R => Reset,		-- 1-bit reset
		S => '0'			-- 1-bit set
	);

	DDR_Reg: process(DCO)
	begin
		if(rising_edge(DCO)) then
			if Reset ='1' then 
				DataP(0) <= '0';
				DataN(0) <= '0';
			else 
				DataP(0) <= Data_p;
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
	
--	DivClk : entity work.ClkDiv
--	port map (
--				i_clk => Clock,	-- input of data clock from ADC 
--				o_clk	=> clkdiv	-- output of data clock divided by 4 and delay to 3125 ps (frame clock)
--				);
	
--	Clk_Div <= clkdiv(1);
	
	Clk_div_es: process(DCO)
		begin
			if(rising_edge(DCO)) then
				clkdiv <= clkdiv + '1';
				clkdiv_a <= clkdiv(1);
				clkdiv_b <= clkdiv_a;
				if clkdiv_a = '1' and clkdiv_b = '0' then
					clkdiv_es <= '1';
				else clkdiv_es <= '0';
				end if;
			end if;
		end process Clk_div_es;
	
--	clkdiv_es <= '1' when (clkdiv_1='1' and clkdiv_2='0') else
--					 '0';
	
--	Reg: for i in 0 to 3 generate
		adc_data: process(DCO)
		begin
			if(rising_edge(DCO)) then
				if clkdiv_es = '1' then
--				DataOut(2*i) <= DataP(i);
--				DataOut(2*i+1) <= DataN(i);
					DataOut(0) <= DataP(0);
					DataOut(1) <= DataN(0);
					DataOut(2) <= DataP(1);
					DataOut(3) <= DataN(1);
					DataOut(4) <= DataP(2);
					DataOut(5) <= DataN(2);
					DataOut(6) <= DataP(3);
					DataOut(7) <= DataN(3);
				end if;
			end if;
		end process adc_data;
--	end generate;

	ADC_CLK <= CLK80;

	ADCTest : entity work.V_Counter 
	generic map(
				WIDTH => 6
			)
	port map (
				clock 	=> Clk20,
				clk_en	=> ADCtest_Bit_write,
				sclr		=> PwrUpReset,
				q			=> ADCtest_bit_count
				);

	process (Clk20)
	begin
		if rising_edge(Clk20) then
			if (ADCtest_bit_count < "110100") Then ADCtest_Bit_write <= '1';
															Else ADCtest_Bit_write <= '0';
			end if;
			IF ((ADCtest_bit_count >= "000001") AND (ADCtest_bit_count < "110100")) Then ADCtest_reg_sset <= '0';
																												  ADC_SDIO <= ADCtest_SDIO_trig;
																											Else ADCtest_reg_sset <= '1';
																												  ADC_SDIO <= '0';
			END IF;
			IF (((ADCtest_bit_count >= "000010") AND (ADCtest_bit_count < "11010")) OR ((ADCtest_bit_count >= "11100") AND (ADCtest_bit_count < "110100")))Then 
				ADCtest_CSB_trig <= '0';
			ELSE 
				ADCtest_CSB_trig <= '1';
			END IF;
		end if;
	end process;
	
--	signal s_fadc_sdio_test	: STD_LOGIC_VECTOR(49 downto 0) := "000000000000110100001100 00 000000001111111100000001";
--											--									  "set	addr		 data			 set	addr		  data "
--											--									   3bit	 13bit	 8bit			 3bit	13bit		  8bit

	ADC_CSB <= ADCtest_CSB_trig;
	ADC_SCLK <= Clk20;

	ShiftReg_test : entity work.ShiftReg 
		generic map (WIDTH => 50) 
		port map(clock	=> clk20,
				d		=> s_fadc_sdio_test,
				sset	=> ADCtest_reg_sset,
				q		=> ADCtest_SDIO_trig
		);

--******** Test part ********--

	CntTest : entity work.V_Counter 
	generic map(
				WIDTH => 26
			)
	port map (
				clock 	=> Quarts,--CLK40,
				clk_en	=>	'1',
				q			=> TestCnt
				);

   OBUF_inst : OBUF
   generic map (
      CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" 
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O => DCO_O,     -- Buffer output (connect directly to top-level port)
      I => DCO      -- Buffer input 
   );

	Test(0) <= DataOut(0);
	Test(1) <= DataOut(1);
	Test(2) <= DataOut(2);
	Test(3) <= DataOut(3);
	Test(4) <= DataOut(4);
	Test(5) <= DataOut(5);
	Test(6) <= DataOut(6);
	Test(7) <= DataOut(7);
	Test(8) <= DCO_O;
	Test(9) <= clkdiv_es;

end Behavioral;


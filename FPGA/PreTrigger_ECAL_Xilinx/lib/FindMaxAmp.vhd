----------------------------------------------------------------------------------
-- Company: BINP
-- Engineer: Epshteyn Leonid
-- 
-- Create Date:    09:45:30 04/19/2018 
-- Design Name: 
-- Module Name:    FindMaxAmp - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: v.1.0
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.parameters.all;

entity FindMaxAmp is
	Port ( In_Data				: in	array_adc;
			 In_DataPrev		: in	array_prev_adc;
			 RegInit 			: in	STD_LOGIC;
			 MaxAmp 				: out	STD_LOGIC_VECTOR (Sum_Bits-1 downto 0);
			 MaxCellNumber 	: out STD_LOGIC_VECTOR (BitNumGroup downto 0);
			 ThrNum1 			: out STD_LOGIC_VECTOR (3 downto 0);
			 ThrNum2 			: out STD_LOGIC_VECTOR (3 downto 0);
			 ThrNum3 			: out	STD_LOGIC_VECTOR (3 downto 0);
			 ThrNum4 			: out	STD_LOGIC_VECTOR (3 downto 0);
			 ThrNum5 			: out	STD_LOGIC_VECTOR (3 downto 0);
			 FastTrig 			: out	STD_LOGIC;
			 Trig 				: out	STD_LOGIC;
			 SaveTrigData		: out	STD_LOGIC;

			 Clock 				: in	STD_LOGIC;
			 Clock160 			: in	STD_LOGIC;

			 Reset 				: in  STD_LOGIC;
			 ResetAll			: out STD_LOGIC;
			 Error 				: out	STD_LOGIC;

			 test 				: out	STD_LOGIC_VECTOR (15 downto 0));
end FindMaxAmp;

architecture Behavioral of FindMaxAmp is

	signal Ped_ch			: array_adc;
	signal Sub_ped			: array_adc;
	signal Sub_ped_delay	: array_adc;
	signal Aver2			: array_adc;
	signal GroupSum		: array_group_sum;

	signal GroupValue_Up_LT		: STD_LOGIC_VECTOR (NumGroup-1 downto 0):= (others => '0'); -- flag exceeding (overpass) the lower threshold
	signal GroupValue_Up_MT		: STD_LOGIC_VECTOR (NumGroup-1 downto 0):= (others => '0'); -- flag exceeding (overpass) the middle threshold
	signal GroupValue_Up_HT		: STD_LOGIC_VECTOR (NumGroup-1 downto 0):= (others => '0'); -- flag exceeding (overpass) the high threshold
	signal GroupValue_Amp_Done	: STD_LOGIC_VECTOR (NumGroup-1 downto 0):= (others => '0'); -- flag that the amplitude in channels was finded

	signal GroupLT_Trig		: STD_LOGIC_VECTOR (NumGroup-1 downto 0):= (others => '0'); -- ???? ??????????? ??????? ??????
	signal GroupMT_Trig		: STD_LOGIC_VECTOR (NumGroup-1 downto 0):= (others => '0'); -- ???? ??????????? ???????? ??????
	signal GroupHT_Trig		: STD_LOGIC_VECTOR (NumGroup-1 downto 0):= (others => '0'); -- ???? ??????????? ???????? ??????
	signal GroupAmp_Trig		: STD_LOGIC_VECTOR (NumGroup-1 downto 0):= (others => '0'); -- ???? ??????????? ?????????
	
	signal FastTrig_o			: STD_LOGIC;
	signal Trig_o				: STD_LOGIC;
	
	signal GroupAmp			: array_group_sum;-- := (others => '0');
	signal DelayGroupAmp		: array_group_sum;-- := (others => '0');

	signal GroupChAmps		: array_group_amp;-- := (others => '0');
	signal GroupChNum			: array_group_num;-- := (others => '0');

	signal NSampleCt			: STD_LOGIC_VECTOR (15 downto 0);
	signal NSampleCt_en		: STD_LOGIC;
	signal AllReset			: STD_LOGIC;
	signal AllReset_S			: STD_LOGIC;
	signal Inhibit				: STD_LOGIC;
	signal TimeOutSch			: STD_LOGIC;
	signal TimeOut				: STD_LOGIC;
	signal ENDCycle			: STD_LOGIC; -- флаг окончание работы цикла
	signal ENDthrFound		: STD_LOGIC;
	signal DelayENDCycle		: STD_LOGIC_VECTOR (9 downto 0);
	signal DelayReset			: STD_LOGIC_VECTOR (9 downto 0);


begin

-- subtraction of the pedestal and running average 
	Sub_ped_i: for iCHAN in 0 to NUM_TrigCell-1 generate
		process(Clock160)
		begin
			if rising_edge(Clock160) then
				Sub_ped(iCHAN) <= In_Data(iCHAN) - Ped_ch(iCHAN);
				Sub_ped_delay(iCHAN) <= Sub_ped(iCHAN);
			end if;
		end process;
	end generate Sub_ped_i;
	
	Aver_i: for iCHAN in 0 to NUM_TrigCell-1 generate
		process(Clock160)
		begin
			if rising_edge(Clock160) then
				Aver2(iCHAN) <= Sub_ped_delay(iCHAN) + Sub_ped(iCHAN);
			end if;
		end process;
	end generate Aver_i;
	
-- Group sum
	
	GroupSum(0) <= (Aver2(0)+Aver2(1)+Aver2(4)+Aver2(5));
	GroupSum(1) <= (Aver2(4)+Aver2(5)+Aver2(8)+Aver2(9));
	GroupSum(2) <= (Aver2(8)+Aver2(9)+Aver2(12)+Aver2(13));
	GroupSum(3) <= (Aver2(1)+Aver2(2)+Aver2(5)+Aver2(6));
	GroupSum(4) <= (Aver2(5)+Aver2(6)+Aver2(9)+Aver2(10));
	GroupSum(5) <= (Aver2(9)+Aver2(10)+Aver2(13)+Aver2(14));
	GroupSum(6) <= (Aver2(2)+Aver2(3)+Aver2(6)+Aver2(7));
	GroupSum(7) <= (Aver2(6)+Aver2(7)+Aver2(10)+Aver2(11));
	GroupSum(8) <= (Aver2(10)+Aver2(11)+Aver2(14)+Aver2(15));

	Thresh_i: for iGroup in 0 to NumGroup-1 generate
		GroupValue_Up_LT(iGroup) <= '1' when (GroupSum(iGroup) >= ThresholdData_0) else
			'0';
		GroupValue_Up_MT(iGroup) <= '1' when (GroupSum(iGroup) >= ThresholdData_1 and GroupSum(iGroup) < ThresholdData_2) else
			'0';
		GroupValue_Up_HT(iGroup) <= '1' when (GroupSum(iGroup) >= ThresholdData_2) else
			'0';
		Threshold : entity work.SRFF 
			port map (
				S		=> GroupValue_Up_LT(iGroup),
				CLK	=> Clock160,
				R		=> AllReset,
				q		=> GroupLT_Trig(iGroup)
			);
	end generate Thresh_i;
		
--	FastTrig_i: for iGroup in 0 to NumGroup-1 generate
	process(Clock160)
	begin
		if rising_edge(Clock160) then
			if ((GroupLT_Trig(0) = '1') or (GroupLT_Trig(1) = '1') or (GroupLT_Trig(2) = '1') or 
				 (GroupLT_Trig(3) = '1') or (GroupLT_Trig(4) = '1') or (GroupLT_Trig(5) = '1') or 
				 (GroupLT_Trig(6) = '1') or (GroupLT_Trig(7) = '1') or (GroupLT_Trig(8) = '1')) then FastTrig_o <= '1';
																														  else FastTrig_o <= '0';
			end if;
		end if;
	end process;
	FastTrig <= FastTrig_o;

-- Group Amplitudes

	Amp_i: for iGroup in 0 to NumGroup-1 generate
		DelayGroupAmp(iGroup) <= GroupAmp(iGroup);
		GroupValue_Amp_Done(iGroup) <= '1' when ((DelayGroupAmp(iGroup) > GroupAmp(iGroup)) and GroupLT_Trig(iGroup) = '1' and GroupAmp_Trig(iGroup) = '0') else
												 '0';
		Amp : entity work.SRFF 
			port map (
				S		=> GroupValue_Amp_Done(iGroup),
				CLK	=> Clock160,
				R		=> AllReset,
				q		=> GroupAmp_Trig(iGroup)
			);
	end generate Amp_i;

--	Trig_i: for iGroup in 0 to NumGroup-1 generate
	process(Clock160)
	begin
		if rising_edge(Clock160) then
			if ((GroupAmp_Trig(0) = '1') or (GroupAmp_Trig(1) = '1') or (GroupAmp_Trig(2) = '1') or 
				 (GroupAmp_Trig(3) = '1') or (GroupAmp_Trig(4) = '1') or (GroupAmp_Trig(5) = '1') or 
				 (GroupAmp_Trig(6) = '1') or (GroupAmp_Trig(7) = '1') or (GroupAmp_Trig(8) = '1')) then Trig_o <= '1';
																															  else Trig_o <= '0';
			end if;
		end if;
	end process;
	Trig <= Trig_o;

-- *************** Max Amp Search ********************

	process(Clock160)
	begin
		if rising_edge(Clock160) then
			if Inhibit = '1' then 
					GroupChAmps(0) <= (others => '0');
					GroupChAmps(1) <= (others => '0');
					GroupChAmps(2) <= (others => '0');
					GroupChAmps(3) <= (others => '0');
					GroupChAmps(4) <= (others => '0');
					GroupChAmps(5) <= (others => '0');
					GroupChAmps(6) <= (others => '0');
					MaxAmp 			<= (others => '0');
					GroupChNum(0) <= (others => '0');
					GroupChNum(1) <= (others => '0');
					GroupChNum(2) <= (others => '0');
					GroupChNum(3) <= (others => '0');
					GroupChNum(4) <= (others => '0');
					GroupChNum(5) <= (others => '0');
					GroupChNum(6) <= (others => '0');
					MaxCellNumber <= (others => '0');
			else
				if (DelayGroupAmp(0) > DelayGroupAmp(1)) then GroupChAmps(0) <= DelayGroupAmp(0);
																			 GroupChNum(0) <= "0000";
																	  else GroupChAmps(0) <= DelayGroupAmp(1);
																			 GroupChNum(0) <= "0001";
				end if;
				if (DelayGroupAmp(2) > DelayGroupAmp(3)) then GroupChAmps(1) <= DelayGroupAmp(2);
																			 GroupChNum(1) <= "0010";
																	  else GroupChAmps(1) <= DelayGroupAmp(3);
																			 GroupChNum(1) <= "0011";
				end if;
				if (DelayGroupAmp(4) > DelayGroupAmp(5)) then GroupChAmps(2) <= DelayGroupAmp(4);
																			 GroupChNum(2) <= "0100";
																	  else GroupChAmps(2) <= DelayGroupAmp(5);
																			 GroupChNum(2) <= "0101";
				end if;
				if (DelayGroupAmp(6) > DelayGroupAmp(7)) then GroupChAmps(3) <= DelayGroupAmp(6);
																			 GroupChNum(3) <= "0110";
																	  else GroupChAmps(3) <= DelayGroupAmp(7);
																			 GroupChNum(3) <= "0111";
				end if;
				if (GroupChAmps(0) > GroupChAmps(1)) then GroupChAmps(4) <= GroupChAmps(0);
																		GroupChNum(4) <= GroupChNum(0);
																 else GroupChAmps(4) <= GroupChAmps(1);
																		GroupChNum(4) <= GroupChNum(1);
				end if;
				if (GroupChAmps(2) > GroupChAmps(3)) then GroupChAmps(5) <= GroupChAmps(2);
																		GroupChNum(5) <= GroupChNum(2);
																 else GroupChAmps(5) <= GroupChAmps(3);
																		GroupChNum(5) <= GroupChNum(3);
				end if;
				if (GroupChAmps(4) > GroupChAmps(5)) then GroupChAmps(6) <= GroupChAmps(4);
																		GroupChNum(6) <= GroupChNum(4);
																 else GroupChAmps(6) <= GroupChAmps(5);
																		GroupChNum(6) <= GroupChNum(5);
				end if;
				if (GroupChAmps(6) > DelayGroupAmp(8)) then MaxAmp <= GroupChAmps(6);
																		  MaxCellNumber <= GroupChNum(6);
																	else MaxAmp <= DelayGroupAmp(8);
																		  MaxCellNumber <= "1000";
				end if;
			end if;
		end if;
	end process;

-- *************** Cycle proceeding control ********************
-- All Reset
-- The MaxTime during which the thresholds are looking for and then flags are found thresholds

	NSampleCt_Counter : entity work.V_Counter 
	generic map(
				WIDTH => 16
			)
	port map (
				clock 	=> Clock,
				cnt_en	=> NSampleCt_en,
				clk_en	=> '1',
				sclr		=> AllReset,
				q			=> NSampleCt
				);

	process(Clock160)
	begin
		if rising_edge(Clock160) then
			if ((GroupLT_Trig(0) = '1') or (GroupLT_Trig(1) = '1') or (GroupLT_Trig(2) = '1') or 
				 (GroupLT_Trig(3) = '1') or (GroupLT_Trig(4) = '1') or (GroupLT_Trig(5) = '1') or 
				 (GroupLT_Trig(6) = '1') or (GroupLT_Trig(7) = '1') or (GroupLT_Trig(8) = '1')) then NSampleCt_en <= '1';
																														  else NSampleCt_en <= '0';
			end if;
		end if;
	end process;

	TimeOut <= '1' when ( NSampleCt >= ResetTime) else
				  '0';

	ENDCycle <= '1' when (Trig_o = '1') else
					'0';

	process(Clock160)
	begin
		if rising_edge(Clock160) then
			DelayENDCycle(0) <= ENDCycle;
			DelayENDCycle(1) <= DelayENDCycle(0);
			DelayENDCycle(2) <= DelayENDCycle(1);
			DelayENDCycle(3) <= DelayENDCycle(2);
			DelayENDCycle(4) <= DelayENDCycle(3);
			DelayENDCycle(5) <= DelayENDCycle(4);
			DelayENDCycle(6) <= DelayENDCycle(5);
			DelayENDCycle(7) <= DelayENDCycle(6);
			DelayENDCycle(8) <= DelayENDCycle(7);
			DelayENDCycle(9) <= DelayENDCycle(8);
		end if;
	end process;

	Inhibit_srff : entity work.SRFF 
	port map (
		S		=> DelayENDCycle(9),
		CLK	=> Clock160,
		R		=> DelayReset(5),
		q		=> Inhibit
	);

	AllReset_S <= (TimeOutSch OR (TimeOut AND ENDthrFound));

	AllReset_SRFF : entity work.SRFF 
		port map (
			S		=> AllReset_S,
			CLK	=> Clock160,
			R		=> DelayReset(5),										-- работа разрешается после пересечения малого порога при уменьшении сигнала
			q		=> AllReset
		);

	process(Clock160)
	begin
		if rising_edge(Clock160) then
			DelayReset(0) <= AllReset;
			DelayReset(1) <= DelayReset(0);
			DelayReset(2) <= DelayReset(1);
			DelayReset(3) <= DelayReset(2);
			DelayReset(4) <= DelayReset(3);
			DelayReset(5) <= DelayReset(4);
			DelayReset(6) <= DelayReset(5);
			DelayReset(7) <= DelayReset(6);
			DelayReset(8) <= DelayReset(7);
			DelayReset(9) <= DelayReset(8);
		end if;
	end process;

	ResetAll <= AllReset;

--******** Test part ********--

	Test(0) <= Clock160;
	Test(1) <= GroupLT_Trig(0);
	Test(2) <= GroupMT_Trig(0);
	Test(3) <= GroupHT_Trig(0);
	Test(4) <= FastTrig_o;
	Test(5) <= GroupAmp_Trig(0);
	Test(6) <= Trig_o;
	Test(7) <= Clock160;
	Test(8) <= Clock160;
	Test(9) <= AllReset;
	Test(10) <= Clock160;
	Test(11) <= Clock160;
	Test(12) <= Clock160;
	Test(13) <= Clock160;
	Test(14) <= Clock160;
	Test(15) <= Clock160;

end Behavioral;
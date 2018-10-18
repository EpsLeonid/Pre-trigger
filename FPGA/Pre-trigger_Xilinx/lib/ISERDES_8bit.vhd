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

	DataIn 	: in std_logic := '0';	-- input of data from ADC by bits
	Clock		: in std_logic;
	Clk_Div	: out std_logic;
	Rst		: in std_logic := '0';
	
	DataOut	: out std_logic_vector(ADC_Bits-1 downto 0);
	
	Test		: out std_logic_vector(15 downto 0):= (others => '0')
	
	);
end ISERDES_8bit;

architecture Behavioral of ISERDES_8bit is

	signal shift1	: std_logic; 
	signal shift2	: std_logic;
	signal clkdiv	: std_logic;
	signal Data_p	: std_logic := '0';
	signal Data_n	: std_logic := '0';
	signal DataP	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal DataN	: std_logic_vector(ADC_Bits/2-1 downto 0):= (others => '0');
	signal Data		: std_logic_vector(ADC_Bits-1 downto 0):= (others => '0');

begin

--	DivClk: BUFR generic map (
--      BUFR_DIVIDE => "4",   -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8" 
--      SIM_DEVICE => "VIRTEX4")   -- Specify target device, "VIRTEX4", "VIRTEX5", "VIRTEX6" 
--   port map (
--      O => clkdiv,     -- Clock buffer output
--      CE => '1',   -- Clock enable input
--      CLR => '0', -- Clock buffer reset input
--      I => Clock      -- Clock buffer input
--   );	

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
		C => Clock,		-- 1-bit clock input
		CE => '1',		-- 1-bit clock enable input
		D => DataIn,	-- 1-bit DDR data input
		R => Rst,		-- 1-bit reset
		S => '1'			-- 1-bit set
	);

	DDR_Reg: process(Clock)
	begin
		if(rising_edge(Clock)) then
			if Rst ='1' then 
				DataP(0) <= '0';
				DataN(0) <= '0';
			else 
				DataP(0) <= Data_p;
				DataN(0) <= Data_n;
			end if;
		end if;
	end process;

	DDR_Reg_P: for i in 0 to 2 generate
		DDR_Reg_pos: process(Clock)
		begin
			if(rising_edge(Clock)) then
				if Rst ='1' then 
					DataP(i+1) <= '0';
				else 
					DataP(i+1) <= DataP(i);
				end if;
			end if;
		end process DDR_Reg_pos;
	end generate;

	DDR_Reg_N: for i in 0 to 2 generate
		DDR_Reg_neg: process(Clock)
		begin
			if(rising_edge(Clock)) then
				if Rst ='1' then 
					DataN(i+1) <= '0';
				else 
					DataN(i+1) <= DataN(i);
				end if;
			end if;
		end process DDR_Reg_neg;
	end generate;
	
	DivClk : entity work.ClkDiv
	port map (
				i_clk 		=> Clock,	-- input of data clock from ADC 
				o_clk			=> clkdiv	-- output of data clock divided by 4 and delay to 3125 ps (frame clock)
				);
	
	Clk_Div <= clkdiv;
	
	adc_data: process(clkdiv)
	begin
		if(rising_edge(clkdiv)) then
			Data(0) <= DataP(0);
			Data(1) <= DataN(0);
			Data(2) <= DataP(1);
			Data(3) <= DataN(1);
			Data(4) <= DataP(2);
			Data(5) <= DataN(2);
			Data(6) <= DataP(3);
			Data(7) <= DataN(3);
		end if;
	end process adc_data;

--	adc_serdes_p: ISERDES generic map (
--      BITSLIP_ENABLE => TRUE, -- TRUE/FALSE to enable bitslip controller
--                                 -- Must be "FALSE" in interface type is "MEMORY" 
--      DATA_RATE => "DDR", -- Specify data rate of "DDR" or "SDR" 
--      DATA_WIDTH => 4, -- Specify data width - For DDR 4,6,8, or 10 
--                       -- For SDR 2,3,4,5,6,7, or 8 
--      INTERFACE_TYPE => "NETWORKING", -- Use model - "MEMORY" or "NETWORKING" 
--      IOBDELAY => "NONE", -- Specify outputs where delay chain will be applied
--                          -- "NONE", "IBUF", "IFD", or "BOTH" 
--      IOBDELAY_TYPE => "DEFAULT", -- Set tap delay "DEFAULT", "FIXED", or "VARIABLE" 
--      IOBDELAY_VALUE => 0, -- Set initial tap delay to an integer from 0 to 63
--      NUM_CE => 1, -- Define number or clock enables to an integer of 1 or 2
--      SERDES_MODE => "MASTER") --Set SERDES mode to "MASTER" or "SLAVE" 
--   port map (
--      O => Open,    -- 1-bit output
--      Q1 => Data(0),  -- 1-bit output
--      Q2 => Data(2),  -- 1-bit output
--      Q3 => Data(4),  -- 1-bit output
--      Q4 => Data(6),  -- 1-bit output
--      Q5 => Open,  -- 1-bit output
--      Q6 => Open,  -- 1-bit output
--      SHIFTOUT1 => Open, -- 1-bit output
--      SHIFTOUT2 => Open, -- 1-bit output
--      BITSLIP => '0',     -- 1-bit input
--      CE1 => '1',        -- 1-bit input
--      CE2 => '1',        -- 1-bit input
--      CLK => Clock,        -- 1-bit input
--      CLKDIV => clkdiv,  -- 1-bit input
--      D => DataP,            -- 1-bit input
--      DLYCE => '0',    -- 1-bit input
--      DLYINC => '0',  -- 1-bit input
--      DLYRST => '0',  -- 1-bit input
--      OCLK => '0',      -- 1-bit input
--      REV => '0',        -- Must be tied to logic zero
--      SHIFTIN1 => '0', -- 1-bit input
--      SHIFTIN2 => '0', -- 1-bit input
--      SR => Rst           -- 1-bit input
--   );
--
--	adc_serdes_n: ISERDES generic map (
--      BITSLIP_ENABLE => TRUE, -- TRUE/FALSE to enable bitslip controller
--                                 -- Must be "FALSE" in interface type is "MEMORY" 
--      DATA_RATE => "DDR", -- Specify data rate of "DDR" or "SDR" 
--      DATA_WIDTH => 4, -- Specify data width - For DDR 4,6,8, or 10 
--                       -- For SDR 2,3,4,5,6,7, or 8 
--      INTERFACE_TYPE => "NETWORKING", -- Use model - "MEMORY" or "NETWORKING" 
--      IOBDELAY => "NONE", -- Specify outputs where delay chain will be applied
--                          -- "NONE", "IBUF", "IFD", or "BOTH" 
--      IOBDELAY_TYPE => "DEFAULT", -- Set tap delay "DEFAULT", "FIXED", or "VARIABLE" 
--      IOBDELAY_VALUE => 0, -- Set initial tap delay to an integer from 0 to 63
--      NUM_CE => 1, -- Define number or clock enables to an integer of 1 or 2
--      SERDES_MODE => "MASTER") --Set SERDES mode to "MASTER" or "SLAVE" 
--   port map (
--      O => Open,    -- 1-bit output
--      Q1 => Data(1),  -- 1-bit output
--      Q2 => Data(3),  -- 1-bit output
--      Q3 => Data(5),  -- 1-bit output
--      Q4 => Data(7),  -- 1-bit output
--      Q5 => Open,  -- 1-bit output
--      Q6 => Open,  -- 1-bit output
--      SHIFTOUT1 => Open, -- 1-bit output
--      SHIFTOUT2 => Open, -- 1-bit output
--      BITSLIP => '0',     -- 1-bit input
--      CE1 => '1',        -- 1-bit input
--      CE2 => '1',        -- 1-bit input
--      CLK => Clock,        -- 1-bit input
--      CLKDIV => clkdiv,  -- 1-bit input
--      D => DataN,            -- 1-bit input
--      DLYCE => '0',    -- 1-bit input
--      DLYINC => '0',  -- 1-bit input
--      DLYRST => '0',  -- 1-bit input
--      OCLK => '0',      -- 1-bit input
--      REV => '0',        -- Must be tied to logic zero
--      SHIFTIN1 => '0', -- 1-bit input
--      SHIFTIN2 => '0', -- 1-bit input
--      SR => Rst           -- 1-bit input
--   );

	Test(0) <= Data_p;
	Test(1) <= Data_n;
	Test(2) <= DataP(0);
	Test(3) <= DataN(0);
	Test(4) <= DataP(1);
	Test(5) <= DataN(1);
	Test(6) <= DataP(2);
	Test(7) <= DataN(2);
	Test(8) <= DataP(3);
	Test(9) <= DataN(3);

	DataOut(0) <= Data(0);
	DataOut(1) <= Data(1);
	DataOut(2) <= Data(2);
	DataOut(3) <= Data(3);
	DataOut(4) <= Data(4);
	DataOut(5) <= Data(5);
	DataOut(6) <= Data(6);
	DataOut(7) <= Data(7);

end Behavioral;


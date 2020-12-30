
-- VHDL Instantiation Created from source file Sys_dll.vhd -- 18:05:17 12/11/2020
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT Sys_dll
	PORT(
		U1_CLKIN_IN : IN std_logic;
		U1_RST_IN : IN std_logic;          
		CLK90_OUT : OUT std_logic;
		U1_CLKDV_OUT : OUT std_logic;
		U1_CLKFX_OUT : OUT std_logic;
		U1_CLKIN_IBUFG_OUT : OUT std_logic;
		U1_CLK0_OUT : OUT std_logic;
		U2_CLKFX_OUT : OUT std_logic;
		U2_CLK0_OUT : OUT std_logic;
		U2_CLK2X_OUT : OUT std_logic;
		U2_CLK2X180_OUT : OUT std_logic;
		U2_LOCKED_OUT : OUT std_logic
		);
	END COMPONENT;

	Inst_Sys_dll: Sys_dll PORT MAP(
		U1_CLKIN_IN => ,
		U1_RST_IN => ,
		CLK90_OUT => ,
		U1_CLKDV_OUT => ,
		U1_CLKFX_OUT => ,
		U1_CLKIN_IBUFG_OUT => ,
		U1_CLK0_OUT => ,
		U2_CLKFX_OUT => ,
		U2_CLK0_OUT => ,
		U2_CLK2X_OUT => ,
		U2_CLK2X180_OUT => ,
		U2_LOCKED_OUT => 
	);



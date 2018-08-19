library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

use std.textio.all;

package tb_procs is
	constant REG_IO_VERBOSE_YES : integer := 1;
	constant REG_IO_VERBOSE_NO  : integer := 0;

	procedure tkn_slot(
		tkn_vec    : in std_logic_vector(23 downto 0);
		sck_period : in time;
		signal SCK : out std_logic;
		signal TKN : out std_logic);

	procedure tkn_nop(
		sck_period : in time;
		signal SCK : out std_logic;
		signal TKN : out std_logic);

	procedure tkn_reset_adc_cycle(
		sck_period : in time;
		signal SCK : out std_logic;
		signal TKN : out std_logic);

	procedure tkn_write_reg(
		verbose    : in integer;
		reg_num    : in integer;
		reg_wdata  : in integer;
		sck_period : in time;
		signal SCK : out std_logic;
		signal TKN : out std_logic);

end tb_procs;

package body tb_procs is

	procedure tkn_slot(
		tkn_vec    : in std_logic_vector(23 downto 0);
		sck_period : in time;
		signal SCK : out std_logic;
		signal TKN : out std_logic) is
	
	variable tkn_vec_int : std_logic_vector(23 downto 0) := (others=>'0');

	begin
		tkn_vec_int := tkn_vec;
		for cycle_cnt in 0 to 21 loop
			TKN <= tkn_vec_int(23);
			tkn_vec_int := tkn_vec_int(22 downto 0) & '0';
			SCK <= '0';
			wait for sck_period/2;
			SCK <= '1';
			wait for sck_period/2;
		end loop;
		for cycle_cnt in 0 to 1 loop
			TKN <= tkn_vec_int(23);
			tkn_vec_int := tkn_vec_int(22 downto 0) & '0';
			SCK <= '0';
			wait for sck_period/2;
			SCK <= '1';
			wait for sck_period/2;
		end loop;		
	end;

	procedure tkn_nop(
		sck_period : in time;
		signal SCK : out std_logic;
		signal TKN : out std_logic) 
	is
		
	variable reg_rdata : integer := 0;

	begin
		tkn_slot( B"1000_0100_0010_0010_0000_0000", sck_period, SCK, TKN);
	end;

	procedure tkn_reset_adc_cycle(
		sck_period : in time;
		signal SCK : out std_logic;
		signal TKN : out std_logic) 
	is
		
	variable reg_rdata : integer := 0;

	begin
		tkn_slot( B"1000_0100_0011_1110_0000_0000", sck_period, SCK, TKN);
	end;

	procedure tkn_write_reg(
		verbose    : in integer;
		reg_num    : in integer;
		reg_wdata  : in integer;
		sck_period : in time;
		signal SCK : out std_logic;
		signal TKN : out std_logic) 
	is

	variable data_int : std_logic_vector(7 downto 0) := (others=>'0');
	variable tkn_vec  : std_logic_vector(23 downto 0) := (others=>'0');
	variable l     : line;

	begin
		data_int := conv_std_logic_vector(reg_wdata,8);
		tkn_vec := '1' & data_int(7 downto 4) & '1' & data_int(3 downto 0) & B"10_1010_0000_0000";
		tkn_slot( tkn_vec, sck_period, SCK, TKN );
		data_int := conv_std_logic_vector(reg_num,8);
		tkn_vec := '1' & data_int(7 downto 4) & '1' & data_int(3 downto 0) & B"11_1010_0000_0000";
		tkn_slot( tkn_vec, sck_period, SCK, TKN);
		if verbose = 1 then
			write(l,string'("WRITE: REG["));
			write(l,reg_num);
			write(l,string'("] <= "));
			write(l,reg_wdata);
			writeline(output,l);
		end if;
	end;
		
	
end tb_procs;

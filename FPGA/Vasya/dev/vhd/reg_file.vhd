library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;

library work;
use work.constants.all;
use work.types.all;
use work.reg_map.all;

entity reg_file_m is
	port ( 
		i_clock, reset       : in  std_logic;

		-- enable accessing of corresponding registers directly
		i_set_values         : in  t_reg_array(0 to NREG-1);

		-- output values of the registers
		o_reg_data           : out t_reg_array(0 to NREG-1);
		
		----- ethernet interface 
		eth_reg_we           : in  std_logic;
		eth_reg_num          : in  std_logic_vector (15 downto 0);
		eth_reg_wdata        : in  std_logic_vector (15 downto 0);
		eth_reg_rdata        : out std_logic_vector (15 downto 0) );
end reg_file_m;

architecture behavorial of reg_file_m is
	-- default values to be initialized 
	signal s_eth_reg_rdata   : t_reg_data := (others => '0');
	signal s_eth_reg_rdata_0 : t_reg_data := (others => '0');
	signal s_eth_reg_rdata_1 : t_reg_data := (others => '0');
  signal s_eth_reg_rdata_grp : t_reg_array(0 to 4) := (others => (others => '0'));
	signal s_en_reg          : std_logic_vector(NREG-1 downto 0) := (others => '0');

	-- current register values
	signal s_reg_data        : t_reg_array(0 to NREG-1) := REG_DEFAULTS;
	signal s_reg_rdata       : t_reg_array(0 to NREG-1) := (others => (others => '0'));
	signal s_set_values      : t_reg_array(0 to NREG-1);

	signal s_eth_reg_we      : std_logic_vector(NREG-1 downto 0);
	signal s_eth_reg_num     : t_reg_num_array(0 to NREG-1);
	signal s_eth_reg_wdata   : t_reg_num_array(0 to NREG-1);
  ----------------------------------------------------------------
  -- function OR for all elements of array
  ----------------------------------------------------------------
  function func_array_or(arr_reg : t_reg_array) return t_reg_data is
    variable res : t_reg_data := (others => '0');
  begin
    for ix in 0 to arr_reg'length-1 loop
      res := res or arr_reg(ix);
    end loop;
    return res; 
  end func_array_or;
  ----------------------------------------------------------------

BEGIN
  
  ETH_GEN : for i in 0 to NREG-1 generate
    process(i_clock,reset)
    begin
      if reset = '1' then
        s_eth_reg_we(i)    <= '0';
        s_eth_reg_num(i)   <= (others => '0');
        s_eth_reg_wdata(i) <= (others => '0');
      elsif rising_edge(i_clock) then
        s_eth_reg_we(i)    <= eth_reg_we;
        s_eth_reg_num(i)   <= eth_reg_num;
        s_eth_reg_wdata(i) <= eth_reg_wdata;
      end if;
    end process;
  end generate ETH_GEN;

  ----------------------------------------------------------------
  IREG_GEN : for iREG in 0 to NREG-1 generate

    READONLY : if REG_MAPPER(iREG).ACCTYPE = B"01" generate
      process(i_clock)
      begin
        
        if rising_edge(i_clock) then

          s_set_values(iREG)  <= i_set_values(iREG);
          s_reg_data(iREG)    <= s_set_values(iREG);

          if s_eth_reg_num(iREG) = REG_MAPPER(iREG).NUMBER then
            s_reg_rdata(iREG)  <= s_reg_data(iREG);
          else
            s_reg_rdata(iREG) <= (others => '0');
          end if;
        end if;
      end process;
    end generate READONLY;

    READWRITE : if REG_MAPPER(iREG).ACCTYPE = B"10" generate
      process(i_clock, reset)
      begin
        if reset = '1' then
            s_reg_data(iREG)     <= REG_DEFAULTS(iREG);
        elsif rising_edge(i_clock) then

          if s_eth_reg_num(iREG) = REG_MAPPER(iREG).NUMBER then
            s_reg_rdata(iREG)  <= s_reg_data(iREG);
            if s_eth_reg_we(iREG) = '1' then
              s_reg_data(iREG) <= s_eth_reg_wdata(iREG);
            else
              s_reg_data(iREG)  <= s_reg_data(iREG);
            end if;
          else
            s_reg_rdata(iREG) <= (others => '0');
          end if;
        
        end if;
      end process;
    end generate READWRITE;

    WRITEONLY : if REG_MAPPER(iREG).ACCTYPE = B"11" generate
      s_reg_rdata(iREG) <= (others => '0');
      process(i_clock)
      begin
        if rising_edge(i_clock) then
          -- acctype 11 is for control registers
          if s_eth_reg_num(iREG) = REG_MAPPER(iREG).NUMBER and s_eth_reg_we(iREG) = '1'  then
              s_reg_data(iREG) <= s_eth_reg_wdata(iREG);
          else
            s_reg_data(iREG) <= (others => '0');
          end if;
        end if;
      end process;

    end generate WRITEONLY;

  end generate IREG_GEN;
  ----------------------------------------------------------------

  --s_eth_reg_rdata <= func_array_or(s_reg_rdata);

  --OUT_PROC : process(i_clock)
  --begin
    --if rising_edge(i_clock) then
      --eth_reg_rdata  <= s_eth_reg_rdata;
    --end if;
  --end process OUT_PROC;

  --process(i_clock)
    --variable res : t_reg_data := (others => '0');
  --begin
    --if rising_edge(i_clock) then
      --res := (others => '0');
      --for ix in 0 to NREG-1 loop
        --if REG_MAPPER(ix).ACCTYPE = B"01" then 
          --res := res or s_reg_rdata(ix);
        --end if;
      --end loop;
      --s_eth_reg_rdata_0 <= res;
    --end if;
  --end process;

  --process(i_clock)
    --variable res : t_reg_data := (others => '0');
  --begin
    --if rising_edge(i_clock) then
      --res := (others => '0');
      --for ix in 0 to NREG-1 loop
        --if REG_MAPPER(ix).ACCTYPE = B"10" then 
          --res := res or s_reg_rdata(ix);
        --end if;
      --end loop;
      --s_eth_reg_rdata_1 <= res;
    --end if;
  --end process;

  REG_GRP_GEN: for igrp in 1 to 5 generate
      function func_ngp(igp : integer) return integer is
        variable res : integer := 0;
      begin
        res := integer(ceil(real(NREG)/5.0))*igp;
        if res > NREG - 1 then
          res := NREG-1;
        end if;
        return res;
      end func_ngp;

      constant NGRP : integer := func_ngp(igrp);
  begin
    process(i_clock)
      variable res : t_reg_data := (others => '0');
    begin
      if rising_edge(i_clock) then
        res := (others => '0');
        for ix in 0 to NGRP loop
            res := res or s_reg_rdata(ix);
        end loop;
        s_eth_reg_rdata_grp(igrp-1) <= res;
      end if;
    end process;
  end generate REG_GRP_GEN;

  --s_eth_reg_rdata <= s_eth_reg_rdata_0 or s_eth_reg_rdata_1;
  s_eth_reg_rdata <= s_eth_reg_rdata_grp(0) or s_eth_reg_rdata_grp(1) or s_eth_reg_rdata_grp(2) or s_eth_reg_rdata_grp(3) or s_eth_reg_rdata_grp(4); 
  
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      eth_reg_rdata  <= s_eth_reg_rdata;
    end if;
  end process;

  o_reg_data     <= s_reg_data;


END behavorial;



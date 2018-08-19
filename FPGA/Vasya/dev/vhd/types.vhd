library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.constants.all;

package types is

  -- types for ADC data
	subtype t_adc_buf_data          is std_logic_vector(95 downto 0);
	type    t_adc_buf_data_array    is array (integer range <>)  of t_adc_buf_data;
	subtype t_adc_buf_data_4_array  is t_adc_buf_data_array(1 to 4);

  subtype t_adc_data              is std_logic_vector(ADC_BIT_WIDTH - 1 downto 0);
	type    t_adc_data_array        is array (integer range <>)  of t_adc_data;
	subtype t_adc_data_4_array      is t_adc_data_array(1 to 4);
	subtype t_adc_data_8_array      is t_adc_data_array(1 to 8);
	subtype t_adc_data_32_array     is t_adc_data_array(1 to 32);

  subtype t_adc_sum               is std_logic_vector((ADC_BIT_WIDTH+1)-1 downto 0); -- for running sums of two sectors
	type    t_adc_sum_array         is array (integer range <>)  of t_adc_sum;
	subtype t_adc_sum_32_array      is t_adc_sum_array(1 to 32);
                                 
  type    t_mem_12x32_array       is array (31 downto 0) of std_logic_vector(11 downto 0);

  -- testbuf                     
  subtype t_testbuf_addr          is std_logic_vector(4 downto 0);
                                 
  -- coincidence duration        
  subtype t_coidur_data           is std_logic_vector(LOM_COIDUR_BITS-1 downto 0);
  type    t_coidur_array          is array (integer range <>) of t_coidur_data; 
                                 
  -- histograms                  
  subtype t_hdata                 is std_logic_vector(LOM_HISTO_VAL_BITS-1 downto 0);
  type    t_hdata_array           is array (integer range<>)  of t_hdata;
  subtype t_histo_val             is std_logic_vector(LOM_HISTO_VAL_BITS - 1 downto 0);
	type    t_histo_data_arr        is array (integer range<>) of t_histo_val;
  ---                            
                                 
	type    stdlv_array_4x10_t      is array (1 to 4)  of std_logic_vector(10 downto 0);
	type    stdlv_array_8x2_t       is array (1 to 8)  of std_logic_vector(1 downto 0);
	                               
  -- types for registers	       
  subtype t_reg_addr              is std_logic_vector(REG_DEPTH - 1 downto 0);  
  subtype t_reg_data              is std_logic_vector(REG_WIDTH - 1 downto 0);  
  subtype t_reg_acc               is std_logic_vector(1 downto 0);
	type    t_reg_array             is array (integer range<>) of t_reg_data;
  subtype t_reg_32_array          is t_reg_array(0 to 31);
  subtype t_reg_16_array          is t_reg_array(0 to 15);

  subtype t_reg_num               is std_logic_vector(15 downto 0);
  type    t_reg_num_array         is array(integer range<>) of t_reg_num;
                                 
  -- types for counters          
  subtype t_cnt_data              is std_logic_vector(15 downto 0);
	type    t_cnt_data_array        is array (integer range<>) of t_cnt_data;


  -- record of register parameters
  type t_reg_info is record
--    INDEX   : integer;
    NAME    : string (1 to 15);
    NUMBER  : t_reg_addr; --
    DEFVAL  : t_reg_data;
    ACCTYPE : t_reg_acc;  -- bit 0 - access from inside of project 
                          -- bit 1 - access from microblaze
  end record t_reg_info; 

  --
  type    t_reg_info_array        is array(integer range <>) of t_reg_info;
  subtype t_reg_info_32_array     is t_reg_info_array(0 to 31);
  subtype t_reg_info_16_array     is t_reg_info_array(0 to 15);


end types;

package body types is
end types;


library ieee;                                                 
use ieee.std_logic_1164.all;

package constants is

-- constants for ADC
  constant ADC_BIT_WIDTH       : integer := 12;
  constant N_ADC_CHIPS         : integer := 4;
  constant N_ADC_IN_CHIP       : integer := 8;
  constant N_ADC               : integer := N_ADC_CHIPS * N_ADC_IN_CHIP;

-- constants for registers
  constant REG_WIDTH           : integer := 16;
  constant REG_DEPTH           : integer := 16;
--  constant NREG                : integer := 100;

  constant LOM_ADCBUF_DEPTH     : integer := 11;

-- constants for Histograms  
  constant LOM_HISTO_NBINS      : integer := 128;
  constant LOM_HISTO_BIN_WIDTH  : integer := 32;
  constant LOM_HISTO_ADDR_BITS  : integer := 7;
  constant LOM_HISTO_VAL_BITS   : integer := 16;
  constant LOM_HISTO_NUMBER     : integer := 32;
  constant LOM_HISTO_INDEX_BITS : integer := 8;

  constant LOM_COIDUR_BITS      : integer := 16;

  -- number of misconnected ADC channel (1-32)
  -- for which special deserializer should be included
  -- if 0, than use normal deserializers for all channels
  constant SIMPLE_DESER_CHAN    : integer := 6; 

end constants;

package body constants is
end constants;


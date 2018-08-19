library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;
use work.types.all;
use work.utils.all;

----------------------------------------------------------------------
----- REGISTERS MAPPING ----------------------------------------------
----------------------------------------------------------------------
-- reg_info record : 
-- NAME     : register name   : string (1 to 10)
-- NUMBER   : register number : t_reg_data
-- DEFVAL   : default value   : std_logic_vector(15 downto 0)
-- ACC TYPE : access type     : std_logic_vector(1 downto 0)
--                              bit 0 - access inside of project 
--                              bit 1 - access from microblaze
--                              "01"  -- register may be changed only from fpga project
--                                       such registers operate in alway enable mode 
--                                       for writing from internal design
--                              "11"  -- control registers, set from CPU for single clock
--                                       on next clock reset to zero
----------------------------------------------------------------------
-- ADD NEW REGISTERS:
-- single register:
-- 1) add entry to REM_MAP_1
-- 2) add constant with reg index:
--     constant REG_NEW   : integer := get_reg_index("NEWREGNAME  ", REG_MAPPER); 
-- array of registers:
-- 1) add TODO : write instruction how to add array of registers
-- 2) add 
--     


package reg_map is
  
  -- empty record
  constant zero_rec : t_reg_info := ((others => ' '), X"0000", X"0000", B"01");


  ---------------------------------------------------
  --- GENERAL REGISTERS -----------------------------
  ---------------------------------------------------
  constant REG_MAP_1 : t_reg_info_array := (
    -- NAME               NUMBER   DEFAULT  ACCESS
    ( "VERSION        ",  X"1000", X"00C8", B"01"), -- firmaware version
    ( "STATUS         ",  X"0020", X"0001", B"01"), -- LOM status
    ( "LOMCTRL        ",  X"0001", X"0010", B"11"), -- LOM control register
    --( "LOMMODE        ",  X"0002", X"0037", B"10"), -- operation modes
    ( "LOMMODE        ",  X"0002", X"0007", B"10"), -- operation modes
    ( "NEVT           ",  X"0005", X"0000", B"10"), -- number of events
    ( "EVTCNT         ",  X"0010", X"0000", B"01"), -- events counter
    ( "DEADTIME_H     ",  X"0021", X"0000", B"10"), -- dead time duration high word
    ( "DEADTIME_L     ",  X"0022", X"0000", B"10"), -- dead time duration low word
    ( "CLKMAX_H       ",  X"0023", X"0000", B"10"), -- measurement time in ADC clocks (sys_clock/4)
    ( "CLKMAX_L       ",  X"0024", X"0000", B"10"), -- measurement time in ADC clocks (sys_clock/4)
    ( "TEXPAND        ",  X"0025", X"0030", B"10"), -- duration of pulse from discriminator
    ( "NTESTEVT       ",  X"0026", X"0000", B"10"), -- number of test events to generate
    ( "CNTOVERFLOW    ",  X"0027", X"0000", B"01"), -- number of test events to generate
    ( "TTDRUN         ",  X"0028", X"0000", B"01"), -- number of run accepted by TTD from FTSW 
    ( "TTDUTIME_H     ",  X"0029", X"0000", B"01"), -- unix time accepted by TTD (high word)
    ( "TTDUTIME_L     ",  X"002A", X"0000", B"01"), -- unix time accepted by TTD (low rord)
    ( "TTDEXP         ",  X"002B", X"0000", B"01"), -- number of the experiment
    ( "EVTYPE         ",  X"0040", X"0000", B"10"), -- type of events to be stored in ADC buffer
    -- TODO:
    -- CLKHIST  -- time to accumulate histograms

    ( "CLKCNT_HIGH    ",  X"0011", X"0000", B"01"), -- clock counter high word
    ( "CLKCNT_LOW     ",  X"0012", X"0000", B"01"), -- clock counter low word
    ( "ADCADDR0       ",  X"0013", X"0000", B"01"), -- current address in the ADC buffer 
    ( "DTCNT_H        ",  X"0014", X"0000", B"01"), -- dead time counter high word
    ( "DTCNT_L        ",  X"0015", X"0000", B"01"), -- dead time cointer low word
    ( "BHARAWCNT_H    ",  X"0016", X"0000", B"01"), -- bhabha counter (without quality flag) high word
    ( "BHARAWCNT_L    ",  X"0017", X"0000", B"01"), -- bhabha counter (without quality flag) low word
    ( "BHACNT_H       ",  X"0018", X"0000", B"01"), -- bhabha counter high word
    ( "BHACNT_L       ",  X"0019", X"0000", B"01"), -- bhabha counter low word
    ( "FAKECNT_H      ",  X"001A", X"0000", B"01"), -- bhabha counter high word
    ( "FAKECNT_L      ",  X"001B", X"0000", B"01"), -- bhabha counter low word
    ( "INJCNT_H       ",  X"001C", X"0000", B"01"), -- injection time counter high word
    ( "INJCNT_L       ",  X"001D", X"0000", B"01"), -- injection time cointer low word
    ( "BUSYCNT_H      ",  X"001E", X"0000", B"01"), -- DAQ busy time counter high word
    ( "BUSYCNT_L      ",  X"001F", X"0000", B"01"), -- DAQ busy time cointer low word
    ( "BITSHIFT1      ",  X"0041", X"0000", B"10"), -- for bad channel
    ( "BITSHIFT2      ",  X"0042", X"0000", B"10"), -- not used
    ( "INFO           ",  X"000F", X"0007", B"10"), -- dummy register
    ( "ADCSTOP        ",  X"0080", X"0080", B"10"), -- number of samples after the trigger before stop
    ( "ADC1_BUF_MASK  ",  X"0081", X"FFFF", B"10"), -- ADC mask for filling of the buffer (chip 1, BWD endcap)
    ( "ADC2_BUF_MASK  ",  X"0082", X"FFFF", B"10"), -- ADC mask for filling of the buffer (chip 2, FWD endcap)
    ( "ADC1_LOM_MASK  ",  X"0083", X"FFFF", B"10"), -- ADC mask for histograms and counters (chip 1, BWD endcap)
    ( "ADC2_LOM_MASK  ",  X"0084", X"FFFF", B"10"), -- ADC mask for histograms and counters (chip 2, FWD endcap)
    ( "ADCBUFSIZE     ",  X"0085", X"0000", B"01"), -- size of the ADC buffer in number of words
    ( "SETADCBUFSIZE  ",  X"0086", X"0000", B"10")  -- size of the ADC buffer in number of words
  );
  ---------------------------------------------------

  ---------------------------------------------------
  --- ARRAYS OF REGISTERS PARAMETERS ----------------
  ---------------------------------------------------
  -- default threshold for all ADC channels
  constant ADC_DEF_THRESH        : std_logic_vector(15 downto 0) := X"0100";
  constant REG_ADC_THRESH_MAP : t_reg_info_32_array := 
    gen_rec_array( "ADCTHRESH_", X"0051", ADC_DEF_THRESH, B"10", N_ADC);   -- ADC thresholds for trigger for ADC buffer

  constant ADC_DEF_QTHRESH       : std_logic_vector(15 downto 0) := X"0100";
  constant REG_ADC_QTHRESH_MAP : t_reg_info_32_array := 
    gen_rec_array( "ADC_Q_THR_", X"0150", ADC_DEF_QTHRESH, B"10", N_ADC);   -- thresholds for bhabha quality signal

  constant ADC_DEF_SUMTHRESH     : std_logic_vector(15 downto 0) := X"0200";
  constant REG_ADC_SUMTHRESH_MAP : t_reg_info_32_array := 
    gen_rec_array( "ADC_S_THR_", X"0200", ADC_DEF_SUMTHRESH, B"10", N_ADC); -- ADC thresholds for trigger for ADC buffer

  constant REG_ADC_CNT_MAP : t_reg_info_32_array := 
    gen_rec_array( "ADCCNT_", X"00C0", X"0000", B"01", 32);                 -- ADC occupancy counters

  constant REG_SUM_CNT_MAP : t_reg_info_32_array := 
    gen_rec_array( "SUMCNT_", X"00E0", X"0000", B"01", 32);                 -- ADC occupancy counters

  constant REG_COI_CNT_MAP : t_reg_info_16_array := 
    gen_rec_array( "COICNT_", X"0120", X"0000", B"01", 16);                 -- coincidence counters for sum signals

  constant REG_ROI_CNT_MAP : t_reg_info_16_array := 
    gen_rec_array( "ROICNT_", X"0110", X"0000", B"01", 16);                 -- coincidence counters for raw signals

  constant REG_ADC_AMP_MAP : t_reg_info_32_array := 
    gen_rec_array( "ADCAMP_", X"0220", X"0000", B"01", 32);                 -- ADC amplitudes

  constant REG_SUM_AMP_MAP : t_reg_info_32_array := 
    gen_rec_array( "SUMAMP_", X"0240", X"0000", B"01", 32);                 -- ADC sum amplitudes

  --constant REG_COIMATRIX_MAP : t_reg_info_array(0 to 255) :=                          -- temporary
    --gen_rec_array( "COIMATRIX_", X"0300", X"0000", B"01", 256);
  ---------------------------------------------------


  -- calculate total number of registers
  constant NREG : integer := REG_MAP_1'length + 
                             REG_ADC_THRESH_MAP'length + 
                             REG_ADC_QTHRESH_MAP'length + 
                             REG_COI_CNT_MAP'length + 
                             REG_ROI_CNT_MAP'length + 
                             REG_ADC_CNT_MAP'length + 
                             REG_SUM_CNT_MAP'length + 
                             REG_ADC_AMP_MAP'length + 
                             --REG_SUM_AMP_MAP'length + 
                             REG_ADC_SUMTHRESH_MAP'length;
                             --REG_COIMATRIX_MAP'length;

  -- combined registers map
  constant REG_MAPPER : t_reg_info_array(0 to NREG-1) := REG_MAP_1 & 
                                                         REG_ADC_THRESH_MAP & 
                                                         REG_ADC_QTHRESH_MAP & 
                                                         REG_COI_CNT_MAP & 
                                                         REG_ROI_CNT_MAP & 
                                                         REG_ADC_CNT_MAP & 
                                                         REG_SUM_CNT_MAP & 
                                                         REG_ADC_AMP_MAP & 
                                                         --REG_SUM_AMP_MAP & 
                                                         REG_ADC_SUMTHRESH_MAP;
                                                         --REG_COIMATRIX_MAP ;
  

  -- GET INDEXES OF REGISTERS FROM ARRAY OF REG_INFO 
  -- NB: whitespaces in names are MANDATORY!!!!
  -- firmware version
  constant REG_VERSION       : integer := get_reg_index("VERSION      ", REG_MAPPER); 
  -- status
  constant REG_STATUS        : integer := get_reg_index("STATUS       ", REG_MAPPER); 
  -- control register
  constant REG_LOMCTRL       : integer := get_reg_index("LOMCTRL      ", REG_MAPPER); 
  -- operation modes
  constant REG_LOMMODE       : integer := get_reg_index("LOMMODE      ", REG_MAPPER); 
  -- number of "events" before stop
  constant REG_NEVT          : integer := get_reg_index("NEVT         ", REG_MAPPER); 
  -- events counter
  constant REG_EVTCNT        : integer := get_reg_index("EVTCNT       ", REG_MAPPER); 
  -- dead time
  constant REG_DEADTIME_H    : integer := get_reg_index("DEADTIME_H   ", REG_MAPPER); 
  constant REG_DEADTIME_L    : integer := get_reg_index("DEADTIME_L   ", REG_MAPPER); 
  -- number of clocks before stop
  constant REG_CLKMAX_H      : integer := get_reg_index("CLKMAX_H     ", REG_MAPPER); 
  constant REG_CLKMAX_L      : integer := get_reg_index("CLKMAX_L     ", REG_MAPPER); 
  -- duration of pulse from discriminators
  constant REG_TEXPAND       : integer := get_reg_index("TEXPAND      ", REG_MAPPER); 
  -- number of test events to generate
  constant REG_NTESTEVT      : integer := get_reg_index("NTESTEVT     ", REG_MAPPER); 
  -- overflow flags for counters
  constant REG_CNTOVERFLOW   : integer := get_reg_index("CNTOVERFLOW  ", REG_MAPPER); 
  -- type of events to be stored in the ADC buffer
  constant REG_EVTYPE        : integer := get_reg_index("EVTYPE       ", REG_MAPPER); 

  -- data from b2tt
  constant REG_TTDRUN        : integer := get_reg_index("TTDRUN       ", REG_MAPPER); 
  constant REG_TTDUTIME_H    : integer := get_reg_index("TTDUTIME_H   ", REG_MAPPER); 
  constant REG_TTDUTIME_L    : integer := get_reg_index("TTDUTIME_L   ", REG_MAPPER); 
  constant REG_TTDEXP        : integer := get_reg_index("TTDEXP       ", REG_MAPPER); 

  -- dead time
  constant REG_DTCNT_H       : integer := get_reg_index("DTCNT_H      ", REG_MAPPER); 
  constant REG_DTCNT_L       : integer := get_reg_index("DTCNT_L      ", REG_MAPPER); 

  -- bhabha w/o quality
  constant REG_BHACNT_H      : integer := get_reg_index("BHACNT_H     ", REG_MAPPER); 
  constant REG_BHACNT_L      : integer := get_reg_index("BHACNT_L     ", REG_MAPPER); 
  
  -- bhabha w/ quality
  constant REG_BHARAW_CNT_H   : integer := get_reg_index("BHARAWCNT_H  ", REG_MAPPER); 
  constant REG_BHARAW_CNT_L   : integer := get_reg_index("BHARAWCNT_L  ", REG_MAPPER); 

  constant REG_FAKECNT_H      : integer := get_reg_index("FAKECNT_H     ", REG_MAPPER); 
  constant REG_FAKECNT_L      : integer := get_reg_index("FAKECNT_L     ", REG_MAPPER); 
  
  -- injection time
  constant REG_INJCNT_H       : integer := get_reg_index("INJCNT_H      ", REG_MAPPER); 
  constant REG_INJCNT_L       : integer := get_reg_index("INJCNT_L      ", REG_MAPPER); 
  constant REG_BUSYCNT_H      : integer := get_reg_index("BUSYCNT_H     ", REG_MAPPER); 
  constant REG_BUSYCNT_L      : integer := get_reg_index("BUSYCNT_L     ", REG_MAPPER); 

  -- clocks counter
  constant REG_CLKCNT_LOW    : integer := get_reg_index("CLKCNT_LOW   ", REG_MAPPER); 
  constant REG_CLKCNT_HIGH   : integer := get_reg_index("CLKCNT_HIGH  ", REG_MAPPER); 
  
  -- address in the adc buffer when the trigger comes
  constant REG_ADCADDR0      : integer := get_reg_index("ADCADDR0     ", REG_MAPPER); 
  
  -- bit shift for bad ADC channel
  constant REG_BITSHIFT1     : integer := get_reg_index("BITSHIFT1    ", REG_MAPPER); 
  constant REG_BITSHIFT2     : integer := get_reg_index("BITSHIFT2    ", REG_MAPPER); 
  
  -- dummy register
  constant REG_INFO          : integer := get_reg_index("INFO         ", REG_MAPPER); 
  
  -- number of samples after the trigger
  constant REG_ADCSTOP       : integer := get_reg_index("ADCSTOP      ", REG_MAPPER); 
  
  -- adc masks
  constant REG_ADC1_BUF_MASK : integer := get_reg_index("ADC1_BUF_MASK", REG_MAPPER); 
  constant REG_ADC2_BUF_MASK : integer := get_reg_index("ADC2_BUF_MASK", REG_MAPPER); 
  constant REG_ADC1_LOM_MASK : integer := get_reg_index("ADC1_LOM_MASK", REG_MAPPER); 
  constant REG_ADC2_LOM_MASK : integer := get_reg_index("ADC2_LOM_MASK", REG_MAPPER); 
  constant REG_ADCBUFSIZE    : integer := get_reg_index("ADCBUFSIZE   ", REG_MAPPER); 
  constant REG_SETADCBUFSIZE : integer := get_reg_index("SETADCBUFSIZE", REG_MAPPER); 

  -- arrays of registers
  constant REG_ADCTHRESH_1   : integer := get_reg_index("ADCTHRESH_1  ", REG_MAPPER); 
  constant REG_ADC_Q_THRESH_1: integer := get_reg_index("ADC_Q_THR_1  ", REG_MAPPER); 
  constant REG_ADC_S_THRESH_1: integer := get_reg_index("ADC_S_THR_1  ", REG_MAPPER); 
  constant REG_COICNT_1      : integer := get_reg_index("COICNT_1     ", REG_MAPPER); 
  constant REG_ROICNT_1      : integer := get_reg_index("ROICNT_1     ", REG_MAPPER); 
  constant REG_ADCCNT_1      : integer := get_reg_index("ADCCNT_1     ", REG_MAPPER); 
  constant REG_SUMCNT_1      : integer := get_reg_index("SUMCNT_1     ", REG_MAPPER); 
  constant REG_ADCAMP_1      : integer := get_reg_index("ADCAMP_1     ", REG_MAPPER); 
  --constant REG_SUMAMP_1      : integer := get_reg_index("SUMAMP_1     ", REG_MAPPER); 
  --constant REG_COIMATRIX_1   : integer := get_reg_index("COIMATRIX_1  ", REG_MAPPER); 
  ----------------------------------------------------

  -- make array of the registers default values
  constant REG_DEFAULTS     : t_reg_array(0 to NREG-1) := get_reg_from_rec(REG_MAPPER);

end package reg_map;

-------------------------------------------------------------------
-- PACKAGE BODY ---------------------------------------------------
-------------------------------------------------------------------
 
package body reg_map is
-- NOTHING here
end package body reg_map;

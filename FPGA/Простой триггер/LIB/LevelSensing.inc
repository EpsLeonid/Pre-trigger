--TITLE "LevelSensing";
-- This file contains function for "HIGH" level Sensing
-- The function produces positive pulse of 1clock duration when input signal 
-- is detected to be "HIGH" during at least 3 clocks 

-- Unificated NAMES of inputs and outputs (with EdgeSensing, DelayLine)

FUNCTION LevelSensing
(
       d,       -- Exturnal signal to synchronize
       clk,     -- Clock
       Reset    -- Reset
)  
RETURNS
(  
       q    --: output;  -- Synchronized out
);


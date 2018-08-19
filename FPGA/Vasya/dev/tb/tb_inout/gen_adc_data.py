#!/usr/bin/env python2.7

import sys

for ichan in range(1,32) :
    files = [open("adc_ch{}.txt".format(x+1),'w') for x in range(0,32)]

for isample in range(1,430001):
    for i,f in enumerate(files):
       a = isample
#       a = 0x0200 + i + (isample/3) if (isample/6)%2 == 0 else 0 
#       if i == 0 : a = 0x0200 + i if isample%7 == 0 else 0 
#       if i == 1 : a = 0x0200 + i if isample%7 <  1 else 0 
       f.write(str(a)+'\n') 
for f in files :
    f.close()

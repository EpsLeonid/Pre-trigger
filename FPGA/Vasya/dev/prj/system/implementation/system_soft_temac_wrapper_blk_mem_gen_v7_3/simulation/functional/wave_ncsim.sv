

 
 
 




window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/status
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/CLKA
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/ADDRA
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/DINA
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/WEA
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/ENA
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/DOUTA
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/CLKB
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/ADDRB
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/DINB
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/WEB
      waveform add -signals /system_soft_temac_wrapper_blk_mem_gen_v7_3_tb/system_soft_temac_wrapper_blk_mem_gen_v7_3_synth_inst/bmg_port/DOUTB

console submit -using simulator -wait no "run"

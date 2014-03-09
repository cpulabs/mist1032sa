transcript file code_check.log
alib work
set work work
alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ./tb/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../model/sim_memory_model/sim_memory_model.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../model/altera/altera_mf.v
alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/dps/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/dps/device/mimsr/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/dps/device/sci/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/dps/device/utim64/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/mmu/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/lib/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/decode/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/execute/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/execute/divider/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/fetch/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/l1_instruction/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/matching/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/rename/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/scheduling1/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/scheduling2/*.v
quit

transcript file sim/add.result

vlib work
vlog -work work +incdir+../../src/include +incdir+../../src/core/include ./tb/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../model/sim_memory_model/sim_memory_model.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../model/altera/altera_mf.v
vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/dps/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/dps/device/mimsr/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/dps/device/sci/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/dps/device/utim64/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/mmu/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/lib/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/pic/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/l1_instruction/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/l1_data/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/decode/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/execute/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/execute/divider/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/fetch/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/matching/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/rename/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/scheduler1/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/scheduler2/*.v

vlog -work work +incdir+../../src/include +incdir+../../src/core/include ../../src/core/pipeline_control/*.v
run -all
quit

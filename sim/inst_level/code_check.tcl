transcript file code_check.log
alib work
set work work
alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ./tb/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../model/sim_memory_model/sim_memory_model.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../model/altera/altera_mf.v
alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/primitive/altera/sync_fifo_8in_8out_16depth/altera_primitive_sync_fifo_8in_8out_16depth.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/primitive/altera/sync_fifo_28in_28out_16depth/altera_primitive_sync_fifo_28in_28out_16depth.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/primitive/altera/sync_fifo_34in_34out_8depth/altera_primitive_sync_fifo_34in_34out_8depth.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/primitive/altera/sync_fifo_102in_102out_32depth/altera_primitive_sync_fifo_102in_102out_32depth.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/debugger/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/dps_device/mimsr/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/dps_device/sci/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/dps_device/utim64/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/dps_main/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/mmu/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/lib/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/branch_predictor/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/core_debug/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/decode/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/dispatch/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/execution/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/execution/divider/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/fetch/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/instruction_buffer/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/l1_data/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/l1_instruction/*.v

alog -work work -dbg +incdir+../../src/include +incdir+../../src/core/include ../../src/core/pipeline_control/*.v
quit

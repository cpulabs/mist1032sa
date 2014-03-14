onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iCLOCK
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iEXCEPTION_RESTART
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_VALID
add wave -noupdate -expand -group {Scheduler1 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_SOURCE0
add wave -noupdate -expand -group {Scheduler1 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_SOURCE1
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_SYS_ADDER
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_SYS_LDST
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_LOGIC
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_SHIFT
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_ADDER
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_MUL
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_SDIV
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_UDIV
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_LDST
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_0_EX_BRANCH
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_VALID
add wave -noupdate -expand -group {Scheduler1 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_SOURCE0
add wave -noupdate -expand -group {Scheduler1 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_SOURCE1
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_SYS_ADDER
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_SYS_LDST
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_LOGIC
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_SHIFT
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_ADDER
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_MUL
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_SDIV
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_UDIV
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_LDST
add wave -noupdate -expand -group {Scheduler1 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_1_EX_BRANCH
add wave -noupdate -expand -group {Scheduler1 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iPREVIOUS_PC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1596 ns} 0}
configure wave -namecolwidth 239
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {752 ns} {2640 ns}

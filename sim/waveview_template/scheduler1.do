onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iCLOCK
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iEXCEPTION_EVENT
add wave -noupdate -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iEXCEPTION_COMMIT_TAG
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
add wave -noupdate -expand -group {Scheduler1 - Writeback} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iSCHE1_EX_BRANCH_VALID
add wave -noupdate -expand -group {Scheduler1 - Writeback} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iSCHE1_EX_BRANCH_COMMIT_TAG
add wave -noupdate -expand -group {Scheduler1 - Writeback} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iSCHE1_EX_ALU1_VALID
add wave -noupdate -expand -group {Scheduler1 - Writeback} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iSCHE1_EX_ALU1_COMMIT_TAG
add wave -noupdate -expand -group {Scheduler1 - Writeback} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iSCHE1_EX_ALU2_VALID
add wave -noupdate -expand -group {Scheduler1 - Writeback} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iSCHE1_EX_ALU2_COMMIT_TAG
add wave -noupdate -expand -group {Scheduler1 - Writeback} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iSCHE1_EX_ALU3_VALID
add wave -noupdate -expand -group {Scheduler1 - Writeback} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iSCHE1_EX_ALU3_COMMIT_TAG
add wave -noupdate -group {Scheduler1 - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/oNEXT_0_VALID
add wave -noupdate -group {Scheduler1 - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/oNEXT_1_VALID
add wave -noupdate -group {Scheduler1 - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/oNEXT_PC
add wave -noupdate -group {Scheduler1 - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/iNEXT_LOCK
add wave -noupdate -expand -group {Scheduler1 - Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/w_commit_pointer
add wave -noupdate -expand -group {Scheduler1 - Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/w_register_pointer
add wave -noupdate -expand -group {Scheduler1 - Internal} -expand /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE5_SCHEDULER1/entry_info_entry_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {101685 ns} 0}
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
WaveRestoreZoom {101151 ns} {102481 ns}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_VALID
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_SYS_REG
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_SYS_LDST
add wave -noupdate -expand -group {Scheduler2 - Prev Port} -radix binary /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_LOGIC
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_SHIFT
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_ADDER
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_MUL
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_SDIV
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_UDIV
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_LDST
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_BRANCH
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_VALID
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_SYS_REG
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_SYS_LDST
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_LOGIC
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_SHIFT
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_ADDER
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_MUL
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_SDIV
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_UDIV
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_LDST
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_BRANCH
add wave -noupdate -expand -group {Scheduler2 - Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_PC
add wave -noupdate -expand -group {Scheduler2 - Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/oPREVIOUS_LOCK
add wave -noupdate -expand -group {Scheduler2 - Reservation Common} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/w_ex_inorder_execution_pointer
add wave -noupdate -expand -group {Scheduler2 - Reservation Common} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_ex_inorder_regist_pointer
add wave -noupdate -group {Scheduler2 - Reservation0} -expand /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid
add wave -noupdate -group {Scheduler2 - Reservation0} -expand /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {684 ns} 0}
configure wave -namecolwidth 244
configure wave -valuecolwidth 99
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
WaveRestoreZoom {506 ns} {1141 ns}

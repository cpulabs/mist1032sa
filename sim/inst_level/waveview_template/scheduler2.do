onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iCLOCK
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iFREE_RESTART
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_VALID
add wave -noupdate -expand -group {Scheduler2 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_SOURCE0
add wave -noupdate -expand -group {Scheduler2 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_SOURCE1
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_SYS_REG
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_SYS_LDST
add wave -noupdate -expand -group {Scheduler2 - Port Prev} -radix binary /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_LOGIC
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_SHIFT
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_ADDER
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_MUL
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_SDIV
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_UDIV
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_LDST
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_0_EX_BRANCH
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_VALID
add wave -noupdate -expand -group {Scheduler2 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_SOURCE0
add wave -noupdate -expand -group {Scheduler2 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_SOURCE1
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_SYS_REG
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_SYS_LDST
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_LOGIC
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_SHIFT
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_ADDER
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_MUL
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_SDIV
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_UDIV
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_LDST
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_1_EX_BRANCH
add wave -noupdate -expand -group {Scheduler2 - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iPREVIOUS_PC
add wave -noupdate -expand -group {Scheduler2 - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/oPREVIOUS_LOCK
add wave -noupdate -group {Scheduler2 - Reservation Common} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/inorder_regist_pointer_offset
add wave -noupdate -group {Scheduler2 - Reservation Common} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/w_ex_inorder_execution_pointer
add wave -noupdate -group {Scheduler2 - Reservation Common} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/w_ex_0_inorder_regist_pointer
add wave -noupdate -group {Scheduler2 - Reservation Common} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/w_ex_1_inorder_regist_pointer
add wave -noupdate -group {Scheduler2 - Reservation0} -radix hexadecimal -childformat {{{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[0]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[1]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[2]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[3]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[4]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[5]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[6]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[7]} -radix hexadecimal}} -subitemconfig {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[0]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[1]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[2]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[3]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[4]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[5]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[6]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid[7]} {-height 15 -radix hexadecimal}} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_valid
add wave -noupdate -group {Scheduler2 - Reservation0} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_regist_ex_inorder_regist_pointer
add wave -noupdate -group {Scheduler2 - Reservation0} -radix hexadecimal -childformat {{{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[0]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[1]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[2]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[3]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[4]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[5]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[6]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[7]} -radix hexadecimal}} -expand -subitemconfig {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[0]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[1]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[2]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[3]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[4]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[5]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[6]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid[7]} {-height 15 -radix hexadecimal}} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_entry_valid
add wave -noupdate -group {Scheduler2 - Reservation0} -radix hexadecimal -childformat {{{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[0]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[1]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[2]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[3]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[4]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[5]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[6]} -radix hexadecimal} {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[7]} -radix hexadecimal}} -expand -subitemconfig {{/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[0]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[1]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[2]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[3]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[4]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[5]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[6]} {-height 15 -radix hexadecimal} {/tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching[7]} {-height 15 -radix hexadecimal}} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu0_info_matching
add wave -noupdate -expand -group {Scheduler2 - Reservation1} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu1_regist_valid
add wave -noupdate -expand -group {Scheduler2 - Reservation1} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu1_info_entry_valid
add wave -noupdate -expand -group {Scheduler2 - Reservation1} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu1_info_matching
add wave -noupdate -expand -group {Scheduler2 - Reservation1} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu1_info_pcr
add wave -noupdate -expand -group {Scheduler2 - Reservation2} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu2_regist_valid
add wave -noupdate -expand -group {Scheduler2 - Reservation2} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu2_info_entry_valid
add wave -noupdate -expand -group {Scheduler2 - Reservation2} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu2_info_matching
add wave -noupdate -expand -group {Scheduler2 - Reservation2} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu2_info_pcr
add wave -noupdate -expand -group {Scheduler2 - Reservation3} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu3_regist_valid
add wave -noupdate -expand -group {Scheduler2 - Reservation3} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu3_info_entry_valid
add wave -noupdate -expand -group {Scheduler2 - Reservation3} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/rs_alu3_info_matching
add wave -noupdate -group {Scheduler2 - Port WriteBack} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iSCHE2_EX_BRANCH_VALID
add wave -noupdate -group {Scheduler2 - Port WriteBack} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iSCHE2_EX_BRANCH_COMMIT_TAG
add wave -noupdate -group {Scheduler2 - Port WriteBack} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iSCHE2_EX_ALU1_VALID
add wave -noupdate -group {Scheduler2 - Port WriteBack} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iSCHE2_EX_ALU1_COMMIT_TAG
add wave -noupdate -group {Scheduler2 - Port WriteBack} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iSCHE2_EX_ALU2_VALID
add wave -noupdate -group {Scheduler2 - Port WriteBack} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iSCHE2_EX_ALU2_COMMIT_TAG
add wave -noupdate -group {Scheduler2 - Port WriteBack} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iSCHE2_ALU3_VALID
add wave -noupdate -group {Scheduler2 - Port WriteBack} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iSCHE2_ALU3_COMMIT_TAG
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1622 ns} 0}
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
WaveRestoreZoom {812 ns} {2184 ns}

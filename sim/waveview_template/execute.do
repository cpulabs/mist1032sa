onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iCLOCK
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE6_SCHEDULER2/iFREE_RESTART
add wave -noupdate -expand -group {Execute - P0 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/iPREVIOUS_EX_BRANCH_VALID
add wave -noupdate -expand -group {Execute - P0 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/iPREVIOUS_EX_BRANCH_COMMIT_TAG
add wave -noupdate -expand -group {Execute - P0 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/iPREVIOUS_EX_BRANCH_CMD
add wave -noupdate -expand -group {Execute - P0 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/iPREVIOUS_EX_BRANCH_CC
add wave -noupdate -expand -group {Execute - P0 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/iPREVIOUS_EX_BRANCH_FLAG
add wave -noupdate -expand -group {Execute - P0 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/iPREVIOUS_EX_BRANCH_SOURCE
add wave -noupdate -expand -group {Execute - P0 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/iPREVIOUS_EX_BRANCH_PC
add wave -noupdate -expand -group {Execute - P0 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/oPREVIOUS_EX_BRANCH_LOCK
add wave -noupdate -group {Execute - P0 Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/branch_addr
add wave -noupdate -group {Execute - P0 Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/jump_valid
add wave -noupdate -group {Execute - P0 Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/not_jump_valid
add wave -noupdate -group {Execute - P0 Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/ib_valid
add wave -noupdate -group {Execute - P0 Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/idts_valid
add wave -noupdate -group {Execute - P0 Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/halt_valid
add wave -noupdate -expand -group {Execute - P0 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/oJUMP_ACTIVE
add wave -noupdate -expand -group {Execute - P0 Next Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/oJUMP_ADDR
add wave -noupdate -expand -group {Execute - P0 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/oSCHE1_EX_BRANCH_VALID
add wave -noupdate -expand -group {Execute - P0 Next Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/oSCHE1_EX_BRANCH_COMMIT_TAG
add wave -noupdate -expand -group {Execute - P0 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/oSCHE2_EX_BRANCH_VALID
add wave -noupdate -expand -group {Execute - P0 Next Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT0/oSCHE2_EX_BRANCH_COMMIT_TAG
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_VALID
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_WRITEBACK
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_COMMIT_TAG
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_CMD
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_LOGIC
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_SHIFT
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_ADDER
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_MUL
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_SDIV
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_UDIV
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_SOURCE0
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_SOURCE1
add wave -noupdate -expand -group {Execute - P1 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_LOGIC_DEST
add wave -noupdate -expand -group {Execute - P1 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_DESTINATION_REGNAME
add wave -noupdate -expand -group {Execute - P1 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/iPREVIOUS_EX_ALU1_PCR
add wave -noupdate -expand -group {Execute - P1 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT1/oPREVIOUS_EX_ALU1_LOCK
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_VALID
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_WRITEBACK
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_COMMIT_TAG
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_CMD
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_SYS_REG
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_LOGIC
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_SHIFT
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_ADDER
add wave -noupdate -expand -group {Execute - P2 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_SOURCE0
add wave -noupdate -expand -group {Execute - P2 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_SOURCE1
add wave -noupdate -expand -group {Execute - P2 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_LOGIC_DEST
add wave -noupdate -expand -group {Execute - P2 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_DESTINATION_REGNAME
add wave -noupdate -expand -group {Execute - P2 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/iPREVIOUS_EX_ALU2_PCR
add wave -noupdate -expand -group {Execute - P2 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT2/oPREVIOUS_EX_ALU2_LOCK
add wave -noupdate -expand -group {Execute - P3 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iPREVIOUS_EX_ALU3_VALID
add wave -noupdate -expand -group {Execute - P3 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iPREVIOUS_EX_ALU3_CMD
add wave -noupdate -expand -group {Execute - P3 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iPREVIOUS_EX_ALU3_COMMIT_TAG
add wave -noupdate -expand -group {Execute - P3 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iPREVIOUS_EX_ALU3_SOURCE0
add wave -noupdate -expand -group {Execute - P3 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iPREVIOUS_EX_ALU3_SOURCE1
add wave -noupdate -expand -group {Execute - P3 Prev Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iPREVIOUS_EX_ALU3_PC
add wave -noupdate -expand -group {Execute - P3 Prev Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oPREVIOUS_EX_ALU3_LOCK
add wave -noupdate -group {Execute - P3 DataIo} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oDATAIO_REQ
add wave -noupdate -group {Execute - P3 DataIo} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iDATAIO_BUSY
add wave -noupdate -group {Execute - P3 DataIo} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oDATAIO_RW
add wave -noupdate -group {Execute - P3 DataIo} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oDATAIO_ADDR
add wave -noupdate -group {Execute - P3 DataIo} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oDATAIO_DATA
add wave -noupdate -group {Execute - P3 DataIo} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iDATAIO_REQ
add wave -noupdate -group {Execute - P3 DataIo} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/iDATAIO_DATA
add wave -noupdate -expand -group {Execute - P3 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oSCHE1_ALU3_VALID
add wave -noupdate -expand -group {Execute - P3 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oSCHE1_ALU3_COMMIT_TAG
add wave -noupdate -expand -group {Execute - P3 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oSCHE2_ALU3_VALID
add wave -noupdate -expand -group {Execute - P3 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oSCHE2_ALU3_COMMIT_TAG
add wave -noupdate -expand -group {Execute - P3 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oSCHE2_ALU3_DESTINATION_REGNAME
add wave -noupdate -expand -group {Execute - P3 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oSCHE2_ALU3_DESTINATION_SYSREG
add wave -noupdate -expand -group {Execute - P3 Next Port} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oSCHE2_ALU3_WRITEBACK
add wave -noupdate -expand -group {Execute - P3 Next Port} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/oSCHE2_ALU3_DATA
add wave -noupdate -expand -group {Execute - P3 Internal} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/store_done
add wave -noupdate -expand -group {Execute - P3 Internal} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/load_done
add wave -noupdate -expand -group {Execute - P3 Internal} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/spr_done
add wave -noupdate -expand -group {Execute - P3 Internal} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/this_lock
add wave -noupdate -expand -group {Execute - P3 Internal} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/ldst_pipe_rw
add wave -noupdate -expand -group {Execute - P3 Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/SATGE7_EX_PORT3/b_ldst_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2390 ns} 0}
configure wave -namecolwidth 310
configure wave -valuecolwidth 128
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
WaveRestoreZoom {1215 ns} {3653 ns}

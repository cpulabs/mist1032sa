onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/iCLOCK
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/iRESET_SYNC
add wave -noupdate -expand -group {Decoder - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/iPREVIOUS_COMMON_VALID
add wave -noupdate -expand -group {Decoder - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/iPREVIOUS_0_INST_VALID
add wave -noupdate -expand -group {Decoder - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/iPREVIOUS_0_INST
add wave -noupdate -expand -group {Decoder - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/iPREVIOUS_1_INST_VALID
add wave -noupdate -expand -group {Decoder - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/iPREVIOUS_1_INST
add wave -noupdate -expand -group {Decoder - Port Prev} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/iPREVIOUS_PC
add wave -noupdate -expand -group {Decoder - Port Prev} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE2_DECODER/oPREVIOUS_LOCK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1544 ns} 0}
configure wave -namecolwidth 226
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
WaveRestoreZoom {543 ns} {2533 ns}

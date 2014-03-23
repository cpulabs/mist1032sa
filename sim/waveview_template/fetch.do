onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iCLOCK
add wave -noupdate -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iEXCEPTION_EVENT
add wave -noupdate -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iEXCEPTION_RESTART
add wave -noupdate -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iEXCEPTION_ADDR_SET
add wave -noupdate -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iEXCEPTION_ADDR
add wave -noupdate -expand -group {Fetch - Port Prev-Req} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/oPREVIOUS_FETCH_REQ
add wave -noupdate -expand -group {Fetch - Port Prev-Req} -radix unsigned /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/oPREVIOUS_FETCH_ADDR
add wave -noupdate -expand -group {Fetch - Port Prev-Req} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iPREVIOUS_FETCH_LOCK
add wave -noupdate -expand -group {Fetch - Port Prev-In} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iPREVIOUS_0_INST_VALID
add wave -noupdate -expand -group {Fetch - Port Prev-In} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iPREVIOUS_0_INST
add wave -noupdate -expand -group {Fetch - Port Prev-In} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iPREVIOUS_1_INST_VALID
add wave -noupdate -expand -group {Fetch - Port Prev-In} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iPREVIOUS_1_INST
add wave -noupdate -expand -group {Fetch - Port Prev-In} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/oPREVIOUS_LOCK
add wave -noupdate -expand -group {Fetch - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/oNEXT_0_INST_VALID
add wave -noupdate -expand -group {Fetch - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/oNEXT_0_INST
add wave -noupdate -expand -group {Fetch - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/oNEXT_1_INST_VALID
add wave -noupdate -expand -group {Fetch - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/oNEXT_1_INST
add wave -noupdate -expand -group {Fetch - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/oNEXT_PC
add wave -noupdate -expand -group {Fetch - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE1_FETCH/iNEXT_LOCK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3186 ns} 0}
configure wave -namecolwidth 298
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
WaveRestoreZoom {2001 ns} {4113 ns}

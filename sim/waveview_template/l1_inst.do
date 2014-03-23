onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/iCLOCK
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/inRESET
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/iREMOVE
add wave -noupdate /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/iCACHE_FLASH
add wave -noupdate -expand -group {InstL1 - Port Request} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/iNEXT_FETCH_REQ
add wave -noupdate -expand -group {InstL1 - Port Request} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/oNEXT_FETCH_LOCK
add wave -noupdate -expand -group {InstL1 - Port Request} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/iNEXT_FETCH_ADDR
add wave -noupdate -group {InstL1 - Port Next} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/oNEXT_0_INST_VALID
add wave -noupdate -group {InstL1 - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/oNEXT_0_INST
add wave -noupdate -group {InstL1 - Port Next} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/oNEXT_1_INST_VALID
add wave -noupdate -group {InstL1 - Port Next} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/oNEXT_1_INST
add wave -noupdate -group {InstL1 - Port Next} /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/iNEXT_LOCK
add wave -noupdate -expand -group {InstL1 - Internal} -radix hexadecimal /tb_inst_level/TARGET/CORE_IF/CORE_PIPELINE/STAGE0_L1_INST/b_req_main_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1170 ns} 0}
configure wave -namecolwidth 150
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
WaveRestoreZoom {240 ns} {1444 ns}

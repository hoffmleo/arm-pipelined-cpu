onerror {resume}
quietly WaveActivateNextPane {} 0
# Add waves
add wave -noupdate /FWRD_UNIT_testbench/Rd_EX
add wave -noupdate /FWRD_UNIT_testbench/Rd_MEM
add wave -noupdate /FWRD_UNIT_testbench/Rd_WB
add wave -noupdate /FWRD_UNIT_testbench/Rn_ID
add wave -noupdate /FWRD_UNIT_testbench/Rm_ID
add wave -noupdate /FWRD_UNIT_testbench/RegWrite_EX
add wave -noupdate /FWRD_UNIT_testbench/RegWrite_MEM
add wave -noupdate /FWRD_UNIT_testbench/RegWrite_WB
add wave -noupdate /FWRD_UNIT_testbench/FwdA
add wave -noupdate /FWRD_UNIT_testbench/FwdB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 300
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1008 ps}

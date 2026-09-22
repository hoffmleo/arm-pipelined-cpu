onerror {resume}
quietly WaveActivateNextPane {} 0
# Add waves
add wave -noupdate /control_testbench/OppCode
add wave -noupdate /control_testbench/ALUOpp
add wave -noupdate /control_testbench/UncondBr
add wave -noupdate /control_testbench/Branch
add wave -noupdate /control_testbench/MemRead
add wave -noupdate /control_testbench/MemToReg
add wave -noupdate /control_testbench/MemWrite
add wave -noupdate /control_testbench/RegWrite
add wave -noupdate /control_testbench/BL
add wave -noupdate /control_testbench/ALUSrc
add wave -noupdate /control_testbench/BR
add wave -noupdate /control_testbench/ALUI
add wave -noupdate /control_testbench/BLT
add wave -noupdate /control_testbench/Reg2Loc
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

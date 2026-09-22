onerror {resume}
quietly WaveActivateNextPane {} 0
# Add waves
add wave -noupdate /cpu_testbench/clk
add wave -noupdate /cpu_testbench/reset
add wave -noupdate /cpu_testbench/fullRegister
add wave -noupdate /cpu_testbench/overflow
add wave -noupdate /cpu_testbench/negative
add wave -noupdate /cpu_testbench/zero
add wave -noupdate /cpu_testbench/carryout
add wave -noupdate /cpu_testbench/instructionAddress
add wave -noupdate /cpu_testbench/mem
add wave -noupdate /cpu_testbench/ALUOpp
add wave -noupdate /cpu_testbench/UncondBr
add wave -noupdate /cpu_testbench/Branch
add wave -noupdate /cpu_testbench/MemRead
add wave -noupdate /cpu_testbench/MemToReg
add wave -noupdate /cpu_testbench/MemWrite
add wave -noupdate /cpu_testbench/RegWrite
add wave -noupdate /cpu_testbench/BL
add wave -noupdate /cpu_testbench/ALUSrc
add wave -noupdate /cpu_testbench/BR
add wave -noupdate /cpu_testbench/ALUI
add wave -noupdate /cpu_testbench/BLT
add wave -noupdate /cpu_testbench/Reg2Loc
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

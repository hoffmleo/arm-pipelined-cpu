onerror {resume}
quietly WaveActivateNextPane {} 0
# Add waves
add wave -noupdate /EX_MEM_testbench/PC_4_in
add wave -noupdate /EX_MEM_testbench/ALUOut_in
add wave -noupdate /EX_MEM_testbench/MemToReg_in
add wave -noupdate /EX_MEM_testbench/RegWrite_in
add wave -noupdate /EX_MEM_testbench/Rd_in
add wave -noupdate /EX_MEM_testbench/BL_in
add wave -noupdate /EX_MEM_testbench/Db_in
add wave -noupdate /EX_MEM_testbench/MemRead_in
add wave -noupdate /EX_MEM_testbench/MemWrite_in
add wave -noupdate /EX_MEM_testbench/PC_4_out
add wave -noupdate /EX_MEM_testbench/ALUOut_out
add wave -noupdate /EX_MEM_testbench/MemToReg_out
add wave -noupdate /EX_MEM_testbench/RegWrite_out
add wave -noupdate /EX_MEM_testbench/Rd_out
add wave -noupdate /EX_MEM_testbench/BL_out
add wave -noupdate /EX_MEM_testbench/Db_out
add wave -noupdate /EX_MEM_testbench/MemRead_out
add wave -noupdate /EX_MEM_testbench/MemWrite_out
add wave -noupdate /EX_MEM_testbench/clk
add wave -noupdate /EX_MEM_testbench/reset
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

# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./adder_1bit.sv"
vlog "./adder_64bit.sv"
vlog "./bitwise_and.sv"
vlog "./bitwise_xor.sv"
vlog "./bitwise_or.sv"
vlog "./bitwise_not.sv"
vlog "./mux2_1.sv"
vlog "./mux8_1.sv"
vlog "./mux64_8_1.sv"
vlog "./alu.sv"
vlog "./alustim.sv"
vlog "./signExtender.sv"
vlog "./shifter.sv"
vlog "./zeroExtend.sv"
vlog "./control.sv"
vlog "./mux5_2_1.sv"
vlog "./singleRegister.sv"
vlog "./DFF_Enabled.sv"
vlog "./D_FF.sv"
vlog "./zeroExtend.sv"
vlog "./signExtender_9.sv"
vlog "./signExtender_19.sv"
vlog "./signExtender_26.sv"
vlog "./datamem.sv"
vlog "./instructmem.sv"
vlog "./regfile.sv"
vlog "./mux64_2_1.sv"
vlog "./control.sv"
vlog "./addby4.sv"
vlog "./mux64_32_1.sv"
vlog "./mux32_1.sv"
vlog "./decoder5_32.sv"
vlog "./mux5_2_1.sv"
vlog "./mux4_1.sv"
vlog "./mux64_4_1.sv"
vlog "./cpu.sv"
vlog "./zeroCheck.sv"
vlog "./RnAndRmOutMUX.sv"
vlog "./IF_ID.sv"
vlog "./ID_EX.sv"
vlog "./EX_MEM.sv"
vlog "./MEM_WB.sv"
vlog "./forward.sv"
vlog "./ForwardingConditionals.sv"
vlog "./forwardingUnit.sv"
vlog "./RnAndRmOutMUX.sv"
vlog "./branchLogic.sv"
vlog "./pipelinedCPU.sv"
vlog "./ID_EX.sv"
vlog "./pipelinedCPU.sv"
vlog "./pipelinedCPU.sv"
vlog "./instructmem.sv"
vlog "./pipelinedCPU.sv"
vlog "./pipelinedCPU.sv"
vlog "./D_FF_Negative.sv"
vlog "./pipelinedCPU.sv"
vlog "./singleRegister_Negative.sv"
vlog "./pipelinedCPU.sv"
vlog "./FWRD_UNIT.sv"
vlog "./FWRD_UNIT.sv"
vlog "./RnAndRmOutMUX.sv"
# Add vlog

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs=+acc -t 1ps -lib work pipelinedCPU_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do pipelinedCPU.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End

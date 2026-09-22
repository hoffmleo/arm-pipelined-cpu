# Project notes

## Why this file exists

This document is a refresher for the project author and a guide for anyone reviewing the repository. The project was completed in June, so it records the architecture, terminology, and important design decisions in one place rather than requiring the reader to reconstruct the design from every SystemVerilog file.

## What was built

The project implemented a 64-bit pipelined CPU using a course-defined subset of an ARM/LEGv8-style ISA. The processor accepts 32-bit instructions, decodes them into control signals, reads operands from a 32-entry register file, performs an operation in the ALU, optionally accesses data memory, and writes a result back to the register file.

The processor was organized into five stages:

1. **IF — Instruction Fetch:** read the instruction and calculate the sequential PC.
2. **ID — Instruction Decode:** decode the opcode, select source registers, read operands, and calculate branch information.
3. **EX — Execute:** perform ALU operations, choose immediate/register operands, and evaluate relevant conditions.
4. **MEM — Memory:** read or write the modeled data memory for load/store instructions.
5. **WB — Write Back:** select the final result and write it into the register file.

Pipeline registers carry both data and control signals from one stage to the next. This is why files such as `ID_EX.sv`, `EX_MEM.sv`, and `MEM_WB.sv` contain many individual flip-flops: they preserve the state of an instruction while later instructions occupy earlier stages.

## How the important pieces fit together

### Control unit

`control.sv` uses the instruction opcode to generate signals such as `RegWrite`, `MemRead`, `MemWrite`, `MemToReg`, `ALUSrc`, `ALUI`, `Branch`, and `UncondBr`. These signals tell the datapath what each instruction should do.

### Register file

`regfile.sv` provides two combinational read paths and one clocked write path. Thirty-one registers can be written, while register 31 is forced to zero to model the architecture's zero register behavior.

### ALU

`alu.sv` selects among pass-through, addition, subtraction, AND, OR, and XOR operations. It also produces negative, zero, overflow, and carry-out flags. The ALU is assembled from smaller modules including `adder_64bit.sv` and the bitwise operation modules.

### Memory

`instructmem.sv` models instruction ROM and loads a binary benchmark file. `datamem.sv` models byte-addressed data memory, supports transfers up to a double word, and checks alignment and bounds during simulation.

### Branches

The processor sign-extends branch immediates, shifts them by two to account for word alignment, adds them to the current PC, and selects the resulting address when the branch condition is satisfied. Register-based branching uses a register value as the target.

### Forwarding

`ForwardingConditionals.sv` compares a source register with a destination register and checks whether the later instruction will write a result. `FWRD_UNIT.sv` combines those comparisons into forwarding selections for the two ALU operands. This reduces stalls caused by ordinary read-after-write dependencies.

## Simulation and waveforms

The `.do` files are ModelSim command files. They are not RTL modules. Most add signals from a testbench to the waveform viewer, while `runlab.do` creates the work library, compiles modules, starts the simulator, loads the main waveform file, and runs the test.

For a useful integrated simulation, inspect:

- `pc_IF`, `pc_ID`, `pc_4_EX`, `pc_4_MEM`, and `pc_4_WB`;
- instructions in IF, ID, and EX;
- register-file values;
- ALU inputs and result;
- memory read/write control;
- branch target and branch-taken signals; and
- `fwdA_sel` and `fwdB_sel`.

## Historical files and caveats

The original working directory included exploratory versions, duplicated compile commands, comments from debugging, and some modules that were superseded by later versions. Those are useful evidence of the development process, but they should be treated as a historical course snapshot rather than a polished reusable CPU IP block.

The project did **not** need to include DE1-SoC FPGA programming files for the portfolio version. FPGA constraint/configuration files were intentionally excluded because the work being presented here was the SystemVerilog design and simulation project, not a completed DE1-SoC deployment.

Some original source names and references may need cleanup before a fresh compile, including historical naming differences such as `FWCond_ID.sv` versus `ForwardingConditionals.sv`, and references to modules that may have existed in earlier versions. This README describes the design; it does not claim that an unmodified historical snapshot is immediately reproducible with every simulator.

## Suggested portfolio description

> Designed and simulated a 64-bit, five-stage pipelined CPU in SystemVerilog using an ARM/LEGv8-style instruction subset. Implemented the datapath, control unit, register file, ALU, instruction/data memory models, pipeline registers, branch logic, and forwarding unit, then verified individual components and integrated processor behavior with ModelSim waveforms.

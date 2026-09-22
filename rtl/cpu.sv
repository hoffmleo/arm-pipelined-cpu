`timescale 1ns/10ps
module cpu(clk, reset, fullRegister, overflow, negative, zero, carryout, instructionAddress, mem, ALUOpp, UncondBr, Branch, MemRead, MemToReg, MemWrite, RegWrite, BL, ALUSrc, BR, ALUI, BLT, Reg2Loc);
	input logic clk, reset;
	parameter delay = 50;
	`define DATA_MEM_SIZE		1024
	
	// PC variables
	logic [31:0] instructionData;
	output logic [63:0] instructionAddress;
	
	// ALU variable
	logic [63:0] result;
	
	// Register hub variables 	
	logic [63:0] ReadData1, ReadData2;
	
	// Non-branch variable
	logic [63:0] non_branch_add; 
		
	// Select all control variables
	output logic [1:0] ALUOpp; // 00, 10, 11
   output logic UncondBr;
   output logic Branch;
   output logic MemRead;
   output logic MemToReg;
   output logic MemWrite;
   output logic RegWrite;
   output logic BL;
   output logic ALUSrc;
   output logic BR;
   output logic ALUI;
   output logic BLT;
   output logic Reg2Loc;
	control controlModule(instructionData[31:21], ALUOpp, UncondBr, Branch, MemRead, 
								 MemToReg, MemWrite, RegWrite, BL, ALUSrc, BR, ALUI, BLT, Reg2Loc);
		
	
	// Instruction variables and instantiation (uses instructionData, declared above for control usage)
	instructmem instructionModule(instructionAddress, instructionData, clk);
	
	
	// Data memory variables and instantiation
	logic [63:0] MemReadData;
	logic [63:0] WriteDataTemp;
	output logic [7:0] mem [`DATA_MEM_SIZE-1:0];
	datamem RAM(result, MemWrite, MemRead, ReadData2, clk, 4'b1000, MemReadData, mem);
	mux64_2_1 muxMemoryFinal(WriteDataTemp, {MemReadData, result}, MemToReg); // Result = ALU result
	
	
	// Register hub variables and instantiation
	logic	[4:0] 	ReadRegister2, WriteRegister;
	logic [63:0]	WriteData;
	output logic [31:0][63:0] fullRegister;
	regfile registerModule(ReadData1, ReadData2, WriteData, instructionData[9:5], ReadRegister2, WriteRegister, RegWrite, clk, fullRegister);
	mux64_2_1 muxRegWriteData(WriteData, {non_branch_add, WriteDataTemp}, BL);
	mux5_2_1 muxForX30(WriteRegister, {5'b11110, instructionData[4:0]}, BL); 
	mux5_2_1 muxForRdVSRm(ReadRegister2, {instructionData[20:16], instructionData[4:0]}, Reg2Loc);

	 
	// ALU variables and instantiation
	logic overflowTemp, negativeTemp, zeroTemp, carryoutTemp;
	output logic overflow, negative, zero, carryout;
	logic [8:0] in;
	logic [63:0] DTAddrOut;
	logic [63:0] SRCMuxChoice;
	logic [63:0] ExtenderOut;
	logic [63:0] ReadDataBFinal;
	signExtender_9 DTAddr(instructionData[20:12], DTAddrOut);
	zeroExtend extender(instructionData[21:10], ExtenderOut);
	mux64_2_1 muxDTAddr(SRCMuxChoice, {DTAddrOut, ReadData2}, ALUSrc); 
	mux64_2_1 muxALUI(ReadDataBFinal, {ExtenderOut, SRCMuxChoice}, ALUI);
	alu ALU(ReadData1, ReadDataBFinal, {1'b0, ALUOpp[1], ALUOpp[0]}, result, negativeTemp, zeroTemp, overflowTemp, carryoutTemp);
	
	// Flag registers
	logic enableFlags, not23;
	not #delay (not23, instructionData[23]);
	and #delay (enableFlags, instructionData[25], instructionData[24], not23);
	DFF_Enabled negativeFlag(reset, enableFlags, negativeTemp, negative, clk);
	DFF_Enabled overflowFlag(reset, enableFlags, overflowTemp, overflow, clk);
	DFF_Enabled carryoutFlag(reset, enableFlags, carryoutTemp, carryout, clk);
	DFF_Enabled zeroFlag(reset, enableFlags, zeroTemp, zero, clk); 
	
	
	// PC
   logic [63:0] PCin;
   singleRegister PC (reset, 1'b1, PCin, instructionAddress, clk);
	
   // Branch Logic 
   logic [63:0] ex_cond_add, ex_branch_add; 
   signExtender_19 wowa (.in(instructionData[23:5]), .out(ex_cond_add));
   signExtender_26 wowb (.in(instructionData[25:0]), .out(ex_branch_add));

   logic [63:0] branch; 
   mux64_2_1 wowza (.out(branch), .in({ex_branch_add, ex_cond_add}), .sel(UncondBr));

   logic [63:0] branch_shifted;
   shifter wowshift (.in(branch), .out(branch_shifted));

   logic [63:0] branch_addition; 
   adder_64bit wowbranch (.A(instructionAddress), .B(branch_shifted), .cin(1'b0), .sum(branch_addition), .cout(), .overflow()); // Ignores carry/overflow errors...should be okay

   logic [63:0] branch_address;
   mux64_2_1 adder_to_branch_maybe (.out(branch_address), .in({ReadData2, branch_addition}), .sel(BR));

   // Non-branch
   addby4 wowab (.in(instructionAddress), .out(non_branch_add)); 
	
	// Branching from flags to BrTaken
	logic overflowNegativeXOR, chosenFlagTrue, branchingForSure, br_taken;
	xor #delay flagXOR(overflowNegativeXOR, overflow, negative); //Use overflow and negative temps instead?
	mux2_1 flagMUX(.out(chosenFlagTrue), .i0(zeroTemp), .i1(overflowNegativeXOR), .sel(BLT));
	and #delay flagBranchAND(branchingForSure, chosenFlagTrue, Branch);
	or #delay eitherBranchVersion(br_taken, UncondBr, branchingForSure);

   // Selecting if branched or not, giving new "PC" value
   mux64_2_1 ending (.out(PCin), .in({branch_address, non_branch_add}), .sel(br_taken)); 
	
endmodule



module cpu_testbench();
    logic clk, reset;
	 logic [31:0][63:0] fullRegister;
	 logic overflow, negative, zero, carryout;
	 logic [63:0] instructionAddress;
	 logic [7:0] mem [`DATA_MEM_SIZE-1:0]; 
	 parameter delay = 1000; // 10000
	 
	 logic [1:0]ALUOpp;
	 logic UncondBr, Branch, MemRead, MemToReg, MemWrite, RegWrite, BL, ALUSrc, BR, ALUI, BLT, Reg2Loc;
	 
    cpu duf (clk, reset, fullRegister, overflow, negative, zero, carryout, instructionAddress, mem, ALUOpp, UncondBr, Branch, MemRead, MemToReg, MemWrite, RegWrite, BL, ALUSrc, BR, ALUI, BLT, Reg2Loc);
	 
	 integer i;
	 initial begin // Set up the clock FOR TESTING
		clk <= 0;
		forever #(450) clk <= ~clk; // 2500
	 end
	
    initial begin
        reset <= 1; @(posedge clk);
        reset <= 0; @(posedge clk);
    end

endmodule






//`timescale 1ns/10ps
//module cpu(clk, reset);
//	input logic clk, reset;
//	parameter delay = 50;
//	
//	
//	// PC variables
//	logic [31:0] instructionData;
//	logic [63:0] instructionAddress;
//	
//	// ALU variable
//	logic [63:0] result;
//	
//	// Register hub variables 	
//	logic [63:0]	ReadData1, ReadData2;
//	
//	// Non-branch variable
//	logic [63:0] non_branch_add; 
//		
//	// Select all control variables
//	logic [1:0] ALUOpp; // 00, 10, 11
//   logic UncondBr;
//   logic Branch;
//   logic MemRead;
//   logic MemToReg;
//   logic MemWrite;
//   logic RegWrite;
//   logic BL;
//   logic ALUSrc;
//   logic BR;
//   logic ALUI;
//   logic BLT;
//   logic Reg2Loc;
//	control controlModule(instructionData[31:2], ALUOpp, UncondBr, Branch, MemRead, 
//								 MemToReg, MemWrite, RegWrite, BL, ALUSrc, BR, ALUI, BLT, Reg2Loc);
//		
//	
//	// Instruction variables and instantiation (uses instructionData, declared above for control usage)
//	instructmem instructionModule(instructionAddress, instructionData, clk);
//	
//	
//	// Data memory variables and instantiation
//	logic [63:0] MemReadData;
//	logic [63:0] WriteDataTemp;
//	datamem RAM(result, MemWrite, MemRead, ReadData2, clk, 4'b1000, MemReadData);
//	mux64_2_1 muxMemoryFinal(WriteDataTemp, '{MemReadData, result}, MemToReg); // Result = ALU result
//	
//	
//	// Register hub variables and instantiation
//	logic	[4:0] 	ReadRegister2, WriteRegister;
//	logic [63:0]	WriteData;
//	regfile registerModule(ReadData1, ReadData2, WriteData, instructionData[9:5], ReadRegister2, WriteRegister, RegWrite, clk);
//	mux64_2_1 muxRegWriteData(WriteData, '{non_branch_add, WriteDataTemp}, BL);
//	mux5_2_1 muxForX30(WriteRegister, '{5'b11110, instructionData[4:0]}, BL); 
//	mux5_2_1 muxForRdVSRm(ReadRegister2, '{instructionData[20:16], instructionData[4:0]}, Reg2Loc);
//	
//	
//	// ALU variables and instantiation
//	logic overflowTemp, negativeTemp, zeroTemp, carryoutTemp, overflow, negative, zero, carryout;
//	logic [8:0] in;
//	logic [63:0] DTAddrOut;
//	logic [63:0] SRCMuxChoice;
//	logic [63:0] ExtenderOut;
//	logic [63:0] ReadDataBFinal;
//	signExtender_9 DTAddr(instructionData[20:12], DTAddrOut);
//	zeroExtend extender(instructionData[21:10], ExtenderOut);
//	mux64_2_1 muxDTAddr(SRCMuxChoice, '{DTAddrOut, ReadData2}, ALUSrc); // Proper formatting for array?
//	mux64_2_1 muxALUI(ReadDataBFinal, '{ExtenderOut, SRCMuxChoice}, ALUI); // Proper formatting for array?	
//	alu ALU(ReadData1, ReadDataBFinal, {1'b0, ALUOpp[1], ALUOpp[0]}, result, negativeTemp, zeroTemp, overflowTemp, carryoutTemp);
//	
//	// Flag registers
//	logic enableFlags;
//	and #delay (enableFlags, instructionData[27], instructionData[25], instructionData[24]); // MAY BE A BUG SOURCE (unlikely, but possible)
//	DFF_Enabled negativeFlag(reset, enableFlags, negativeTemp, negative, clk);
//	DFF_Enabled overflowFlag(reset, enableFlags, overflowTemp, overflow, clk);
//	DFF_Enabled carryoutFlag(reset, enableFlags, carryoutTemp, carryout, clk);
//	DFF_Enabled zeroFlag(reset, enableFlags, zeroTemp, zero, clk); 
//	
//	
//	// PC
//	// logic [18:0] cond_add; // instructionData[23:5] FIXED
//	// logic [25:0] branch_add; // instructionData[25:0] FIXED
//   logic [63:0] PCin;
//   singleRegister PC (reset, 1'b1, PCin, instructionAddress, clk);
//
//   // Branch Logic 
//   logic [63:0] ex_cond_add, ex_branch_add; 
//   signExtender_19 wowa (.in(instructionData[23:5]), .out(ex_cond_add));
//   signExtender_26 wowb (.in(instructionData[25:0]), .out(ex_branch_add));
//
//   logic [63:0] branch; 
//   mux64_2_1 wowza (.out(branch), .in({ex_branch_add, ex_cond_add}), .sel(UncondBr));
//
//   logic [63:0] branch_shifted;
//   shifter wowshift (.in(branch), .out(branch_shifted));
//
//   logic [63:0] branch_addition; 
//   adder_64bit wowbranch (.A(instructionAddress), .B(branch_shifted), .cin(1'b0), .sum(branch_addition), .cout(), .overflow()); // Ignores carry/overflow errors...should be okay
//
//   logic [63:0] branch_address;
//   mux64_2_1 adder_to_branch_maybe (.out(branch_address), .in({ReadData2, branch_addition}), .sel(BR));
//
//   // Non-branch
//   addby4 wowab (.in(instructionAddress), .out(non_branch_add)); // GET THIS MODULE FROM LEO (CRITICAL)
//	
//	// Branching from flags to BrTaken
//	logic overflowNegativeXOR, chosenFlagTrue, branchingForSure, br_taken;
//	xor #delay flagXOR(overflowNegativeXOR, overflow, negative);
//	mux2_1 flagMUX(.out(chosenFlagTrue), .i0(zero), .i1(overflowNegativeXOR), .sel(BLT));
//	and #delay flagBranchAND(branchingForSure, chosenFlagTrue, Branch);
//	or #delay eitherBranchVersion(br_taken, UncondBr, branchingForSure);
//
//   // Selecting if branched or not, giving new "PC" value
//   mux64_2_1 ending (.out(PCin), .in({branch_address, non_branch_add}), .sel(br_taken)); 
//	
//endmodule
//
//
//
//module cpu_testbench();
//	logic clk, reset;
//	parameter delay = 10000;
//	
//	initial begin // Set up the clock FOR TESTING
//		clk <= 0;
//		forever #(2500) clk <= ~clk;
//	end
//	
//	// Finish this (CRITICAL)
//
//
//endmodule
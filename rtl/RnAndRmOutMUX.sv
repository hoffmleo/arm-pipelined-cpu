`timescale 1ps/1ps
module RnAndRmOutMUX(Branch, UncondBr, pipelineRegInstructions25to22, pipeRegs31to28, rnIn, rmIn, rnOut, rmOut);
	input logic Branch, UncondBr;
	input logic [3:0] pipelineRegInstructions25to22;
	input logic [3:0] pipeRegs31to28;
	input logic [4:0] rnIn, rmIn;
	output logic [4:0] rnOut, rmOut;
	logic inst23wanted, isRType, isBranchInst, isCBZ, iseither, isnt30;
	logic isSTUR, isnt22; 
	parameter delay = 50;
	
	not #delay (inst23Wanted, pipelineRegInstructions25to22[1]);
	and #delay (isRType, inst23Wanted, pipelineRegInstructions25to22[2], pipelineRegInstructions25to22[3]); 
	or #delay (isBranchInst, Branch, UncondBr); 

	logic buffer_cbz;
	not #delay (isnt30, pipeRegs31to28[2]);
	and #delay (buffer_cbz, pipeRegs31to28[3], isnt30, pipeRegs31to28[1]);
	and #delay (isCBZ, pipeRegs31to28[0], buffer_cbz);

	logic buff_STUR;
	not #delay (isnt22, pipelineRegInstructions25to22[0]);
	and #delay (buff_STUR, pipeRegs31to28[3], pipeRegs31to28[2], pipeRegs31to28[1]);
	and #delay (isSTUR, buff_STUR, pipeRegs31to28[0], isnt22);

	or #delay (iseither, isCBZ, isRType, isSTUR);
	
    mux5_2_1 rnMux(rnOut, {5'b11111, rnIn}, isBranchInst);
	mux5_2_1 rmMux(rmOut, {rmIn, 5'b11111}, iseither); // need to use for cbz as well!
	
endmodule

module RnAndRmOutMUX_testbench();
   logic Branch, UncondBr;
	logic [3:0] pipelineRegInstructions25to22;
	logic [3:0] pipeRegs31to28;
	logic [4:0] rnIn, rmIn;
	logic [4:0] rnOut, rmOut;
   parameter delay = 1000;
	
	RnAndRmOutMUX muxes(Branch, UncondBr, pipelineRegInstructions25to22, pipeRegs31to28, rnIn, rmIn, rnOut, rmOut);
	
   initial begin
		// ADDI 
		pipeRegs31to28 = 4'b1001;
		Branch = 0; UncondBr = 0; pipelineRegInstructions25to22 = 4'b0100; rnIn = 5'b00011; rmIn = 5'b11000; #delay;
		
		// STUR
		pipeRegs31to28 = 4'b1111;
		Branch = 0; UncondBr = 0; pipelineRegInstructions25to22 = 4'b0000; rnIn = 5'b01111; rmIn = 5'b11111; #delay;
						
		// LDUR 
		pipeRegs31to28 = 4'b1111;
		Branch = 0; UncondBr = 0; pipelineRegInstructions25to22 = 4'b0010; rnIn = 5'b10000; rmIn = 5'b00001; #delay;
		
		// BL
		pipeRegs31to28 = 4'b1001;
		Branch = 1; UncondBr = 1; pipelineRegInstructions25to22 = 4'b0000; rnIn = 5'b00011; rmIn = 5'b11000; #delay; 
		Branch = 0; #delay;
		Branch = 1; UncondBr = 0; #delay;
		
		// BR
		pipeRegs31to28 = 4'b1101;
		Branch = 1; UncondBr = 1; pipelineRegInstructions25to22 = 4'b1000; rnIn = 5'b10000; rmIn = 5'b00001; #delay;
		Branch = 0; #delay;
		Branch = 1; UncondBr = 0; #delay;
		
		// B
		pipeRegs31to28 = 4'b0001;
		Branch = 1; UncondBr = 1; pipelineRegInstructions25to22 = 4'b0000; rnIn = 5'b00011; rmIn = 5'b11000; #delay;
		Branch = 0; #delay;
		Branch = 1; UncondBr = 0; #delay;
		
		// CBZ
		pipeRegs31to28 = 4'b1011;
		Branch = 1; UncondBr = 1; pipelineRegInstructions25to22 = 4'b0000; rnIn = 5'b10000; rmIn = 5'b00001; #delay;
		Branch = 0; #delay;
		Branch = 1; UncondBr = 0; #delay;

		// SUBS
		pipeRegs31to28 = 4'b1110;
		Branch = 0; UncondBr = 0; pipelineRegInstructions25to22 = 4'b1100; rnIn = 5'b00011; rmIn = 5'b11000; #delay;
		
		// ADDS
		pipeRegs31to28 = 4'b1010;
		Branch = 0; UncondBr = 0; pipelineRegInstructions25to22 = 4'b1100; rnIn = 5'b10000; rmIn = 5'b00001; #delay;	
	end
endmodule


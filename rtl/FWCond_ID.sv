`timescale 1ps/1ps
module FWCond_ID(Rd_FW, Src, RegWrite, hazardDetected);
	input logic [4:0] Rd_FW, Src;
	input logic RegWrite;
	output logic hazardDetected;
	logic RdAnd1, RdAnd2, isNotReg31, xnor1, xnor2, xnor3, xnor4, xnor5, equal, equal2;
	parameter delay = 50;
	
	and #delay (RdAnd1, Rd_FW[0], Rd_FW[1], Rd_FW[2]);
	and #delay (RdAnd2, Rd_FW[3], Rd_FW[4], RdAnd1);
	not #delay (isNotReg31, RdAnd2);
	xnor #delay (xnor1, Rd_FW[0], Src[0]);
	xnor #delay (xnor2, Rd_FW[1], Src[1]);
	xnor #delay (xnor3, Rd_FW[2], Src[2]);
	xnor #delay (xnor4, Rd_FW[3], Src[3]);
	xnor #delay (xnor5, Rd_FW[4], Src[4]);
	and #delay (equal, xnor1, xnor2, xnor3);
	and #delay (equal2, equal, xnor4, xnor5);
	and #delay (hazardDetected, isNotReg31, RegWrite, equal2);

endmodule

module ForwardingConditionals_testbench();
	logic [4:0] Rd_FW, Src;
	logic RegWrite;
	logic hazardDetected;
	parameter delay = 1000;
	
	ForwardingConditionals dut(Rd_FW, Src, RegWrite, hazardDetected);
	
	initial begin
		Rd_FW = 5'b11111; Src = 5'b11111; RegWrite = 1'b0; #delay;
		Rd_FW = 5'b11111; Src = 5'b11111; RegWrite = 1'b1; #delay;
		
		Rd_FW = 5'b00000; Src = 5'b00000; RegWrite = 1'b0; #delay;
		Rd_FW = 5'b00000; Src = 5'b00000; RegWrite = 1'b1; #delay;
		
		Rd_FW = 5'b10101; Src = 5'b10101; RegWrite = 1'b0; #delay;
		Rd_FW = 5'b10101; Src = 5'b10101; RegWrite = 1'b1; #delay;
		
		Rd_FW = 5'b11111; Src = 5'b10101; RegWrite = 1'b0; #delay;
		Rd_FW = 5'b11111; Src = 5'b10101; RegWrite = 1'b1; #delay;
	
	end

endmodule
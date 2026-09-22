`timescale 1ps/1ps
module ForwardingConditionals(Rd_EX_MEM_Or_MEM_WB, Src_ID_EX, RegWrite_EX_MEM, hazardDetected);

	input logic [4:0] Rd_EX_MEM_Or_MEM_WB, Src_ID_EX;
	input logic RegWrite_EX_MEM;
	output logic hazardDetected;
	logic RdAnd1, RdAnd2, isNotReg31, xnor1, xnor2, xnor3, xnor4, xnor5, equal, equal2;
	parameter delay = 50;
	
	and #delay (RdAnd1, Rd_EX_MEM_Or_MEM_WB[0], Rd_EX_MEM_Or_MEM_WB[1], Rd_EX_MEM_Or_MEM_WB[2]);
	and #delay (RdAnd2, Rd_EX_MEM_Or_MEM_WB[3], Rd_EX_MEM_Or_MEM_WB[4], RdAnd1);
	not #delay (isNotReg31, RdAnd2);
	xnor #delay (xnor1, Rd_EX_MEM_Or_MEM_WB[0], Src_ID_EX[0]);
	xnor #delay (xnor2, Rd_EX_MEM_Or_MEM_WB[1], Src_ID_EX[1]);
	xnor #delay (xnor3, Rd_EX_MEM_Or_MEM_WB[2], Src_ID_EX[2]);
	xnor #delay (xnor4, Rd_EX_MEM_Or_MEM_WB[3], Src_ID_EX[3]);
	xnor #delay (xnor5, Rd_EX_MEM_Or_MEM_WB[4], Src_ID_EX[4]);
	and #delay (equal, xnor1, xnor2, xnor3);
	and #delay (equal2, equal, xnor4, xnor5);
	and #delay (hazardDetected, isNotReg31, RegWrite_EX_MEM, equal2);

endmodule

module ForwardingConditionals_testbench();
	logic [4:0] Rd_EX_MEM_Or_MEM_WB, Src_ID_EX;
	logic RegWrite_EX_MEM;
	logic hazardDetected;
	parameter delay = 1000;
	
	ForwardingConditionals dut(Rd_EX_MEM_Or_MEM_WB, Src_ID_EX, RegWrite_EX_MEM, hazardDetected);
	
	initial begin
		Rd_EX_MEM_Or_MEM_WB = 5'b11111; Src_ID_EX = 5'b11111; RegWrite_EX_MEM = 1'b0; #delay;
		Rd_EX_MEM_Or_MEM_WB = 5'b11111; Src_ID_EX = 5'b11111; RegWrite_EX_MEM = 1'b1; #delay;
		
		Rd_EX_MEM_Or_MEM_WB = 5'b00000; Src_ID_EX = 5'b00000; RegWrite_EX_MEM = 1'b0; #delay;
		Rd_EX_MEM_Or_MEM_WB = 5'b00000; Src_ID_EX = 5'b00000; RegWrite_EX_MEM = 1'b1; #delay;
		
		Rd_EX_MEM_Or_MEM_WB = 5'b10101; Src_ID_EX = 5'b10101; RegWrite_EX_MEM = 1'b0; #delay;
		Rd_EX_MEM_Or_MEM_WB = 5'b10101; Src_ID_EX = 5'b10101; RegWrite_EX_MEM = 1'b1; #delay;
		
		Rd_EX_MEM_Or_MEM_WB = 5'b11111; Src_ID_EX = 5'b10101; RegWrite_EX_MEM = 1'b0; #delay;
		Rd_EX_MEM_Or_MEM_WB = 5'b11111; Src_ID_EX = 5'b10101; RegWrite_EX_MEM = 1'b1; #delay;
	
	end

endmodule
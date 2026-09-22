// Check timescale

`timescale 1ps/1ps
module forwardingUnit(Rd_EX_MEM, Rd_MEM_WB, Rn_ID_EX, Rm_ID_EX, RegWrite_EX_MEM, RegWrite_MEM_WB, FwdA, FwdB);
	input logic [4:0] Rd_EX_MEM, Rd_MEM_WB, Rn_ID_EX, Rm_ID_EX;
	input logic RegWrite_EX_MEM, RegWrite_MEM_WB;
	output logic [1:0] FwdA, FwdB;
	
	logic hazardDetectedRn, hazardDetectedRm, hazardDetectedRnWB, hazardDetectedRmWB;
	logic notHazardDetectedRn, notHazardDetectedRm, onlyWBHazardRn, onlyWBHazardRm;
	parameter delay = 50;
	
	// EX/MEM forwarding (Rn)
	ForwardingConditionals exmemHazardRn(Rd_EX_MEM, Rn_ID_EX, RegWrite_EX_MEM, hazardDetectedRn);
	
	// EX/MEM forwarding (Rm)
	ForwardingConditionals exmemHazardRm(Rd_EX_MEM, Rm_ID_EX, RegWrite_EX_MEM, hazardDetectedRm);
	
	// MEM/WB forwarding (Rn)
	ForwardingConditionals memwbHazardRn(Rd_MEM_WB, Rn_ID_EX, RegWrite_MEM_WB, hazardDetectedRnWB);
	
	// MEM/WB forwarding (Rm)
	ForwardingConditionals memwbHazardRm(Rd_MEM_WB, Rm_ID_EX, RegWrite_MEM_WB, hazardDetectedRmWB);
	not #delay (notHazardDetectedRn, hazardDetectedRn);
	and #delay (onlyWBHazardRn, notHazardDetectedRn, hazardDetectedRnWB);
	buf #delay (FwdA[1], hazardDetectedRn);
	buf #delay (FwdA[0], onlyWBHazardRn);
	
	not #delay (notHazardDetectedRm, hazardDetectedRm);
	and #delay (onlyWBHazardRm, notHazardDetectedRm, hazardDetectedRmWB);
	buf #delay (FwdB[1], hazardDetectedRm);
	buf #delay (FwdB[0], onlyWBHazardRm);
	
endmodule



module forwardingUnit_testbench();
	logic [4:0] Rd_EX_MEM, Rd_MEM_WB, Rn_ID_EX, Rm_ID_EX;
	logic RegWrite_EX_MEM, RegWrite_MEM_WB;
	logic [1:0] FwdA, FwdB;
	parameter delay = 1000;
	
	forwardingUnit dut(Rd_EX_MEM, Rd_MEM_WB, Rn_ID_EX, Rm_ID_EX, RegWrite_EX_MEM, RegWrite_MEM_WB, FwdA, FwdB);
		
	initial begin
		Rd_EX_MEM = 5'b11111; Rd_MEM_WB = 5'b11111; Rn_ID_EX = 5'b11111; Rm_ID_EX = 5'b11111; RegWrite_EX_MEM = 1'b1; RegWrite_MEM_WB = 1'b1; #delay;
		Rd_EX_MEM = 5'b11111; Rd_MEM_WB = 5'b11111; Rn_ID_EX = 5'b11111; Rm_ID_EX = 5'b11111; RegWrite_EX_MEM = 1'b0; RegWrite_MEM_WB = 1'b0; #delay;
		RegWrite_MEM_WB = 1; RegWrite_EX_MEM = 0; #delay;
		RegWrite_MEM_WB = 0; RegWrite_EX_MEM = 1; #delay;
		
		Rd_EX_MEM = 5'b00000; Rd_MEM_WB = 5'b00000; Rn_ID_EX = 5'b00000; Rm_ID_EX = 5'b00000; RegWrite_EX_MEM = 1'b1; RegWrite_MEM_WB = 1'b1; #delay;
		Rd_EX_MEM = 5'b00000; Rd_MEM_WB = 5'b00000; Rn_ID_EX = 5'b00000; Rm_ID_EX = 5'b00000; RegWrite_EX_MEM = 1'b0; RegWrite_MEM_WB = 1'b0; #delay;
		RegWrite_MEM_WB = 1; RegWrite_EX_MEM = 0; #delay;
		RegWrite_MEM_WB = 0; RegWrite_EX_MEM = 1; #delay;
		
		Rd_EX_MEM = 5'b11110; Rd_MEM_WB = 5'b10111; Rn_ID_EX = 5'b00000; Rm_ID_EX = 5'b00000; RegWrite_EX_MEM = 1'b1; RegWrite_MEM_WB = 1'b1; #delay;
		Rd_EX_MEM = 5'b11110; Rd_MEM_WB = 5'b10111; Rn_ID_EX = 5'b00000; Rm_ID_EX = 5'b00000; RegWrite_EX_MEM = 1'b0; RegWrite_MEM_WB = 1'b0; #delay;
		RegWrite_MEM_WB = 1; RegWrite_EX_MEM = 0; #delay;
		RegWrite_MEM_WB = 0; RegWrite_EX_MEM = 1; #delay;
		
		Rd_EX_MEM = 5'b11110; Rd_MEM_WB = 5'b11111; Rn_ID_EX = 5'b11110; Rm_ID_EX = 5'b11111; RegWrite_EX_MEM = 1'b1; RegWrite_MEM_WB = 1'b1; #delay;
		Rd_EX_MEM = 5'b11110; Rd_MEM_WB = 5'b11111; Rn_ID_EX = 5'b11110; Rm_ID_EX = 5'b11111; RegWrite_EX_MEM = 1'b0; RegWrite_MEM_WB = 1'b0; #delay;
		RegWrite_MEM_WB = 1; RegWrite_EX_MEM = 0; #delay;
		RegWrite_MEM_WB = 0; RegWrite_EX_MEM = 1; #delay;
		
		Rd_EX_MEM = 5'b11101; Rd_MEM_WB = 5'b11110; Rn_ID_EX = 5'b00000; Rm_ID_EX = 5'b11110; RegWrite_EX_MEM = 1'b1; RegWrite_MEM_WB = 1'b1; #delay;
		Rd_EX_MEM = 5'b11101; Rd_MEM_WB = 5'b11110; Rn_ID_EX = 5'b00000; Rm_ID_EX = 5'b11110; RegWrite_EX_MEM = 1'b0; RegWrite_MEM_WB = 1'b0; #delay;
		RegWrite_MEM_WB = 1; RegWrite_EX_MEM = 0; #delay;
		RegWrite_MEM_WB = 0; RegWrite_EX_MEM = 1; #delay;
		
		Rd_EX_MEM = 5'b11101; Rd_MEM_WB = 5'b11110; Rn_ID_EX = 5'b11101; Rm_ID_EX = 5'b11110; RegWrite_EX_MEM = 1'b1; RegWrite_MEM_WB = 1'b1; #delay;
		Rd_EX_MEM = 5'b11101; Rd_MEM_WB = 5'b11110; Rn_ID_EX = 5'b11101; Rm_ID_EX = 5'b11110; RegWrite_EX_MEM = 1'b0; RegWrite_MEM_WB = 1'b0; #delay;
		RegWrite_MEM_WB = 1; RegWrite_EX_MEM = 0; #delay;
		RegWrite_MEM_WB = 0; RegWrite_EX_MEM = 1; #delay;
		
	end

endmodule
// Check timescale

`timescale 1ps/1ps
module FWRD_UNIT(Rd_EX, Rd_MEM, Rd_WB, Rn_ID, Rm_ID, RegWrite_EX, RegWrite_MEM, RegWrite_WB, FwdA, FwdB);
	input logic [4:0] Rd_EX, Rd_MEM, Rd_WB, Rn_ID, Rm_ID;
	input logic RegWrite_EX, RegWrite_MEM, RegWrite_WB;
	output logic [1:0] FwdA, FwdB;
	
	logic HD_Rn_EX, HD_Rm_EX, HD_Rn_MEM, HD_Rm_MEM, HD_Rn_WB, HD_Rm_WB; // hazard detect (HD)
	logic notHazardDetectedRn, notHazardDetectedRm, onlyWBHazardRn, onlyWBHazardRm;
    logic true = 1'b1; 
	parameter delay = 50;

    // ID/EX fowarding (Rn)
    ForwardingConditionals exmemHazardRn2(Rd_EX, Rn_ID, RegWrite_EX, HD_Rn_EX);

    // ID/EX fowarding (Rm)
    ForwardingConditionals exmemHazardRn1(Rd_EX, Rm_ID, RegWrite_EX, HD_Rm_EX);
	
	// EX/MEM forwarding (Rn)
	ForwardingConditionals exmemHazardRn(Rd_MEM, Rn_ID, RegWrite_MEM, HD_Rn_MEM);
	
	// EX/MEM forwarding (Rm)
	ForwardingConditionals exmemHazardRm(Rd_MEM, Rm_ID, RegWrite_MEM, HD_Rm_MEM);
	
	// MEM/WB forwarding (Rn)
	ForwardingConditionals memwbHazardRn(Rd_WB, Rn_ID, RegWrite_WB, HD_Rn_WB);
	
	// MEM/WB forwarding (Rm)
	ForwardingConditionals memwbHazardRm(Rd_WB, Rm_ID, RegWrite_WB, HD_Rm_WB);
    
	not #delay (notHazardDetectedRn, HD_Rn_MEM);
	and #delay (onlyWBHazardRn, notHazardDetectedRn, HD_Rn_WB);
	// buf #delay (FwdA[1], HD_Rn_MEM);
	// buf #delay (FwdA[0], onlyWBHazardRn);
	
	not #delay (notHazardDetectedRm, HD_Rm_MEM);
	and #delay (onlyWBHazardRm, notHazardDetectedRm, HD_Rm_WB);
	// buf #delay (FwdB[1], HD_Rm_MEM);
	// buf #delay (FwdB[0], onlyWBHazardRm);

    mux2_1 leo1 (.out(FwdA[0]), .i0(onlyWBHazardRn), .i1(true), .sel(HD_Rn_EX));
    mux2_1 carson1 (.out(FwdA[1]), .i0(HD_Rn_MEM), .i1(true), .sel(HD_Rn_EX));

    mux2_1 leo2 (.out(FwdB[0]), .i0(onlyWBHazardRm), .i1(true), .sel(HD_Rm_EX));
    mux2_1 carson2 (.out(FwdB[1]), .i0(HD_Rm_MEM), .i1(true), .sel(HD_Rm_EX));
	
endmodule



module FWRD_UNIT_testbench();
	logic [4:0] Rd_EX, Rd_MEM, Rd_WB, Rn_ID, Rm_ID;
	logic RegWrite_MEM, RegWrite_WB, RegWrite_EX;
	logic [1:0] FwdA, FwdB;
	parameter delay = 1000;
	
	FWRD_UNIT dut(Rd_EX, Rd_MEM, Rd_WB, Rn_ID, Rm_ID, RegWrite_EX, RegWrite_MEM, RegWrite_WB, FwdA, FwdB);
		
	initial begin
        Rd_EX = 5'b11111;
		Rd_MEM = 5'b11111; Rd_WB = 5'b11111; Rn_ID = 5'b11111; Rm_ID = 5'b11111; RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1; RegWrite_EX = 0; #delay;
		Rd_MEM = 5'b11111; Rd_WB = 5'b11111; Rn_ID = 5'b11111; Rm_ID = 5'b11111; RegWrite_MEM = 1'b0; RegWrite_WB = 1'b0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 0; #delay;
        RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 1; #delay;
		
        Rd_EX = 5'b00000;
		Rd_MEM = 5'b00000; Rd_WB = 5'b00000; Rn_ID = 5'b00000; Rm_ID = 5'b00000; RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1; RegWrite_EX = 0; #delay;
		Rd_MEM = 5'b00000; Rd_WB = 5'b00000; Rn_ID = 5'b00000; Rm_ID = 5'b00000; RegWrite_MEM = 1'b0; RegWrite_WB = 1'b0; RegWrite_EX = 0;#delay;
		RegWrite_WB = 1; RegWrite_MEM = 0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 0; #delay;
        RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 1; #delay;
		
        Rd_EX = 5'b11000;
		Rd_MEM = 5'b11110; Rd_WB = 5'b10111; Rn_ID = 5'b00000; Rm_ID = 5'b00000; RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1; RegWrite_EX = 0; #delay;
		Rd_MEM = 5'b11110; Rd_WB = 5'b10111; Rn_ID = 5'b00000; Rm_ID = 5'b00000; RegWrite_MEM = 1'b0; RegWrite_WB = 1'b0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 0; #delay;
        RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 1; #delay;;
		
        Rd_EX = 5'b11110;
		Rd_MEM = 5'b11110; Rd_WB = 5'b11111; Rn_ID = 5'b11110; Rm_ID = 5'b11111; RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1; RegWrite_EX = 0; #delay;
		Rd_MEM = 5'b11110; Rd_WB = 5'b11111; Rn_ID = 5'b11110; Rm_ID = 5'b11111; RegWrite_MEM = 1'b0; RegWrite_WB = 1'b0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 0; #delay;
        RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 1; #delay;
		   
        Rd_EX = 5'b11110;
		Rd_MEM = 5'b11101; Rd_WB = 5'b11110; Rn_ID = 5'b00000; Rm_ID = 5'b11110; RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1; RegWrite_EX = 0; #delay;
		Rd_MEM = 5'b11101; Rd_WB = 5'b11110; Rn_ID = 5'b00000; Rm_ID = 5'b11110; RegWrite_MEM = 1'b0; RegWrite_WB = 1'b0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 0; #delay;
        RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 1; #delay;

		Rd_EX = 5'b11110;
		Rd_MEM = 5'b11101; Rd_WB = 5'b11110; Rn_ID = 5'b11101; Rm_ID = 5'b11110; RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1; RegWrite_EX = 0; #delay;
		Rd_MEM = 5'b11101; Rd_WB = 5'b11110; Rn_ID = 5'b11101; Rm_ID = 5'b11110; RegWrite_MEM = 1'b0; RegWrite_WB = 1'b0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 0; RegWrite_EX = 0; #delay;
		RegWrite_WB = 1; RegWrite_MEM = 1; RegWrite_EX = 0; #delay;
		
	end

endmodule
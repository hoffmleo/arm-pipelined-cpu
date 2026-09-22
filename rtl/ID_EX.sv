`timescale 1ns/10ps
module ID_EX(PC_4_in, ALUOp_in, MemToReg_in, RegWrite_in, Rd_in, BL_in, Db_in, Da_in, Rm_in, Rn_in, BrAdd_in, 
                BLT_in, UncondBr_in, Branch_in, MemRead_in, MemWrite_in, ALUI_in, ALUSrc_in, PC_4_out,  
                    ALUOp_out, MemToReg_out, RegWrite_out, Rd_out, BL_out, Db_out, Da_out, Rm_out, Rn_out, BrAdd_out, 
                        BLT_out, UncondBr_out, Branch_out, MemRead_out, MemWrite_out, ALUI_out, ALUSrc_out, 
									instructions_in, instructions_out, clk, reset); 
    input logic [63:0] PC_4_in, Db_in, Da_in, BrAdd_in;
	 input logic [31:0] instructions_in;
	 input logic [4:0] Rd_in, Rm_in, Rn_in;
    input logic [2:0] ALUOp_in;
    input logic MemToReg_in, RegWrite_in, BL_in, BLT_in, UncondBr_in, Branch_in, 
					MemRead_in, MemWrite_in, ALUI_in, ALUSrc_in; 
    input logic clk, reset; 
    output logic [63:0] PC_4_out, Db_out, Da_out, BrAdd_out;
	 output logic [31:0] instructions_out;
	 output logic [4:0] Rd_out, Rm_out, Rn_out;
    output logic [2:0] ALUOp_out;
    output logic MemToReg_out, RegWrite_out, BL_out, BLT_out, UncondBr_out, Branch_out,
					MemRead_out, MemWrite_out, ALUI_out, ALUSrc_out; 
    logic true = 1'b1; 
    logic false = 1'b0;

    singleRegister pc_4 (reset, true, PC_4_in, PC_4_out, clk);
	 singleRegister Br_Add (reset, true, BrAdd_in, BrAdd_out, clk);
    D_FF ALUOp_in0 (ALUOp_out[0], ALUOp_in[0], reset, clk);
    D_FF ALUOp_in1 (ALUOp_out[1], ALUOp_in[1], reset, clk);
    D_FF ALUOp_in2 (ALUOp_out[2], ALUOp_in[2], reset, clk);
    D_FF MemToReg (MemToReg_out, MemToReg_in, reset, clk);
    D_FF MemWrite (MemWrite_out, MemWrite_in, reset, clk);
    D_FF RegWrite (RegWrite_out, RegWrite_in, reset, clk);
    D_FF BL (BL_out, BL_in, reset, clk);
    D_FF BLT (BLT_out, BLT_in, reset, clk);
    D_FF UncondBr (UncondBr_out, UncondBr_in, reset, clk);
    D_FF Branch (Branch_out, Branch_in, reset, clk);
    D_FF MemRead (MemRead_out, MemRead_in, reset, clk);
    D_FF ALUI (ALUI_out, ALUI_in, reset, clk);
    D_FF ALUSrc (ALUSrc_out, ALUSrc_in, reset, clk);
	 
	 genvar i;
	 generate
		 for (i = 0; i < 32; i++) begin: loop
			 D_FF flipflop(instructions_out[i], instructions_in[i], reset, clk);
		 end
	 endgenerate
	 
	 genvar j;
	 generate
		 for (j = 0; j < 64; j++) begin: loop2
			 D_FF flipflops(Db_out[j], Db_in[j], reset, clk);
		 end
	 endgenerate
	 
	 genvar k;
	 generate
		 for (k = 0; k < 64; k++) begin: loop3
			 D_FF flipflopss(Da_out[k], Da_in[k], reset, clk);
		 end
	 endgenerate
	 
	 genvar l;
	 generate
		 for (l = 0; l < 5; l++) begin: loop4
			 D_FF flipflopsss(Rd_out[l], Rd_in[l], reset, clk);
		 end
	 endgenerate
	 
	 genvar m;
	 generate
		 for (m = 0; m < 5; m++) begin: loop5
			 D_FF flipflopssss(Rm_out[m], Rm_in[m], reset, clk);
		 end
	 endgenerate
	 
	 genvar n;
	 generate
		 for (n = 0; n < 5; n++) begin: loop6
			 D_FF flipflopssss(Rn_out[n], Rn_in[n], reset, clk);
		 end
	 endgenerate

endmodule

module ID_EX_testbench();
    logic [63:0] PC_4_in, Db_in, Da_in, BrAdd_in;
	 logic [31:0] instructions_in;
	 logic [4:0] Rd_in, Rm_in, Rn_in;
    logic [2:0] ALUOp_in;
    logic MemToReg_in, RegWrite_in, BL_in, BLT_in, UncondBr_in, Branch_in, 
			MemRead_in, MemWrite_in, ALUI_in, ALUSrc_in; 
    logic clk, reset; 
    logic [63:0] PC_4_out, Db_out, Da_out, BrAdd_out;
	 logic [31:0] instructions_out;
	 logic [4:0] Rd_out, Rm_out, Rn_out;
    logic [2:0] ALUOp_out;
    logic MemToReg_out, RegWrite_out, BL_out, BLT_out, UncondBr_out, Branch_out,
					MemRead_out, MemWrite_out, ALUI_out, ALUSrc_out; 
	 
    ID_EX DUT (PC_4_in, ALUOp_in, MemToReg_in, RegWrite_in, Rd_in, BL_in, Db_in, Da_in, Rm_in, Rn_in, BrAdd_in, 
                BLT_in, UncondBr_in, Branch_in, MemRead_in, MemWrite_in, ALUI_in, ALUSrc_in, PC_4_out,  
                    ALUOp_out, MemToReg_out, RegWrite_out, Rd_out, BL_out, Db_out, Da_out, Rm_out, Rn_out, BrAdd_out, 
                        BLT_out, UncondBr_out, Branch_out, MemRead_out, MemWrite_out, ALUI_out, ALUSrc_out, instructions_in, instructions_out, clk, reset); 

    initial begin // Set up the clock FOR TESTING
        clk <= 0;
        repeat(12) begin
            #450 clk <= ~clk;
        end
    end

    initial begin
        reset <= 1; @(posedge clk);
        reset <= 0; 
        PC_4_in = 64'hF0FF0DCDEF123F0F; ALUOp_in = 3'b010; MemToReg_in = 0; RegWrite_in = 0; Rd_in = 5'b11000; BL_in = 0; Db_in = 64'h0000000000000000; Da_in = 64'h0000000000000011; 
        Rm_in = 5'b11111; Rn_in = 5'b11110; BrAdd_in = 64'hF0FF0DCDEF1230F0; BLT_in = 0; Branch_in = 0; UncondBr_in = 0; MemRead_in = 0; MemWrite_in = 0; ALUI_in = 0; ALUSrc_in = 0; 
				instructions_in = 32'hFFFFFFFF; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'h0000000000000000; ALUOp_in = 3'b000; MemToReg_in = 1; Rd_in = 5'b00000; RegWrite_in = 1; BL_in = 1; Db_in = 64'h000000FF00000000; Da_in = 64'h00000AC000000011; 
        Rm_in = 5'b11001; Rn_in = 5'b10101; BrAdd_in = 64'h999999CDEF123F0F; BLT_in = 1; Branch_in = 1; UncondBr_in = 1; MemRead_in = 1; MemWrite_in = 1; ALUI_in = 1; ALUSrc_in = 1; 
				instructions_in = 32'h00000000; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'hFFFFFFFFFFFFFFFF; ALUOp_in = 3'b111; MemToReg_in = 1; Rd_in = 5'b00011; RegWrite_in = 1; BL_in = 1; Db_in = 64'h00000009C0000000; Da_in = 64'h0000110000000011; 
        Rm_in = 5'b01011; Rn_in = 5'b00111; BrAdd_in = 64'hF0FF0DCDE8490CBA; BLT_in = 0; Branch_in = 0; UncondBr_in = 0; MemRead_in = 0; MemWrite_in = 0; ALUI_in = 0; ALUSrc_in = 0; 
				instructions_in = 32'hAAAAAAAA; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'h0F0F0F0F0F0F0F0F; ALUOp_in = 3'b101; MemToReg_in = 0; Rd_in = 5'b10000;  RegWrite_in = 0; BL_in = 0; Db_in = 64'h1100000000000000; Da_in = 64'h0220000000000011;  
        Rm_in = 5'b11011; Rn_in = 5'b10111; BrAdd_in = 64'hF0FF0C8DEF123F0F; BLT_in = 1; Branch_in = 1; UncondBr_in = 1; MemRead_in = 1; MemWrite_in = 1; ALUI_in = 1; ALUSrc_in = 1; 
				instructions_in = 32'h0FA8769C; @(posedge clk);
    end
endmodule
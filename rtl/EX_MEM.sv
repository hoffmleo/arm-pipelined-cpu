`timescale 1ns/10ps
module EX_MEM(PC_4_in, ALUOut_in, MemToReg_in, RegWrite_in, Rd_in, BL_in, Db_in, MemRead_in, MemWrite_in, PC_4_out, ALUOut_out, 
                    MemToReg_out, RegWrite_out, Rd_out, BL_out, Db_out, MemRead_out, MemWrite_out, clk, reset); 
    input logic [63:0] PC_4_in, ALUOut_in, Db_in;
	 input logic [4:0] Rd_in;
    input logic MemToReg_in, RegWrite_in, BL_in, MemRead_in, MemWrite_in;
    input logic clk, reset; 
    output logic [63:0] PC_4_out, ALUOut_out, Db_out;
	 output logic [4:0] Rd_out;
    output logic MemToReg_out, RegWrite_out, BL_out, MemRead_out, MemWrite_out; 
    logic true = 1'b1; 
    logic false = 1'b0;

    singleRegister pc_4 (reset, true, PC_4_in, PC_4_out, clk);
	 singleRegister ALUOut (reset, true, ALUOut_in, ALUOut_out, clk);
    D_FF MemToReg (MemToReg_out, MemToReg_in, reset, clk);
    D_FF MemWrite (MemWrite_out, MemWrite_in, reset, clk);
    D_FF RegWrite (RegWrite_out, RegWrite_in, reset, clk);
    D_FF BL (BL_out, BL_in, reset, clk);
    D_FF MemRead (MemRead_out, MemRead_in, reset, clk);
	 
	 genvar j;
	 generate
		 for (j = 0; j < 64; j++) begin: loop2
			 D_FF flipflops(Db_out[j], Db_in[j], reset, clk);
		 end
	 endgenerate
	 
	 genvar l;
	 generate
		 for (l = 0; l < 5; l++) begin: loop4
			 D_FF flipflops(Rd_out[l], Rd_in[l], reset, clk);
		 end
	 endgenerate	 

endmodule

module EX_MEM_testbench();
    logic [63:0] PC_4_in, ALUOut_in, Db_in;
	 logic [4:0] Rd_in;
    logic MemToReg_in, RegWrite_in, BL_in, MemRead_in, MemWrite_in;
    logic clk, reset; 
    logic [63:0] PC_4_out, ALUOut_out, Db_out;
	 logic [4:0] Rd_out;
    logic MemToReg_out, RegWrite_out, BL_out, MemRead_out, MemWrite_out; 

    EX_MEM DUT (PC_4_in, ALUOut_in, MemToReg_in, RegWrite_in, Rd_in, BL_in, Db_in, MemRead_in, MemWrite_in, PC_4_out, ALUOut_out, 
                    MemToReg_out, RegWrite_out, Rd_out, BL_out, Db_out, MemRead_out, MemWrite_out, clk, reset); 

    initial begin // Set up the clock FOR TESTING
        clk <= 0;
        repeat(12) begin
            #450 clk <= ~clk;
        end
    end

    initial begin
        reset <= 1; @(posedge clk);
        reset <= 0; 
        PC_4_in = 64'hF0FF0DCDEF123F0F; ALUOut_in = 64'hF894107300000000; MemToReg_in = 0; RegWrite_in = 0;
        Rd_in = 5'b01010; BL_in = 0; Db_in = 64'hF894107300000011; MemRead_in = 0; MemWrite_in = 0; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'h0000000000000000; ALUOut_in = 64'hFBA6C78100000000; MemToReg_in = 1; Rd_in = 5'b01011; RegWrite_in = 1; 
        BL_in = 1; Db_in = 64'hF894107300000122; MemRead_in = 1; MemWrite_in = 1; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'hFFFFFFFFFFFFFFFF; ALUOut_in = 64'h819405FF00000000; MemToReg_in = 1; Rd_in = 5'b01001; RegWrite_in = 1; 
        BL_in = 1; Db_in = 64'hF894107300054321; MemRead_in = 0; MemWrite_in = 0; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'h0F0F0F0F0F0F0F0F; ALUOut_in = 64'hFFFFFFFF00000000; MemToReg_in = 0; Rd_in = 5'b01101;  RegWrite_in = 0; 
        BL_in = 0; Db_in = 64'hF89410730009836C; MemRead_in = 1; MemWrite_in = 1; @(posedge clk);
    end
endmodule
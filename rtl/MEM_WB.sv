`timescale 1ns/10ps
module MEM_WB(PC_4_in, ALUOut_in, MemToReg_in, RegWrite_in, Rd_in, BL_in, MemDOut_in, 
					PC_4_out, ALUOut_out, MemToReg_out, RegWrite_out, Rd_out, BL_out, MemDOut_out, clk, reset); 
    input logic [63:0] PC_4_in, ALUOut_in, MemDOut_in;
	 input logic [4:0] Rd_in;
    input logic MemToReg_in, RegWrite_in, BL_in;
	 
    input logic clk, reset; 
	 
    output logic [63:0] PC_4_out, ALUOut_out, MemDOut_out;
	 output logic [4:0] Rd_out;
    output logic MemToReg_out, RegWrite_out, BL_out; 
	 
    logic true = 1'b1; 
    logic false = 1'b0;

    singleRegister pc_4 (reset, true, PC_4_in, PC_4_out, clk);
	 singleRegister ALUOut (reset, true, ALUOut_in, ALUOut_out, clk);
	 singleRegister MemDOut (reset, true, MemDOut_in, MemDOut_out, clk);
    D_FF MemToReg (MemToReg_out, MemToReg_in, reset, clk);
    D_FF RegWrite (RegWrite_out, RegWrite_in, reset, clk);
    D_FF BL (BL_out, BL_in, reset, clk);
	 
	 genvar l;
	 generate
		 for (l = 0; l < 5; l++) begin: loop4
			 D_FF flipflops(Rd_out[l], Rd_in[l], reset, clk);
		 end
	 endgenerate	 

endmodule

module MEM_WB_testbench();
    logic [63:0] PC_4_in, ALUOut_in, MemDOut_in;
	 logic [4:0] Rd_in;
    logic MemToReg_in, RegWrite_in, BL_in;
	 
    logic clk, reset; 
	 
    logic [63:0] PC_4_out, ALUOut_out, MemDOut_out;
	 logic [4:0] Rd_out;
    logic MemToReg_out, RegWrite_out, BL_out; 

    MEM_WB DUT (PC_4_in, ALUOut_in, MemToReg_in, RegWrite_in, Rd_in, BL_in, MemDOut_in, PC_4_out, ALUOut_out, 
                    MemToReg_out, RegWrite_out, Rd_out, BL_out, MemDOut_out, clk, reset); 

    initial begin // Set up the clock FOR TESTING
        clk <= 0;
        repeat(12) begin
            #450 clk <= ~clk;
        end
    end

    initial begin
        reset <= 1; @(posedge clk);
        reset <= 0; 
        PC_4_in = 64'hF0FF0DCDEF123F0F; ALUOut_in = 64'hF8941073; MemDOut_in = 64'h0000000011111111; MemToReg_in = 0; RegWrite_in = 0;
        Rd_in = 5'b01010; BL_in = 0; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'h0000000000000000; ALUOut_in = 64'hFBA6C781; MemDOut_in = 64'h1111111122222222; MemToReg_in = 1; Rd_in = 5'b01101; RegWrite_in = 1; 
        BL_in = 1; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'hFFFFFFFFFFFFFFFF; ALUOut_in = 64'h819405FF; MemDOut_in = 64'h2222222233333333; MemToReg_in = 1; Rd_in = 5'b01100; RegWrite_in = 1; 
        BL_in = 1; @(posedge clk);

        reset <= 0; 
        PC_4_in = 64'h0F0F0F0F0F0F0F0F; ALUOut_in = 64'hFFFFFFFF; MemDOut_in = 64'h3333333344444444; MemToReg_in = 0; Rd_in = 5'b01011;  RegWrite_in = 0; 
        BL_in = 0; @(posedge clk);
    end
endmodule
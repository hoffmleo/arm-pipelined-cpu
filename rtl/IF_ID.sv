`timescale 1ns/10ps
module IF_ID(instructionData_in, PC_in, PC_4_in, instructionData, PC, PC_4, clk, reset);
	input logic clk;
	input logic reset;
	input logic [31:0] instructionData_in;
	input logic [63:0] PC_in, PC_4_in;
	output logic [31:0] instructionData;
	output logic [63:0] PC, PC_4;
	logic true = 1'b1;
	logic false = 1'b0;
	
	singleRegister PC_DFF(reset, true, PC_in, PC, clk);
	singleRegister PC_4_DFF(reset, true, PC_4_in, PC_4, clk);
		
	genvar i;
	generate
		for (i = 0; i < 32; i++) begin: loop
			D_FF flipflop(instructionData[i], instructionData_in[i], reset, clk);
		end
	endgenerate
endmodule

module IF_ID_testbench();
	logic clk;
	logic reset;
	logic [31:0] instructionData_in;
	logic [63:0] PC_in, PC_4_in;
	logic [31:0] instructionData;
	logic [63:0] PC, PC_4;
	
	IF_ID dut(instructionData_in, PC_in, PC_4_in, instructionData, PC, PC_4, clk, reset);
	
	initial begin // Set up the clock FOR TESTING
		clk <= 0;
		repeat (30) begin
			#(450) clk <= ~clk;
		end
	end	

   initial begin
       reset <= 1; 																				   @(posedge clk);
																											@(posedge clk);
		 reset <= 0; instructionData_in = 32'hFFFFFFFF;	PC_in =  4; PC_4_in = 8;   @(posedge clk);
																										   @(posedge clk);
																										   @(posedge clk);
						 instructionData_in = 32'h0F0F0F0F;	PC_in =  0; PC_4_in = 4;	@(posedge clk);
						 instructionData_in = 32'hAAAAAAAA;	PC_in =  8; PC_4_in = 12;	@(posedge clk);
																										   @(posedge clk);
						 instructionData_in = 32'h00000000;	PC_in =  24; PC_4_in = 28; @(posedge clk);
																										   @(posedge clk);
   end
endmodule
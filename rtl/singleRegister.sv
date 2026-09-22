`timescale 1ns/10ps
module singleRegister(reset, enable, in, out, clk);
	input logic reset, clk, enable; 
	input logic [63:0] in;
	output logic [63:0] out;
	logic [63:0] tempD, tempQ, tempAll;
	logic notEnable;
	
	not #50 unable (notEnable, enable);
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: loop
			and #50 checkEnabled (tempD[i], enable, in[i]);
			and #50 checkQ (tempQ[i], notEnable, out[i]); 
			or #50 finalGate (tempAll[i], tempQ[i], tempD[i]);
			D_FF flipflop(out[i], tempAll[i], reset, clk);
		end
	endgenerate
	
endmodule



module singleRegister_testbench();
	logic reset, clk, enable; 
	logic [63:0] in;
	logic [63:0] out;
	parameter delay = 9999;
	
	initial begin // Set up the clock FOR TESTING
		clk <= 0;
		forever #(2500) clk <= ~clk;
	end
	
	singleRegister dut(.reset, .enable, .in, .out, .clk);
	
	initial begin
		reset = 1; enable = 0; 																						#delay; 
		reset = 0;  in = 64'b0000000010101010101010101101010100000000101010101010101011010101;  #delay; 
																																#delay; 
																																#delay; 
		enable = 1; in = 64'b0000000010101010101010101101010100000000101010101010101011010101;  #delay; 
																																#delay; 
						in = 64'b1111111111111111111111111111111111111111111111111111111111111111;  #delay; 
		enable = 0;																										#delay; 
																																#delay;
						in = 64'b0000000000000000000000011111111111111111111111111111111111111111;
	end
endmodule




//module D_FF(q, d, reset, clk);
//	output reg q;
//	input d, reset, clk;
//	
//	always_ff @(posedge clk);
//	if (reset)
//		q <= 0;
//	else
//		q <= d;
//endmodule

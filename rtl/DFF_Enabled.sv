`timescale 1ns/10ps
module DFF_Enabled(reset, enable, in, out, clk);
	input logic reset, clk, enable; 
	input logic in;
	output logic out;
	logic tempD, tempQ, tempAll;
	logic notEnable;
	
	not #50 unable (notEnable, enable);
	and #50 checkEnabled (tempD, enable, in);
	and #50 checkQ (tempQ, notEnable, out); 
	or #50 finalGate (tempAll, tempQ, tempD);
	D_FF flipflop(out, tempAll, reset, clk);
	
endmodule



module DFF_Enabled_testbench();
	logic reset, clk, enable; 
	logic in;
	logic out;
	parameter delay = 10000;
	
	initial begin // Set up the clock FOR TESTING
		clk <= 0;
		forever #(2500) clk <= ~clk;
	end
	
	DFF_Enabled dut(.reset, .enable, .in, .out, .clk);
	
	initial begin
		reset = 1; enable = 0; 																						#delay; 
		reset = 0;  in = 1'b1;  #delay; 
																																#delay; 
																																#delay; 
		enable = 1; in = 1'b0;  #delay; 
																																#delay; 
						in = 1'b1;  #delay; 
		enable = 0;																										#delay; 
																																#delay;
						in = 1'b0;
	end
endmodule



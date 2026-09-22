`timescale 1ps/1ps
module mux8_1 (out, in, sel);
	input logic [7:0] in;
	input logic [2:0] sel;
	output logic out;  
	logic [3:0] outzero;
	logic [1:0] outone; 

	mux2_1 OutZero0 (outzero[0], in[0], in[1], sel[0]);
	mux2_1 OutZero1 (outzero[1], in[2], in[3], sel[0]);
	mux2_1 OutZero2 (outzero[2], in[4], in[5], sel[0]);
	mux2_1 OutZero3 (outzero[3], in[6], in[7], sel[0]);
	
	mux2_1 OutOne0 (outone[0], outzero[0], outzero[1], sel[1]);
	mux2_1 OutOne1 (outone[1], outzero[2], outzero[3], sel[1]);
	
	mux2_1 TheOutput (out, outone[0], outone[1], sel[2]);
endmodule

module mux8_1_testbench(); 
	logic [7:0] in;
	logic [2:0] sel;
	logic out;
	parameter delay = 10; 
	
	mux8_1 dut (.out(out), .in(in[7:0]), .sel(sel[2:0]));
	
	integer i;
	initial begin
		for (i=0; i<2048; i++) begin
			{in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0], sel[2], sel[1], sel[0]} = i; #delay; 
		end	
	end
endmodule 
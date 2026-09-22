`timescale 1ps/1ps
module mux2_1(out, i0, i1, sel);
	output logic out;
	input  logic  i0, i1, sel;
	logic outzero, outone, notsel;
	parameter delay = 50;
	
	not #delay NotSelect (notsel, sel);
	and #delay SelectZero (outzero, i1, sel);
	and #delay SelectOne (outone, i0, notsel);
	or #delay TheOutput (out, outzero, outone);
endmodule


// When testing set mux2_1 delay to zero! Or increase delay here. 
// Therefore you can see the results.
module mux2_1_testbench();
	logic i0, i1, sel;
	logic out;
	parameter delay = 10;
	
	mux2_1 dut (.out(out), .i0(i0), .i1(i1), .sel(sel));
	
	initial begin
		sel=0; i0=0; i1=0; #delay;
		sel=0; i0=0; i1=1; #delay;
		sel=0; i0=1; i1=0; #delay;
		sel=0; i0=1; i1=1; #delay;
		sel=1; i0=0; i1=0; #delay;
		sel=1; i0=0; i1=1; #delay;
		sel=1; i0=1; i1=0; #delay;
		sel=1; i0=1; i1=1; #delay;
	end
endmodule
	
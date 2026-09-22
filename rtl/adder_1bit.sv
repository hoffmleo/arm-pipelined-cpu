// add, subtract, and, or, xor	
// negative, zero, overflow, carry_out
`timescale 1ps/1ps

module adder_1bit(A, B, cin, sum, cout);
	input logic A, B, cin;
	output logic sum, cout;
	logic aAndB, bAndC, aAndC, temp;
	parameter delay = 50;
	
	xor #delay summing (sum, A, B, cin);
	and #delay firstAnd (aAndB, A, B);
	and #delay secondAnd (bAndC, B, cin);
	and #delay thirdAnd (aAndC, A, cin);
	or #delay firstOr (cout, aAndB, bAndC, aAndC);
endmodule


module adder_1bit_testbench();
	logic A, B, cin, sum, cout;
	parameter delay = 500;
	
	adder_1bit dut (A, B, cin, sum, cout);
	initial begin
	A = 0; B = 0; cin = 0; #delay;
					  cin = 1; #delay;
			 B = 1; cin = 0; #delay;
					  cin = 1; #delay;
	A = 1; B = 0; cin = 0; #delay;
					  cin = 1; #delay;
			 B = 1; cin = 0; #delay;
					  cin = 1; #delay;
	end 
	
endmodule
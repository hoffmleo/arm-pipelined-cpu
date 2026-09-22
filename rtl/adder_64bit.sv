`timescale 1ps/1ps

module adder_64bit (A, B, cin, sum, cout, overflow);
	input logic [63:0] A, B;
	input logic cin;
	
	output logic [63:0] sum; 
	output logic cout, overflow;
	
	parameter delay = 50;
	logic [62:0] carries;
		
	adder_1bit add0(A[0], B[0], cin, sum[0], carries[0]);
	genvar i;
	generate
		for (i = 1; i < 63; i++) begin: loop
			adder_1bit add1(A[i], B[i], carries[i-1], sum[i], carries[i]);
		end
	endgenerate
	adder_1bit add63(A[63], B[63], carries[62], sum[63], cout);
	
	// Overflow Flag
	xor #delay overflowGate (overflow, cout, carries[62]);	
endmodule


module adder_64bit_testbench();
	logic [63:0] A, B, sum;
	logic cin, cout;
	logic overflow;
	parameter delay = 20000;
	
	adder_64bit dut (A, B, cin, sum, cout, overflow);
	
	initial begin
		A = 64'h0000000000000000; B = 64'h0000000000000000; cin = 0; #delay;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h7FFFFFFFFFFFFFFF; cin = 0; #delay;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000000; cin = 0; #delay;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'h0000000000000000; cin = 1; #delay;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; cin = 1; #delay;
		A = 64'h00809AF079990010; B = 64'h0000000000000000; cin = 0; #delay;
		A = 64'h0000000000000000; B = 64'h00809AF079990010; cin = 1; #delay; 
		A = 64'h0101010101010101; B = 64'h0101010010101001; cin = 0; #delay; 
		A = 64'h0101010101010101; B = 64'h0000000000000009; cin = 1; #delay; //ADD: A + B        SUB: A + ~B + 1   = A + (-B)    -10=11111111111...0110
	end
	
endmodule
	

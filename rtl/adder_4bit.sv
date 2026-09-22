module adder_4bit (A, B, cin, sum, cout);
	input logic [3:0] A;
	input logic [3:0] B;
	input logic cin;
	
	output logic [3:0] sum;
	output logic cout;
	
	logic c1, c2, c3;
	
	

	adder_1bit FA0 (.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(c1)); 
	adder_1bit FA1 (.A(A[1]), .B(B[1]), .cin(c1), .sum(sum[1]), .cout(c2)); 
	adder_1bit FA2 (.A(A[2]), .B(B[2]), .cin(c2), .sum(sum[2]), .cout(c3));
	adder_1bit FA3 (.A(A[3]), .B(B[3]), .cin(c3), .sum(sum[3]), .cout(cout)); 	
endmodule



module adder_4bit (A, B, cin, sum, cout);
	input logic [3:0] A, B;
	input logic cin;
	
	output logic [3:0] sum; 
	output logic cout;
	
	logic c0, c1, c2;
	
	adder_1bit(A[3], B[3], c2, sum[3], cout);
	adder_1bit(A[2], B[2], c1, sum[2], c2);
	adder_1bit(A[1], B[1], c0, sum[1], c1);
	adder_1bit(A[0], B[0], cin, sum[0], c0);

endmodule

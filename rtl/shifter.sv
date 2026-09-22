module shifter(in, out);
	input logic [63:0] in;
	output logic [63:0] out;
	parameter delay = 50;
	
	assign out[0] = 0;
	assign out[1] = 0;
	genvar i;
   generate 
		for (i = 2; i < 64; i++)    begin: loop
//			buf #delay keepSame(out[i], in[i-2]);
			assign out[i] = in[i-2];
		end
   endgenerate
endmodule

module shifter_testbench();
	logic [63:0] in, out;
	parameter delay = 200;
	
	shifter shifted(in, out);
	
	initial begin
		in = 64'b1111111111111111111111111111111101010101010101010101010101011110; #delay;
		in = 64'b0000000000000000000000000000000001010101010101010101010101011110; #delay;	
		in = 64'b0011111111111111111111111111111111111111111111111111111111111111; #delay;
		in = 64'b1111111111111111111111111111111111111111111111111111111111111111; #delay;
		in = 64'b0000000000000000000000000000000000000000000000000000000000000000; #delay;
	end
endmodule

module signExtender(in, out);
	input logic [31:0] in;
	output logic [63:0] out;
	parameter delay = 50;
	
	genvar i;
   generate 
		for (i = 0; i < 32; i++)    begin: loop
			assign out[i] = in[i];
		end
   endgenerate
	
	genvar j;
   generate 
		for (j = 32; j < 64; j++)    begin: loop2
			assign out[j] = in[31];
		end
   endgenerate
endmodule

module signExtender_testbench();
	logic [31:0] in;
	logic [63:0] out;
	parameter delay = 200;
	
	signExtender extension(in, out);
	
	initial begin
		in = 32'b10101010010101001010100101010101; #delay;
		in = 32'b01010101010101010101010101010101; #delay;	
		in = 32'b11111111111111111111111111111111; #delay;
		in = 32'b00000000000000000000000000000000; #delay;
	end
endmodule

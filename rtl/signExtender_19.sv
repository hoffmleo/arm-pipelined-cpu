module signExtender_19(in, out);
	input logic [18:0] in;
	output logic [63:0] out;
	parameter delay = 50;
	
	genvar i;
   generate 
		for (i = 0; i < 19; i++)    begin: loop
			assign out[i] = in[i];
		end
   endgenerate
	
	genvar j;
   generate 
		for (j = 19; j < 64; j++)    begin: loop2
			assign out[j] = in[18];
		end
   endgenerate
endmodule

module signExtender_19_testbench();
	logic [18:0] in;
	logic [63:0] out;
	parameter delay = 200;
	
	signExtender_19 extension(in, out);
	
	initial begin
		in = 19'b0000000000000000000; #delay;
		in = 19'b1111111111111111111; #delay;	
		in = 19'b1010101010101010101; #delay;
	end
endmodule

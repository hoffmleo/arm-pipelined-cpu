module signExtender_9(in, out);
	input logic [8:0] in;
	output logic [63:0] out;
	parameter delay = 50;
	
	genvar i;
   generate 
		for (i = 0; i < 9; i++)    begin: loop
			assign out[i] = in[i];
		end
   endgenerate
	
	genvar j;
   generate 
		for (j = 9; j < 64; j++)    begin: loop2
			assign out[j] = in[8];
		end
   endgenerate
endmodule

module signExtender_9_testbench();
	logic [8:0] in;
	logic [63:0] out;
	parameter delay = 200;
	
	signExtender_9 extension(in, out);
	
	initial begin
		in = 9'b000000000; #delay;
		in = 9'b111111111; #delay;	
		in = 9'b101010101; #delay;
	end
endmodule

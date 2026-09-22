module signExtender_26(in, out);
	input logic [25:0] in;
	output logic [63:0] out;
	parameter delay = 50;
	
	genvar i;
   generate 
		for (i = 0; i < 26; i++)    begin: loop
			assign out[i] = in[i];
		end
   endgenerate
	
	genvar j;
   generate 
		for (j = 26; j < 64; j++)    begin: loop2
			assign out[j] = in[25];
		end
   endgenerate
endmodule

module signExtender_26_testbench();
	logic [25:0] in;
	logic [63:0] out;
	parameter delay = 200;
	
	signExtender_26 extension(in, out);
	
	initial begin
		in = 26'b00000000000000000000000000; #delay;
		in = 26'b11111111111111111111111111; #delay;	
		in = 26'b10101010101010101010101010; #delay;
	end
endmodule

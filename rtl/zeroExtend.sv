module zeroExtend(in, out);
	input logic [11:0] in;
	output logic [63:0] out;
	
	genvar i;
   generate 
		for (i = 0; i < 12; i++)    begin: loop
			assign out[i] = in[i];
		end
   endgenerate
	
	genvar j;
   generate 
		for (j = 12; j < 64; j++)    begin: loop2
			assign out[j] = 1'b0;
		end
   endgenerate
		
endmodule


module zeroExtend_testbench();
	logic [12:0] in;
	logic [63:0] out;
	parameter delay = 200;
	
	zeroExtend extension(in, out);
	
	initial begin
		in = 12'b000000000000; #delay;
		in = 12'b111111111111; #delay;	
		in = 12'b101010101010; #delay;
		in = 12'b010101010101; #delay;
	end

endmodule

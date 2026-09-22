`timescale 1ps/1ps
module decoder5_32(in, out, enable);
	input logic enable;
	input logic [4:0] in;
	output logic [31:0] out;
	logic bit1[31:0], bit2[31:0], bit3[31:0], bit4[31:0], bit5[31:0], tempAnd[31:0];
	parameter delay = 50;
	
	genvar i;
	generate
		for (i = 0; i < 32; i++) begin: loop
			xnor #delay xnor1 (bit1[i], in[0], i[0]);
			xnor #delay xnor2 (bit2[i], in[1], i[1]);
			xnor #delay xnor3 (bit3[i], in[2], i[2]);
			xnor #delay xnor4 (bit4[i], in[3], i[3]);
			xnor #delay xnor5 (bit5[i], in[4], i[4]);
			and #delay finalGate (tempAnd[i], enable, bit1[i], bit2[i], bit3[i]);
			and #delay finalGate2 (out[i], tempAnd[i], bit4[i], bit5[i]);
		end
	endgenerate

endmodule

module decoder5_32_testbench();
	logic [4:0] in;
	logic [31:0] out;
	logic enable;
	decoder5_32 dut (.in(in), .out(out), .enable(enable));
	initial begin
		enable = 0;
		in = 5'b00000; #20000;
		in = 5'b00001; #20000;
		in = 5'b00010; #20000;
		in = 5'b00011; #20000;
		in = 5'b00100; #20000;
		in = 5'b00101; #20000;
		in = 5'b00110; #20000;
		in = 5'b00111; #20000;
		in = 5'b01000; #20000;
		in = 5'b01001; #20000;
		in = 5'b01010; #20000;
		in = 5'b01011; #20000;
		in = 5'b01100; #20000;
		in = 5'b01101; #20000;
		in = 5'b01110; #20000;
		in = 5'b01111; #20000;
		in = 5'b10000; #20000;
		in = 5'b10001; #20000;
		in = 5'b10010; #20000;
		in = 5'b10011; #20000;
		in = 5'b10100; #20000;
		in = 5'b10101; #20000;
		in = 5'b10110; #20000;
		in = 5'b10111; #20000;
		in = 5'b11000; #20000;
		in = 5'b11001; #20000;
		in = 5'b11010; #20000;
		in = 5'b11011; #20000;
		in = 5'b11100; #20000;
		in = 5'b11101; #20000;
		in = 5'b11110; #20000;
		in = 5'b11111; #20000;	

		enable = 1;
		in = 5'b00000; #20000;
		in = 5'b00001; #20000;
		in = 5'b00010; #20000;
		in = 5'b00011; #20000;
		in = 5'b00100; #20000;
		in = 5'b00101; #20000;
		in = 5'b00110; #20000;
		in = 5'b00111; #20000;
		in = 5'b01000; #20000;
		in = 5'b01001; #20000;
		in = 5'b01010; #20000;
		in = 5'b01011; #20000;
		in = 5'b01100; #20000;
		in = 5'b01101; #20000;
		in = 5'b01110; #20000;
		in = 5'b01111; #20000;
		in = 5'b10000; #20000;
		in = 5'b10001; #20000;
		in = 5'b10010; #20000;
		in = 5'b10011; #20000;
		in = 5'b10100; #20000;
		in = 5'b10101; #20000;
		in = 5'b10110; #20000;
		in = 5'b10111; #20000;
		in = 5'b11000; #20000;
		in = 5'b11001; #20000;
		in = 5'b11010; #20000;
		in = 5'b11011; #20000;
		in = 5'b11100; #20000;
		in = 5'b11101; #20000;
		in = 5'b11110; #20000;
		in = 5'b11111; #20000;			
	end
endmodule

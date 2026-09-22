module mux32_1 (out, in, sel); 
	input  logic [31:0] in;
	input logic [4:0] sel;
	output logic out;
	logic [3:0] outzero;
	logic [1:0] outone;
	
	mux8_1 OutZero0 (.out(outzero[0]), .in(in[7:0]), .sel(sel[2:0]));
	mux8_1 OutZero1 (.out(outzero[1]), .in(in[15:8]), .sel(sel[2:0]));
	mux8_1 OutZero2 (.out(outzero[2]), .in(in[23:16]), .sel(sel[2:0]));
	mux8_1 OutZero3 (.out(outzero[3]), .in(in[31:24]), .sel(sel[2:0]));
	
	mux2_1 OutOne0 (outone[0], outzero[0], outzero[1], sel[3]);
	mux2_1 OutOne1 (outone[1], outzero[2], outzero[3], sel[3]);
	
	mux2_1 TheOutput (out, outone[0], outone[1], sel[4]);
endmodule

module mux32_1_testbench();
	logic [31:0] in;
	logic [4:0] sel;
	logic out;
	parameter delay = 10;
	
	mux32_1 dut (.out(out), .in(in), .sel(sel));
	
	integer i;
	initial begin
		in=32'b00101010101010101010101010101011; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end
		in=32'b11111111101010101010101010101011; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end
		in=32'b00101010111010101010101010101011; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end
		in=32'b11111111111111111111111111111111; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end
		in=32'b00101010101010101010101010101011; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end
		in=32'b00101010101010101010101010101011; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end
		in=32'h000000FF; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end
		in=32'h0000000F; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end
		in=32'h00000000; sel=5'b00000;  #delay;
		for (i=0; i<32; i++) begin
			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
		end		
	end
endmodule
	
	
`timescale 1ps/1ps
module bitwise_or(A, B, out);
	input logic [63:0] A, B;
	output logic [63:0] out;
	parameter delay = 50;
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: loop
			or #delay orGate(out[i], A[i], B[i]);
		end
	endgenerate

endmodule


module bitwise_or_testbench();
	logic [63:0] A, B, out;
	parameter delay = 20000;
	
	bitwise_or dut(A, B, out);	
	initial begin
		A = 64'hFFF78229830ADEBC; B = 64'h819460BCE0A5D9FA; #delay;
		A = 64'h0000000000000000; B = 64'h0000000000000000; #delay;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF; #delay;
		A = 64'h5555555555555555; B = 64'hAAAAAAAAAAAAAAAA; #delay;
	end
	
endmodule

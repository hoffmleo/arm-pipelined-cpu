`timescale 1ps/1ps
module bitwise_not(A, out);
	input logic [63:0] A;
	output logic [63:0] out;
	parameter delay = 50;
	
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: loop
			not #delay notGate(out[i], A[i]);
		end
	endgenerate

endmodule


module bitwise_not_testbench();
	logic [63:0] A, out;
	parameter delay = 20000;
	
	bitwise_not dut(A, out);	
	initial begin
		A = 64'hFFF78229830ADEBC; #delay;
		A = 64'h0000000000000000; #delay;
		A = 64'hFFFFFFFFFFFFFFFF; #delay;
		A = 64'h5555555555555555; #delay;
	end
	
endmodule

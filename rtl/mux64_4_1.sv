`timescale 1ps/1ps
module mux64_4_1(in, sel, out); 
    input logic [3:0][63:0] in;
    input logic [1:0] sel;
    output logic [63:0] out;

    genvar i;
    generate 
		for (i = 0; i < 64; i++)    begin: loop
			  mux4_1 TheOutput (.out(out[i]), 
					.in({in[3][i], in[2][i], in[1][i], in[0][i]}), 
						.sel(sel[1:0]));
		end
    endgenerate
endmodule 

module mux64_4_1_testbench();
    logic [3:0][63:0] in;
    logic [1:0] sel;
    logic [63:0] out;
    parameter delay = 1000;

    mux64_4_1 dut (.in, .sel, .out);

    integer i;
    initial begin 
        in[0][63:0] = 64'hB13ACEFAFFFFFFFF; 
        in[1][63:0] = 64'h0FF0F0FADEF02310;
        in[2][63:0] = 64'hF0FF0DCDEF123F0F;
        in[3][63:0] = 64'hFFF0ADCD83200FF0;

        for (i=0; i<4; i++) begin: loop
            {sel[1], sel[0]} = i; #delay;
        end
    end
endmodule
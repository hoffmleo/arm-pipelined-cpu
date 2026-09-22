`timescale 1ps/1ps
module mux64_8_1 (out, in, sel);
    input logic [7:0][63:0] in;
    input logic [2:0] sel;
	 
    output logic [63:0] out;

    genvar i;
    generate 
		for (i = 0; i < 64; i++)    begin: loop
			  mux8_1 TheOutput (.out(out[i]), 
					.in({in[7][i], in[6][i], in[5][i], in[4][i], in[3][i], in[2][i], in[1][i], in[0][i]}), 
						.sel(sel[2:0]));
		end
    endgenerate
endmodule

module mux64_8_1_testbench();
    logic [7:0][63:0] in;
    logic [2:0] sel;
    logic [63:0] out;
    parameter delay = 1000;

    mux64_8_1 dut (.out, .in, .sel);

    integer i;
    initial begin 
        in[0][63:0] = 64'hB13ACEFAFFFFFFFF; 
        in[1][63:0] = 64'h0FF0F0FADEF02310;
        in[2][63:0] = 64'hF0FF0DCDEF123F0F;
        in[3][63:0] = 64'hFFF0ADCD83200FF0;
        in[4][63:0]=  64'hF01394103900FFFF;
        in[5][63:0] = 64'hFFF31032093FFFF1;
        in[6][63:0] = 64'h0FF0F0F192834921;
        in[7][63:0] = 64'hF0FF012A92314F01;

        for (i=0; i<8; i++) begin: loop
            {sel[2], sel[1], sel[0]} = i; #delay;
        end
    end
endmodule
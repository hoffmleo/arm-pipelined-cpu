`timescale 1ps/1ps
module mux64_2_1 (out, in, sel);
    input logic [1:0][63:0] in;
    input logic sel;

    output logic [63:0] out;

    genvar i;
    generate 
        for (i = 0; i < 64; i++)    begin: loop
              mux2_1 TheOutput (.out(out[i]), 
                    .i0(in[0][i]), .i1(in[1][i]), 
                        .sel(sel));
        end
    endgenerate
endmodule

module mux64_2_1_testbench();
    logic [1:0][63:0] in;
    logic sel;
    logic [63:0] out;
    parameter delay = 1000;

    mux64_2_1 dut (.out, .in, .sel);

    integer i;
    initial begin 
        in[0][63:0] = 64'hB13ACEFAFFFFFFFF; 
        in[1][63:0] = 64'h0FF0F0FADEF02310;

        for (i=0; i<2; i++) begin: loop
            sel = i; #delay;
        end
    end
endmodule
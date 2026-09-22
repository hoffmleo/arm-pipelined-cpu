`timescale 1ps/1ps
module mux5_2_1 (out, in, sel);
    input logic [1:0][4:0] in;
    input logic sel;

    output logic [4:0] out;

    genvar i;
    generate 
        for (i = 0; i < 5; i++)    begin: loop
				mux2_1 chooseBit(.out(out[i]), .i0(in[0][i]), .i1(in[1][i]), .sel(sel));
        end
    endgenerate
endmodule

module mux5_2_1_testbench();
    logic [1:0][4:0] in;
    logic sel;
    logic [4:0] out;
    parameter delay = 1000;

    mux5_2_1 dut (.out, .in, .sel);

    integer i;
    initial begin 
        in[0][4:0] = 5'b11110;
        in[1][4:0] = 5'b00100;

        for (i=0; i<2; i++) begin: loop
            sel = i; #delay;
        end
    end
endmodule

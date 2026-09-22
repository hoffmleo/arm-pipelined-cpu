`timescale 1ps/1ps
module addby4 (out, in);
    input logic [63:0] in;
    output logic [63:0] out;

    adder_64bit fuckyou (.A(in), .B(64'h0000000000000004), .cin(1'b0), .sum(out), .cout(), .overflow());
endmodule 

module addby4_testbench();
    logic [63:0] in, out;
    parameter delay = 1000;

    addby4 dut (.out, .in);

    initial begin
        in = 64'h0000000000000009; #delay;
        in = 64'h00809AF079990010; #delay;
        in = 64'h0101010101010101; #delay;
    end
endmodule

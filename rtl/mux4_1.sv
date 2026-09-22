`timescale 1ps/1ps
module mux4_1 (in, sel, out);
    input logic [3:0] in;
    input logic [1:0] sel;
    output logic out;

    logic semi1win, semi2win; 
    mux2_1 semifinals1 (.out(semi1win), .i0(in[0]), .i1(in[1]), .sel(sel[0]));
    mux2_1 semifinals2 (.out(semi2win), .i0(in[2]), .i1(in[3]), .sel(sel[0]));
    mux2_1 finals (.out(out), .i0(semi1win), .i1(semi2win), .sel(sel[1]));
endmodule

module mux4_1_testbench(); 
    logic [3:0] in;
    logic [1:0] sel;
    logic out;

    parameter delay = 500;

    mux4_1 duf (.in, .out, .sel); 
    initial begin
      sel=2'b00; in=4'b0000; #delay;
		sel=2'b01; in=4'b0000; #delay;
		sel=2'b10; in=4'b0000; #delay;
		sel=2'b11; in=4'b0000; #delay;
		sel=2'b00; in=4'b1111; #delay;
		sel=2'b01; in=4'b1111; #delay;
		sel=2'b10; in=4'b1111; #delay;
		sel=2'b11; in=4'b1111; #delay;
      sel=2'b00; in=4'b1010; #delay;
		sel=2'b01; in=4'b1010; #delay;
		sel=2'b10; in=4'b1010; #delay;
		sel=2'b11; in=4'b1010; #delay;
		sel=2'b00; in=4'b0101; #delay;
		sel=2'b01; in=4'b0101; #delay;
		sel=2'b10; in=4'b0101; #delay;
		sel=2'b11; in=4'b0101; #delay;
    end
endmodule
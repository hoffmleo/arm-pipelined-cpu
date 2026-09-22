`timescale 1ps/1ps
module forward(passOut, MemToRegOut, ALUMemOut, forwardSEL, out);
    input logic [63:0] passOut, MemToRegOut, ALUMemOut; // 00, 01, 10
    input logic [1:0] forwardSEL; 
    output logic [63:0] out;

    mux64_4_1 done (.in({64'h0000000000000000, ALUMemOut, MemToRegOut, passOut}), .sel(forwardSEL), .out(out));   
endmodule

module forward_testbench();
    logic [63:0] passOut, MemToRegOut, ALUMemOut;
    logic [1:0] forwardSEL;
    logic [63:0] out;
    parameter delay = 1000;

    forward duf (.passOut, .MemToRegOut, .ALUMemOut, .forwardSEL, .out);

    integer i;
    initial begin 
        passOut = 64'hB13ACEFAFFFFFFFF; 
        MemToRegOut = 64'h0FF0F0FADEF02310;
        ALUMemOut = 64'hF0FF0DCDEF123F0F;

        for (i=0; i<4; i++) begin: loop
            {forwardSEL[1], forwardSEL[0]} = i; #delay;
        end
    end
endmodule
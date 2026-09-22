module PC (clk, in, cond_add, branch_add, uncond_br, br_taken, reset, out);
    input logic [18:0] cond_add;
    input logic [25:0] branch_add;
    input logic uncond_br, br_taken, clk, reset;
    output logic [63:0] out;
    logic [63:0] in;

    // "PC"
    singleRegister wow (1'b0, 1'b1, in, out, clk); // Can add your own implementation of reset at the top module? 

    // Branch Logic (Can combine different methods? Not use signextender_19 and 26?)
    logic [63:0] ex_cond_add, ex_branch_add; 
    signExtender_19 wowa (.in(cond_add), .out(ex_cond_add));
    signExtender_26 wowb (.in(branch_add), .out(ex_branch_add));

    logic [63:0] branch; 
    mux64_2_1 wowza (.out(branch), .in({ex_branch_add, ex_cond_add}), .sel(uncond_br));

    logic [63:0] branch_shifted;
    shifter wowshift (.in(branch), .out(branch_shifted));

    logic [63:0] branch_add; 
    adder_64bit wowbranch (.A(out), .B(branch_shifted), .cin(1'b0), .sum(branch_add), .cout(), .overflow());

    // Non-branch
    logic [63:0] non_branch_add; 
    addby4 wowab (.in(out), .out(non_branch));

    // Selecting if branched or not, giving new PC value
    mux64_2_1 ending (.out(in), .in({branch_add, non_branch_add}), .sel(br_taken));
endmodule

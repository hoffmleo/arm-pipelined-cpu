`timescale 1ps/1ps
module branchLogic(OF, Neg, zeroTemp, BLT, Branch, UncondBr, BrTake);
    input logic OF, Neg, zeroTemp, BLT, Branch, UncondBr; 
    output logic BrTake; 
    parameter delay = 50; 

    logic iflesstomux, toUncondBr, toBranch;
    xor #delay iflessthan (iflesstomux, OF, Neg);
    mux2_1 #delay passblt (.out(toBranch), .i1(iflesstomux), .i0(zeroTemp), .sel(BLT));
    and #delay passbranch (toUncondBr, Branch, toBranch);
    or #delay passUnconbranch (BrTake, UncondBr, toUncondBr);
endmodule

module branchLogic_testbench();
    logic OF, Neg, zeroTemp, BLT, Branch, UncondBr, BrTake; 
    parameter delay = 500; 

    branchLogic Muf (OF, Neg, zeroTemp, BLT, Branch, UncondBr, BrTake);

    initial begin
        OF = 0; Neg = 1; zeroTemp = 0; #delay; // less-than assertive
        BLT = 0; Branch = 1; UncondBr = 0; #delay;
        BLT = 1; Branch = 0; UncondBr = 0; #delay;
        BLT = 1; Branch = 1; UncondBr = 0; #delay; // now should be true!

        OF = 0; Neg = 0; zeroTemp = 1; #delay; // zero assertive
        BLT = 0; Branch = 1; UncondBr = 0; #delay; // should be true here only!
        BLT = 1; Branch = 0; UncondBr = 0; #delay;
        BLT = 1; Branch = 1; UncondBr = 0; #delay; 
        
        OF = 1; Neg = 0; zeroTemp = 0; #delay; // non assertive
        BLT = 0; Branch = 1; UncondBr = 0; #delay; 
        BLT = 1; Branch = 0; UncondBr = 0; #delay;
        BLT = 1; Branch = 1; UncondBr = 0; #delay; // ACTUALY THIS TOO!
        BLT = 1; Branch = 1; UncondBr = 1; #delay; // only way!
    end 
endmodule
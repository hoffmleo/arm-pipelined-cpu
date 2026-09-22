module control (OppCode, ALUOpp, UncondBr, Branch, MemRead, MemToReg, MemWrite, RegWrite, BL, ALUSrc, BR, ALUI, BLT, Reg2Loc);
    input logic [10:0] OppCode;
    output logic [1:0] ALUOpp; // 00, 10, 11
    output logic UncondBr;
    output logic Branch;
    output logic MemRead;
    output logic MemToReg;
    output logic MemWrite;
    output logic RegWrite;
    output logic BL;
    output logic ALUSrc;
    output logic BR;
    output logic ALUI;
    output logic BLT;
    output logic Reg2Loc;
    
    always_comb begin
        casex (OppCode)
            11'b1001000100x:  begin: ADDI
                Reg2Loc =  		  1'bx;
                UncondBr = 		  1'b0;
                Branch =   		  1'b0;
                MemRead =  		  1'b0;
                MemToReg = 		  1'b0;
                ALUOpp =   		  2'b10;
                MemWrite = 		  1'b0;
                ALUSrc =   		  1'bx;
                RegWrite = 		  1'b1;
                BL =       		  1'b0;
                BR =       		  1'b0;
                ALUI =     		  1'b1;
                BLT =      		  1'b0; 
            end
            11'b10101011000:  begin: ADDS
                Reg2Loc =     	  1'b1;
                UncondBr =    	  1'b0;
                Branch =      	  1'b0;
                MemRead =     	  1'b0;
                MemToReg =    	  1'b0;
                ALUOpp =      	  2'b10;
                MemWrite =    	  1'b0;
                ALUSrc =      	  1'b0;
                RegWrite =    	  1'b1;
                BL =          	  1'b0;
                BR =          	  1'b0;
                ALUI =        	  1'b0;
                BLT =         	  1'b0; 
            end
            11'b11101011000:  begin: SUBS
                Reg2Loc =   		  1'b1;
                UncondBr =  		  1'b0;
                Branch =    		  1'b0;
                MemRead =   		  1'b0;
                MemToReg =  		  1'b0;
                ALUOpp =    		  2'b11;
                MemWrite =  		  1'b0;
                ALUSrc =    		  1'b0;
                RegWrite =  		  1'b1;
                BL =        		  1'b0;
                BR =        		  1'b0;
                ALUI =      		  1'b0;
                BLT =       		  1'b0; 
            end
            11'b11111000010:  begin: LDUR
					 Reg2Loc =   		  1'bx;
					 UncondBr =  		  1'b0;
					 Branch =    		  1'b0;
					 MemRead =   		  1'b1;
					 MemToReg =  		  1'b1;
					 ALUOpp =    		  2'b10;
					 MemWrite =  		  1'b0;
					 ALUSrc =    		  1'b1;
					 RegWrite =  		  1'b1;
					 BL =        		  1'b0;
					 BR =        		  1'b0;
					 ALUI =      		  1'b0;
					 BLT =       		  1'b0; 
				end
            11'b11111000000: begin: STUR
				    Reg2Loc =          1'b0;
				    UncondBr =         1'b0;
				    Branch =           1'b0;
				    MemRead =          1'b0;
				    MemToReg =         1'bx;
				    ALUOpp =     		  2'b10;
				    MemWrite =         1'b1;
				    ALUSrc =           1'b1;
				    RegWrite =         1'b0;
				    BL =               1'b0;
				    BR =               1'b0;
				    ALUI =             1'b0;
				    BLT =              1'b0;
            end
            11'b000101xxxxx: begin: Booo
                Reg2Loc =          1'bx;
                UncondBr =         1'b1;
                Branch =           1'b0;
                MemRead =          1'b0;
                MemToReg =         1'bx;
                ALUOpp =     	     2'bxx;
                MemWrite =         1'b0;
                ALUSrc =           1'bx;
                RegWrite =         1'b0;
                BL =               1'b0;
                BR =               1'b0;
                ALUI =             1'b0;
                BLT =              1'b0;
            end
            11'b10110100xxx: begin: CBZ
                Reg2Loc =          1'b0;
                UncondBr =         1'b0;
                Branch =           1'b1;
                MemRead =          1'b0;
                MemToReg =         1'bx;
                ALUOpp =     	  	  2'b00;
                MemWrite =         1'b0;
                ALUSrc =           1'b0;
                RegWrite =         1'b0;
                BL =               1'b0;
                BR =               1'b0;
                ALUI =             1'b0;
                BLT =              1'b0;
            end
            11'b01010100xxx: begin: BLToo
                Reg2Loc =          1'b0;
                UncondBr =         1'b0;
                Branch =           1'b1;
                MemRead =          1'b0;
                MemToReg =         1'bx;
                ALUOpp =     	     2'b00;
                MemWrite =         1'b0;
                ALUSrc =           1'b0;
                RegWrite =         1'b0;
                BL =               1'b0;
                BR =               1'b0;
                ALUI =             1'b0;
                BLT =              1'b1;
            end
            11'b100101xxxxx: begin: BLoo
                Reg2Loc =          1'bx;
                UncondBr =         1'b1;
                Branch =           1'b0;
                MemRead =          1'b0;
                MemToReg =         1'b0;
                ALUOpp =   		  2'bxx;
                MemWrite =         1'b0;
                ALUSrc       = 	  1'b0;
                RegWrite =         1'b1;
                BL =               1'b1;
                BR =               1'b0;
                ALUI =             1'b0;
                BLT =              1'b0;
            end
            11'b11010110000: begin: BRoo
                Reg2Loc =          1'b0;
                UncondBr =         1'b1;
                Branch =           1'b0;
                MemRead =          1'b0;
                MemToReg =         1'b0;
                ALUOpp =     		  2'bxx;
                MemWrite =         1'b0;
                ALUSrc =           1'b0;
                RegWrite =         1'b0;
                BL =               1'b0;
                BR =               1'b1;
                ALUI =             1'b0;
                BLT =              1'b0;
            end
            default: begin: defaultMode
                Reg2Loc =          1'b0;
                UncondBr =         1'b0;
                Branch =           1'b0;
                MemRead =          1'b0;
                MemToReg =         1'b0;
                ALUOpp =     		  2'b0;
                MemWrite =         1'b0;
                ALUSrc =           1'b0;
                RegWrite =         1'b0;
                BL =               1'b0;
                BR =               1'b0;
                ALUI =             1'b0;
                BLT =              1'b0;                
            end
        endcase
    end
endmodule

module control_testbench();
    logic [10:0] OppCode;
    logic [1:0] AluOpp; // 00, 10, 11
    logic UncondBr;
    logic Branch;
    logic MemRead;
    logic MemToReg;
    logic MemWrite;
    logic RegWrite;
    logic BL;
    logic ALUSrc;
    logic BR;
    logic ALUI;
    logic BLT;
    logic Reg2Loc;
	 parameter delay = 200;
	 
	 
	 control controlBlock (OppCode, AluOpp, UncondBr, Branch, MemRead, MemToReg, MemWrite, RegWrite, BL, ALUSrc, BR, ALUI, BLT, Reg2Loc);
	 
	 initial begin
			OppCode = 11'b1001000100x; #delay;
			OppCode = 11'b10101011000; #delay;
			OppCode = 11'b10101111000; #delay;
			OppCode = 11'b11111000010; #delay;
			OppCode = 11'b11111000000; #delay;
			OppCode = 11'b000101xxxxx; #delay;
			OppCode = 11'b10110100xxx; #delay;
			OppCode = 11'b01010100xxx; #delay;
			OppCode = 11'b100101xxxxx; #delay;
			OppCode = 11'b11010110000; #delay;
			OppCode = 11'b00000000000; #delay;
	 
	 end
	 
endmodule

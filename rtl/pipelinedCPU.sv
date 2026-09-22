// Could remove AW

`timescale 1ns/10ps
module pipelinedCPU(clk, reset, fullRegister, mem, 
					pc_IF, instructionData_IF, pc_4_IF, pc_in,
					Db_ID, pc_4_ID, pc_ID, instructionData_ID, ALUOp_ID, BrAdd_ID, Br, Reg2Loc, MemToReg_ID, RegWrite_ID, Branch_ID, BL_ID, BLT_ID, UncondBr_ID, MemRead_ID, MemWrite_ID, ALUI_ID, ALUSrc_ID, BrTake, zeroTemp, Neg, OF, AW, Ab, Rd_ID, Rd_WB, Da_ID, DW, Rn_ID, Rm_ID,
					BrAdd_EX, pc_4_EX, Db_EX, Da_EX, instructionData_EX, Rd_EX, Rn_EX, Rm_EX, ALUOp_EX, MemToReg_EX, RegWrite_EX, BL_EX, BLT_EX, UncondBr_EX, Branch_EX, MemRead_EX, MemWrite_EX, ALUI_EX, ALUSrc_EX, ALUOut,
					ALUOut_MEM, pc_4_MEM, Db_MEM, Rd_MEM, MemToReg_MEM, RegWrite_MEM, BL_MEM, MemRead_MEM, MemWrite_MEM, MemDOut_MEM,
					fwdA_sel, fwdB_sel, pc_4_WB, RegWrite_WB, BL_WB, Mem2RegOut, ALUOut_WB, MemDOut_WB, MemToReg_WB, fw_MEM, fw_WB, fw_MEM_actual);			
					
					
    input logic clk, reset;
	 parameter delay = 50;
    logic true = 1'b1;
    logic false = 1'b0; 
	 `define DATA_MEM_SIZE		1024
	 
	 // To be used later (must be declared before being used)
	 output logic [63:0] ALUOut_MEM;
	 output logic [63:0] Mem2RegOut;
	 output logic [63:0] Db_ID;
	 output logic BrTake, zeroTemp, MemRead_MEM;
    output logic Neg, OF, BL_MEM, BL_EX;
	 output logic [63:0] pc_4_WB;
	 output logic RegWrite_WB, BL_WB;
	 output logic [1:0] fwdA_sel, fwdB_sel;
	 output logic [63:0] BrAdd_EX;
    output logic [63:0] BrAdd_ID, pc_4_MEM;
    output logic [63:0] ALUOut;
    output logic [63:0] MemDOut_MEM, MemDOut_WB;
    
	 
		
    //----------------------------------- INSTRUCTION FETCH ------------------------------------------
    output logic [63:0] pc_4_IF, pc_in;
	output logic [63:0] pc_IF;
    output logic [31:0] instructionData_IF; 

    mux64_2_1 ifBranch (.out(pc_in), .in({BrAdd_ID, pc_4_IF}), .sel(BrTake)); 
    singleRegister PC (.reset(reset), .enable(true), .in(pc_in), .out(pc_IF), .clk(clk));
    addby4 addpc (.in(pc_IF), .out(pc_4_IF));
    instructmem currentInstr (.address(pc_IF), .instruction(instructionData_IF), .clk(clk));

    // Pipline
    output logic [63:0] pc_4_ID, pc_ID;
    output logic [31:0] instructionData_ID; 
    IF_ID ifid (.instructionData_in(instructionData_IF), .PC_in(pc_IF), .PC_4_in(pc_4_IF), .instructionData(instructionData_ID), 
                                        .PC(pc_ID), .PC_4(pc_4_ID), .clk(clk), .reset(reset));    
													 
    //----------------------------------- INSTRUCTION DECODE -------------------------------------------
    // Control Unit
    output logic [1:0] ALUOp_ID;																																					
    output logic Br, Reg2Loc, MemToReg_ID, RegWrite_ID, Branch_ID, BL_ID, BLT_ID, UncondBr_ID, MemRead_ID, MemWrite_ID, ALUI_ID, ALUSrc_ID; 	
    
    control get (.OppCode(instructionData_ID[31:21]), .ALUOpp(ALUOp_ID), .UncondBr(UncondBr_ID), .Branch(Branch_ID), 
                    .MemRead(MemRead_ID), .MemToReg(MemToReg_ID), .MemWrite(MemWrite_ID), .RegWrite(RegWrite_ID), .BL(BL_ID), .ALUSrc(ALUSrc_ID), 
                        .BR(Br), .ALUI(ALUI_ID), .BLT(BLT_ID), .Reg2Loc(Reg2Loc));

    // Branch Address 
    logic [63:0] br_cond_ad, br_uncond_ad; 
    signExtender_19 wowa (.in(instructionData_ID[23:5]), .out(br_cond_ad));
    signExtender_26 wowb (.in(instructionData_ID[25:0]), .out(br_uncond_ad));
 
    logic [63:0] br_unshifted;
	 logic [63:0] branch;
    mux64_2_1 wowza (.out(branch), .in({br_uncond_ad, br_cond_ad}), .sel(UncondBr_ID));
 
    logic [63:0] br_shifted;
    shifter wowshift (.in(branch), .out(br_shifted));
 
    logic [63:0] branch_addition; 
    adder_64bit wowbranch (.A(pc_ID), .B(br_shifted), .cin(1'b0), .sum(branch_addition), .cout(), .overflow()); // Ignores carry/overflow errors...should be okay
 
    
    mux64_2_1 adder_to_branch_maybe (.out(BrAdd_ID), .in({Db_ID, branch_addition}), .sel(Br));
	 
	 
    // Registers
    output logic [4:0] AW, Ab, Rd_ID, Rd_WB;
    output logic [63:0] Da_ID, DW; 
    output logic [31:0][63:0] fullRegister;
    logic [63:0] Db_bf, Da_bf;
    mux5_2_1 muxForX30_pipeline(.out(Rd_ID), .in({5'b11110, instructionData_ID[4:0]}), .sel(BL_ID)); 
    mux5_2_1 br_load (.out(Ab), .in({instructionData_ID[20:16], instructionData_ID[4:0]}), .sel(Reg2Loc));
    mux64_2_1 br_wb (.out(DW), .in({pc_4_WB, Mem2RegOut}), .sel(BL_WB)); 
    regfile regs (.ReadData1(Da_bf), .ReadData2(Db_bf), .WriteData(DW), .ReadRegister1(instructionData_ID[9:5]), .ReadRegister2(Ab), //changed from Ab to Rd_WB
                        .WriteRegister(Rd_WB), .RegWrite(RegWrite_WB), .clk(clk), .fullRegister(fullRegister));
    
    // Pre-Fowarding Data (Rm, Rn)
    output logic [4:0] Rn_ID, Rm_ID;
    RnAndRmOutMUX pre_forward (.Branch(Branch_ID), .UncondBr(UncondBr_ID), .pipelineRegInstructions25to22(instructionData_ID[25:22]), .pipeRegs31to28(instructionData_ID[31:28]), .rnIn(instructionData_ID[9:5]), .rmIn(Ab), .rnOut(Rn_ID), .rmOut(Rm_ID));   // FIX -- rmIn should not be Ab?

    // forward
    output logic [63:0] fw_MEM, fw_WB, fw_MEM_actual;
    mux64_2_1 ifBL_MEM (.out(fw_MEM), .in({pc_4_MEM, ALUOut_MEM}), .sel(BL_MEM));
    mux64_2_1 ifBL_WB (.out(fw_WB), .in({pc_4_WB, Mem2RegOut}), .sel(BL_WB));
    mux64_2_1 ifLDUR_MEM(.out(fw_MEM_actual), .in({MemDOut_MEM, fw_MEM}), .sel(MemRead_MEM));

    mux64_4_1 fwdB_yes (.out(Db_ID), .in({ALUOut, fw_MEM_actual, fw_WB, Db_bf}), .sel(fwdB_sel));
    mux64_4_1 fwdA_yes (.out(Da_ID), .in({ALUOut, fw_MEM_actual, fw_WB, Da_bf}), .sel(fwdA_sel));

    // Zero Check
    logic zeroTemp_ID;
    zeroCheck whenzero (.B(Db_ID), .zeroCheckValue(zeroTemp_ID));

    // Branch Logic 
    branchLogic ifbranch (OF, Neg, zeroTemp_ID, BLT_ID, Branch_ID, UncondBr_ID, BrTake);

    // Pipeline
    output logic [63:0] pc_4_EX, Db_EX, Da_EX;
    output logic [31:0] instructionData_EX;
	 output logic [4:0] Rd_EX, Rn_EX, Rm_EX;
    output logic [2:0] ALUOp_EX;
    output logic MemToReg_EX, RegWrite_EX, BLT_EX, UncondBr_EX, Branch_EX, MemRead_EX, MemWrite_EX, ALUI_EX, ALUSrc_EX; 
    ID_EX pip (.PC_4_in(pc_4_ID), .ALUOp_in({1'b0, ALUOp_ID[1], ALUOp_ID[0]}), .MemToReg_in(MemToReg_ID), .RegWrite_in(RegWrite_ID), .Rd_in(Rd_ID), .BL_in(BL_ID), 
                    .Db_in(Db_ID), .Da_in(Da_ID), .Rm_in(Rm_ID), .Rn_in(Rn_ID), .BrAdd_in(BrAdd_ID), .BLT_in(BLT_ID), .UncondBr_in(UncondBr_ID), .Branch_in(Branch_ID), 
                        .MemRead_in(MemRead_ID), .MemWrite_in(MemWrite_ID), .ALUI_in(ALUI_ID), .ALUSrc_in(ALUSrc_ID), .PC_4_out(pc_4_EX), .ALUOp_out(ALUOp_EX), .MemToReg_out(MemToReg_EX), 
                            .RegWrite_out(RegWrite_EX), .Rd_out(Rd_EX), .BL_out(BL_EX), .Db_out(Db_EX), .Da_out(Da_EX), .Rm_out(Rm_EX), .Rn_out(Rn_EX), .BrAdd_out(BrAdd_EX), .BLT_out(BLT_EX), 
                                .UncondBr_out(UncondBr_EX), .Branch_out(Branch_EX), .MemRead_out(MemRead_EX), .MemWrite_out(MemWrite_EX), .ALUI_out(ALUI_EX), .ALUSrc_out(ALUSrc_EX), 
												.instructions_in(instructionData_ID[31:0]), .instructions_out(instructionData_EX[31:0]), .clk(clk), .reset(reset)); 
												
    //---------------------------------------- EXECUTE --------------------------------------------------
    // ALU and it's Logic
    // logic [63:0] aIntoALU;
    // forward fwdA (.passOut(Da_EX), .MemToRegOut(fw_WB), .ALUMemOut(fw_MEM), .forwardSEL(fwdA_sel), .out(aIntoALU));
    // forward fwdB (.passOut(Db_EX), .MemToRegOut(fw_WB), .ALUMemOut(fw_MEM), .forwardSEL(fwdB_sel), .out(intoALUSrc_0));

    logic [63:0] intoALUSrc_1, intoALUI_1;
    signExtender_9 SignEx (.in(instructionData_EX[20:12]), .out(intoALUSrc_1));
    zeroExtend UnsignedEx (.in(instructionData_EX[21:10]), .out(intoALUI_1));

    logic [63:0] intoALUI_0, bIntoALU;
    mux64_2_1 alusrc (.in({intoALUSrc_1, Db_EX}), .sel(ALUSrc_EX), .out(intoALUI_0));
    mux64_2_1 aluimmed (.in({intoALUI_1, intoALUI_0}), .sel(ALUI_EX), .out(bIntoALU));

    logic negative, overflow, carryout;
    alu ALunit (.A(Da_EX), .B(bIntoALU), .ctrl(ALUOp_EX), .result(ALUOut), .negative(negative), .zero(zeroTemp), .overflow(overflow), .carryout(carryout));

    // Flags
    logic Neg_imm, OF_imm, Neg_delayed, OF_delayed;
	 logic enableFlags, not23;
	 not #delay (not23, instructionData_EX[23]);
	 and #delay (enableFlags, instructionData_EX[25], instructionData_EX[24], not23);
     mux2_1 negativeFlag_imm (.out(Neg_imm), .i1(negative), .i0(false), .sel(enableFlags));
     mux2_1 overflowFlag_imm (.out(OF_imm), .i1(overflow), .i0(false), .sel(enableFlags));
	 DFF_Enabled negativeFlag_delayed (.reset(reset), .enable(enableFlags), .in(negative), .out(Neg_delayed), .clk(clk));
	 DFF_Enabled overflowFlag_delayed (.reset(reset), .enable(enableFlags), .in(overflow), .out(OF_delayed), .clk(clk));
    mux2_1 negFLAG (.out(Neg), .i1(Neg_imm), .i0(Neg_delayed), .sel(enableFlags));
    mux2_1 OFFLAG (.out(OF), .i1(OF_imm), .i0(OF_delayed), .sel(enableFlags));

    //------------------------------------- MEMORY ACCESS -----------------------------------------------
	 output logic [7:0] mem [`DATA_MEM_SIZE-1:0];	 
	 // Pipeline
	 output logic [63:0] Db_MEM;
	 output logic [4:0] Rd_MEM;
	 output logic MemToReg_MEM, RegWrite_MEM, MemWrite_MEM;
	 EX_MEM pip2(pc_4_EX, ALUOut, MemToReg_EX, RegWrite_EX, Rd_EX, BL_EX, Db_EX, MemRead_EX, MemWrite_EX, pc_4_MEM, 
                 ALUOut_MEM, MemToReg_MEM, RegWrite_MEM, Rd_MEM, BL_MEM, Db_MEM, MemRead_MEM, MemWrite_MEM, clk, reset); 
					  
	 datamem RAM(ALUOut_MEM, MemWrite_MEM, MemRead_MEM, Db_MEM, clk, 4'b1000, MemDOut_MEM, mem);
	 
    //-------------------------------------- WRITE BACK -------------------------------------------------
	 
	 // Pipeline
	 output logic [63:0] ALUOut_WB;
	 output logic MemToReg_WB;
     MEM_WB pip3(.PC_4_in(pc_4_MEM), .ALUOut_in(ALUOut_MEM), .MemToReg_in(MemToReg_MEM), .RegWrite_in(RegWrite_MEM), .Rd_in(Rd_MEM), .BL_in(BL_MEM), .MemDOut_in(MemDOut_MEM), 
					.PC_4_out(pc_4_WB), .ALUOut_out(ALUOut_WB), .MemToReg_out(MemToReg_WB), .RegWrite_out(RegWrite_WB), .Rd_out(Rd_WB), .BL_out(BL_WB), .MemDOut_out(MemDOut_WB), .clk(clk), .reset(reset));
	//  MEM_WB pip3(pc_4_MEM, ALUOut_MEM, MemToReg_MEM, RegWrite_MEM, Rd_MEM, BL_MEM, MemDOut_MEM, pc_4_WB, 
                //  ALUOut_WB, MemToReg_WB, RegWrite_WB, Rd_WB, BL_WB, MemDOut_WB, clk, reset); 
	 
	 mux64_2_1 muxFinal(.out(Mem2RegOut), .in({MemDOut_WB, ALUOut_WB}), .sel(MemToReg_WB));
	 
	 
	 //-------------------------------------- FORWARDING UNIT -------------------------------------------------
	 
	 FWRD_UNIT unit(Rd_EX, Rd_MEM, Rd_WB, Rn_ID, Rm_ID, RegWrite_EX, RegWrite_MEM, RegWrite_WB, fwdA_sel, fwdB_sel);

endmodule


module pipelinedCPU_testbench();
    logic clk, reset;
     logic [63:0] fw_MEM, fw_WB;
	 logic [31:0][63:0] fullRegister;
	 logic [1:0] fwdA_sel, fwdB_sel;
	 logic [63:0] pc_IF;
	 logic [7:0] mem [`DATA_MEM_SIZE-1:0]; 
	 logic [63:0] ALUOut_MEM;
	 logic [63:0] Mem2RegOut;
	 logic [63:0] Db_ID, fw_MEM_actual;
	 logic BrTake, zeroTemp;
	 logic Neg, OF;
	 logic [63:0] pc_4_WB;
	 logic RegWrite_WB, BL_WB;
	 logic [63:0] BrAdd_EX;
	 logic [31:0] instructionData_IF;
	 logic [63:0] pc_4_ID, pc_ID;
	 logic [31:0] instructionData_ID; 
	 logic [1:0] ALUOp_ID;																																					
	 logic Br, Reg2Loc, MemToReg_ID, RegWrite_ID, Branch_ID, BL_ID, BLT_ID, UncondBr_ID, MemRead_ID, MemWrite_ID, ALUI_ID, ALUSrc_ID; 	
	 logic [63:0] BrAdd_ID;
	 logic [4:0] AW, Ab, Rd_ID, Rd_WB;
	 logic [63:0] Da_ID, DW; 
	 logic [4:0] Rn_ID, Rm_ID;
	 logic [63:0] pc_4_EX, Db_EX, Da_EX;
	 logic [31:0] instructionData_EX;
	 logic [4:0] Rd_EX, Rn_EX, Rm_EX;
	 logic [2:0] ALUOp_EX;
	 logic MemToReg_EX, RegWrite_EX, BL_EX, BLT_EX, UncondBr_EX, Branch_EX, MemRead_EX, MemWrite_EX, ALUI_EX, ALUSrc_EX; 
	 logic [63:0] ALUOut;
	 logic [63:0] pc_4_MEM, Db_MEM;
	 logic [4:0] Rd_MEM;
	 logic MemToReg_MEM, RegWrite_MEM, BL_MEM, MemRead_MEM, MemWrite_MEM;
	 logic [63:0] MemDOut_MEM;
	 logic [63:0] ALUOut_WB, MemDOut_WB;
	 logic MemToReg_WB;
	 logic [63:0] pc_4_IF, pc_in;	 
	  
	 parameter delay = 10000; // 10000
	 
    pipelinedCPU dut(clk, reset, fullRegister, mem, 
					pc_IF, instructionData_IF, pc_4_IF, pc_in,
					Db_ID, pc_4_ID, pc_ID, instructionData_ID, ALUOp_ID, BrAdd_ID, Br, Reg2Loc, MemToReg_ID, RegWrite_ID, Branch_ID, BL_ID, BLT_ID, UncondBr_ID, MemRead_ID, MemWrite_ID, ALUI_ID, ALUSrc_ID, BrTake, zeroTemp, Neg, OF, AW, Ab, Rd_ID, Rd_WB, Da_ID, DW, Rn_ID, Rm_ID,
					BrAdd_EX, pc_4_EX, Db_EX, Da_EX, instructionData_EX, Rd_EX, Rn_EX, Rm_EX, ALUOp_EX, MemToReg_EX, RegWrite_EX, BL_EX, BLT_EX, UncondBr_EX, Branch_EX, MemRead_EX, MemWrite_EX, ALUI_EX, ALUSrc_EX, ALUOut,
					ALUOut_MEM, pc_4_MEM, Db_MEM, Rd_MEM, MemToReg_MEM, RegWrite_MEM, BL_MEM, MemRead_MEM, MemWrite_MEM, MemDOut_MEM,
					fwdA_sel, fwdB_sel, pc_4_WB, RegWrite_WB, BL_WB, Mem2RegOut, ALUOut_WB, MemDOut_WB, MemToReg_WB, fw_MEM, fw_WB, fw_MEM_actual);
	 
	 initial begin // Set up the clock FOR TESTING
        clk <= 0;
        repeat(100) begin // CHANGE TO NEEDED AMOUNT
            #450 clk <= ~clk;
        end
    end
	
    initial begin
        reset <= 1; @(posedge clk);
        reset <= 0; @(posedge clk);
    end

endmodule
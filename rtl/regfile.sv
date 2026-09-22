module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk, fullRegister);
	input logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0]	WriteData;
	input logic 			RegWrite, clk;
	output logic [63:0]	ReadData1, ReadData2;
	
	// Decoder variables
	logic [31:0] writeOut;

	// Register variables
	output logic [31:0][63:0] fullRegister;
	logic true = 1'b1;
	logic false = 1'b0;
	
	decoder5_32 writeDecoder(WriteRegister, writeOut, RegWrite); 
	mux64_32_1 firstMux (ReadData1, fullRegister, ReadRegister1);
	mux64_32_1 secondMux (ReadData2, fullRegister, ReadRegister2);
	
	genvar i;
	generate
		for (i = 0; i < 31; i++) begin: loop
			singleRegister_Negative registerNum(false, writeOut[i], WriteData, fullRegister[i], clk);
		end
	endgenerate
	
	singleRegister_Negative reg31(true, false, WriteData, fullRegister[31], clk);
	
endmodule
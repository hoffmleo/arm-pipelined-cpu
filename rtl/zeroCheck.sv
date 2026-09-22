`timescale 1ps/1ps
module zeroCheck (B, zeroCheckValue);
   input logic [63:0] B;
	output logic zeroCheckValue;
	
	logic [16:0] temp;
	logic [4:0] tempCombined;
   parameter delay = 50;
	
	// Zero Flag
	or #delay zeroGate1 (temp[0], B[63], B[62], B[61], B[60]);
	or #delay zeroGate2 (temp[1], B[59], B[58], B[57], B[56]);
	or #delay zeroGate3 (temp[2], B[55], B[54], B[53], B[52]);
	or #delay zeroGate4 (temp[3], B[51], B[50], B[49], B[48]);
	or #delay zeroGate5 (temp[4], B[47], B[46], B[45], B[44]);
	or #delay zeroGate6 (temp[5], B[43], B[42], B[41], B[40]);
	or #delay zeroGate7 (temp[6], B[39], B[38], B[37], B[36]);
	or #delay zeroGate8 (temp[7], B[35], B[34], B[33], B[32]);
	or #delay zeroGate9 (temp[8], B[31], B[30], B[29], B[28]);
	or #delay zeroGate10 (temp[9], B[27], B[26], B[25], B[24]);
	or #delay zeroGate11 (temp[10], B[23], B[22], B[21], B[20]);
	or #delay zeroGate12 (temp[11], B[19], B[18], B[17], B[16]);
	or #delay zeroGate13 (temp[12], B[15], B[14], B[13], B[12]);
	or #delay zeroGate14 (temp[13], B[11], B[10], B[9], B[8]);
	or #delay zeroGate15 (temp[14], B[7], B[6], B[5], B[4]);	
	or #delay zeroGate16 (temp[15], B[3], B[2], B[1], B[0]);
	or #delay zeroGate17 (tempCombined[3], temp[3], temp[2], temp[1], temp[0]);
	or #delay zeroGate18 (tempCombined[2], temp[7], temp[6], temp[5], temp[4]);
	or #delay zeroGate19 (tempCombined[1], temp[11], temp[10], temp[9], temp[8]);
	or #delay zeroGate20 (tempCombined[0], temp[15], temp[14], temp[13], temp[12]);
	nor #delay zeroGate21 (zeroCheckValue, tempCombined[3], tempCombined[2], tempCombined[1], tempCombined[0]);
	 
endmodule


module zeroCheck_testbench();
	logic [63:0] B;
	logic val;
	parameter delay = 20000;
	
	zeroCheck dut(B, val);	
	initial begin
		B = 64'h819460BCE0A5D9FA; #delay;
		B = 64'h0000000000000000; #delay;
		B = 64'hFFFFFFFFFFFFFFFF; #delay;
		B = 64'hAAAAAAAAAAAAAAAA; #delay;
	end
	
endmodule
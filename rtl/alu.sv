`timescale 1ps/1ps
module alu (A, B, ctrl, result, negative, zero, overflow, carryout);
   input logic [63:0] A, B;
   input logic [2:0] ctrl;
	
   output logic [63:0] result;
   output logic negative, zero, overflow, carryout;
	
	logic [7:0][63:0] allResults;
	logic [63:0] notB;
	logic addCarryout, subCarryout, addOverflow, subOverflow;
	logic [16:0] temp;
	logic [4:0] tempCombined;
	logic tempCarryout, tempOverflow, notSecond, notSecondCarry;
	logic true = 1'b1;
	logic false = 1'b0;
   parameter delay = 50;

	// Selections
	genvar i;
   generate 
		for (i = 0; i < 64; i++)    begin: loop
			buf #delay keepB(allResults[0][i], B[i]);
		end
   endgenerate
	
	bitwise_not notForSub (B, notB);
	adder_64bit addOption (A, B, false, allResults[2], addCarryout, addOverflow);
	adder_64bit subOption (A, notB, true, allResults[3], subCarryout, subOverflow);
	bitwise_and andOption (A, B, allResults[4]);
	bitwise_or  orOption (A, B, allResults[5]);
	bitwise_xor xorOption (A, B, allResults[6]);
	mux64_8_1 controlGate (result, allResults, ctrl);
	
	
	// ------ FLAGS --------
	not #delay notGate (notSecondCarry, ctrl[2]);
	
	// Overflow Flag
	mux2_1 overflowGate (tempOverflow, addOverflow, subOverflow, ctrl[0]);
	and #delay overflowAnd (overflow, tempOverflow, ctrl[1], notSecondCarry);
	
	// Carryout Flag
	mux2_1 carryoutGate (tempCarryout, addCarryout, subCarryout, ctrl[0]);
	and #delay carryoutAnd (carryout, tempCarryout, ctrl[1], notSecondCarry);	
	
	// Negative Flag
	buf #delay negativeGate (negative, result[63]);
	
	// Zero Flag
	or #delay zeroGate1 (temp[0], result[63], result[62], result[61], result[60]);
	or #delay zeroGate2 (temp[1], result[59], result[58], result[57], result[56]);
	or #delay zeroGate3 (temp[2], result[55], result[54], result[53], result[52]);
	or #delay zeroGate4 (temp[3], result[51], result[50], result[49], result[48]);
	or #delay zeroGate5 (temp[4], result[47], result[46], result[45], result[44]);
	or #delay zeroGate6 (temp[5], result[43], result[42], result[41], result[40]);
	or #delay zeroGate7 (temp[6], result[39], result[38], result[37], result[36]);
	or #delay zeroGate8 (temp[7], result[35], result[34], result[33], result[32]);
	or #delay zeroGate9 (temp[8], result[31], result[30], result[29], result[28]);
	or #delay zeroGate10 (temp[9], result[27], result[26], result[25], result[24]);
	or #delay zeroGate11 (temp[10], result[23], result[22], result[21], result[20]);
	or #delay zeroGate12 (temp[11], result[19], result[18], result[17], result[16]);
	or #delay zeroGate13 (temp[12], result[15], result[14], result[13], result[12]);
	or #delay zeroGate14 (temp[13], result[11], result[10], result[9], result[8]);
	or #delay zeroGate15 (temp[14], result[7], result[6], result[5], result[4]);	
	or #delay zeroGate16 (temp[15], result[3], result[2], result[1], result[0]);
	or #delay zeroGate17 (tempCombined[3], temp[3], temp[2], temp[1], temp[0]);
	or #delay zeroGate18 (tempCombined[2], temp[7], temp[6], temp[5], temp[4]);
	or #delay zeroGate19 (tempCombined[1], temp[11], temp[10], temp[9], temp[8]);
	or #delay zeroGate20 (tempCombined[0], temp[15], temp[14], temp[13], temp[12]);
	nor #delay zeroGate21 (zero, tempCombined[3], tempCombined[2], tempCombined[1], tempCombined[0]);
	 
endmodule
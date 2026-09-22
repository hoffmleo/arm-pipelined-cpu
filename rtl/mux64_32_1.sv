module mux64_32_1 (out, in, sel);
    input logic  [31:0][63:0] in;
    input logic  [4:0] sel;
    output logic [63:0] out;

    genvar i;
    generate 
		 for (i=0; i<64; i++)    begin: loop
			  mux32_1 TheOutput (.out(out[i]),
					.in({in[31][i], in[30][i], in[29][i], in[28][i], in[27][i], in[26][i], in[25][i], in[24][i], 
						 in[23][i], in[22][i], in[21][i], in[20][i], in[19][i], in[18][i], in[17][i], in[16][i],
							  in[15][i], in[14][i], in[13][i], in[12][i], in[11][i], in[10][i], in[9][i], in[8][i],
									in[7][i], in[6][i], in[5][i], in[4][i], in[3][i], in[2][i], in[1][i], in[0][i]}), 
												  .sel(sel[4:0]));
		 end
    endgenerate 
endmodule

module mux64_32_1_testbench();
    logic [31:0][63:0] in;
    logic [4:0] sel;
    logic [63:0] out;
    parameter delay = 100;

    mux64_32_1 dut (.out, .in, .sel);

    integer i;
    initial begin 
        in[0][63:0] = 64'hB13ACEFAFFFFFFFF; 
        in[1][63:0] = 64'h0FF0F0FADEF02310;
        in[2][63:0] = 64'hF0FF0DCDEF123F0F;
        in[3][63:0] = 64'hFFF0ADCD83200FF0;
        in[4][63:0]=  64'hF01394103900FFFF;
        in[5][63:0] = 64'hFFF31032093FFFF1;
        in[6][63:0] = 64'h0FF0F0F192834921;
        in[7][63:0] = 64'hF0FF012A92314F01;
        in[8][63:0] = 64'hFFF0029452340FF1;
        in[9][63:0] = 64'hF000FF90148502F1;
        in[10][63:0] = 64'hB13ACEFAFFFFFFFF;
        in[11][63:0] = 64'h0FF0F0FADEF02310;
        in[12][63:0] = 64'hF0ABCDCDEF123F0A;
        in[13][63:0] = 64'hFFF0ADCD83200FFA;
        in[14][63:0] = 64'hF01394103900FFFA;
        in[15][63:0] = 64'hFFF31032093FFFFA;
        in[16][63:0] = 64'h0FF0F0F19283492A;
        in[17][63:0] = 64'hF0FF012A92314F0A;
        in[18][63:0] = 64'hFFF0029452340FFA;
        in[19][63:0] = 64'hF000FF90148502FA;
        in[20][63:0] = 64'hB13ACEFAFFFFFFFB;
        in[21][63:0] = 64'h0FF0F0FADEF0231B;
        in[22][63:0] = 64'hF0FF0DCDEF123F0B;
        in[23][63:0] = 64'hFFF0ADCD83200FFB;
        in[24][63:0] = 64'hF01394103900FFFB;
        in[25][63:0] = 64'hFFF31032093FFFFB;
        in[26][63:0] = 64'h0FF0F0F19283492B;
        in[27][63:0] = 64'hF0FF012A92314F0B;
        in[28][63:0] = 64'hFFF0029452340FFB;
        in[29][63:0] = 64'hF000FF90148502FB;
        in[30][63:0] = 64'hB13ACEFAFFFFFFFC;
        in[31][63:0] = 64'h0FF0F0FADEF0231C; 

        for (i=0; i<32; i++) begin: loop
            {sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
        end
    end
endmodule




//module mux64_32_1 (out, in, sel);
//    input logic [63:0][31:0] in;
//    input logic  [4:0] sel;
//    output logic [63:0] out;
//
//    genvar i;
//    generate 
//		 for (i=0; i<64; i++)    begin
//			 mux32_1 TheOutput (out[i], in[i], sel[4:0]);
//		 end
//    endgenerate 
//endmodule

//
//
//module mux64_32_1_testbench();
//	logic [63:0][31:0] in;
//	logic [4:0] sel;
//	logic [63:0] out;
//	parameter delay = 10;
//
//	mux64_32_1 dut (.out, .in, .sel);
//
//	integer i;
//	initial begin 
//		in[63] = 32'b01110000111100001111000011110010;
//		in[62] = 32'b00000000000000000000000000000000;
//		in[61] = 32'b11111111111111111111111111111111;
//		in[60] = 32'b10101010101010101010101010101010;
//		for (i = 0; i < 60; i++) begin
//			in[i] = 32'b01110000111100001111000011110010 + i;
//		end
//
//		for (i=0; i<32; i++) begin
//			{sel[4], sel[3], sel[2], sel[1], sel[0]} = i; #delay;
//		end
//	end
//endmodule

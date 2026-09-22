module D_FF_Negative(q, d, reset, clk);
	output reg q;
	input d, reset, clk;
	
	always_ff @(negedge clk) begin
		if (reset)
			q <= 0;
		else
			q <= d;
	end
endmodule

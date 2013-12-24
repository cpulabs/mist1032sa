
`default_nettype none


module frcr_timer(
		input wire  iCLOCK,
		input wire  inRESET,
		input wire  iWR_ENA,
		input wire  [63:0] iRW_COUNTER,
		output wire  [63:0] oCOUNTER
	);

	reg [63:0] b_counter;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_counter <= {64{1'b0}};
		end
		else if(iWR_ENA)begin
			b_counter <= iRW_COUNTER;
		end
		else begin
			b_counter <= b_counter + 64'h1;
		end
	end
	
	assign	oCOUNTER = b_counter;
endmodule


`default_nettype wire

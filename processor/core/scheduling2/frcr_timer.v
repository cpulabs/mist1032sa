
`default_nettype none


module frcr_timer(
		input					iCLOCK,
		input					inRESET,
		input					iWR_ENA,
		input	[63:0]			iRW_COUNTER,
		output	[63:0]			oCOUNTER
	);

	reg		[63:0]		b_counter;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_counter		<=		{64{1'b0}};
		end
		else if(iWR_ENA)begin
			b_counter		<=		iRW_COUNTER;
		end
		else begin
			b_counter		<=		b_counter + 64'h1;
		end
	end
	
	assign	oCOUNTER	=	b_counter;
endmodule


`default_nettype wire

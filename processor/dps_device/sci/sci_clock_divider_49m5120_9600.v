
`default_nettype none


module sci_clock_divider_49m5120_9600(
		input				inRESET,
		input				iCLOCK,
		output				oCLOCK
	);

	reg		[8:0]		counter;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			counter		<=		9'h0;
		end
		else begin
			counter		<=		counter + 9'h1;
		end
	end
	
	assign	oCLOCK			=		counter[8];
	
endmodule

			
`default_nettype wire

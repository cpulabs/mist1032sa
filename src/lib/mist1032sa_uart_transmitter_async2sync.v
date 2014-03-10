
`default_nettype none

module mist1032sa_uart_transmitter_async2sync #(
		parameter N = 1
	)(
		input wire iCLOCK,
		input wire inRESET,
		//Ena-Signal
		input wire [N-1:0] iSIGNAL,
		output wire [N-1:0] oSIGNAL
	);
	
	reg [N-1:0] b_buffer;
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_buffer <= {N{1'b0}};
		end
		else begin
			b_buffer <= iSIGNAL;
		end
	end
	
	assign oSIGNAL = iSIGNAL & ~b_buffer;
	
endmodule

`default_nettype wire 

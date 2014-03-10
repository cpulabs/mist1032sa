
`default_nettype none

module mist1032sa_uart_receiver_double_flipflop
	#(
		parameter N = 1
	)(
		input wire iCLOCK,
		input wire inRESET,
		//Input
		input wire [N-1:0] iREQ_DATA,
		//Output
		output wire [N-1:0] oOUT_DATA
	);
	
	
	reg [N-1:0] b_data0/* synthesis preserve = 1 */;		//Altera QuartusII Option
	reg [N-1:0] b_data1/* synthesis preserve = 1 */;		//Altera QuartusII Option
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_data0 <= {N{1'b0}};
			b_data1 <= {N{1'b0}};
		end
		else begin
			b_data0 <= iREQ_DATA;
			b_data1 <= b_data0;
		end
	end
	
	assign oOUT_DATA = b_data1;
	
endmodule

`default_nettype wire

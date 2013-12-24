

`default_nettype none

module mist1032sa_async_fifo_double_flipflop #(
		parameter N = 1
	)(
		input wire iCLOCK,
		input wire inRESET,
		//Input
		input wire [N-1:0] iREQ_DATA,
		//Output
		output wire [N-1:0] oOUT_DATA
	);
	
	
	(* equivalent_register_removal = "no" *) (* syn_preserve = 1 *) (* register_duplication = "no" *) (* syn_replicate = 0 *) reg [N-1:0] b_data0;		//Xilinx XST and Altera QuartusII Option
	(* equivalent_register_removal = "no" *) (* syn_preserve = 1 *) (* register_duplication = "no" *) (* syn_replicate = 0 *) reg [N-1:0] b_data1;		//Xilinx XST and Altera QuartusII Option
	
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

	
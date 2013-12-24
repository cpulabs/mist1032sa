`default_nettype none 

module pipeline_register #(
		parameter P_N = 32
	)(
		input wire iCLOCK,
		input wire inRESET,
		input wire iRESET_SYNC,
		//
		input wire iPREV_REQ,
		output wire oPREV_BUSY,
		input wire [P_N-1:0] iPREV_DATA,
		//
		output wire oNEXT_REQ,
		input wire iNEXT_BUSY,
		output wire [P_N-1:0] oNEXT_DATA
	);

	reg b_valid;
	reg [P_N-1:0] b_data;

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_valid <= 1'b0;
			b_data <= {P_N{1'b0}};
		end
		else if(iRESET_SYNC)begin
			b_valid <= 1'b0;
			b_data <= {P_N{1'b0}};
		end
		else begin
			if(!iNEXT_BUSY || (!b_valid && iNEXT_BUSY))begin
				b_valid <= iPREV_REQ;
				b_data <= iPREV_DATA;
			end
		end

	end

	assign oNEXT_REQ = b_valid;
	assign oNEXT_DATA = b_data;

	assign oPREV_BUSY = iNEXT_BUSY && b_valid;

endmodule

`default_nettype wire 


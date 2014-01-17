
`default_nettype none


module dps_lsflags(
		input wire iCLOCK,
		input wire inRESET,
		input wire iRESET_SYNC,
		//
		input wire iSCI_VALID,
		input wire iSCI_SCITIE,
		input wire iSCI_SCIRIE,
		//
		input wire iREAD_VALID,
		//
		output wire oLSFLAGS_VALID,
		output wire [31:0] oLSFLAGS
	);
	
	reg [31:0] b_lsflags;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_lsflags <= 32'h0;
		end
		else if(iRESET_SYNC || iREAD_VALID)begin
			b_lsflags <= 32'h0;
		end
		else begin
			if(iSCI_VALID)begin
				b_lsflags <= {30'h0, iSCI_SCIRIE, iSCI_SCITIE}; 
			end
		end
	end
	
	reg b_valid;
	reg [31:0] b_buff_lsflags;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_valid <= 1'b0;
			b_buff_lsflags <= 32'h0;
		end
		else if(iRESET_SYNC)begin
			b_valid <= 1'b0;
			b_buff_lsflags <= 32'h0;
		end
		else begin
			b_valid <= iREAD_VALID;
			b_buff_lsflags <= b_lsflags;
		end
	end	
	
	assign oLSFLAGS_VALID = b_valid;
	assign oLSFLAGS = b_buff_lsflags;
	
endmodule

`default_nettype wire 

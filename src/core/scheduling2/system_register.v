`default_nettype none



module system_register(
				//System
				input wire iCLOCK,
				input wire inRESET,		
				//Regist
				input wire iREGIST_DATA_VALID,
				input wire [31:0] iREGIST_DATA,
				//Info
				output wire [31:0] oINFO_DATA);
	
	reg [31:0] b_data;
	
	
	always@(negedge inRESET or posedge iCLOCK)begin
		if(!inRESET)begin	
			b_data <= {32{1'b0}};
		end
		else begin
			if(iREGIST_DATA_VALID)begin
				b_data <= iREGIST_DATA;
			end
		end
	end //always

	assign oINFO_DATA = b_data;
	
endmodule



`default_nettype wire




`default_nettype none

module sysreg_spr_register #(
		parameter N = 32
	)(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Regist
		input wire iREGIST_REQ,
		input wire [N-1:0] iREGIST_DATA,
		//Info
		output wire [N-1:0] oINFO_DATA
	);				
						
	reg [N-1:0] b_spr;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_spr <= {N{1'b0}};
		end
		else begin
			if(iREGIST_REQ)begin
				b_spr <= iREGIST_DATA;
			end
		end
	end //always SPR Register
	
	
	assign oINFO_DATA = b_spr;	
	
endmodule


`default_nettype wire


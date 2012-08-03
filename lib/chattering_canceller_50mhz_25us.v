
`default_nettype none
/*******************************************************
	Chattaring Canceller
	Main freq		: 50Mhz
	Sampling Rate	: 25uS
	Make	:	2010/10/01
	Update	:	2011/07/17
*******************************************************/

module chattering_canceller_50mhz_25us(iCLOCK, inRESET, iDATA, oDATA);
	parameter	N	=	1;
	input				iCLOCK;
	input				inRESET;		
	input	[N-1:0]		iDATA;
	output	[N-1:0]		oDATA;
	
	reg		[N-1:0]		bData;
	reg		[5:0]		counter;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			bData					<=		{N{1'b0}};
			counter					<=		{6{1'b0}};
		end
		else begin
			counter					<=		counter + 6'h01;
			if(counter == 6'h00)begin
				bData					<=		iDATA;
			end
		end
	end //timing
	
	assign		oDATA		=		bData;
	
endmodule


`default_nettype wire


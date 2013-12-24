`default_nettype none



module main_counter(		
		input				iCLOCK,
		input				inRESET,
		//Config Write
		input				iCONF_WRITE,
		input				iCONF_ENA,
		//Counter Write
		input				iCOUNT_WRITE,
		input	[1:0]		inCOUNT_DQM,
		input	[63:0]		iCOUNT_COUNTER,
		//Output
		output				oWORKING,
		output	[63:0]		oCOUNTER
	);
	
	
			
	//Counter
	reg						b_working;
	reg		[63:0]			b_counter;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_working		<=		1'b0;
			b_counter		<=		{64{1'b0}};
		end
		else begin
			//Config Mode
			if(iCONF_WRITE)begin
				b_working		<=		iCONF_ENA;
			end
			begin
				if(b_working)begin
					//Count UP
					b_counter		<=		b_counter + 64'h00000001;
				end
				else begin
					//Stop
					if(iCOUNT_WRITE)begin
						b_counter[31:0]	<=		(!inCOUNT_DQM[0])? iCOUNT_COUNTER[31:0] : b_counter[31:0];
						b_counter[63:32]<=		(!inCOUNT_DQM[1])? iCOUNT_COUNTER[63:32] : b_counter[63:32];
					end
				end
			end
		end
	end
	
	assign		oCOUNTER		=		b_counter;
	assign		oWORKING		=		b_working;
		
endmodule
`default_nettype wire

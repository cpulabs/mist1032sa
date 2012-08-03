
`default_nettype none

module ps2_receive(
					input				iCLOCK,
					input				inRESET,
					//Receive
					output				oPS2MOD_REQ,
					output	[7:0]		oPS2MOD_DATA,
					//PS2
					input				iPS2_CLOCK,
					input				iPS2_DATA);	
			
	//PS2 Interface
	wire	[7:0]		wRevScancode;
	//Chattaring 
	wire				ps2_clk;
	wire				ps2_data;
	//State
	reg					bHighFlag;
	reg		[3:0]		bState;
	reg		[7:0]		bPs2Scancode;
						
	//PS2 Interface  Module
	generate
		genvar	i;
		for(i = 0; i < 8; i = i + 1)begin : BIT_REVIRCE
			assign	wRevScancode[i]		=		bPs2Scancode[7-i];
		end
	endgenerate
	
	//Chattaring Camceller Module
	chattering_canceller_50mhz_25us #(2) PS2_CHATTA_CAN(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iDATA({iPS2_CLOCK, iPS2_DATA}),
		.oDATA({ps2_clk, ps2_data})
	);
	
	
	//State				
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			bHighFlag		<=		1'b0;
			bState			<=		{4{1'b0}};
			bPs2Scancode	<=		{8{1'b0}};
		end
		else begin
			if(bState == 4'hB)begin
				bState			<=		4'h0;
				bHighFlag		<=		1'b0;
			end
			else if(ps2_clk)begin
				bHighFlag		<=		1'b1;
			end
			else if(bHighFlag & !ps2_clk)begin
				case(bState)
					4'h0:
						begin
							bState			<=		bState + {{3{1'b0}}, 1'b1};	
							bHighFlag		<=		1'b0;
						end
					4'h1, 4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7, 4'h8:
						begin
							bState			<=		bState + {{3{1'b0}}, 1'b1};
							bHighFlag		<=		1'b0;
							bPs2Scancode	<=		((bPs2Scancode << 1) & 8'hFF) |  {7'h00, ps2_data};
						end
					4'h9:
						begin
							bState			<=		bState + {{3{1'b0}}, 1'b1};
							bHighFlag		<=		1'b0;
						end
					default:		//Stop Bit(Data Get End)
						begin
							bState			<=		bState + {{3{1'b0}}, 1'b1};
							bHighFlag		<=		1'b0;
						end
				endcase
			end
		end
	end //always
	
	
	/***********************************
	Output Asssign
	***********************************/
	assign		oPS2MOD_REQ		=		(bState == 4'hB)? 1'b1 : 1'b0;
	assign		oPS2MOD_DATA	=		(bState == 4'hB)? wRevScancode : {8{1'b0}};
	
endmodule


`default_nettype wire

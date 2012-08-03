`default_nettype none
//VGA Clock is 25.2MHz

module vgatiming_640x480_60hz(
									input				iVGA_CLOCK,
									input				inRESET,
									//PIXCEL
									output				oDATA_REQ,
									//DISP Out
									output				oDISP_VSYNC,
									output				oDISP_HSYNC,
									output				oDISP_BLANK);
	
	reg	[9:0]		b_hs_counter;
	reg	[9:0]		b_vs_counter;
	//95, 47.5, 635, 15
	always@(posedge iVGA_CLOCK or negedge inRESET)begin
		if(!inRESET)begin	
			b_hs_counter		<=		{10{1'b0}};
			b_vs_counter		<=		{10{1'b0}};
		end
		else begin
			b_hs_counter		<=		(b_hs_counter < 10'd96 +10'd 48 + 10'd640 + 10'd16)? b_hs_counter + {{9{1'b0}}, 1'b1} : {10{1'b0}};
			b_vs_counter		<=		(!(b_hs_counter == 10'd0))? b_vs_counter : (b_vs_counter < 10'd525)? b_vs_counter + {{9{1'b0}}, 1'b1} : {10{1'b0}};//(b_vs_counter < (800*2) + (800*33) + (800*480) + (800*10))? b_vs_counter + {{18{1'b0}}, 1'b1} : {19{1'b0}};
		end
	end
	
	assign	oDISP_BLANK		=		(b_hs_counter > 10'd96 + 10'd48 & b_hs_counter <= 10'd96 + 10'd48/*48*/ + 10'd640/*635*/ & b_vs_counter > 10'd2 + 10'd33 &  b_vs_counter <= 10'd2 + 10'd33 + 10'd480)? 1'b0 : 1'b1;
	assign	oDATA_REQ		=		(b_hs_counter > 10'd96 + 10'd48 & b_hs_counter <= 10'd96 + 10'd48 + 10'd640 & b_vs_counter > 10'd2 + 10'd33 &  b_vs_counter <= 10'd2 + 10'd33 + 10'd480)? 1'b1 : 1'b0;
	
	assign	oDISP_HSYNC		=		(b_hs_counter < 10'd95)? 1'b0 : 1'b1;
	assign	oDISP_VSYNC		=		(b_vs_counter < 10'd2)? 1'b0 : 1'b1;//(b_vs_counter > 800*2 & b_vs_counter < (800*2) + (800*33) + (800*480) + (800*10))? 1'b1 : 1'b0;
	
	
endmodule


`default_nettype wire

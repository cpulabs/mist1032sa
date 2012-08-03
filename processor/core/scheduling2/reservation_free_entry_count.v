
`default_nettype none


module reservation_free_entry_count(
				input			iINFO0,
				input			iINFO1,
				input			iINFO2,
				input			iINFO3,
				input			iINFO4,
				input			iINFO5,
				input			iINFO6,
				input			iINFO7,
				input			iINFO8,
				input			iINFO9,
				input			iINFO10,
				input			iINFO11,
				input			iINFO12,
				input			iINFO13,
				input			iINFO14,
				input			iINFO15,
				output	[3:0]	oCOUNT);
	
	assign	oCOUNT		=		func_rb_free_count16(
									iINFO0, iINFO1, iINFO2, iINFO3,
									iINFO4, iINFO5, iINFO6, iINFO7,
									iINFO8, iINFO9, iINFO10, iINFO11,
									iINFO12, iINFO13, iINFO14, iINFO15
								);

	function [3:0] func_rb_free_count16;
		input			func_rb0;
		input			func_rb1;
		input			func_rb2;
		input			func_rb3;
		input			func_rb4;
		input			func_rb5;
		input			func_rb6;
		input			func_rb7;
		input			func_rb8;
		input			func_rb9;
		input			func_rb10;
		input			func_rb11;
		input			func_rb12;
		input			func_rb13;
		input			func_rb14;
		input			func_rb15;
		reg		[3:0]	func_rb_tmp_count;
		begin
			func_rb_tmp_count	=	4'h0;
			if(func_rb0)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb1)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb2)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb3)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb4)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb5)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end	
			if(func_rb6)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb7)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb8)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb9)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb10)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb11)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb12)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb13)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb14)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			if(func_rb15)begin
				func_rb_tmp_count	=	func_rb_tmp_count + 4'h1;
			end
			func_rb_free_count16	=	func_rb_tmp_count;
		end
	endfunction
	
endmodule




`default_nettype wire


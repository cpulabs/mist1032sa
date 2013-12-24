
`default_nettype none


module reservation_free_entry_count(
		input wire iINFO0,
		input wire iINFO1,
		input wire iINFO2,
		input wire iINFO3,
		input wire iINFO4,
		input wire iINFO5,
		input wire iINFO6,
		input wire iINFO7,
		input wire iINFO8,
		input wire iINFO9,
		input wire iINFO10,
		input wire iINFO11,
		input wire iINFO12,
		input wire iINFO13,
		input wire iINFO14,
		input wire iINFO15,
		output wire [3:0] oCOUNT
	);
	
	assign oCOUNT = func_rb_free_count16(
									iINFO0, iINFO1, iINFO2, iINFO3,
									iINFO4, iINFO5, iINFO6, iINFO7,
									iINFO8, iINFO9, iINFO10, iINFO11,
									iINFO12, iINFO13, iINFO14, iINFO15
								);

	function [3:0] func_rb_free_count16;
		input func_rb0;
		input func_rb1;
		input func_rb2;
		input func_rb3;
		input func_rb4;
		input func_rb5;
		input func_rb6;
		input func_rb7;
		input func_rb8;
		input func_rb9;
		input func_rb10;
		input func_rb11;
		input func_rb12;
		input func_rb13;
		input func_rb14;
		input func_rb15;
		reg [3:0] func_rb_tmp_count;
		begin
			func_rb_tmp_count = 4'h0;
			if(func_rb0)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb1)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb2)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb3)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb4)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb5)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end	
			if(func_rb6)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb7)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb8)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb9)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb10)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb11)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb12)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb13)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb14)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			if(func_rb15)begin
				func_rb_tmp_count = func_rb_tmp_count + 4'h1;
			end
			func_rb_free_count16 = func_rb_tmp_count;
		end
	endfunction
	
endmodule

`default_nettype wire


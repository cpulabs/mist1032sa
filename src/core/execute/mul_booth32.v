/****************************************
	Mul Unit
	- Booth Algorithm
	- 32bit Adder
	
	
	Make	:	2010/12/07
	Update	:		
****************************************/
`default_nettype none



module mul_booth32(
				//iDATA
				input	[31:0]			iDATA_0,
				input	[31:0]			iDATA_1,
				//oDATA
				output	[63:0]			oDATA,
				output					oHSF,
				output					oHOF,				
				output					oHCF,
				output					oHPF,
				output					oHZF,
				output					oLSF,
				output					oLOF,				
				output					oLCF,
				output					oLPF,
				output					oLZF);
				

	/****************************************
	wire
	****************************************/
	wire	[63:0]		w_tmp_out;
	wire	[63:0]		w0_tmp;
	wire	[63:0]		w1_tmp;
	wire	[63:0]		w2_tmp;
	wire	[63:0]		w3_tmp;
	wire	[63:0]		w4_tmp;
	wire	[63:0]		w5_tmp;
	wire	[63:0]		w6_tmp;
	wire	[63:0]		w7_tmp;
	wire	[63:0]		w8_tmp;
	wire	[63:0]		w9_tmp;
	wire	[63:0]		w10_tmp;
	wire	[63:0]		w11_tmp;
	wire	[63:0]		w12_tmp;
	wire	[63:0]		w13_tmp;
	wire	[63:0]		w14_tmp;
	wire	[63:0]		w15_tmp;
	wire	[63:0]		w16_tmp;


	/****************************************
	Booth - Encoder
	****************************************/
	assign		w0_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[1], iDATA_1[0], 1'b0);
	assign		w1_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[3], iDATA_1[2], iDATA_1[1]);
	assign		w2_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[5], iDATA_1[4], iDATA_1[3]);
	assign		w3_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[7], iDATA_1[6], iDATA_1[5]);
	assign		w4_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[9], iDATA_1[8], iDATA_1[7]);
	assign		w5_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[11], iDATA_1[10], iDATA_1[9]);
	assign		w6_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[13], iDATA_1[12], iDATA_1[11]);
	assign		w7_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[15], iDATA_1[14], iDATA_1[13]);
	assign		w8_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[17], iDATA_1[16], iDATA_1[15]);
	assign		w9_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[19], iDATA_1[18], iDATA_1[17]);
	assign		w10_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[21], iDATA_1[20], iDATA_1[19]);
	assign		w11_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[23], iDATA_1[22], iDATA_1[21]);
	assign		w12_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[25], iDATA_1[24], iDATA_1[23]);
	assign		w13_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[27], iDATA_1[26], iDATA_1[25]);
	assign		w14_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[29], iDATA_1[28], iDATA_1[27]);
	assign		w15_tmp		=		func_booth_algorithm(iDATA_0, iDATA_1[31], iDATA_1[30], iDATA_1[29]);
	assign		w16_tmp		=		func_booth_algorithm(iDATA_0, 1'b0, 1'b0, iDATA_1[31]);


	/****************************************
	Booth - Exeout
	****************************************/
	assign	w_tmp_out		=		w0_tmp + w1_tmp<<2 + w2_tmp<<4 + w3_tmp<<6 + w4_tmp<<8 + w5_tmp<<10 + w6_tmp<<12 + w7_tmp<<14 + w8_tmp<<16 + w9_tmp<<18 + w10_tmp<<20 + w11_tmp<<22 + w12_tmp<<24 + w13_tmp<<26 + w14_tmp<<28 + w15_tmp<<30 + w16_tmp<<32;

				
	function [63:0] func_booth_algorithm;
		input	[31:0]	func_booth_algorithm_a;
		input			func_booth_algorithm_b2;
		input			func_booth_algorithm_b1;
		input			func_booth_algorithm_b0;
		reg		[2:0]	reg_func_booth_algorithm_tmp;
		reg		[2:0]	reg_func_booth_algorithm_cmd;
		begin
			reg_func_booth_algorithm_tmp		=		{func_booth_algorithm_b2, func_booth_algorithm_b1, func_booth_algorithm_b0};
			case(reg_func_booth_algorithm_tmp)
				3'h0 : reg_func_booth_algorithm_cmd		=		3'h0;
				3'h1 : reg_func_booth_algorithm_cmd		=		3'h1;
				3'h2 : reg_func_booth_algorithm_cmd		=		3'h1;
				3'h3 : reg_func_booth_algorithm_cmd		=		3'h2;
				3'h4 : reg_func_booth_algorithm_cmd		=		{1'b1, 2'h2};
				3'h5 : reg_func_booth_algorithm_cmd		=		{1'b1, 2'h1};
				3'h6 : reg_func_booth_algorithm_cmd		=		{1'b1, 2'h1};
				default : reg_func_booth_algorithm_cmd		=		3'h0;
			endcase
			
			if(reg_func_booth_algorithm_cmd[2] == 0)begin
				//Plus
				if(reg_func_booth_algorithm_cmd[1:0] == 2'h0)begin
					func_booth_algorithm		=		{32{1'b0}};
				end
				else if(reg_func_booth_algorithm_cmd[1:0] == 2'h1)begin
					func_booth_algorithm		=		{{32{1'b0}}, func_booth_algorithm_a};
				end
				else begin
					func_booth_algorithm		=		{{32{1'b0}}, func_booth_algorithm_a} << 1;
				end
			end
			else begin
				if(reg_func_booth_algorithm_cmd[1:0] == 2'h0)begin
					func_booth_algorithm		=		{32{1'b0}};
				end
				else if(reg_func_booth_algorithm_cmd[1:0] == 2'h1)begin
					func_booth_algorithm		=		-{{32{1'b0}}, func_booth_algorithm_a};//(~{{32{1'b0}}, func_booth_algorithm_a}) + {{63{1'b0}}, 1'b1};
				end
				else begin
					func_booth_algorithm		=		-({{32{1'b0}}, func_booth_algorithm_a} << 1);//(~({{32{1'b0}}, func_booth_algorithm_a} << 1)) + {{63{1'b0}}, 1'b1};
				end
			end
		end
	endfunction	
	
	/****************************************
	Assign
	****************************************/
	assign	oDATA		=		w_tmp_out;
	assign	oHSF		=		w_tmp_out[31];
	assign	oHOF		=		w_tmp_out[32] ^ w_tmp_out[31];
	assign	oHCF		=		w_tmp_out[32];
	assign	oHPF		=		w_tmp_out[0];
	assign	oHZF		=		(w_tmp_out[32:0] == {33{1'b0}})? 1'b1 : 1'b0;
	assign	oLSF		=		w_tmp_out[32];
	assign	oLOF		=		w_tmp_out[63];
	assign	oLCF		=		1'b0;
	assign	oLPF		=		w_tmp_out[32];
	assign	oLZF		=		(w_tmp_out == {64{1'b0}})? 1'b1 : 1'b0;
	
	
	
endmodule


`default_nettype wire



`default_nettype none

//Parallel Adder - non pipeline
module mul4(
				input	[3 : 0]			iSOURCE0,
				input	[3 : 0]			iSOURCE1,
				output	[7 : 0]			oOUTPUT);
				
	assign	oOUTPUT	=	((iSOURCE0[0])? iSOURCE1 : 7'h00) + ((iSOURCE0[1])? iSOURCE1 << 1 : 7'h00) + ((iSOURCE0[2])? iSOURCE1 << 2 : 7'h00) + ((iSOURCE0[3])? iSOURCE1 << 3 : 7'h00);
endmodule

//Parallel Adder - non pipeline
module mul32(
				input	[31 : 0]		iSOURCE0,
				input	[31 : 0]		iSOURCE1,
				output	[63 : 0]		oDATA,
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
				
	wire	[63:0]		w_tmp_out;
	assign	w_tmp_out	=		((iSOURCE0[0])? iSOURCE1 : 64'h00) + ((iSOURCE0[1])? iSOURCE1 << 1 : 64'h00) + ((iSOURCE0[2])? iSOURCE1 << 2 : 64'h00) + ((iSOURCE0[3])? iSOURCE1 << 3 : 64'h00)
								+((iSOURCE0[4])? iSOURCE1 << 4  : 64'h00) + ((iSOURCE0[5])? iSOURCE1 << 5 : 64'h00) + ((iSOURCE0[6])? iSOURCE1 << 6 : 64'h00) + ((iSOURCE0[7])? iSOURCE1 << 7 : 64'h00)
								+((iSOURCE0[8])? iSOURCE1 << 8  : 64'h00) + ((iSOURCE0[9])? iSOURCE1 << 9 : 64'h00) + ((iSOURCE0[10])? iSOURCE1 << 10 : 64'h00) + ((iSOURCE0[11])? iSOURCE1 << 11 : 64'h00)
								+((iSOURCE0[12])? iSOURCE1 << 12  : 64'h00) + ((iSOURCE0[13])? iSOURCE1 << 13 : 64'h00) + ((iSOURCE0[14])? iSOURCE1 << 14 : 64'h00) + ((iSOURCE0[15])? iSOURCE1 << 15 : 64'h00)
								+((iSOURCE0[16])? iSOURCE1 << 16  : 64'h00) + ((iSOURCE0[17])? iSOURCE1 << 17 : 64'h00) + ((iSOURCE0[18])? iSOURCE1 << 18 : 64'h00) + ((iSOURCE0[19])? iSOURCE1 << 19 : 64'h00)					
								+((iSOURCE0[20])? iSOURCE1 << 20  : 64'h00) + ((iSOURCE0[21])? iSOURCE1 << 21 : 64'h00) + ((iSOURCE0[22])? iSOURCE1 << 22 : 64'h00) + ((iSOURCE0[23])? iSOURCE1 << 23 : 64'h00)
								+((iSOURCE0[24])? iSOURCE1 << 24  : 64'h00) + ((iSOURCE0[25])? iSOURCE1 << 25 : 64'h00) + ((iSOURCE0[26])? iSOURCE1 << 26 : 64'h00) + ((iSOURCE0[27])? iSOURCE1 << 27 : 64'h00)
								+((iSOURCE0[28])? iSOURCE1 << 28  : 64'h00) + ((iSOURCE0[29])? iSOURCE1 << 29 : 64'h00) + ((iSOURCE0[30])? iSOURCE1 << 30 : 64'h00) + ((iSOURCE0[31])? iSOURCE1 << 31 : 64'h00);

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



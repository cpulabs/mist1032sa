/****************************************
	Logic
	- Logic Calcration Circuit
	
	
	Make	:	2011/01/20
	Update	:	2011/01/26
****************************************/
`default_nettype none

module	logic_n
	#(
		parameter	N	=	32
	)
	(
		//Control
		input	[4:0]			iCONTROL_CMD,
		//iDATA
		input	[N-1:0]			iDATA_0,
		input	[N-1:0]			iDATA_1,
		//oDATA
		output	[N-1:0]			oDATA,
		output					oSF,
		output					oOF,				
		output					oCF,
		output					oPF,
		output					oZF
	);

				

	
	wire	[31:0]		tmp;
	assign	tmp		=	f_logic(iCONTROL_CMD, iDATA_0, iDATA_1);
	
	
	function [N-1 : 0] f_logic;
		input	[4 : 0]		f_cmd;
		input	[N-1 : 0]	f_data0;
		input	[N-1 : 0]	f_data1;
		begin
			case(f_cmd)
				5'h0 : f_logic		=		f_data0;														//Buffer
				5'h1 : f_logic		=		f_data1;														//Buffer
				5'h2 : f_logic		=		~f_data0;														//Inverter
				5'h3 : f_logic		=		~f_data1;														//Inverter
				5'h4 : f_logic		=		f_data0 & f_data1;												//AND
				5'h5 : f_logic		=		f_data0 | f_data1;												//OR
				5'h6 : f_logic		=		f_data0 ^ f_data1;												//XOR
				5'h7 : f_logic		=		~(f_data0 & f_data1);											//NAND
				5'h8 : f_logic		=		~(f_data0 | f_data1);											//NOA	
				5'h9 : f_logic		=		~(f_data0 ^ f_data1);											//XNOR	
				5'hA : f_logic		=		f_data0 | (1'b1 << f_data1);									//Set Bit	
				5'hB : f_logic		=		f_data0 & (32'hFFFFFFFF ^ (1'b1 << f_data1));					//Clear Bit				
				5'hC : f_logic		=		{f_data0[0], f_data0[1], f_data0[2], f_data0[3],				//Bit Reverse
											f_data0[4], f_data0[5], f_data0[6], f_data0[7],
											f_data0[8], f_data0[9], f_data0[10], f_data0[11],
											f_data0[12], f_data0[13], f_data0[14], f_data0[15],
											f_data0[16], f_data0[17], f_data0[18], f_data0[19],
											f_data0[20], f_data0[21], f_data0[22], f_data0[23],
											f_data0[24], f_data0[25], f_data0[26], f_data0[27],
											f_data0[28], f_data0[28], f_data0[30], f_data0[31]};
				5'hD : f_logic		=		{f_data0[7:0], f_data0[15:8], f_data0[23:16], f_data0[31:24]};	//Byte Reverse
				5'hE : f_logic		=		{{31{1'b0}}, f_data0[f_data1[4:0]]};								//Get Bit
				5'hF : f_logic		=		{{28{1'b0}}, 
											f_data0[f_data1+3], f_data0[f_data1+2], f_data0[f_data1+1], f_data0[f_data1]};	//Get Byte
				5'h10 : f_logic		=		{f_data0[31:16], f_data1[15:0]};								//Set L 2Byte
				5'h11 : f_logic		=		{f_data1[15:0], f_data0[15:0]};									//Set H 2Byte
				5'h12 : f_logic		=		{{16{f_data1[15]}}, f_data1[15:0]};								//LIL
				5'h14 : f_logic		=		{16'h0, f_data1[15:0]};											//ULIL
				default :
					begin
						f_logic		=		f_data0;
						/*
						f_logic	=		{N{1'b0}};
						$display("[Logic Calcration Error] file : logic.v : Not CMD[CMD:%x]", f_cmd);
						*/
					end
			endcase
		end
	endfunction
	
	
	//Output assign
		assign	oDATA	=	tmp;
	assign	oSF		=	tmp[31];
	assign	oOF		=	1'b0;
	assign	oCF		=	1'b0;
	assign	oPF		=	tmp[0];
	assign	oZF		=	(tmp == {N{1'b0}})? 1'b1 : 1'b0;
	

endmodule

`default_nettype wire


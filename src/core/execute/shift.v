/****************************************
	Logic
	- Logic Calcration Circuit
	
	
	Make	:	2010/@@/@@
	Update	:	
****************************************/


`default_nettype none

module shift_n
	#(
		parameter	N	=	32
	)
	(
		//Control
		input	[2:0]			iCONTROL_MODE,			
		//iDATA
		input	[N-1:0]			iDATA_0,
		input	[N-1:0]			iDATA_1,
		//oDATA
		//output					oVALID,		//NEW
		output	[N-1:0]			oDATA,
		output					oSF,
		output					oOF,				
		output					oCF,
		output					oPF,
		output					oZF
	);
			

	genvar i;
	
	
	wire	[31:0]		l_shift_input;
	assign				l_shift_input			=	iDATA_0;
	wire	[31:0]		l_shift_out[0:63];
	generate
		for(i = 0; i < 64; i = i + 1)begin : L_SHIFTER
			if(i < 32)begin
				assign		l_shift_out	[i[5:0]]	=		l_shift_input	<<	i[5:0];
			end
			else begin
				assign		l_shift_out	[i[5:0]]	=		32'h0;
			end
		end
	endgenerate
	
	
	
	wire	[31:0]		r_shift_input;
	assign				r_shift_input			=	iDATA_0;
	wire	[31:0]		r_shift_out[0:63];
	generate
		for(i = 0; i < 64; i = i + 1)begin : R_SHIFTER
			if(i < 32)begin
				assign		r_shift_out	[i[5:0]]	=		r_shift_input	>>	i[5:0];
			end
			else begin
				assign		r_shift_out	[i[5:0]]	=		32'h0;
			end
		end
	endgenerate
	
	
	wire	[31:0]		r_al_shift_input;
	assign				r_al_shift_input			=	iDATA_0;
	wire	[31:0]		r_al_shift_out[0:63];
	generate
		for(i = 0; i < 64; i = i + 1)begin : R_AL_SHIFTER
			if(i == 0)begin
				assign		r_al_shift_out	[i[5:0]]	=	r_al_shift_input;
			end
			else if(i < 32)begin
				assign		r_al_shift_out	[i[5:0]]	=	{{i{r_al_shift_input[31]}}, r_al_shift_input[31:i]};
			end
			else begin
				assign		r_al_shift_out	[i[5:0]]	=	{32{r_al_shift_input[31]}};
			end
		end
	endgenerate
	
	/*
	function [31:0] func_rol;
		input	[31:0]	func_rol_data;
		input	[5:0]	func_rol_shift;
		begin
			case(func_rol_shift)
				6'd0, 6'd32 :	func_rol	=	func_rol_data;
				6'd1, 6'd2 :	func_rol	=	{func_rol_data[30:0], func_rol_data[31:31]};
				6'd2, 6'd4 :	func_rol	=	{func_rol_data[29:0], func_rol_data[31:30]};
				6'd3, 6'd6 :	func_rol	=	{func_rol_data[28:0], func_rol_data[31:29]};
				6'd4, 6'd8 :	func_rol	=	{func_rol_data[27:0], func_rol_data[31:28]};
				6'd5, 6'd10 :	func_rol	=	{func_rol_data[26:0], func_rol_data[31:27]};
				6'd6, 6'd12 :	func_rol	=	{func_rol_data[25:0], func_rol_data[31:26]};
				6'd7, 6'd14 :	func_rol	=	{func_rol_data[24:0], func_rol_data[31:25]};
				6'd8, 6'd16 :	func_rol	=	{func_rol_data[23:0], func_rol_data[31:24]};
				6'd9, 6'd18 :	func_rol	=	{func_rol_data[22:0], func_rol_data[31:23]};
				6'd10, 6'd20 :	func_rol	=	{func_rol_data[21:0], func_rol_data[31:22]};
				6'd11, 6'd22 :	func_rol	=	{func_rol_data[20:0], func_rol_data[31:21]};
				6'd12, 6'd24 :	func_rol	=	{func_rol_data[19:0], func_rol_data[31:20]};
				6'd13, 6'd26 :	func_rol	=	{func_rol_data[18:0], func_rol_data[31:19]};
				6'd14, 6'd28 :	func_rol	=	{func_rol_data[17:0], func_rol_data[31:18]};
				6'd15, 6'd30 :	func_rol	=	{func_rol_data[16:0], func_rol_data[31:17]};
				6'd16, 6'd32 :	func_rol	=	{func_rol_data[15:0], func_rol_data[31:16]};
				6'd17, 6'd34 :	func_rol	=	{func_rol_data[14:0], func_rol_data[31:15]};
				6'd18, 6'd36 :	func_rol	=	{func_rol_data[13:0], func_rol_data[31:14]};
				6'd19, 6'd38 :	func_rol	=	{func_rol_data[12:0], func_rol_data[31:13]};
				6'd20, 6'd40 :	func_rol	=	{func_rol_data[11:0], func_rol_data[31:12]};
				6'd21, 6'd42 :	func_rol	=	{func_rol_data[10:0], func_rol_data[31:11]};
				6'd22, 6'd44 :	func_rol	=	{func_rol_data[9:0], func_rol_data[31:10]};
				6'd23, 6'd46 :	func_rol	=	{func_rol_data[8:0], func_rol_data[31:9]};
				6'd24, 6'd48 :	func_rol	=	{func_rol_data[7:0], func_rol_data[31:8]};
				6'd25, 6'd50 :	func_rol	=	{func_rol_data[6:0], func_rol_data[31:7]};
				6'd26, 6'd52 :	func_rol	=	{func_rol_data[5:0], func_rol_data[31:6]};
				6'd27, 6'd54 :	func_rol	=	{func_rol_data[4:0], func_rol_data[31:5]};
				6'd28, 6'd56 :	func_rol	=	{func_rol_data[3:0], func_rol_data[31:4]};
				6'd29, 6'd58 :	func_rol	=	{func_rol_data[2:0], func_rol_data[31:3]};
				6'd30, 6'd60 :	func_rol	=	{func_rol_data[1:0], func_rol_data[31:2]};
				6'd31, 6'd62 :	func_rol	=	{func_rol_data[0:0], func_rol_data[31:1]};
			endcase
		end
	endfunction
	*/
	
	/*
	function [31:0] func_ror;
		input	[31:0]	func_ror_data;
		input	[5:0]	func_ror_shift;
		begin
			case(func_ror_shift)
				6'd0, 6'd32 :	func_ror	=	func_ror_data;
				6'd1, 6'd2 :	func_ror	=	{func_ror_data[0:0], func_ror_data[31:1]};
				6'd2, 6'd4 :	func_ror	=	{func_ror_data[1:0], func_ror_data[31:2]};
				6'd3, 6'd6 :	func_ror	=	{func_ror_data[2:0], func_ror_data[31:3]};
				6'd4, 6'd8 :	func_ror	=	{func_ror_data[3:0], func_ror_data[31:4]};
				6'd5, 6'd10 :	func_ror	=	{func_ror_data[4:0], func_ror_data[31:5]};
				6'd6, 6'd12 :	func_ror	=	{func_ror_data[5:0], func_ror_data[31:6]};
				6'd7, 6'd14 :	func_ror	=	{func_ror_data[6:0], func_ror_data[31:7]};
				6'd8, 6'd16 :	func_ror	=	{func_ror_data[7:0], func_ror_data[31:8]};
				6'd9, 6'd18 :	func_ror	=	{func_ror_data[8:0], func_ror_data[31:9]};
				6'd10, 6'd20 :	func_ror	=	{func_ror_data[9:0], func_ror_data[31:10]};
				6'd11, 6'd22 :	func_ror	=	{func_ror_data[10:0], func_ror_data[31:11]};
				6'd12, 6'd24 :	func_ror	=	{func_ror_data[11:0], func_ror_data[31:12]};
				6'd13, 6'd26 :	func_ror	=	{func_ror_data[12:0], func_ror_data[31:13]};
				6'd14, 6'd28 :	func_ror	=	{func_ror_data[13:0], func_ror_data[31:14]};
				6'd15, 6'd30 :	func_ror	=	{func_ror_data[14:0], func_ror_data[31:15]};
				6'd16, 6'd32 :	func_ror	=	{func_ror_data[15:0], func_ror_data[31:16]};
				6'd17, 6'd34 :	func_ror	=	{func_ror_data[16:0], func_ror_data[31:17]};
				6'd18, 6'd36 :	func_ror	=	{func_ror_data[17:0], func_ror_data[31:18]};
				6'd19, 6'd38 :	func_ror	=	{func_ror_data[18:0], func_ror_data[31:19]};
				6'd20, 6'd40 :	func_ror	=	{func_ror_data[19:0], func_ror_data[31:20]};
				6'd21, 6'd42 :	func_ror	=	{func_ror_data[20:0], func_ror_data[31:21]};
				6'd22, 6'd44 :	func_ror	=	{func_ror_data[21:0], func_ror_data[31:22]};
				6'd23, 6'd46 :	func_ror	=	{func_ror_data[22:0], func_ror_data[31:23]};
				6'd24, 6'd48 :	func_ror	=	{func_ror_data[23:0], func_ror_data[31:24]};
				6'd25, 6'd50 :	func_ror	=	{func_ror_data[24:0], func_ror_data[31:25]};
				6'd26, 6'd52 :	func_ror	=	{func_ror_data[25:0], func_ror_data[31:26]};
				6'd27, 6'd54 :	func_ror	=	{func_ror_data[26:0], func_ror_data[31:27]};
				6'd28, 6'd56 :	func_ror	=	{func_ror_data[27:0], func_ror_data[31:28]};
				6'd29, 6'd58 :	func_ror	=	{func_ror_data[28:0], func_ror_data[31:29]};
				6'd30, 6'd60 :	func_ror	=	{func_ror_data[29:0], func_ror_data[31:30]};
				6'd31, 6'd62 :	func_ror	=	{func_ror_data[30:0], func_ror_data[31:31]};
			endcase
		end
	endfunction*/
	
	
	
	
	function [31:0] func_rol;
		input	[31:0]	func_rol_data;
		input	[5:0]	func_rol_shift;
		begin
			case(func_rol_shift)
				5'd0	:	func_rol	=	func_rol_data;
				5'd1	:	func_rol	=	{func_rol_data[30:0], func_rol_data[31:31]};
				5'd2	:	func_rol	=	{func_rol_data[29:0], func_rol_data[31:30]};
				5'd3	:	func_rol	=	{func_rol_data[28:0], func_rol_data[31:29]};
				5'd4	:	func_rol	=	{func_rol_data[27:0], func_rol_data[31:28]};
				5'd5	:	func_rol	=	{func_rol_data[26:0], func_rol_data[31:27]};
				5'd6	:	func_rol	=	{func_rol_data[25:0], func_rol_data[31:26]};
				5'd7	:	func_rol	=	{func_rol_data[24:0], func_rol_data[31:25]};
				5'd8	:	func_rol	=	{func_rol_data[23:0], func_rol_data[31:24]};
				5'd9	:	func_rol	=	{func_rol_data[22:0], func_rol_data[31:23]};
				5'd10	:	func_rol	=	{func_rol_data[21:0], func_rol_data[31:22]};
				5'd11	:	func_rol	=	{func_rol_data[20:0], func_rol_data[31:21]};
				5'd12	:	func_rol	=	{func_rol_data[19:0], func_rol_data[31:20]};
				5'd13	:	func_rol	=	{func_rol_data[18:0], func_rol_data[31:19]};
				5'd14	:	func_rol	=	{func_rol_data[17:0], func_rol_data[31:18]};
				5'd15	:	func_rol	=	{func_rol_data[16:0], func_rol_data[31:17]};
				5'd16	:	func_rol	=	{func_rol_data[15:0], func_rol_data[31:16]};
				5'd17	:	func_rol	=	{func_rol_data[14:0], func_rol_data[31:15]};
				5'd18	:	func_rol	=	{func_rol_data[13:0], func_rol_data[31:14]};
				5'd19	:	func_rol	=	{func_rol_data[12:0], func_rol_data[31:13]};
				5'd20	:	func_rol	=	{func_rol_data[11:0], func_rol_data[31:12]};
				5'd21	:	func_rol	=	{func_rol_data[10:0], func_rol_data[31:11]};
				5'd22	:	func_rol	=	{func_rol_data[9:0], func_rol_data[31:10]};
				5'd23	:	func_rol	=	{func_rol_data[8:0], func_rol_data[31:9]};
				5'd24	:	func_rol	=	{func_rol_data[7:0], func_rol_data[31:8]};
				5'd25	:	func_rol	=	{func_rol_data[6:0], func_rol_data[31:7]};
				5'd26	:	func_rol	=	{func_rol_data[5:0], func_rol_data[31:6]};
				5'd27	:	func_rol	=	{func_rol_data[4:0], func_rol_data[31:5]};
				5'd28	:	func_rol	=	{func_rol_data[3:0], func_rol_data[31:4]};
				5'd29	:	func_rol	=	{func_rol_data[2:0], func_rol_data[31:3]};
				5'd30	:	func_rol	=	{func_rol_data[1:0], func_rol_data[31:2]};
				5'd31	:	func_rol	=	{func_rol_data[0:0], func_rol_data[31:1]};

			endcase
		end
	endfunction
	
	
	
	function [31:0] func_ror;
		input	[31:0]	func_ror_data;
		input	[5:0]	func_ror_shift;
		begin
			case(func_ror_shift)
				5'd0	:	func_ror	=	func_ror_data;
				5'd1	:	func_ror	=	{func_ror_data[0:0], func_ror_data[31:1]};
				5'd2	:	func_ror	=	{func_ror_data[1:0], func_ror_data[31:2]};
				5'd3	:	func_ror	=	{func_ror_data[2:0], func_ror_data[31:3]};
				5'd4	:	func_ror	=	{func_ror_data[3:0], func_ror_data[31:4]};
				5'd5	:	func_ror	=	{func_ror_data[4:0], func_ror_data[31:5]};
				5'd6	:	func_ror	=	{func_ror_data[5:0], func_ror_data[31:6]};
				5'd7	:	func_ror	=	{func_ror_data[6:0], func_ror_data[31:7]};
				5'd8	:	func_ror	=	{func_ror_data[7:0], func_ror_data[31:8]};
				5'd9	:	func_ror	=	{func_ror_data[8:0], func_ror_data[31:9]};
				5'd10	:	func_ror	=	{func_ror_data[9:0], func_ror_data[31:10]};
				5'd11	:	func_ror	=	{func_ror_data[10:0], func_ror_data[31:11]};
				5'd12	:	func_ror	=	{func_ror_data[11:0], func_ror_data[31:12]};
				5'd13	:	func_ror	=	{func_ror_data[12:0], func_ror_data[31:13]};
				5'd14	:	func_ror	=	{func_ror_data[13:0], func_ror_data[31:14]};
				5'd15	:	func_ror	=	{func_ror_data[14:0], func_ror_data[31:15]};
				5'd16	:	func_ror	=	{func_ror_data[15:0], func_ror_data[31:16]};
				5'd17	:	func_ror	=	{func_ror_data[16:0], func_ror_data[31:17]};
				5'd18	:	func_ror	=	{func_ror_data[17:0], func_ror_data[31:18]};
				5'd19	:	func_ror	=	{func_ror_data[18:0], func_ror_data[31:19]};
				5'd20	:	func_ror	=	{func_ror_data[19:0], func_ror_data[31:20]};
				5'd21	:	func_ror	=	{func_ror_data[20:0], func_ror_data[31:21]};
				5'd22	:	func_ror	=	{func_ror_data[21:0], func_ror_data[31:22]};
				5'd23	:	func_ror	=	{func_ror_data[22:0], func_ror_data[31:23]};
				5'd24	:	func_ror	=	{func_ror_data[23:0], func_ror_data[31:24]};
				5'd25	:	func_ror	=	{func_ror_data[24:0], func_ror_data[31:25]};
				5'd26	:	func_ror	=	{func_ror_data[25:0], func_ror_data[31:26]};
				5'd27	:	func_ror	=	{func_ror_data[26:0], func_ror_data[31:27]};
				5'd28	:	func_ror	=	{func_ror_data[27:0], func_ror_data[31:28]};
				5'd29	:	func_ror	=	{func_ror_data[28:0], func_ror_data[31:29]};
				5'd30	:	func_ror	=	{func_ror_data[29:0], func_ror_data[31:30]};
				5'd31	:	func_ror	=	{func_ror_data[30:0], func_ror_data[31:31]};
			endcase
		end
	endfunction
	
	
	//Output Selector
	reg		[31:0]		data_out;
	reg					flag_cf;
	always @* begin
		case(iCONTROL_MODE)
			3'h0 :			//Buffer
				begin
					data_out		=		iDATA_0;
					flag_cf			=		1'b0;
				end
			3'h1 :			//Logic Left
				begin
					data_out		=		l_shift_out[iDATA_1[5:0]];
					if(iDATA_1[5:0] > 32 || iDATA_1[5:0] == 6'h0)begin
						flag_cf			=		1'b0;
					end
					else begin
						flag_cf			=		iDATA_0[31-(iDATA_1[5:0]-1)];
					end
				end
			3'h2 :			//Logic Right
				begin
					data_out		=		r_shift_out[iDATA_1[5:0]];
					if(iDATA_1[5:0] > 32 || iDATA_1[5:0] == 6'h0)begin
						flag_cf			=		1'b0;
					end
					else begin
						flag_cf			=		iDATA_0[iDATA_1[5:0]-1];
					end
				end	
			3'h3 :			//Arithmetic Right
				begin
					data_out		=		r_al_shift_out[iDATA_1[5:0]];
					if(iDATA_1[5:0] == 6'h0)begin
						flag_cf			=		1'b0;
					end
					else if(iDATA_1[5:0] > 32)begin
						flag_cf			=		iDATA_0[31];
					end
					else begin
						flag_cf			=		iDATA_0[iDATA_1[5:0]-1];
					end
				end
			3'h4 :			//Rotate Left
				begin
					data_out		=		func_rol(iDATA_0, iDATA_1[4:0]);
					if(iDATA_1[5:0] > 32 || iDATA_1[5:0] == 6'h0)begin
						flag_cf			=		1'b0;
					end
					else begin
						flag_cf			=		iDATA_0[31-(iDATA_1[5:0]-1)];
					end
				end
			3'h5 :			//Rotate Right
				begin
					data_out		=		func_ror(iDATA_0, iDATA_1[4:0]);
					if(iDATA_1[5:0] > 32 || iDATA_1[5:0] == 6'h0)begin
						flag_cf			=		1'b0;
					end
					else begin
						flag_cf			=		iDATA_0[iDATA_1[5:0]-1];
					end
				end
			default:		//Reserved (Buffer)
				begin
					data_out		=		iDATA_0;
					flag_cf			=		1'b0;
				end
		endcase
	end
	
	
	assign	oDATA		=		data_out;
	assign	oSF			=		data_out[N-1];
	assign	oOF			=		1'b0;
	assign	oCF			=		flag_cf;
	assign	oPF			=		data_out[0];
	assign	oZF			=		(data_out == {32{1'b0}})? 1'b1 : 1'b0;
	
	
endmodule


`default_nettype wire


/****************************************
Shift 
for MIST32 Processor

Takahiro Ito @cpu_labs
****************************************/

`default_nettype none

module execute_shift #(
		parameter P_N	= 32
	)(
		//Control
		input wire [2:0] iCONTROL_MODE,			
		//iDATA
		input wire [P_N-1:0] iDATA_0,
		input wire [P_N-1:0] iDATA_1,
		//oDATA
		output wire [P_N-1:0] oDATA,
		output wire oSF,
		output wire oOF,				
		output wire oCF,
		output wire oPF,
		output wire oZF
	);


	function [31:0] func_sar;
		input [31:0] func_sar_data;
		input [4:0] func_sar_shift;
		begin
			case(func_sar_shift)
				5'd0 : func_sar = func_sar_data;
				5'd1 : func_sar = {{1{func_sar_data[31]}}, func_sar_data[31:1]};
				5'd2 : func_sar = {{2{func_sar_data[31]}}, func_sar_data[31:2]};
				5'd3 : func_sar = {{3{func_sar_data[31]}}, func_sar_data[31:3]};
				5'd4 : func_sar = {{4{func_sar_data[31]}}, func_sar_data[31:4]};
				5'd5 : func_sar = {{5{func_sar_data[31]}}, func_sar_data[31:5]};
				5'd6 : func_sar = {{6{func_sar_data[31]}}, func_sar_data[31:6]};
				5'd7 : func_sar = {{7{func_sar_data[31]}}, func_sar_data[31:7]};
				5'd8 : func_sar = {{8{func_sar_data[31]}}, func_sar_data[31:8]};
				5'd9 : func_sar = {{9{func_sar_data[31]}}, func_sar_data[31:9]};
				5'd10 : func_sar = {{10{func_sar_data[31]}}, func_sar_data[31:10]};
				5'd11 : func_sar = {{11{func_sar_data[31]}}, func_sar_data[31:11]};
				5'd12 : func_sar = {{12{func_sar_data[31]}}, func_sar_data[31:12]};
				5'd13 : func_sar = {{13{func_sar_data[31]}}, func_sar_data[31:13]};
				5'd14 : func_sar = {{14{func_sar_data[31]}}, func_sar_data[31:14]};
				5'd15 : func_sar = {{15{func_sar_data[31]}}, func_sar_data[31:15]};
				5'd16 : func_sar = {{16{func_sar_data[31]}}, func_sar_data[31:16]};
				5'd17 : func_sar = {{17{func_sar_data[31]}}, func_sar_data[31:17]};
				5'd18 : func_sar = {{18{func_sar_data[31]}}, func_sar_data[31:18]};
				5'd19 : func_sar = {{19{func_sar_data[31]}}, func_sar_data[31:19]};
				5'd20 : func_sar = {{20{func_sar_data[31]}}, func_sar_data[31:20]};
				5'd21 : func_sar = {{21{func_sar_data[31]}}, func_sar_data[31:21]};
				5'd22 : func_sar = {{22{func_sar_data[31]}}, func_sar_data[31:22]};
				5'd23 : func_sar = {{23{func_sar_data[31]}}, func_sar_data[31:23]};
				5'd24 : func_sar = {{24{func_sar_data[31]}}, func_sar_data[31:24]};
				5'd25 : func_sar = {{25{func_sar_data[31]}}, func_sar_data[31:25]};
				5'd26 : func_sar = {{26{func_sar_data[31]}}, func_sar_data[31:26]};
				5'd27 : func_sar = {{27{func_sar_data[31]}}, func_sar_data[31:27]};
				5'd28 : func_sar = {{28{func_sar_data[31]}}, func_sar_data[31:28]};
				5'd29 : func_sar = {{29{func_sar_data[31]}}, func_sar_data[31:29]};
				5'd30 : func_sar = {{30{func_sar_data[31]}}, func_sar_data[31:30]};
				5'd31 : func_sar = {{31{func_sar_data[31]}}, func_sar_data[31:31]};
			endcase
		end
	endfunction

	function [31:0] func_shr;
		input [31:0] func_shr_data;
		input [4:0] func_shr_shift;
		begin
			case(func_shr_shift)
				5'd0 : func_shr = func_shr_data;
				5'd1 : func_shr = {{1{1'b0}}, func_shr_data[31:1]};
				5'd2 : func_shr = {{2{1'b0}}, func_shr_data[31:2]};
				5'd3 : func_shr = {{3{1'b0}}, func_shr_data[31:3]};
				5'd4 : func_shr = {{4{1'b0}}, func_shr_data[31:4]};
				5'd5 : func_shr = {{5{1'b0}}, func_shr_data[31:5]};
				5'd6 : func_shr = {{6{1'b0}}, func_shr_data[31:6]};
				5'd7 : func_shr = {{7{1'b0}}, func_shr_data[31:7]};
				5'd8 : func_shr = {{8{1'b0}}, func_shr_data[31:8]};
				5'd9 : func_shr = {{9{1'b0}}, func_shr_data[31:9]};
				5'd10 : func_shr = {{10{1'b0}}, func_shr_data[31:10]};
				5'd11 : func_shr = {{11{1'b0}}, func_shr_data[31:11]};
				5'd12 : func_shr = {{12{1'b0}}, func_shr_data[31:12]};
				5'd13 : func_shr = {{13{1'b0}}, func_shr_data[31:13]};
				5'd14 : func_shr = {{14{1'b0}}, func_shr_data[31:14]};
				5'd15 : func_shr = {{15{1'b0}}, func_shr_data[31:15]};
				5'd16 : func_shr = {{16{1'b0}}, func_shr_data[31:16]};
				5'd17 : func_shr = {{17{1'b0}}, func_shr_data[31:17]};
				5'd18 : func_shr = {{18{1'b0}}, func_shr_data[31:18]};
				5'd19 : func_shr = {{19{1'b0}}, func_shr_data[31:19]};
				5'd20 : func_shr = {{20{1'b0}}, func_shr_data[31:20]};
				5'd21 : func_shr = {{21{1'b0}}, func_shr_data[31:21]};
				5'd22 : func_shr = {{22{1'b0}}, func_shr_data[31:22]};
				5'd23 : func_shr = {{23{1'b0}}, func_shr_data[31:23]};
				5'd24 : func_shr = {{24{1'b0}}, func_shr_data[31:24]};
				5'd25 : func_shr = {{25{1'b0}}, func_shr_data[31:25]};
				5'd26 : func_shr = {{26{1'b0}}, func_shr_data[31:26]};
				5'd27 : func_shr = {{27{1'b0}}, func_shr_data[31:27]};
				5'd28 : func_shr = {{28{1'b0}}, func_shr_data[31:28]};
				5'd29 : func_shr = {{29{1'b0}}, func_shr_data[31:29]};
				5'd30 : func_shr = {{30{1'b0}}, func_shr_data[31:30]};
				5'd31 : func_shr = {{31{1'b0}}, func_shr_data[31:31]};
			endcase
		end
	endfunction
	
	function [31:0] func_shl;
		input [31:0] func_shl_data;
		input [4:0] func_shl_shift;
		begin
			case(func_shl_shift)
				5'd0 : func_shl = func_shl_data;
				5'd1 : func_shl = {func_shl_data[30:0], 1'b0};
				5'd2 : func_shl = {func_shl_data[29:0], {2{1'b0}}};
				5'd3 : func_shl = {func_shl_data[28:0], {3{1'b0}}};
				5'd4 : func_shl = {func_shl_data[27:0], {4{1'b0}}};
				5'd5 : func_shl = {func_shl_data[26:0], {5{1'b0}}};
				5'd6 : func_shl = {func_shl_data[25:0], {6{1'b0}}};
				5'd7 : func_shl = {func_shl_data[24:0], {7{1'b0}}};
				5'd8 : func_shl = {func_shl_data[23:0], {8{1'b0}}};
				5'd9 : func_shl = {func_shl_data[22:0], {9{1'b0}}};
				5'd10 : func_shl = {func_shl_data[21:0], {10{1'b0}}};
				5'd11 : func_shl = {func_shl_data[20:0], {11{1'b0}}};
				5'd12 : func_shl = {func_shl_data[19:0], {12{1'b0}}};
				5'd13 : func_shl = {func_shl_data[18:0], {13{1'b0}}};
				5'd14 : func_shl = {func_shl_data[17:0], {14{1'b0}}};
				5'd15 : func_shl = {func_shl_data[16:0], {15{1'b0}}};
				5'd16 : func_shl = {func_shl_data[15:0], {16{1'b0}}};
				5'd17 : func_shl = {func_shl_data[14:0], {17{1'b0}}};
				5'd18 : func_shl = {func_shl_data[13:0], {18{1'b0}}};
				5'd19 : func_shl = {func_shl_data[12:0], {19{1'b0}}};
				5'd20 : func_shl = {func_shl_data[11:0], {20{1'b0}}};
				5'd21 : func_shl = {func_shl_data[10:0], {21{1'b0}}};
				5'd22 : func_shl = {func_shl_data[9:0], {22{1'b0}}};
				5'd23 : func_shl = {func_shl_data[8:0], {23{1'b0}}};
				5'd24 : func_shl = {func_shl_data[7:0], {24{1'b0}}};
				5'd25 : func_shl = {func_shl_data[6:0], {25{1'b0}}};
				5'd26 : func_shl = {func_shl_data[5:0], {26{1'b0}}};
				5'd27 : func_shl = {func_shl_data[4:0], {27{1'b0}}};
				5'd28 : func_shl = {func_shl_data[3:0], {28{1'b0}}};
				5'd29 : func_shl = {func_shl_data[2:0], {29{1'b0}}};
				5'd30 : func_shl = {func_shl_data[1:0], {30{1'b0}}};
				5'd31 : func_shl = {func_shl_data[0:0], {31{1'b0}}};
			endcase
		end
	endfunction


	
	function [31:0] func_rol;
		input [31:0] func_rol_data;
		input [4:0] func_rol_shift;
		begin
			case(func_rol_shift)
				5'd0 : func_rol = func_rol_data;
				5'd1 : func_rol = {func_rol_data[30:0], func_rol_data[31:31]};
				5'd2 : func_rol = {func_rol_data[29:0], func_rol_data[31:30]};
				5'd3 : func_rol = {func_rol_data[28:0], func_rol_data[31:29]};
				5'd4 : func_rol = {func_rol_data[27:0], func_rol_data[31:28]};
				5'd5 : func_rol = {func_rol_data[26:0], func_rol_data[31:27]};
				5'd6 : func_rol = {func_rol_data[25:0], func_rol_data[31:26]};
				5'd7 : func_rol = {func_rol_data[24:0], func_rol_data[31:25]};
				5'd8 : func_rol = {func_rol_data[23:0], func_rol_data[31:24]};
				5'd9 : func_rol = {func_rol_data[22:0], func_rol_data[31:23]};
				5'd10 : func_rol = {func_rol_data[21:0], func_rol_data[31:22]};
				5'd11 : func_rol = {func_rol_data[20:0], func_rol_data[31:21]};
				5'd12 : func_rol = {func_rol_data[19:0], func_rol_data[31:20]};
				5'd13 : func_rol = {func_rol_data[18:0], func_rol_data[31:19]};
				5'd14 : func_rol = {func_rol_data[17:0], func_rol_data[31:18]};
				5'd15 : func_rol = {func_rol_data[16:0], func_rol_data[31:17]};
				5'd16 : func_rol = {func_rol_data[15:0], func_rol_data[31:16]};
				5'd17 : func_rol = {func_rol_data[14:0], func_rol_data[31:15]};
				5'd18 : func_rol = {func_rol_data[13:0], func_rol_data[31:14]};
				5'd19 : func_rol = {func_rol_data[12:0], func_rol_data[31:13]};
				5'd20 : func_rol = {func_rol_data[11:0], func_rol_data[31:12]};
				5'd21 : func_rol = {func_rol_data[10:0], func_rol_data[31:11]};
				5'd22 : func_rol = {func_rol_data[9:0], func_rol_data[31:10]};
				5'd23 : func_rol = {func_rol_data[8:0], func_rol_data[31:9]};
				5'd24 : func_rol = {func_rol_data[7:0], func_rol_data[31:8]};
				5'd25 : func_rol = {func_rol_data[6:0], func_rol_data[31:7]};
				5'd26 : func_rol = {func_rol_data[5:0], func_rol_data[31:6]};
				5'd27 : func_rol = {func_rol_data[4:0], func_rol_data[31:5]};
				5'd28 : func_rol = {func_rol_data[3:0], func_rol_data[31:4]};
				5'd29 : func_rol = {func_rol_data[2:0], func_rol_data[31:3]};
				5'd30 : func_rol = {func_rol_data[1:0], func_rol_data[31:2]};
				5'd31 : func_rol = {func_rol_data[0:0], func_rol_data[31:1]};
			endcase
		end
	endfunction
	
	
	
	function [31:0] func_ror;
		input [31:0] func_ror_data;
		input [4:0] func_ror_shift;
		begin
			case(func_ror_shift)
				5'd0 : func_ror = func_ror_data;
				5'd1 : func_ror = {func_ror_data[0:0], func_ror_data[31:1]};
				5'd2 : func_ror = {func_ror_data[1:0], func_ror_data[31:2]};
				5'd3 : func_ror = {func_ror_data[2:0], func_ror_data[31:3]};
				5'd4 : func_ror = {func_ror_data[3:0], func_ror_data[31:4]};
				5'd5 : func_ror = {func_ror_data[4:0], func_ror_data[31:5]};
				5'd6 : func_ror = {func_ror_data[5:0], func_ror_data[31:6]};
				5'd7 : func_ror = {func_ror_data[6:0], func_ror_data[31:7]};
				5'd8 : func_ror = {func_ror_data[7:0], func_ror_data[31:8]};
				5'd9 : func_ror = {func_ror_data[8:0], func_ror_data[31:9]};
				5'd10 : func_ror = {func_ror_data[9:0], func_ror_data[31:10]};
				5'd11 : func_ror = {func_ror_data[10:0], func_ror_data[31:11]};
				5'd12 : func_ror = {func_ror_data[11:0], func_ror_data[31:12]};
				5'd13 : func_ror = {func_ror_data[12:0], func_ror_data[31:13]};
				5'd14 : func_ror = {func_ror_data[13:0], func_ror_data[31:14]};
				5'd15 : func_ror = {func_ror_data[14:0], func_ror_data[31:15]};
				5'd16 : func_ror = {func_ror_data[15:0], func_ror_data[31:16]};
				5'd17 : func_ror = {func_ror_data[16:0], func_ror_data[31:17]};
				5'd18 : func_ror = {func_ror_data[17:0], func_ror_data[31:18]};
				5'd19 : func_ror = {func_ror_data[18:0], func_ror_data[31:19]};
				5'd20 : func_ror = {func_ror_data[19:0], func_ror_data[31:20]};
				5'd21 : func_ror = {func_ror_data[20:0], func_ror_data[31:21]};
				5'd22 : func_ror = {func_ror_data[21:0], func_ror_data[31:22]};
				5'd23 : func_ror = {func_ror_data[22:0], func_ror_data[31:23]};
				5'd24 : func_ror = {func_ror_data[23:0], func_ror_data[31:24]};
				5'd25 : func_ror = {func_ror_data[24:0], func_ror_data[31:25]};
				5'd26 : func_ror = {func_ror_data[25:0], func_ror_data[31:26]};
				5'd27 : func_ror = {func_ror_data[26:0], func_ror_data[31:27]};
				5'd28 : func_ror = {func_ror_data[27:0], func_ror_data[31:28]};
				5'd29 : func_ror = {func_ror_data[28:0], func_ror_data[31:29]};
				5'd30 : func_ror = {func_ror_data[29:0], func_ror_data[31:30]};
				5'd31 : func_ror = {func_ror_data[30:0], func_ror_data[31:31]};
			endcase
		end
	endfunction
	
	
	//Output Selector
	reg [31:0] data_out;
	reg flag_cf;

	always @* begin
		case(iCONTROL_MODE)
			3'h0 :			//Buffer
				begin
					data_out = iDATA_0;
				end
			3'h1 :			//Logic Left
				begin
					if(iDATA_1[5:0] < 6'd32)begin
						data_out = func_shl(iDATA_0, iDATA_1[4:0]);
					end
					else begin
						data_out = 32'h0;
					end
				end
			3'h2 :			//Logic Right
				begin
					if(iDATA_1[5:0] < 6'd32)begin
						data_out = func_shr(iDATA_0, iDATA_1[4:0]);
					end
					else begin
						data_out = 32'h0;
					end
				end	
			3'h3 :			//Arithmetic Right
				begin
					if(iDATA_1[5:0] < 6'd32)begin
						data_out = func_sar(iDATA_0, iDATA_1[4:0]);
					end
					else begin
						data_out = {32{iDATA_0[31]}};
					end
				end
			3'h4 :			//Rotate Left
				begin
					data_out = func_rol(iDATA_0, iDATA_1[4:0]);
				end
			3'h5 :			//Rotate Right
				begin
					data_out = func_ror(iDATA_0, iDATA_1[4:0]);
				end
			default:		//Reserved (Buffer)
				begin
					data_out = iDATA_0;
				end
		endcase
	end

	always @* begin
		case(iCONTROL_MODE)
			3'h0 :			//Buffer
				begin
					flag_cf	= 1'b0;
				end
			3'h1 :			//Logic Left
				begin
					if(iDATA_1[5:0] > 32 || iDATA_1[5:0] == 6'h0)begin
						flag_cf = 1'b0;
					end
					else begin
						flag_cf = iDATA_0[31-(iDATA_1[5:0]-1)];
					end
				end
			3'h2 :			//Logic Right
				begin
					if(iDATA_1[5:0] > 32 || iDATA_1[5:0] == 6'h0)begin
						flag_cf = 1'b0;
					end
					else begin
						flag_cf = iDATA_0[iDATA_1[5:0]-1];
					end
				end	
			3'h3 :			//Arithmetic Right
				begin
					if(iDATA_1[5:0] == 6'h0)begin
						flag_cf = 1'b0;
					end
					else if(iDATA_1[5:0] > 32)begin
						flag_cf = iDATA_0[31];
					end
					else begin
						flag_cf = iDATA_0[iDATA_1[5:0]-1];
					end
				end
			3'h4 :			//Rotate Left
				begin
					if(iDATA_1[5:0] > 32 || iDATA_1[5:0] == 6'h0)begin
						flag_cf = 1'b0;
					end
					else begin
						flag_cf = iDATA_0[31-(iDATA_1[5:0]-1)];
					end
				end
			3'h5 :			//Rotate Right
				begin
					if(iDATA_1[5:0] > 32 || iDATA_1[5:0] == 6'h0)begin
						flag_cf = 1'b0;
					end
					else begin
						flag_cf = iDATA_0[iDATA_1[5:0]-1];
					end
				end
			default:		//Reserved (Buffer)
				begin
					flag_cf = 1'b0;
				end
		endcase
	end
	
	
	assign oDATA = data_out;
	assign oSF = data_out[P_N-1];
	assign oOF = 1'b0;
	assign oCF = flag_cf;
	assign oPF = data_out[0];
	assign oZF = (data_out == {32{1'b0}})? 1'b1 : 1'b0;
	
endmodule


`default_nettype wire


/****************************************
	Adder Unit
	- 32bit Adder
	
	
	Make	:	2010/12/07
	Update	:		
****************************************/
`default_nettype none
`include "core.h"



module adder_n
	#(
		parameter	N	=	32
	)(
		//iDATA
		input	[N-1:0]			iDATA_0,
		input	[N-1:0]			iDATA_1,
		input	[4:0]			iADDER_CMD,
		//oDATA
		output	[N-1:0]			oDATA,
		output					oSF,
		output					oOF,				
		output					oCF,
		output					oPF,
		output					oZF
	);

			
	/****************************************
	This -> Output
	****************************************/
	assign		{oZF, oPF, oOF, oSF, oCF, oDATA}	=		func_adder_execution(iADDER_CMD, iDATA_0, iDATA_1);
	
	//ZF, PF, OF, SF, CF, Data
	function [36:0] func_adder_execution;
		input		[4:0]		func_cmd;
		input		[31:0]		func_data0;
		input		[31:0]		func_data1;
		
		reg			[32:0]		func_pri_op0;
		reg			[32:0]		func_pri_op1;
		
		reg			[32:0]		func_pri_out;
		begin
			case(func_cmd)
				`EXE_ADDER_ADD :
					begin
						func_pri_op0				=	{1'b0, func_data0};
						func_pri_op1				=	{1'b0, func_data1};
						func_pri_out				=	func_pri_op0 + func_pri_op1;//func_data0 + func_data1;
						func_adder_execution		=	{(func_pri_out[31:0] == {32{1'h0}}), func_pri_out[0], (func_pri_op0[31] == func_pri_op1[31] && func_pri_op0[31] != func_pri_out[31]), func_pri_out[31], func_pri_out[32], func_pri_out[31:0]};
					end
				`EXE_ADDER_SUB :
					begin
						func_pri_op0				=	{1'b0, func_data0};
						func_pri_op1				=	({1'b0, ~func_data1} + 32'h1);
						func_pri_out				=	func_pri_op0 + func_pri_op1;
						func_adder_execution		=	{(func_pri_out[31:0] == {32{1'h0}}), func_pri_out[0],( func_data0[31] != func_data1[31] && func_data0[31] != func_pri_out[31]), func_pri_out[31], func_pri_out[32], func_pri_out[31:0]};
					end
				`EXE_ADDER_NEG:
					begin
						func_pri_op0				=	{1'b0, func_data0};
						func_pri_op1				=	{1'b0, func_data1};
						func_pri_out				=	~func_data0 + {{N-1{1'b0}}, 1'b1};
						func_adder_execution		=	{5'h0, func_pri_out[31:0]};//{(func_pri_out[31:0] == {32{1'h0}}), func_pri_out[0], (func_pri_out[32] ^ func_pri_out[31]), func_pri_out[31], func_pri_out[32], func_pri_out[31:0]};
					end
				`EXE_ADDER_COUT	:
					begin
						func_pri_op0				=	{1'b0, func_data0};
						func_pri_op1				=	{1'b0, func_data1};
						func_pri_out				=	func_pri_op0 + func_pri_op1;//func_data0 + func_data1;
						func_adder_execution		=	{(func_pri_out[31:0] == {32{1'h0}}), func_pri_out[0], (func_pri_op0[31] == func_pri_op1[31] && func_pri_op0[31] != func_pri_out[31]), func_pri_out[31], func_pri_out[32], 31'h0 , func_pri_out[32]};
					end
				`EXE_ADDER_SEXT8 :
					begin
						func_pri_op0				=	{1'b0, func_data0};
						func_pri_op1				=	{1'b0, func_data1};
						func_pri_out				=	{1'b0, {24{func_data1[7]}}, func_data1[7:0]};
						func_adder_execution		=	{5'h0, func_pri_out[31:0]};//{(func_pri_out[31:0] == {32{1'h0}}), func_pri_out[0], (func_pri_out[32] ^ func_pri_out[31]), func_pri_out[31], func_pri_out[32], func_pri_out[31:0]};
					end
				`EXE_ADDER_SEXT16 :
					begin
						func_pri_op0				=	{1'b0, func_data0};
						func_pri_op1				=	{1'b0, func_data1};
						func_pri_out				=	{1'b0, {16{func_data1[15]}}, func_data1[15:0]};
						func_adder_execution		=	{5'h0, func_pri_out[31:0]};//{(func_pri_out[31:0] == {32{1'h0}}), func_pri_out[0], (func_pri_out[32] ^ func_pri_out[31]), func_pri_out[31], func_pri_out[32], func_pri_out[31:0]};
					end
				default:
					begin/*	
						//$display("[ERROR] : adder_n.v func_addder_execution Error");
						func_pri_out				=	{33{1'b0}};
						func_adder_execution		=	{37{1'b0}};
						*/
						func_pri_op0				=	{1'b0, func_data0};
						func_pri_op1				=	{1'b0, func_data1};
						func_pri_out				=	{33{1'b0}};
						func_adder_execution		=	{37{1'h0}};
					end
			endcase
		end
	endfunction
	
	
endmodule


`default_nettype wire


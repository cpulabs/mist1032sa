/****************************************
MIST1032SA
OoO Processor

for Open Design Computer Project

Takahiro Ito @cpu_labs
****************************************/

`include "core.h"
`default_nettype none

module execute_port2(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Free
		input wire iFREE_EX,
		//Previous
		input wire iPREVIOUS_EX_ALU2_VALID,
		input wire iPREVIOUS_EX_ALU2_WRITEBACK,
		input wire [5:0] iPREVIOUS_EX_ALU2_COMMIT_TAG,
		input wire [4:0] iPREVIOUS_EX_ALU2_CMD,
		input wire [3:0] iPREVIOUS_EX_ALU2_AFE,
		input wire iPREVIOUS_EX_ALU2_SYS_REG,
		input wire iPREVIOUS_EX_ALU2_LOGIC,
		input wire iPREVIOUS_EX_ALU2_SHIFT,
		input wire iPREVIOUS_EX_ALU2_ADDER,
		input wire [31:0] iPREVIOUS_EX_ALU2_SOURCE0,
		input wire [31:0] iPREVIOUS_EX_ALU2_SOURCE1,
		input wire iPREVIOUS_EX_ALU2_DESTINATION_SYSREG,
		input wire [5:0] iPREVIOUS_EX_ALU2_DESTINATION_REGNAME,
		input wire iPREVIOUS_EX_ALU2_FLAGS_WRITEBACK,
		input wire [3:0] iPREVIOUS_EX_ALU2_FLAGS_REGNAME,
		output wire oPREVIOUS_EX_ALU2_LOCK,
		//NEXTUNIT - SCHEDULER1
		output wire oSCHE1_EX_ALU2_VALID,
		output wire [5:0] oSCHE1_EX_ALU2_COMMIT_TAG,
		//NEXTUNIT - SCHEDULER2
		output wire oSCHE2_EX_ALU2_VALID,
		output wire [5:0] oSCHE2_EX_ALU2_COMMIT_TAG,
		output wire oSCHE2_EX_ALU2_SYSREG,
		output wire [5:0] oSCHE2_EX_ALU2_DESTINATION_REGNAME,
		output wire oSCHE2_EX_ALU2_WRITEBACK,
		output wire [31:0] oSCHE2_EX_ALU2_DATA,
		output wire [4:0] oSCHE2_EX_ALU2_FLAG,
		output wire oSCHE2_EX_ALU2_FLAGS_WRITEBACK,
		output wire [3:0] oSCHE2_EX_ALU2_FLAGS_REGNAME
	);
		

	/****************************************
	Register and Wire
	****************************************/
	//System Register
	wire	[31:0]		sys_reg_data;
	wire				sys_reg_sf;
	wire				sys_reg_of;
	wire				sys_reg_cf;
	wire				sys_reg_pf;
	wire				sys_reg_zf;
	wire	[4:0]		sys_reg_flags;
	//Logic
	wire	[31:0]		logic_data;
	wire				logic_sf;
	wire				logic_of;
	wire				logic_cf;
	wire				logic_pf;
	wire				logic_zf;
	wire	[4:0]		logic_cmd;
	wire	[4:0]		logic_flags;
	//Shift
	wire	[31:0]		shift_data;
	wire				shift_sf;
	wire				shift_of;
	wire				shift_cf;
	wire				shift_pf;
	wire				shift_zf;
	wire	[4:0]		shift_flags;
	//Adder
	wire	[31:0]		adder_data;
	wire				adder_sf;
	wire				adder_of;
	wire				adder_cf;
	wire				adder_pf;
	wire				adder_zf;
	wire	[4:0]		adder_flags;	
	//Writeback Buffer
	reg					b0_valid;
	reg		[5:0]		b0_commit_tag;
	reg					b0_sysreg;
	reg		[5:0]		b0_destination_regname;
	reg					b0_writeback;
	reg		[31:0]		b0_data;
	reg		[4:0]		b0_flag;
	reg					b0_flags_writeback;
	reg		[3:0]		b0_flags_regname;
	reg					b0_lock;
	
	
	
	
	/****************************************
	System Register
	****************************************/
	
	assign				sys_reg_sf		=		1'b0;
	assign				sys_reg_of		=		1'b0;
	assign				sys_reg_cf		=		1'b0;
	assign				sys_reg_pf		=		1'b0;
	assign				sys_reg_zf		=		1'b0;
	assign				sys_reg_flags		=		{sys_reg_sf, sys_reg_of, sys_reg_cf, sys_reg_pf, sys_reg_zf};
	
	sys_reg ALU2_SYS_REG(
		.iCMD(iPREVIOUS_EX_ALU2_CMD),
		.iSOURCE0(iPREVIOUS_EX_ALU2_SOURCE0),
		.iSOURCE1(iPREVIOUS_EX_ALU2_SOURCE1),
		.oOUT(sys_reg_data)
	);
	
	/****************************************
	Logic
	****************************************/
	assign	logic_cmd		=	func_logic_select(iPREVIOUS_EX_ALU2_CMD);
	
	
	function [4:0] func_logic_select;
		input wire [4:0]	func_logic_select_cmd;
		
		begin
			case(func_logic_select_cmd)
				`EXE_LOGIC_BUFFER0	:	func_logic_select		=		5'h0;	
				`EXE_LOGIC_BUFFER1	:	func_logic_select		=		5'h1;
				`EXE_LOGIC_AND		:	func_logic_select		=		5'h4;										
				`EXE_LOGIC_OR		:	func_logic_select		=		5'h5;								
				`EXE_LOGIC_XOR		:	func_logic_select		=		5'h6;							
				`EXE_LOGIC_NOT		:	func_logic_select		=		5'h2;										
				`EXE_LOGIC_NAND		:	func_logic_select		=		5'h7;									
				`EXE_LOGIC_NOR		:	func_logic_select		=		5'h8;								
				`EXE_LOGIC_XNOR		:	func_logic_select		=		5'h9;	
				`EXE_LOGIC_TEST		:	func_logic_select		=		5'h4;
				`EXE_LOGIC_WBL		:	func_logic_select		=		5'h10;													
				`EXE_LOGIC_WBH		:	func_logic_select		=		5'h11;
				`EXE_LOGIC_CLB		:	func_logic_select		=		5'hA;
				`EXE_LOGIC_STB		:	func_logic_select		=		5'hB;
				`EXE_LOGIC_CLW		:	func_logic_select		=		5'h0;
				`EXE_LOGIC_STW		:	func_logic_select		=		5'h0;
				`EXE_LOGIC_BITREV	:	func_logic_select		=		5'hC;
				`EXE_LOGIC_BYTEREV	:	func_logic_select		=		5'hD;
				`EXE_LOGIC_GETBIT	:	func_logic_select		=		5'hE;
				`EXE_LOGIC_GETBYTE	:	func_logic_select		=		5'hF;
				`EXE_LOGIC_LIL		:	func_logic_select		=		5'h12;
				`EXE_LOGIC_LIH		:	func_logic_select		=		5'h1;
				`EXE_LOGIC_ULIL		:	func_logic_select		=		5'h14;	
				default
					begin
						func_logic_select		=		5'h0;	
						/*
						func_logic_select	=		{4{1'b0}};
						if(func_logic_select_cmd != 4'hx)begin
							$display("[Logic Calcration Error] alu1.v : Not CMD[CMD:%x]", func_logic_select_cmd);
						end
						*/
						//Error
					end
			endcase
		end
	endfunction
				
	
	logic_n #(32) ALU2_LOGIC(	
		.iCONTROL_CMD(logic_cmd),
		.iDATA_0(iPREVIOUS_EX_ALU2_SOURCE0), 
		.iDATA_1(iPREVIOUS_EX_ALU2_SOURCE1),
		.oDATA(logic_data), 
		.oSF(logic_sf), 
		.oOF(logic_of), 
		.oCF(logic_cf), 
		.oPF(logic_pf), 
		.oZF(logic_zf)
	);
	
	assign				logic_flags		=		{logic_sf, logic_of, logic_cf, logic_pf, logic_zf};
	
	/****************************************
	Shift
	****************************************/	
	
	shift_n #(32) ALU2_SHIFT(
		.iCONTROL_MODE(func_shift_select(iPREVIOUS_EX_ALU2_CMD)),
		.iDATA_0(iPREVIOUS_EX_ALU2_SOURCE0), 
		.iDATA_1(iPREVIOUS_EX_ALU2_SOURCE1),
		.oDATA(shift_data), 
		.oSF(shift_sf), 
		.oOF(shift_of), 
		.oCF(shift_cf), 
		.oPF(shift_pf), 
		.oZF(shift_zf)
	);
	


	
	function [2:0] func_shift_select;
		input		[4:0]	func_shift_select_cmd;
		begin
			case(func_shift_select_cmd)
				`EXE_SHIFT_BUFFER		:	func_shift_select		=		3'h0;
				`EXE_SHIFT_LOGICL		:	func_shift_select		=		3'h1;
				`EXE_SHIFT_LOGICR		:	func_shift_select		=		3'h2;
				`EXE_SHIFT_ALITHMETICR	:	func_shift_select		=		3'h3;
				`EXE_SHIFT_ROTATEL		:	func_shift_select		=		3'h4;
				`EXE_SHIFT_ROTATER		:	func_shift_select		=		3'h5;
				default:					func_shift_select		=		3'h0;
			endcase
		end
	endfunction


	assign				shift_flags		=		{shift_sf, shift_of, shift_cf, shift_pf, shift_zf};
	/****************************************
	Adder
	****************************************/

	adder_n	#(32) ALU2_ADDER(	
		.iDATA_0(iPREVIOUS_EX_ALU2_SOURCE0), 
		.iDATA_1(iPREVIOUS_EX_ALU2_SOURCE1), 
		.iADDER_CMD(iPREVIOUS_EX_ALU2_CMD),
		.oDATA(adder_data), 
		.oSF(adder_sf), 
		.oOF(adder_of), 
		.oCF(adder_cf), 
		.oPF(adder_pf), 
		.oZF(adder_zf)
	);


	assign				adder_flags		=		{adder_sf, adder_of, adder_cf, adder_pf, adder_zf};
	
	
	
	/****************************************
	Writeback Buffer
	****************************************/	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_valid					<=		1'b0;
			b0_commit_tag				<=		{6{1'b0}};
			b0_sysreg					<=		1'b0;
			b0_destination_regname		<=		{6{1'b0}};
			b0_writeback				<=		1'b0;
			b0_data						<=		{32{1'b0}};
			b0_flag						<=		1'b0;
			b0_flags_writeback			<=		1'b0;
			b0_flags_regname			<=		4'h0;
			b0_lock						<=		1'b0;
		end
		else if(iFREE_EX)begin
			b0_valid					<=		1'b0;
			b0_commit_tag				<=		{6{1'b0}};
			b0_sysreg					<=		1'b0;
			b0_destination_regname		<=		{6{1'b0}};
			b0_writeback				<=		1'b0;
			b0_data						<=		{32{1'b0}};
			b0_flag						<=		1'b0;
			b0_flags_writeback			<=		1'b0;
			b0_flags_regname			<=		4'h0;
			b0_lock						<=		1'b0;
		end
		else begin
			b0_valid					<=		(b0_lock)? 1'b0 : iPREVIOUS_EX_ALU2_VALID;
			b0_commit_tag				<=		iPREVIOUS_EX_ALU2_COMMIT_TAG;
			b0_sysreg					<=		iPREVIOUS_EX_ALU2_DESTINATION_SYSREG;
			b0_destination_regname		<=		iPREVIOUS_EX_ALU2_DESTINATION_REGNAME;
			b0_writeback				<=		iPREVIOUS_EX_ALU2_WRITEBACK;
			b0_data						<=		((iPREVIOUS_EX_ALU2_SYS_REG)? sys_reg_data :
													((iPREVIOUS_EX_ALU2_LOGIC)? logic_data : 
														((iPREVIOUS_EX_ALU2_SHIFT)? shift_data : adder_data)
													)
												);
			b0_flag						<=		((iPREVIOUS_EX_ALU2_SYS_REG)? sys_reg_flags :
													((iPREVIOUS_EX_ALU2_LOGIC)? logic_flags : 
														((iPREVIOUS_EX_ALU2_SHIFT)? shift_flags : adder_flags)
													)
												);
			b0_flags_writeback			<=		iPREVIOUS_EX_ALU2_FLAGS_WRITEBACK;
			b0_flags_regname			<=		iPREVIOUS_EX_ALU2_FLAGS_REGNAME;
			b0_lock						<=		1'b0;
		end
	end //always
	
	/****************************************
	Assign
	****************************************/
	assign	oPREVIOUS_EX_ALU2_LOCK	=		1'b0;
	assign	oSCHE1_EX_ALU2_VALID					=		b0_valid;
	assign	oSCHE1_EX_ALU2_COMMIT_TAG				=		b0_commit_tag;
	assign	oSCHE2_EX_ALU2_VALID					=		b0_valid;
	assign	oSCHE2_EX_ALU2_DESTINATION_REGNAME		=		b0_destination_regname;
	assign	oSCHE2_EX_ALU2_COMMIT_TAG				=		b0_commit_tag;
	assign	oSCHE2_EX_ALU2_SYSREG					=		b0_sysreg;
	assign	oSCHE2_EX_ALU2_WRITEBACK				=		b0_writeback;
	assign	oSCHE2_EX_ALU2_DATA						=		b0_data;
	assign	oSCHE2_EX_ALU2_FLAG						=		b0_flag;
	assign	oSCHE2_EX_ALU2_FLAGS_WRITEBACK			=		b0_flags_writeback;
	assign	oSCHE2_EX_ALU2_FLAGS_REGNAME			=		b0_flags_regname;	
	
endmodule



`default_nettype wire
	


/****************************************
MIST1032SA
OoO Processor

for Open Design Computer Project

Takahiro Ito @cpu_labs
****************************************/

`include "core.h"
`default_nettype none

module execute_port1(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Free
		input wire iFREE_EX,
		//Previous
		input wire iPREVIOUS_EX_ALU1_VALID,
		input wire iPREVIOUS_EX_ALU1_WRITEBACK,
		input wire [5:0] iPREVIOUS_EX_ALU1_COMMIT_TAG,
		input wire [4:0] iPREVIOUS_EX_ALU1_CMD,
		input wire [3:0] iPREVIOUS_EX_ALU1_AFE,
		input wire iPREVIOUS_EX_ALU1_SYS_REG,		
		input wire iPREVIOUS_EX_ALU1_LOGIC,
		input wire iPREVIOUS_EX_ALU1_SHIFT,
		input wire iPREVIOUS_EX_ALU1_ADDER,
		input wire iPREVIOUS_EX_ALU1_MUL,
		input wire iPREVIOUS_EX_ALU1_SDIV,
		input wire iPREVIOUS_EX_ALU1_UDIV,
		input wire [31:0] iPREVIOUS_EX_ALU1_SOURCE0,
		input wire [31:0] iPREVIOUS_EX_ALU1_SOURCE1,
		input wire iPREVIOUS_EX_ALU1_DESTINATION_SYSREG,
		input wire [5:0] iPREVIOUS_EX_ALU1_DESTINATION_REGNAME,
		input wire iPREVIOUS_EX_ALU1_FLAGS_WRITEBACK,
		input wire [3:0] iPREVIOUS_EX_ALU1_FLAGS_REGNAME,
		output wire oPREVIOUS_EX_ALU1_LOCK,
		//Interrupt
		output wire oINTERRUPT_ACTIVE,
		output wire [10:0] oINTERRUPT_NUM,
		//NEXTUNIT - SCHEDULER1
		output wire oSCHE1_EX_ALU1_VALID,
		output wire [5:0] oSCHE1_EX_ALU1_COMMIT_TAG,
		//NEXTUNIT - SCHEDULER2
		output wire oSCHE2_EX_ALU1_VALID,
		output wire [5:0] oSCHE2_EX_ALU1_COMMIT_TAG,
		output wire oSCHE2_EX_ALU1_SYSREG,
		output wire [5:0] oSCHE2_EX_ALU1_DESTINATION_REGNAME,
		output wire oSCHE2_EX_ALU1_WRITEBACK,
		output wire [31:0] oSCHE2_EX_ALU1_DATA,
		output wire [4:0] oSCHE2_EX_ALU1_FLAG,
		output wire oSCHE2_EX_ALU1_FLAGS_WRITEBACK,
		output wire [3:0] oSCHE2_EX_ALU1_FLAGS_REGNAME
	);
				
	
	/****************************************
	Wire and Register
	****************************************/
	wire this_lock;
	//System Register
	wire [31:0] sys_reg_data;
	wire sys_reg_sf;
	wire sys_reg_of;
	wire sys_reg_cf;
	wire sys_reg_pf;
	wire sys_reg_zf;
	wire [4:0] sys_reg_flags;
	//Logic
	wire [31:0] logic_data;
	wire logic_sf;
	wire logic_of;
	wire logic_cf;
	wire logic_pf;
	wire logic_zf;
	wire [4:0] logic_cmd;
	wire [4:0] logic_flags;
	//Shift
	wire [31:0] shift_data;
	wire shift_sf;
	wire shift_of;
	wire shift_cf;
	wire shift_pf;
	wire shift_zf;
	wire [4:0] shift_flags;
	//Adder
	wire [31:0] adder_data;
	wire adder_sf;
	wire adder_of;
	wire adder_cf;
	wire adder_pf;
	wire adder_zf;
	wire [4:0] adder_flags;
	//Mull
	wire [63:0] mul_tmp;
	wire mul_sf_l;
	wire mul_of_l;
	wire mul_cf_l;
	wire mul_pf_l;
	wire mul_zf_l;
	wire mul_sf_h;
	wire mul_of_h;
	wire mul_cf_h;
	wire mul_pf_h;
	wire mul_zf_h;
	wire [4:0] mul_flags;
	wire [31:0] mul_data;
	//Writeback Register
	reg b0_valid;
	reg [5:0] b0_commit_tag;
	reg b0_sysreg;
	reg [5:0] b0_destination_regname;
	reg b0_writeback;
	reg [31:0] b0_data;
	reg [4:0] b0_flag;
	reg b0_flag_opt_valid;
	reg b0_exception_valid;
	reg [10:0] b0_exception_num;
	reg [3:0] b0_flags_regname;
	reg b0_lock;
	//Exception Check
	wire exception_condition;
	wire [10:0]	exception_number;
	//Divider
	wire divider_condition;
	wire divider_mod_flag;
	wire [5:0] divider_commit_tag;
	wire divider_sysreg;
	wire [5:0] divider_destination_regname;
	wire divider_out_valid;
	wire [31:0]	divider_out_q;
	wire [31:0]	divider_out_r;
	wire [31:0]	divider_out_data;
	
	//Lock
	assign this_lock = divider_out_valid && !divider_condition;		//Divider is Output notoki Divider no Regist dehanai baai Lock

	
	/****************************************
	System Register
	****************************************/
	assign sys_reg_sf = 1'b0;
	assign sys_reg_of = 1'b0;
	assign sys_reg_cf = 1'b0;
	assign sys_reg_pf = 1'b0;
	assign sys_reg_zf = 1'b0;
	assign sys_reg_flags = {sys_reg_sf, sys_reg_of, sys_reg_cf, sys_reg_pf, sys_reg_zf};
	
	execute_sys_reg ALU1_SYS_REG(
		.iCMD(iPREVIOUS_EX_ALU1_CMD),
		.iSOURCE0(iPREVIOUS_EX_ALU1_SOURCE0),
		.iSOURCE1(iPREVIOUS_EX_ALU1_SOURCE1),
		.oOUT(sys_reg_data)
	);
	
	/****************************************
	Logic
	****************************************/
	assign logic_cmd = func_logic_select(iPREVIOUS_EX_ALU1_CMD);
	
	
	function [4:0] func_logic_select;
		input [4:0] func_logic_select_cmd;
		begin
			case(func_logic_select_cmd)
				`EXE_LOGIC_BUFFER0	:	func_logic_select = 5'h00;	
				`EXE_LOGIC_BUFFER1	:	func_logic_select = 5'h01;
				`EXE_LOGIC_AND		:	func_logic_select = 5'h04;										
				`EXE_LOGIC_OR		:	func_logic_select = 5'h05;								
				`EXE_LOGIC_XOR		:	func_logic_select = 5'h06;							
				`EXE_LOGIC_NOT		:	func_logic_select = 5'h02;										
				`EXE_LOGIC_NAND		:	func_logic_select = 5'h07;									
				`EXE_LOGIC_NOR		:	func_logic_select = 5'h08;								
				`EXE_LOGIC_XNOR		:	func_logic_select = 5'h09;	
				`EXE_LOGIC_TEST		:	func_logic_select = 5'h04;
				`EXE_LOGIC_WBL		:	func_logic_select = 5'h10;													
				`EXE_LOGIC_WBH		:	func_logic_select = 5'h11;
				`EXE_LOGIC_CLB		:	func_logic_select = 5'h0A;
				`EXE_LOGIC_STB		:	func_logic_select = 5'h0B;
				`EXE_LOGIC_CLW		:	func_logic_select = 5'h15;
				`EXE_LOGIC_STW		:	func_logic_select = 5'h16;
				`EXE_LOGIC_BITREV	:	func_logic_select = 5'h0C;
				`EXE_LOGIC_BYTEREV	:	func_logic_select = 5'h0D;
				`EXE_LOGIC_GETBIT	:	func_logic_select = 5'h0E;
				`EXE_LOGIC_GETBYTE	:	func_logic_select = 5'h0F;
				`EXE_LOGIC_LIL		:	func_logic_select = 5'h12;
				`EXE_LOGIC_LIH		:	func_logic_select = 5'h01;
				`EXE_LOGIC_ULIL		:	func_logic_select = 5'h14;	
				default
					begin
						func_logic_select = 5'h00;	
						/*
							func_logic_select	=		{4{1'b0}};
							if(func_logic_select_cmd != 4'hx)begin
								$display("[Logic Calcration Error] alu1.v : Not CMD[CMD:%x]", func_logic_select_cmd);
							end
						*/
					end
			endcase
		end
	endfunction
				
	
	execute_logic #(32) ALU1_LOGIC(	
		.iCONTROL_CMD(logic_cmd),
		.iDATA_0(iPREVIOUS_EX_ALU1_SOURCE0), 
		.iDATA_1(iPREVIOUS_EX_ALU1_SOURCE1),
		.oDATA(logic_data), 
		.oSF(logic_sf), 
		.oOF(logic_of), 
		.oCF(logic_cf), 
		.oPF(logic_pf), 
		.oZF(logic_zf)
	);
								
	assign logic_flags = {logic_sf, logic_of, logic_cf, logic_pf, logic_zf};
	
	/****************************************
	Shift
	****************************************/	
	execute_shift #(32) ALU1_SHIFT(	
		.iCONTROL_MODE(func_shift_select(iPREVIOUS_EX_ALU1_CMD)),
		.iDATA_0(iPREVIOUS_EX_ALU1_SOURCE0),
		.iDATA_1(iPREVIOUS_EX_ALU1_SOURCE1),
		.oDATA(shift_data),
		.oSF(shift_sf),
		.oOF(shift_of),
		.oCF(shift_cf),
		.oPF(shift_pf),
		.oZF(shift_zf)
	);
	


	function [2:0] func_shift_select;
		input [4:0] func_shift_select_cmd;
		begin
			case(func_shift_select_cmd)
				`EXE_SHIFT_BUFFER		:	func_shift_select = 3'h0;
				`EXE_SHIFT_LOGICL		:	func_shift_select = 3'h1;
				`EXE_SHIFT_LOGICR		:	func_shift_select = 3'h2;
				`EXE_SHIFT_ALITHMETICR	:	func_shift_select = 3'h3;
				`EXE_SHIFT_ROTATEL		:	func_shift_select = 3'h4;
				`EXE_SHIFT_ROTATER		:	func_shift_select = 3'h5;
				default:					func_shift_select = 3'h0;
			endcase
		end
	endfunction

	assign shift_flags = {shift_sf, shift_of, shift_cf, shift_pf, shift_zf};

	/****************************************
	Adder
	****************************************/
	execute_adder #(32) ALU1_ADDER(
		.iDATA_0(iPREVIOUS_EX_ALU1_SOURCE0), 
		.iDATA_1(iPREVIOUS_EX_ALU1_SOURCE1), 
		.iADDER_CMD(iPREVIOUS_EX_ALU1_CMD),
		.oDATA(adder_data), 
		.oSF(adder_sf), 
		.oOF(adder_of), 
		.oCF(adder_cf), 
		.oPF(adder_pf), 
		.oZF(adder_zf)
	);

	assign adder_flags = {adder_sf, adder_of, adder_cf, adder_pf, adder_zf};
	
	/****************************************
	Mul 
	****************************************/	
	assign mul_tmp = iPREVIOUS_EX_ALU1_SOURCE0 * iPREVIOUS_EX_ALU1_SOURCE1;
	assign mul_sf_l = mul_tmp[31];
	assign mul_cf_l = mul_tmp[32];
	assign mul_of_l = mul_tmp[31] ^ mul_tmp[32];
	assign mul_pf_l = mul_tmp[0];
	assign mul_zf_l = (mul_tmp == {64{1'b0}})? 1'b1 : 1'b0;
	assign mul_sf_h = mul_tmp[63];
	assign mul_cf_h = 1'b0;
	assign mul_of_h = 1'b0;
	assign mul_pf_h = mul_tmp[32];
	assign mul_zf_h = (mul_tmp == {64{1'b0}})? 1'b1 : 1'b0;
	
	assign mul_flags = (iPREVIOUS_EX_ALU1_CMD == `EXE_MUL_MULH || iPREVIOUS_EX_ALU1_CMD == `EXE_MUL_UMULH)? {mul_sf_h, mul_of_h, mul_cf_h, mul_pf_h, mul_zf_h} : {mul_sf_l, mul_of_l, mul_cf_l, mul_pf_l, mul_zf_l};
	assign mul_data = (iPREVIOUS_EX_ALU1_CMD == `EXE_MUL_MULH || iPREVIOUS_EX_ALU1_CMD == `EXE_MUL_UMULH)? mul_tmp[63:32] : mul_tmp[31:0];
	
	/****************************************
	Latch Data Select 
	****************************************/
	reg [31:0] latch_sel_data;
	reg [4:0] latch_sel_flag;
	always @* begin
		if(iPREVIOUS_EX_ALU1_SYS_REG)begin
			latch_sel_data = sys_reg_data;
			latch_sel_flag = sys_reg_flags;
		end
		else if(iPREVIOUS_EX_ALU1_LOGIC)begin
			latch_sel_data = logic_data;
			latch_sel_flag = logic_flags;
		end
		else if(iPREVIOUS_EX_ALU1_SHIFT)begin
			latch_sel_data = shift_data;
			latch_sel_flag = shift_flags;
		end
		else if(iPREVIOUS_EX_ALU1_MUL)begin
			latch_sel_data = mul_data;
			latch_sel_flag = mul_flags;
		end
		else begin //Adder
			latch_sel_data = adder_data;
			latch_sel_flag = adder_flags;
		end
	end


	/****************************************
	Adder / Logic / Shift / Mul Select & Latch
	****************************************/		
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_valid <= 1'b0;
			b0_commit_tag <= {6{1'b0}};
			b0_sysreg <= 1'b0;
			b0_destination_regname <= {6{1'b0}};
			b0_writeback <= 1'b0;
			b0_data <= {32{1'b0}};
			b0_flag <= 1'b0;
			b0_flag_opt_valid <= 1'b0;
			b0_exception_valid <= 1'b0;
			b0_exception_num <= 11'h0;
			b0_flags_regname <= 4'h0;
			b0_lock <= 1'b0;
		end
		else if(iFREE_EX)begin
			b0_valid <= 1'b0;
			b0_commit_tag <= {6{1'b0}};
			b0_sysreg <= 1'b0;
			b0_destination_regname <= {6{1'b0}};
			b0_writeback <= 1'b0;
			b0_data <= {32{1'b0}};
			b0_flag <= 1'b0;
			b0_flag_opt_valid <= 1'b0;
			b0_exception_valid <= 1'b0;
			b0_exception_num <= 11'h0;
			b0_flags_regname <= 4'h0;
			b0_lock <= 1'b0;
		end
		else begin
			if(!divider_out_valid)begin
				b0_valid <= (b0_lock)? 1'b0 : iPREVIOUS_EX_ALU1_VALID && (iPREVIOUS_EX_ALU1_LOGIC || iPREVIOUS_EX_ALU1_SHIFT || iPREVIOUS_EX_ALU1_ADDER || iPREVIOUS_EX_ALU1_MUL);
				b0_commit_tag <= iPREVIOUS_EX_ALU1_COMMIT_TAG;
				b0_sysreg <= iPREVIOUS_EX_ALU1_DESTINATION_SYSREG;
				b0_destination_regname <= iPREVIOUS_EX_ALU1_DESTINATION_REGNAME;
				b0_writeback <= iPREVIOUS_EX_ALU1_WRITEBACK;
				b0_data <= latch_sel_data;
				b0_flag <= latch_sel_flag;
				b0_flag_opt_valid <= iPREVIOUS_EX_ALU1_FLAGS_WRITEBACK;
				b0_flags_regname <= iPREVIOUS_EX_ALU1_FLAGS_REGNAME;
			end
			b0_exception_valid <= (b0_lock)? 1'b0 : exception_condition;
			b0_exception_num <= exception_number;
			b0_lock <= (b0_lock)? 1'b1 : exception_condition;
		end
	end //always
	
	/****************************************
	Exception Check
	****************************************/
	
	assign {exception_condition, exception_number} = 12'h0;//func_ecxeption_check(iPREVIOUS_EX_ALU1_VALID && (iPREVIOUS_EX_ALU1_UDIV || iPREVIOUS_EX_ALU1_SDIV), iPREVIOUS_EX_ALU1_SOURCE0, iPREVIOUS_EX_ALU1_SOURCE1);
	
	/*
	function [11:0] func_ecxeption_check;
		input func_mul;
		input [31:0] func_source0;
		input [31:0] func_source1;
		begin
			if(func_mul)begin
				if(func_source0 == 32'h0 || func_source1 == 32'h0)begin
					func_ecxeption_check = {1'b1, `EXCEPT_DIV};
				end
			end
			else begin
				func_ecxeption_check = {1'b0, 11'h0};
			end
		end
	endfunction
	*/
	
	/****************************************
	Divider
	****************************************/
	assign divider_condition = iPREVIOUS_EX_ALU1_VALID && (iPREVIOUS_EX_ALU1_UDIV || iPREVIOUS_EX_ALU1_SDIV);
	
	//parameter is N, DEPTH, DEPTH_N
	mist1032sa_sync_fifo #(14, 16, 4) ALU1_DIV_CONDITION_FIFO (
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET), 
		.iREMOVE(iFREE_EX), 
		.oCOUNT(/* Not Use */), 	
		.iWR_EN(divider_condition), 
		.iWR_DATA({(iPREVIOUS_EX_ALU1_UDIV && iPREVIOUS_EX_ALU1_CMD == `EXE_DIV_UMOD || iPREVIOUS_EX_ALU1_SDIV && iPREVIOUS_EX_ALU1_CMD == `EXE_DIV_MOD), iPREVIOUS_EX_ALU1_COMMIT_TAG, iPREVIOUS_EX_ALU1_DESTINATION_SYSREG, iPREVIOUS_EX_ALU1_DESTINATION_REGNAME}), 
		.oWR_FULL(/* Not Use */),
		.iRD_EN(divider_out_valid), 
		.oRD_DATA({divider_mod_flag, divider_commit_tag, divider_sysreg, divider_destination_regname}), 
		.oRD_EMPTY(/* Not Use */)
	);
	
	pipelined_div_radix2 ALU1_DIV(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iFREE_EX),
		//Source
		.oSOURCE_BUSY(/* Not Use*/),
		.iSOURCE_VALID(divider_condition),
		.iSOURCE_SIGN(iPREVIOUS_EX_ALU1_SDIV),
		.iSOURCE_DIVIDEND(iPREVIOUS_EX_ALU1_SOURCE0),
		.iSOURCE_DIVISOR(iPREVIOUS_EX_ALU1_SOURCE1),
		//Output
		.iOUT_BUSY(1'b0),
		.oOUT_VALID(divider_out_valid),
		.oOUT_DATA_Q(divider_out_q),
		.oOUT_DATA_R(divider_out_r)
	);
	
	assign divider_out_data = (divider_mod_flag)? divider_out_r : divider_out_q;
	
	/****************************************
	Output Select
	****************************************/
	//Lock
	assign oPREVIOUS_EX_ALU1_LOCK = this_lock;
	//Interrupt
	assign oINTERRUPT_ACTIVE = b0_exception_valid;
	assign oINTERRUPT_NUM = b0_exception_num;
	
	assign oSCHE1_EX_ALU1_VALID = (!divider_out_valid)? b0_valid : divider_out_valid;
	assign oSCHE1_EX_ALU1_COMMIT_TAG = (!divider_out_valid)? b0_commit_tag : divider_commit_tag;
	assign oSCHE2_EX_ALU1_VALID = (!divider_out_valid)? b0_valid : divider_out_valid;
	assign oSCHE2_EX_ALU1_SYSREG = (!divider_out_valid)? b0_sysreg : divider_sysreg;
	assign oSCHE2_EX_ALU1_DESTINATION_REGNAME = (!divider_out_valid)? b0_destination_regname : divider_destination_regname;
	assign oSCHE2_EX_ALU1_COMMIT_TAG = (!divider_out_valid)? b0_commit_tag : divider_commit_tag;
	assign oSCHE2_EX_ALU1_WRITEBACK = (!divider_out_valid)? b0_writeback : 1'b1;
	assign oSCHE2_EX_ALU1_DATA = (!divider_out_valid)? b0_data : divider_out_data;
	assign oSCHE2_EX_ALU1_FLAG = (!divider_out_valid)? b0_flag : {5{1'b0}};
	assign oSCHE2_EX_ALU1_FLAGS_WRITEBACK = (!divider_out_valid)? b0_flag_opt_valid : 1'b0;
	assign oSCHE2_EX_ALU1_FLAGS_REGNAME = (!divider_out_valid)? b0_flags_regname : 4'h0;
	

endmodule


`default_nettype wire

		
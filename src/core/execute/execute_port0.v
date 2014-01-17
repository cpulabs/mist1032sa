/****************************************
MIST1032SA
OoO Processor

for Open Design Computer Project

Takahiro Ito @cpu_labs
****************************************/

`include "core.h"
`default_nettype none

module execute_port0(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Free
		input wire iFREE_RESTART,
		//Previous
		input wire iPREVIOUS_EX_BRANCH_VALID,
		input wire [5:0] iPREVIOUS_EX_BRANCH_COMMIT_TAG,
		input wire [4:0] iPREVIOUS_EX_BRANCH_CMD,
		input wire [3:0] iPREVIOUS_EX_BRANCH_CC,
		input wire [4:0] iPREVIOUS_EX_BRANCH_FLAG,
		input wire [31:0] iPREVIOUS_EX_BRANCH_SOURCE,
		input wire [31:0] iPREVIOUS_EX_BRANCH_PC,
		output wire oPREVIOUS_EX_BRANCH_LOCK,
		//Jump
		output wire oJUMP_ACTIVE,
		output wire [31:0] oJUMP_ADDR,
		//SWI
		output wire oSWI_ACTIVE,
		output wire [10:0] oSWI_NUMBER,
		//Interrupt Return
		output wire oINTR_ACTIVE,
		output wire [31:0] oINTR_ADDR,
		//IDTS
		output wire oIDTS_ACTIVE,
		output wire [31:0] oIDTS_R_ADDR,
		output wire [5:0] oIDTR_COMMIT_TAG,
		//NEXTUNIT - SCHEDULER1
		output wire oSCHE1_EX_BRANCH_VALID,
		output wire [5:0] oSCHE1_EX_BRANCH_COMMIT_TAG,
		//Scheduler2
		output wire oSCHE2_EX_BRANCH_VALID,
		output wire [5:0] oSCHE2_EX_BRANCH_COMMIT_TAG
	);
	
	
	execute_branch EXECUTE_BRANCH(
		.iDATA_0(32'h0),	//non use
		.iDATA_1(iPREVIOUS_EX_BRANCH_SOURCE),		
		.iPC(iPREVIOUS_EX_BRANCH_PC),
		.iFLAG(iPREVIOUS_EX_BRANCH_FLAG),
		.iCC(iPREVIOUS_EX_BRANCH_CC),
		.iCMD(iPREVIOUS_EX_BRANCH_CMD),
		.oBRANCH_ADDR(),
		.oJUMP_VALID(),
		.oNOT_JUMP_VALID(),
		.oIB_VALID(),
		.oIDTS_VALID(),
		.oHALT_VALID()
	);


				
	/****************************************
	Register and Wire
	****************************************/
	//State Register
	reg				b0_lock;
	reg				b0_entry_valid;
	reg				b0_branch_valid;
	reg				b0_swi_valid;
	reg		[10:0]	b0_swi_number;
	reg				b0_intr_valid;
	reg		[5:0]	b0_commit_tag;
	reg		[31:0]	b0_addr;
	reg				b0_idts_valid;
	reg		[31:0]	b0_idts_addr;
		
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_lock <= 1'b0;
			b0_entry_valid <= 1'b0;
			b0_branch_valid <= 1'b0;
			b0_swi_valid <= 1'b0;
			b0_swi_number <= 11'h0;
			b0_intr_valid <= 1'b0;
			b0_commit_tag <= {6{1'b0}};
			b0_addr <= {32{1'b0}};
			b0_idts_valid <= 1'b0;
			b0_idts_addr <= 32'h0;
		end
		else if(iFREE_RESTART)begin
			b0_lock <= 1'b0;
			b0_entry_valid <= 1'b0;
			b0_branch_valid <= 1'b0;
			b0_swi_valid <= 1'b0;
			b0_swi_number <= 11'h0;
			b0_intr_valid <= 1'b0;
			b0_commit_tag <= {6{1'b0}};
			b0_addr <= {32{1'b0}};
			b0_idts_valid <= 1'b0;
			b0_idts_addr <= 32'h0;
		end
		else begin
			b0_entry_valid <= (b0_lock)? 1'b0 : iPREVIOUS_EX_BRANCH_VALID;
			b0_branch_valid <= (b0_lock)? 1'b0 : iPREVIOUS_EX_BRANCH_VALID && func_ex_branch_check(iPREVIOUS_EX_BRANCH_CC, iPREVIOUS_EX_BRANCH_FLAG);
			b0_swi_valid <= (iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_SWI)? iPREVIOUS_EX_BRANCH_VALID : 1'b0;
			b0_swi_number <= iPREVIOUS_EX_BRANCH_SOURCE[10:0];
			b0_intr_valid <= (iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_INTB)? iPREVIOUS_EX_BRANCH_VALID : 1'b0;
			b0_commit_tag <= iPREVIOUS_EX_BRANCH_COMMIT_TAG;
			b0_addr <= (iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_INTB)? iPREVIOUS_EX_BRANCH_SOURCE : ((iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_BUR)? iPREVIOUS_EX_BRANCH_SOURCE + iPREVIOUS_EX_BRANCH_PC : ((iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_BR)? /*(~iPREVIOUS_EX_BRANCH_SOURCE + 32'b1)*/iPREVIOUS_EX_BRANCH_SOURCE + iPREVIOUS_EX_BRANCH_PC : iPREVIOUS_EX_BRANCH_SOURCE));
			b0_idts_valid <= (iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_IDTS)? iPREVIOUS_EX_BRANCH_VALID : 1'b0;
			b0_lock <= (b0_lock)? 1'b1 :  iPREVIOUS_EX_BRANCH_VALID & (func_ex_branch_check(iPREVIOUS_EX_BRANCH_CC, iPREVIOUS_EX_BRANCH_FLAG) || iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_SWI || iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_INTB || iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_IDTS);
			b0_idts_addr <= iPREVIOUS_EX_BRANCH_PC + 32'h4;
		end
	end
	
	function func_ex_branch_check;
		input wire [3:0]	func_ex_branch_check_cc;
		input wire [4:0]	func_ex_branch_check_flag;
		begin
			case(func_ex_branch_check_cc)
				`CC_AL : func_ex_branch_check	=	1'b1;
				`CC_EQ : 
					begin
						if(func_ex_branch_check_flag[`FLAGS_ZF])begin
							func_ex_branch_check	=	1'b1;
						end
						else begin
							func_ex_branch_check	=	1'b0;
						end
					end
				`CC_NEQ : 
					begin
						if(!func_ex_branch_check_flag[`FLAGS_ZF])begin
							func_ex_branch_check	=	1'b1;
						end
						else begin
							func_ex_branch_check	=	1'b0;
						end
					end
				`CC_MI : 
					begin
						func_ex_branch_check	=	func_ex_branch_check_flag[`FLAGS_SF];
					end
				`CC_PL : 
					begin
						func_ex_branch_check	=	!func_ex_branch_check_flag[`FLAGS_SF];
					end
				`CC_EN : 
					begin
						if(!func_ex_branch_check_flag[`FLAGS_PF])begin
							func_ex_branch_check	=	1'b1;
						end
						else begin
							func_ex_branch_check	=	1'b0;
						end
					end
				`CC_ON : 
					begin
						if(func_ex_branch_check_flag[`FLAGS_PF])begin
							func_ex_branch_check	=	1'b1;
						end
						else begin
							func_ex_branch_check	=	1'b0;
						end
					end
				`CC_OVF : 
					begin
						if(func_ex_branch_check_flag[`FLAGS_OF])begin
							func_ex_branch_check	=	1'b1;
						end
						else begin
							func_ex_branch_check	=	1'b0;
						end
					end
				`CC_UEO : 
					begin
						func_ex_branch_check	=	func_ex_branch_check_flag[`FLAGS_CF];
					end
				`CC_UU : 
					begin
						func_ex_branch_check	=	!func_ex_branch_check_flag[`FLAGS_CF];
					end
				`CC_UO : 
					begin
						func_ex_branch_check	=	func_ex_branch_check_flag[`FLAGS_CF] && !func_ex_branch_check_flag[`FLAGS_ZF];
					end
				`CC_UEU : 
					begin
						func_ex_branch_check	=	!func_ex_branch_check_flag[`FLAGS_CF] || func_ex_branch_check_flag[`FLAGS_ZF];
					end
				`CC_SEO : 
					begin
						func_ex_branch_check	=	(func_ex_branch_check_flag[`FLAGS_SF] && func_ex_branch_check_flag[`FLAGS_OF]) || (!func_ex_branch_check_flag[`FLAGS_SF] && !func_ex_branch_check_flag[`FLAGS_OF]);
					end
				`CC_SU : 
					begin
						func_ex_branch_check	=	(func_ex_branch_check_flag[`FLAGS_SF] && !func_ex_branch_check_flag[`FLAGS_OF]) || (!func_ex_branch_check_flag[`FLAGS_SF] && func_ex_branch_check_flag[`FLAGS_OF]);
					end
				`CC_SO : 
					begin
						func_ex_branch_check	=	!((func_ex_branch_check_flag[`FLAGS_SF] ^ func_ex_branch_check_flag[`FLAGS_OF]) || func_ex_branch_check_flag[`FLAGS_ZF]);//!func_ex_branch_check_flag[`FLAGS_ZF] || (func_ex_branch_check_flag[`FLAGS_SF] == func_ex_branch_check_flag[`FLAGS_OF]);
					end
				`CC_SEU : 
					begin
						func_ex_branch_check	=	(func_ex_branch_check_flag[`FLAGS_SF] ^ func_ex_branch_check_flag[`FLAGS_OF]) || func_ex_branch_check_flag[`FLAGS_ZF];//func_ex_branch_check_flag[`FLAGS_ZF] || (func_ex_branch_check_flag[`FLAGS_SF] != func_ex_branch_check_flag[`FLAGS_OF]);
					end
				default : func_ex_branch_check	=	1'b1;
			endcase
		end
	endfunction
		
	//Output Assign
	assign oPREVIOUS_EX_BRANCH_LOCK		=	b0_lock;	
	
	assign oJUMP_ACTIVE					=	b0_branch_valid && !b0_idts_valid && !b0_intr_valid && !b0_swi_valid;
	assign oJUMP_ADDR						=	b0_addr;
	
	assign oINTR_ACTIVE					=	b0_intr_valid;
	assign oINTR_ADDR						=	b0_addr;
	
	assign oIDTS_ACTIVE					=	b0_idts_valid;
	assign oIDTS_R_ADDR					=	b0_idts_addr;
	assign oIDTR_COMMIT_TAG				=	b0_commit_tag;
	
	assign oSWI_ACTIVE						=	b0_swi_valid;
	assign oSWI_NUMBER						=	b0_swi_number;
	
	assign oSCHE1_EX_BRANCH_VALID			=	b0_entry_valid;
	assign oSCHE1_EX_BRANCH_COMMIT_TAG		=	b0_commit_tag;
	
	assign oSCHE2_EX_BRANCH_VALID			=	b0_entry_valid;
	assign oSCHE2_EX_BRANCH_COMMIT_TAG		=	b0_commit_tag;
		
endmodule


`default_nettype wire
	
	
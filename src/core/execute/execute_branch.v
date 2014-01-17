/****************************************
Branch
for MIST32 Processor

Takahiro Ito @cpu_labs
****************************************/
`include "core.h"
`default_nettype none

module execute_branch(
		input wire [31:0] iDATA_0,
		input wire [31:0] iDATA_1,		
		input wire [31:0] iPC,
		input wire [4:0] iFLAG,
		input wire [3:0] iCC,
		input wire [4:0] iCMD,
		output wire [31:0] oBRANCH_ADDR,
		output wire oJUMP_VALID,
		output wire oNOT_JUMP_VALID,
		output wire oIB_VALID,
		output wire oIDTS_VALID,
		output wire oHALT_VALID
	);
	
	
	assign oBRANCH_ADDR = func_branch_addr(
		iCMD,
		iPC,
		iDATA_1
	);


	function [31:0] func_branch_addr;
		input [4:0] func_cmd;
		input [31:0] func_pc;
		input [31:0] func_source1;
		begin
			case(func_cmd)
				`EXE_BRANCH_BUR:
					begin
						func_branch_addr = func_source1 + func_pc;
					end
				`EXE_BRANCH_BR:
					begin
						func_branch_addr = func_source1 + func_pc;
					end
				`EXE_BRANCH_B:
					begin
						func_branch_addr = func_source1;
					end
				`EXE_BRANCH_INTB:
					begin
						func_branch_addr = 32'h0;
					end
				`EXE_BRANCH_IDTS:
					begin
						func_branch_addr = func_pc + 32'h0000004;
					end
				default:
					begin
						func_branch_addr = 32'h0;
					end
			endcase
		end
	endfunction
	
	
	assign oJUMP_VALID = (iCMD != `EXE_BRANCH_INTB && iCMD != `EXE_BRANCH_IDTS)? func_ex_branch_check(iCC, iFLAG) : 1'b0;
	assign oNOT_JUMP_VALID = (iCMD != `EXE_BRANCH_INTB && iCMD != `EXE_BRANCH_IDTS)? !func_ex_branch_check(iCC, iFLAG) : 1'b0;
	assign oIB_VALID = (iCMD == `EXE_BRANCH_INTB)? 1'b1 : 1'b0;
	assign oIDTS_VALID = (iCMD == `EXE_BRANCH_IDTS)? 1'b1 : 1'b0;
	assign oHALT_VALID = (iCMD == `EXE_BRANCH_HALT)? 1'b1 : 1'b0;
	
	function func_ex_branch_check;
		input [3:0] func_ex_branch_check_cc;
		input [4:0] func_ex_branch_check_flag;
		begin
			case(func_ex_branch_check_cc)
				`CC_AL : func_ex_branch_check = 1'b1;
				`CC_EQ : 
					begin
						if(func_ex_branch_check_flag[`FLAGS_ZF])begin
							func_ex_branch_check = 1'b1;
						end
						else begin
							func_ex_branch_check = 1'b0;
						end
					end
				`CC_NEQ : 
					begin
						if(!func_ex_branch_check_flag[`FLAGS_ZF])begin
							func_ex_branch_check = 1'b1;
						end
						else begin
							func_ex_branch_check = 1'b0;
						end
					end
				`CC_MI : 
					begin
						func_ex_branch_check = func_ex_branch_check_flag[`FLAGS_SF];
					end
				`CC_PL : 
					begin
						func_ex_branch_check = !func_ex_branch_check_flag[`FLAGS_SF];
					end
				`CC_EN : 
					begin
						if(!func_ex_branch_check_flag[`FLAGS_PF])begin
							func_ex_branch_check = 1'b1;
						end
						else begin
							func_ex_branch_check = 1'b0;
						end
					end
				`CC_ON : 
					begin
						if(func_ex_branch_check_flag[`FLAGS_PF])begin
							func_ex_branch_check = 1'b1;
						end
						else begin
							func_ex_branch_check = 1'b0;
						end
					end
				`CC_OVF : 
					begin
						if(func_ex_branch_check_flag[`FLAGS_OF])begin
							func_ex_branch_check = 1'b1;
						end
						else begin
							func_ex_branch_check = 1'b0;
						end
					end
				`CC_UEO : 
					begin
						func_ex_branch_check = func_ex_branch_check_flag[`FLAGS_CF];
					end
				`CC_UU : 
					begin
						func_ex_branch_check = !func_ex_branch_check_flag[`FLAGS_CF];
					end
				`CC_UO : 
					begin
						func_ex_branch_check = func_ex_branch_check_flag[`FLAGS_CF] && !func_ex_branch_check_flag[`FLAGS_ZF];
					end
				`CC_UEU : 
					begin
						func_ex_branch_check = !func_ex_branch_check_flag[`FLAGS_CF] || func_ex_branch_check_flag[`FLAGS_ZF];
					end
				`CC_SEO : 
					begin
						func_ex_branch_check = (func_ex_branch_check_flag[`FLAGS_SF] && func_ex_branch_check_flag[`FLAGS_OF]) || (!func_ex_branch_check_flag[`FLAGS_SF] && !func_ex_branch_check_flag[`FLAGS_OF]);
					end
				`CC_SU : 
					begin
						func_ex_branch_check = (func_ex_branch_check_flag[`FLAGS_SF] && !func_ex_branch_check_flag[`FLAGS_OF]) || (!func_ex_branch_check_flag[`FLAGS_SF] && func_ex_branch_check_flag[`FLAGS_OF]);
					end
				`CC_SO : 
					begin
						func_ex_branch_check = !((func_ex_branch_check_flag[`FLAGS_SF] ^ func_ex_branch_check_flag[`FLAGS_OF]) || func_ex_branch_check_flag[`FLAGS_ZF]);
					end
				`CC_SEU : 
					begin
						func_ex_branch_check = (func_ex_branch_check_flag[`FLAGS_SF] ^ func_ex_branch_check_flag[`FLAGS_OF]) || func_ex_branch_check_flag[`FLAGS_ZF];
					end
				default : func_ex_branch_check = 1'b1;
			endcase
		end
	endfunction
	
endmodule

`default_nettype wire
	

	
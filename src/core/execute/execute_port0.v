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

	wire iRESET_SYNC = 1'b0;
	
	wire [31:0] branch_addr;
	wire jump_valid;
	wire not_jump_valid;
	wire ib_valid;
	wire idts_valid;
	wire halt_valid;

	execute_branch EXECUTE_BRANCH(
		.iDATA_0(32'h0),	//non use
		.iDATA_1(iPREVIOUS_EX_BRANCH_SOURCE),		
		.iPC(iPREVIOUS_EX_BRANCH_PC),
		.iFLAG(iPREVIOUS_EX_BRANCH_FLAG),
		.iCC(iPREVIOUS_EX_BRANCH_CC),
		.iCMD(iPREVIOUS_EX_BRANCH_CMD),
		.oBRANCH_ADDR(branch_addr),
		.oJUMP_VALID(jump_valid),
		.oNOT_JUMP_VALID(not_jump_valid),
		.oIB_VALID(ib_valid),
		.oIDTS_VALID(idts_valid),
		.oHALT_VALID(halt_valid)
	);


	reg b_busy;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_busy <= 1'b0;
		end
		else if(iRESET_SYNC || iFREE_RESTART)begin
			b_busy <= 1'b0;
		end
		else begin
			if(!b_busy)begin
				b_busy <= iPREVIOUS_EX_BRANCH_VALID && (jump_valid || ib_valid || idts_valid || halt_valid);
			end
		end
	end


	reg b_stage_valid;
	reg [31:0] b_branch_addr;
	reg b_jump_valid;
	reg b_not_jump_valid;
	reg b_ib_valid;
	reg b_idts_valid;
	reg b_halt_valid;
	reg [5:0] b_commit_tag;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_stage_valid <= 1'b0;
			b_branch_addr <= 32'h0;
			b_jump_valid <= 1'b0;
			b_not_jump_valid <= 1'b0;
			b_ib_valid <= 1'b0;
			b_idts_valid <= 1'b0;
			b_halt_valid <= 1'b0;
			b_commit_tag <= 6'h0;
		end
		else if(iRESET_SYNC || iFREE_RESTART)begin
			b_stage_valid <= 1'b0;
			b_branch_addr <= 32'h0;
			b_jump_valid <= 1'b0;
			b_not_jump_valid <= 1'b0;
			b_ib_valid <= 1'b0;
			b_idts_valid <= 1'b0;
			b_halt_valid <= 1'b0;
			b_commit_tag <= 6'h0;
		end
		else begin
			b_stage_valid <= !b_lock && iPREVIOUS_EX_BRANCH_VALID;
			b_branch_addr <= branch_addr;
			b_jump_valid <= jump_valid;
			b_not_jump_valid <= not_jump_valid;
			b_ib_valid <= ib_valid;
			b_idts_valid <= idts_valid;
			b_halt_valid <= halt_valid;
			b_commit_tag <= iPREVIOUS_EX_BRANCH_COMMIT_TAG;
		end
	end

		//Output Assign
	assign oPREVIOUS_EX_BRANCH_LOCK = b_lock;	
	
	assign oJUMP_ACTIVE = b_stage_valid && !b_idts_valid && !b_ib_valid && !b_halt_valid;
	assign oJUMP_ADDR = b_branch_addr;
	
	assign oINTR_ACTIVE = b_ib_valid;
	assign oINTR_ADDR = b_branch_addr;
	
	assign oIDTS_ACTIVE = b_idts_valid;
	assign oIDTS_R_ADDR = b_branch_addr;
	assign oIDTR_COMMIT_TAG = b_commit_tag;
	
	assign oSWI_ACTIVE = b_halt_valid;
	assign oSWI_NUMBER = iPREVIOUS_EX_BRANCH_SOURCE[9:0];
	
	assign oSCHE1_EX_BRANCH_VALID = b_stage_valid;
	assign oSCHE1_EX_BRANCH_COMMIT_TAG = b_commit_tag;
	
	assign oSCHE2_EX_BRANCH_VALID = b_stage_valid;
	assign oSCHE2_EX_BRANCH_COMMIT_TAG = b_commit_tag;

				
	/****************************************
	Register and Wire
	****************************************/
	//State Register
	/*
	reg b0_lock;
	reg b0_entry_valid;
	reg b0_branch_valid;
	reg b0_swi_valid;
	reg [10:0] b0_swi_number;
	reg b0_intr_valid;
	reg [5:0] b0_commit_tag;
	reg [31:0] b0_addr;
	reg b0_idts_valid;
	reg [31:0] b0_idts_addr;
		
	
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
			b0_branch_valid <= (b0_lock)? 1'b0 : jump_valid;//iPREVIOUS_EX_BRANCH_VALID && func_ex_branch_check(iPREVIOUS_EX_BRANCH_CC, iPREVIOUS_EX_BRANCH_FLAG);
			b0_swi_valid <= (iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_SWI)? iPREVIOUS_EX_BRANCH_VALID : 1'b0;
			b0_swi_number <= iPREVIOUS_EX_BRANCH_SOURCE[10:0];
			b0_intr_valid <= (iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_INTB)? iPREVIOUS_EX_BRANCH_VALID : 1'b0;
			b0_commit_tag <= iPREVIOUS_EX_BRANCH_COMMIT_TAG;
			b0_addr <= branch_addr;//(iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_INTB)? iPREVIOUS_EX_BRANCH_SOURCE : ((iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_BUR)? iPREVIOUS_EX_BRANCH_SOURCE + iPREVIOUS_EX_BRANCH_PC : ((iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_BR)? iPREVIOUS_EX_BRANCH_SOURCE + iPREVIOUS_EX_BRANCH_PC : iPREVIOUS_EX_BRANCH_SOURCE));
			b0_idts_valid <= (iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_IDTS)? iPREVIOUS_EX_BRANCH_VALID : 1'b0;
			b0_lock <= (b0_lock)? 1'b1 :  iPREVIOUS_EX_BRANCH_VALID & (func_ex_branch_check(iPREVIOUS_EX_BRANCH_CC, iPREVIOUS_EX_BRANCH_FLAG) || iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_SWI || iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_INTB || iPREVIOUS_EX_BRANCH_CMD == `EXE_BRANCH_IDTS);
			b0_idts_addr <= iPREVIOUS_EX_BRANCH_PC + 32'h4;
		end
	end
	
	
		
	//Output Assign
	assign oPREVIOUS_EX_BRANCH_LOCK = b0_lock;	
	
	assign oJUMP_ACTIVE = b0_branch_valid && !b0_idts_valid && !b0_intr_valid && !b0_swi_valid;
	assign oJUMP_ADDR = b0_addr;
	
	assign oINTR_ACTIVE = b0_intr_valid;
	assign oINTR_ADDR = b0_addr;
	
	assign oIDTS_ACTIVE = b0_idts_valid;
	assign oIDTS_R_ADDR = b0_addr;
	assign oIDTR_COMMIT_TAG = b0_commit_tag;
	
	assign oSWI_ACTIVE = b0_swi_valid;
	assign oSWI_NUMBER = b0_swi_number;
	
	assign oSCHE1_EX_BRANCH_VALID = b0_entry_valid;
	assign oSCHE1_EX_BRANCH_COMMIT_TAG = b0_commit_tag;
	
	assign oSCHE2_EX_BRANCH_VALID = b0_entry_valid;
	assign oSCHE2_EX_BRANCH_COMMIT_TAG = b0_commit_tag;
	*/
		
endmodule


`default_nettype wire
	
	
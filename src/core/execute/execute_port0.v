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
			b_stage_valid <= !b_busy && iPREVIOUS_EX_BRANCH_VALID;
			b_branch_addr <= branch_addr;
			b_jump_valid <= jump_valid;
			b_not_jump_valid <= not_jump_valid;
			b_ib_valid <= ib_valid;
			b_idts_valid <= idts_valid;
			b_halt_valid <= halt_valid;
			b_commit_tag <= iPREVIOUS_EX_BRANCH_COMMIT_TAG;
		end
	end

	always@(posedge iCLOCK)begin
		if(inRESET)begin
			if(iPREVIOUS_EX_BRANCH_VALID)begin
				$display("Execute Branch");
			end
		end
	end




	//Output Assign
	assign oPREVIOUS_EX_BRANCH_LOCK = b_busy;	
	
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

endmodule


`default_nettype wire
	
	
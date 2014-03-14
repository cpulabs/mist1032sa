/*****************************************************************************************************
Files that are included in this project is deliverable by all Open Design Computer Project.
http://open-arch.org

All files included in this project have been allocated in the BSD licence.	
Open Design Computer Project @Takahiro Ito
*****************************************************************************************************/

`default_nettype none
`include "global.h"
`include "irq.h"

module matching(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Free
		input wire iFREE_DEFAULT,
		input wire iFREE_RESTART,
		//Commit Offset
		input wire [2:0] iCOMMIT_OFFSET,
		//Fetch Stop
		output wire oLOOPBUFFER_LIMIT,
		//Other Infomation
		input wire iOTHER_INFO_RENAME_0_VALID,		
		input wire iOTHER_INFO_RENAME_1_VALID,		
		input wire iOTHER_INFO_SCHEDULER1_0_VALID,	
		input wire iOTHER_INFO_SCHEDULER1_1_VALID,		
		input wire [5:0] iOTHER_INFO_SCHEDULER1_REGIST_POINTER,
		input wire [5:0] iOTHER_INFO_SCHEDULER1_COMMIT_POINTER,	
		//Previous - 0		
		input wire iPREVIOUS_0_VALID,
		input wire [5:0] iPREVIOUS_0_MMU_FLAGS,		//NEW 20120711
		input wire iPREVIOUS_0_SOURCE0_ACTIVE,		
		input wire iPREVIOUS_0_SOURCE1_ACTIVE,		
		input wire iPREVIOUS_0_SOURCE0_SYSREG,		
		input wire iPREVIOUS_0_SOURCE1_SYSREG,		
		input wire iPREVIOUS_0_SOURCE0_SYSREG_RENAME,	
		input wire iPREVIOUS_0_SOURCE1_SYSREG_RENAME,	
		input wire iPREVIOUS_0_ADV_ACTIVE,		//++		
		input wire iPREVIOUS_0_DESTINATION_SYSREG,		
		input wire iPREVIOUS_0_DEST_RENAME,		
		input wire iPREVIOUS_0_WRITEBACK,	
		input wire iPREVIOUS_0_FLAGS_WRITEBACK,
		input wire iPREVIOUS_0_FRONT_COMMIT_WAIT,				
		input wire [4:0] iPREVIOUS_0_CMD,
		input wire [3:0] iPREVIOUS_0_CC_AFE,
		input wire [4:0] iPREVIOUS_0_SOURCE0,
		input wire [31:0] iPREVIOUS_0_SOURCE1,
		input wire [5:0] iPREVIOUS_0_ADV_DATA,		//++	
		input wire iPREVIOUS_0_SOURCE0_FLAGS,
		input wire iPREVIOUS_0_SOURCE1_IMM,
		input wire [4:0] iPREVIOUS_0_DESTINATION,
		input wire iPREVIOUS_0_EX_SYS_ADDER,	
		input wire iPREVIOUS_0_EX_SYS_LDST,
		input wire iPREVIOUS_0_EX_LOGIC,
		input wire iPREVIOUS_0_EX_SHIFT,
		input wire iPREVIOUS_0_EX_ADDER,
		input wire iPREVIOUS_0_EX_MUL,	
		input wire iPREVIOUS_0_EX_SDIV,
		input wire iPREVIOUS_0_EX_UDIV,			
		input wire iPREVIOUS_0_EX_LDST,
		input wire iPREVIOUS_0_EX_BRANCH,
		//Previous - 1					
		input wire iPREVIOUS_1_VALID,
		input wire [5:0] iPREVIOUS_1_MMU_FLAGS,		//NEW 20120711
		input wire iPREVIOUS_1_SOURCE0_ACTIVE,		
		input wire iPREVIOUS_1_SOURCE1_ACTIVE,		
		input wire iPREVIOUS_1_SOURCE0_SYSREG,		
		input wire iPREVIOUS_1_SOURCE1_SYSREG,		
		input wire iPREVIOUS_1_SOURCE0_SYSREG_RENAME,	
		input wire iPREVIOUS_1_SOURCE1_SYSREG_RENAME,	
		input wire iPREVIOUS_1_ADV_ACTIVE,		//++				
		input wire iPREVIOUS_1_DESTINATION_SYSREG,	
		input wire iPREVIOUS_1_DEST_RENAME,	
		input wire iPREVIOUS_1_WRITEBACK,
		input wire iPREVIOUS_1_FLAGS_WRITEBACK,
		input wire iPREVIOUS_1_FRONT_COMMIT_WAIT,					
		input wire [4:0] iPREVIOUS_1_CMD,
		input wire [3:0] iPREVIOUS_1_CC_AFE,
		input wire [4:0] iPREVIOUS_1_SOURCE0,
		input wire [31:0] iPREVIOUS_1_SOURCE1,
		input wire [5:0] iPREVIOUS_1_ADV_DATA,		//++
		input wire iPREVIOUS_1_SOURCE0_FLAGS,
		input wire iPREVIOUS_1_SOURCE1_IMM,
		input wire [4:0] iPREVIOUS_1_DESTINATION,
		input wire iPREVIOUS_1_EX_SYS_ADDER,		
		input wire iPREVIOUS_1_EX_SYS_LDST,	
		input wire iPREVIOUS_1_EX_LOGIC,
		input wire iPREVIOUS_1_EX_SHIFT,
		input wire iPREVIOUS_1_EX_ADDER,
		input wire iPREVIOUS_1_EX_MUL,
		input wire iPREVIOUS_1_EX_SDIV,
		input wire iPREVIOUS_1_EX_UDIV,
		input wire iPREVIOUS_1_EX_LDST,
		input wire iPREVIOUS_1_EX_BRANCH,
		input wire [31:0] iPREVIOUS_PC,
		output wire oPREVIOUS_LOCK,
		//Next-0		
		output wire oNEXT_0_VALID,
		output wire oNEXT_0_SOURCE0_ACTIVE,		
		output wire oNEXT_0_SOURCE1_ACTIVE,		
		output wire oNEXT_0_SOURCE0_SYSREG,		
		output wire oNEXT_0_SOURCE1_SYSREG,			
		output wire oNEXT_0_SOURCE0_SYSREG_RENAME,		
		output wire oNEXT_0_SOURCE1_SYSREG_RENAME,	
		output wire oNEXT_0_ADV_ACTIVE,
		output wire oNEXT_0_DESTINATION_SYSREG,	
		output wire oNEXT_0_DEST_RENAME,	
		output wire oNEXT_0_WRITEBACK,
		output wire oNEXT_0_FLAGS_WRITEBACK,	
		output wire [4:0] oNEXT_0_CMD,
		output wire [3:0] oNEXT_0_CC_AFE,
		output wire [4:0] oNEXT_0_SOURCE0,
		output wire [31:0] oNEXT_0_SOURCE1,
		output wire [5:0] oNEXT_0_ADV_DATA,
		output wire oNEXT_0_SOURCE0_FLAGS,
		output wire oNEXT_0_SOURCE1_IMM,
		output wire [4:0] oNEXT_0_DESTINATION,
		output wire oNEXT_0_EX_SYS_ADDER,	
		output wire oNEXT_0_EX_SYS_LDST,	
		output wire oNEXT_0_EX_LOGIC,
		output wire oNEXT_0_EX_SHIFT,
		output wire oNEXT_0_EX_ADDER,
		output wire oNEXT_0_EX_MUL,
		output wire oNEXT_0_EX_SDIV,
		output wire oNEXT_0_EX_UDIV,
		output wire oNEXT_0_EX_LDST,
		output wire oNEXT_0_EX_BRANCH,
		//Next-1				
		output wire oNEXT_1_VALID,
		output wire oNEXT_1_SOURCE0_ACTIVE,		
		output wire oNEXT_1_SOURCE1_ACTIVE,		
		output wire oNEXT_1_SOURCE0_SYSREG,		
		output wire oNEXT_1_SOURCE1_SYSREG,		
		output wire oNEXT_1_SOURCE0_SYSREG_RENAME,		
		output wire oNEXT_1_SOURCE1_SYSREG_RENAME,
		output wire oNEXT_1_ADV_ACTIVE,	
		output wire oNEXT_1_DESTINATION_SYSREG,	
		output wire oNEXT_1_DEST_RENAME,			
		output wire oNEXT_1_WRITEBACK,
		output wire oNEXT_1_FLAGS_WRITEBACK,	
		output wire [4:0] oNEXT_1_CMD,
		output wire [3:0] oNEXT_1_CC_AFE,
		output wire [4:0] oNEXT_1_SOURCE0,
		output wire [31:0] oNEXT_1_SOURCE1,
		output wire [5:0] oNEXT_1_ADV_DATA,
		output wire oNEXT_1_SOURCE0_FLAGS,
		output wire oNEXT_1_SOURCE1_IMM,
		output wire [4:0] oNEXT_1_DESTINATION,
		output wire oNEXT_1_EX_SYS_ADDER,	
		output wire oNEXT_1_EX_SYS_LDST,	
		output wire oNEXT_1_EX_LOGIC,
		output wire oNEXT_1_EX_SHIFT,
		output wire oNEXT_1_EX_ADDER,
		output wire oNEXT_1_EX_MUL,
		output wire oNEXT_1_EX_SDIV,
		output wire oNEXT_1_EX_UDIV,
		output wire oNEXT_1_EX_LDST,
		output wire oNEXT_1_EX_BRANCH,
		output wire [31:0] oNEXT_PC,
		input wire iNEXT_LOCK
	);

	
	localparam STT_LOOP_OUT = 2'b0;
	localparam STT_LOOP_COMMIT_WAIT = 2'h1;
	localparam STT_BUFFER_COMMIT_WAIT = 2'h2;
	
	
	/****************************************
	Wire
	****************************************/
	//Lock
	wire prev_lock;
	wire next_lock;	
	//Instruction Loop Buffer
	wire [(114*2)-1:0] wr_loop_buffer_data;	
	//Loop Buffer Output
	wire [3:0] loop_buffer_count;
	wire loop_buffer_wr_full;
	wire [114-1:0]	loop_buffer_rd_inst0;
	wire [114-1:0]	loop_buffer_rd_inst1;
	wire loop_buffer_rd_empty;
	//Loop Buffer Request
	reg b_fifo_req;
	//Instruction Buffer
	wire inst_0_valid;					
	wire inst_0_destination_sysreg;	
	wire inst_0_dest_rename;
	wire inst_0_writeback;	
	wire inst_0_flags_writeback;
	wire inst_0_commit_wait_inst;					
	wire [4:0] inst_0_cmd;
	wire [3:0] inst_0_cc_afe;
	wire [4:0] inst_0_source0;
	wire [31:0] inst_0_source1;
	wire inst_0_source0_flags;
	wire inst_0_source1_imm;
	wire inst_0_source0_active;	
	wire inst_0_source1_active;	
	wire inst_0_source0_sysreg;				
	wire inst_0_source1_sysreg;	
	wire inst_0_source0_sysreg_rename;
	wire inst_0_source1_sysreg_rename;
	wire inst_0_adv_active;
	wire [5:0] inst_0_adv_data;
	wire [4:0] inst_0_destination;	
	wire inst_0_ex_sys_adder;
	wire inst_0_ex_sys_ldst;
	wire inst_0_ex_logic;
	wire inst_0_ex_shift;
	wire inst_0_ex_adder;
	wire inst_0_ex_mul;
	wire inst_0_ex_sdiv;
	wire inst_0_ex_udiv;
	wire inst_0_ex_ldst;
	wire inst_0_ex_branch;
	wire [31:0] inst_0_pc;
	wire inst_1_valid;					
	wire inst_1_destination_sysreg;	
	wire inst_1_dest_rename;
	wire inst_1_writeback;	
	wire inst_1_flags_writeback;
	wire inst_1_commit_wait_inst;					
	wire [4:0] inst_1_cmd;
	wire [3:0] inst_1_cc_afe;
	wire [4:0] inst_1_source0;
	wire [31:0] inst_1_source1;
	wire inst_1_source0_flags;
	wire inst_1_source1_imm;
	wire inst_1_source0_active;	
	wire inst_1_source1_active;	
	wire inst_1_source0_sysreg;				
	wire inst_1_source1_sysreg;	
	wire inst_1_source0_sysreg_rename;
	wire inst_1_source1_sysreg_rename;
	wire inst_1_adv_active;
	wire [5:0] inst_1_adv_data;
	wire [4:0] inst_1_destination;	
	wire inst_1_ex_sys_adder;
	wire inst_1_ex_sys_ldst;
	wire inst_1_ex_logic;
	wire inst_1_ex_shift;
	wire inst_1_ex_adder;
	wire inst_1_ex_mul;
	wire inst_1_ex_sdiv;
	wire inst_1_ex_udiv;
	wire inst_1_ex_ldst;
	wire inst_1_ex_branch;
	wire [31:0] inst_1_pc;
	//Controll Wire
	wire next_0_valid;
	wire next_1_valid;
	reg b_next_0_valid;
	reg b_next_1_valid;
	//Commit Check Counter
	wire full_commit;
	//State
	reg [2:0] b_state;

	
	/****************************************
	Lock Condition
	****************************************/	
	assign prev_lock = loop_buffer_wr_full;
	assign next_lock = loop_buffer_rd_empty || iNEXT_LOCK;
	
	/****************************************
	Instruction Loop Buffer
	****************************************/
	assign wr_loop_buffer_data = 
		{
			//Inst Pipeline 0
			iPREVIOUS_0_VALID,	
			iPREVIOUS_0_DESTINATION_SYSREG,	
			iPREVIOUS_0_DEST_RENAME,
			iPREVIOUS_0_WRITEBACK,	
			iPREVIOUS_0_FLAGS_WRITEBACK,
			iPREVIOUS_0_FRONT_COMMIT_WAIT,				
			iPREVIOUS_0_CMD,	
			iPREVIOUS_0_CC_AFE,
			iPREVIOUS_0_SOURCE0,
			iPREVIOUS_0_SOURCE1,
			iPREVIOUS_0_SOURCE0_FLAGS,
			iPREVIOUS_0_SOURCE1_IMM,
			iPREVIOUS_0_SOURCE0_ACTIVE,		
			iPREVIOUS_0_SOURCE1_ACTIVE,		
			iPREVIOUS_0_SOURCE0_SYSREG,		
			iPREVIOUS_0_SOURCE1_SYSREG,		
			iPREVIOUS_0_SOURCE0_SYSREG_RENAME,	
			iPREVIOUS_0_SOURCE1_SYSREG_RENAME,	
			iPREVIOUS_0_ADV_ACTIVE,
			iPREVIOUS_0_ADV_DATA,
			iPREVIOUS_0_DESTINATION,
			iPREVIOUS_0_EX_SYS_ADDER,	
			iPREVIOUS_0_EX_SYS_LDST,
			iPREVIOUS_0_EX_LOGIC,
			iPREVIOUS_0_EX_SHIFT,
			iPREVIOUS_0_EX_ADDER,
			iPREVIOUS_0_EX_MUL,	
			iPREVIOUS_0_EX_SDIV,
			iPREVIOUS_0_EX_UDIV,			
			iPREVIOUS_0_EX_LDST,
			iPREVIOUS_0_EX_BRANCH,
			iPREVIOUS_PC,
			//Inst Pipeline 1
			iPREVIOUS_1_VALID,	
			iPREVIOUS_1_DESTINATION_SYSREG,	
			iPREVIOUS_1_DEST_RENAME,
			iPREVIOUS_1_WRITEBACK,	
			iPREVIOUS_1_FLAGS_WRITEBACK,
			iPREVIOUS_1_FRONT_COMMIT_WAIT,				
			iPREVIOUS_1_CMD,	
			iPREVIOUS_1_CC_AFE,
			iPREVIOUS_1_SOURCE0,
			iPREVIOUS_1_SOURCE1,
			iPREVIOUS_1_SOURCE0_FLAGS,
			iPREVIOUS_1_SOURCE1_IMM,
			iPREVIOUS_1_SOURCE0_ACTIVE,		
			iPREVIOUS_1_SOURCE1_ACTIVE,		
			iPREVIOUS_1_SOURCE0_SYSREG,		
			iPREVIOUS_1_SOURCE1_SYSREG,		
			iPREVIOUS_1_SOURCE0_SYSREG_RENAME,	
			iPREVIOUS_1_SOURCE1_SYSREG_RENAME,	
			iPREVIOUS_1_ADV_ACTIVE,
			iPREVIOUS_1_ADV_DATA,
			iPREVIOUS_1_DESTINATION,
			iPREVIOUS_1_EX_SYS_ADDER,	
			iPREVIOUS_1_EX_SYS_LDST,
			iPREVIOUS_1_EX_LOGIC,
			iPREVIOUS_1_EX_SHIFT,
			iPREVIOUS_1_EX_ADDER,
			iPREVIOUS_1_EX_MUL,	
			iPREVIOUS_1_EX_SDIV,
			iPREVIOUS_1_EX_UDIV,			
			iPREVIOUS_1_EX_LDST,
			iPREVIOUS_1_EX_BRANCH,
			iPREVIOUS_PC + 32'h4
		};
	
	
	//parameter is N, DEPTH, DEPTH_N
	mist1032sa_sync_fifo #(114*2, 16, 4) INST_LOOP_BUFFER(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iFREE_RESTART || iFREE_DEFAULT),
		.oCOUNT(loop_buffer_count), 	
		//WR
		.iWR_EN(!prev_lock && (iPREVIOUS_0_VALID || iPREVIOUS_1_VALID)),
		.iWR_DATA(wr_loop_buffer_data),
		.oWR_FULL(loop_buffer_wr_full),
		//RD
		.iRD_EN(b_fifo_req),
		.oRD_DATA({loop_buffer_rd_inst0, loop_buffer_rd_inst1}),
		.oRD_EMPTY(loop_buffer_rd_empty)
	);
	
	always@* begin
		case(b_state)
			STT_LOOP_OUT:
				begin
					b_fifo_req = !next_lock && (inst_0_valid && !inst_0_commit_wait_inst && (inst_1_valid && !inst_1_commit_wait_inst || !inst_1_valid));
				end
			STT_LOOP_COMMIT_WAIT:
				begin
					b_fifo_req = !next_lock && inst_0_valid && full_commit && (!next_lock && inst_1_valid && full_commit && !inst_1_commit_wait_inst || !inst_1_valid);
				end
			STT_BUFFER_COMMIT_WAIT:
				begin
					b_fifo_req = !next_lock && inst_0_valid && full_commit;
				end
			default:
				begin
					b_fifo_req = 1'b0;
				end
		endcase
	end
	
	//Instruction Buffer	
	assign {
		inst_0_valid,					
		inst_0_destination_sysreg,	
		inst_0_dest_rename,
		inst_0_writeback,	
		inst_0_flags_writeback,
		inst_0_commit_wait_inst,					
		inst_0_cmd,
		inst_0_cc_afe,
		inst_0_source0,
		inst_0_source1,
		inst_0_source0_flags,
		inst_0_source1_imm,
		inst_0_source0_active,	
		inst_0_source1_active,	
		inst_0_source0_sysreg,				
		inst_0_source1_sysreg,	
		inst_0_source0_sysreg_rename,
		inst_0_source1_sysreg_rename,
		inst_0_adv_active,
		inst_0_adv_data,
		inst_0_destination,	
		inst_0_ex_sys_adder,
		inst_0_ex_sys_ldst,
		inst_0_ex_logic,
		inst_0_ex_shift,
		inst_0_ex_adder,
		inst_0_ex_mul,
		inst_0_ex_sdiv,
		inst_0_ex_udiv,
		inst_0_ex_ldst,
		inst_0_ex_branch,
		inst_0_pc} = loop_buffer_rd_inst0;
	
	assign {
		inst_1_valid,					
		inst_1_destination_sysreg,	
		inst_1_dest_rename,
		inst_1_writeback,	
		inst_1_flags_writeback,
		inst_1_commit_wait_inst,					
		inst_1_cmd,
		inst_1_cc_afe,
		inst_1_source0,
		inst_1_source1,
		inst_1_source0_flags,
		inst_1_source1_imm,
		inst_1_source0_active,	
		inst_1_source1_active,	
		inst_1_source0_sysreg,				
		inst_1_source1_sysreg,	
		inst_1_source0_sysreg_rename,
		inst_1_source1_sysreg_rename,
		inst_1_adv_active,
		inst_1_adv_data,
		inst_1_destination,	
		inst_1_ex_sys_adder,
		inst_1_ex_sys_ldst,
		inst_1_ex_logic,
		inst_1_ex_shift,
		inst_1_ex_adder,
		inst_1_ex_mul,
		inst_1_ex_sdiv,
		inst_1_ex_udiv,
		inst_1_ex_ldst,
		inst_1_ex_branch,
		inst_1_pc} = loop_buffer_rd_inst1;

	/****************************************
	Control & wire
	****************************************/	
	assign next_0_valid = b_next_0_valid;
	assign next_1_valid = b_next_1_valid;
	
	always@* begin
		if(!next_lock)begin
			case(b_state)
				STT_LOOP_OUT:
					begin
						b_next_0_valid = inst_0_valid && !inst_0_commit_wait_inst;
						b_next_1_valid = (inst_0_valid && !inst_0_commit_wait_inst && inst_1_valid && !inst_1_commit_wait_inst);
					end
				STT_LOOP_COMMIT_WAIT:
					begin
						b_next_0_valid = inst_0_valid && full_commit;
						b_next_1_valid = inst_1_valid && full_commit && !inst_1_commit_wait_inst;
					end
				STT_BUFFER_COMMIT_WAIT:
					begin
						b_next_0_valid = inst_0_valid && full_commit;
						b_next_1_valid = 1'b0;
					end
				default:
					begin
						b_next_0_valid = 1'b0;
						b_next_1_valid = 1'b0;
					end
			endcase
		end
		else begin
			b_next_0_valid = 1'b0;
			b_next_1_valid = 1'b0;
		end
	end
				
	/****************************************
	Commit Check Counter
	****************************************/
	reg [7:0] regist_counter;
	reg [7:0] commit_counter;
	assign full_commit = (regist_counter == commit_counter)? 1'b1 : 1'b0;
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			regist_counter <= 8'h0;
			commit_counter <= 8'h0;
		end
		else if(iFREE_RESTART || iFREE_DEFAULT)begin
			regist_counter <= 8'h0;
			commit_counter <= 8'h0;
		end
		else begin
			//Regist Counter
			if(!iNEXT_LOCK)begin
				if(next_0_valid && next_1_valid)begin
					regist_counter <= regist_counter + 8'h2;
				end
				else if(next_0_valid)begin
					regist_counter <= regist_counter + 8'h1;
				end
			end
			//Commit Counter
			commit_counter <= commit_counter + iCOMMIT_OFFSET;
		end
	end
	
	
	/****************************************
	State
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state <= STT_LOOP_OUT;
		end
		else if(iFREE_DEFAULT)begin
			b_state <= STT_LOOP_OUT;
		end
		else begin
			case(b_state)
				STT_LOOP_OUT:
					begin
						if(inst_0_valid && inst_0_commit_wait_inst)begin
							b_state <= STT_LOOP_COMMIT_WAIT;
						end
						else if(inst_1_valid && inst_1_commit_wait_inst)begin
							b_state <= STT_BUFFER_COMMIT_WAIT;
						end
					end
				STT_LOOP_COMMIT_WAIT:
					begin
						if(!next_lock && full_commit)begin
							if(inst_1_valid && inst_1_commit_wait_inst)begin
								b_state <= STT_BUFFER_COMMIT_WAIT;
							end
							else begin
								b_state <= STT_LOOP_OUT;
							end
						end
					end
				STT_BUFFER_COMMIT_WAIT:
					begin
						if(!next_lock && full_commit)begin
							b_state <= STT_LOOP_OUT;
						end
					end
			endcase
		end
	end
	
	
	/************************************************************
	MMU Flag Exception Check
	************************************************************/
	//[6:0]	:	IRQ Number
	//[7]	:	Interrupt Request Valid
	function [7:0] func_mmu_flag_exception_check;
		input [13:0] func_flags;
		input func_rw;			//0:Read | 1:Write
		input func_type;			//0:Data | 1:Inst
		input func_auth_mode;		//0:Kernel | 1:User
		begin
			if(func_flags[0])begin
				if(!(func_type && func_flags[3]))begin
					case(func_flags[5:4])
						2'h0://K:RW U:**
							begin
								//kernel
								if(func_auth_mode)begin
									func_mmu_flag_exception_check = 8'h0;
								end
								//User
								else begin
									//Auth Error
									func_mmu_flag_exception_check = {1'b1, `INT_NUM_PRIVILEGE_ERRPR};
								end
							end
						2'h1://K:R* U:R*
							begin
								//kernel
								if(func_auth_mode)begin
									if(!func_rw)begin
										func_mmu_flag_exception_check = 8'h0;
									end
									else begin
										//Auth Error
										func_mmu_flag_exception_check = {1'b1, `INT_NUM_PRIVILEGE_ERRPR};
									end
								end
								//User
								else begin
									if(!func_rw)begin
										func_mmu_flag_exception_check = 8'h0;
									end
									else begin
										//Auth Error
										func_mmu_flag_exception_check = {1'b1, `INT_NUM_PRIVILEGE_ERRPR};
									end
								end
							end
						2'h2://K:RW U:R*
							begin
								//kernel
								if(func_auth_mode)begin
									func_mmu_flag_exception_check = 8'h0;
								end
								//User
								else begin
									if(!func_rw)begin
										func_mmu_flag_exception_check = 8'h0;
									end
									else begin
										//Auth Error
										func_mmu_flag_exception_check = {1'b1, `INT_NUM_PRIVILEGE_ERRPR};
									end
								end
							end
						2'h3://K:RW U:RW
							begin
								func_mmu_flag_exception_check = 8'h0;
							end
					endcase
				end
				//Invalid Instruction Page Error
				else begin
					func_mmu_flag_exception_check = {1'b1, `INT_NUM_INSTRUCTION_INVALID};
				end
			end
			//Page Fault
			else begin
				func_mmu_flag_exception_check = {1'b1, `INT_NUM_PAGEFAULT};
			end
		end
	endfunction



	/****************************************
	This -> Next
	****************************************/	
	assign oNEXT_0_VALID = next_0_valid;
	assign {
		oNEXT_0_DESTINATION_SYSREG,
		oNEXT_0_DEST_RENAME,		
		oNEXT_0_WRITEBACK,	
		oNEXT_0_FLAGS_WRITEBACK,	
		oNEXT_0_CMD,
		oNEXT_0_CC_AFE,			
		oNEXT_0_SOURCE0,			
		oNEXT_0_SOURCE1,		
		oNEXT_0_SOURCE0_FLAGS,	
		oNEXT_0_SOURCE1_IMM,	
		oNEXT_0_SOURCE0_ACTIVE,		
		oNEXT_0_SOURCE1_ACTIVE,	
		oNEXT_0_SOURCE0_SYSREG,	
		oNEXT_0_SOURCE1_SYSREG,	
		oNEXT_0_SOURCE0_SYSREG_RENAME,
		oNEXT_0_SOURCE1_SYSREG_RENAME,
		oNEXT_0_ADV_ACTIVE,
		oNEXT_0_ADV_DATA,	
		oNEXT_0_DESTINATION,	
		oNEXT_0_EX_SYS_ADDER,	
		oNEXT_0_EX_SYS_LDST,	
		oNEXT_0_EX_LOGIC,	
		oNEXT_0_EX_SHIFT,		
		oNEXT_0_EX_ADDER,		
		oNEXT_0_EX_MUL,		
		oNEXT_0_EX_SDIV,			
		oNEXT_0_EX_UDIV,		
		oNEXT_0_EX_LDST,	
		oNEXT_0_EX_BRANCH} = (!(b_state == STT_BUFFER_COMMIT_WAIT))? 
																		{inst_0_destination_sysreg,	
																		inst_0_dest_rename,
																		inst_0_writeback,	
																		inst_0_flags_writeback,
																		//inst_0_commit_wait_inst,					
																		inst_0_cmd,
																		inst_0_cc_afe,
																		inst_0_source0,
																		inst_0_source1,
																		inst_0_source0_flags,
																		inst_0_source1_imm,
																		inst_0_source0_active,	
																		inst_0_source1_active,	
																		inst_0_source0_sysreg,				
																		inst_0_source1_sysreg,	
																		inst_0_source0_sysreg_rename,
																		inst_0_source1_sysreg_rename,
																		inst_0_adv_active,
																		inst_0_adv_data,
																		inst_0_destination,	
																		inst_0_ex_sys_adder,
																		inst_0_ex_sys_ldst,
																		inst_0_ex_logic,
																		inst_0_ex_shift,
																		inst_0_ex_adder,
																		inst_0_ex_mul,
																		inst_0_ex_sdiv,
																		inst_0_ex_udiv,
																		inst_0_ex_ldst,
																		inst_0_ex_branch} : {
																					inst_1_destination_sysreg,	
																					inst_1_dest_rename,
																					inst_1_writeback,	
																					inst_1_flags_writeback,
																					//inst_1_commit_wait_inst,					
																					inst_1_cmd,
																					inst_1_cc_afe,
																					inst_1_source0,
																					inst_1_source1,
																					inst_1_source0_flags,
																					inst_1_source1_imm,
																					inst_1_source0_active,	
																					inst_1_source1_active,	
																					inst_1_source0_sysreg,				
																					inst_1_source1_sysreg,	
																					inst_1_source0_sysreg_rename,
																					inst_1_source1_sysreg_rename,
																					inst_1_adv_active,
																					inst_1_adv_data,
																					inst_1_destination,	
																					inst_1_ex_sys_adder,
																					inst_1_ex_sys_ldst,
																					inst_1_ex_logic,
																					inst_1_ex_shift,
																					inst_1_ex_adder,
																					inst_1_ex_mul,
																					inst_1_ex_sdiv,
																					inst_1_ex_udiv,
																					inst_1_ex_ldst,
																					inst_1_ex_branch};
			
	assign oNEXT_1_VALID = next_1_valid;										
	assign {
		oNEXT_1_DESTINATION_SYSREG,
		oNEXT_1_DEST_RENAME,		
		oNEXT_1_WRITEBACK,	
		oNEXT_1_FLAGS_WRITEBACK,	
		oNEXT_1_CMD,
		oNEXT_1_CC_AFE,			
		oNEXT_1_SOURCE0,			
		oNEXT_1_SOURCE1,		
		oNEXT_1_SOURCE0_FLAGS,
		oNEXT_1_SOURCE1_IMM,	
		oNEXT_1_SOURCE0_ACTIVE,		
		oNEXT_1_SOURCE1_ACTIVE,	
		oNEXT_1_SOURCE0_SYSREG,	
		oNEXT_1_SOURCE1_SYSREG,	
		oNEXT_1_SOURCE0_SYSREG_RENAME,
		oNEXT_1_SOURCE1_SYSREG_RENAME,	
		oNEXT_1_ADV_ACTIVE,
		oNEXT_1_ADV_DATA,	
		oNEXT_1_DESTINATION,	
		oNEXT_1_EX_SYS_ADDER,	
		oNEXT_1_EX_SYS_LDST,	
		oNEXT_1_EX_LOGIC,	
		oNEXT_1_EX_SHIFT,		
		oNEXT_1_EX_ADDER,		
		oNEXT_1_EX_MUL,		
		oNEXT_1_EX_SDIV,			
		oNEXT_1_EX_UDIV,		
		oNEXT_1_EX_LDST,	
		oNEXT_1_EX_BRANCH} = {
								inst_1_destination_sysreg,	
								inst_1_dest_rename,
								inst_1_writeback,	
								inst_1_flags_writeback,
								//inst_1_commit_wait_inst,					
								inst_1_cmd,
								inst_1_cc_afe,
								inst_1_source0,
								inst_1_source1,
								inst_1_source0_flags,
								inst_1_source1_imm,
								inst_1_source0_active,	
								inst_1_source1_active,	
								inst_1_source0_sysreg,				
								inst_1_source1_sysreg,	
								inst_1_source0_sysreg_rename,
								inst_1_source1_sysreg_rename,
								inst_1_adv_active,
								inst_1_adv_data,
								inst_1_destination,	
								inst_1_ex_sys_adder,
								inst_1_ex_sys_ldst,
								inst_1_ex_logic,
								inst_1_ex_shift,
								inst_1_ex_adder,
								inst_1_ex_mul,
								inst_1_ex_sdiv,
								inst_1_ex_udiv,
								inst_1_ex_ldst,
								inst_1_ex_branch};

	assign oNEXT_PC = (!(b_state == STT_BUFFER_COMMIT_WAIT))? inst_0_pc : inst_1_pc;
	assign oPREVIOUS_LOCK = prev_lock;
	
	assign oLOOPBUFFER_LIMIT = (loop_buffer_count >= 4'h8)? 1'b1 : 1'b0;
	
endmodule

`default_nettype wire

/****************************************
	Decode Unit
****************************************/
`include "core.h"
`default_nettype none			


module decoder(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Free
		//input wire iFREE_DEFAULT,	
		input wire iRESET_SYNC,
		//Previous
		/*
		input wire iPREVIOUS_INST_VALID,
		input wire iPREVIOUS_FAULT_PAGEFAULT,
		input wire iPREVIOUS_FAULT_PRIVILEGE_ERROR,
		input wire iPREVIOUS_FAULT_INVALID_INST,
		input wire iPREVIOUS_PAGING_ENA,
		input wire iPREVIOUS_KERNEL_ACCESS,
		input wire iPREVIOUS_BRANCH_PREDICT,
		input wire [31:0] iPREVIOUS_BRANCH_PREDICT_ADDR,
		input wire [31:0] iPREVIOUS_INST,
		input wire [31:0] iPREVIOUS_PC,
		output wire oPREVIOUS_LOCK,
		*/
		input wire iPREVIOUS_COMMON_VALID,
		input wire iPREVIOUS_0_INST_VALID,
		input wire iPREVIOUS_0_PAGEFAULT,
		input wire iPREVIOUS_0_PAGING_ENA,
		input wire iPREVIOUS_0_KERNEL_ACCESS,
		input wire iPREVIOUS_0_BRANCH_PREDICT,
		input wire [31:0] iPREVIOUS_0_BRANCH_PREDICT_ADDR,
		input wire [31:0] iPREVIOUS_0_INST,
		input wire iPREVIOUS_1_INST_VALID,
		input wire iPREVIOUS_1_PAGEFAULT,
		input wire iPREVIOUS_1_PAGING_ENA,
		input wire iPREVIOUS_1_KERNEL_ACCESS,
		input wire iPREVIOUS_1_BRANCH_PREDICT,
		input wire [31:0] iPREVIOUS_1_BRANCH_PREDICT_ADDR,
		input wire [31:0] iPREVIOUS_1_INST,
		input wire [31:0] iPREVIOUS_PC,
		output wire oPREVIOUS_LOCK,
		//Next-0		
		output wire oNEXT_COMMON_VALID,
		output wire oNEXT_0_VALID,
		output wire oNEXT_0_FAULT_PAGEFAULT,
		output wire oNEXT_0_FAULT_PRIVILEGE_ERROR,
		output wire oNEXT_0_FAULT_INVALID_INST,
		output wire oNEXT_0_PAGING_ENA,
		output wire oNEXT_0_KERNEL_ACCESS,
		output wire oNEXT_0_BRANCH_PREDICT,
		output wire [31:0] oNEXT_0_BRANCH_PREDICT_ADDR,
		output wire oNEXT_0_SOURCE0_ACTIVE,			
		output wire oNEXT_0_SOURCE1_ACTIVE,		
		output wire oNEXT_0_SOURCE0_SYSREG,		
		output wire oNEXT_0_SOURCE1_SYSREG,		
		output wire oNEXT_0_SOURCE0_SYSREG_RENAME,	
		output wire oNEXT_0_SOURCE1_SYSREG_RENAME,
		output wire oNEXT_0_ADV_ACTIVE,		//++
		output wire oNEXT_0_DESTINATION_SYSREG,	
		output wire oNEXT_0_DEST_RENAME,	
		output wire oNEXT_0_WRITEBACK,
		output wire oNEXT_0_FLAGS_WRITEBACK,
		output wire oNEXT_0_FRONT_COMMIT_WAIT,				
		output wire [4:0] oNEXT_0_CMD,
		output wire [3:0] oNEXT_0_CC_AFE,
		output wire [4:0] oNEXT_0_SOURCE0,
		output wire [31:0] oNEXT_0_SOURCE1,
		output wire [5:0] oNEXT_0_ADV_DATA,	//++
		output wire oNEXT_0_SOURCE0_FLAGS,
		output wire oNEXT_0_SOURCE1_IMM,
		output wire [4:0] oNEXT_0_DESTINATION,
		output wire oNEXT_0_EX_SYS_REG,	
		output wire oNEXT_0_EX_SYS_LDST,	
		output wire oNEXT_0_EX_LOGIC,
		output wire oNEXT_0_EX_SHIFT,
		output wire oNEXT_0_EX_ADDER,
		output wire oNEXT_0_EX_MUL,			
		output wire oNEXT_0_EX_SDIV,		
		output wire oNEXT_0_EX_UDIV,		
		output wire oNEXT_0_EX_LDST,
		output wire oNEXT_0_EX_BRANCH,
		output wire oNEXT_1_VALID,
		output wire oNEXT_1_FAULT_PAGEFAULT,
		output wire oNEXT_1_FAULT_PRIVILEGE_ERROR,
		output wire oNEXT_1_FAULT_INVALID_INST,
		output wire oNEXT_1_PAGING_ENA,
		output wire oNEXT_1_KERNEL_ACCESS,
		output wire oNEXT_1_BRANCH_PREDICT,
		output wire [31:0] oNEXT_1_BRANCH_PREDICT_ADDR,
		output wire oNEXT_1_SOURCE0_ACTIVE,			
		output wire oNEXT_1_SOURCE1_ACTIVE,		
		output wire oNEXT_1_SOURCE0_SYSREG,		
		output wire oNEXT_1_SOURCE1_SYSREG,		
		output wire oNEXT_1_SOURCE0_SYSREG_RENAME,	
		output wire oNEXT_1_SOURCE1_SYSREG_RENAME,
		output wire oNEXT_1_ADV_ACTIVE,		//++
		output wire oNEXT_1_DESTINATION_SYSREG,	
		output wire oNEXT_1_DEST_RENAME,	
		output wire oNEXT_1_WRITEBACK,
		output wire oNEXT_1_FLAGS_WRITEBACK,
		output wire oNEXT_1_FRONT_COMMIT_WAIT,				
		output wire [4:0] oNEXT_1_CMD,
		output wire [3:0] oNEXT_1_CC_AFE,
		output wire [4:0] oNEXT_1_SOURCE0,
		output wire [31:0] oNEXT_1_SOURCE1,
		output wire [5:0] oNEXT_1_ADV_DATA,	//++
		output wire oNEXT_1_SOURCE0_FLAGS,
		output wire oNEXT_1_SOURCE1_IMM,
		output wire [4:0] oNEXT_1_DESTINATION,
		output wire oNEXT_1_EX_SYS_REG,	
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
	
	wire decode_0_source0_active;			
	wire decode_0_source1_active;		
	wire decode_0_source0_sysreg;		
	wire decode_0_source1_sysreg;		
	wire decode_0_source0_sysreg_rename;	
	wire decode_0_source1_sysreg_rename;
	wire decode_0_adv_active;	
	wire decode_0_destination_sysreg;	
	wire decode_0_dest_rename;	
	wire decode_0_writeback;
	wire decode_0_flags_writeback;
	wire decode_0_front_commit_wait;				
	wire [4:0] decode_0_cmd;
	wire [3:0] decode_0_cc_afe;
	wire [4:0] decode_0_source0;
	wire [31:0] decode_0_source1;
	wire [5:0] decode_0_adv_data;
	wire decode_0_source0_flags;
	wire decode_0_source1_imm;
	wire [4:0] decode_0_destination;
	wire decode_0_ex_sys_reg;	
	wire decode_0_ex_sys_ldst;	
	wire decode_0_ex_logic;
	wire decode_0_ex_shift;
	wire decode_0_ex_adder;
	wire decode_0_ex_mul;			
	wire decode_0_ex_sdiv;		
	wire decode_0_ex_udiv;		
	wire decode_0_ex_ldst;
	wire decode_0_ex_branch;	

	wire decode_1_source0_active;			
	wire decode_1_source1_active;		
	wire decode_1_source0_sysreg;		
	wire decode_1_source1_sysreg;		
	wire decode_1_source0_sysreg_rename;	
	wire decode_1_source1_sysreg_rename;
	wire decode_1_adv_active;	
	wire decode_1_destination_sysreg;	
	wire decode_1_dest_rename;	
	wire decode_1_writeback;
	wire decode_1_flags_writeback;
	wire decode_1_front_commit_wait;				
	wire [4:0] decode_1_cmd;
	wire [3:0] decode_1_cc_afe;
	wire [4:0] decode_1_source0;
	wire [31:0] decode_1_source1;
	wire [5:0] decode_1_adv_data;
	wire decode_1_source0_flags;
	wire decode_1_source1_imm;
	wire [4:0] decode_1_destination;
	wire decode_1_ex_sys_reg;	
	wire decode_1_ex_sys_ldst;	
	wire decode_1_ex_logic;
	wire decode_1_ex_shift;
	wire decode_1_ex_adder;
	wire decode_1_ex_mul;			
	wire decode_1_ex_sdiv;		
	wire decode_1_ex_udiv;		
	wire decode_1_ex_ldst;
	wire decode_1_ex_branch;

	//synthesis translate_off
	wire decode_0_error;
	wire decode_1_error;
	//synthesis translate_on

	/****************************************
	Auth & MMU Check
	****************************************/
	wire instcheck_0_mmu_irq40;
	wire instcheck_0_mmu_irq41;
	wire instcheck_0_mmu_irq42;
	wire instcheck_0_auth_irq41;

	wire instcheck_1_mmu_irq40;
	wire instcheck_1_mmu_irq41;
	wire instcheck_1_mmu_irq42;
	wire instcheck_1_auth_irq41;

	/*
	decode_mmucheck MMUCHECK_PIPE0(
		.iPAGING_ENA(),
		.iKERNEL_ACCESS(),
		.iMMU_FLAGS(),
		.oIRQ40(instcheck_0_mmu_irq40),
		.oIRQ41(instcheck_0_mmu_irq41),
		.oIRQ42(instcheck_0_mmu_irq42)
	);


	decode_authcheck AUCHCHECK_PIPE0(
		.iINSTRUCTION(iPREVIOUS_0_INST),
		.iKERNEL_ACCESS(),
		.iMMU_FLAGS(),
		.oIRQ41(instcheck_0_auth_irq41)
	);
	*/
	assign instcheck_0_mmu_irq40 = 1'b0;
	assign instcheck_0_mmu_irq41 = 1'b0;
	assign instcheck_0_mmu_irq42 = 1'b0;
	assign instcheck_0_auth_irq41 = 1'b0;

	assign instcheck_1_mmu_irq40 = 1'b0;
	assign instcheck_1_mmu_irq41 = 1'b0;
	assign instcheck_1_mmu_irq42 = 1'b0;
	assign instcheck_1_auth_irq41 = 1'b0;

	/****************************************
	Instruction Decode
	****************************************/	
	decode_function DECODE_FUNCTION0(
		//Input
		.iINSTLUCTION(iPREVIOUS_0_INST),
		//Info
		.oINF_ERROR(decode_0_error),
		//Decode
		.oDECODE_SOURCE0_ACTIVE(decode_0_source0_active),			
		.oDECODE_SOURCE1_ACTIVE(decode_0_source1_active),		
		.oDECODE_SOURCE0_SYSREG(decode_0_source0_sysreg),		
		.oDECODE_SOURCE1_SYSREG(decode_0_source1_sysreg),		
		.oDECODE_SOURCE0_SYSREG_RENAME(decode_0_source0_sysreg_rename),	
		.oDECODE_SOURCE1_SYSREG_RENAME(decode_0_source1_sysreg_rename),
		.oDECODE_ADV_ACTIVE(decode_0_adv_active),	
		.oDECODE_DESTINATION_SYSREG(decode_0_destination_sysreg),	
		.oDECODE_DEST_RENAME(decode_0_dest_rename),	
		.oDECODE_WRITEBACK(decode_0_writeback),
		.oDECODE_FLAGS_WRITEBACK(decode_0_flags_writeback),
		.oDECODE_FRONT_COMMIT_WAIT(decode_0_front_commit_wait),	//???			
		.oDECODE_CMD(decode_0_cmd),
		.oDECODE_CC_AFE(decode_0_cc_afe),
		.oDECODE_SOURCE0(decode_0_source0),
		.oDECODE_SOURCE1(decode_0_source1),
		.oDECODE_ADV_DATA(decode_0_adv_data),
		.oDECODE_SOURCE0_FLAGS(decode_0_source0_flags),
		.oDECODE_SOURCE1_IMM(decode_0_source1_imm),
		.oDECODE_DESTINATION(decode_0_destination),
		.oDECODE_EX_SYS_REG(decode_0_ex_sys_reg),	
		.oDECODE_EX_SYS_LDST(decode_0_ex_sys_ldst),	
		.oDECODE_EX_LOGIC(decode_0_ex_logic),
		.oDECODE_EX_SHIFT(decode_0_ex_shift),
		.oDECODE_EX_ADDER(decode_0_ex_adder),
		.oDECODE_EX_MUL(decode_0_ex_mul),			
		.oDECODE_EX_SDIV(decode_0_ex_sdiv),		
		.oDECODE_EX_UDIV(decode_0_ex_udiv),		
		.oDECODE_EX_LDST(decode_0_ex_ldst),
		.oDECODE_EX_BRANCH(decode_0_ex_branch)
	);

	decode_function DECODE_FUNCTION1(
		//Input
		.iINSTLUCTION(iPREVIOUS_1_INST),
		//Info
		.oINF_ERROR(decode_1_error),
		//Decode
		.oDECODE_SOURCE0_ACTIVE(decode_1_source0_active),			
		.oDECODE_SOURCE1_ACTIVE(decode_1_source1_active),		
		.oDECODE_SOURCE0_SYSREG(decode_1_source0_sysreg),		
		.oDECODE_SOURCE1_SYSREG(decode_1_source1_sysreg),		
		.oDECODE_SOURCE0_SYSREG_RENAME(decode_1_source0_sysreg_rename),	
		.oDECODE_SOURCE1_SYSREG_RENAME(decode_1_source1_sysreg_rename),
		.oDECODE_ADV_ACTIVE(decode_1_adv_active),	
		.oDECODE_DESTINATION_SYSREG(decode_1_destination_sysreg),	
		.oDECODE_DEST_RENAME(decode_1_dest_rename),	
		.oDECODE_WRITEBACK(decode_1_writeback),
		.oDECODE_FLAGS_WRITEBACK(decode_1_flags_writeback),
		.oDECODE_FRONT_COMMIT_WAIT(decode_1_front_commit_wait),	//???			
		.oDECODE_CMD(decode_1_cmd),
		.oDECODE_CC_AFE(decode_1_cc_afe),
		.oDECODE_SOURCE0(decode_1_source0),
		.oDECODE_SOURCE1(decode_1_source1),
		.oDECODE_ADV_DATA(decode_1_adv_data),
		.oDECODE_SOURCE0_FLAGS(decode_1_source0_flags),
		.oDECODE_SOURCE1_IMM(decode_1_source1_imm),
		.oDECODE_DESTINATION(decode_1_destination),
		.oDECODE_EX_SYS_REG(decode_1_ex_sys_reg),	
		.oDECODE_EX_SYS_LDST(decode_1_ex_sys_ldst),	
		.oDECODE_EX_LOGIC(decode_1_ex_logic),
		.oDECODE_EX_SHIFT(decode_1_ex_shift),
		.oDECODE_EX_ADDER(decode_1_ex_adder),
		.oDECODE_EX_MUL(decode_1_ex_mul),			
		.oDECODE_EX_SDIV(decode_1_ex_sdiv),		
		.oDECODE_EX_UDIV(decode_1_ex_udiv),		
		.oDECODE_EX_LDST(decode_1_ex_ldst),
		.oDECODE_EX_BRANCH(decode_1_ex_branch)
	);
	
	
	
	/****************************************
	Condition
	****************************************/	
	wire stage_reg_system_busy;
	wire stage_reg_pipe0_busy;
	wire stage_reg_pipe1_busy;


	wire latch_busy = stage_reg_system_busy || stage_reg_pipe0_busy || stage_reg_pipe1_busy;
	wire latch_enable_condition = iPREVIOUS_COMMON_VALID && !latch_busy;

				
	/****************************************
	This -> Next
	****************************************/
	pipeline_register #(108) PIPELINE_REG_SYSTEM(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iRESET_SYNC(iRESET_SYNC),
		//
		.iPREV_REQ(latch_enable_condition),
		.oPREV_BUSY(stage_reg_system_busy),
		.iPREV_DATA(
			{
				//0-Pipe
				instcheck_0_mmu_irq42,
				(instcheck_0_mmu_irq41 || instcheck_0_auth_irq41),
				(instcheck_0_mmu_irq40 || iPREVIOUS_0_PAGEFAULT),
				iPREVIOUS_0_PAGING_ENA,
				iPREVIOUS_0_KERNEL_ACCESS,
				iPREVIOUS_0_BRANCH_PREDICT,
				iPREVIOUS_0_BRANCH_PREDICT_ADDR,
				//1-Pipe
				instcheck_1_mmu_irq42,
				(instcheck_1_mmu_irq41 || instcheck_1_auth_irq41),
				(instcheck_1_mmu_irq40 || iPREVIOUS_1_PAGEFAULT),
				iPREVIOUS_1_PAGING_ENA,
				iPREVIOUS_1_KERNEL_ACCESS,
				iPREVIOUS_1_BRANCH_PREDICT,
				iPREVIOUS_1_BRANCH_PREDICT_ADDR,
				//Program Counter		
				iPREVIOUS_PC
			}
		),
		//
		.oNEXT_REQ(oNEXT_COMMON_VALID),
		.iNEXT_BUSY(iNEXT_LOCK),
		.oNEXT_DATA(
			{
				oNEXT_0_FAULT_PAGEFAULT,
				oNEXT_0_FAULT_PRIVILEGE_ERROR,
				oNEXT_0_FAULT_INVALID_INST,
				oNEXT_0_PAGING_ENA,
				oNEXT_0_KERNEL_ACCESS,
				oNEXT_0_BRANCH_PREDICT,
				oNEXT_0_BRANCH_PREDICT_ADDR,
				oNEXT_1_FAULT_PAGEFAULT,
				oNEXT_1_FAULT_PRIVILEGE_ERROR,
				oNEXT_1_FAULT_INVALID_INST,
				oNEXT_1_PAGING_ENA,
				oNEXT_1_KERNEL_ACCESS,
				oNEXT_1_BRANCH_PREDICT,
				oNEXT_1_BRANCH_PREDICT_ADDR,
				oNEXT_PC
			}
		)
	);

	wire nexe_decode_0_valid;
	wire nexe_decode_1_valid;

	pipeline_register #(82) PIPELINE_REG_PIPE0(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iRESET_SYNC(iRESET_SYNC),
		//
		.iPREV_REQ(latch_enable_condition),
		.oPREV_BUSY(stage_reg_pipe0_busy),
		.iPREV_DATA(
			{
				iPREVIOUS_0_INST_VALID,
				decode_0_source0_active,
				decode_0_source1_active,
				decode_0_source0_sysreg,
				decode_0_source1_sysreg,
				decode_0_source0_sysreg_rename,
				decode_0_source1_sysreg_rename,
				decode_0_adv_data,
				decode_0_adv_active,
				decode_0_destination_sysreg,
				decode_0_dest_rename,
				decode_0_writeback,
				decode_0_flags_writeback,
				decode_0_front_commit_wait,
				decode_0_cmd,
				decode_0_cc_afe,
				decode_0_source0,
				decode_0_source1,
				decode_0_source0_flags,
				decode_0_source1_imm,
				decode_0_destination,
				decode_0_ex_sys_reg,
				decode_0_ex_sys_ldst,
				decode_0_ex_logic,
				decode_0_ex_shift,
				decode_0_ex_adder,
				decode_0_ex_mul,
				decode_0_ex_sdiv,
				decode_0_ex_udiv,
				decode_0_ex_ldst,
				decode_0_ex_branch
			}
		),
		//
		.oNEXT_REQ(),
		.iNEXT_BUSY(iNEXT_LOCK),
		.oNEXT_DATA(
			{
				nexe_decode_0_valid,//oNEXT_0_VALID,
				oNEXT_0_SOURCE0_ACTIVE,			
				oNEXT_0_SOURCE1_ACTIVE,		
				oNEXT_0_SOURCE0_SYSREG,		
				oNEXT_0_SOURCE1_SYSREG,		
				oNEXT_0_SOURCE0_SYSREG_RENAME,	
				oNEXT_0_SOURCE1_SYSREG_RENAME,
				oNEXT_0_ADV_DATA,
				oNEXT_0_ADV_ACTIVE,		//++
				oNEXT_0_DESTINATION_SYSREG,	
				oNEXT_0_DEST_RENAME,	
				oNEXT_0_WRITEBACK,
				oNEXT_0_FLAGS_WRITEBACK,
				oNEXT_0_FRONT_COMMIT_WAIT,				
				oNEXT_0_CMD,
				oNEXT_0_CC_AFE,
				oNEXT_0_SOURCE0,
				oNEXT_0_SOURCE1,
				oNEXT_0_SOURCE0_FLAGS,
				oNEXT_0_SOURCE1_IMM,
				oNEXT_0_DESTINATION,
				oNEXT_0_EX_SYS_REG,	
				oNEXT_0_EX_SYS_LDST,	
				oNEXT_0_EX_LOGIC,
				oNEXT_0_EX_SHIFT,
				oNEXT_0_EX_ADDER,
				oNEXT_0_EX_MUL,			
				oNEXT_0_EX_SDIV,		
				oNEXT_0_EX_UDIV,		
				oNEXT_0_EX_LDST,
				oNEXT_0_EX_BRANCH
			}
		)
	);

	pipeline_register #(82) PIPELINE_REG_PIPE1(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iRESET_SYNC(iRESET_SYNC),
		//
		.iPREV_REQ(latch_enable_condition),
		.oPREV_BUSY(stage_reg_pipe1_busy),
		.iPREV_DATA(
			{
				iPREVIOUS_1_INST_VALID,
				decode_1_source0_active,
				decode_1_source1_active,
				decode_1_source0_sysreg,
				decode_1_source1_sysreg,
				decode_1_source0_sysreg_rename,
				decode_1_source1_sysreg_rename,
				decode_1_adv_data,
				decode_1_adv_active,
				decode_1_destination_sysreg,
				decode_1_dest_rename,
				decode_1_writeback,
				decode_1_flags_writeback,
				decode_1_front_commit_wait,
				decode_1_cmd,
				decode_1_cc_afe,
				decode_1_source0,
				decode_1_source1,
				decode_1_source0_flags,
				decode_1_source1_imm,
				decode_1_destination,
				decode_1_ex_sys_reg,
				decode_1_ex_sys_ldst,
				decode_1_ex_logic,
				decode_1_ex_shift,
				decode_1_ex_adder,
				decode_1_ex_mul,
				decode_1_ex_sdiv,
				decode_1_ex_udiv,
				decode_1_ex_ldst,
				decode_1_ex_branch
			}
		),
		//
		.oNEXT_REQ(),
		.iNEXT_BUSY(iNEXT_LOCK),
		.oNEXT_DATA(
			{
				nexe_decode_1_valid,//oNEXT_1_VALID,
				oNEXT_1_SOURCE0_ACTIVE,			
				oNEXT_1_SOURCE1_ACTIVE,		
				oNEXT_1_SOURCE0_SYSREG,		
				oNEXT_1_SOURCE1_SYSREG,		
				oNEXT_1_SOURCE0_SYSREG_RENAME,	
				oNEXT_1_SOURCE1_SYSREG_RENAME,
				oNEXT_1_ADV_DATA,
				oNEXT_1_ADV_ACTIVE,		//++
				oNEXT_1_DESTINATION_SYSREG,	
				oNEXT_1_DEST_RENAME,	
				oNEXT_1_WRITEBACK,
				oNEXT_1_FLAGS_WRITEBACK,
				oNEXT_1_FRONT_COMMIT_WAIT,				
				oNEXT_1_CMD,
				oNEXT_1_CC_AFE,
				oNEXT_1_SOURCE0,
				oNEXT_1_SOURCE1,
				oNEXT_1_SOURCE0_FLAGS,
				oNEXT_1_SOURCE1_IMM,
				oNEXT_1_DESTINATION,
				oNEXT_1_EX_SYS_REG,	
				oNEXT_1_EX_SYS_LDST,	
				oNEXT_1_EX_LOGIC,
				oNEXT_1_EX_SHIFT,
				oNEXT_1_EX_ADDER,
				oNEXT_1_EX_MUL,			
				oNEXT_1_EX_SDIV,		
				oNEXT_1_EX_UDIV,		
				oNEXT_1_EX_LDST,
				oNEXT_1_EX_BRANCH
			}
		)
	);
	
	assign oNEXT_0_VALID = !iRESET_SYNC && nexe_decode_0_valid;
	assign oNEXT_1_VALID = !iRESET_SYNC && nexe_decode_1_valid;
		
	assign oPREVIOUS_LOCK = latch_busy;

endmodule


`default_nettype wire



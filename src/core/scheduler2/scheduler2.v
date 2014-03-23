/*************************************************************
	Scheduler2 Unit (Out of Order Scheduler Unit 2/2)
	- Reservation station & Register & RegisterFreelist
	
	
	Make	:	2010/11/00 Takahiro Ito
	Update	:	
*************************************************************/

`include "core.h"
`include "processor.h"
`default_nettype none

module scheduler2 #(
		parameter CORE_ID = 32'h0
	)(
		//System
		input wire iCLOCK,
		input wire inRESET,	
		//Error
		//Free
		input wire iFREE_DEFAULT,
		input wire iFREE_RESTART,
		input wire iFREE_RESERVATIONSTATION,	
		input wire iFREE_SYSREG_SET_IRQ_MODE,
		input wire iFREE_SYSREG_BACK_PREVIOUS,
		input wire [31:0] iFREE_CURRENT_PC,
		input wire [63:0] iFREE_REGISTER,
		//Fetch
		//input wire [31:0] iFETCH_PC,
		//Scheduler1
		input wire [63:0] iCOMMIT_ENTRY_COMMIT_VECTOR,
		//SystemRegister Info
		input wire iSYSREGINFO_IOSR_VALID,
		input wire [31:0] iSYSREGINFO_IOSR,
		output wire [31:0] oSYSREGINFO_TIDR,
		output wire [31:0] oSYSREGINFO_PTIDR,
		output wire [31:0] oSYSREGINFO_PSR,
		output wire [31:0] oSYSREGINFO_PPSR,
		output wire [31:0] oSYSREGINFO_TISR,
		output wire [31:0] oSYSREGINFO_PDTR,
		output wire [31:0] oSYSREGINFO_IDTR,
		output wire [31:0] oSYSREGINFO_PPCR,
		//Previous - 0		
		input wire iPREVIOUS_0_VALID,
		input wire iPREVIOUS_0_SOURCE0_ACTIVE,			
		input wire iPREVIOUS_0_SOURCE1_ACTIVE,		
		input wire iPREVIOUS_0_SOURCE0_SYSREG,		
		input wire iPREVIOUS_0_SOURCE1_SYSREG,				
		input wire iPREVIOUS_0_SOURCE0_SYSREG_RENAME,		
		input wire iPREVIOUS_0_SOURCE1_SYSREG_RENAME,
		input wire iPREVIOUS_0_ADV_ACTIVE,	
		input wire iPREVIOUS_0_DESTINATION_SYSREG,			
		input wire iPREVIOUS_0_WRITEBACK,	
		input wire iPREVIOUS_0_FLAGS_WRITEBACK,	
		input wire [4:0] iPREVIOUS_0_CMD,
		input wire [5:0] iPREVIOUS_0_COMMIT_TAG,
		input wire [3:0] iPREVIOUS_0_CC_AFE,		
		input wire [3:0] iPREVIOUS_0_FLAGS_REGNAME,
		input wire [5:0] iPREVIOUS_0_DESTINATION_REGNAME,
		input wire [4:0] iPREVIOUS_0_LOGIC_DESTINATION,
		input wire [5:0] iPREVIOUS_0_SOURCE0,
		input wire [31:0] iPREVIOUS_0_SOURCE1,
		input wire [5:0] iPREVIOUS_0_ADV_DATA,
		input wire iPREVIOUS_0_SOURCE0_FLAGS,	
		input wire iPREVIOUS_0_SOURCE1_IMM,	
		input wire iPREVIOUS_0_EX_SYS_REG,		
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
		input wire iPREVIOUS_1_SOURCE0_ACTIVE,			
		input wire iPREVIOUS_1_SOURCE1_ACTIVE,		
		input wire iPREVIOUS_1_SOURCE0_SYSREG,	
		input wire iPREVIOUS_1_SOURCE1_SYSREG,		
		input wire iPREVIOUS_1_SOURCE0_SYSREG_RENAME,		
		input wire iPREVIOUS_1_SOURCE1_SYSREG_RENAME,
		input wire iPREVIOUS_1_ADV_ACTIVE,				
		input wire iPREVIOUS_1_DESTINATION_SYSREG,	
		input wire iPREVIOUS_1_WRITEBACK,	
		input wire iPREVIOUS_1_FLAGS_WRITEBACK,	
		input wire [4:0] iPREVIOUS_1_CMD,
		input wire [5:0] iPREVIOUS_1_COMMIT_TAG,
		input wire [3:0] iPREVIOUS_1_CC_AFE,			
		input wire [3:0] iPREVIOUS_1_FLAGS_REGNAME,
		input wire [5:0] iPREVIOUS_1_DESTINATION_REGNAME,
		input wire [4:0] iPREVIOUS_1_LOGIC_DESTINATION,
		input wire [5:0] iPREVIOUS_1_SOURCE0,
		input wire [31:0] iPREVIOUS_1_SOURCE1,
		input wire [5:0] iPREVIOUS_1_ADV_DATA,
		input wire iPREVIOUS_1_SOURCE0_FLAGS,		
		input wire iPREVIOUS_1_SOURCE1_IMM,	
		input wire iPREVIOUS_1_EX_SYS_REG,		
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
		//Previous-Register
		output wire oFLAG_REGISTER_0_WR,
		output wire [3:0] oFLAG_REGISTER_0_NUM,
		input wire iFLAG_REGISTER_0_FULL,
		input wire [1:0] iFLAG_REGISTER_0_COUNT,
		output wire oFLAG_REGISTER_1_WR,
		output wire [3:0] oFLAG_REGISTER_1_NUM,
		input wire iFLAG_REGISTER_1_FULL,
		input wire [1:0] iFLAG_REGISTER_1_COUNT,
		output wire oOTHER_REGISTER_0_WR,
		output wire [5:0] oOTHER_REGISTER_0_NUM,
		input wire iOTHER_REGISTER_0_FULL,
		input wire [2:0] iOTHER_REGISTER_0_COUNT,
		output wire oOTHER_REGISTER_1_WR,
		output wire [5:0] oOTHER_REGISTER_1_NUM,
		input wire iOTHER_REGISTER_1_FULL,
		input wire [2:0] iOTHER_REGISTER_1_COUNT,
		//Branch Unit - Output
		output wire oNEXT_EX_BRANCH_VALID,
		output wire [5:0] oNEXT_EX_BRANCH_COMMIT_TAG,
		output wire [4:0] oNEXT_EX_BRANCH_CMD,
		output wire [3:0] oNEXT_EX_BRANCH_CC,
		output wire [4:0] oNEXT_EX_BRANCH_FLAG,
		output wire [31:0] oNEXT_EX_BRANCH_SOURCE,
		output wire [31:0] oNEXT_EX_PC,
		input wire iNEXT_EX_BRANCH_LOCK,
		//Branch Unit - Input
		input wire iSCHE2_EX_BRANCH_VALID,
		input wire [5:0] iSCHE2_EX_BRANCH_COMMIT_TAG,
		//ALU-1(Output)
		output wire oNEXT_EX_ALU1_VALID,
		output wire oNEXT_EX_ALU1_WRITEBACK,
		output wire [5:0] oNEXT_EX_ALU1_COMMIT_TAG,
		output wire [4:0] oNEXT_EX_ALU1_CMD,
		output wire [3:0] oNEXT_EX_ALU1_AFE,	
		output wire oNEXT_EX_ALU1_SYS_REG,
		output wire oNEXT_EX_ALU1_LOGIC,
		output wire oNEXT_EX_ALU1_SHIFT,
		output wire oNEXT_EX_ALU1_ADDER,
		output wire oNEXT_EX_ALU1_MUL,
		output wire oNEXT_EX_ALU1_SDIV,
		output wire oNEXT_EX_ALU1_UDIV,
		output wire [31:0] oNEXT_EX_ALU1_SOURCE0,
		output wire [31:0] oNEXT_EX_ALU1_SOURCE1,
		output wire oNEXT_EX_ALU1_DESTINATION_SYSREG,	
		output wire [4:0] oNEXT_EX_ALU1_LOGIC_DEST,			//for debug
		output wire [5:0] oNEXT_EX_ALU1_DESTINATION_REGNAME,
		output wire oNEXT_EX_ALU1_FLAGS_WRITEBACK,
		output wire [3:0] oNEXT_EX_ALU1_FLAGS_REGNAME,
		output wire [31:0] oNEXT_EX_ALU1_PCR,
		input wire iNEXT_EX_ALU1_LOCK,
		//ALU-1(Input)
		input wire iSCHE2_EX_ALU1_VALID,
		input wire [5:0] iSCHE2_EX_ALU1_COMMIT_TAG,
		input wire iSCHE2_EX_ALU1_DESTINATION_SYSREG,
		input wire [5:0] iSCHE2_EX_ALU1_DESTINATION_REGNAME,	
		input wire iSCHE2_EX_ALU1_WRITEBACK,
		input wire [31:0] iSCHE2_EX_ALU1_DATA,
		input wire [4:0] iSCHE2_EX_ALU1_FLAG,
		input wire iSCHE2_EX_ALU1_FLAGS_WRITEBACK,			
		input wire [3:0] iSCHE2_EX_ALU1_FLAGS_REGNAME,	
		//ALU-2(Output)			
		output wire oNEXT_EX_ALU2_VALID,
		output wire oNEXT_EX_ALU2_WRITEBACK,
		output wire [5:0] oNEXT_EX_ALU2_COMMIT_TAG,
		output wire [4:0] oNEXT_EX_ALU2_CMD,
		output wire [3:0] oNEXT_EX_ALU2_AFE,	
		output wire oNEXT_EX_ALU2_SYS_REG,
		output wire oNEXT_EX_ALU2_LOGIC,
		output wire oNEXT_EX_ALU2_SHIFT,
		output wire oNEXT_EX_ALU2_ADDER,
		output wire [31:0] oNEXT_EX_ALU2_SOURCE0,
		output wire [31:0] oNEXT_EX_ALU2_SOURCE1,
		output wire oNEXT_EX_ALU2_DESTINATION_SYSREG,	
		output wire [4:0] oNEXT_EX_ALU2_LOGIC_DEST,			//for debug	
		output wire [5:0] oNEXT_EX_ALU2_DESTINATION_REGNAME,
		output wire oNEXT_EX_ALU2_FLAGS_WRITEBACK,		
		output wire [3:0] oNEXT_EX_ALU2_FLAGS_REGNAME,
		output wire [31:0] oNEXT_EX_ALU2_PCR,
		input wire iNEXT_EX_ALU2_LOCK,		
		//ALU-2(Input)
		input wire iSCHE2_EX_ALU2_VALID,
		input wire [5:0] iSCHE2_EX_ALU2_COMMIT_TAG,
		input wire iSCHE2_EX_ALU2_DESTINATION_SYSREG,
		input wire [5:0] iSCHE2_EX_ALU2_DESTINATION_REGNAME,	
		input wire iSCHE2_EX_ALU2_WRITEBACK,
		input wire [31:0] iSCHE2_EX_ALU2_DATA,
		input wire [4:0] iSCHE2_EX_ALU2_FLAG,
		input wire iSCHE2_EX_ALU2_FLAGS_WRITEBACK,		
		input wire [3:0] iSCHE2_EX_ALU2_FLAGS_REGNAME,			
		//Load/Store Unit - Output
		output wire oNEXT_EX_ALU3_VALID,
		output wire oNEXT_EX_ALU3_DESTINATION_SYSREG,		
		output wire [5:0] oNEXT_EX_ALU3_COMMIT_TAG,
		output wire [4:0] oNEXT_EX_ALU3_CMD,		
		output wire oNEXT_EX_ALU3_SYS_LDST,				
		output wire oNEXT_EX_ALU3_LDST,
		output wire [31:0] oNEXT_EX_ALU3_SOURCE0,
		output wire [31:0] oNEXT_EX_ALU3_SOURCE1,
		output wire oNEXT_EX_ALU3_ADV_ACTIVE,
		output wire [5:0] oNEXT_EX_ALU3_ADV_DATA,
		output wire [4:0] oNEXT_EX_ALU3_LOGIC_DEST,			//for debug
		output wire [5:0] oNEXT_EX_ALU3_DESTINATION_REGNAME,
		output wire [31:0] oNEXT_EX_ALU3_PC,					
		input wire iNEXT_EX_ALU3_LOCK,
		//Load/Store Unit - Input
		input wire iSCHE2_ALU3_VALID,
		input wire [5:0] iSCHE2_ALU3_COMMIT_TAG,
		input wire [5:0] iSCHE2_ALU3_DESTINATION_REGNAME,
		input wire iSCHE2_ALU3_DESTINATION_SYSREG,			
		input wire iSCHE2_ALU3_WRITEBACK,
		input wire [31:0] iSCHE2_ALU3_DATA
	);
								
	/****************************************
	Wire and Register
	****************************************/
	//Generate
	genvar i;	
	//Lock
	reg b_iosr_get_wait;
	wire this_lock;
	//Extension Inorder Execution Controller
	wire [1:0] inorder_regist_pointer_offset;															
	reg b_ex_execution_lock;
	reg [4:0] b_ex_inorder_regist_pointer;
	reg [4:0] b_ex_inorder_execution_pointer;
	wire [3:0] w_ex_0_inorder_regist_pointer;
	wire [3:0] w_ex_1_inorder_regist_pointer;
	wire [3:0] w_ex_inorder_execution_pointer;
	wire [4:0] w_ex_counter;
	wire w_ex_full;
	//General Register Freelist
	wire gr_freelist_0_set_valid;
	wire [5:0] gr_freelist_0_set_num;
	wire gr_freelist_1_set_valid;
	wire [5:0] gr_freelist_1_set_num;
	//Flag Register
	wire [15:0] flag_rename_management_freelist_regist_valid;
	wire [15:0] flag_rename_management_info_freelist_req;
	wire [15:0] flag_rename_management_info_flags_valid;
	wire [4:0] flag_rename_management_info_flags[15:0];
	//Flag Register Free list
	wire flag_rename_management_select_0_valid;
	wire flag_rename_management_select_1_valid;
	wire [3:0] flag_rename_management_select_0_num;
	wire [3:0] flag_rename_management_select_1_num;
	//System Register
	wire [31:0] w_sysreg_cpuidr_info_data;
	wire [31:0] w_sysreg_coreidr_info_data;
	wire w_sysreg_tidr_regist_valid;
	wire [31:0] w_sysreg_tidr_regist_data;
	wire [31:0] w_sysreg_tidr_info_data;
	wire w_sysreg_psr_regist_valid;
	wire [31:0] w_sysreg_psr_regist_data;
	wire [31:0] w_sysreg_psr_info_data;
	wire w_sysreg_idtr_regist_valid;
	wire [31:0] w_sysreg_idtr_regist_data;
	wire [31:0] w_sysreg_idtr_info_data;
	wire w_sysreg_pdtr_regist_valid;
	wire [31:0] w_sysreg_pdtr_regist_data;
	wire [31:0] w_sysreg_pdtr_info_data;
	wire w_sysreg_tisr_regist_valid;
	wire [31:0] w_sysreg_tisr_regist_data;
	wire [31:0] w_sysreg_tisr_info_data;
	wire w_sysreg_kpdtr_regist_valid;
	wire [31:0] w_sysreg_kpdtr_regist_data;
	wire [31:0] w_sysreg_kpdtr_info_data;
	wire [31:0] w_sysreg_iosr_info_data;
	wire w_sysreg_ppcr_regist_valid;
	wire [31:0] w_sysreg_ppcr_regist_data;
	wire [31:0] w_sysreg_ppcr_info_data;
	wire w_sysreg_ptidr_regist_valid;
	wire [31:0] w_sysreg_ptidr_regist_data;
	wire [31:0] w_sysreg_ptidr_info_data;
	wire w_sysreg_ppdtr_regist_valid;
	wire [31:0] w_sysreg_ppdtr_regist_data;
	wire [31:0] w_sysreg_ppdtr_info_data;	
	wire w_sysreg_ppsr_regist_valid;
	wire [31:0] w_sysreg_ppsr_regist_data;
	wire [31:0] w_sysreg_ppsr_info_data;
	wire w_sysreg_frclr_regist_valid;
	wire [31:0] w_sysreg_frclr_regist_data;
	wire w_sysreg_frchr_regist_valid;
	wire [31:0] w_sysreg_frchr_regist_data;
	wire [31:0] w_sysreg_frclr_info_data;
	wire [31:0] w_sysreg_frchr_info_data;
	//General Register Instance
	wire gr_freelist_regist_valid[0:63];
	wire gr_info_freelist_req[0:63];
	wire gr_info_data_valid[0:63];
	wire [31:0] gr_info_data[0:63];
	//All Register Select
	wire w_register_mix_prev0_source0_valid;
	wire [31:0] w_register_mix_prev0_source0;
	wire w_register_mix_prev0_source1_valid;
	wire [31:0] w_register_mix_prev0_source1;
	wire w_register_mix_prev1_source0_valid;
	wire [31:0] w_register_mix_prev1_source0;
	wire w_register_mix_prev1_source1_valid;
	wire [31:0] w_register_mix_prev1_source1;
	//Reservetion Station0
	wire rs_branch_exout_all_valid;
	wire rs_branch_lock;
	wire rs_alu0_regist_valid[0:7];
	wire [4:0] rs_alu0_regist_cmd[0:7];
	wire [3:0] rs_alu0_regist_cc[0:7];
	wire rs_alu0_regist_flag_valid[0:7];
	wire [4:0] rs_alu0_regist_flag[0:7];
	wire rs_alu0_regist_source1_valid[0:7];
	wire [31:0] rs_alu0_regist_source1[0:7];
	wire [31:0] rs_alu0_regist_pc[0:7];
	wire [5:0] rs_alu0_regist_destination_regname[0:7];
	wire [5:0] rs_alu0_regist_commit_tag[0:7];
	wire [3:0] rs_alu0_regist_ex_inorder_regist_pointer[0:7];
	wire rs_alu0_exout_valid[0:7];
	wire rs_alu0_info_entry_valid[0:7];
	wire rs_alu0_info_matching[0:7];
	wire [4:0] rs_alu0_info_cmd[0:7];
	wire [3:0] rs_alu0_info_cc[0:7];
	wire rs_alu0_info_flag_valid[0:7];
	wire [4:0] rs_alu0_info_flag[0:7];
	wire rs_alu0_info_source1_valid[0:7];
	wire [31:0] rs_alu0_info_source1[0:7];
	wire [31:0] rs_alu0_info_pc[0:7];
	wire [5:0] rs_alu0_info_destination_regname[0:7];
	wire [5:0] rs_alu0_info_commit_tag[0:7];
	//Reservetion Station1
	wire rs_alu1_lock;
	wire [3:0] rs_alu1_regist_possible_count;
	wire rs_alu1_regist_0_valid;
	wire [3:0] rs_alu1_regist_0_num;
	wire rs_alu1_regist_1_valid;
	wire [3:0] rs_alu1_regist_1_num;
	wire rs_alu1_exout_entry_num_valid;
	wire [3:0] rs_alu1_exout_entry_num;
	wire rs_alu1_regist_destination_sysreg[0:15];
	wire rs_alu1_regist_valid[0:15];
	wire rs_alu1_regist_lock[0:15];
	wire rs_alu1_regist_writeback[0:15];
	wire [4:0] rs_alu1_regist_cmd[0:15];
	wire [3:0] rs_alu1_regist_afe[0:15];
	wire rs_alu1_regist_sys_reg[0:15];
	wire rs_alu1_regist_logic[0:15];
	wire rs_alu1_regist_shift[0:15];
	wire rs_alu1_regist_adder[0:15];
	wire rs_alu1_regist_mul[0:15];
	wire rs_alu1_regist_sdiv[0:15];
	wire rs_alu1_regist_udiv[0:15];
	wire rs_alu1_regist_flags_writeback[0:15];
	wire [3:0] rs_alu1_regist_flags_regname[0:15];
	wire rs_alu1_regist_source0_valid[0:15];
	wire [31:0] rs_alu1_regist_source0[0:15];
	wire rs_alu1_regist_source1_valid[0:15];
	wire [31:0] rs_alu1_regist_source1[0:15];
	wire [31:0] rs_alu1_regist_pcr[0:15];
	wire [4:0] rs_alu1_regist_logic_dest[0:15];
	wire [5:0] rs_alu1_regist_destination_regname[0:15];
	wire [5:0] rs_alu1_regist_commit_tag[0:15];
	wire rs_alu1_exout_valid[0:15];
	wire rs_alu1_info_entry_valid[0:15];
	wire rs_alu1_info_matching[0:15];
	wire rs_alu1_info_destination_sysreg[0:15];
	wire rs_alu1_info_writeback[0:15];
	wire [4:0] rs_alu1_info_cmd[0:15];
	wire [3:0] rs_alu1_info_afe[0:15];
	wire rs_alu1_info_sys_reg[0:15];
	wire rs_alu1_info_logic[0:15];
	wire rs_alu1_info_shift[0:15];
	wire rs_alu1_info_adder[0:15];
	wire rs_alu1_info_mul[0:15];
	wire rs_alu1_info_sdiv[0:15];
	wire rs_alu1_info_udiv[0:15];
	wire rs_alu1_info_flags_writeback[0:15];
	wire [3:0] rs_alu1_info_flags_regname[0:15];
	wire rs_alu1_info_source0_valid[0:15];
	wire [31:0] rs_alu1_info_source0[0:15];
	wire rs_alu1_info_source1_valid[0:15];
	wire [31:0] rs_alu1_info_source1[0:15];
	wire [31:0] rs_alu1_info_pcr[0:15];
	wire [4:0] rs_alu1_info_logic_dest[0:15];
	wire [5:0] rs_alu1_info_destination_regname[0:15];
	wire [5:0] rs_alu1_info_commit_tag[0:15];
	//Reservation Station2
	wire rs_alu2_lock;
	wire [3:0] rs_alu2_regist_possible_count;
	wire rs_alu2_regist_0_valid;
	wire [3:0] rs_alu2_regist_0_num;
	wire rs_alu2_regist_1_valid;
	wire [3:0] rs_alu2_regist_1_num;
	wire rs_alu2_exout_entry_num_valid;
	wire [3:0] rs_alu2_exout_entry_num;
	wire rs_alu2_regist_destination_sysreg[0:15];
	wire rs_alu2_regist_lock[0:15];
	wire rs_alu2_regist_valid[0:15];
	wire rs_alu2_regist_writeback[0:15];
	wire [4:0] rs_alu2_regist_cmd[0:15];
	wire [3:0] rs_alu2_regist_afe[0:15];
	wire rs_alu2_regist_sys_reg[0:15];
	wire rs_alu2_regist_logic[0:15];
	wire rs_alu2_regist_shift[0:15];
	wire rs_alu2_regist_adder[0:15];
	wire rs_alu2_regist_flags_writeback[0:15];
	wire [3:0] rs_alu2_regist_flags_regname[0:15];
	wire rs_alu2_regist_source0_valid[0:15];
	wire [31:0] rs_alu2_regist_source0[0:15];
	wire rs_alu2_regist_source1_valid[0:15];
	wire [31:0] rs_alu2_regist_source1[0:15];
	wire [31:0] rs_alu2_regist_pcr[0:15];
	wire [4:0] rs_alu2_regist_logic_dest[0:15];
	wire [5:0] rs_alu2_regist_destination_regname[0:15];
	wire [5:0] rs_alu2_regist_commit_tag[0:15];
	wire rs_alu2_exout_valid[0:15];
	wire rs_alu2_info_entry_valid[0:15];
	wire rs_alu2_info_matching[0:15];
	wire rs_alu2_info_destination_sysreg[0:15];
	wire rs_alu2_info_writeback[0:15];
	wire [4:0] rs_alu2_info_cmd[0:15];
	wire [3:0] rs_alu2_info_afe[0:15];
	wire rs_alu2_info_sys_reg[0:15];
	wire rs_alu2_info_logic[0:15];
	wire rs_alu2_info_shift[0:15];
	wire rs_alu2_info_adder[0:15];
	wire rs_alu2_info_flags_writeback[0:15];
	wire [3:0] rs_alu2_info_flags_regname[0:15];
	wire rs_alu2_info_source0_valid[0:15];
	wire [31:0] rs_alu2_info_source0[0:15];
	wire rs_alu2_info_source1_valid[0:15];
	wire [31:0] rs_alu2_info_source1[0:15];
	wire [31:0] rs_alu2_info_pcr[0:15];
	wire [4:0] rs_alu2_info_logic_dest[0:15];
	wire [5:0] rs_alu2_info_destination_regname[0:15];
	wire [5:0] rs_alu2_info_commit_tag[0:15];
	//Load Store Reservation
	wire rs_alu3_0_reg_valid;
	wire rs_alu3_1_reg_valid;
	wire rs_alu3_exout_all_valid;
	wire [3:0] rs_alu3_validentry_count;
	wire rs_alu3_lock;
	wire [2:0] w_rs_alu3_exe_pointer;
	wire [2:0] w_rs_alu3_reg_pointer;
	reg [3:0] b0_rs_alu3_exe_pointer;
	reg [3:0] b0_rs_alu3_reg_pointer;
	wire rs_alu3_exout_valid[0:7];
	wire rs_alu3_info_entry_valid[0:7];
	wire rs_alu3_info_matching[0:7];
	wire [4:0] rs_alu3_info_cmd[0:7];
	wire rs_alu3_info_sys_ldst[0:7];
	wire rs_alu3_info_ldst[0:7];
	wire rs_alu3_info_source0_valid[0:7];
	wire rs_alu3_info_source0_sysreg[0:7];
	wire [31:0] rs_alu3_info_source0[0:7];
	wire rs_alu3_info_source1_valid[0:7];
	wire rs_alu3_info_source1_sysreg[0:7];
	wire [31:0] rs_alu3_info_source1[0:7];
	wire rs_alu3_info_adv_active[0:7];
	wire [5:0] rs_alu3_info_adv_data[0:7];
	wire [4:0] rs_alu3_info_logic_dest[0:7];
	wire [5:0] rs_alu3_info_destination_regname[0:7];
	wire rs_alu3_info_destination_sysreg[0:7];
	wire [5:0] rs_alu3_info_commit_tag[0:7];
	wire [31:0] rs_alu3_info_pc[0:7];
	
	
	/****************************************
	Lock Condition
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_iosr_get_wait <= 1'b0;
		end
		else begin
			if(!b_iosr_get_wait)begin
				b_iosr_get_wait <= iSYSREGINFO_IOSR_VALID;
			end
		end
	end
	
	assign this_lock = rs_branch_lock || rs_alu1_lock || rs_alu2_lock || rs_alu3_lock || w_ex_full || !b_iosr_get_wait;
	
	
	/****************************************
	Extension Inorder Execution Controller
	ex_inorder
	****************************************/
	assign inorder_regist_pointer_offset = ((iPREVIOUS_0_VALID && (iPREVIOUS_0_EX_BRANCH || iPREVIOUS_0_EX_LDST || iPREVIOUS_0_EX_SYS_LDST/* || iPREVIOUS_0_EX_SYS_REG*/)) && 
																(iPREVIOUS_1_VALID && (iPREVIOUS_1_EX_BRANCH || iPREVIOUS_1_EX_LDST || iPREVIOUS_1_EX_SYS_LDST/* || iPREVIOUS_1_EX_SYS_REG*/)))?
																	2'h2 :
																	((iPREVIOUS_0_VALID && (iPREVIOUS_0_EX_BRANCH || iPREVIOUS_0_EX_LDST || iPREVIOUS_0_EX_SYS_LDST/* || iPREVIOUS_0_EX_SYS_REG*/)) ||
																	(iPREVIOUS_1_VALID && (iPREVIOUS_1_EX_BRANCH || iPREVIOUS_1_EX_LDST || iPREVIOUS_1_EX_SYS_LDST/* || iPREVIOUS_1_EX_SYS_REG*/)))?
																		2'h1 : 2'h0;

	assign w_ex_0_inorder_regist_pointer = b_ex_inorder_regist_pointer[3:0];
	assign w_ex_1_inorder_regist_pointer = (inorder_regist_pointer_offset == 2'h2)? b_ex_inorder_regist_pointer[3:0] + 4'h1 : b_ex_inorder_regist_pointer[3:0];
	assign w_ex_inorder_execution_pointer = b_ex_inorder_execution_pointer[3:0];
	assign w_ex_counter = b_ex_inorder_regist_pointer - b_ex_inorder_execution_pointer;
	assign w_ex_full = w_ex_counter[4];
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ex_execution_lock <= 1'b0;
			b_ex_inorder_regist_pointer <= {5{1'b0}};
			b_ex_inorder_execution_pointer <= {5{1'b0}};	
		end
		else if(iFREE_RESTART)begin
			b_ex_execution_lock <= 1'b0;
			b_ex_inorder_regist_pointer <= {5{1'b0}};
			b_ex_inorder_execution_pointer <= {5{1'b0}};	
		end
		else begin
			//Branch Lock
			if(iFREE_DEFAULT)begin
				b_ex_execution_lock <= 1'b1;
			end
			//Regist Pointer
			if(!this_lock)begin
				b_ex_inorder_regist_pointer <= b_ex_inorder_regist_pointer + {3'h0, inorder_regist_pointer_offset};
			end
			//Commit Pointer
			if(!iNEXT_EX_BRANCH_LOCK)begin
				if(!iFREE_DEFAULT && !b_ex_execution_lock)begin
					if(iSCHE2_EX_BRANCH_VALID && iSCHE2_ALU3_VALID)begin
						b_ex_inorder_execution_pointer <= b_ex_inorder_execution_pointer + 5'h02;
					end
					else if(iSCHE2_EX_BRANCH_VALID || iSCHE2_ALU3_VALID)begin
						b_ex_inorder_execution_pointer <= b_ex_inorder_execution_pointer + 5'h01;
					end
				end
			end
		end
	end
	
	/****************************************
	Register Freelist
	Freelist Regist
	****************************************/
	scheduler2_free_search_64to2 FREE_REG_SEARCH(
		.iENTRY0_VALID(gr_info_freelist_req[0]),
		.iENTRY1_VALID(gr_info_freelist_req[1]),
		.iENTRY2_VALID(gr_info_freelist_req[2]),
		.iENTRY3_VALID(gr_info_freelist_req[3]),
		.iENTRY4_VALID(gr_info_freelist_req[4]),
		.iENTRY5_VALID(gr_info_freelist_req[5]),
		.iENTRY6_VALID(gr_info_freelist_req[6]),
		.iENTRY7_VALID(gr_info_freelist_req[7]),
		.iENTRY8_VALID(gr_info_freelist_req[8]),
		.iENTRY9_VALID(gr_info_freelist_req[9]),
		.iENTRY10_VALID(gr_info_freelist_req[10]),
		.iENTRY11_VALID(gr_info_freelist_req[11]),
		.iENTRY12_VALID(gr_info_freelist_req[12]),
		.iENTRY13_VALID(gr_info_freelist_req[13]),
		.iENTRY14_VALID(gr_info_freelist_req[14]),
		.iENTRY15_VALID(gr_info_freelist_req[15]),
		.iENTRY16_VALID(gr_info_freelist_req[16]),
		.iENTRY17_VALID(gr_info_freelist_req[17]),
		.iENTRY18_VALID(gr_info_freelist_req[18]),
		.iENTRY19_VALID(gr_info_freelist_req[19]),
		.iENTRY20_VALID(gr_info_freelist_req[20]),
		.iENTRY21_VALID(gr_info_freelist_req[21]),
		.iENTRY22_VALID(gr_info_freelist_req[22]),
		.iENTRY23_VALID(gr_info_freelist_req[23]),
		.iENTRY24_VALID(gr_info_freelist_req[24]),
		.iENTRY25_VALID(gr_info_freelist_req[25]),
		.iENTRY26_VALID(gr_info_freelist_req[26]),
		.iENTRY27_VALID(gr_info_freelist_req[27]),
		.iENTRY28_VALID(gr_info_freelist_req[28]),
		.iENTRY29_VALID(gr_info_freelist_req[29]),
		.iENTRY30_VALID(gr_info_freelist_req[30]),
		.iENTRY31_VALID(gr_info_freelist_req[31]),
		.iENTRY32_VALID(gr_info_freelist_req[32]),
		.iENTRY33_VALID(gr_info_freelist_req[33]),
		.iENTRY34_VALID(gr_info_freelist_req[34]),
		.iENTRY35_VALID(gr_info_freelist_req[35]),
		.iENTRY36_VALID(gr_info_freelist_req[36]),
		.iENTRY37_VALID(gr_info_freelist_req[37]),
		.iENTRY38_VALID(gr_info_freelist_req[38]),
		.iENTRY39_VALID(gr_info_freelist_req[39]),
		.iENTRY40_VALID(gr_info_freelist_req[40]),
		.iENTRY41_VALID(gr_info_freelist_req[41]),
		.iENTRY42_VALID(gr_info_freelist_req[42]),
		.iENTRY43_VALID(gr_info_freelist_req[43]),
		.iENTRY44_VALID(gr_info_freelist_req[44]),
		.iENTRY45_VALID(gr_info_freelist_req[45]),
		.iENTRY46_VALID(gr_info_freelist_req[46]),
		.iENTRY47_VALID(gr_info_freelist_req[47]),
		.iENTRY48_VALID(gr_info_freelist_req[48]),
		.iENTRY49_VALID(gr_info_freelist_req[49]),
		.iENTRY50_VALID(gr_info_freelist_req[50]),
		.iENTRY51_VALID(gr_info_freelist_req[51]),
		.iENTRY52_VALID(gr_info_freelist_req[52]),
		.iENTRY53_VALID(gr_info_freelist_req[53]),
		.iENTRY54_VALID(gr_info_freelist_req[54]),
		.iENTRY55_VALID(gr_info_freelist_req[55]),
		.iENTRY56_VALID(gr_info_freelist_req[56]),
		.iENTRY57_VALID(gr_info_freelist_req[57]),
		.iENTRY58_VALID(gr_info_freelist_req[58]),
		.iENTRY59_VALID(gr_info_freelist_req[59]),
		.iENTRY60_VALID(gr_info_freelist_req[60]),
		.iENTRY61_VALID(gr_info_freelist_req[61]),
		.iENTRY62_VALID(gr_info_freelist_req[62]),
		.iENTRY63_VALID(gr_info_freelist_req[63]),
		.oSELECT0_VALID(gr_freelist_0_set_valid),
		.oSELECT0_ENTRY(gr_freelist_0_set_num),
		.oSELECT1_VALID(gr_freelist_1_set_valid),
		.oSELECT1_ENTRY(gr_freelist_1_set_num)
	);



	generate
		for(i = 0; i < 64; i = i + 1)begin : GR_FREELIST_SEARCH
			assign gr_freelist_regist_valid[i[5:0]] = ((((gr_freelist_0_set_num == i[5:0]) & gr_freelist_0_set_valid & ~iOTHER_REGISTER_0_FULL) | 
											((gr_freelist_1_set_num == i) & gr_freelist_1_set_valid & ~iOTHER_REGISTER_1_FULL)))? 1'b1: 1'b0;
		end
	endgenerate

	
											
	/****************************************
	Flag Rename Recycle Management
	****************************************/	
	generate
		//genvar i; //QuartusII Bug
		for(i = 0; i < 16; i = i + 1)begin : FLAGSR_ENTRY
			flag_rename_management #(i[3:0]) FLAGSR_ENTRY (
				.iCLOCK(iCLOCK), 
				.inRESET(inRESET), 
				.iREMOVE_VALID(iFREE_RESERVATIONSTATION),
				//Commit
				.iCOMMIT_VECTOR(iCOMMIT_ENTRY_COMMIT_VECTOR),
				//Regist
				.iREGIST_0_VALID(iPREVIOUS_0_VALID && iPREVIOUS_0_FLAGS_WRITEBACK), 
				.iREGIST_0_FLAGAS_REGNAME(iPREVIOUS_0_FLAGS_REGNAME),
				.iREGIST_0_COMMIT_TAG(iPREVIOUS_0_COMMIT_TAG),
				.iREGIST_1_VALID(iPREVIOUS_1_VALID && iPREVIOUS_1_FLAGS_WRITEBACK),  
				.iREGIST_1_FLAGAS_REGNAME(iPREVIOUS_1_FLAGS_REGNAME),
				.iREGIST_1_COMMIT_TAG(iPREVIOUS_1_COMMIT_TAG),
				.iALU1_VALID(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_FLAGS_WRITEBACK), 
				.iALU1_COMMIT_TAG(iSCHE2_EX_ALU1_COMMIT_TAG),
				.iALU1_FLAGS(iSCHE2_EX_ALU1_FLAG),
				.iALU2_VALID(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_FLAGS_WRITEBACK), 
				.iALU2_COMMIT_TAG(iSCHE2_EX_ALU2_COMMIT_TAG),
				.iALU2_FLAGS(iSCHE2_EX_ALU2_FLAG),
				.iFREELIST_REGIST_VALID(flag_rename_management_freelist_regist_valid[i[3:0]]),
				.oINFO_FREELIST_REQ(flag_rename_management_info_freelist_req[i[3:0]]), 
				.oINFO_FLAGS_VALID(flag_rename_management_info_flags_valid[i[3:0]]), 
				.oINFO_FLAGS(flag_rename_management_info_flags[i[3:0]])
			);
		end
	endgenerate

	

	assign {flag_rename_management_select_1_valid, flag_rename_management_select_1_num,
				flag_rename_management_select_0_valid, flag_rename_management_select_0_num} = 
				func_entry_search16to2(
					flag_rename_management_info_freelist_req[0], flag_rename_management_info_freelist_req[1],
					flag_rename_management_info_freelist_req[2], flag_rename_management_info_freelist_req[3],
					flag_rename_management_info_freelist_req[4], flag_rename_management_info_freelist_req[5],
					flag_rename_management_info_freelist_req[6], flag_rename_management_info_freelist_req[7],
					flag_rename_management_info_freelist_req[8], flag_rename_management_info_freelist_req[9],
					flag_rename_management_info_freelist_req[10], flag_rename_management_info_freelist_req[11],
					flag_rename_management_info_freelist_req[12], flag_rename_management_info_freelist_req[13],
					flag_rename_management_info_freelist_req[14], flag_rename_management_info_freelist_req[15]
				);
	
	
	generate
		//genvar i; //QuartusII Bug
		for(i = 0; i < 16; i = i + 1)begin : FLAG_FREELIST_SEARCH
			assign flag_rename_management_freelist_regist_valid[i[3:0]] = (flag_rename_management_select_0_valid && !iFLAG_REGISTER_0_FULL && flag_rename_management_select_0_num == i[3:0] || 
																						flag_rename_management_select_1_valid && !iFLAG_REGISTER_1_FULL && flag_rename_management_select_1_num == i[3:0]);			//(flag_rename_management_select_valid & ~iFLAG_REGISTER_0_FULL & (flag_rename_management_select_num == i[2:0]))? 1'b1 : 1'b0;
		end
	endgenerate
	
	/****************************************
	System Register
	****************************************/	
	/*
	SPR Register is
	alu3.v
	*/
	
	
	//CPUIDR : Processor ID Register
	system_register CPUIDR (
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(1'b1), 
		.iREGIST_DATA({`PROCESSOR_ID, `PROCESSOR_REVISION}), 
		.oINFO_DATA(w_sysreg_cpuidr_info_data)
	);
								
	//COREIDR : Core ID Register
	system_register COREIDR (
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(1'b1), 
		.iREGIST_DATA(CORE_ID), 
		.oINFO_DATA(w_sysreg_coreidr_info_data)
	);
	
	//TIDR : Task ID Register
	system_register TIDR (
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_tidr_regist_valid), 
		.iREGIST_DATA(w_sysreg_tidr_regist_data), 
		.oINFO_DATA(w_sysreg_tidr_info_data)
	);
								
	assign w_sysreg_tidr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_TIDR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_TIDR) ||
														iFREE_SYSREG_BACK_PREVIOUS;
	assign w_sysreg_tidr_regist_data = (iFREE_SYSREG_BACK_PREVIOUS)? w_sysreg_ptidr_info_data : (
															(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_TIDR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA
														);
	
	
	//FLAGR : Renaming System Register
	
	//PCR : Non Use Register
	
	//SPR : alu3.v Module 
	
	//PSR : Program Status Register
	system_register PSR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_psr_regist_valid), 
		.iREGIST_DATA(w_sysreg_psr_regist_data), 
		.oINFO_DATA(w_sysreg_psr_info_data)
	);
								
	assign w_sysreg_psr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PSR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_PSR) ||
														iFREE_SYSREG_SET_IRQ_MODE || iFREE_SYSREG_BACK_PREVIOUS;
	assign w_sysreg_psr_regist_data = (iFREE_SYSREG_SET_IRQ_MODE)? {w_sysreg_psr_info_data[31:7], 2'h0, w_sysreg_psr_info_data[4:3], 1'b0, w_sysreg_psr_info_data[1:0]} : (
															(iFREE_SYSREG_BACK_PREVIOUS)? w_sysreg_ppsr_info_data : (
																(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PSR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA
															)
														);
	
	//IDTR
	system_register IDTR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_idtr_regist_valid), 
		.iREGIST_DATA(w_sysreg_idtr_regist_data), 
		.oINFO_DATA(w_sysreg_idtr_info_data)
	);
	
	assign w_sysreg_idtr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_IDTR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_IDTR);
	assign w_sysreg_idtr_regist_data = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_IDTR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA;

	
	
	//PDTR : Page Directory Table Register
	system_register PDTR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_pdtr_regist_valid), 
		.iREGIST_DATA(w_sysreg_pdtr_regist_data), 
		.oINFO_DATA(w_sysreg_pdtr_info_data)
	);
	
	assign w_sysreg_pdtr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PDTR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_PDTR) ||
														iFREE_SYSREG_BACK_PREVIOUS;
	assign w_sysreg_pdtr_regist_data = (iFREE_SYSREG_BACK_PREVIOUS)? w_sysreg_ppdtr_info_data : (
															(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PDTR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA
														);

	
	
	//TISR
	system_register TISR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_tisr_regist_valid), 
		.iREGIST_DATA(w_sysreg_tisr_regist_data), 
		.oINFO_DATA(w_sysreg_tisr_info_data)
	);
	
	assign w_sysreg_tisr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_TISR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_TISR);
	assign w_sysreg_tisr_regist_data = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_TISR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA;

	
	//KPDTR
	system_register KPDTR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_kpdtr_regist_valid), 
		.iREGIST_DATA(w_sysreg_kpdtr_regist_data), 
		.oINFO_DATA(w_sysreg_kpdtr_info_data)
	);
	
	assign w_sysreg_kpdtr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_KPDTR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_KPDTR);
	assign w_sysreg_kpdtr_regist_data = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_KPDTR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA;

	
	//IOSR
	system_register IOSR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(iSYSREGINFO_IOSR_VALID), 
		.iREGIST_DATA(iSYSREGINFO_IOSR), 
		.oINFO_DATA(w_sysreg_iosr_info_data)
	);
	
	
	//PPSR : Previous Program Status Register
	system_register PPSR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_ppsr_regist_valid), 
		.iREGIST_DATA(w_sysreg_ppsr_regist_data), 
		.oINFO_DATA(w_sysreg_ppsr_info_data)
	);
								
	assign w_sysreg_ppsr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PPSR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_PPSR) || 
														iFREE_SYSREG_SET_IRQ_MODE;
	assign w_sysreg_ppsr_regist_data = (iFREE_SYSREG_SET_IRQ_MODE)? w_sysreg_psr_info_data : (
															(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PPSR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA
														);
	
	//PPCR : Previous Program Counter
	system_register PPCR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_ppcr_regist_valid), 
		.iREGIST_DATA(w_sysreg_ppcr_regist_data), 
		.oINFO_DATA(w_sysreg_ppcr_info_data)
	);
								
	assign w_sysreg_ppcr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PPCR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_PPCR) ||
														iFREE_SYSREG_SET_IRQ_MODE;
	assign w_sysreg_ppcr_regist_data = (iFREE_SYSREG_SET_IRQ_MODE)? iFREE_CURRENT_PC : (
															(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PPCR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA
														);

	
	//PPDTR : Previous Page Directry Table Register
	system_register PPDTR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_ppdtr_regist_valid), 
		.iREGIST_DATA(w_sysreg_ppdtr_regist_data), 
		.oINFO_DATA(w_sysreg_ppdtr_info_data)
	);
								
	assign w_sysreg_ppdtr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PPDTR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_PPDTR) || 
														iFREE_SYSREG_SET_IRQ_MODE;
	assign w_sysreg_ppdtr_regist_data = (iFREE_SYSREG_SET_IRQ_MODE)? w_sysreg_pdtr_info_data : (
															(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PPDTR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA
														);
	
	//PTIDR : Previous Task Id Register
	system_register PTIDR	(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_ptidr_regist_valid), 
		.iREGIST_DATA(w_sysreg_ptidr_regist_data), 
		.oINFO_DATA(w_sysreg_ptidr_info_data)
	);
								
	assign w_sysreg_ptidr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PTIDR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_PTIDR) || 
														iFREE_SYSREG_SET_IRQ_MODE;
	assign w_sysreg_ptidr_regist_data = (iFREE_SYSREG_SET_IRQ_MODE)? w_sysreg_tidr_info_data : (
															(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_PTIDR)? iSCHE2_EX_ALU1_DATA : iSCHE2_EX_ALU2_DATA
														);
	
	//FRCR
	wire frcr_64bit_write_condition;
	wire [63:0] frcr_64bit_timer;
	assign frcr_64bit_write_condition = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_FRCR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_FRCR);
	frcr_timer FRCR(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iWR_ENA(frcr_64bit_write_condition),
		.iRW_COUNTER({w_sysreg_frchr_info_data, 
		w_sysreg_frclr_info_data}),
		.oCOUNTER(frcr_64bit_timer)
	);
	
	
	//FRCLR
	system_register FRCLR	(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_frclr_regist_valid), 
		.iREGIST_DATA(w_sysreg_frclr_regist_data), 
		.oINFO_DATA(w_sysreg_frclr_info_data)
	);

	
	assign w_sysreg_frclr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_FRCLR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_FRCLR) ||
														(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_FRCR2FRCXR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_FRCR2FRCXR);
														
	assign w_sysreg_frclr_regist_data = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_FRCLR)? iSCHE2_EX_ALU1_DATA : (
															(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_FRCLR)? iSCHE2_EX_ALU2_DATA : (
																frcr_64bit_timer[31:0]
															)
														);
	//FRCHR
	system_register FRCHR	(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),
		.iREGIST_DATA_VALID(w_sysreg_frchr_regist_valid), 
		.iREGIST_DATA(w_sysreg_frchr_regist_data), 
		.oINFO_DATA(w_sysreg_frchr_info_data)
	);
	
	assign w_sysreg_frchr_regist_valid = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_FRCHR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_FRCHR) || 
														(iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_FRCR2FRCXR) || 
														(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_FRCR2FRCXR);
	
	assign w_sysreg_frchr_regist_data = (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == `SYSREG_FRCHR)? iSCHE2_EX_ALU1_DATA : (
															(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == `SYSREG_FRCHR)? iSCHE2_EX_ALU2_DATA : (
																frcr_64bit_timer[63:32]
															)
														);

	/****************************************
	General-Purpose Register
	****************************************/	
	generate
		//genvar i; //QuartusII Bug
		for(i = 0; i < 64; i = i + 1)begin : GR_ENTRY
			scheduler2_gr #(i[5:0]) GR_ENTRY(
				//System
				.iCLOCK(iCLOCK), 
				.inRESET(inRESET), 
				.iFREE_RESTART(iFREE_RESTART),
				//Commit
				.iCOMMIT_VECTOR(iCOMMIT_ENTRY_COMMIT_VECTOR),
				//Register
				.iREGIST_0_VALID(iPREVIOUS_0_VALID & iPREVIOUS_0_WRITEBACK && !iPREVIOUS_0_DESTINATION_SYSREG & !this_lock), 
				.iREGIST_0_DESTINATION_REGNAME(iPREVIOUS_0_DESTINATION_REGNAME), 
				.iREGIST_0_LOGIC_DESTINATION(iPREVIOUS_0_LOGIC_DESTINATION), 
				.iREGIST_0_COMMIT_TAG(iPREVIOUS_0_COMMIT_TAG), 
				.iREGIST_1_VALID(iPREVIOUS_1_VALID & iPREVIOUS_1_WRITEBACK && !iPREVIOUS_1_DESTINATION_SYSREG && !this_lock), 
				.iREGIST_1_DESTINATION_REGNAME(iPREVIOUS_1_DESTINATION_REGNAME), 
				.iREGIST_1_LOGIC_DESTINATION(iPREVIOUS_1_LOGIC_DESTINATION), 
				.iREGIST_1_COMMIT_TAG(iPREVIOUS_1_COMMIT_TAG),
				//ExEND
				.iEXEND_ADDER_VALID(iSCHE2_EX_ALU1_VALID & iSCHE2_EX_ALU1_WRITEBACK && !iSCHE2_EX_ALU1_DESTINATION_SYSREG), 
				.iEXEND_ADDER_COMMIT_TAG(iSCHE2_EX_ALU1_COMMIT_TAG), 
				.iEXEND_ADDER_REGNAME(iSCHE2_EX_ALU1_DESTINATION_REGNAME), 
				.iEXEND_ADDER_DATA(iSCHE2_EX_ALU1_DATA),
				.iEXEND_MULDIV_VALID(iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_WRITEBACK && !iSCHE2_EX_ALU2_DESTINATION_SYSREG), 
				.iEXEND_MULDIV_COMMIT_TAG(iSCHE2_EX_ALU2_COMMIT_TAG), 
				.iEXEND_MULDIV_REGNAME(iSCHE2_EX_ALU2_DESTINATION_REGNAME), 
				.iEXEND_MULDIV_DATA(iSCHE2_EX_ALU2_DATA),
				.iEXEND_LDST_VALID(iSCHE2_ALU3_VALID && iSCHE2_ALU3_WRITEBACK && !iSCHE2_ALU3_DESTINATION_SYSREG), 
				.iEXEND_LDST_COMMIT_TAG(iSCHE2_ALU3_COMMIT_TAG), 
				.iEXEND_LDST_REGNAME(iSCHE2_ALU3_DESTINATION_REGNAME), 
				.iEXEND_LDST_DATA(iSCHE2_ALU3_DATA),
				//Freelist - Info
				.iFREELIST_REGIST_VALID(gr_freelist_regist_valid[i[5:0]]),
				.oINFO_FREELIST_REQ(gr_info_freelist_req[i[5:0]]), 
				.oINFO_DATA_VALID(gr_info_data_valid[i]), 
				.oINFO_DATA(gr_info_data[i[5:0]])
			);
		end
	endgenerate
	

	/********************************************************************************
	Register Set
	********************************************************************************/			
	//Flags Select
	wire w_register_mix_prev0_flags_valid;
	wire [4:0] w_register_mix_prev0_flags;			
	wire w_register_mix_prev1_flags_valid;
	wire [4:0] w_register_mix_prev1_flags;	

	assign {w_register_mix_prev0_flags_valid, w_register_mix_prev0_flags} = func_flags_set(
																							iPREVIOUS_0_VALID && iPREVIOUS_0_SOURCE0_FLAGS, 
																							iPREVIOUS_0_SOURCE0[3:0], 
																							flag_rename_management_info_flags_valid[iPREVIOUS_0_SOURCE0[3:0]],
																							flag_rename_management_info_flags[iPREVIOUS_0_SOURCE0[3:0]]
																						);
																						
	assign {w_register_mix_prev1_flags_valid, w_register_mix_prev1_flags} = func_flags_set(
																							iPREVIOUS_1_VALID && iPREVIOUS_1_SOURCE0_FLAGS, 
																							iPREVIOUS_1_SOURCE0[3:0], 
																							flag_rename_management_info_flags_valid[iPREVIOUS_1_SOURCE0[3:0]],
																							flag_rename_management_info_flags[iPREVIOUS_1_SOURCE0[3:0]]
																						);
	
	
	
	function [5:0] func_flags_set;
		input func_use_flag_active;
		input [3:0] func_flag_regname;
		//Flag Register
		input func_flag_valid;
		input [4:0] func_flags;
		begin
			if(func_use_flag_active)begin
				if(func_flag_valid)begin
					func_flags_set = {1'b1, func_flags};
				end
				else begin
					func_flags_set = {2'h0, func_flag_regname};
				end
			end
			else begin
				func_flags_set = {2'h0, func_flag_regname};
			end
		end
	endfunction
	
	
	//System Register Select
	wire w_sys_register_mix_previous0_source0_valid;
	wire [31:0] w_sys_register_mix_previous0_source0;
	wire w_sys_register_mix_previous0_source1_valid;
	wire [31:0] w_sys_register_mix_previous0_source1;
	wire w_sys_register_mix_previous1_source0_valid;
	wire [31:0] w_sys_register_mix_previous1_source0;
	wire w_sys_register_mix_previous1_source1_valid;
	wire [31:0] w_sys_register_mix_previous1_source1;	
	assign {w_sys_register_mix_previous0_source0_valid, w_sys_register_mix_previous0_source0} = func_sysreg_set(
																										iPREVIOUS_0_SOURCE0_ACTIVE,
																										iPREVIOUS_0_SOURCE0[4:0], 
																										w_sysreg_cpuidr_info_data,
																										w_sysreg_coreidr_info_data,
																										w_sysreg_tidr_info_data,
																										iPREVIOUS_PC - 32'h4,
																										w_sysreg_psr_info_data,
																										w_sysreg_idtr_info_data,
																										w_sysreg_pdtr_info_data,
																										w_sysreg_tisr_info_data,
																										w_sysreg_kpdtr_info_data,
																										w_sysreg_iosr_info_data,
																										w_sysreg_ppsr_info_data,
																										w_sysreg_ppcr_info_data,
																										w_sysreg_ppdtr_info_data,
																										w_sysreg_ptidr_info_data,
																										w_sysreg_frclr_info_data,
																										w_sysreg_frchr_info_data																									
																									);
	assign {w_sys_register_mix_previous0_source1_valid, w_sys_register_mix_previous0_source1} = func_sysreg_set(
																										iPREVIOUS_0_SOURCE1_ACTIVE,
																										iPREVIOUS_0_SOURCE1[4:0], 
																										w_sysreg_cpuidr_info_data,
																										w_sysreg_coreidr_info_data,
																										w_sysreg_tidr_info_data,
																										iPREVIOUS_PC - 32'h4,
																										w_sysreg_psr_info_data,
																										w_sysreg_idtr_info_data,
																										w_sysreg_pdtr_info_data,
																										w_sysreg_tisr_info_data,
																										w_sysreg_kpdtr_info_data,
																										w_sysreg_iosr_info_data,
																										w_sysreg_ppsr_info_data,
																										w_sysreg_ppcr_info_data,
																										w_sysreg_ppdtr_info_data,
																										w_sysreg_ptidr_info_data,
																										w_sysreg_frclr_info_data,
																										w_sysreg_frchr_info_data
																									);
	assign {w_sys_register_mix_previous1_source0_valid, w_sys_register_mix_previous1_source0} = func_sysreg_set(
																										iPREVIOUS_1_SOURCE0_ACTIVE,
																										iPREVIOUS_1_SOURCE0[4:0], 
																										w_sysreg_cpuidr_info_data,
																										w_sysreg_coreidr_info_data,
																										w_sysreg_tidr_info_data,
																										iPREVIOUS_PC,
																										w_sysreg_psr_info_data,
																										w_sysreg_idtr_info_data,
																										w_sysreg_pdtr_info_data,
																										w_sysreg_tisr_info_data,
																										w_sysreg_kpdtr_info_data,
																										w_sysreg_iosr_info_data,
																										w_sysreg_ppsr_info_data,
																										w_sysreg_ppcr_info_data,
																										w_sysreg_ppdtr_info_data,
																										w_sysreg_ptidr_info_data,
																										w_sysreg_frclr_info_data,
																										w_sysreg_frchr_info_data
																									);
	assign {w_sys_register_mix_previous1_source1_valid, w_sys_register_mix_previous1_source1} = func_sysreg_set(
																										iPREVIOUS_1_SOURCE1_ACTIVE,
																										iPREVIOUS_1_SOURCE1[4:0], 
																										w_sysreg_cpuidr_info_data,
																										w_sysreg_coreidr_info_data,
																										w_sysreg_tidr_info_data,
																										iPREVIOUS_PC,
																										w_sysreg_psr_info_data,
																										w_sysreg_idtr_info_data,
																										w_sysreg_pdtr_info_data,
																										w_sysreg_tisr_info_data,
																										w_sysreg_kpdtr_info_data,
																										w_sysreg_iosr_info_data,
																										w_sysreg_ppsr_info_data,
																										w_sysreg_ppcr_info_data,
																										w_sysreg_ppdtr_info_data,
																										w_sysreg_ptidr_info_data,
																										w_sysreg_frclr_info_data,
																										w_sysreg_frchr_info_data
																									);
	
	function [32:0] func_sysreg_set;
		//Active
		input func_active;
		//Select
		input [4:0] func_sysreg;
		//Sysreg
		input [31:0] func_cpuidr;
		input [31:0] func_coreidr;
		input [31:0] func_tidr;
		input [31:0] func_pcr;
		input [31:0] func_sr1;
		input [31:0] func_idtr;
		input [31:0] func_pdtr;
		input [31:0] func_tisr;
		input [31:0] func_kpdtr;
		input [31:0] func_iosr;	
		input [31:0] func_ppsr;	
		input [31:0] func_ppcr;	
		input [31:0] func_ppdtr;
		input [31:0] func_ptidr;
		input [31:0] func_frclr;
		input [31:0] func_frchr;
		begin
			if(func_active)begin
				case(func_sysreg)
					`SYSREG_CPUIDR : func_sysreg_set = {1'b1, func_cpuidr};
					`SYSREG_COREIDR : func_sysreg_set = {1'b1, func_coreidr};
					`SYSREG_TIDR : func_sysreg_set = {1'b1, func_tidr};
					//`SYSREG_FLAGR		Non Use
					`SYSREG_PCR : func_sysreg_set = {1'b1, func_pcr};
					`SYSREG_SPR : func_sysreg_set = {1'b0, 27'h0, func_sysreg};	//Non Match (ALU3 Module)
					`SYSREG_PSR : func_sysreg_set = {1'b1, func_sr1};
					`SYSREG_IDTR : func_sysreg_set = {1'b1, func_idtr};
					`SYSREG_PDTR : func_sysreg_set = {1'b1, func_pdtr};
					`SYSREG_TISR : func_sysreg_set = {1'b1, func_tisr};
					`SYSREG_KPDTR : func_sysreg_set = {1'b1, func_kpdtr};
					`SYSREG_IOSR : func_sysreg_set = {1'b1, func_iosr};
					`SYSREG_PPSR : func_sysreg_set = {1'b1, func_ppsr};
					`SYSREG_PPCR : func_sysreg_set = {1'b1, func_ppcr};
					`SYSREG_PPDTR : func_sysreg_set = {1'b1, func_ppdtr};
					`SYSREG_PTIDR : func_sysreg_set = {1'b1, func_ptidr};
					`SYSREG_FRCLR : func_sysreg_set = {1'b1, func_frclr};
					`SYSREG_FRCHR : func_sysreg_set = {1'b1, func_frchr};
					default	:
						begin
							//$display("[ERROR] PCR : %x, scheduling2.v func_sysreg_set error", iPREVIOUS_PC);
							func_sysreg_set = {1'b0, 32'h0};
						end
				endcase
			end
			else begin
				func_sysreg_set = {1'b0, 27'h0, func_sysreg};	
			end
		end
	endfunction
							
	
	//General Register Select
	wire w_register_mix_previous0_source0_valid;
	wire [31:0] w_register_mix_previous0_source0;
	wire w_register_mix_previous0_source1_valid;
	wire [31:0] w_register_mix_previous0_source1;
	wire w_register_mix_previous1_source0_valid;
	wire [31:0] w_register_mix_previous1_source0;
	wire w_register_mix_previous1_source1_valid;
	wire [31:0] w_register_mix_previous1_source1;
	assign {w_register_mix_previous0_source0_valid, w_register_mix_previous0_source0} = (iPREVIOUS_0_SOURCE0_ACTIVE && (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && !iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == iPREVIOUS_0_SOURCE0[5:0] || 
																									iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_WRITEBACK && !iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == iPREVIOUS_0_SOURCE0[5:0] || 
																									iSCHE2_ALU3_VALID && !iSCHE2_ALU3_DESTINATION_SYSREG && iSCHE2_ALU3_WRITEBACK && iSCHE2_ALU3_DESTINATION_REGNAME == iPREVIOUS_0_SOURCE0[5:0]))? 
																									{1'b0, iPREVIOUS_0_SOURCE0}
																									: func_gr_set(1'b0, iPREVIOUS_0_SOURCE0, iPREVIOUS_0_SOURCE0_ACTIVE, iPREVIOUS_0_SOURCE0_SYSREG, gr_info_data_valid[iPREVIOUS_0_SOURCE0[5:0]], gr_info_data[iPREVIOUS_0_SOURCE0[5:0]], iPREVIOUS_1_VALID & iPREVIOUS_1_WRITEBACK, iPREVIOUS_1_DESTINATION_REGNAME);

	assign {w_register_mix_previous0_source1_valid, w_register_mix_previous0_source1} = (iPREVIOUS_0_SOURCE1_ACTIVE && !iPREVIOUS_0_SOURCE1_IMM && (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && !iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == iPREVIOUS_0_SOURCE1[5:0] || 
																									iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_WRITEBACK && !iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == iPREVIOUS_0_SOURCE1[5:0] || 
																									iSCHE2_ALU3_VALID && !iSCHE2_ALU3_DESTINATION_SYSREG && iSCHE2_ALU3_WRITEBACK && iSCHE2_ALU3_DESTINATION_REGNAME == iPREVIOUS_0_SOURCE1[5:0]))? 
																									{1'b0, iPREVIOUS_0_SOURCE1}
																									: func_gr_set(iPREVIOUS_0_SOURCE1_IMM, iPREVIOUS_0_SOURCE1, iPREVIOUS_0_SOURCE1_ACTIVE, iPREVIOUS_0_SOURCE1_SYSREG, gr_info_data_valid[iPREVIOUS_0_SOURCE1[5:0]], gr_info_data[iPREVIOUS_0_SOURCE1[5:0]], iPREVIOUS_1_VALID & iPREVIOUS_1_WRITEBACK, iPREVIOUS_1_DESTINATION_REGNAME);
	
	assign {w_register_mix_previous1_source0_valid, w_register_mix_previous1_source0} = (iPREVIOUS_1_SOURCE0_ACTIVE && (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && !iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == iPREVIOUS_1_SOURCE0[5:0] || 
																									iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_WRITEBACK && !iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == iPREVIOUS_1_SOURCE0[5:0] || 
																									iSCHE2_ALU3_VALID && !iSCHE2_ALU3_DESTINATION_SYSREG && iSCHE2_ALU3_WRITEBACK && iSCHE2_ALU3_DESTINATION_REGNAME == iPREVIOUS_1_SOURCE0[5:0]))? 
																									{1'b0, iPREVIOUS_1_SOURCE0}
																									: func_gr_set(1'b0, iPREVIOUS_1_SOURCE0, iPREVIOUS_1_SOURCE0_ACTIVE, iPREVIOUS_1_SOURCE0_SYSREG, gr_info_data_valid[iPREVIOUS_1_SOURCE0[5:0]], gr_info_data[iPREVIOUS_1_SOURCE0[5:0]], 1'b0, {32{1'b0}});
	
	assign {w_register_mix_previous1_source1_valid, w_register_mix_previous1_source1} = (iPREVIOUS_1_SOURCE1_ACTIVE && !iPREVIOUS_1_SOURCE1_IMM && (iSCHE2_EX_ALU1_VALID && iSCHE2_EX_ALU1_WRITEBACK && !iSCHE2_EX_ALU1_DESTINATION_SYSREG && iSCHE2_EX_ALU1_DESTINATION_REGNAME == iPREVIOUS_1_SOURCE1[5:0] || 
																									iSCHE2_EX_ALU2_VALID && iSCHE2_EX_ALU2_WRITEBACK && !iSCHE2_EX_ALU2_DESTINATION_SYSREG && iSCHE2_EX_ALU2_DESTINATION_REGNAME == iPREVIOUS_1_SOURCE1[5:0] || 
																									iSCHE2_ALU3_VALID && !iSCHE2_ALU3_DESTINATION_SYSREG && iSCHE2_ALU3_WRITEBACK && iSCHE2_ALU3_DESTINATION_REGNAME == iPREVIOUS_1_SOURCE1[5:0]))? 
																									{1'b0, iPREVIOUS_1_SOURCE1}
																									: func_gr_set(iPREVIOUS_1_SOURCE1_IMM, iPREVIOUS_1_SOURCE1, iPREVIOUS_1_SOURCE1_ACTIVE, iPREVIOUS_1_SOURCE1_SYSREG, gr_info_data_valid[iPREVIOUS_1_SOURCE1[5:0]], gr_info_data[iPREVIOUS_1_SOURCE1[5:0]], 1'b0, {32{1'b0}});



	function [32:0] func_gr_set;
		input func_gr_mix_sourve_imm;
		input [31:0] func_gr_mix_source;
		input func_gr_mix_active;
		input func_gr_mix_sysreg;
		input func_gr_mix_gr_data_valid;
		input [31:0] func_gr_mix_gr_data;
		input func_gr_mix_former_destination_valid;
		input [31:0] func_gr_mix_former_destination;
		begin
			if(!func_gr_mix_sysreg)begin
				if(func_gr_mix_active)begin
					if(func_gr_mix_sourve_imm)begin
						func_gr_set = {1'b1, func_gr_mix_source};
					end
					//koko okasii
					//else if(func_gr_mix_gr_data_valid & !(func_gr_mix_source == func_gr_mix_former_source & func_gr_mix_former_active & !func_gr_mix_former_sysreg))begin
					else if(func_gr_mix_gr_data_valid & !(func_gr_mix_source == func_gr_mix_former_destination & func_gr_mix_former_destination_valid))begin
						func_gr_set = {1'b1, func_gr_mix_gr_data};
					end
					else begin
						func_gr_set = {1'b0, func_gr_mix_source};
					end
				end
				else begin
					func_gr_set = {1'b1, {32{1'b0}}};
				end
			end
			else begin
				func_gr_set = {1'b0, func_gr_mix_source};
			end
		end
	endfunction
	
		
	assign w_register_mix_prev0_source0_valid = (iPREVIOUS_0_SOURCE0_SYSREG && !iPREVIOUS_0_SOURCE0_SYSREG_RENAME)? w_sys_register_mix_previous0_source0_valid : w_register_mix_previous0_source0_valid;
	assign w_register_mix_prev0_source0 = (iPREVIOUS_0_SOURCE0_SYSREG && !iPREVIOUS_0_SOURCE0_SYSREG_RENAME)? w_sys_register_mix_previous0_source0 : w_register_mix_previous0_source0;
	assign w_register_mix_prev0_source1_valid = (iPREVIOUS_0_SOURCE1_SYSREG && !iPREVIOUS_0_SOURCE1_SYSREG_RENAME)? w_sys_register_mix_previous0_source1_valid : w_register_mix_previous0_source1_valid;
	assign w_register_mix_prev0_source1 = (iPREVIOUS_0_SOURCE1_SYSREG && !iPREVIOUS_0_SOURCE1_SYSREG_RENAME)? w_sys_register_mix_previous0_source1 : w_register_mix_previous0_source1;
	assign w_register_mix_prev1_source0_valid = (iPREVIOUS_1_SOURCE0_SYSREG && !iPREVIOUS_1_SOURCE0_SYSREG_RENAME)? w_sys_register_mix_previous1_source0_valid : w_register_mix_previous1_source0_valid;
	assign w_register_mix_prev1_source0 = (iPREVIOUS_1_SOURCE0_SYSREG && !iPREVIOUS_1_SOURCE0_SYSREG_RENAME)? w_sys_register_mix_previous1_source0 : w_register_mix_previous1_source0;
	assign w_register_mix_prev1_source1_valid = (iPREVIOUS_1_SOURCE1_SYSREG && !iPREVIOUS_1_SOURCE1_SYSREG_RENAME)? w_sys_register_mix_previous1_source1_valid : w_register_mix_previous1_source1_valid;
	assign w_register_mix_prev1_source1 = (iPREVIOUS_1_SOURCE1_SYSREG && !iPREVIOUS_1_SOURCE1_SYSREG_RENAME)? w_sys_register_mix_previous1_source1 : w_register_mix_previous1_source1;
			

	/********************************************************************************
	Reservation Station Regist Control
	********************************************************************************/	
	wire rs0_0_regist_valid;
	wire rs1_0_regist_valid;
	wire rs2_0_regist_valid;
	wire rs3_0_regist_valid;
	wire rs0_1_regist_valid;
	wire rs1_1_regist_valid;
	wire rs2_1_regist_valid;
	wire rs3_1_regist_valid;
	
	//regist_rbuffer_select RB_SELECT(
	scheduler2_allocate_rsv_station RB_SELECT(
		.iORDER_LOCK(this_lock),
		.iORDER_0_VALID(iPREVIOUS_0_VALID),
		.iORDER_0_EX_SYS_REG(iPREVIOUS_0_EX_SYS_REG),	
		.iORDER_0_EX_SYS_LDST(iPREVIOUS_0_EX_SYS_LDST),		
		.iORDER_0_EX_LOGIC(iPREVIOUS_0_EX_LOGIC),
		.iORDER_0_EX_SHIFT(iPREVIOUS_0_EX_SHIFT),
		.iORDER_0_EX_ADDER(iPREVIOUS_0_EX_ADDER),
		.iORDER_0_EX_MUL(iPREVIOUS_0_EX_MUL),
		.iORDER_0_EX_SDIV(iPREVIOUS_0_EX_SDIV),
		.iORDER_0_EX_UDIV(iPREVIOUS_0_EX_UDIV),
		.iORDER_0_EX_LDST(iPREVIOUS_0_EX_LDST),
		.iORDER_0_EX_BRANCH(iPREVIOUS_0_EX_BRANCH),
		.iORDER_1_VALID(iPREVIOUS_1_VALID),
		.iORDER_1_EX_SYS_REG(iPREVIOUS_1_EX_SYS_REG),	
		.iORDER_1_EX_SYS_LDST(iPREVIOUS_1_EX_SYS_LDST),		
		.iORDER_1_EX_LOGIC(iPREVIOUS_1_EX_LOGIC),
		.iORDER_1_EX_SHIFT(iPREVIOUS_1_EX_SHIFT),
		.iORDER_1_EX_ADDER(iPREVIOUS_1_EX_ADDER),
		.iORDER_1_EX_MUL(iPREVIOUS_1_EX_MUL),
		.iORDER_1_EX_SDIV(iPREVIOUS_1_EX_SDIV),
		.iORDER_1_EX_UDIV(iPREVIOUS_1_EX_UDIV),
		.iORDER_1_EX_LDST(iPREVIOUS_1_EX_LDST),
		.iORDER_1_EX_BRANCH(iPREVIOUS_1_EX_BRANCH),
		//RS-INFO
		.iRS1_COUNT(rs_alu1_regist_possible_count),
		.iRS2_COUNT(rs_alu2_regist_possible_count),
		//Output
		.oRS0_0_VALID(rs0_0_regist_valid),
		.oRS1_0_VALID(rs1_0_regist_valid),
		.oRS2_0_VALID(rs2_0_regist_valid),
		.oRS3_0_VALID(rs3_0_regist_valid),
		.oRS0_1_VALID(rs0_1_regist_valid),
		.oRS1_1_VALID(rs1_1_regist_valid),
		.oRS2_1_VALID(rs2_1_regist_valid),
		.oRS3_1_VALID(rs3_1_regist_valid)
	);
	

	/********************************************************************************
	Exe-Port0 Branch Reservation Station
	********************************************************************************/	
	//Regist Enable wire
	wire rs_alu0_0_reg_valid;
	wire rs_alu0_1_reg_valid;
	assign rs_alu0_0_reg_valid = !rs_branch_lock & iPREVIOUS_0_VALID & iPREVIOUS_0_EX_BRANCH;
	assign rs_alu0_1_reg_valid = !rs_branch_lock & iPREVIOUS_1_VALID & iPREVIOUS_1_EX_BRANCH;
	//Regist Pointer Offset
	wire [1:0] w_rs_alu0_reg_offset;
	assign w_rs_alu0_reg_offset = rs_alu0_0_reg_valid + rs_alu0_1_reg_valid;
	//Execution Enable wire
	assign rs_branch_exout_all_valid = !iNEXT_EX_BRANCH_LOCK & (rs_alu0_exout_valid[0] || rs_alu0_exout_valid[1] || rs_alu0_exout_valid[2] || rs_alu0_exout_valid[3] ||
												rs_alu0_exout_valid[4] || rs_alu0_exout_valid[5] || rs_alu0_exout_valid[6] || rs_alu0_exout_valid[7]);
		
	//Counter				
	wire [2:0] w_rs_branch_exe_pointer;
	wire [2:0] w_rs_alu0_reg_pointer;
	reg [3:0] b0_rs_branch_exe_pointer;
	reg [3:0] b0_rs_branch_reg_pointer;
	assign w_rs_branch_exe_pointer = b0_rs_branch_exe_pointer[2:0];
	assign w_rs_alu0_reg_pointer = b0_rs_branch_reg_pointer[2:0];

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_rs_branch_exe_pointer <= {4{1'b0}};
			b0_rs_branch_reg_pointer <= {4{1'b0}};
		end
		else if(iFREE_RESTART)begin
			b0_rs_branch_exe_pointer <= {4{1'b0}};
			b0_rs_branch_reg_pointer <= {4{1'b0}};
		end
		else begin
			b0_rs_branch_reg_pointer <= b0_rs_branch_reg_pointer + {2'h0, w_rs_alu0_reg_offset};
			if(!iNEXT_EX_BRANCH_LOCK)begin
				b0_rs_branch_exe_pointer <= b0_rs_branch_exe_pointer + {3'h0, rs_branch_exout_all_valid}; 
			end
		end
	end

	//Lock 
	assign rs_branch_lock = (b0_rs_branch_reg_pointer - b0_rs_branch_exe_pointer == 4'h8)? 1'b1 : 1'b0;

	
	generate
		//genvar i; //QuartusII Bug
		for(i = 0; i < 8; i = i + 1)begin : RS_ALU0
			reservation_alu0_entry RS_ALU0	(
				.iCLOCK(iCLOCK), 
				.inRESET(inRESET), 
				.iREMOVE_VALID(iFREE_RESERVATIONSTATION),
				.iREGIST_VALID(rs_alu0_regist_valid[i[2:0]]), 
				.iREGIST_CMD(rs_alu0_regist_cmd[i[2:0]]), 
				.iREGIST_CC(rs_alu0_regist_cc[i[2:0]]), 
				.iREGIST_FLAGS_VALID(rs_alu0_regist_flag_valid[i[2:0]]), 
				.iREGIST_FLAGS(rs_alu0_regist_flag[i[2:0]]), 
				.iREGIST_SOURCE1_VALID(rs_alu0_regist_source1_valid[i[2:0]]), 
				.iREGIST_SOURCE1(rs_alu0_regist_source1[i[2:0]]), 
				.iREGIST_PC(rs_alu0_regist_pc[i[2:0]]), 
				.iREGIST_DESTINATION_REGNAME(rs_alu0_regist_destination_regname[i[2:0]]),
				.iREGIST_COMMIT_TAG(rs_alu0_regist_commit_tag[i[2:0]]),
				.iREGIST_EX_REGIST_POINTER(rs_alu0_regist_ex_inorder_regist_pointer[i[2:0]]),
				//CDB
				.iALU1_VALID(iSCHE2_EX_ALU1_VALID && !iSCHE2_EX_ALU1_DESTINATION_SYSREG), 
				.iALU1_FLAGS_OPT_VALID(iSCHE2_EX_ALU1_FLAGS_WRITEBACK),
				.iALU1_FLAGS_REGNAME(iSCHE2_EX_ALU1_FLAGS_REGNAME),
				.iALU1_DESTINATION_REGNAME(iSCHE2_EX_ALU1_DESTINATION_REGNAME), 
				.iALU1_WRITEBACK(iSCHE2_EX_ALU1_WRITEBACK), 
				.iALU1_DATA(iSCHE2_EX_ALU1_DATA), 
				.iALU1_FLAGS(iSCHE2_EX_ALU1_FLAG),
				.iALU2_VALID(iSCHE2_EX_ALU2_VALID && !iSCHE2_EX_ALU2_DESTINATION_SYSREG), 
				.iALU2_FLAGS_OPT_VALID(iSCHE2_EX_ALU2_FLAGS_WRITEBACK),
				.iALU2_FLAGS_REGNAME(iSCHE2_EX_ALU2_FLAGS_REGNAME), 
				.iALU2_DESTINATION_REGNAME(iSCHE2_EX_ALU2_DESTINATION_REGNAME), 
				.iALU2_WRITEBACK(iSCHE2_EX_ALU2_WRITEBACK), 
				.iALU2_DATA(iSCHE2_EX_ALU2_DATA), 
				.iALU2_FLAGS(iSCHE2_EX_ALU2_FLAG), 
				.iALU3_VALID(iSCHE2_ALU3_VALID && iSCHE2_ALU3_WRITEBACK && !iSCHE2_ALU3_DESTINATION_SYSREG ), 
				.iALU3_DESTINATION_REGNAME(iSCHE2_ALU3_DESTINATION_REGNAME), 
				.iALU3_DATA(iSCHE2_ALU3_DATA),
				//EX Pointer
				.iEX_EXECUTION_POINTER(w_ex_inorder_execution_pointer),
				//Execution Flag
				.iEXOUT_VALID(rs_alu0_exout_valid[i[2:0]] & !iNEXT_EX_BRANCH_LOCK), 
				//Infomation
				.oINFO_ENTRY_VALID(rs_alu0_info_entry_valid[i[2:0]]), 
				.oINFO_MATCHING(rs_alu0_info_matching[i[2:0]]), 
				.oINFO_CMD(rs_alu0_info_cmd[i[2:0]]), 
				.oINFO_CC(rs_alu0_info_cc[i[2:0]]), 
				.oINFO_FLAG_VALID(rs_alu0_info_flag_valid[i[2:0]]), 
				.oINFO_FLAG(rs_alu0_info_flag[i[2:0]]), 
				.oINFO_SOURCE1_VALID(rs_alu0_info_source1_valid[i[2:0]]), 
				.oINFO_SOURCE1(rs_alu0_info_source1[i[2:0]]), 
				.oINFO_PC(rs_alu0_info_pc[i[2:0]]),
				.oINFO_DESTINATION_REGNAME(rs_alu0_info_destination_regname[i[2:0]]), 
				.oINFO_COMMIT_TAG(rs_alu0_info_commit_tag[i[2:0]])
			);
		end
	endgenerate
	

	generate
		for(i = 0; i < 8; i = i + 1)begin : ALU0_RB_CONTROL
			//---Verilog Syntax Bug
			wire [2:0] gen_alu0_reg_pointer_0 = w_rs_alu0_reg_pointer;
			wire [2:0] gen_alu0_reg_pointer_1 = w_rs_alu0_reg_pointer + 3'h1;
			//---Verilog Syntax Bug End
			//Regist
			assign rs_alu0_regist_valid[i[2:0]] = (rs_alu0_0_reg_valid & rs_alu0_1_reg_valid & (w_rs_alu0_reg_pointer == i[2:0] || w_rs_alu0_reg_pointer + 3'h1 == i[2:0])) || ((rs_alu0_0_reg_valid || rs_alu0_1_reg_valid) & w_rs_alu0_reg_pointer == i[2:0]);
			assign rs_alu0_regist_cmd[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? iPREVIOUS_0_CMD : iPREVIOUS_1_CMD;
			assign rs_alu0_regist_cc[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? iPREVIOUS_0_CC_AFE : iPREVIOUS_1_CC_AFE;
			assign rs_alu0_regist_flag_valid[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? w_register_mix_prev0_flags_valid : w_register_mix_prev1_flags_valid;
			assign rs_alu0_regist_flag[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? w_register_mix_prev0_flags : w_register_mix_prev1_flags;
			assign rs_alu0_regist_source1_valid[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? w_register_mix_prev0_source1_valid : w_register_mix_prev1_source1_valid;
			assign rs_alu0_regist_source1[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? w_register_mix_prev0_source1 : w_register_mix_prev1_source1;
			assign rs_alu0_regist_pc[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? iPREVIOUS_PC : iPREVIOUS_PC + 32'h4;
			assign rs_alu0_regist_destination_regname[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? iPREVIOUS_0_DESTINATION_REGNAME : iPREVIOUS_1_DESTINATION_REGNAME;
			assign rs_alu0_regist_commit_tag[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? iPREVIOUS_0_COMMIT_TAG : iPREVIOUS_1_COMMIT_TAG;
			assign rs_alu0_regist_ex_inorder_regist_pointer[i[2:0]] = (func_alu0_rs_regist_select(rs_alu0_0_reg_valid, rs_alu0_1_reg_valid, i[2:0], w_rs_alu0_reg_pointer))? w_ex_0_inorder_regist_pointer : w_ex_1_inorder_regist_pointer;
		end
	endgenerate
	

	function func_alu0_rs_regist_select;
		input func_branch_rs_regist_select_0_reg_valid;
		input func_branch_rs_regist_select_1_reg_valid;
		input [2:0] func_branch_rs_regist_select_entry_id;
		input [2:0] func_branch_rs_regist_select_counter;
		begin
			if(func_branch_rs_regist_select_0_reg_valid & func_branch_rs_regist_select_1_reg_valid)begin
				if(func_branch_rs_regist_select_entry_id == func_branch_rs_regist_select_counter)begin
					func_alu0_rs_regist_select = 1'b1;
				end
				else begin
					func_alu0_rs_regist_select = 1'b0;
				end
			end
			else if(func_branch_rs_regist_select_0_reg_valid)begin
				if(func_branch_rs_regist_select_entry_id == func_branch_rs_regist_select_counter)begin
					func_alu0_rs_regist_select = 1'b1;
				end
				else begin
					func_alu0_rs_regist_select = 1'b0;
				end
			end
			else if(func_branch_rs_regist_select_1_reg_valid)begin
				if(func_branch_rs_regist_select_entry_id == func_branch_rs_regist_select_counter)begin
					func_alu0_rs_regist_select = 1'b0;
				end
				else begin
					func_alu0_rs_regist_select = 1'b1;
				end
			end
			else begin
				func_alu0_rs_regist_select = 1'b0;
			end
		end
	endfunction
	
	//Execution Output Signal
	assign rs_alu0_exout_valid[0] =	(w_rs_branch_exe_pointer == 3'h0 & rs_alu0_info_matching[0] & !iNEXT_EX_BRANCH_LOCK)? 1'b1 : 1'b0;
	assign rs_alu0_exout_valid[1] = (w_rs_branch_exe_pointer == 3'h1 & rs_alu0_info_matching[1] & !iNEXT_EX_BRANCH_LOCK)? 1'b1 : 1'b0;
	assign rs_alu0_exout_valid[2] = (w_rs_branch_exe_pointer == 3'h2 & rs_alu0_info_matching[2] & !iNEXT_EX_BRANCH_LOCK)? 1'b1 : 1'b0;
	assign rs_alu0_exout_valid[3] = (w_rs_branch_exe_pointer == 3'h3 & rs_alu0_info_matching[3] & !iNEXT_EX_BRANCH_LOCK)? 1'b1 : 1'b0;
	assign rs_alu0_exout_valid[4] = (w_rs_branch_exe_pointer == 3'h4 & rs_alu0_info_matching[4] & !iNEXT_EX_BRANCH_LOCK)? 1'b1 : 1'b0;
	assign rs_alu0_exout_valid[5] = (w_rs_branch_exe_pointer == 3'h5 & rs_alu0_info_matching[5] & !iNEXT_EX_BRANCH_LOCK)? 1'b1 : 1'b0;
	assign rs_alu0_exout_valid[6] = (w_rs_branch_exe_pointer == 3'h6 & rs_alu0_info_matching[6] & !iNEXT_EX_BRANCH_LOCK)? 1'b1 : 1'b0;
	assign rs_alu0_exout_valid[7] = (w_rs_branch_exe_pointer == 3'h7 & rs_alu0_info_matching[7] & !iNEXT_EX_BRANCH_LOCK)? 1'b1 : 1'b0;
	

	
	
	
	/********************************************************************************
	Exe-Port1 Comprex Integer Reservation Station  
	********************************************************************************/	
	//Lock Condition
	assign rs_alu1_lock = ~rs_alu1_regist_0_valid | ~rs_alu1_regist_1_valid;
	
	//Regist Possible Count
	reservation_free_entry_count ALU1_RB_COUNT(
		.iINFO0(!rs_alu1_info_entry_valid[0] && !rs_alu1_info_matching[0]),
		.iINFO1(!rs_alu1_info_entry_valid[1] && !rs_alu1_info_matching[1]),
		.iINFO2(!rs_alu1_info_entry_valid[2] && !rs_alu1_info_matching[2]),
		.iINFO3(!rs_alu1_info_entry_valid[3] && !rs_alu1_info_matching[3]),
		.iINFO4(!rs_alu1_info_entry_valid[4] && !rs_alu1_info_matching[4]),
		.iINFO5(!rs_alu1_info_entry_valid[5] && !rs_alu1_info_matching[5]),
		.iINFO6(!rs_alu1_info_entry_valid[6] && !rs_alu1_info_matching[6]),
		.iINFO7(!rs_alu1_info_entry_valid[7] && !rs_alu1_info_matching[7]),
		.iINFO8(!rs_alu1_info_entry_valid[8] && !rs_alu1_info_matching[8]),
		.iINFO9(!rs_alu1_info_entry_valid[9] && !rs_alu1_info_matching[9]),
		.iINFO10(!rs_alu1_info_entry_valid[10] && !rs_alu1_info_matching[10]),
		.iINFO11(!rs_alu1_info_entry_valid[11] && !rs_alu1_info_matching[11]),
		.iINFO12(!rs_alu1_info_entry_valid[12] && !rs_alu1_info_matching[12]),
		.iINFO13(!rs_alu1_info_entry_valid[13] && !rs_alu1_info_matching[13]),
		.iINFO14(!rs_alu1_info_entry_valid[14] && !rs_alu1_info_matching[14]),
		.iINFO15(!rs_alu1_info_entry_valid[15] && !rs_alu1_info_matching[15]),
		.oCOUNT(rs_alu1_regist_possible_count)
	);
	
	//Regist Possible-2Entry Get
	reservation_search16to2 ALU1_RB_2PICKUP(
		.iINFO0(!rs_alu1_info_entry_valid[0] && !rs_alu1_info_matching[0] && !rs_alu1_regist_lock[0]),
		.iINFO1(!rs_alu1_info_entry_valid[1] && !rs_alu1_info_matching[1] && !rs_alu1_regist_lock[1]),
		.iINFO2(!rs_alu1_info_entry_valid[2] && !rs_alu1_info_matching[2] && !rs_alu1_regist_lock[2]),
		.iINFO3(!rs_alu1_info_entry_valid[3] && !rs_alu1_info_matching[3] && !rs_alu1_regist_lock[3]),
		.iINFO4(!rs_alu1_info_entry_valid[4] && !rs_alu1_info_matching[4] && !rs_alu1_regist_lock[4]),
		.iINFO5(!rs_alu1_info_entry_valid[5] && !rs_alu1_info_matching[5] && !rs_alu1_regist_lock[5]),
		.iINFO6(!rs_alu1_info_entry_valid[6] && !rs_alu1_info_matching[6] && !rs_alu1_regist_lock[6]),
		.iINFO7(!rs_alu1_info_entry_valid[7] && !rs_alu1_info_matching[7] && !rs_alu1_regist_lock[7]),
		.iINFO8(!rs_alu1_info_entry_valid[8] && !rs_alu1_info_matching[8] && !rs_alu1_regist_lock[8]),
		.iINFO9(!rs_alu1_info_entry_valid[9] && !rs_alu1_info_matching[9] && !rs_alu1_regist_lock[9]),
		.iINFO10(!rs_alu1_info_entry_valid[10] && !rs_alu1_info_matching[10] && !rs_alu1_regist_lock[10]),
		.iINFO11(!rs_alu1_info_entry_valid[11] && !rs_alu1_info_matching[11] && !rs_alu1_regist_lock[11]),
		.iINFO12(!rs_alu1_info_entry_valid[12] && !rs_alu1_info_matching[12] && !rs_alu1_regist_lock[12]),
		.iINFO13(!rs_alu1_info_entry_valid[13] && !rs_alu1_info_matching[13] && !rs_alu1_regist_lock[13]),
		.iINFO14(!rs_alu1_info_entry_valid[14] && !rs_alu1_info_matching[14] && !rs_alu1_regist_lock[14]),
		.iINFO15(!rs_alu1_info_entry_valid[15] && !rs_alu1_info_matching[15] && !rs_alu1_regist_lock[15]),
		.oPICKUP_0_VALID(rs_alu1_regist_0_valid), .oPICLUP_0_NUM(rs_alu1_regist_0_num),
		.oPICKUP_1_VALID(rs_alu1_regist_1_valid), .oPICLUP_1_NUM(rs_alu1_regist_1_num)
	);
																												

	//Execute Priority Encoder
	priority_encoder_16 ALU1_PRYORITY	(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET), 
		.iRESTART(iFREE_RESERVATIONSTATION),
		.iSOURCE_VALID0(rs_alu1_info_entry_valid[0] & rs_alu1_info_matching[0] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID1(rs_alu1_info_entry_valid[1] & rs_alu1_info_matching[1] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID2(rs_alu1_info_entry_valid[2] & rs_alu1_info_matching[2] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID3(rs_alu1_info_entry_valid[3] & rs_alu1_info_matching[3] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID4(rs_alu1_info_entry_valid[4] & rs_alu1_info_matching[4] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID5(rs_alu1_info_entry_valid[5] & rs_alu1_info_matching[5] & !iNEXT_EX_ALU1_LOCK),
		.iSOURCE_VALID6(rs_alu1_info_entry_valid[6] & rs_alu1_info_matching[6] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID7(rs_alu1_info_entry_valid[7] & rs_alu1_info_matching[7] & !iNEXT_EX_ALU1_LOCK),
		.iSOURCE_VALID8(rs_alu1_info_entry_valid[8] & rs_alu1_info_matching[8] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID9(rs_alu1_info_entry_valid[9] & rs_alu1_info_matching[9] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID10(rs_alu1_info_entry_valid[10] & rs_alu1_info_matching[10] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID11(rs_alu1_info_entry_valid[11] & rs_alu1_info_matching[11] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID12(rs_alu1_info_entry_valid[12] & rs_alu1_info_matching[12] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID13(rs_alu1_info_entry_valid[13] & rs_alu1_info_matching[13] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID14(rs_alu1_info_entry_valid[14] & rs_alu1_info_matching[14] & !iNEXT_EX_ALU1_LOCK), 
		.iSOURCE_VALID15(rs_alu1_info_entry_valid[15] & rs_alu1_info_matching[15] & !iNEXT_EX_ALU1_LOCK),
		.oSELECT_VALID(rs_alu1_exout_entry_num_valid), .oSELECT_NUM(rs_alu1_exout_entry_num)
	);
	

	//RB Write Control
	generate
		//genvar i; //QuartusII Bug
		for(i = 0; i < 16; i = i + 1)begin : ALU1_RB_CONTROL
			//Regist wire
			assign rs_alu1_regist_destination_sysreg[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_DESTINATION_SYSREG : iPREVIOUS_1_DESTINATION_SYSREG;
			assign rs_alu1_regist_valid[i] = (rs1_0_regist_valid && rs_alu1_regist_0_valid && rs_alu1_regist_0_num == i[3:0]) || (rs1_1_regist_valid && rs_alu1_regist_1_valid && rs_alu1_regist_1_num == i[3:0]);
			assign rs_alu1_regist_writeback[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_WRITEBACK : iPREVIOUS_1_WRITEBACK;
			assign rs_alu1_regist_cmd[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_CMD : iPREVIOUS_1_CMD;
			assign rs_alu1_regist_afe[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_CC_AFE : iPREVIOUS_1_CC_AFE;
			assign rs_alu1_regist_sys_reg[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_EX_SYS_REG : iPREVIOUS_1_EX_SYS_REG;
			assign rs_alu1_regist_logic[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_EX_LOGIC : iPREVIOUS_1_EX_LOGIC;
			assign rs_alu1_regist_shift[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_EX_SHIFT : iPREVIOUS_1_EX_SHIFT;
			assign rs_alu1_regist_adder[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_EX_ADDER : iPREVIOUS_1_EX_ADDER;
			assign rs_alu1_regist_mul[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_EX_MUL : iPREVIOUS_1_EX_MUL;
			assign rs_alu1_regist_sdiv[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_EX_SDIV : iPREVIOUS_1_EX_SDIV;
			assign rs_alu1_regist_udiv[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_EX_UDIV : iPREVIOUS_1_EX_UDIV;
			assign rs_alu1_regist_flags_writeback[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_FLAGS_WRITEBACK : iPREVIOUS_1_FLAGS_WRITEBACK;
			assign rs_alu1_regist_flags_regname[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_FLAGS_REGNAME : iPREVIOUS_1_FLAGS_REGNAME;
			assign rs_alu1_regist_source0_valid[i] = (rs_alu1_regist_0_num == i[3:0])? w_register_mix_prev0_source0_valid : w_register_mix_prev1_source0_valid;
			assign rs_alu1_regist_source0[i] = (rs_alu1_regist_0_num == i[3:0])? w_register_mix_prev0_source0 : w_register_mix_prev1_source0;
			assign rs_alu1_regist_source1_valid[i] = (rs_alu1_regist_0_num == i[3:0])? w_register_mix_prev0_source1_valid : w_register_mix_prev1_source1_valid;
			assign rs_alu1_regist_source1[i] = (rs_alu1_regist_0_num == i[3:0])? w_register_mix_prev0_source1 : w_register_mix_prev1_source1;
			assign rs_alu1_regist_pcr[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_PC : (iPREVIOUS_PC + 32'h4);
			assign rs_alu1_regist_logic_dest[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_LOGIC_DESTINATION : iPREVIOUS_1_LOGIC_DESTINATION;
			assign rs_alu1_regist_destination_regname[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_DESTINATION_REGNAME : iPREVIOUS_1_DESTINATION_REGNAME;
			assign rs_alu1_regist_commit_tag[i] = (rs_alu1_regist_0_num == i[3:0])? iPREVIOUS_0_COMMIT_TAG : iPREVIOUS_1_COMMIT_TAG;	
			//Exout Wire
			assign rs_alu1_exout_valid[i] = (rs_alu1_exout_entry_num_valid && rs_alu1_exout_entry_num == i[3:0])? 1'b1 : 1'b0;	
		end
	endgenerate
	
	
	
	generate
		//genvar i; //QuartusII Bug
		for(i = 0; i < 16; i = i + 1)begin : RS_ALU1
			reservation_alu1_entry RS_ALU1 (
				.iCLOCK(iCLOCK), 
				.inRESET(inRESET), 
				.iREMOVE_VALID(iFREE_RESERVATIONSTATION), 
				.oINFO_REGIST_LOCK(rs_alu1_regist_lock[i[3:0]]),
				.iREGISTER_DESTINATION_SYSREG(rs_alu1_regist_destination_sysreg[i[3:0]]),
				.iREGISTER_VALID(rs_alu1_regist_valid[i[3:0]]), 
				.iREGISTER_WRITEBACK(rs_alu1_regist_writeback[i[3:0]]), 
				.iREGISTER_CMD(rs_alu1_regist_cmd[i[3:0]]), 
				.iREGISTER_AFE(rs_alu1_regist_afe[i[3:0]]),
				.iREGISTER_SYS_REG(rs_alu1_regist_sys_reg[i[3:0]]), 
				.iREGISTER_LOGIC(rs_alu1_regist_logic[i[3:0]]), 
				.iREGISTER_SHIFT(rs_alu1_regist_shift[i[3:0]]), 
				.iREGISTER_MUL(rs_alu1_regist_mul[i[3:0]]),
				.iREGISTER_SDIV(rs_alu1_regist_sdiv[i[3:0]]), 
				.iREGISTER_UDIV(rs_alu1_regist_udiv[i[3:0]]), 
				.iREGISTER_ADDER(rs_alu1_regist_adder[i[3:0]]), 
				.iREGISTER_FLAGS_OPT_VALID(rs_alu1_regist_flags_writeback[i[3:0]]),
				.iREGISTER_FLAGS_REGNAME(rs_alu1_regist_flags_regname[i[3:0]]),
				.iREGISTER_SOURCE0_VALID(rs_alu1_regist_source0_valid[i[3:0]]), 
				.iREGISTER_SOURCE0(rs_alu1_regist_source0[i[3:0]]), 
				.iREGISTER_SOURCE1_VALID(rs_alu1_regist_source1_valid[i[3:0]]), 
				.iREGISTER_SOURCE1(rs_alu1_regist_source1[i[3:0]]), 
				.iREGISTER_PCR(rs_alu1_regist_pcr[i[3:0]]),
				.iREGISTER_LOGIC_DEST(rs_alu1_regist_logic_dest[i[3:0]]),
				.iREGISTER_DESTINATION_REGNAME(rs_alu1_regist_destination_regname[i[3:0]]),
				.iREGISTER_COMMIT_TAG(rs_alu1_regist_commit_tag[i[3:0]]),
				.iALU1_VALID(iSCHE2_EX_ALU1_VALID && !iSCHE2_EX_ALU1_DESTINATION_SYSREG), 
				.iALU1_DESTINATION_REGNAME(iSCHE2_EX_ALU1_DESTINATION_REGNAME), 
				.iALU1_WRITEBACK(iSCHE2_EX_ALU1_WRITEBACK), 
				.iALU1_DATA(iSCHE2_EX_ALU1_DATA), 
				.iALU2_VALID(iSCHE2_EX_ALU2_VALID && !iSCHE2_EX_ALU2_DESTINATION_SYSREG), 
				.iALU2_DESTINATION_REGNAME(iSCHE2_EX_ALU2_DESTINATION_REGNAME), 
				.iALU2_WRITEBACK(iSCHE2_EX_ALU2_WRITEBACK), 
				.iALU2_DATA(iSCHE2_EX_ALU2_DATA), 
				.iALU3_VALID(iSCHE2_ALU3_VALID && iSCHE2_ALU3_WRITEBACK && !iSCHE2_ALU3_DESTINATION_SYSREG), 
				.iALU3_DESTINATION_REGNAME(iSCHE2_ALU3_DESTINATION_REGNAME), 
				.iALU3_DATA(iSCHE2_ALU3_DATA),
				.iEXOUT_VALID(rs_alu1_exout_valid[i[3:0]] & !iNEXT_EX_ALU1_LOCK), 
				.oINFO_ENTRY_VALID(rs_alu1_info_entry_valid[i[3:0]]), 
				.oINFO_MATCHING(rs_alu1_info_matching[i[3:0]]), 
				.oINFO_DESTINATION_SYSREG(rs_alu1_info_destination_sysreg[i[3:0]]),
				.oINFO_WRITEBACK(rs_alu1_info_writeback[i[3:0]]), 
				.oINFO_CMD(rs_alu1_info_cmd[i[3:0]]), 
				.oINFO_AFE(rs_alu1_info_afe[i[3:0]]),
				.oINFO_SYS_REG(rs_alu1_info_sys_reg[i[3:0]]),
				.oINFO_LOGIC(rs_alu1_info_logic[i[3:0]]),
				.oINFO_SHIFT(rs_alu1_info_shift[i[3:0]]), 
				.oINFO_ADDER(rs_alu1_info_adder[i[3:0]]), 
				.oINFO_MUL(rs_alu1_info_mul[i[3:0]]), 
				.oINFO_SDIV(rs_alu1_info_sdiv[i[3:0]]), 
				.oINFO_UDIV(rs_alu1_info_udiv[i[3:0]]), 
				.oINFO_FLAGS_OPT_VALID(rs_alu1_info_flags_writeback[i[3:0]]),
				.oINFO_FLAGS_REGNAME(rs_alu1_info_flags_regname[i[3:0]]),
				.oINFO_SOURCE0_VALID(rs_alu1_info_source0_valid[i[3:0]]), 
				.oINFO_SOURCE0(rs_alu1_info_source0[i[3:0]]), 
				.oINFO_SOURCE1_VALID(rs_alu1_info_source1_valid[i[3:0]]), 
				.oINFO_SOURCE1(rs_alu1_info_source1[i[3:0]]), 
				.oINFO_PCR(rs_alu1_info_pcr[i[3:0]]),
				.oINFO_LOGIC_DEST(rs_alu1_info_logic_dest[i[3:0]]),
				.oINFO_DESTINATION_REGNAME(rs_alu1_info_destination_regname[i[3:0]]), 
				.oINFO_COMMIT_TAG(rs_alu1_info_commit_tag[i[3:0]])
			);
		end
	endgenerate
			

	
	
	
	/********************************************************************************
	Exe-Port2 Simple Integer Reservation Station  
	********************************************************************************/	
	//Lock Condition
	assign rs_alu2_lock = !rs_alu2_regist_0_valid || !rs_alu2_regist_1_valid;
	
	//Regist Possible Count
	reservation_free_entry_count ALU2_RB_COUNT(
		.iINFO0(!rs_alu2_info_entry_valid[0] && !rs_alu2_info_matching[0]),
		.iINFO1(!rs_alu2_info_entry_valid[1] && !rs_alu2_info_matching[1]),
		.iINFO2(!rs_alu2_info_entry_valid[2] && !rs_alu2_info_matching[2]),
		.iINFO3(!rs_alu2_info_entry_valid[3] && !rs_alu2_info_matching[3]),
		.iINFO4(!rs_alu2_info_entry_valid[4] && !rs_alu2_info_matching[4]),
		.iINFO5(!rs_alu2_info_entry_valid[5] && !rs_alu2_info_matching[5]),
		.iINFO6(!rs_alu2_info_entry_valid[6] && !rs_alu2_info_matching[6]),
		.iINFO7(!rs_alu2_info_entry_valid[7] && !rs_alu2_info_matching[7]),
		.iINFO8(!rs_alu2_info_entry_valid[8] && !rs_alu2_info_matching[8]),
		.iINFO9(!rs_alu2_info_entry_valid[9] && !rs_alu2_info_matching[9]),
		.iINFO10(!rs_alu2_info_entry_valid[10] && !rs_alu2_info_matching[10]),
		.iINFO11(!rs_alu2_info_entry_valid[11] && !rs_alu2_info_matching[11]),
		.iINFO12(!rs_alu2_info_entry_valid[12] && !rs_alu2_info_matching[12]),
		.iINFO13(!rs_alu2_info_entry_valid[13] && !rs_alu2_info_matching[13]),
		.iINFO14(!rs_alu2_info_entry_valid[14] && !rs_alu2_info_matching[14]),
		.iINFO15(!rs_alu2_info_entry_valid[15] && !rs_alu2_info_matching[15]),
		.oCOUNT(rs_alu2_regist_possible_count)
	);
	
	//Regist Possible-2Entry Get
	reservation_search16to2 ALU2_RB_2PICKUP(
		.iINFO0(!rs_alu2_info_entry_valid[0] && !rs_alu2_info_matching[0] && !rs_alu2_regist_lock[0]),
		.iINFO1(!rs_alu2_info_entry_valid[1] && !rs_alu2_info_matching[1] && !rs_alu2_regist_lock[1]),
		.iINFO2(!rs_alu2_info_entry_valid[2] && !rs_alu2_info_matching[2] && !rs_alu2_regist_lock[2]),
		.iINFO3(!rs_alu2_info_entry_valid[3] && !rs_alu2_info_matching[3] && !rs_alu2_regist_lock[3]),
		.iINFO4(!rs_alu2_info_entry_valid[4] && !rs_alu2_info_matching[4] && !rs_alu2_regist_lock[4]),
		.iINFO5(!rs_alu2_info_entry_valid[5] && !rs_alu2_info_matching[5] && !rs_alu2_regist_lock[5]),
		.iINFO6(!rs_alu2_info_entry_valid[6] && !rs_alu2_info_matching[6] && !rs_alu2_regist_lock[6]),
		.iINFO7(!rs_alu2_info_entry_valid[7] && !rs_alu2_info_matching[7] && !rs_alu2_regist_lock[7]),
		.iINFO8(!rs_alu2_info_entry_valid[8] && !rs_alu2_info_matching[8] && !rs_alu2_regist_lock[8]),
		.iINFO9(!rs_alu2_info_entry_valid[9] && !rs_alu2_info_matching[9] && !rs_alu2_regist_lock[9]),
		.iINFO10(!rs_alu2_info_entry_valid[10] && !rs_alu2_info_matching[10] && !rs_alu2_regist_lock[10]),
		.iINFO11(!rs_alu2_info_entry_valid[11] && !rs_alu2_info_matching[11] && !rs_alu2_regist_lock[11]),
		.iINFO12(!rs_alu2_info_entry_valid[12] && !rs_alu2_info_matching[12] && !rs_alu2_regist_lock[12]),
		.iINFO13(!rs_alu2_info_entry_valid[13] && !rs_alu2_info_matching[13] && !rs_alu2_regist_lock[13]),
		.iINFO14(!rs_alu2_info_entry_valid[14] && !rs_alu2_info_matching[14] && !rs_alu2_regist_lock[14]),
		.iINFO15(!rs_alu2_info_entry_valid[15] && !rs_alu2_info_matching[15] && !rs_alu2_regist_lock[15]),
		.oPICKUP_0_VALID(rs_alu2_regist_0_valid), .oPICLUP_0_NUM(rs_alu2_regist_0_num),
		.oPICKUP_1_VALID(rs_alu2_regist_1_valid), .oPICLUP_1_NUM(rs_alu2_regist_1_num)
	);
																												

	//Execute Priority Encoder
	priority_encoder_16 ALU2_PRYORITY (
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),
		.iRESTART(iFREE_RESERVATIONSTATION),
		.iSOURCE_VALID0(rs_alu2_info_entry_valid[0] & rs_alu2_info_matching[0] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID1(rs_alu2_info_entry_valid[1] & rs_alu2_info_matching[1] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID2(rs_alu2_info_entry_valid[2] & rs_alu2_info_matching[2] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID3(rs_alu2_info_entry_valid[3] & rs_alu2_info_matching[3] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID4(rs_alu2_info_entry_valid[4] & rs_alu2_info_matching[4] & !iNEXT_EX_ALU2_LOCK),
		.iSOURCE_VALID5(rs_alu2_info_entry_valid[5] & rs_alu2_info_matching[5] & !iNEXT_EX_ALU2_LOCK),
		.iSOURCE_VALID6(rs_alu2_info_entry_valid[6] & rs_alu2_info_matching[6] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID7(rs_alu2_info_entry_valid[7] & rs_alu2_info_matching[7] & !iNEXT_EX_ALU2_LOCK),
		.iSOURCE_VALID8(rs_alu2_info_entry_valid[8] & rs_alu2_info_matching[8] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID9(rs_alu2_info_entry_valid[9] & rs_alu2_info_matching[9] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID10(rs_alu2_info_entry_valid[10] & rs_alu2_info_matching[10] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID11(rs_alu2_info_entry_valid[11] & rs_alu2_info_matching[11] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID12(rs_alu2_info_entry_valid[12] & rs_alu2_info_matching[12] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID13(rs_alu2_info_entry_valid[13] & rs_alu2_info_matching[13] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID14(rs_alu2_info_entry_valid[14] & rs_alu2_info_matching[14] & !iNEXT_EX_ALU2_LOCK), 
		.iSOURCE_VALID15(rs_alu2_info_entry_valid[15] & rs_alu2_info_matching[15] & !iNEXT_EX_ALU2_LOCK),
		.oSELECT_VALID(rs_alu2_exout_entry_num_valid), 
		.oSELECT_NUM(rs_alu2_exout_entry_num)
	);

	
	//RB Write Control
	generate
		//genvar i; //Quaruts II Bug
		for(i = 0; i < 16; i = i + 1)begin : ALU2_RB_CONTROL
			//Regist wire
			assign rs_alu2_regist_destination_sysreg[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_DESTINATION_SYSREG : iPREVIOUS_1_DESTINATION_SYSREG;
			assign rs_alu2_regist_valid[i] = (rs2_0_regist_valid && rs2_0_regist_valid && rs_alu2_regist_0_num == i[3:0]) || (rs2_1_regist_valid && rs_alu2_regist_1_valid && rs_alu2_regist_1_num == i[3:0]);
			assign rs_alu2_regist_writeback[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_WRITEBACK : iPREVIOUS_1_WRITEBACK;
			assign rs_alu2_regist_cmd[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_CMD : iPREVIOUS_1_CMD;
			assign rs_alu2_regist_afe[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_CC_AFE : iPREVIOUS_1_CC_AFE;
			assign rs_alu2_regist_sys_reg[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_EX_SYS_REG : iPREVIOUS_1_EX_SYS_REG;
			assign rs_alu2_regist_logic[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_EX_LOGIC : iPREVIOUS_1_EX_LOGIC;
			assign rs_alu2_regist_shift[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_EX_SHIFT : iPREVIOUS_1_EX_SHIFT;
			assign rs_alu2_regist_adder[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_EX_ADDER : iPREVIOUS_1_EX_ADDER;
			assign rs_alu2_regist_flags_writeback[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_FLAGS_WRITEBACK : iPREVIOUS_1_FLAGS_WRITEBACK;
			assign rs_alu2_regist_flags_regname[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_FLAGS_REGNAME : iPREVIOUS_1_FLAGS_REGNAME;
			assign rs_alu2_regist_source0_valid[i] = (rs_alu2_regist_0_num == i[3:0])? w_register_mix_prev0_source0_valid : w_register_mix_prev1_source0_valid;
			assign rs_alu2_regist_source0[i] = (rs_alu2_regist_0_num == i[3:0])? w_register_mix_prev0_source0 : w_register_mix_prev1_source0;
			assign rs_alu2_regist_source1_valid[i] = (rs_alu2_regist_0_num == i[3:0])? w_register_mix_prev0_source1_valid : w_register_mix_prev1_source1_valid;
			assign rs_alu2_regist_source1[i] = (rs_alu2_regist_0_num == i[3:0])? w_register_mix_prev0_source1 : w_register_mix_prev1_source1;
			assign rs_alu2_regist_pcr[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_PC : (iPREVIOUS_PC + 32'h4);
			assign rs_alu2_regist_logic_dest[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_LOGIC_DESTINATION : iPREVIOUS_1_LOGIC_DESTINATION;
			assign rs_alu2_regist_destination_regname[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_DESTINATION_REGNAME : iPREVIOUS_1_DESTINATION_REGNAME;
			assign rs_alu2_regist_commit_tag[i] = (rs_alu2_regist_0_num == i[3:0])? iPREVIOUS_0_COMMIT_TAG : iPREVIOUS_1_COMMIT_TAG;	
			//Exout Wire
			assign rs_alu2_exout_valid[i] = (rs_alu2_exout_entry_num_valid && rs_alu2_exout_entry_num == i[3:0])? 1'b1 : 1'b0;	
		end
	endgenerate
	
	
	
	generate
		//genvar i; //Quaruts II Bug
		for(i = 0; i < 16; i = i + 1)begin : RS_ALU2
			reservation_alu2_entry RS_ALU2 (
				.iCLOCK(iCLOCK), 
				.inRESET(inRESET), 
				.oINFO_REGIST_LOCK(rs_alu2_regist_lock[i[3:0]]),
				.iREMOVE_VALID(iFREE_RESERVATIONSTATION), 
				.iREGISTER_DESTINATION_SYSREG(rs_alu2_regist_destination_sysreg[i[3:0]]),
				.iREGISTER_VALID(rs_alu2_regist_valid[i[3:0]]), 
				.iREGISTER_WRITEBACK(rs_alu2_regist_writeback[i[3:0]]), 
				.iREGISTER_CMD(rs_alu2_regist_cmd[i[3:0]]), 
				.iREGISTER_AFE(rs_alu2_regist_afe[i[3:0]]),
				.iREGISTER_SYS_REG(rs_alu2_regist_sys_reg[i[3:0]]),
				.iREGISTER_LOGIC(rs_alu2_regist_logic[i[3:0]]), 
				.iREGISTER_SHIFT(rs_alu2_regist_shift[i[3:0]]), 
				.iREGISTER_ADDER(rs_alu2_regist_adder[i[3:0]]), 
				.iREGISTER_FLAGS_OPT_VALID(rs_alu2_regist_flags_writeback[i[3:0]]),
				.iREGISTER_FLAGS_REGNAME(rs_alu2_regist_flags_regname[i[3:0]]),
				.iREGISTER_SOURCE0_VALID(rs_alu2_regist_source0_valid[i[3:0]]), 
				.iREGISTER_SOURCE0(rs_alu2_regist_source0[i[3:0]]), 
				.iREGISTER_SOURCE1_VALID(rs_alu2_regist_source1_valid[i[3:0]]), 
				.iREGISTER_SOURCE1(rs_alu2_regist_source1[i[3:0]]), 
				.iREGISTER_PCR(rs_alu2_regist_pcr[i[3:0]]), 
				.iREGISTER_LOGIC_DEST(rs_alu2_regist_logic_dest[i[3:0]]),
				.iREGISTER_DESTINATION_REGNAME(rs_alu2_regist_destination_regname[i[3:0]]),
				.iREGISTER_COMMIT_TAG(rs_alu2_regist_commit_tag[i[3:0]]),
				.iALU1_VALID(iSCHE2_EX_ALU1_VALID && !iSCHE2_EX_ALU1_DESTINATION_SYSREG), 
				.iALU1_DESTINATION_REGNAME(iSCHE2_EX_ALU1_DESTINATION_REGNAME), 
				.iALU1_WRITEBACK(iSCHE2_EX_ALU1_WRITEBACK), 
				.iALU1_DATA(iSCHE2_EX_ALU1_DATA), 
				.iALU2_VALID(iSCHE2_EX_ALU2_VALID && !iSCHE2_EX_ALU2_DESTINATION_SYSREG), 
				.iALU2_DESTINATION_REGNAME(iSCHE2_EX_ALU2_DESTINATION_REGNAME), 
				.iALU2_WRITEBACK(iSCHE2_EX_ALU2_WRITEBACK), 
				.iALU2_DATA(iSCHE2_EX_ALU2_DATA), 
				.iALU3_VALID(iSCHE2_ALU3_VALID && iSCHE2_ALU3_WRITEBACK && !iSCHE2_ALU3_DESTINATION_SYSREG), 
				.iALU3_DESTINATION_REGNAME(iSCHE2_ALU3_DESTINATION_REGNAME), 
				.iALU3_DATA(iSCHE2_ALU3_DATA),
				.iEXOUT_VALID(rs_alu2_exout_valid[i[3:0]] & !iNEXT_EX_ALU2_LOCK), 
				.oINFO_ENTRY_VALID(rs_alu2_info_entry_valid[i[3:0]]), 
				.oINFO_MATCHING(rs_alu2_info_matching[i[3:0]]), 
				.oINFO_DESTINATION_SYSREG(rs_alu2_info_destination_sysreg[i[3:0]]),
				.oINFO_WRITEBACK(rs_alu2_info_writeback[i[3:0]]), 
				.oINFO_CMD(rs_alu2_info_cmd[i[3:0]]), 
				.oINFO_AFE(rs_alu2_info_afe[i[3:0]]),
				.oINFO_SYS_REG(rs_alu2_info_sys_reg[i[3:0]]),
				.oINFO_LOGIC(rs_alu2_info_logic[i[3:0]]),
				.oINFO_SHIFT(rs_alu2_info_shift[i[3:0]]), 
				.oINFO_ADDER(rs_alu2_info_adder[i[3:0]]), 
				.oINFO_FLAGS_OPT_VALID(rs_alu2_info_flags_writeback[i[3:0]]),
				.oINFO_FLAGS_REGNAME(rs_alu2_info_flags_regname[i[3:0]]),
				.oINFO_SOURCE0_VALID(rs_alu2_info_source0_valid[i[3:0]]), 
				.oINFO_SOURCE0(rs_alu2_info_source0[i[3:0]]), 
				.oINFO_SOURCE1_VALID(rs_alu2_info_source1_valid[i[3:0]]), 
				.oINFO_SOURCE1(rs_alu2_info_source1[i[3:0]]), 
				.oINFO_PCR(rs_alu2_info_pcr[i[3:0]]), 
				.oINFO_LOGIC_DEST(rs_alu2_info_logic_dest[i[3:0]]),
				.oINFO_DESTINATION_REGNAME(rs_alu2_info_destination_regname[i[3:0]]), 
				.oINFO_COMMIT_TAG(rs_alu2_info_commit_tag[i[3:0]])
			);
		end
	endgenerate
	
	
	
	
	/****************************************
	Exe-Port3 Load/Store Reservation Station
	****************************************/
	wire rs_alu3_regist_valid[0:7];
	wire [4:0] rs_alu3_regist_cmd[0:7];
	wire rs_alu3_regist_sys_ldst[0:7];
	wire rs_alu3_regist_ldst[0:7];
	wire rs_alu3_regist_source0_valid[0:7];
	wire rs_alu3_regist_source0_sysreg[0:7];
	wire [31:0] rs_alu3_regist_source0[0:7];
	wire rs_alu3_regist_source1_valid[0:7];
	wire rs_alu3_regist_source1_sysreg[0:7];
	wire [31:0] rs_alu3_regist_source1[0:7];
	wire rs_alu3_regist_adv_active[0:7];
	wire [5:0] rs_alu3_regist_adv_data[0:7];
	wire [4:0] rs_alu3_regist_logic_dest[0:7];
	wire [5:0] rs_alu3_regist_destination_regname[0:7];
	wire rs_alu3_regist_destination_sysreg[0:7];
	wire [5:0] rs_alu3_regist_commit_tag[0:7];
	wire [31:0] rs_alu3_regist_pc[0:7];
	wire [3:0] rs_alu3_regist_ex_inorder_regist_pointer[0:7];

	//Regist Enable wire
	assign rs_alu3_0_reg_valid = rs3_0_regist_valid && !rs_alu3_lock;//!rs_alu3_lock & iPREVIOUS_0_VALID & (iPREVIOUS_0_EX_LDST | iPREVIOUS_0_EX_SYS_LDST | iPREVIOUS_0_EX_SYS_REG);
	assign rs_alu3_1_reg_valid = rs3_1_regist_valid && !rs_alu3_lock;//!rs_alu3_lock & iPREVIOUS_1_VALID & (iPREVIOUS_1_EX_LDST | iPREVIOUS_1_EX_SYS_LDST | iPREVIOUS_1_EX_SYS_REG);
	//Execution Enable wire
	assign rs_alu3_exout_all_valid = !iNEXT_EX_ALU3_LOCK & (rs_alu3_exout_valid[0] || rs_alu3_exout_valid[1] || rs_alu3_exout_valid[2] || rs_alu3_exout_valid[3] ||
														rs_alu3_exout_valid[4] || rs_alu3_exout_valid[5] || rs_alu3_exout_valid[6] || rs_alu3_exout_valid[7]);
	//Lock Signal
	assign rs_alu3_validentry_count = 	(b0_rs_alu3_reg_pointer - b0_rs_alu3_exe_pointer) + 4'h2;
	assign rs_alu3_lock = rs_alu3_validentry_count[3];
	
	//Counter				
	wire [1:0] w_rs_alu3_reg_offset;
	assign 	w_rs_alu3_reg_offset = (rs_alu3_0_reg_valid && rs_alu3_1_reg_valid)? 2'h2 : (rs_alu3_0_reg_valid || rs_alu3_1_reg_valid)? 2'h1 : 2'h0;
	assign w_rs_alu3_exe_pointer = b0_rs_alu3_exe_pointer[2:0];
	assign w_rs_alu3_reg_pointer = b0_rs_alu3_reg_pointer[2:0];
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_rs_alu3_exe_pointer <= {4{1'b0}};
			b0_rs_alu3_reg_pointer <= {4{1'b0}};
		end
		else if(iFREE_RESTART)begin
			b0_rs_alu3_exe_pointer <= {4{1'b0}};
			b0_rs_alu3_reg_pointer <= {4{1'b0}};
		end
		else begin
			b0_rs_alu3_reg_pointer <= b0_rs_alu3_reg_pointer + {2'b0, w_rs_alu3_reg_offset};
			if(!iNEXT_EX_ALU3_LOCK)begin
				b0_rs_alu3_exe_pointer <= b0_rs_alu3_exe_pointer + {3'h0, rs_alu3_exout_all_valid}; 
			end
		end
	end
	
	
	//LoadStore Reservation Station Regist_select
	function func_alu3_rs_regist_select;
		//[0] :	Select Output
		input func_alu3_rs_input_regist_0_reg_valid;
		input func_alu3_rs_input_regist_1_reg_valid;
		input [2:0] func_alu3_rs_input_regist_entry_id;
		input [2:0] func_alu3_rs_input_regist_reg_counter;
		begin
			if(func_alu3_rs_input_regist_0_reg_valid & func_alu3_rs_input_regist_1_reg_valid)begin
				if(func_alu3_rs_input_regist_entry_id == func_alu3_rs_input_regist_reg_counter)begin
					func_alu3_rs_regist_select = 1'b1;//
				end
				else begin
					func_alu3_rs_regist_select = 1'b0;//
				end
			end
			else if(func_alu3_rs_input_regist_0_reg_valid)begin
				if(func_alu3_rs_input_regist_entry_id == func_alu3_rs_input_regist_reg_counter)begin
					func_alu3_rs_regist_select = 1'b1;//
				end
				else begin
					func_alu3_rs_regist_select = 1'b0;//
				end
			end
			else if(func_alu3_rs_input_regist_1_reg_valid)begin
				if(func_alu3_rs_input_regist_entry_id == func_alu3_rs_input_regist_reg_counter)begin
					func_alu3_rs_regist_select = 1'b0;
				end
				else begin
					func_alu3_rs_regist_select = 1'b1;
				end
			end
			else begin
				func_alu3_rs_regist_select = 1'b0;
			end
		end
	endfunction
	
	//RB Write Control
	generate
		for(i = 0; i < 8; i = i + 1)begin : ALU3_RB_CONTROL
			//--Verilog Syntax Bug
			wire [2:0] gen_alu3_reg_pointer_0;
			wire [2:0] gen_alu3_reg_pointer_1;
			assign gen_alu3_reg_pointer_0 = w_rs_alu3_reg_pointer;
			assign gen_alu3_reg_pointer_1 = w_rs_alu3_reg_pointer + 3'h1;
			//--Verilog Syntax Bug End
			//Regist
			assign rs_alu3_regist_valid[i] = (rs_alu3_0_reg_valid & rs_alu3_1_reg_valid & ((gen_alu3_reg_pointer_0 == i[2:0]) || (gen_alu3_reg_pointer_1 == i[2:0]))) || ((rs_alu3_0_reg_valid || rs_alu3_1_reg_valid) & gen_alu3_reg_pointer_0 == i[2:0]);
			assign rs_alu3_regist_cmd[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_CMD : iPREVIOUS_1_CMD;
			assign rs_alu3_regist_sys_ldst[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_EX_SYS_LDST : iPREVIOUS_1_EX_SYS_LDST;
			assign rs_alu3_regist_ldst[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_EX_LDST : iPREVIOUS_1_EX_LDST;
			assign rs_alu3_regist_source0_valid[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? w_register_mix_prev0_source0_valid : w_register_mix_prev1_source0_valid;
			assign rs_alu3_regist_source0_sysreg[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_SOURCE0_SYSREG : iPREVIOUS_1_SOURCE0_SYSREG;
			assign rs_alu3_regist_source0[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? w_register_mix_prev0_source0 : w_register_mix_prev1_source0;
			assign rs_alu3_regist_source1_valid[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? w_register_mix_prev0_source1_valid : w_register_mix_prev1_source1_valid;
			assign rs_alu3_regist_source1_sysreg[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_SOURCE1_SYSREG : iPREVIOUS_1_SOURCE1_SYSREG;
			assign rs_alu3_regist_source1[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? w_register_mix_prev0_source1 : w_register_mix_prev1_source1;
			assign rs_alu3_regist_adv_active[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_ADV_ACTIVE : iPREVIOUS_1_ADV_ACTIVE;
			assign rs_alu3_regist_adv_data[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_ADV_DATA : iPREVIOUS_1_ADV_DATA;
			assign rs_alu3_regist_logic_dest[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_LOGIC_DESTINATION : iPREVIOUS_1_LOGIC_DESTINATION;
			assign rs_alu3_regist_destination_regname[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_DESTINATION_REGNAME : iPREVIOUS_1_DESTINATION_REGNAME;
			assign rs_alu3_regist_destination_sysreg[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_DESTINATION_SYSREG : iPREVIOUS_1_DESTINATION_SYSREG;
			assign rs_alu3_regist_commit_tag[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_0_COMMIT_TAG : iPREVIOUS_1_COMMIT_TAG;
			assign rs_alu3_regist_pc[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? iPREVIOUS_PC : iPREVIOUS_PC + 32'h4;
			assign rs_alu3_regist_ex_inorder_regist_pointer[i] = (func_alu3_rs_regist_select(rs_alu3_0_reg_valid, rs_alu3_1_reg_valid, i[2:0], gen_alu3_reg_pointer_0))? w_ex_0_inorder_regist_pointer : w_ex_1_inorder_regist_pointer;
			//Exe Out
			assign rs_alu3_exout_valid[i] = (w_rs_alu3_exe_pointer == i[2:0] && rs_alu3_info_matching[i[2:0]] == 1'b1)? 1'b1 : 1'b0;	
		end
	endgenerate

	
	generate
		for(i = 0; i < 8; i = i + 1)begin : RS_ALU3
			reservation_alu3_entry RS_ALU3_0 (
				.iCLOCK(iCLOCK), 
				.inRESET(inRESET), 
				.iREMOVE_VALID(iFREE_RESERVATIONSTATION),
				.iREGISTER_VALID(rs_alu3_regist_valid[i[2:0]]), 
				.iREGISTER_CMD(rs_alu3_regist_cmd[i[2:0]]), 
				.iREGISTER_SYS_LDST(rs_alu3_regist_sys_ldst[i[2:0]]), 
				.iREGISTER_LDST(rs_alu3_regist_ldst[i[2:0]]),
				.iREGISTER_SOURCE0_VALID(rs_alu3_regist_source0_valid[i[2:0]]), 
				.iREGISTER_SOURCE0_SYSREG(rs_alu3_regist_source0_sysreg[i[2:0]]), 
				.iREGISTER_SOURCE0(rs_alu3_regist_source0[i[2:0]]), 
				.iREGISTER_SOURCE1_VALID(rs_alu3_regist_source1_valid[i[2:0]]), 
				.iREGISTER_SOURCE1_SYSREG(rs_alu3_regist_source1_sysreg[i[2:0]]), 
				.iREGISTER_SOURCE1(rs_alu3_regist_source1[i[2:0]]), 
				.iREGISTER_ADV_ACTIVE(rs_alu3_regist_adv_active[i[2:0]]), 
				.iREGISTER_ADV_DATA(rs_alu3_regist_adv_data[i[2:0]]), 
				.iREGISTER_LOGIC_DEST(rs_alu3_regist_logic_dest[i[2:0]]),
				.iREGISTER_DESTINATION_REGNAME(rs_alu3_regist_destination_regname[i[2:0]]), 
				.iREGISTER_DESTINATION_SYSREG(rs_alu3_regist_destination_sysreg[i[2:0]]),
				.iREGISTER_COMMIT_TAG(rs_alu3_regist_commit_tag[i[2:0]]),
				.iREGISTER_PC(rs_alu3_regist_pc[i[2:0]]), 
				.iREGISTER_EX_REGIST_POINTER(rs_alu3_regist_ex_inorder_regist_pointer[i[2:0]]),
				.iADDER_VALID(iSCHE2_EX_ALU1_VALID && !iSCHE2_EX_ALU1_DESTINATION_SYSREG), 
				.iADDER_DESTINATION_REGNAME(iSCHE2_EX_ALU1_DESTINATION_REGNAME), 
				.iADDER_WRITEBACK(iSCHE2_EX_ALU1_WRITEBACK), 
				.iADDER_DATA(iSCHE2_EX_ALU1_DATA), 
				.iMULDIV_VALID(iSCHE2_EX_ALU2_VALID && !iSCHE2_EX_ALU2_DESTINATION_SYSREG), 
				.iMULDIV_DESTINATION_REGNAME(iSCHE2_EX_ALU2_DESTINATION_REGNAME), 
				.iMULDIV_WRITEBACK(iSCHE2_EX_ALU2_WRITEBACK), 
				.iMULDIV_DATA(iSCHE2_EX_ALU2_DATA), 
				.iLDST_VALID(iSCHE2_ALU3_VALID && iSCHE2_ALU3_WRITEBACK && !iSCHE2_ALU3_DESTINATION_SYSREG), 
				.iLDST_DESTINATION_REGNAME(iSCHE2_ALU3_DESTINATION_REGNAME), 
				.iLDST_DATA(iSCHE2_ALU3_DATA),
				.iEX_EXECUTION_POINTER(w_ex_inorder_execution_pointer),
				.iEXOUT_VALID(rs_alu3_exout_valid[i[2:0]] & !iNEXT_EX_ALU3_LOCK), 
				.oINFO_ENTRY_VALID(rs_alu3_info_entry_valid[i[2:0]]), 
				.oINFO_MATCHING(rs_alu3_info_matching[i[2:0]]), 
				.oINFO_CMD(rs_alu3_info_cmd[i[2:0]]), 
				.oINFO_SYS_LDST(rs_alu3_info_sys_ldst[i[2:0]]), 
				.oINFO_LDST(rs_alu3_info_ldst[i[2:0]]),
				.oINFO_SOURCE0_VALID(rs_alu3_info_source0_valid[i[2:0]]), 
				.oINFO_SOURCE0_SYSREG(rs_alu3_info_source0_sysreg[i[2:0]]), 
				.oINFO_SOURCE0(rs_alu3_info_source0[i[2:0]]), 
				.oINFO_SOURCE1_VALID(rs_alu3_info_source1_valid[i[2:0]]), 
				.oINFO_SOURCE1_SYSREG(rs_alu3_info_source1_sysreg[i[2:0]]), 
				.oINFO_SOURCE1(rs_alu3_info_source1[i[2:0]]), 
				.oINFO_ADV_ACTIVE(rs_alu3_info_adv_active[i[2:0]]),
				.oINFO_ADV_DATA(rs_alu3_info_adv_data[i[2:0]]),
				.oINFO_LOGIC_DEST(rs_alu3_info_logic_dest[i[2:0]]),
				.oINFO_DESTINATION_REGNAME(rs_alu3_info_destination_regname[i[2:0]]), 
				.oINFO_DESTINATION_SYSREG(rs_alu3_info_destination_sysreg[i[2:0]]),
				.oINFO_COMMIT_TAG(rs_alu3_info_commit_tag[i[2:0]]),
				.oINFO_PC(rs_alu3_info_pc[i[2:0]])
			);
		end
	endgenerate
	
	

	/****************************************
	Function
	****************************************/
	//Reservation station or General Register Free Entry Search
	function [3:0] func_free_entry_search8to1;
		/* Output Signal
		[3] : Entry Valid
		[2:0] :	Entry Table Number
		*/
		input func_free_entry_search8to1_entry_valid0;
		input func_free_entry_search8to1_entry_valid1;
		input func_free_entry_search8to1_entry_valid2;
		input func_free_entry_search8to1_entry_valid3;
		input func_free_entry_search8to1_entry_valid4;
		input func_free_entry_search8to1_entry_valid5;
		input func_free_entry_search8to1_entry_valid6;
		input func_free_entry_search8to1_entry_valid7;
		
		reg func_free_entry_search8to1_tournament_data0_valid;
		reg [2:0] func_free_entry_search8to1_tournament_data0_num;
		
		reg func_free_entry_search8to1_tournament_data1_valid0;
		reg [2:0] func_free_entry_search8to1_tournament_data1_num0;
		reg func_free_entry_search8to1_tournament_data1_valid1;
		reg [2:0] func_free_entry_search8to1_tournament_data1_num1;
		
		reg func_free_entry_search8to1_tournament_data2_valid0[0:1];
		reg [2:0] func_free_entry_search8to1_tournament_data2_num0[0:1];
		reg func_free_entry_search8to1_tournament_data2_valid1[0:1];
		reg [2:0] func_free_entry_search8to1_tournament_data2_num1[0:1];
		
		begin
			//2
			func_free_entry_search8to1_tournament_data2_valid0[0] =	func_free_entry_search8to1_entry_valid0 | func_free_entry_search8to1_entry_valid1;
			func_free_entry_search8to1_tournament_data2_num0[0] = (func_free_entry_search8to1_entry_valid0)? 3'h0 : 3'h1;
			func_free_entry_search8to1_tournament_data2_valid1[0] =	func_free_entry_search8to1_entry_valid2 | func_free_entry_search8to1_entry_valid3;
			func_free_entry_search8to1_tournament_data2_num1[0] = (func_free_entry_search8to1_entry_valid2)? 3'h2 : 3'h3;	
			func_free_entry_search8to1_tournament_data2_valid0[1] = func_free_entry_search8to1_entry_valid4 | func_free_entry_search8to1_entry_valid5;
			func_free_entry_search8to1_tournament_data2_num0[1] = (func_free_entry_search8to1_entry_valid4)? 3'h4 : 3'h5;
			func_free_entry_search8to1_tournament_data2_valid1[1] = func_free_entry_search8to1_entry_valid6 | func_free_entry_search8to1_entry_valid7;
			func_free_entry_search8to1_tournament_data2_num1[1] = (func_free_entry_search8to1_entry_valid6)? 3'h6 : 3'h7;
			//1
			func_free_entry_search8to1_tournament_data1_valid0 = func_free_entry_search8to1_tournament_data2_valid0[0] | func_free_entry_search8to1_tournament_data2_valid1[0];
			func_free_entry_search8to1_tournament_data1_num0 = (func_free_entry_search8to1_tournament_data2_valid0[0])? func_free_entry_search8to1_tournament_data2_num0[0] : func_free_entry_search8to1_tournament_data2_num1[0];
			func_free_entry_search8to1_tournament_data1_valid1 = func_free_entry_search8to1_tournament_data2_valid0[1] | func_free_entry_search8to1_tournament_data2_valid1[1];
			func_free_entry_search8to1_tournament_data1_num1 = (func_free_entry_search8to1_tournament_data2_valid0[1])? func_free_entry_search8to1_tournament_data2_num0[1] : func_free_entry_search8to1_tournament_data2_num1[1];
			//0
			func_free_entry_search8to1_tournament_data0_valid = func_free_entry_search8to1_tournament_data1_valid0 | func_free_entry_search8to1_tournament_data1_valid1;
			func_free_entry_search8to1_tournament_data0_num = (func_free_entry_search8to1_tournament_data1_valid0)? func_free_entry_search8to1_tournament_data1_num0 : func_free_entry_search8to1_tournament_data1_num1;
			
			//Assign
			func_free_entry_search8to1 = {func_free_entry_search8to1_tournament_data0_valid, func_free_entry_search8to1_tournament_data0_num};
		end
	endfunction	
	
	
	
	
	function [9:0] func_entry_search16to2;
		/* Output Signal
		[9] : Entry 1 Valid
		[8:5] :	Entry 1 Table Numver
		[4] : Entry 0	Valid
		[3:0] :	Entry 0 Table Number
		*/
		input		func_entry0;
		input		func_entry1;
		input		func_entry2;
		input		func_entry3;
		input		func_entry4;
		input		func_entry5;
		input		func_entry6;
		input		func_entry7;
		input		func_entry8;
		input		func_entry9;
		input		func_entry10;
		input		func_entry11;
		input		func_entry12;
		input		func_entry13;
		input		func_entry14;
		input		func_entry15;
		
		reg	[3:0] func_reg_out0;
		reg	[3:0] func_reg_out1;
		reg			func_reg_out0_valid;
		reg			func_reg_out1_valid;
		reg	[15:0] func_segment;		
		begin
			//Segment Input
			func_segment = {func_entry15, func_entry14, func_entry13, func_entry12,
										func_entry11, func_entry10, func_entry9, func_entry8,
										func_entry7, func_entry6, func_entry5, func_entry4,
										func_entry3, func_entry2, func_entry1, func_entry0};
			//Out0
			if(func_segment[15])begin
				func_reg_out0 = 4'd15;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[14])begin
				func_reg_out0 = 4'd14;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[13])begin
				func_reg_out0 = 4'd13;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[12])begin
				func_reg_out0 = 4'd12;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[11])begin
				func_reg_out0 = 4'd11;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[10])begin
				func_reg_out0 = 4'd10;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[9])begin
				func_reg_out0 = 4'd9;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[8])begin
				func_reg_out0 = 4'd8;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[7])begin
				func_reg_out0 = 4'd7;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[6])begin
				func_reg_out0 = 4'd6;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[5])begin
				func_reg_out0 = 4'd5;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[4])begin
				func_reg_out0 = 4'd4;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[3])begin
				func_reg_out0 = 4'd3;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[2])begin
				func_reg_out0 = 4'd2;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[1])begin
				func_reg_out0 = 4'd1;
				func_reg_out0_valid = 1'h1;
			end
			else if(func_segment[0])begin
				func_reg_out0 = 4'd0;
				func_reg_out0_valid = 1'h1;
			end
			else begin
				func_reg_out0 = 4'd0;
				func_reg_out0_valid = 1'h0;
			end			
			//Out1
			if(!func_reg_out0_valid || !(func_reg_out0_valid && (func_reg_out0 == 4'h0)))begin
				if(func_segment[0] && func_reg_out0 > 4'd0)begin	
					func_reg_out1 = 4'd0;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[1] && func_reg_out0 > 4'd1)begin	
					func_reg_out1 = 4'd1;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[2] && func_reg_out0 > 4'd2)begin	
					func_reg_out1 = 4'd2;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[3] && func_reg_out0 > 4'd3)begin	
					func_reg_out1 = 4'd3;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[4] && func_reg_out0 > 4'd4)begin	
					func_reg_out1 = 4'd4;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[5] && func_reg_out0 > 4'd5)begin	
					func_reg_out1 = 4'd5;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[6] && func_reg_out0 > 4'd6)begin	
					func_reg_out1 = 4'd6;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[7] && func_reg_out0 > 4'd7)begin	
					func_reg_out1 = 4'd7;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[8] && func_reg_out0 > 4'd8)begin	
					func_reg_out1 = 4'd8;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[9] && func_reg_out0 > 4'd9)begin	
					func_reg_out1 = 4'd9;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[10] && func_reg_out0 > 4'd10)begin	
					func_reg_out1 = 4'd10;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[11] && func_reg_out0 > 4'd11)begin	
					func_reg_out1 = 4'd11;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[12] && func_reg_out0 > 4'd12)begin	
					func_reg_out1 = 4'd12;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[13] && func_reg_out0 > 4'd13)begin	
					func_reg_out1 = 4'd13;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[14] && func_reg_out0 > 4'd14)begin	
					func_reg_out1 = 4'd14;
					func_reg_out1_valid = 1'h1;
				end
				else if(func_segment[15] && func_reg_out0 > 4'd15)begin	
					func_reg_out1 = 4'd15;
					func_reg_out1_valid = 1'h1;
				end
				else begin	
					func_reg_out1 = 4'd0;
					func_reg_out1_valid = 1'h0;
				end

			end
			else begin
				func_reg_out1 = 4'h0;
				func_reg_out1_valid = 1'b0;
			end
			
		func_entry_search16to2 = {func_reg_out1_valid, func_reg_out1, func_reg_out0_valid, func_reg_out0};
			
		end
	endfunction
	
	
	/****************************************
	Module Assign
	****************************************/
	//Sysreg Info
	assign oSYSREGINFO_TIDR = w_sysreg_tidr_info_data;
	assign oSYSREGINFO_PTIDR = w_sysreg_ptidr_info_data;
	assign oSYSREGINFO_PSR = w_sysreg_psr_info_data;
	assign oSYSREGINFO_PPSR = w_sysreg_ppsr_info_data;
	assign oSYSREGINFO_TISR = w_sysreg_tisr_info_data;
	assign oSYSREGINFO_PDTR = w_sysreg_pdtr_info_data;
	assign oSYSREGINFO_IDTR = w_sysreg_idtr_info_data;	
	assign oSYSREGINFO_PPCR = w_sysreg_ppcr_info_data;
	//To ALU-0
	assign oNEXT_EX_BRANCH_VALID = rs_branch_exout_all_valid;
	assign oNEXT_EX_BRANCH_COMMIT_TAG = rs_alu0_info_commit_tag[w_rs_branch_exe_pointer];
	assign oNEXT_EX_BRANCH_CMD = rs_alu0_info_cmd[w_rs_branch_exe_pointer];
	assign oNEXT_EX_BRANCH_CC = rs_alu0_info_cc[w_rs_branch_exe_pointer];
	assign oNEXT_EX_BRANCH_FLAG = rs_alu0_info_flag[w_rs_branch_exe_pointer];
	//assign oNEXT_EX_BRANCH_SOURCE0 = rs_branch_info_source0[w_rs_branch_exe_pointer];
	assign oNEXT_EX_BRANCH_SOURCE = rs_alu0_info_source1[w_rs_branch_exe_pointer];
	assign oNEXT_EX_PC = rs_alu0_info_pc[w_rs_branch_exe_pointer];
	
	//To ALU-1
	assign oNEXT_EX_ALU1_VALID = rs_alu1_exout_entry_num_valid;
	assign oNEXT_EX_ALU1_WRITEBACK = rs_alu1_info_writeback[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_COMMIT_TAG = rs_alu1_info_commit_tag[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_CMD = rs_alu1_info_cmd[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_AFE = rs_alu1_info_afe[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_SYS_REG = rs_alu1_info_sys_reg[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_LOGIC = rs_alu1_info_logic[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_SHIFT = rs_alu1_info_shift[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_ADDER = rs_alu1_info_adder[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_MUL = rs_alu1_info_mul[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_SDIV = rs_alu1_info_sdiv[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_UDIV = rs_alu1_info_udiv[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_SOURCE0 = rs_alu1_info_source0[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_SOURCE1 = rs_alu1_info_source1[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_DESTINATION_SYSREG = rs_alu1_info_destination_sysreg[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_LOGIC_DEST = rs_alu1_info_logic_dest[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_DESTINATION_REGNAME = rs_alu1_info_destination_regname[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_FLAGS_WRITEBACK = rs_alu1_info_flags_writeback[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_FLAGS_REGNAME = rs_alu1_info_flags_regname[rs_alu1_exout_entry_num];
	assign oNEXT_EX_ALU1_PCR = rs_alu1_info_pcr[rs_alu1_exout_entry_num];
	
	//To ALU-2
	assign oNEXT_EX_ALU2_VALID = rs_alu2_exout_entry_num_valid;
	assign oNEXT_EX_ALU2_WRITEBACK = rs_alu2_info_writeback[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_COMMIT_TAG = rs_alu2_info_commit_tag[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_CMD = rs_alu2_info_cmd[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_AFE = rs_alu2_info_afe[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_SYS_REG = rs_alu2_info_sys_reg[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_LOGIC = rs_alu2_info_logic[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_SHIFT = rs_alu2_info_shift[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_ADDER = rs_alu2_info_adder[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_SOURCE0 = rs_alu2_info_source0[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_SOURCE1 = rs_alu2_info_source1[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_DESTINATION_SYSREG = rs_alu2_info_destination_sysreg[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_LOGIC_DEST = rs_alu2_info_logic_dest[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_DESTINATION_REGNAME = rs_alu2_info_destination_regname[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_FLAGS_WRITEBACK = rs_alu2_info_flags_writeback[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_FLAGS_REGNAME = rs_alu2_info_flags_regname[rs_alu2_exout_entry_num];
	assign oNEXT_EX_ALU2_PCR = rs_alu2_info_pcr[rs_alu2_exout_entry_num];
		
	//To ALU-3
	//rs_alu3_info_source0_sysreg[w_rs_alu3_exe_pointer];
	//rs_alu3_info_source1_sysreg[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_VALID = rs_alu3_exout_all_valid;
	assign oNEXT_EX_ALU3_DESTINATION_SYSREG = rs_alu3_info_destination_sysreg[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_COMMIT_TAG = rs_alu3_info_commit_tag[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_CMD = rs_alu3_info_cmd[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_SYS_LDST = rs_alu3_info_sys_ldst[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_LDST = rs_alu3_info_ldst[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_SOURCE0 = rs_alu3_info_source0[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_SOURCE1 = rs_alu3_info_source1[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_ADV_ACTIVE = rs_alu3_info_adv_active[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_ADV_DATA = rs_alu3_info_adv_data[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_LOGIC_DEST = rs_alu3_info_logic_dest[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_DESTINATION_REGNAME = rs_alu3_info_destination_regname[w_rs_alu3_exe_pointer];
	assign oNEXT_EX_ALU3_PC = rs_alu3_info_pc[w_rs_alu3_exe_pointer];
	//Register Free List
	assign oOTHER_REGISTER_0_WR = gr_freelist_0_set_valid & ~iOTHER_REGISTER_0_FULL;//& !this_lock;
	assign oOTHER_REGISTER_0_NUM = gr_freelist_0_set_num;
	assign oOTHER_REGISTER_1_WR = gr_freelist_1_set_valid & ~iOTHER_REGISTER_1_FULL;//& !this_lock;
	assign oOTHER_REGISTER_1_NUM = gr_freelist_1_set_num;
	assign oFLAG_REGISTER_0_WR = flag_rename_management_select_0_valid && !iFLAG_REGISTER_0_FULL;
	assign oFLAG_REGISTER_0_NUM = flag_rename_management_select_0_num;
	assign oFLAG_REGISTER_1_WR = flag_rename_management_select_1_valid && !iFLAG_REGISTER_1_FULL;
	assign oFLAG_REGISTER_1_NUM = flag_rename_management_select_1_num;
	

	//Lock
	assign oPREVIOUS_LOCK = this_lock;
		
endmodule

`default_nettype wire

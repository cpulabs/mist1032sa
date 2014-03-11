/****************************************
	Scheduler1 Unit (Out of Order Unit 1/2)
	- Register Freelist & Comitbiffer
	
	
	Make	:	2010/11/05
	Update	:	
****************************************/
`default_nettype none



module scheduler1(
		//System
		input wire iCLOCK,
		input wire inRESET,	
		//Interrupt
		input wire iIRQ_VALID,		
		//Free
		input wire iEXCEPTION_EVENT,
		input wire [5:0] iEXCEPTION_COMMIT_TAG,
		input wire iEXCEPTION_RESTART,	
		output wire [31:0] oFREE_CURRENT_PC,
		output wire [63:0] oFREE_REGISTER,
		//Info
		output wire [5:0] oINFO_COMMIT_COUNTER,
		output wire oINFO_EXCEPTION_PROTECT,
		//Register Rename Table - Rollback Info
		output wire oRENAME_ROLLBACK_UPDATE_INFO0_VALID,			
		output wire [4:0] oRENAME_ROLLBACK_UPDATE_INFO0_LREGNAME,		
		output wire [5:0] oRENAME_ROLLBACK_UPDATE_INFO0_PREGNAME,		
		output wire oRENAME_ROLLBACK_UPDATE_INFO0_SYSREG,		
		output wire oRENAME_ROLLBACK_UPDATE_INFO1_VALID,		
		output wire [4:0] oRENAME_ROLLBACK_UPDATE_INFO1_LREGNAME,		
		output wire [5:0] oRENAME_ROLLBACK_UPDATE_INFO1_PREGNAME,		
		output wire oRENAME_ROLLBACK_UPDATE_INFO1_SYSREG,	
		output wire oRENAME_ROLLBACK_UPDATE_INFO2_VALID,	
		output wire [4:0] oRENAME_ROLLBACK_UPDATE_INFO2_LREGNAME,	
		output wire [5:0] oRENAME_ROLLBACK_UPDATE_INFO2_PREGNAME,		
		output wire oRENAME_ROLLBACK_UPDATE_INFO2_SYSREG,		
		output wire oRENAME_ROLLBACK_UPDATE_INFO3_VALID,		
		output wire [4:0] oRENAME_ROLLBACK_UPDATE_INFO3_LREGNAME,		
		output wire [5:0] oRENAME_ROLLBACK_UPDATE_INFO3_PREGNAME,		
		output wire oRENAME_ROLLBACK_UPDATE_INFO3_SYSREG,		
		output wire oFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_VALID,
		output wire [3:0] oFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_PREGNAME,
		output wire oFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_VALID,
		output wire [3:0] oFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_PREGNAME,
		output wire oFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_VALID,
		output wire [3:0] oFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_PREGNAME,
		output wire oFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_VALID,
		output wire [3:0] oFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_PREGNAME,
		//Commit Infomation			
		output wire [2:0] oCOMMIT_OFFSET,							
		//Re Order Buffer
		output wire [63:0] oCOMMIT_ENTRY_COMMIT_VECTOR,
		//EX_Output - Branch
		input wire iSCHE1_EX_BRANCH_VALID,
		input wire [5:0] iSCHE1_EX_BRANCH_COMMIT_TAG,
		//EX_Output - ADDER
		input wire iSCHE1_EX_ALU1_VALID,
		input wire [5:0] iSCHE1_EX_ALU1_COMMIT_TAG,
		//EX_Output - MULDIV
		input wire iSCHE1_EX_ALU2_VALID,
		input wire [5:0] iSCHE1_EX_ALU2_COMMIT_TAG,
		//LDST_Output
		input wire iSCHE1_EX_ALU3_VALID,
		input wire [5:0] iSCHE1_EX_ALU3_COMMIT_TAG,
		//StageInfo
		output wire oSTAGE_INFO_0_VALID,
		output wire oSTAGE_INFO_1_VALID,
		output wire [5:0] oSTAGE_INFO_REGIST_POINTER,		
		output wire [5:0] oSTAGE_INFO_COMMIT_POINTER,	
		//Previous-0			
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
		input wire [3:0] iPREVIOUS_0_CC_AFE,		
		input wire [3:0] iPREVIOUS_0_FLAGS_REGNAME,
		input wire [5:0] iPREVIOUS_0_DESTINATION_REGNAME,
		input wire [4:0] iPREVIOUS_0_LOGIC_DESTINATION,
		input wire [5:0] iPREVIOUS_0_SOURCE0,
		input wire [31:0] iPREVIOUS_0_SOURCE1,
		input wire [5:0] iPREVIOUS_0_ADV_DATA,
		input wire iPREVIOUS_0_SOURCE0_FLAGS,	
		input wire iPREVIOUS_0_SOURCE1_IMM,	
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
		//Previous-1	
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
		input wire [3:0] iPREVIOUS_1_CC_AFE,	
		input wire [3:0] iPREVIOUS_1_FLAGS_REGNAME,		
		input wire [5:0] iPREVIOUS_1_DESTINATION_REGNAME,
		input wire [4:0] iPREVIOUS_1_LOGIC_DESTINATION,
		input wire [5:0] iPREVIOUS_1_SOURCE0,
		input wire [31:0] iPREVIOUS_1_SOURCE1,
		input wire [5:0] iPREVIOUS_1_ADV_DATA,
		input wire iPREVIOUS_1_SOURCE0_FLAGS,
		input wire iPREVIOUS_1_SOURCE1_IMM,
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
		//Previous-Register
		input wire iFLAG_REGISTER_0_RD,
		output wire [3:0] oFLAG_REGISTER_0_NUM,
		output wire oFLAG_REGISTER_0_EMPTY,
		input wire iFLAG_REGISTER_1_RD,
		output wire [3:0] oFLAG_REGISTER_1_NUM,
		output wire oFLAG_REGISTER_1_EMPTY,
		input wire iOTHER_REGISTER_0_RD,
		output wire [5:0] oOTHER_REGISTER_0_NUM,
		output wire oOTHER_REGISTER_0_EMPTY,
		input wire iOTHER_REGISTER_1_RD,
		output wire [5:0] oOTHER_REGISTER_1_NUM,
		output wire oOTHER_REGISTER_1_EMPTY,
		//Next-Register
		input wire iFLAG_REGISTER_0_WR,
		input wire [3:0] iFLAG_REGISTER_0_NUM,
		output wire oFLAG_REGISTER_0_FULL,
		output wire [1:0] oFLAG_REGISTER_0_COUNT,
		input wire iFLAG_REGISTER_1_WR,
		input wire [3:0] iFLAG_REGISTER_1_NUM,
		output wire oFLAG_REGISTER_1_FULL,
		output wire [1:0] oFLAG_REGISTER_1_COUNT,
		input wire iOTHER_REGISTER_0_WR,
		input wire [5:0] iOTHER_REGISTER_0_NUM,
		output wire oOTHER_REGISTER_0_FULL,
		output wire [2:0] oOTHER_REGISTER_0_COUNT,
		input wire iOTHER_REGISTER_1_WR,
		input wire [5:0] iOTHER_REGISTER_1_NUM,
		output wire oOTHER_REGISTER_1_FULL,
		output wire [2:0] oOTHER_REGISTER_1_COUNT,
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
		output wire oNEXT_0_WRITEBACK,	
		output wire oNEXT_0_FLAGS_WRITEBACK,			
		output wire [4:0] oNEXT_0_CMD,
		output wire [5:0] oNEXT_0_COMMIT_TAG,
		output wire [3:0] oNEXT_0_CC_AFE,		
		output wire [3:0] oNEXT_0_FLAGS_REGNAME,
		output wire [5:0] oNEXT_0_DESTINATION_REGNAME,
		output wire [4:0] oNEXT_0_LOGIC_DESTINATION,
		output wire [5:0] oNEXT_0_SOURCE0,
		output wire [31:0] oNEXT_0_SOURCE1,
		output wire [5:0] oNEXT_0_ADV_DATA,
		output wire oNEXT_0_SOURCE0_FLAGS,
		output wire oNEXT_0_SOURCE1_IMM,	
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
		output wire oNEXT_1_WRITEBACK,	
		output wire oNEXT_1_FLAGS_WRITEBACK,
		output wire [4:0] oNEXT_1_CMD,
		output wire [5:0] oNEXT_1_COMMIT_TAG,
		output wire [3:0] oNEXT_1_CC_AFE,		
		output wire [3:0] oNEXT_1_FLAGS_REGNAME,
		output wire [5:0] oNEXT_1_DESTINATION_REGNAME,
		output wire [4:0] oNEXT_1_LOGIC_DESTINATION,
		output wire [5:0] oNEXT_1_SOURCE0,
		output wire [31:0] oNEXT_1_SOURCE1,
		output wire [5:0] oNEXT_1_ADV_DATA,
		output wire oNEXT_1_SOURCE0_FLAGS,
		output wire oNEXT_1_SOURCE1_IMM,
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
	
	localparam PL_STT_NORMAL = 1'b0;
	localparam PL_STT_EXCEPTION = 1'b1;
	
	
	/***********************************************
	Wire and Register
	***********************************************/
	//Generate
	genvar i;			
	//Commit List
	wire [63:0] entry_commit_valid;
	wire entry_info_entry_valid[0:63];
	wire entry_info_make_flags[0:63];
	wire [31:0] entry_info_pc[0:63];
	wire [3:0] entry_info_flags_regname[0:63];
	wire entry_info_writeback[0:63];
	wire [4:0] entry_info_logic_destination[0:63];
	wire [5:0] entry_info_destination_regname[0:63];
	wire entry_info_dest_sysreg[0:63];
	wire entry_info_ex_branch[0:63];
	wire [63:0] entry_info_ex_end;
	//Commit Valid
	wire entry_commit_0_valid;
	wire entry_commit_1_valid;
	wire entry_commit_2_valid;
	wire entry_commit_3_valid;
	wire [5:0] entry_commit_0_num;
	wire [5:0] entry_commit_1_num;
	wire [5:0] entry_commit_2_num;
	wire [5:0] entry_commit_3_num;
	//Exception Protect Check(Non Core Exceotion Block)
	wire exception_protect;
	//Commit Infomation
	wire [6:0] w_commit_count;
	wire [2:0] w_commit_offset;		
	wire [5:0] w_commit_pointer;
	wire [5:0] w_register_pointer;
	wire [5:0] ww_regist_pointer;
	//Commit Count Register
	reg [6:0] b_commit_pointer;
	reg [6:0] b_regist_pointer;
	reg [6:0] bb_regist_pointer;
	//Commit Id Info
	wire w_commit_id_n0_valid;
	wire w_commit_id_n1_valid;
	wire w_commit_id_n2_valid;
	wire w_commit_id_n3_valid;
	wire [5:0] w_commit_id_n0;
	wire [5:0] w_commit_id_n1;
	wire [5:0] w_commit_id_n2;
	wire [5:0] w_commit_id_n3;
	//RollBack Register
	reg b_commit_id_n0_valid;
	reg b_commit_id_n1_valid;
	reg b_commit_id_n2_valid;
	reg b_commit_id_n3_valid;
	reg [5:0] b_commit_id_n0;
	reg [5:0] b_commit_id_n1;
	reg [5:0] b_commit_id_n2;
	reg [5:0] b_commit_id_n3;
	
	reg [4:0] b_commit_lregname_n0;
	reg [4:0] b_commit_lregname_n1;
	reg [4:0] b_commit_lregname_n2;
	reg [4:0] b_commit_lregname_n3;
	reg [5:0] b_commit_pregname_n0;
	reg [5:0] b_commit_pregname_n1;
	reg [5:0] b_commit_pregname_n2;
	reg [5:0] b_commit_pregname_n3;
	reg b_commit_writeback_n0;
	reg b_commit_writeback_n1;
	reg b_commit_writeback_n2;
	reg b_commit_writeback_n3;
	reg b_commit_dest_sysreg_n0;
	reg b_commit_dest_sysreg_n1;
	reg b_commit_dest_sysreg_n2;
	reg b_commit_dest_sysreg_n3;
	reg b_commit_flags_make_flags_n0;
	reg b_commit_flags_make_flags_n1;
	reg b_commit_flags_make_flags_n2;
	reg b_commit_flags_make_flags_n3;
	reg [3:0] b_commit_flags_p_regname_n0;
	reg [3:0] b_commit_flags_p_regname_n1;
	reg [3:0] b_commit_flags_p_regname_n2;
	reg [3:0] b_commit_flags_p_regname_n3;
	//Next Stage Buffer
	//Instruction0
	reg b0_valid;				
	reg b0_source0_active;	
	reg b0_source1_active;
	reg b0_source0_sysreg;
	reg b0_source1_sysreg;	
	reg b0_source0_sysreg_rename;
	reg b0_source1_sysreg_rename;		
	reg b0_adv_active;
	reg b0_destination_sysreg;					
	reg b0_data_writeback;	
	reg b0_flags_writeback;
	reg [4:0] b0_cmd;
	reg [5:0] b0_commit_tag;
	reg [3:0] b0_cc_afe;
	reg [3:0] b0_flags_regname;
	reg [5:0] b0_destination_regname;
	reg [4:0] b0_logic_destination;
	reg [5:0] b0_source0;
	reg [31:0] b0_source1;
	reg [5:0] b0_adv_data;
	reg b0_source0_flags;	
	reg b0_source1_imm;		
	reg b0_ex_sys_adder;
	reg b0_ex_sys_ldst;		
	reg b0_ex_logic;
	reg b0_ex_shift;
	reg b0_ex_adder;
	reg b0_ex_mul;
	reg b0_ex_sdiv;
	reg b0_ex_udiv;
	reg b0_ex_ldst;
	reg b0_ex_branch;
	//Instruction1
	reg b1_valid;					
	reg b1_source0_active;	
	reg b1_source1_active;
	reg b1_source0_sysreg;			
	reg b1_source1_sysreg;	
	reg b1_source0_sysreg_rename;
	reg b1_source1_sysreg_rename;
	reg b1_adv_active;
	reg b1_destination_sysreg;					
	reg b1_data_writeback;	
	reg b1_flags_writeback;
	reg [4:0] b1_cmd;
	reg [5:0] b1_commit_tag;
	reg [3:0] b1_cc_afe;
	reg [3:0] b1_flags_regname;
	reg [5:0] b1_destination_regname;
	reg [4:0] b1_logic_destination;
	reg [5:0] b1_source0;
	reg [31:0] b1_source1;
	reg [5:0] b1_adv_data;
	reg b1_source0_flags;
	reg b1_source1_imm;			
	reg b1_ex_sys_adder;
	reg b1_ex_sys_ldst;	
	reg b1_ex_logic;
	reg b1_ex_shift;
	reg b1_ex_adder;
	reg b1_ex_mul;
	reg b1_ex_sdiv;
	reg b1_ex_udiv;
	reg b1_ex_ldst;
	reg b1_ex_branch;
	reg [31:0] b_pc;
	//Scheduler State
	reg [1:0] b_scheduler_state;
	//Lock
	wire this_lock;
	wire [6:0] check_counter;
				
	
	/****************************************
	LOCK
	****************************************/
	assign check_counter = w_commit_count[6:0] + 7'h02;	//2011/12/18	
	assign this_lock = iNEXT_LOCK | check_counter[6] == 1'b1;//2011/12/18 iNEXT_LOCK | w_commit_count[6:5] == 2'b01;//2011/12/17 iNEXT_LOCK | w_commit_count[6] == 1'b1;

				
				
	/****************************************
	Next <-> Previous	(Register Free List)
	****************************************/
	//parameter is N, DEPTH, DEPTH_N
	mist1032sa_sync_fifo #(4, 4, 2) FRAG_REG_FREELIST0(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET), 
		.iREMOVE(iEXCEPTION_RESTART), 
		.oCOUNT(oFLAG_REGISTER_0_COUNT), 	
		.iWR_EN(iFLAG_REGISTER_0_WR), 
		.iWR_DATA(iFLAG_REGISTER_0_NUM), 
		.oWR_FULL(oFLAG_REGISTER_0_FULL),
		.iRD_EN(iFLAG_REGISTER_0_RD), 
		.oRD_DATA(oFLAG_REGISTER_0_NUM), 
		.oRD_EMPTY(oFLAG_REGISTER_0_EMPTY)
	);
	
	//parameter is N, DEPTH, DEPTH_N
	mist1032sa_sync_fifo #(4, 4, 2) FRAG_REG_FREELIST1(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET), 
		.iREMOVE(iEXCEPTION_RESTART), 
		.oCOUNT(oFLAG_REGISTER_1_COUNT), 	
		.iWR_EN(iFLAG_REGISTER_1_WR), 
		.iWR_DATA(iFLAG_REGISTER_1_NUM), 
		.oWR_FULL(oFLAG_REGISTER_1_FULL),
		.iRD_EN(iFLAG_REGISTER_1_RD), 
		.oRD_DATA(oFLAG_REGISTER_1_NUM), 
		.oRD_EMPTY(oFLAG_REGISTER_1_EMPTY)
	);
	
	
	mist1032sa_sync_fifo #(6, 8, 3) GR_REG_FREELIST0(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET), 
		.iREMOVE(iEXCEPTION_RESTART/*restart*/), 
		.oCOUNT(oOTHER_REGISTER_0_COUNT), 	
		.iWR_EN(iOTHER_REGISTER_0_WR), 
		.iWR_DATA(iOTHER_REGISTER_0_NUM), 
		.oWR_FULL(oOTHER_REGISTER_0_FULL),
		.iRD_EN(iOTHER_REGISTER_0_RD), 
		.oRD_DATA(oOTHER_REGISTER_0_NUM), 
		.oRD_EMPTY(oOTHER_REGISTER_0_EMPTY)
	);
	mist1032sa_sync_fifo #(6, 8, 3) GR_REG_FREELIST1(
		.iCLOCK(iCLOCK), .inRESET(inRESET), 
		.iREMOVE(iEXCEPTION_RESTART/*restart*/), 
		.oCOUNT(oOTHER_REGISTER_1_COUNT), 	
		.iWR_EN(iOTHER_REGISTER_1_WR), 
		.iWR_DATA(iOTHER_REGISTER_1_NUM), 
		.oWR_FULL(oOTHER_REGISTER_1_FULL),
		.iRD_EN(iOTHER_REGISTER_1_RD), 
		.oRD_DATA(oOTHER_REGISTER_1_NUM), 
		.oRD_EMPTY(oOTHER_REGISTER_1_EMPTY)
	);
	
	/****************************************
	Commit Id Info
	****************************************/	
	assign w_commit_id_n0_valid = (w_commit_offset == 3'h4 || w_commit_offset == 3'h3 || w_commit_offset == 3'h2 || w_commit_offset == 3'h1 || iEXCEPTION_RESTART/*iranai kamo sirenai*/)? 1'b1 : 1'b0;
	assign w_commit_id_n1_valid = (w_commit_offset == 3'h4 || w_commit_offset == 3'h3 || w_commit_offset == 3'h2)? 1'b1 : 1'b0;
	assign w_commit_id_n2_valid = (w_commit_offset == 3'h4 || w_commit_offset == 3'h3)? 1'b1 : 1'b0;
	assign w_commit_id_n3_valid = (w_commit_offset == 3'h4)? 1'b1 : 1'b0;
	assign w_commit_id_n0 = w_commit_pointer + 6'h00;
	assign w_commit_id_n1 = w_commit_pointer + 6'h01;
	assign w_commit_id_n2 = w_commit_pointer + 6'h02;
	assign w_commit_id_n3 = w_commit_pointer + 6'h03;
	
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_commit_id_n0_valid <= 1'b0;
			b_commit_id_n1_valid <= 1'b0;
			b_commit_id_n2_valid <= 1'b0;
			b_commit_id_n3_valid <= 1'b0;
			b_commit_id_n0 <= {6{1'b0}};
			b_commit_id_n1 <= {6{1'b0}};
			b_commit_id_n2 <= {6{1'b0}};
			b_commit_id_n3 <= {6{1'b0}};
			
			b_commit_lregname_n0 <= {5{1'b0}};
			b_commit_lregname_n1 <= {5{1'b0}};
			b_commit_lregname_n2 <= {5{1'b0}};
			b_commit_lregname_n3 <= {5{1'b0}};
			b_commit_pregname_n0 <= {6{1'b0}};
			b_commit_pregname_n1 <= {6{1'b0}};
			b_commit_pregname_n2 <= {6{1'b0}};
			b_commit_pregname_n3 <= {6{1'b0}};
			b_commit_writeback_n0 <= 1'b0;
			b_commit_writeback_n1 <= 1'b0;
			b_commit_writeback_n2 <= 1'b0;
			b_commit_writeback_n3 <= 1'b0;
			b_commit_dest_sysreg_n0 <= 1'b0;
			b_commit_dest_sysreg_n1 <= 1'b0;
			b_commit_dest_sysreg_n2 <= 1'b0;
			b_commit_dest_sysreg_n3 <= 1'b0;
			
			b_commit_flags_make_flags_n0 <= 1'b0;
			b_commit_flags_make_flags_n1 <= 1'b0;
			b_commit_flags_make_flags_n2 <= 1'b0;
			b_commit_flags_make_flags_n3 <= 1'b0;
			b_commit_flags_p_regname_n0 <= 4'h0;
			b_commit_flags_p_regname_n1 <= 4'h0;
			b_commit_flags_p_regname_n2 <= 4'h0;
			b_commit_flags_p_regname_n3 <= 4'h0;
		end
		else begin
			b_commit_id_n0_valid <= w_commit_id_n0_valid;
			b_commit_id_n1_valid <= w_commit_id_n1_valid;
			b_commit_id_n2_valid <= w_commit_id_n2_valid;
			b_commit_id_n3_valid <= w_commit_id_n3_valid;
			b_commit_id_n0 <= w_commit_id_n0;
			b_commit_id_n1 <= w_commit_id_n1;
			b_commit_id_n2 <= w_commit_id_n2;
			b_commit_id_n3 <= w_commit_id_n3;
			
			b_commit_lregname_n0 <= entry_info_logic_destination[w_commit_id_n0];
			b_commit_lregname_n1 <= entry_info_logic_destination[w_commit_id_n1];
			b_commit_lregname_n2 <= entry_info_logic_destination[w_commit_id_n2];
			b_commit_lregname_n3 <= entry_info_logic_destination[w_commit_id_n3];
			b_commit_pregname_n0 <= entry_info_destination_regname[w_commit_id_n0];
			b_commit_pregname_n1 <= entry_info_destination_regname[w_commit_id_n1];
			b_commit_pregname_n2 <= entry_info_destination_regname[w_commit_id_n2];
			b_commit_pregname_n3 <= entry_info_destination_regname[w_commit_id_n3];
			b_commit_writeback_n0 <= entry_info_writeback[w_commit_id_n0];
			b_commit_writeback_n1 <= entry_info_writeback[w_commit_id_n1];
			b_commit_writeback_n2 <= entry_info_writeback[w_commit_id_n2];
			b_commit_writeback_n3 <= entry_info_writeback[w_commit_id_n3];
			b_commit_dest_sysreg_n0 <= entry_info_dest_sysreg[w_commit_id_n0];
			b_commit_dest_sysreg_n1 <= entry_info_dest_sysreg[w_commit_id_n1];
			b_commit_dest_sysreg_n2 <= entry_info_dest_sysreg[w_commit_id_n2];
			b_commit_dest_sysreg_n3 <= entry_info_dest_sysreg[w_commit_id_n3];
				
			b_commit_flags_make_flags_n0 <= entry_info_make_flags[w_commit_id_n0];		
			b_commit_flags_make_flags_n1 <= entry_info_make_flags[w_commit_id_n1];		
			b_commit_flags_make_flags_n2 <= entry_info_make_flags[w_commit_id_n2];		
			b_commit_flags_make_flags_n3 <= entry_info_make_flags[w_commit_id_n3];
			b_commit_flags_p_regname_n0 <= entry_info_flags_regname[w_commit_id_n0];
			b_commit_flags_p_regname_n1 <= entry_info_flags_regname[w_commit_id_n1];
			b_commit_flags_p_regname_n2 <= entry_info_flags_regname[w_commit_id_n2];
			b_commit_flags_p_regname_n3 <= entry_info_flags_regname[w_commit_id_n3];	
		end
	end //always

	
	/****************************************
	Next Stage Buffer
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			//Pipeline0
			b0_valid <= 1'b0;		
			b0_source0_active <= 1'b0;		
			b0_source1_active <= 1'b0;		
			b0_source0_sysreg <= 1'b0;		
			b0_source1_sysreg <= 1'b0;
			b0_source0_sysreg_rename <= 1'b0;
			b0_source1_sysreg_rename <= 1'b0;
			b0_adv_active <= 1'b0;
			b0_destination_sysreg <= 1'b0;		
			b0_data_writeback <= 1'b0;	
			b0_flags_writeback <= 1'b0;
			b0_cmd <= {5{1'b0}};
			b0_commit_tag <= {6{1'b0}};
			b0_cc_afe <= {4{1'b0}};
			b0_flags_regname <= 4'h0;
			b0_destination_regname <= {6{1'b0}};
			b0_logic_destination <= {5{1'b0}};
			b0_source0 <= {6{1'b0}};
			b0_source1 <= {32{1'b0}};
			b0_adv_data <= 6'h0;
			b0_source0_flags <= 1'b0;
			b0_source1_imm <= 1'b0;
			b0_ex_sys_adder <= 1'b0;
			b0_ex_sys_ldst <= 1'b0;
			b0_ex_logic <= 1'b0;
			b0_ex_shift <= 1'b0;
			b0_ex_adder <= 1'b0;
			b0_ex_mul <= 1'b0;
			b0_ex_sdiv <= 1'b0;
			b0_ex_udiv <= 1'b0;
			b0_ex_ldst <= 1'b0;
			b0_ex_branch <= 1'b0;
			//Pipeline1
			b1_valid <= 1'b0;			
			b1_source0_active <= 1'b0;		
			b1_source1_active <= 1'b0;		
			b1_source0_sysreg <= 1'b0;			
			b1_source1_sysreg <= 1'b0;	
			b1_source0_sysreg_rename <= 1'b0;
			b1_source1_sysreg_rename <= 1'b0;	
			b1_adv_active <= 1'b0;	
			b1_destination_sysreg <= 1'b0;		
			b1_data_writeback <= 1'b0;	
			b1_flags_writeback <= 1'b0;			
			b1_cmd <= {5{1'b0}};
			b1_commit_tag <= {6{1'b0}};
			b1_cc_afe <= {4{1'b0}};
			b1_flags_regname <= 4'h0;
			b1_destination_regname <= {6{1'b0}};
			b1_logic_destination <= {5{1'b0}};
			b1_source0 <= {6{1'b0}};
			b1_source1 <= {32{1'b0}};
			b1_adv_data <= 6'h0;
			b1_source0_flags <= 1'b0;
			b1_source1_imm <= 1'b0;
			b1_ex_sys_adder <= 1'b0;
			b1_ex_sys_ldst <= 1'b0;
			b1_ex_logic <= 1'b0;
			b1_ex_shift <= 1'b0;
			b1_ex_adder <= 1'b0;
			b1_ex_mul <= 1'b0;
			b1_ex_sdiv <= 1'b0;
			b1_ex_udiv <= 1'b0;
			b1_ex_ldst <= 1'b0;
			b1_ex_branch <= 1'b0;
			b_pc <= {32{1'b0}};			
		end
		else if(iEXCEPTION_EVENT)begin
			//Pipeline0
			b0_valid <= 1'b0;		
			b0_source0_active <= 1'b0;		
			b0_source1_active <= 1'b0;		
			b0_source0_sysreg <= 1'b0;		
			b0_source1_sysreg <= 1'b0;
			b0_source0_sysreg_rename <= 1'b0;
			b0_source1_sysreg_rename <= 1'b0;
			b0_adv_active <= 1'b0;
			b0_destination_sysreg <= 1'b0;		
			b0_data_writeback <= 1'b0;	
			b0_flags_writeback <= 1'b0;
			b0_cmd <= {5{1'b0}};
			b0_commit_tag <= {6{1'b0}};
			b0_cc_afe <= {4{1'b0}};
			b0_flags_regname <= 4'h0;
			b0_destination_regname <= {6{1'b0}};
			b0_logic_destination <= {5{1'b0}};
			b0_source0 <= {6{1'b0}};
			b0_source1 <= {32{1'b0}};
			b0_adv_data <= 6'h0;
			b0_source0_flags <= 1'b0;
			b0_source1_imm <= 1'b0;
			b0_ex_sys_adder <= 1'b0;
			b0_ex_sys_ldst <= 1'b0;
			b0_ex_logic <= 1'b0;
			b0_ex_shift <= 1'b0;
			b0_ex_adder <= 1'b0;
			b0_ex_mul <= 1'b0;
			b0_ex_sdiv <= 1'b0;
			b0_ex_udiv <= 1'b0;
			b0_ex_ldst <= 1'b0;
			b0_ex_branch <= 1'b0;
			//Pipeline1
			b1_valid <= 1'b0;			
			b1_source0_active <= 1'b0;		
			b1_source1_active <= 1'b0;		
			b1_source0_sysreg <= 1'b0;			
			b1_source1_sysreg <= 1'b0;	
			b1_source0_sysreg_rename <= 1'b0;
			b1_source1_sysreg_rename <= 1'b0;	
			b1_adv_active <= 1'b0;		
			b1_destination_sysreg <= 1'b0;		
			b1_data_writeback <= 1'b0;	
			b1_flags_writeback <= 1'b0;			
			b1_cmd <= {5{1'b0}};
			b1_commit_tag <= {6{1'b0}};
			b1_cc_afe <= {4{1'b0}};
			b1_flags_regname <= 4'h0;
			b1_destination_regname <= {6{1'b0}};
			b1_logic_destination <= {5{1'b0}};
			b1_source0 <= {6{1'b0}};
			b1_source1 <= {32{1'b0}};
			b1_adv_data <= 6'h0;
			b1_source0_flags <= 1'b0;
			b1_source1_imm <= 1'b0;
			b1_ex_sys_adder <= 1'b0;
			b1_ex_sys_ldst <= 1'b0;
			b1_ex_logic <= 1'b0;
			b1_ex_shift <= 1'b0;
			b1_ex_adder <= 1'b0;
			b1_ex_mul <= 1'b0;
			b1_ex_sdiv <= 1'b0;
			b1_ex_udiv <= 1'b0;
			b1_ex_ldst <= 1'b0;
			b1_ex_branch <= 1'b0;
			b_pc <= {32{1'b0}};			
		end
		else begin
			if(!/*iNEXT_LOCK*/this_lock)begin
				//***Instruction0***//
				b0_valid <= iPREVIOUS_0_VALID;			
				b0_source0_active <= iPREVIOUS_0_SOURCE0_ACTIVE;	
				b0_source1_active <= iPREVIOUS_0_SOURCE1_ACTIVE;
				b0_source0_sysreg <= iPREVIOUS_0_SOURCE0_SYSREG;
				b0_source1_sysreg <= iPREVIOUS_0_SOURCE1_SYSREG;	
				b0_source0_sysreg_rename <= iPREVIOUS_0_SOURCE0_SYSREG_RENAME;
				b0_source1_sysreg_rename <= iPREVIOUS_0_SOURCE1_SYSREG_RENAME;	
				b0_adv_active <= iPREVIOUS_0_ADV_ACTIVE;	
				b0_destination_sysreg <= iPREVIOUS_0_DESTINATION_SYSREG;		
				b0_data_writeback <= iPREVIOUS_0_WRITEBACK;	
				b0_flags_writeback <= iPREVIOUS_0_FLAGS_WRITEBACK;
				b0_cmd <= iPREVIOUS_0_CMD;
				b0_commit_tag <= {6{1'b0}};
				b0_cc_afe <= iPREVIOUS_0_CC_AFE;
				b0_flags_regname <= iPREVIOUS_0_FLAGS_REGNAME;
				b0_destination_regname <= iPREVIOUS_0_DESTINATION_REGNAME;
				b0_logic_destination <= iPREVIOUS_0_LOGIC_DESTINATION;
				b0_source0 <= iPREVIOUS_0_SOURCE0; 	
				b0_source1 <= iPREVIOUS_0_SOURCE1; 	
				b0_adv_data <= iPREVIOUS_0_ADV_DATA;
				b0_source0_flags <= iPREVIOUS_0_SOURCE0_FLAGS;
				b0_source1_imm <= iPREVIOUS_0_SOURCE1_IMM;
				b0_ex_sys_adder <= iPREVIOUS_0_EX_SYS_ADDER;
				b0_ex_sys_ldst <= iPREVIOUS_0_EX_SYS_LDST;
				b0_ex_logic <= iPREVIOUS_0_EX_LOGIC;
				b0_ex_shift <= iPREVIOUS_0_EX_SHIFT;
				b0_ex_adder <= iPREVIOUS_0_EX_ADDER;
				b0_ex_mul <= iPREVIOUS_0_EX_MUL;
				b0_ex_sdiv <= iPREVIOUS_0_EX_SDIV;
				b0_ex_udiv <= iPREVIOUS_0_EX_UDIV;
				b0_ex_ldst <= iPREVIOUS_0_EX_LDST;
				b0_ex_branch <= iPREVIOUS_0_EX_BRANCH;
				//***Instruction1***//
				b1_valid <= iPREVIOUS_1_VALID;	
				b1_source0_active <= iPREVIOUS_1_SOURCE0_ACTIVE;	
				b1_source1_active <= iPREVIOUS_1_SOURCE1_ACTIVE;
				b1_source0_sysreg <= iPREVIOUS_1_SOURCE0_SYSREG;
				b1_source1_sysreg <= iPREVIOUS_1_SOURCE1_SYSREG;	
				b1_source0_sysreg_rename <= iPREVIOUS_1_SOURCE0_SYSREG_RENAME;
				b1_source1_sysreg_rename <= iPREVIOUS_1_SOURCE1_SYSREG_RENAME;	
				b1_adv_active <= iPREVIOUS_1_ADV_ACTIVE;			
				b1_destination_sysreg <= iPREVIOUS_1_DESTINATION_SYSREG;	
				b1_data_writeback <= iPREVIOUS_1_WRITEBACK;
				b1_flags_writeback <= iPREVIOUS_1_FLAGS_WRITEBACK;
				b1_cmd <= iPREVIOUS_1_CMD;
				b1_commit_tag <= {6{1'b0}};
				b1_cc_afe <= iPREVIOUS_1_CC_AFE;
				b1_flags_regname <= iPREVIOUS_1_FLAGS_REGNAME;
				b1_destination_regname <= iPREVIOUS_1_DESTINATION_REGNAME;		
				b1_logic_destination <= iPREVIOUS_1_LOGIC_DESTINATION;
				b1_source0 <= iPREVIOUS_1_SOURCE0; 	
				b1_source1 <= iPREVIOUS_1_SOURCE1; 
				b1_adv_data <= iPREVIOUS_1_ADV_DATA;
				b1_source0_flags <= iPREVIOUS_1_SOURCE0_FLAGS;	
				b1_source1_imm <= iPREVIOUS_1_SOURCE1_IMM;
				b1_ex_sys_adder <= iPREVIOUS_1_EX_SYS_ADDER;
				b1_ex_sys_ldst <= iPREVIOUS_1_EX_SYS_LDST;
				b1_ex_logic <= iPREVIOUS_1_EX_LOGIC;
				b1_ex_shift <= iPREVIOUS_1_EX_SHIFT;
				b1_ex_adder <= iPREVIOUS_1_EX_ADDER;
				b1_ex_mul <= iPREVIOUS_1_EX_MUL;
				b1_ex_sdiv <= iPREVIOUS_1_EX_SDIV;
				b1_ex_udiv <= iPREVIOUS_1_EX_UDIV;
				b1_ex_ldst <= iPREVIOUS_1_EX_LDST;
				b1_ex_branch <= iPREVIOUS_1_EX_BRANCH;
				b_pc <= iPREVIOUS_PC;
			end
		end
	end //always
	
	
	
	/****************************************
	Scheduler State
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_scheduler_state <= PL_STT_NORMAL;
		end
		else begin
			case(b_scheduler_state)
				PL_STT_NORMAL:
					begin
						if(iEXCEPTION_EVENT)begin
							b_scheduler_state <= PL_STT_EXCEPTION;
						end
					end
				PL_STT_EXCEPTION:
					begin
						if(iEXCEPTION_RESTART)begin
							b_scheduler_state <= PL_STT_NORMAL;
						end
					end
			endcase
		end
	end

	
	/****************************************
	Commit List
	****************************************/
	generate
		for(i = 0; i < 64; i = i + 1)begin : COMMIT_ENTRY
			scheduler1_commit_entry #(i[5:0]) COMMIT_ENTRY (
				//System
				.iCLOCK(iCLOCK), 
				.inRESET(inRESET), 
				//Regist
				.iLOCK(this_lock),
				.iRESTART_VALID(iEXCEPTION_RESTART),
				.iREGIST_POINTER(w_register_pointer), 
				.iREGIST_0_VALID(iPREVIOUS_0_VALID & !this_lock), 
				.iREGIST_0_MAKE_FLAGS(iPREVIOUS_0_FLAGS_WRITEBACK),
				.iREGIST_0_WRITEBACK(iPREVIOUS_0_WRITEBACK), 
				.iREGIST_0_FLAGS_PREG_POINTER(iPREVIOUS_0_FLAGS_REGNAME),
				.iREGIST_0_DEST_PREG_POINTER(iPREVIOUS_0_DESTINATION_REGNAME), 
				.iREGIST_0_DEST_LREG_POINTER(iPREVIOUS_0_LOGIC_DESTINATION), 
				.iREGIST_0_DEST_SYSREG(iPREVIOUS_0_DESTINATION_SYSREG),
				.iREGIST_0_EX_BRANCH(iPREVIOUS_0_EX_BRANCH),
				.iREGIST_1_VALID(iPREVIOUS_0_VALID & iPREVIOUS_1_VALID & !this_lock), 
				.iREGIST_1_MAKE_FLAGS(iPREVIOUS_1_FLAGS_WRITEBACK),
				.iREGIST_1_WRITEBACK(iPREVIOUS_1_WRITEBACK), 
				.iREGIST_1_FLAGS_PREG_POINTER(iPREVIOUS_1_FLAGS_REGNAME),
				.iREGIST_1_DEST_PREG_POINTER(iPREVIOUS_1_DESTINATION_REGNAME), 
				.iREGIST_1_DEST_LREG_POINTER(iPREVIOUS_1_LOGIC_DESTINATION), 
				.iREGIST_1_DEST_SYSREG(iPREVIOUS_1_DESTINATION_SYSREG),
				.iREGIST_1_EX_BRANCH(iPREVIOUS_1_EX_BRANCH),
				.iREGIST_PC(iPREVIOUS_PC), 
				.iCOMMIT_VALID(entry_commit_valid[i[5:0]]),
				.iEXEND_ALU0_VALID(iSCHE1_EX_BRANCH_VALID), 
				.iEXEND_ALU0_COMMIT_TAG(iSCHE1_EX_BRANCH_COMMIT_TAG), 
				.iEXEND_ALU1_VALID(iSCHE1_EX_ALU1_VALID), 
				.iEXEND_ALU1_COMMIT_TAG(iSCHE1_EX_ALU1_COMMIT_TAG),
				.iEXEND_ALU2_VALID(iSCHE1_EX_ALU2_VALID), 
				.iEXEND_ALU2_COMMIT_TAG(iSCHE1_EX_ALU2_COMMIT_TAG), 
				.iEXEND_ALU3_VALID(iSCHE1_EX_ALU3_VALID), 
				.iEXEND_ALU3_COMMIT_TAG(iSCHE1_EX_ALU3_COMMIT_TAG),
				//RollBack Info
				.oINFO_VALID(entry_info_entry_valid[i[5:0]]),
				.oINFO_MAKE_FLAGS_VALID(entry_info_make_flags[i[5:0]]),
				.oINFO_WRITEBACK_VALID(entry_info_writeback[i[5:0]]), 
				.oINFO_PC(entry_info_pc[i[5:0]]), 
				.oINFO_FLAGS_PREG_POINTER(entry_info_flags_regname[i[5:0]]),
				.oINFO_DEST_PREG_POINTER(entry_info_destination_regname[i[5:0]]), 
				.oINFO_DEST_LREG_POINTER(entry_info_logic_destination[i[5:0]]), 
				.oINFO_DEST_SYSREG(entry_info_dest_sysreg[i[5:0]]),
				.oINFO_EX_BRANCH(entry_info_ex_branch[i[5:0]]),
				.oINFO_EX_END(entry_info_ex_end[i[5:0]]), 
				.oINFO_FREE(oFREE_REGISTER[i[5:0]])
			);
		end
	endgenerate

	
	/***************************************************
	Commit List
	***************************************************/
	assign {entry_commit_3_valid, entry_commit_3_num,
			entry_commit_2_valid, entry_commit_2_num,
			entry_commit_1_valid, entry_commit_1_num,
			entry_commit_0_valid, entry_commit_0_num} = func_entry_commit_valid(w_commit_pointer, w_commit_offset);
	
	function [27:0] func_entry_commit_valid;
		/*
			[27]
			[26:21]
			[20]
			[19:14]
			[13]
			[12:7]
			[6]
			[5:0] 
		*/
		input [5:0] func_entry_commit_valid_commit_pointer;
		input [2:0] func_entry_commit_valid_commit_offset;
		begin
			func_entry_commit_valid	[26:21] = func_entry_commit_valid_commit_pointer + {{3{1'b0}}, 3'h3};
			func_entry_commit_valid	[19:14] = func_entry_commit_valid_commit_pointer + {{3{1'b0}}, 3'h2};
			func_entry_commit_valid	[12:7] = func_entry_commit_valid_commit_pointer + {{3{1'b0}}, 3'h1};
			func_entry_commit_valid	[5:0] = func_entry_commit_valid_commit_pointer + {{3{1'b0}}, 3'h0};
			
			if(func_entry_commit_valid_commit_offset == 3'h1)begin
				func_entry_commit_valid	[6] = 1'b1;
				func_entry_commit_valid	[13] = 1'b0;
				func_entry_commit_valid	[20] = 1'b0;
				func_entry_commit_valid	[27] = 1'b0;
			end
			else if(func_entry_commit_valid_commit_offset == 3'h2)begin
				func_entry_commit_valid	[6] = 1'b1;
				func_entry_commit_valid	[13] = 1'b1;
				func_entry_commit_valid	[20] = 1'b0;
				func_entry_commit_valid	[27] = 1'b0;
			end
			else if(func_entry_commit_valid_commit_offset == 3'h3)begin
				func_entry_commit_valid	[6] = 1'b1;
				func_entry_commit_valid	[13] = 1'b1;
				func_entry_commit_valid	[20] = 1'b1;
				func_entry_commit_valid	[27] = 1'b0;
			end
			else if(func_entry_commit_valid_commit_offset == 3'h4)begin
				func_entry_commit_valid	[6] = 1'b1;
				func_entry_commit_valid	[13] = 1'b1;
				func_entry_commit_valid	[20] = 1'b1;
				func_entry_commit_valid	[27] = 1'b1;
			end
			else begin
				func_entry_commit_valid	[6] = 1'b0;
				func_entry_commit_valid	[13] = 1'b0;
				func_entry_commit_valid	[20] = 1'b0;
				func_entry_commit_valid	[27] = 1'b0;
			end
		end
	endfunction
	

	generate
		for(i = 0; i < 64; i = i + 1)begin : ENTRY_COMMIT_VALID
			assign entry_commit_valid[i[5:0]] = ((entry_commit_0_valid & (entry_commit_0_num == i[5:0])) | (entry_commit_1_valid & (entry_commit_1_num == i[5:0])) |
											(entry_commit_2_valid & (entry_commit_2_num == i[5:0])) | (entry_commit_3_valid & (entry_commit_3_num == i[5:0])))? 1'b1 : 1'b0;
		end
	endgenerate
	
	

	//Exception Protect Check(Non Core Exceotion Block)
	
	assign exception_protect = func_exception_protect_check(
													w_register_pointer,
													w_commit_pointer,
													w_commit_offset,
													entry_info_entry_valid[w_commit_pointer + 6'h1],
													entry_info_entry_valid[w_commit_pointer + 6'h2],
													entry_info_entry_valid[w_commit_pointer + 6'h3],
													entry_info_entry_valid[w_commit_pointer + 6'h4],
													entry_info_entry_valid[w_commit_pointer + 6'h5],
													entry_info_ex_branch[w_commit_pointer + 6'h1],
													entry_info_ex_branch[w_commit_pointer + 6'h2],
													entry_info_ex_branch[w_commit_pointer + 6'h3],
													entry_info_ex_branch[w_commit_pointer + 6'h4],
													entry_info_ex_branch[w_commit_pointer + 6'h5]
												);
	
	
	
	function func_exception_protect_check;
		input [5:0] func_regist_pointer;
		input [5:0] func_commit_pointer;
		input [2:0] func_cntry_commit_offset;
		input func_commit_entry1_ex_branch_active;
		input func_commit_entry2_ex_branch_active;
		input func_commit_entry3_ex_branch_active;
		input func_commit_entry4_ex_branch_active;
		input func_commit_entry5_ex_branch_active;
		input func_commit_entry1_ex_branch_flag;
		input func_commit_entry2_ex_branch_flag;
		input func_commit_entry3_ex_branch_flag;
		input func_commit_entry4_ex_branch_flag;
		input func_commit_entry5_ex_branch_flag;
		
		reg [5:0] func_reg_regist_pointer_inc;
		begin
			//Initial
			func_reg_regist_pointer_inc = func_commit_pointer + 6'h1;
		
			if((func_regist_pointer == func_commit_pointer) || (func_regist_pointer == func_reg_regist_pointer_inc[5:0]))begin
				func_exception_protect_check = 1'b1;
			end
			else begin
				case(func_cntry_commit_offset)
					3'h0:	
						begin
							if(func_commit_entry1_ex_branch_flag || !func_commit_entry1_ex_branch_active)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
					3'h1:	
						begin
							if((!func_commit_entry1_ex_branch_flag && func_commit_entry2_ex_branch_flag) || !func_commit_entry2_ex_branch_active)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
					3'h2:	
						begin
							if((!func_commit_entry2_ex_branch_flag && func_commit_entry3_ex_branch_flag) || !func_commit_entry3_ex_branch_active)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
					3'h3:	
						begin
							if((!func_commit_entry3_ex_branch_flag && func_commit_entry4_ex_branch_flag) || !func_commit_entry4_ex_branch_active)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
					3'h4:
						begin
							if((!func_commit_entry4_ex_branch_flag && func_commit_entry5_ex_branch_flag) || !func_commit_entry5_ex_branch_active)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
				endcase
			end
		end
	endfunction
	
	/*
	
	assign exception_protect = func_exception_protect_check(
													w_register_pointer,
													w_commit_pointer,
													w_commit_offset,
													entry_info_ex_branch[w_commit_pointer],
													entry_info_ex_branch[w_commit_pointer + 6'h1],
													entry_info_ex_branch[w_commit_pointer + 6'h2],
													entry_info_ex_branch[w_commit_pointer + 6'h3],
													entry_info_ex_branch[w_commit_pointer + 6'h4]
												);

	
	function func_exception_protect_check;
		input [5:0] func_regist_pointer;
		input [5:0] func_commit_pointer;
		input [1:0] func_cntry_commit_offset;
		input func_commit_entry0_ex_branch_flag;		//NOW
		input func_commit_entry1_ex_branch_flag;
		input func_commit_entry2_ex_branch_flag;
		input func_commit_entry3_ex_branch_flag;
		input func_commit_entry4_ex_branch_flag;
		begin
			if(func_regist_pointer == func_commit_pointer || func_regist_pointer == (func_commit_pointer + 6'h1))begin
				func_exception_protect_check = 1'b1;
			end
			else begin
				case(func_cntry_commit_offset)
					2'h0:	
						begin
							if(!func_commit_entry0_ex_branch_flag && func_commit_entry1_ex_branch_flag)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
					2'h1:	
						begin
							if(!func_commit_entry1_ex_branch_flag && func_commit_entry2_ex_branch_flag)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
					2'h2:	
						begin
							if(!func_commit_entry2_ex_branch_flag && func_commit_entry3_ex_branch_flag)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
					2'h3:	
						begin
							if(!func_commit_entry3_ex_branch_flag && func_commit_entry4_ex_branch_flag)begin
								func_exception_protect_check = 1'b1;
							end
							else begin
								func_exception_protect_check = 1'b0;
							end
						end
				endcase
			end
		end
	endfunction
		*/
	
	
	//Commit Count
	assign w_commit_offset = func_entry_commit_count
										(
											entry_info_ex_end[w_commit_pointer], 
											entry_info_ex_end[w_commit_pointer + 6'h1],
											entry_info_ex_end[w_commit_pointer + 6'h2], 
											entry_info_ex_end[w_commit_pointer + 6'h3],
											w_commit_pointer,
											(iEXCEPTION_EVENT || (b_scheduler_state == PL_STT_EXCEPTION) || iEXCEPTION_RESTART), 
											iEXCEPTION_COMMIT_TAG
										);
															
	
															
	function [2:0] func_entry_commit_count;
		//Execution End Infomation
		input func_commit_entry_ex_end0;
		input func_commit_entry_ex_end1;
		input func_commit_entry_ex_end2;
		input func_commit_entry_ex_end3;
		//Now Commit Pointer
		input [5:0] func_now_commit_pointer;
		//Exception Request
		input func_exception_request_valid;
		input [5:0] func_exception_request_pointer;
		//Internal(Private)
		reg [2:0] pri_exend_count;
		reg [2:0] pri_max_count;	
		begin
			//Ex End Count
			if(func_commit_entry_ex_end0)begin
				if(func_commit_entry_ex_end1)begin
					if(func_commit_entry_ex_end2)begin
						if(func_commit_entry_ex_end3)begin
							pri_exend_count = 3'h4;
						end
						else begin
							pri_exend_count = 3'h3;
						end
					end
					else begin
						pri_exend_count = 3'h2;
					end
				end
				else begin
					pri_exend_count = 3'h1;
				end
			end
			else begin
				pri_exend_count = 3'h0;
			end
			//Max Count
			if(func_now_commit_pointer != func_exception_request_pointer)begin
				if(func_now_commit_pointer + 3'h1 != func_exception_request_pointer)begin
					if(func_now_commit_pointer + 3'h2 != func_exception_request_pointer)begin
						if(func_now_commit_pointer + 3'h3 != func_exception_request_pointer)begin
							pri_max_count = 3'h4;
						end
						else begin
							pri_max_count = 3'h3;
						end
					end
					else begin
						pri_max_count = 3'h2;
					end
				end
				else begin
					pri_max_count = 3'h1;
				end
			end
			else begin
				pri_max_count = 3'h0;
			end
			//Output Calc
			if(!func_exception_request_valid)begin
				func_entry_commit_count = pri_exend_count;
			end
			else begin
				if(pri_exend_count <= pri_max_count)begin
					func_entry_commit_count = pri_exend_count;
				end
				else begin
					func_entry_commit_count = pri_max_count;
				end
			end
		end
	endfunction
	
	assign w_commit_count = b_regist_pointer - b_commit_pointer;
		
	
	//Commit & Regist Pointer
	assign w_commit_pointer = b_commit_pointer[5:0];
	assign w_register_pointer = b_regist_pointer[5:0];
	assign ww_regist_pointer = bb_regist_pointer[5:0];

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_commit_pointer <= {7{1'b0}};
			b_regist_pointer <= {7{1'b0}};
			bb_regist_pointer <= {7{1'b0}};
		end
		else begin
		
			if(iEXCEPTION_RESTART)begin
				//Branch
				b_regist_pointer <= ({1'b0, iEXCEPTION_COMMIT_TAG}) + 7'h01;
				bb_regist_pointer <= b_regist_pointer;
				b_commit_pointer <= ({1'b0, iEXCEPTION_COMMIT_TAG}) + 7'h01;
			end
			else begin
				//Normal
				b_commit_pointer <= b_commit_pointer + {3'h0, w_commit_offset};
				if(!this_lock)begin
					if(iPREVIOUS_0_VALID)begin
						if(iPREVIOUS_1_VALID)begin
							b_regist_pointer <= b_regist_pointer + 7'h02;
							bb_regist_pointer <= b_regist_pointer;
						end
						else begin
							b_regist_pointer <= b_regist_pointer + 7'h01;
							bb_regist_pointer <= b_regist_pointer;
						end
					end
				end
			end
		end
	end //always
	
	
	/**********************************************
	Module Output
	**********************************************/
	//Module Info
	assign oSTAGE_INFO_REGIST_POINTER = w_register_pointer;
	assign oSTAGE_INFO_COMMIT_POINTER = w_commit_pointer;
	//Commit Info
	assign oINFO_COMMIT_COUNTER = w_commit_pointer;
	assign oINFO_EXCEPTION_PROTECT = exception_protect; //1'b0  bug
	wire [5:0] commit_pc_pointer = w_commit_pointer;
	assign oFREE_CURRENT_PC = entry_info_pc[commit_pc_pointer];
	assign oCOMMIT_OFFSET = w_commit_offset;
	//Lock
	assign oPREVIOUS_LOCK = this_lock;
	//Stage Info
	assign oSTAGE_INFO_0_VALID = b0_valid;
	assign oSTAGE_INFO_1_VALID = b1_valid;
	//RollBack Info
	assign oRENAME_ROLLBACK_UPDATE_INFO0_VALID = b_commit_id_n0_valid && b_commit_writeback_n0;
	assign oRENAME_ROLLBACK_UPDATE_INFO0_LREGNAME = b_commit_lregname_n0;
	assign oRENAME_ROLLBACK_UPDATE_INFO0_PREGNAME = b_commit_pregname_n0;
	assign oRENAME_ROLLBACK_UPDATE_INFO0_SYSREG = b_commit_dest_sysreg_n0;

	assign oRENAME_ROLLBACK_UPDATE_INFO1_VALID = b_commit_id_n1_valid && b_commit_writeback_n1;
	assign oRENAME_ROLLBACK_UPDATE_INFO1_LREGNAME = b_commit_lregname_n1;
	assign oRENAME_ROLLBACK_UPDATE_INFO1_PREGNAME = b_commit_pregname_n1;
	assign oRENAME_ROLLBACK_UPDATE_INFO1_SYSREG = b_commit_dest_sysreg_n1;
	
	assign oRENAME_ROLLBACK_UPDATE_INFO2_VALID = b_commit_id_n2_valid && b_commit_writeback_n2;
	assign oRENAME_ROLLBACK_UPDATE_INFO2_LREGNAME = b_commit_lregname_n2;
	assign oRENAME_ROLLBACK_UPDATE_INFO2_PREGNAME = b_commit_pregname_n2;
	assign oRENAME_ROLLBACK_UPDATE_INFO2_SYSREG = b_commit_dest_sysreg_n2;
	
	assign oRENAME_ROLLBACK_UPDATE_INFO3_VALID = b_commit_id_n3_valid && b_commit_writeback_n3;
	assign oRENAME_ROLLBACK_UPDATE_INFO3_LREGNAME = b_commit_lregname_n3;
	assign oRENAME_ROLLBACK_UPDATE_INFO3_PREGNAME = b_commit_pregname_n3;
	assign oRENAME_ROLLBACK_UPDATE_INFO3_SYSREG = b_commit_dest_sysreg_n3;
	
	assign oFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_VALID = b_commit_flags_make_flags_n0;
	assign oFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_PREGNAME = b_commit_flags_p_regname_n0;
	assign oFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_VALID = b_commit_flags_make_flags_n1;
	assign oFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_PREGNAME = b_commit_flags_p_regname_n1;
	assign oFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_VALID = b_commit_flags_make_flags_n2;
	assign oFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_PREGNAME = b_commit_flags_p_regname_n2;
	assign oFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_VALID = b_commit_flags_make_flags_n3;
	assign oFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_PREGNAME = b_commit_flags_p_regname_n3;
	
	//Next-0	
	assign oNEXT_0_VALID = (!this_lock)? b0_valid : 1'b0;		//12/19 2:13 always@de this_lock or inext_loxk dotirawo tukauka mayota toki
	assign oNEXT_0_SOURCE0_ACTIVE = b0_source0_active;
	assign oNEXT_0_SOURCE1_ACTIVE = b0_source1_active;
	assign oNEXT_0_SOURCE0_SYSREG = b0_source0_sysreg;
	assign oNEXT_0_SOURCE1_SYSREG = b0_source1_sysreg;
	assign oNEXT_0_SOURCE0_SYSREG_RENAME = b0_source0_sysreg_rename;
	assign oNEXT_0_SOURCE1_SYSREG_RENAME = b0_source1_sysreg_rename;
	assign oNEXT_0_ADV_ACTIVE = b0_adv_active;
	assign oNEXT_0_DESTINATION_SYSREG = b0_destination_sysreg;
	assign oNEXT_0_WRITEBACK = b0_data_writeback;
	assign oNEXT_0_FLAGS_WRITEBACK = b0_flags_writeback;
	assign oNEXT_0_CMD = b0_cmd;
	assign oNEXT_0_COMMIT_TAG = ww_regist_pointer;
	assign oNEXT_0_CC_AFE = b0_cc_afe;
	assign oNEXT_0_FLAGS_REGNAME = b0_flags_regname;
	assign oNEXT_0_DESTINATION_REGNAME = b0_destination_regname;
	assign oNEXT_0_LOGIC_DESTINATION = b0_logic_destination;	
	assign oNEXT_0_SOURCE0 = b0_source0;
	assign oNEXT_0_SOURCE1 = b0_source1;
	assign oNEXT_0_ADV_DATA = b0_adv_data;
	assign oNEXT_0_SOURCE0_FLAGS = b0_source0_flags;
	assign oNEXT_0_SOURCE1_IMM = b0_source1_imm;
	assign oNEXT_0_EX_SYS_ADDER = b0_ex_sys_adder;
	assign oNEXT_0_EX_SYS_LDST = b0_ex_sys_ldst;
	assign oNEXT_0_EX_LOGIC = b0_ex_logic;
	assign oNEXT_0_EX_SHIFT = b0_ex_shift;
	assign oNEXT_0_EX_ADDER = b0_ex_adder;
	assign oNEXT_0_EX_MUL = b0_ex_mul;
	assign oNEXT_0_EX_SDIV = b0_ex_sdiv;
	assign oNEXT_0_EX_UDIV = b0_ex_udiv;
	assign oNEXT_0_EX_LDST = b0_ex_ldst;
	assign oNEXT_0_EX_BRANCH = b0_ex_branch;	
	//Next-1			
	assign oNEXT_1_VALID = (!this_lock)? b1_valid : 1'b0;		//12/19 2:13 always@de this_lock or inext_loxk dotirawo tukauka mayota toki
	assign oNEXT_1_SOURCE0_ACTIVE = b1_source0_active;
	assign oNEXT_1_SOURCE1_ACTIVE = b1_source1_active;
	assign oNEXT_1_SOURCE0_SYSREG = b1_source0_sysreg;
	assign oNEXT_1_SOURCE1_SYSREG = b1_source1_sysreg;
	assign oNEXT_1_SOURCE0_SYSREG_RENAME = b1_source0_sysreg_rename;
	assign oNEXT_1_SOURCE1_SYSREG_RENAME = b1_source1_sysreg_rename;
	assign oNEXT_1_ADV_ACTIVE = b1_adv_active;
	assign oNEXT_1_DESTINATION_SYSREG = b1_destination_sysreg;
	assign oNEXT_1_WRITEBACK = b1_data_writeback;
	assign oNEXT_1_FLAGS_WRITEBACK = b1_flags_writeback;
	assign oNEXT_1_CMD = b1_cmd;
	assign oNEXT_1_COMMIT_TAG = ww_regist_pointer + 6'h01;
	assign oNEXT_1_CC_AFE = b1_cc_afe;
	assign oNEXT_1_FLAGS_REGNAME = b1_flags_regname;
	assign oNEXT_1_DESTINATION_REGNAME = b1_destination_regname;
	assign oNEXT_1_LOGIC_DESTINATION = b1_logic_destination;	
	assign oNEXT_1_SOURCE0 = b1_source0;
	assign oNEXT_1_SOURCE1 = b1_source1;
	assign oNEXT_1_ADV_DATA = b1_adv_data;
	assign oNEXT_1_SOURCE0_FLAGS = b1_source0_flags;
	assign oNEXT_1_SOURCE1_IMM = b1_source1_imm;
	assign oNEXT_1_EX_SYS_ADDER = b1_ex_sys_adder;
	assign oNEXT_1_EX_SYS_LDST = b1_ex_sys_ldst;
	assign oNEXT_1_EX_LOGIC = b1_ex_logic;
	assign oNEXT_1_EX_SHIFT = b1_ex_shift;
	assign oNEXT_1_EX_ADDER = b1_ex_adder;
	assign oNEXT_1_EX_MUL = b1_ex_mul;
	assign oNEXT_1_EX_SDIV = b1_ex_sdiv;
	assign oNEXT_1_EX_UDIV = b1_ex_udiv;
	assign oNEXT_1_EX_LDST = b1_ex_ldst;
	assign oNEXT_1_EX_BRANCH = b1_ex_branch;
	assign oNEXT_PC = b_pc;
	//Commit Entry Vector
	generate
		for(i = 0; i < 64; i = i + 1)begin : COMMIT_VECTOR
			assign oCOMMIT_ENTRY_COMMIT_VECTOR[i[5:0]] = (b_commit_id_n0_valid && i[5:0] == b_commit_id_n0) || (b_commit_id_n1_valid && i[5:0] == b_commit_id_n1) || (b_commit_id_n2_valid && i[5:0] == b_commit_id_n2) || (b_commit_id_n3_valid && i[5:0] == b_commit_id_n3)? 1'b1 : 1'b0;
		end
	endgenerate
	
	
endmodule


				
`default_nettype wire


/****************************************
	Renaming Unit
	- 2 instruction multi renaming
	- Register Riname List
	
	Make	:	2011/01/20
	Update	:	
****************************************/
`include "core.h"
`default_nettype none


module renaming(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Free
		input wire iFREE_DEFAULT,
		input wire iFREE_RESTART,
		//Rollback Update Info
		input wire iROLLBACK_UPDATE_CANDIDATE0_VALID,			
		input wire [4:0] iROLLBACK_UPDATE_CANDIDATE0_LREGNAME,		
		input wire [5:0] iROLLBACK_UPDATE_CANDIDATE0_PREGNAME,		
		input wire iROLLBACK_UPDATE_CANDIDATE0_SYSREG,			
		input wire iROLLBACK_UPDATE_CANDIDATE1_VALID,		
		input wire [4:0] iROLLBACK_UPDATE_CANDIDATE1_LREGNAME,	
		input wire [5:0] iROLLBACK_UPDATE_CANDIDATE1_PREGNAME,		
		input wire iROLLBACK_UPDATE_CANDIDATE1_SYSREG,			
		input wire iROLLBACK_UPDATE_CANDIDATE2_VALID,		
		input wire [4:0] iROLLBACK_UPDATE_CANDIDATE2_LREGNAME,	
		input wire [5:0] iROLLBACK_UPDATE_CANDIDATE2_PREGNAME,		
		input wire iROLLBACK_UPDATE_CANDIDATE2_SYSREG,			
		input wire iROLLBACK_UPDATE_CANDIDATE3_VALID,			
		input wire [4:0] iROLLBACK_UPDATE_CANDIDATE3_LREGNAME,		
		input wire [5:0] iROLLBACK_UPDATE_CANDIDATE3_PREGNAME,	
		input wire iROLLBACK_UPDATE_CANDIDATE3_SYSREG,	
		input wire iFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_VALID,
		input wire [3:0] iFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_PREGNAME,
		input wire iFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_VALID,
		input wire [3:0] iFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_PREGNAME,
		input wire iFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_VALID,
		input wire [3:0] iFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_PREGNAME,
		input wire iFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_VALID,
		input wire [3:0] iFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_PREGNAME,			
		//StageInfo
		output wire oSTAGE_INFO_0_VALID,	
		output wire oSTAGE_INFO_1_VALID,
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
		input wire iPREVIOUS_0_DEST_RENAME,		
		input wire iPREVIOUS_0_WRITEBACK,	
		input wire iPREVIOUS_0_FLAGS_WRITEBACK,	
		input wire [4:0] iPREVIOUS_0_CMD,
		input wire [3:0] iPREVIOUS_0_CC_AFE,
		input wire [4:0] iPREVIOUS_0_SOURCE0,
		input wire [31:0] iPREVIOUS_0_SOURCE1,
		input wire [5:0] iPREVIOUS_0_ADV_DATA,
		input wire iPREVIOUS_0_SOURCE0_FLAGS,
		input wire iPREVIOUS_0_SOURCE1_IMM,
		input wire [4:0] iPREVIOUS_0_DESTINATION,				
		input wire iPREVIOUS_0_EX_LOGIC,
		input wire iPREVIOUS_0_EX_SYS_ADDER,		
		input wire iPREVIOUS_0_EX_SYS_LDST,		
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
		input wire iPREVIOUS_1_DEST_RENAME,			
		input wire iPREVIOUS_1_WRITEBACK,	
		input wire iPREVIOUS_1_FLAGS_WRITEBACK,
		input wire [4:0] iPREVIOUS_1_CMD,
		input wire [3:0] iPREVIOUS_1_CC_AFE,
		input wire [4:0] iPREVIOUS_1_SOURCE0,
		input wire [31:0] iPREVIOUS_1_SOURCE1,
		input wire [5:0] iPREVIOUS_1_ADV_DATA,
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
		//Register-Flags
		output wire oFLAG_REGISTER_0_RD,
		input wire [3:0] iFLAG_REGISTER_0_NUM,
		input wire iFLAG_REGISTER_0_EMPTY,
		output wire oFLAG_REGISTER_1_RD,
		input wire [3:0] iFLAG_REGISTER_1_NUM,
		input wire iFLAG_REGISTER_1_EMPTY,
		//Generals
		output wire oOTHER_REGISTER_0_RD,
		input wire [5:0] iOTHER_REGISTER_0_NUM,
		input wire iOTHER_REGISTER_0_EMPTY,
		output wire oOTHER_REGISTER_1_RD,
		input wire [5:0] iOTHER_REGISTER_1_NUM,
		input wire iOTHER_REGISTER_1_EMPTY,
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
				

	/****************************************
	Wire and Register
	****************************************/	
	wire this_lock;
	//Register Request Condition
	wire new_register_0_req_condition;
	wire new_register_1_req_condition;
	wire new_register_0_flag_req_condition;
	wire new_register_1_flag_req_condition;
	//Pipeline0 - Source0-1
	reg [5:0] pipeline0_source0;
	reg [31:0] pipeline0_source1;	
	//Pipeline1 - Source0-1
	reg [5:0] pipeline1_source0;
	reg [31:0] pipeline1_source1;
	//Table Instance
	wire flag_table_read_valid;
	wire [5:0] flag_table_read_regname;
	wire [5:0] flag_table_read_old_regname;
	//Flag & Destination Buffer
	reg [5:0] b_old_last_instruction_destination_regname;
	reg bb_old_last_instruction_flags_writeback;
	reg [5:0] bb_old_last_instruction_destination_regname;
	//FIfo Buffer
	reg [5:0] b_other0_buffer;
	reg [5:0] b_other1_buffer;
	reg [3:0] b_flag0_buffer;
	reg [3:0] b_flag1_buffer;
	//Generate 
	genvar i;
	//Renaming Table Instance
	wire renaming_info_valid[0:31];
	wire [5:0] renaming_info_regname[0:31];
	wire [5:0] renaming_info_old_regname[0:31];
	//Output Buffer0
	reg b0_valid;				
	reg b0_source0_active;	
	reg b0_source1_active;	
	reg b0_source0_sysreg;	
	reg b0_source1_sysreg;		
	reg b0_source0_sysreg_rename;					
	reg b0_source1_sysreg_rename;	
	reg b0_adv_active;
	reg b0_destination_sysreg;	
	reg b0_dest_rename;				
	reg b0_writeback;	
	reg b0_flags_writeback;
	reg [4:0] b0_cmd;
	reg [3:0] b0_cc_afe;
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
	//Output Buffer1
	reg b1_valid;					
	reg b1_source0_active;	
	reg b1_source1_active;	
	reg b1_source0_sysreg;					
	reg b1_source1_sysreg;		
	reg b1_source0_sysreg_rename;					
	reg b1_source1_sysreg_rename;			
	reg b1_adv_active;
	reg b1_destination_sysreg;	
	reg b1_dest_rename;
	reg b1_writeback;
	reg b1_flags_writeback;	
	reg [4:0] b1_cmd;
	reg [3:0] b1_cc_afe;
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
	
	
	/****************************************
	Lock Condition
	****************************************/	
	assign this_lock = iFLAG_REGISTER_0_EMPTY || iFLAG_REGISTER_1_EMPTY || iOTHER_REGISTER_0_EMPTY || iOTHER_REGISTER_1_EMPTY || iNEXT_LOCK;	
	

	/****************************************
	Next Register Request Condition 
	****************************************/	
	assign new_register_0_req_condition = iPREVIOUS_0_VALID && ((iPREVIOUS_0_DESTINATION_SYSREG && iPREVIOUS_0_DEST_RENAME) || !iPREVIOUS_0_DESTINATION_SYSREG) && iPREVIOUS_0_WRITEBACK /*&& !iPREVIOUS_0_FLAGS_WRITEBACK*/ && !this_lock;	
	assign new_register_1_req_condition = iPREVIOUS_1_VALID && ((iPREVIOUS_1_DESTINATION_SYSREG && iPREVIOUS_1_DEST_RENAME) || !iPREVIOUS_1_DESTINATION_SYSREG) && iPREVIOUS_1_WRITEBACK /*&& !iPREVIOUS_1_FLAGS_WRITEBACK*/ && !this_lock;
	assign new_register_0_flag_req_condition = iPREVIOUS_0_VALID && !iPREVIOUS_0_DESTINATION_SYSREG && iPREVIOUS_0_FLAGS_WRITEBACK && !this_lock;//!this_lock && (b0_valid && !b0_destination_sysreg && b0_flags_writeback) || (b1_valid && !b1_destination_sysreg && b1_flags_writeback);
	assign new_register_1_flag_req_condition = iPREVIOUS_1_VALID && !iPREVIOUS_1_DESTINATION_SYSREG && iPREVIOUS_1_FLAGS_WRITEBACK && !this_lock;
	
	/****************************************
	Next Port Selecter
	****************************************/
	//Pipeline0 - Source0
	always @* begin
		//System Register(Except FLAGR Register)
		if(b0_source0_sysreg)begin
			//Flag Register - This Instruction Use
			if(b0_source0_flags)begin
				pipeline0_source0 = flag_table_read_old_regname;
			end
			//No Renaming System Register
			else if(!b0_source0_sysreg_rename)begin
				pipeline0_source0 = b0_source0;
			end
			//Renaming System Register
			/*
			else begin
				//SPR
				if(b0_source0[4:0] ==`SYSREG_SPR)begin
					pipeline0_source0 = renaming_spr_info_old_regname;
				end
				else begin
					$display("[Error][renaming.v] : None No renaming systemregister[Logic Destination : %x]", b0_source0[4:0]);
				end
			end
			*/
			else begin
				pipeline0_source0 = b0_source0;
			end
		end
		//General Register
		else begin
			pipeline0_source0 = renaming_info_old_regname[b0_source0[4:0]];
		end
	end //Pipeline0 - Source0 Output Selector Combination Logic
	
	//Pipeline0 - Source1
	always @* begin
		//System Register(Except FLAGR Register)
		if(b0_source1_sysreg)begin
			//No Renaming System Register
			if(!b0_source1_sysreg_rename)begin
				pipeline0_source1 = b0_source1;
			end
			//Renaming System Register
			/*
			else begin
				//SPR
				if(b0_source1[4:0] ==`SYSREG_SPR)begin
					pipeline0_source1 = renaming_spr_info_old_regname;
				end
				else begin
					$display("[Error][renaming.v] : None No renaming systemregister[Logic Destination : %x]", b0_source1[4:0]);
				end
			end
			*/
			else begin
				pipeline0_source1 = b0_source1;
			end
		end
		//Immediaite
		else if(b0_source1_imm)begin
			pipeline0_source1 = b0_source1;
		end
		//General Register
		else begin
			pipeline0_source1 = {26'h0, renaming_info_old_regname[b0_source1[4:0]]};
		end
	end //Pipeline0 - Source1 Output Selector Combination Logic
	
	//Pipeline1 - Source0
	always @* begin
		//System Register(Except FLAGR Register)
		if(b1_source0_sysreg)begin
			//Flag Register - This Instruction Use
			if(b1_source0_flags)begin
				pipeline1_source0 = (b0_flags_writeback)? b_flag0_buffer : flag_table_read_old_regname;
			end
			//No Renaming System Register
			else if(!b1_source0_sysreg_rename)begin
				pipeline1_source0 = b1_source0;
			end
			//Renaming System Register
			/*
			else begin
				//SPR
				if(b1_source0[4:0] ==`SYSREG_SPR)begin
					pipeline1_source0 = renaming_spr_info_old_regname;
				end
				else begin
					$display("[Error][renaming.v] : None No renaming system register[Logic Destination : %x]", b1_source0[4:0]);
				end
			end
			*/
			else begin
				pipeline1_source0 = b1_source0;
			end
		end
		//Pipeline0 Destination Match Logic Register
		else if(b1_source0[4:0] == b0_logic_destination & b0_writeback)begin
			pipeline1_source0 = b_other0_buffer;
		end
		//General Register
		else begin
			pipeline1_source0 = renaming_info_old_regname[b1_source0[4:0]];
		end
	end //Pipeline1 - Source0 Output Selector Combination Logic
	

	//Pipeline1 - Source1
	always @* begin
		//System Register(Except FLAGR Register)
		if(b1_source1_sysreg)begin
			//No Renaming System Register
			if(!b1_source1_sysreg_rename)begin
				pipeline1_source1 = b1_source1;
			end
			//Renaming System Register
			/*
			else begin
				//SPR
				if(b1_source1[4:0] ==`SYSREG_SPR)begin
					pipeline1_source1 = renaming_spr_info_old_regname;
				end
				else begin
					$display("[Error][renaming.v] : None No renaming systemregister[Logic Destination : %x]", b1_source1[4:0]);
				end
			end
			*/
			else begin
				pipeline1_source1 = b1_source1;
			end
		end
		//Immediaite
		else if(b1_source1_imm)begin
			pipeline1_source1 = b1_source1;
		end
		//Pipeline0 Destination Match Logic Register
		else if(b1_source1[4:0] == b0_logic_destination && b0_writeback)begin
			pipeline1_source1 = b_other0_buffer;
		end
		//General Register
		else begin
			pipeline1_source1 = {26'h0, renaming_info_old_regname[b1_source1[4:0]]};
		end
	end //Pipeline1 - Source1 Output Selector Combination Logic

	
	
	/****************************************
	Renaming Table
	Flag
	****************************************/		
	register_renaming_table #(`SYSREG_FLAGR) RENAMETABLE_FLAGR	(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),
		.iRESTART_VALID(iFREE_RESTART), 
		.iROLLBACK_UPDATE_CANDIDATE0_VALID(iFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_VALID), 
		.iROLLBACK_UPDATE_CANDIDATE0_LREGNAME(`SYSREG_FLAGR), 
		.iROLLBACK_UPDATE_CANDIDATE0_PREGNAME({2'h0, iFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_PREGNAME}),
		.iROLLBACK_UPDATE_CANDIDATE1_VALID(iFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_VALID), 
		.iROLLBACK_UPDATE_CANDIDATE1_LREGNAME(`SYSREG_FLAGR), 
		.iROLLBACK_UPDATE_CANDIDATE1_PREGNAME({2'h0, iFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_PREGNAME}),
		.iROLLBACK_UPDATE_CANDIDATE2_VALID(iFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_VALID), 
		.iROLLBACK_UPDATE_CANDIDATE2_LREGNAME(`SYSREG_FLAGR), 
		.iROLLBACK_UPDATE_CANDIDATE2_PREGNAME({2'h0, iFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_PREGNAME}),
		.iROLLBACK_UPDATE_CANDIDATE3_VALID(iFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_VALID), 
		.iROLLBACK_UPDATE_CANDIDATE3_LREGNAME(`SYSREG_FLAGR), 
		.iROLLBACK_UPDATE_CANDIDATE3_PREGNAME({2'h0, iFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_PREGNAME}),
		.iLOCK(this_lock),
		.iREGIST_0_VALID(iPREVIOUS_0_VALID && !iPREVIOUS_0_DESTINATION_SYSREG && iPREVIOUS_0_FLAGS_WRITEBACK), 
		.iREGIST_0_LOGIC_DESTINATION(`SYSREG_FLAGR), 
		.iREGIST_0_REGNAME({2'h0, iFLAG_REGISTER_0_NUM}), 
		.iREGIST_1_VALID(iPREVIOUS_1_VALID && !iPREVIOUS_1_DESTINATION_SYSREG && iPREVIOUS_1_FLAGS_WRITEBACK), 
		.iREGIST_1_LOGIC_DESTINATION(`SYSREG_FLAGR), 
		.iREGIST_1_REGNAME({2'h0, iFLAG_REGISTER_1_NUM}), 
		.oINFO_VALID(flag_table_read_valid), 
		.oINFO_REGNAME(flag_table_read_regname), 
		.oINFO_OLD_REGNAME(flag_table_read_old_regname)
	);
	
	
	
	/****************************************
	Flag Buffer
	Flag Old Infomation Buffer(Use Next Instruction Data)
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			bb_old_last_instruction_flags_writeback <= 1'b0;
			bb_old_last_instruction_destination_regname <= {6{1'b0}};
		end
		else if(iFREE_DEFAULT)begin
			bb_old_last_instruction_flags_writeback <= 1'b0;
			bb_old_last_instruction_destination_regname <= {6{1'b0}};
		end	
		else begin
			if(!iFLAG_REGISTER_0_EMPTY && !iFLAG_REGISTER_1_EMPTY && !iOTHER_REGISTER_0_EMPTY && !iOTHER_REGISTER_1_EMPTY && !iNEXT_LOCK)begin
				if(b0_valid && b1_valid)begin
					bb_old_last_instruction_flags_writeback <= b1_flags_writeback;
					bb_old_last_instruction_destination_regname <= oNEXT_1_DESTINATION_REGNAME;//b1_destination_regname;
				end
				else if(b0_valid)begin
					bb_old_last_instruction_flags_writeback <= b0_flags_writeback;
					bb_old_last_instruction_destination_regname <= oNEXT_0_DESTINATION_REGNAME;//b0_destination_regname;
				end
			end
		end
	end //always
	
	
	
	/****************************************
	FIFO Out Buffer
	****************************************/	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_other0_buffer <= {6{1'b0}};
			b_other1_buffer <= {6{1'b0}};
			b_flag0_buffer <= {4{1'b0}};
			b_flag1_buffer <= {4{1'b0}};
		end
		else if(iFREE_DEFAULT)begin
			b_other0_buffer <= {6{1'b0}};
			b_other1_buffer <= {6{1'b0}};
			b_flag0_buffer <= {4{1'b0}};
			b_flag1_buffer <= {4{1'b0}};
		end	
		else begin
			if(!iFLAG_REGISTER_0_EMPTY && !iFLAG_REGISTER_1_EMPTY && !iOTHER_REGISTER_0_EMPTY && !iOTHER_REGISTER_1_EMPTY && !iNEXT_LOCK)begin
				b_other0_buffer <= iOTHER_REGISTER_0_NUM;
				b_other1_buffer <= iOTHER_REGISTER_1_NUM;
				b_flag0_buffer <= iFLAG_REGISTER_0_NUM;		
				b_flag1_buffer <= iFLAG_REGISTER_1_NUM;
			end
		end
	end //always
	
	
	/****************************************
	Renaming Table
	Other0 and 1
	****************************************/	
	//General Register
	generate
		for(i = 0; i < 32; i = i + 1)begin : GR_RENAME_TABLE		
			register_renaming_table #(/*`LOGICREG_R0.......R1...*/i[4:0]) GR_RENAME_TABLE	(
				.iCLOCK(iCLOCK), 
				.inRESET(inRESET), 
				.iRESTART_VALID(iFREE_RESTART), 
				.iROLLBACK_UPDATE_CANDIDATE0_VALID(iROLLBACK_UPDATE_CANDIDATE0_VALID && !iROLLBACK_UPDATE_CANDIDATE0_SYSREG), 
				.iROLLBACK_UPDATE_CANDIDATE0_LREGNAME(iROLLBACK_UPDATE_CANDIDATE0_LREGNAME), 
				.iROLLBACK_UPDATE_CANDIDATE0_PREGNAME(iROLLBACK_UPDATE_CANDIDATE0_PREGNAME),
				.iROLLBACK_UPDATE_CANDIDATE1_VALID(iROLLBACK_UPDATE_CANDIDATE1_VALID && !iROLLBACK_UPDATE_CANDIDATE1_SYSREG), 
				.iROLLBACK_UPDATE_CANDIDATE1_LREGNAME(iROLLBACK_UPDATE_CANDIDATE1_LREGNAME), 
				.iROLLBACK_UPDATE_CANDIDATE1_PREGNAME(iROLLBACK_UPDATE_CANDIDATE1_PREGNAME),
				.iROLLBACK_UPDATE_CANDIDATE2_VALID(iROLLBACK_UPDATE_CANDIDATE2_VALID && !iROLLBACK_UPDATE_CANDIDATE2_SYSREG), 
				.iROLLBACK_UPDATE_CANDIDATE2_LREGNAME(iROLLBACK_UPDATE_CANDIDATE2_LREGNAME), 
				.iROLLBACK_UPDATE_CANDIDATE2_PREGNAME(iROLLBACK_UPDATE_CANDIDATE2_PREGNAME),
				.iROLLBACK_UPDATE_CANDIDATE3_VALID(iROLLBACK_UPDATE_CANDIDATE3_VALID && !iROLLBACK_UPDATE_CANDIDATE3_SYSREG), 
				.iROLLBACK_UPDATE_CANDIDATE3_LREGNAME(iROLLBACK_UPDATE_CANDIDATE3_LREGNAME), 
				.iROLLBACK_UPDATE_CANDIDATE3_PREGNAME(iROLLBACK_UPDATE_CANDIDATE3_PREGNAME),						
				.iLOCK(this_lock),
				.iREGIST_0_VALID(iPREVIOUS_0_VALID && !iPREVIOUS_0_DESTINATION_SYSREG && iPREVIOUS_0_WRITEBACK), 
				.iREGIST_0_LOGIC_DESTINATION(iPREVIOUS_0_DESTINATION), 
				.iREGIST_0_REGNAME(iOTHER_REGISTER_0_NUM), 
				.iREGIST_1_VALID(iPREVIOUS_1_VALID && !iPREVIOUS_1_DESTINATION_SYSREG && iPREVIOUS_1_WRITEBACK), 
				.iREGIST_1_LOGIC_DESTINATION(iPREVIOUS_1_DESTINATION), 
				.iREGIST_1_REGNAME(iOTHER_REGISTER_1_NUM), 
				.oINFO_VALID(renaming_info_valid[i[4:0]]), 
				.oINFO_REGNAME(renaming_info_regname[i[4:0]]), 
				.oINFO_OLD_REGNAME(renaming_info_old_regname[i[4:0]])
			);
		end
	endgenerate
	



	/****************************************
	Regist
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
			b0_dest_rename <= 1'b0;	
			b0_writeback <= 1'b0;
			b0_flags_writeback <= 1'b0;
			b0_cmd <= {5{1'b0}};
			b0_cc_afe <= {4{1'b0}};
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
			b1_dest_rename <= 1'b0;
			b1_writeback <= 1'b0;	
			b1_flags_writeback <= 1'b0;
			b1_cmd <= {4{1'b0}};
			b1_cc_afe <= {4{1'b0}};
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
		else if(iFREE_DEFAULT)begin
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
			b0_dest_rename <= 1'b0;	
			b0_writeback <= 1'b0;
			b0_flags_writeback <= 1'b0;
			b0_cmd <= {5{1'b0}};
			b0_cc_afe <= {4{1'b0}};
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
			b1_dest_rename <= 1'b0;
			b1_writeback <= 1'b0;	
			b1_flags_writeback <= 1'b0;
			b1_cmd <= {4{1'b0}};
			b1_cc_afe <= {4{1'b0}};
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
			if(!this_lock)begin
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
				b0_dest_rename <= iPREVIOUS_0_DEST_RENAME;
				b0_writeback <= iPREVIOUS_0_WRITEBACK;	
				b0_flags_writeback <= iPREVIOUS_0_FLAGS_WRITEBACK;
				b0_cmd <= iPREVIOUS_0_CMD;
				b0_cc_afe <= iPREVIOUS_0_CC_AFE;
				b0_destination_regname <= {1'b0, iPREVIOUS_0_DESTINATION};
				b0_logic_destination <= iPREVIOUS_0_DESTINATION;
				b0_source0 <= {1'b0, iPREVIOUS_0_SOURCE0};
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
				b1_dest_rename <= iPREVIOUS_1_DEST_RENAME;	
				b1_writeback <= iPREVIOUS_1_WRITEBACK;	
				b1_flags_writeback <= iPREVIOUS_1_FLAGS_WRITEBACK;				
				b1_cmd <= iPREVIOUS_1_CMD;
				b1_cc_afe <= iPREVIOUS_1_CC_AFE;
				b1_destination_regname <= {1'b0, iPREVIOUS_1_DESTINATION};
				b1_logic_destination <= iPREVIOUS_1_DESTINATION;
				b1_source0 <= {1'b0, iPREVIOUS_1_SOURCE0}; 	//or Renaming Address
				b1_source1 <= iPREVIOUS_1_SOURCE1; 		//or no source
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
	Module Output
	****************************************/
	//Prev-Lock
	assign oPREVIOUS_LOCK = this_lock;
	//Stage Info
	assign oSTAGE_INFO_0_VALID = b0_valid;
	assign oSTAGE_INFO_1_VALID = b1_valid;
	//Next-0	
	assign oNEXT_0_VALID = !this_lock && b0_valid;
	assign oNEXT_0_SOURCE0_ACTIVE = b0_source0_active;
	assign oNEXT_0_SOURCE1_ACTIVE = b0_source1_active;
	assign oNEXT_0_SOURCE0_SYSREG = b0_source0_sysreg;
	assign oNEXT_0_SOURCE1_SYSREG = b0_source1_sysreg;
	assign oNEXT_0_SOURCE0_SYSREG_RENAME = b0_source0_sysreg_rename;
	assign oNEXT_0_SOURCE1_SYSREG_RENAME = b0_source1_sysreg_rename;
	assign oNEXT_0_ADV_ACTIVE = b0_adv_active;
	assign oNEXT_0_DESTINATION_SYSREG = b0_destination_sysreg;
	assign oNEXT_0_WRITEBACK = b0_writeback;
	assign oNEXT_0_FLAGS_WRITEBACK = b0_flags_writeback;//20120723 || bb_old_last_instruction_flags_writeback && b0_ex_branch;
	assign oNEXT_0_CMD = b0_cmd;
	assign oNEXT_0_CC_AFE = b0_cc_afe;
	assign oNEXT_0_FLAGS_REGNAME = b_flag0_buffer;
	assign oNEXT_0_DESTINATION_REGNAME = (b0_destination_sysreg)? {1'b0, b0_logic_destination} : b_other0_buffer;
	assign oNEXT_0_LOGIC_DESTINATION = b0_logic_destination;
	assign oNEXT_0_SOURCE0 = pipeline0_source0;	
	assign oNEXT_0_SOURCE1 = pipeline0_source1;
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
	assign oNEXT_1_VALID = !this_lock && b1_valid;
	assign oNEXT_1_SOURCE0_ACTIVE = b1_source0_active;
	assign oNEXT_1_SOURCE1_ACTIVE = b1_source1_active;
	assign oNEXT_1_SOURCE0_SYSREG = b1_source0_sysreg;
	assign oNEXT_1_SOURCE1_SYSREG = b1_source1_sysreg;
	assign oNEXT_1_SOURCE0_SYSREG_RENAME = b1_source0_sysreg_rename;
	assign oNEXT_1_SOURCE1_SYSREG_RENAME = b1_source1_sysreg_rename;
	assign oNEXT_1_ADV_ACTIVE = b1_adv_active;
	assign oNEXT_1_DESTINATION_SYSREG = b1_destination_sysreg;
	assign oNEXT_1_WRITEBACK = b1_writeback;
	assign oNEXT_1_FLAGS_WRITEBACK = b1_flags_writeback;//20120723|| b0_flags_writeback && b1_ex_branch;
	assign oNEXT_1_CMD = b1_cmd;
	assign oNEXT_1_CC_AFE = b1_cc_afe;
	assign oNEXT_1_FLAGS_REGNAME = b_flag1_buffer;
	assign oNEXT_1_DESTINATION_REGNAME = (b1_destination_sysreg)? {1'b0, b1_logic_destination} : b_other1_buffer;
	assign oNEXT_1_LOGIC_DESTINATION = b1_logic_destination;		
	assign oNEXT_1_SOURCE0 = pipeline1_source0; 
	assign oNEXT_1_SOURCE1 = pipeline1_source1;
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
	//FIFO Read (Reqest) - Register CH0					
	assign oOTHER_REGISTER_0_RD = new_register_0_req_condition;
	//FIFO Read (Reqest) - Register CH1
	assign oOTHER_REGISTER_1_RD = new_register_1_req_condition;
	//FIFO Read (Reqest)
	assign oFLAG_REGISTER_0_RD = new_register_0_flag_req_condition;
	assign oFLAG_REGISTER_1_RD = new_register_1_flag_req_condition;
	
	
endmodule


`default_nettype wire




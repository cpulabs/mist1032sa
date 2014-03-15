/****************************************
MIST1032 - Core-Main Pipeline
	[ODCP] Open Design Computer Project
****************************************/
`default_nettype none

module core_pipeline #(
		parameter CORE_ID = 32'h0
	)(
		//System
		input wire iCLOCK,
		input wire inRESET,
		/****************************************
		System
		****************************************/
		output wire oFREE_TLB_FLUSH,		
		/****************************************
		GCI Controll
		****************************************/
		//Interrupt Controll
		output wire oIO_IRQ_CONFIG_TABLE_REQ,
		output wire [5:0] oIO_IRQ_CONFIG_TABLE_ENTRY,
		output wire oIO_IRQ_CONFIG_TABLE_FLAG_MASK,
		output wire oIO_IRQ_CONFIG_TABLE_FLAG_VALID,
		output wire [1:0] oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL,	
		/****************************************
		Instrution Memory
		****************************************/	
		//Req
		output wire oINST_REQ,
		input wire iINST_LOCK,
		output wire [1:0] oINST_MMUMOD,
		output wire [31:0] oINST_PDT,
		output wire [31:0] oINST_ADDR,
		//RAM -> This
		input wire iINST_VALID,
		output wire oINST_BUSY,
		input wire iINST_PAGEFAULT,
		input wire iINST_QUEUE_FLUSH,
		input wire [63:0] iINST_DATA,
		input wire [27:0] iINST_MMU_FLAGS,
		/****************************************
		Load Store Access
		****************************************/
		//Req
		output wire oDATA_REQ,
		input wire iDATA_LOCK,
		output wire [1:0] oDATA_ORDER,
		output wire [3:0] oDATA_MASK,
		output wire oDATA_RW,		//0=Write 1=Read
		output wire [13:0] oDATA_TID,
		output wire [1:0] oDATA_MMUMOD,
		output wire [31:0] oDATA_PDT,
		output wire [31:0] oDATA_ADDR,
		//This -> Data RAM
		output wire [31:0] oDATA_DATA,
		//Data RAM -> This
		input wire iDATA_VALID,
		input wire iDATA_PAGEFAULT,
		input wire [63:0] iDATA_DATA,
		input wire [27:0] iDATA_MMU_FLAGS,
		/****************************************
		IO
		****************************************/
		//Req
		output wire oIO_REQ,
		input wire iIO_BUSY,
		output wire [1:0] oIO_ORDER,
		output wire oIO_RW,			//0=Write 1=Read
		output wire [31:0] oIO_ADDR,
		//Write
		output wire [31:0] oIO_DATA,
		//Rec
		input wire iIO_VALID,
		input wire [31:0] iIO_DATA,
		/****************************************
		Interrupt
		****************************************/
		input wire iINTERRUPT_VALID,
		input wire [5:0] iINTERRUPT_NUM,
		output wire oINTERRUPT_ACK,
		/****************************************
		System Infomation
		****************************************/
		//IOSR(Input Output Status Register)
		input wire iSYSINFO_IOSR_VALID,	
		input wire [31:0] iSYSINFO_IOSR		
	);
			
			
	//Dummy
	assign oFREE_TLB_FLUSH = 1'b0;


	/****************************************
	Core Internal wire
	****************************************/
	//FreeRegister
	wire freereg_renaming2scheduler1_flag0_rd;
	wire [3:0] freereg_renaming2scheduler1_flag0_num;
	wire freereg_renaming2scheduler1_flag0_empty;
	wire freereg_renaming2scheduler1_flag1_rd;
	wire [3:0] freereg_renaming2scheduler1_flag1_num;
	wire freereg_renaming2scheduler1_flag1_empty;	
	wire freereg_renaming2scheduler1_other0_rd;
	wire [5:0] freereg_renaming2scheduler1_other0_num;
	wire freereg_renaming2scheduler1_other0_empty;
	wire freereg_renaming2scheduler1_other1_rd;
	wire [5:0] freereg_renaming2scheduler1_other1_num;
	wire freereg_renaming2scheduler1_other1_empty;
	wire freereg_scheduler12scheduler2_flag0_wr;
	wire [3:0] freereg_scheduler12scheduler2_flag0_num;
	wire freereg_scheduler12scheduler2_flag0_full;
	wire [1:0] freereg_scheduler12scheduler2_flag0_count;
	wire freereg_scheduler12scheduler2_flag1_wr;
	wire [3:0] freereg_scheduler12scheduler2_flag1_num;
	wire freereg_scheduler12scheduler2_flag1_full;
	wire [1:0] freereg_scheduler12scheduler2_flag1_count;
	
	wire freereg_scheduler12scheduler2_other0_wr;
	wire [5:0] freereg_scheduler12scheduler2_other0_num;
	wire freereg_scheduler12scheduler2_other0_full;
	wire [2:0] freereg_scheduler12scheduler2_other0_count;
	wire freereg_scheduler12scheduler2_other1_wr;
	wire [5:0] freereg_scheduler12scheduler2_other1_num;
	wire freereg_scheduler12scheduler2_other1_full;
	wire [2:0] freereg_scheduler12scheduler2_other1_count;
	//Jump
	wire jump_active;
	wire [31:0] jump_addr;
	//Free
	wire [63:0] free_register;
	//Info
	wire [5:0] commit_counter;
	wire exception_protect;
	//Re Order Buffer
	wire [63:0] commit_vector;
	//Commit 
	wire [2:0] commit_offset;
	//Stage Info
	wire stage_info_renaming_0_valid;
	wire stage_info_renaming_1_valid;
	wire stage_info_scheduler1_0_valid;
	wire stage_info_scheduler1_1_valid;
	wire [5:0] stage_info_scheduler1_regist_pointer;
	wire [5:0] stage_info_scheduler1_commit_pointer;
	//Renaming Table
	wire scheduler12renaming_rollback_update_info0_valid;
	wire [4:0] scheduler12renaming_rollback_update_info0_lregname;
	wire [5:0] scheduler12renaming_rollback_update_info0_pregname;
	wire scheduler12renaming_rollback_update_info0_sysreg;
	wire scheduler12renaming_rollback_update_info1_valid;
	wire [4:0] scheduler12renaming_rollback_update_info1_lregname;
	wire [5:0] scheduler12renaming_rollback_update_info1_pregname;
	wire scheduler12renaming_rollback_update_info1_sysreg;
	wire scheduler12renaming_rollback_update_info2_valid;
	wire [4:0] scheduler12renaming_rollback_update_info2_lregname;
	wire [5:0] scheduler12renaming_rollback_update_info2_pregname;
	wire scheduler12renaming_rollback_update_info2_sysreg;
	wire scheduler12renaming_rollback_update_info3_valid;
	wire [4:0] scheduler12renaming_rollback_update_info3_lregname;
	wire [5:0] scheduler12renaming_rollback_update_info3_pregname;
	wire scheduler12renaming_rollback_update_info3_sysreg;
	wire scheduler12renaming_flags_rollback_update_info0_valid;
	wire [3:0] scheduler12renaming_flags_rollback_update_info0_pregname;
	wire scheduler12renaming_flags_rollback_update_info1_valid;
	wire [3:0] scheduler12renaming_flags_rollback_update_info1_pregname;
	wire scheduler12renaming_flags_rollback_update_info2_valid;
	wire [3:0] scheduler12renaming_flags_rollback_update_info2_pregname;
	wire scheduler12renaming_flags_rollback_update_info3_valid;
	wire [3:0] scheduler12renaming_flags_rollback_update_info3_pregname;

	//I-cache to Fetch
	wire icache2fetch_0_inst_valid;
	//wire icache2fetch_0_inst_pagefault;
	wire [13:0] icache2fetch_0_inst_mmuflags;
	wire [31:0] icache2fetch_0_inst_inst;
	wire icache2fetch_1_inst_valid;
	//wire icache2fetch_1_inst_pagefault;
	wire [13:0] icache2fetch_1_inst_mmuflags;
	wire [31:0] icache2fetch_1_inst_inst;
	wire fetch2icache_inst_busy;


	wire fetch2icache_inst_req;
	wire [31:0] fetch2icache_inst_addr;
	wire icache2fetch_inst_busy;

	//Fetch to Decoder and Decoder to Fetch
	wire fetch2decoder_0_inst_valid;
	wire [5:0] fetch2decoder_0_mmu_flags;
	wire [31:0] fetch2decoder_0_inst;
	wire fetch2decoder_1_inst_valid;
	wire [5:0] fetch2decoder_1_mmu_flags;
	wire [31:0] fetch2decoder_1_inst;
	wire [31:0] fetch2decoder_pc;
	wire decoder2fetch_lock;
	//Decoder to Matching and Matching to Fetch
	wire decoder2matching_0_valid;
	wire [5:0] decoder2matching_0_mmu_flags;
	wire decoder2matching_0_source0_active;
	wire decoder2matching_0_source1_active;
	wire decoder2matching_0_source0_sysreg;
	wire decoder2matching_0_source1_sysreg;
	wire decoder2matching_0_source0_sysreg_rename;
	wire decoder2matching_0_source1_sysreg_rename;
	wire decoder2matching_0_adv_active;
	wire [5:0] decoder2matching_0_adv_data;
	wire decoder2matching_0_destination_sysreg;
	wire decoder2matching_0_dest_rename;
	wire decoder2matching_0_writeback;
	wire decoder2mathsing_0_flags_writeback;
	wire decoder2matching_0_front_commit_wait;
	wire [4:0] decoder2matching_0_cmd;
	wire [3:0] decoder2matching_0_cc_afe;
	wire [4:0] decoder2matching_0_source0;
	wire [31:0] decoder2matching_0_source1;
	wire decoder2matching_0_source0_flags;
	wire decoder2matching_0_source1_imm;
	wire [4:0] decoder2matching_0_destination;
	wire decoder2matching_0_sys_reg;
	wire decoder2matching_0_sys_ldst;
	wire decoder2matching_0_logic;
	wire decoder2matching_0_shift;
	wire decoder2matching_0_adder;
	wire decoder2matching_0_mul;
	wire decoder2matching_0_sdiv;
	wire decoder2matching_0_udiv;
	wire decoder2matching_0_ldst;
	wire decoder2matching_0_branch;
	wire decoder2matching_1_valid;
	wire [5:0] decoder2matching_1_mmu_flags;
	wire decoder2matching_1_source0_active;
	wire decoder2matching_1_source1_active;
	wire decoder2matching_1_source0_sysreg;
	wire decoder2matching_1_source1_sysreg;
	wire decoder2matching_1_source0_sysreg_rename;
	wire decoder2matching_1_source1_sysreg_rename;
	wire decoder2matching_1_adv_active;
	wire [5:0] decoder2matching_1_adv_data;
	wire decoder2matching_1_destination_sysreg;
	wire decoder2matching_1_dest_rename;
	wire decoder2matching_1_writeback;
	wire decoder2mathsing_1_flags_writeback;
	wire decoder2matching_1_front_commit_wait;
	wire [4:0] decoder2matching_1_cmd;
	wire [3:0] decoder2matching_1_cc_afe;
	wire [4:0] decoder2matching_1_source0;
	wire [31:0] decoder2matching_1_source1;
	wire decoder2matching_1_source0_flags;
	wire decoder2matching_1_source1_imm;
	wire [4:0] decoder2matching_1_destination;
	wire decoder2matching_1_sys_reg;
	wire decoder2matching_1_sys_ldst;
	wire decoder2matching_1_logic;
	wire decoder2matching_1_shift;
	wire decoder2matching_1_adder;
	wire decoder2matching_1_mul;
	wire decoder2matching_1_sdiv;
	wire decoder2matching_1_udiv;
	wire decoder2matching_1_ldst;
	wire decoder2matching_1_branch;
	wire [31:0] decoder2matching_pc;
	wire matching2decoder_lock;
	//Matching to Fetch
	wire matching2fetch_loopbuffer_limit;
	//Matching to Renaming and Renaming to Matching
	wire matching2renaming_0_valid;
	wire matching2renaming_0_source0_active;
	wire matching2renaming_0_source1_active;
	wire matching2renaming_0_source0_sysreg;
	wire matching2renaming_0_source1_sysreg;
	wire matching2renaming_0_source0_sysreg_rename;
	wire matching2renaming_0_source1_sysreg_rename;
	wire matching2renaming_0_adv_active;
	wire matching2renaming_0_destination_sysreg;
	wire matching2renaming_0_dest_rename;
	wire matching2renaming_0_writeback;
	wire matching2renaming_0_flags_writeback;
	wire [4:0] matching2renaming_0_cmd;
	wire [3:0] matching2renaming_0_cc_afe;
	wire [4:0] matching2renaming_0_source0;
	wire [31:0] matching2renaming_0_source1;
	wire [5:0] matching2renaming_0_adv_data;
	wire matching2renaming_0_source0_flags;
	wire matching2renaming_0_source1_imm;
	wire [4:0] matching2renaming_0_destination;
	wire matching2renaming_0_sys_adder;
	wire matching2renaming_0_sys_ldst;
	wire matching2renaming_0_logic;
	wire matching2renaming_0_shift;
	wire matching2renaming_0_adder;
	wire matching2renaming_0_mul;
	wire matching2renaming_0_sdiv;
	wire matching2renaming_0_udiv;
	wire matching2renaming_0_ldst;
	wire matching2renaming_0_branch;
	wire matching2renaming_1_valid;
	wire matching2renaming_1_source0_active;
	wire matching2renaming_1_source1_active;
	wire matching2renaming_1_source0_sysreg;
	wire matching2renaming_1_source1_sysreg;
	wire matching2renaming_1_source0_sysreg_rename;
	wire matching2renaming_1_source1_sysreg_rename;
	wire matching2renaming_1_adv_active;
	wire matching2renaming_1_destination_sysreg;
	wire matching2renaming_1_dest_rename;
	wire matching2renaming_1_writeback;
	wire matching2renaming_1_flags_writeback;
	wire matching2renaming_1_system_end;
	wire [4:0] matching2renaming_1_cmd;
	wire [3:0] matching2renaming_1_cc_afe;
	wire [4:0] matching2renaming_1_source0;
	wire [31:0] matching2renaming_1_source1;
	wire [5:0] matching2renaming_1_adv_data;
	wire matching2renaming_1_source0_flags;
	wire matching2renaming_1_source1_imm;
	wire [4:0] matching2renaming_1_destination;
	wire matching2renaming_1_sys_adder;
	wire matching2renaming_1_sys_ldst;
	wire matching2renaming_1_logic;
	wire matching2renaming_1_shift;
	wire matching2renaming_1_adder;
	wire matching2renaming_1_mul;
	wire matching2renaming_1_sdiv;
	wire matching2renaming_1_udiv;
	wire matching2renaming_1_ldst;
	wire matching2renaming_1_branch;
	wire [31:0] matching2renaming_pc;
	wire renaming2matching_lock;
	//Renaming to Scheduler1 and Scheduler1 to Renaming
	wire renaming2scheduler1_0_valid;
	wire renaming2scheduler1_0_source0_active;
	wire renaming2scheduler1_0_source1_active;
	wire renaming2scheduler1_0_source0_sysreg;
	wire renaming2scheduler1_0_source1_sysreg;
	wire renaming2scheduler1_0_source0_sysreg_rename;
	wire renaming2scheduler1_0_source1_sysreg_rename;
	wire renaming2scheduler1_0_adv_active;
	wire renaming2scheduler1_0_destination_sysreg;
	wire renaming2scheduler1_0_data_writeback;
	wire renaming2scheduler1_0_flags_writeback;
	wire [4:0] renaming2scheduler1_0_cmd;
	wire [3:0] renaming2scheduler1_0_cc_afe;
	wire [3:0] renaming2scheduler1_0_flags_regname;
	wire [5:0] renaming2scheduler1_0_destination_regname;
	wire [4:0] renaming2scheduler1_0_logic_destination;
	wire [5:0] renaming2scheduler1_0_source0;
	wire [31:0] renaming2scheduler1_0_source1;
	wire [5:0] renaming2scheduler1_0_adv_data;
	wire renaming2scheduler1_0_source0_flags;
	wire renaming2scheduler1_0_source1_imm;
	wire renaming2scheduler1_0_sys_adder;
	wire renaming2scheduler1_0_sys_ldst;
	wire renaming2scheduler1_0_logic;
	wire renaming2scheduler1_0_shift;
	wire renaming2scheduler1_0_adder;
	wire renaming2scheduler1_0_mul;
	wire renaming2scheduler1_0_sdiv;
	wire renaming2scheduler1_0_udiv;
	wire renaming2scheduler1_0_ldst;
	wire renaming2scheduler1_0_branch;
	wire renaming2scheduler1_1_valid;
	wire renaming2scheduler1_1_source0_active;
	wire renaming2scheduler1_1_source1_active;
	wire renaming2scheduler1_1_source0_sysreg;
	wire renaming2scheduler1_1_source1_sysreg;
	wire renaming2scheduler1_1_source0_sysreg_rename;
	wire renaming2scheduler1_1_source1_sysreg_rename;
	wire renaming2scheduler1_1_adv_active;
	wire renaming2scheduler1_1_destination_sysreg;
	wire renaming2scheduler1_1_data_writeback;
	wire renaming2scheduler1_1_flags_writeback;
	wire [4:0] renaming2scheduler1_1_cmd;
	wire [3:0] renaming2scheduler1_1_cc_afe;
	wire [3:0] renaming2scheduler1_1_flags_regname;
	wire [5:0] renaming2scheduler1_1_destination_regname;
	wire [4:0] renaming2scheduler1_1_logic_destination;
	wire [5:0] renaming2scheduler1_1_source0;
	wire [31:0] renaming2scheduler1_1_source1;
	wire [5:0] renaming2scheduler1_1_adv_data;
	wire renaming2scheduler1_1_source0_flags;
	wire renaming2scheduler1_1_source_imm;
	wire renaming2scheduler1_1_sys_adder;
	wire renaming2scheduler1_1_sys_ldst;
	wire renaming2scheduler1_1_logic;
	wire renaming2scheduler1_1_shift;
	wire renaming2scheduler1_1_adder;
	wire renaming2scheduler1_1_mul;
	wire renaming2scheduler1_1_sdiv;
	wire renaming2scheduler1_1_udiv;
	wire renaming2scheduler1_1_ldst;
	wire renaming2scheduler1_1_branch;
	wire [31:0] renaming2scheduler1_pc;
	wire scheduler12renaming_lock;
	//Scheduler1 to Scheduler2 and Scheduler2 to Scheduler1
	wire scheduler12scheduler2_0_valid;
	wire scheduler12scheduler2_0_source0_active;
	wire scheduler12scheduler2_0_source1_active;
	wire scheduler12scheduler2_0_source0_sysreg;
	wire scheduler12scheduler2_0_source1_sysreg;
	wire scheduler12scheduler2_0_source0_sysreg_rename;
	wire scheduler12scheduler2_0_source1_sysreg_rename;
	wire scheduler12scheduler2_0_adv_active;
	wire scheduler12scheduler2_0_destination_sysreg;
	wire scheduler12scheduler2_0_writeback;
	wire scheduler12scheduler2_0_flags_writeback;
	wire [4:0] scheduler12scheduler2_0_cmd;
	wire [5:0] scheduler12scheduler2_0_commit_tag;
	wire [3:0] scheduler12scheduler2_0_cc_afe;
	wire [3:0] scheduler12scheduler2_0_flags_regname;
	wire [5:0] scheduler12scheduler2_0_destination_regname;
	wire [4:0] scheduler12scheduler2_0_logic_destination;
	wire [5:0] scheduler12scheduler2_0_source0;
	wire [31:0] scheduler12scheduler2_0_source1;
	wire [5:0] scheduler12scheduler2_0_adv_data;
	wire scheduler12scheduler2_0_source0_flags;
	wire scheduler12scheduler2_0_source1_imm;
	wire scheduler12scheduler2_0_sys_reg;
	wire scheduler12scheduler2_0_sys_ldst;
	wire scheduler12scheduler2_0_logic;
	wire scheduler12scheduler2_0_shift;
	wire scheduler12scheduler2_0_adder;
	wire scheduler12scheduler2_0_mul;
	wire scheduler12scheduler2_0_sdiv;
	wire scheduler12scheduler2_0_udiv;
	wire scheduler12scheduler2_0_ldst;
	wire scheduler12scheduler2_0_branch;
	wire scheduler12scheduler2_1_valid;
	wire scheduler12scheduler2_1_source0_active;
	wire scheduler12scheduler2_1_source1_active;
	wire scheduler12scheduler2_1_source0_sysreg;
	wire scheduler12scheduler2_1_source1_sysreg;
	wire scheduler12scheduler2_1_source0_sysreg_rename;
	wire scheduler12scheduler2_1_source1_sysreg_rename;
	wire scheduler12scheduler2_1_adv_active;
	wire scheduler12scheduler2_1_destination_sysreg;
	wire scheduler12scheduler2_1_writeback;
	wire scheduler12scheduler2_1_flags_writeback;
	wire [4:0] scheduler12scheduler2_1_cmd;
	wire [5:0] scheduler12scheduler2_1_commit_tag;
	wire [3:0] scheduler12scheduler2_1_cc_afe;
	wire [3:0] scheduler12scheduler2_1_flags_regname;
	wire [5:0] scheduler12scheduler2_1_destination_regname;
	wire [4:0] scheduler12scheduler2_1_logic_destination;
	wire [5:0] scheduler12scheduler2_1_source0;
	wire [31:0] scheduler12scheduler2_1_source1;
	wire [5:0] scheduler12scheduler2_1_adv_data;
	wire scheduler12scheduler2_1_source0_flags;
	wire scheduler12scheduler2_1_source1_imm;
	wire scheduler12scheduler2_1_sys_reg;
	wire scheduler12scheduler2_1_sys_ldst;
	wire scheduler12scheduler2_1_logic;
	wire scheduler12scheduler2_1_shift;
	wire scheduler12scheduler2_1_adder;
	wire scheduler12scheduler2_1_mul;
	wire scheduler12scheduler2_1_sdiv;
	wire scheduler12scheduler2_1_udiv;
	wire scheduler12scheduler2_1_ldst;
	wire scheduler12scheduler2_1_branch;
	wire [31:0] scheduler12scheduler2_pc;
	wire scheduler22scheduler1_lock;
	//Scheduler2 to alu0 and alu0 to Scheduler2
	wire scheduler22ex_alu0_valid;
	wire [5:0] scheduler22ex_alu0_commit_tag;
	wire [4:0] scheduler22ex_alu0_cmd;
	wire [3:0] scheduler22ex_alu0_cc;
	wire [4:0] scheduler22ex_alu0_flag;
	wire [31:0] scheduler22ex_alu0_source;
	wire [31:0] scheduler22ex_alu0_pc;
	wire ex_alu02scheduler2_lock;
	wire ex_alu02scheduler2_branch_valid;
	wire [5:0] ex_alu02scheduler2_branch_commit_tag;
	//Scheduler2 to alu1
	wire scheduler22ex_alu1_valid;
	wire scheduler22ex_alu1_writeback;
	wire [5:0] scheduler22ex_alu1_commit_tag;
	wire [4:0] scheduler22ex_alu1_cmd;
	wire [3:0] scheduler22ex_alu1_afe;
	wire scheduler22ex_alu1_sys_reg;
	wire scheduler22ex_alu1_logic;
	wire scheduler22ex_alu1_shift;
	wire scheduler22ex_alu1_adder;
	wire scheduler22ex_alu1_mul;
	wire scheduler22ex_alu1_sdiv;
	wire scheduler22ex_alu1_udiv;
	wire [31:0] scheduler22ex_alu1_source0;
	wire [31:0] scheduler22ex_alu1_source1;
	wire scheduler22ex_alu1_destination_sysreg;
	wire [4:0] scheduler22ex_alu1_logic_dest;
	wire [5:0] scheduler22ex_alu1_destination_regname;
	wire scheduler22ex_alu1_flags_writeback;
	wire [3:0] scheduler22ex_alu1_flags_regname;
	wire [31:0] scheduler22ex_alu1_pcr;
	wire ex_alu12scheduler2_lock;
	wire ex_alu12scheduler2_valid;
	wire [5:0] ex_alu12scheduler2_commit_tag;
	wire ex_alu12scheduler2_destination_sysreg;
	wire [5:0] ex_alu12scheduler2_destination_regname;
	wire ex_alu12scheduler2_writeback;
	wire [31:0] ex_alu12scheduler2_data;
	wire [4:0] ex_alu12scheduler2_flag;
	wire ex_alu12scheduler2_flags_writeback;
	wire [3:0] ex_alu12scheduler2_flags_regname;
	//Scheduler2 to alu2 
	wire scheduler22ex_alu2_valid;
	wire scheduler22ex_alu2_writeback;
	wire [5:0] scheduler22ex_alu2_commit_tag;
	wire [4:0] scheduler22ex_alu2_cmd;
	wire [3:0] scheduler22ex_alu2_afe;
	wire scheduler22ex_alu2_sys_reg;
	wire scheduler22ex_alu2_logic;
	wire scheduler22ex_alu2_shift;
	wire scheduler22ex_alu2_adder;
	wire [31:0] scheduler22ex_alu2_source0;
	wire [31:0] scheduler22ex_alu2_source1;
	wire scheduler22ex_alu2_destination_sysreg;
	wire [4:0] scheduler22ex_alu2_logic_dest;
	wire [5:0] scheduler22ex_alu2_destination_regname;
	wire scheduler22ex_alu2_flags_writeback;
	wire [3:0] scheduler22ex_alu2_flags_regname;
	wire [31:0] scheduler22ex_alu2_pcr;
	wire ex_alu22scheduler2_lock;
	wire ex_alu22scheduler2_valid;
	wire [5:0] ex_alu22scheduler2_commit_tag;
	wire ex_alu22scheduler2_destination_sysreg;
	wire [5:0] ex_alu22scheduler2_destination_regname;
	wire ex_alu22scheduler2_writeback;
	wire [31:0] ex_alu22scheduler2_data;
	wire [4:0] ex_alu22scheduler2_flag;
	wire ex_alu22scheduler2_flags_writeback;
	wire [3:0] ex_alu22scheduler2_flags_regname;
	//Scheduler2 to alu3 and alu3 to scheduler2
	wire scheduler22ex_alu3_valid;
	wire scheduler22ex_alu3_destination_sysreg;
	wire [5:0] scheduler22ex_alu3_commit_tag;
	wire [4:0] scheduler22ex_alu3_cmd;
	wire scheduler22ex_alu3_sys_ldst;
	wire scheduler22ex_alu3_ldst;
	wire [31:0] scheduler22ex_alu3_source0;
	wire [31:0] scheduler22ex_alu3_source1;
	wire scheduler22ex_alu3_adv_active;
	wire [5:0] scheduler22ex_alu3_adv_data;
	wire [4:0] scheduler22ex_alu3_logic_dest;
	wire [5:0] scheduler22ex_alu3_destination_regname;
	wire [31:0] scheduler22ex_alu3_pc;
	wire ex_alu32scheduler2_ldst_lock;
	wire ex_alu32scheduler2_ldst_valid;
	wire [5:0] ex_alu32scheduler2_ldst_commit_tag;
	wire [5:0] ex_alu32scheduler2_ldst_destination_regname;
	wire ex_alu32scheduler2_ldst_destination_sysreg;
	wire ex_alu32scheduler2_ldst_writeback;
	wire [31:0] ex_alu32scheduler2_ldst_data;
	//alu0-3 to scheduler1
	wire ex_alu02scheduler1_branch_valid;
	wire [5:0] ex_alu02scheduler1_branch_commit_tag;
	wire ex_alu12scheduler1_valid;
	wire [5:0] ex_alu12scheduler1_commit_tag;
	wire ex_alu22scheduler1_valid;
	wire [5:0] ex_alu22scheduler1_commit_tag;
	wire ex_alu32scheduler1_ldst_valid;
	wire [5:0] ex_alu32scheduler1_ldst_commit_tag;
	//alu0 to IIC
	wire ex_alu02iic_swi_active;
	wire [10:0] ex_alu02iic_swi_number;
	//alu0~3 to CIM
	wire ex_alu12cim_valid;
	wire [10:0] ex_alu12cim_num;
	//SystemRegister
	wire [31:0] wire_sysreg_tidr;
	wire [31:0] wire_sysreg_ptidr;
	wire [31:0] wire_sysreg_psr;
	wire [31:0] wire_sysreg_ppsr;
	wire [31:0] wire_sysreg_tisr;
	wire [31:0] wire_sysreg_pdtr;
	wire [31:0] wire_sysreg_idtr;
	wire [31:0] wire_sysreg_ppcr;
	wire [31:0] wire_sysreg_spr;
	//ALU3 to Load Store Selector
	wire alu32ldst_ldst_req;
	wire ldst2alu3_ldst_busy;
	wire [1:0] alu32ldst_ldst_order;
	wire [3:0] alu32ldst_ldst_mask;
	wire alu32ldst_ldst_rw;
	wire [13:0] alu32ldst_ldst_tid;
	wire [1:0] alu32ldst_ldst_mmumod;
	wire [31:0] alu32ldst_ldst_pdt;
	wire [31:0] alu32ldst_ldst_addr;
	wire [31:0] alu32ldst_ldst_data;
	wire ldst2alu3_ldst_req;
	wire [31:0] ldst2alu3_ldst_data;
			
	
	/****************************************
	Internal Interrupt Controlor
	****************************************/
	wire exception2cim_irq_lock;	
	wire cim2exception_irq_req;
	wire [6:0] cim2exception_irq_num;
	wire exception2cim_irq_ack;
	
	wire exception2ldst_ldst_use;
	wire exception2ldst_ldst_req;
	wire ldst2exception_ldst_busy;
	wire [1:0] exception2ldst_ldst_order;
	wire exception2ldst_ldst_rw;
	wire [13:0] exception2ldst_ldst_tid;
	wire [1:0] exception2ldst_ldst_mmumod;
	wire [31:0] exception2ldst_ldst_pdt;
	wire [31:0] exception2ldst_ldst_addr;
	wire [31:0] exception2ldst_ldst_data;
	wire ldst2exception_ldst_req;
	wire [31:0] ldst2exception_ldst_data;
	
	wire exception2cim_ict_req;
	wire [5:0] exception2cim_ict_entry;
	wire exception2cim_ict_conf_mask;
	wire exception2cim_ict_conf_valid;
	wire [1:0] exception2cim_ict_conf_level;
	
	wire exception2alu0_new_spr_valid;
	wire [31:0] exception2alu0_new_spr;
	
	wire ex_alu02exception_intr_active;
	wire [31:0] ex_alu02exception_intr_addr;
	
	wire ex_alu02exception_idts_active;
	wire [31:0] ex_alu02exception_idts_r_addr;
	wire [5:0] ex_alu02exception_idts_commit_tag;
	
	wire [31:0] current_execution_pc;
		
	wire exception_inst_discard;
	wire exception_event;
	wire [5:0] exception_commit_tag;
	wire exception_addr_set;
	wire [31:0] exception_addr;
	wire exception_restart;
	wire [31:0] exception_current_pc;
	wire exception2scheduler2_irq_reqister_set;
	wire exception2scheduler2_irq_reqister_ret;
		

	core_interrupt_manager CORE_INT_M(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Exception
		.iFREE_IRQ_SETCONDITION(exception2scheduler2_irq_reqister_set),
		//Core Interrupt Configlation Table
		.iICT_VALID(exception2cim_ict_req),
		.iICT_ENTRY(exception2cim_ict_entry),
		.iICT_CONF_MASK(exception2cim_ict_conf_mask),
		.iICT_CONF_VALID(exception2cim_ict_conf_valid),	
		.iICT_CONF_LEVEL(exception2cim_ict_conf_level),	
		//Sysreg
		.iSYSREGINFO_PSR(wire_sysreg_psr),
		//Interrupt Input
		.iEXT_ACTIVE(iINTERRUPT_VALID),
		.iEXT_NUM(iINTERRUPT_NUM),
		.oEXT_ACK(oINTERRUPT_ACK),
		//Internal IRQ
		/*
		.iSWI_ACTIVE(ex_alu02iic_swi_active),
		.iSWI_NUM(ex_alu02iic_swi_number[6:0]),
		//To Exception Manager
		.iEXCEPTION_LOCK(exception2cim_irq_lock),
		.oEXCEPTION_ACTIVE(cim2exception_irq_req),
		.oEXCEPTION_IRQ_NUM(cim2exception_irq_num),
		.iEXCEPTION_IRQ_ACK(exception2cim_irq_ack)
		*/
		.iFAULT_ACTIVE(ex_alu02iic_swi_active),
		.iFAULT_NUM(ex_alu02iic_swi_number[6:0]),	
		.iFAULT_FI0R(32'h0),	//dummy
		///To Exception Manager
		.iEXCEPTION_LOCK(exception2cim_irq_lock),
		.oEXCEPTION_ACTIVE(cim2exception_irq_req),
		.oEXCEPTION_IRQ_NUM(cim2exception_irq_num),
		.oEXCEPTION_IRQ_FI0R(),
		.iEXCEPTION_IRQ_ACK(exception2cim_irq_ack)
	);
	
	
	/****************************************
	Core Exception Manager
	****************************************/
	exception_manager EXCEPTION_MANAGER(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		/*********************************
		Core
		*********************************/
		//Commit & Regist Info
		.iCOREINFO_COMMIT_COUNTER(commit_counter),
		.iCOREINFO_EXCEPTION_PROTECT(exception_protect),
		//Scheduler1
		.iCOREINFO_CURRENT_PC(current_execution_pc),
		//Free
		.oCOREINFO_FREE_INST_DISCARD(exception_inst_discard),
		.oCOREINFO_FREE_EVENT(exception_event),
		.oCOREINFO_FREE_COMMIT_TAG(exception_commit_tag),
		.oCOREINFO_FREE_ADDR_SET(exception_addr_set),
		.oCOREINFO_FREE_ADDR(exception_addr),
		.oCOREINFO_FREE_RESTART(exception_restart),
		.oCOREINFO_FREE_CURRENT_PC(exception_current_pc),
		.oCOREINFO_FREE_SET_IRQ_MODE(exception2scheduler2_irq_reqister_set),
		.oCOREINFO_FREE_CLR_IRQ_MODE(exception2scheduler2_irq_reqister_ret),
		.oCOREINFO_FREE_NEW_SPR_VALID(exception2alu0_new_spr_valid),
		.oCOREINFO_FREE_NEW_SPR(exception2alu0_new_spr),
		//Order
		.oCOREINFO_MCODE0_VALID(),
		.oCOREINFO_MCODE0(),
		.oCOREINFO_MCODE1_VALID(),
		.oCOREINFO_MCODE1(),
		.iCODEINFO_MCODE_LOCK(1'b0),	//damy
		//System Register
		.iCOREINFO_SYSREG_IDTR(wire_sysreg_idtr),
		.iCOREINFO_SYSREG_TISR(wire_sysreg_tisr),
		.iCOREINFO_SYSREG_TIDR(wire_sysreg_tidr),
		.iCOREINFO_SYSREG_PSR(wire_sysreg_psr),
		.iCOREINFO_SYSREG_PPSR(wire_sysreg_ppsr),
		.iCOREINFO_SYSREG_PPCR(wire_sysreg_ppcr),
		.iCOREINFO_SYSREG_SPR(wire_sysreg_spr),
		//Load Store 
		.oLDST_USE(exception2ldst_ldst_use),
		.oLDST_REQ(exception2ldst_ldst_req),
		.iLDST_BUSY(ldst2exception_ldst_busy),
		.oLDST_ORDER(exception2ldst_ldst_order),
		.oLDST_RW(exception2ldst_ldst_rw),	
		.oLDST_TID(exception2ldst_ldst_tid),
		.oLDST_MMUMOD(exception2ldst_ldst_mmumod),
		.oLDST_PDT(exception2ldst_ldst_pdt),
		.oLDST_ADDR(exception2ldst_ldst_addr),
		.oLDST_DATA(exception2ldst_ldst_data),
		.iLDST_REQ(ldst2exception_ldst_req),
		.iLDST_DATA(ldst2exception_ldst_data),		
		//GCI Interrupt Configlation Table
		.oIO_IRQ_CONFIG_TABLE_REQ(oIO_IRQ_CONFIG_TABLE_REQ),
		.oIO_IRQ_CONFIG_TABLE_ENTRY(oIO_IRQ_CONFIG_TABLE_ENTRY),
		.oIO_IRQ_CONFIG_TABLE_FLAG_MASK(oIO_IRQ_CONFIG_TABLE_FLAG_MASK),
		.oIO_IRQ_CONFIG_TABLE_FLAG_VALID(oIO_IRQ_CONFIG_TABLE_FLAG_VALID),	
		.oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL(oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL),	
		//Core Interrupt Configlation Table
		.oICT_REQ(exception2cim_ict_req),
		.oICT_ENTRY(exception2cim_ict_entry),
		.oICT_CONF_MASK(exception2cim_ict_conf_mask),
		.oICT_CONF_VALID(exception2cim_ict_conf_valid),	
		.oICT_CONF_LEVEL(exception2cim_ict_conf_level),	
		/*********************************
		Exeption Source
		*********************************/
		//ALU Branch
		.iALU_BRANCH_REQ(jump_active),
		.iALU_BRANCH_ADDR(jump_addr),
		.iALU_BRANCH_COMMIT_TAG(ex_alu02scheduler1_branch_commit_tag),
		//Int ret
		.iALU_INTRET_REQ(ex_alu02exception_intr_active),
		.iALU_INTRET_ADDR(ex_alu02exception_intr_addr),
		.iALU_INTRET_COMMIT_TAG(ex_alu02scheduler1_branch_commit_tag),
		//IDT Set
		.iIDT_SET_REQ(ex_alu02exception_idts_active),
		.iIDT_SET_R_ADDR(ex_alu02exception_idts_r_addr),
		.iIDT_SET_COMMIT_TAG(ex_alu02exception_idts_commit_tag),
		.iIDT_SET_IDTR(wire_sysreg_idtr),
		//Hardware Task Switch
		.iHW_TS_REQ(1'b0),
		.iHW_TS_ADDR({32{1'b0}}),
		.oHW_TS_BUSY(),
		//IRQ Branch
		.iIRQ_REQ(cim2exception_irq_req),
		.iIRQ_NUM(cim2exception_irq_num),
		.oIRQ_ACK(exception2cim_irq_ack),
		.oIRQ_BUSY(exception2cim_irq_lock)
	);
	

	
	/****************************************
	Stage : 0
	Instruction Cache
	****************************************/
	l1_instruction_cache STAGE0_L1_INST(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Remove
		.iREMOVE(exception_event),
		.iCACHE_FLASH(1'b0),
		/****************************************
		Memory Port Memory
		****************************************/
		//Req
		.oINST_REQ(oINST_REQ),
		.iINST_LOCK(iINST_LOCK),
		.oINST_MMUMOD(oINST_MMUMOD),
		.oINST_ADDR(oINST_ADDR),
		//Mem
		.iINST_VALID(iINST_VALID),
		.oINST_BUSY(oINST_BUSY),
		.iINST_PAGEFAULT(iINST_PAGEFAULT),
		.iINST_DATA(iINST_DATA),
		.iINST_MMU_FLAGS(iINST_MMU_FLAGS),
		/****************************************
		Fetch Module
		****************************************/
		//From Fetch
		.iNEXT_FETCH_REQ(fetch2icache_inst_req),
		.oNEXT_FETCH_LOCK(icache2fetch_inst_busy),
		.iNEXT_MMUMOD(2'h0),
		.iNEXT_FETCH_ADDR(fetch2icache_inst_addr),
		//To Fetch
		.oNEXT_0_INST_VALID(icache2fetch_0_inst_valid),
		.oNEXT_0_PAGEFAULT(/*icache2fetch_0_inst_pagefault*/),		
		.oNEXT_0_MMU_FLAGS(icache2fetch_0_inst_mmuflags),
		.oNEXT_0_INST(icache2fetch_0_inst_inst),
		.oNEXT_1_INST_VALID(icache2fetch_1_inst_valid),
		.oNEXT_1_PAGEFAULT(/*icache2fetch_1_inst_pagefault*/),	
		.oNEXT_1_MMU_FLAGS(icache2fetch_1_inst_mmuflags),
		.oNEXT_1_INST(icache2fetch_1_inst_inst),
		.iNEXT_LOCK(fetch2icache_inst_busy)
	);


	
	/****************************************
	Stage : 1
	Instruction Fetch Unit
	****************************************/
	fetch STAGE1_FETCH(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),
		//Exception
		.iEXCEPTION_INST_DISCARD(exception_inst_discard),
		.iEXCEPTION_EVENT(exception_event), 
		.iEXCEPTION_ADDR_SET(exception_addr_set),
		.iEXCEPTION_ADDR(exception_addr),
		.iEXCEPTION_RESTART(exception_restart),
		//Fetch Stop
		.iFETCH_STOP_LOOPBUFFER_LIMIT(matching2fetch_loopbuffer_limit),
		//Input Instruction
		.iPREVIOUS_0_INST_VALID(icache2fetch_0_inst_valid),
		.iPREVIOUS_0_MMU_FLAGS(icache2fetch_0_inst_mmuflags),
		.iPREVIOUS_0_INST(icache2fetch_0_inst_inst), 
		.iPREVIOUS_1_INST_VALID(icache2fetch_1_inst_valid), 
		.iPREVIOUS_1_MMU_FLAGS(icache2fetch_1_inst_mmuflags),
		.iPREVIOUS_1_INST(icache2fetch_1_inst_inst),
		.oPREVIOUS_LOCK(fetch2icache_inst_busy),
		//Req Instruction
		.oPREVIOUS_FETCH_REQ(fetch2icache_inst_req), 
		.oPREVIOUS_FETCH_ADDR(fetch2icache_inst_addr), 
		.iPREVIOUS_FETCH_LOCK(icache2fetch_inst_busy),
		//Next Unit
		.oNEXT_0_INST_VALID(fetch2decoder_0_inst_valid), 
		.oNEXT_0_MMU_FLAGS(fetch2decoder_0_mmu_flags),
		.oNEXT_0_INST(fetch2decoder_0_inst), 
		.oNEXT_1_INST_VALID(fetch2decoder_1_inst_valid),  
		.oNEXT_1_MMU_FLAGS(fetch2decoder_1_mmu_flags),
		.oNEXT_1_INST(fetch2decoder_1_inst), 
		.oNEXT_PC(fetch2decoder_pc), 
		.iNEXT_LOCK(decoder2fetch_lock)
	);
	
	/****************************************
	Stage : 2
	Decoder Unit
	****************************************/
	assign decoder2matching_0_mmu_flags = 6'h0;
	assign decoder2matching_1_mmu_flags = 6'h0;

	decoder STAGE2_DECODER(
		//System
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),
		//Free
		.iRESET_SYNC(exception_event),
		//Previous
		/*
		.iPREVIOUS_0_INST_VALID(fetch2decoder_0_inst_valid), 
		.iPREVIOUS_0_MMU_FLAGS(fetch2decoder_0_mmu_flags),
		.iPREVIOUS_0_INST(fetch2decoder_0_inst), 
		.iPREVIOUS_1_INST_VALID(fetch2decoder_1_inst_valid), 
		.iPREVIOUS_1_MMU_FLAGS(fetch2decoder_1_mmu_flags),
		.iPREVIOUS_1_INST(fetch2decoder_1_inst), 
		.iPREVIOUS_PC(fetch2decoder_pc), 
		.oPREVIOUS_LOCK(decoder2fetch_lock),	
		*/
		.iPREVIOUS_COMMON_VALID(fetch2decoder_0_inst_valid),
		.iPREVIOUS_0_INST_VALID(fetch2decoder_0_inst_valid),
		.iPREVIOUS_0_PAGEFAULT(1'b0),
		.iPREVIOUS_0_PAGING_ENA(1'b0),
		.iPREVIOUS_0_KERNEL_ACCESS(1'b1),
		.iPREVIOUS_0_BRANCH_PREDICT(1'b0),
		.iPREVIOUS_0_BRANCH_PREDICT_ADDR(32'h0),
		.iPREVIOUS_0_INST(fetch2decoder_0_inst),
		.iPREVIOUS_1_INST_VALID(fetch2decoder_1_inst_valid),
		.iPREVIOUS_1_PAGEFAULT(1'b0),
		.iPREVIOUS_1_PAGING_ENA(1'b0),
		.iPREVIOUS_1_KERNEL_ACCESS(1'b1),
		.iPREVIOUS_1_BRANCH_PREDICT(1'b0),
		.iPREVIOUS_1_BRANCH_PREDICT_ADDR(32'h0),
		.iPREVIOUS_1_INST(fetch2decoder_1_inst),
		.iPREVIOUS_PC(fetch2decoder_pc),
		.oPREVIOUS_LOCK(decoder2fetch_lock),
		//Next
		.oNEXT_COMMON_VALID(decoder2matching_0_valid),
		.oNEXT_0_VALID(),//(decoder2matching_0_valid), 
		//.oNEXT_0_MMU_FLAGS(decoder2matching_0_mmu_flags),
		.oNEXT_0_SOURCE0_ACTIVE(decoder2matching_0_source0_active), 
		.oNEXT_0_SOURCE1_ACTIVE(decoder2matching_0_source1_active), 
		.oNEXT_0_SOURCE0_SYSREG(decoder2matching_0_source0_sysreg), 
		.oNEXT_0_SOURCE1_SYSREG(decoder2matching_0_source1_sysreg), 
		.oNEXT_0_SOURCE0_SYSREG_RENAME(decoder2matching_0_source0_sysreg_rename), 
		.oNEXT_0_SOURCE1_SYSREG_RENAME(decoder2matching_0_source1_sysreg_rename),
		.oNEXT_0_ADV_ACTIVE(decoder2matching_0_adv_active),	//++
		.oNEXT_0_DESTINATION_SYSREG(decoder2matching_0_destination_sysreg), 
		.oNEXT_0_DEST_RENAME(decoder2matching_0_dest_rename),
		.oNEXT_0_WRITEBACK(decoder2matching_0_writeback), 
		.oNEXT_0_FLAGS_WRITEBACK(decoder2mathsing_0_flags_writeback),
		.oNEXT_0_FRONT_COMMIT_WAIT(decoder2matching_0_front_commit_wait),
		.oNEXT_0_CMD(decoder2matching_0_cmd), 
		.oNEXT_0_CC_AFE(decoder2matching_0_cc_afe),
		.oNEXT_0_SOURCE0(decoder2matching_0_source0),
		.oNEXT_0_SOURCE1(decoder2matching_0_source1), 
		.oNEXT_0_ADV_DATA(decoder2matching_0_adv_data),	//++
		.oNEXT_0_SOURCE0_FLAGS(decoder2matching_0_source0_flags),
		.oNEXT_0_SOURCE1_IMM(decoder2matching_0_source1_imm),
		.oNEXT_0_DESTINATION(decoder2matching_0_destination), 
		.oNEXT_0_EX_SYS_REG(decoder2matching_0_sys_reg),
		.oNEXT_0_EX_SYS_LDST(decoder2matching_0_sys_ldst), 
		.oNEXT_0_EX_LOGIC(decoder2matching_0_logic), 
		.oNEXT_0_EX_SHIFT(decoder2matching_0_shift), 
		.oNEXT_0_EX_ADDER(decoder2matching_0_adder), 
		.oNEXT_0_EX_MUL(decoder2matching_0_mul), 
		.oNEXT_0_EX_SDIV(decoder2matching_0_sdiv), 
		.oNEXT_0_EX_UDIV(decoder2matching_0_udiv), 
		.oNEXT_0_EX_LDST(decoder2matching_0_ldst), 
		.oNEXT_0_EX_BRANCH(decoder2matching_0_branch),
		.oNEXT_1_VALID(decoder2matching_1_valid), 
		//.oNEXT_1_MMU_FLAGS(decoder2matching_1_mmu_flags),
		.oNEXT_1_SOURCE0_ACTIVE(decoder2matching_1_source0_active), 
		.oNEXT_1_SOURCE1_ACTIVE(decoder2matching_1_source1_active), 
		.oNEXT_1_SOURCE0_SYSREG(decoder2matching_1_source0_sysreg), 
		.oNEXT_1_SOURCE1_SYSREG(decoder2matching_1_source1_sysreg), 
		.oNEXT_1_SOURCE0_SYSREG_RENAME(decoder2matching_1_source0_sysreg_rename), 
		.oNEXT_1_SOURCE1_SYSREG_RENAME(decoder2matching_1_source1_sysreg_rename),
		.oNEXT_1_ADV_ACTIVE(decoder2matching_1_adv_active),	//++
		.oNEXT_1_DESTINATION_SYSREG(decoder2matching_1_destination_sysreg),
		.oNEXT_1_DEST_RENAME(decoder2matching_1_dest_rename), 
		.oNEXT_1_WRITEBACK(decoder2matching_1_writeback), 
		.oNEXT_1_FLAGS_WRITEBACK(decoder2mathsing_1_flags_writeback),
		.oNEXT_1_FRONT_COMMIT_WAIT(decoder2matching_1_front_commit_wait),
		.oNEXT_1_CMD(decoder2matching_1_cmd), 
		.oNEXT_1_CC_AFE(decoder2matching_1_cc_afe),
		.oNEXT_1_SOURCE0(decoder2matching_1_source0), 
		.oNEXT_1_SOURCE1(decoder2matching_1_source1), 
		.oNEXT_1_ADV_DATA(decoder2matching_1_adv_data),	//++
		.oNEXT_1_SOURCE0_FLAGS(decoder2matching_1_source0_flags),
		.oNEXT_1_SOURCE1_IMM(decoder2matching_1_source1_imm),
		.oNEXT_1_DESTINATION(decoder2matching_1_destination), 
		.oNEXT_1_EX_SYS_REG(decoder2matching_1_sys_reg),
		.oNEXT_1_EX_SYS_LDST(decoder2matching_1_sys_ldst), 
		.oNEXT_1_EX_LOGIC(decoder2matching_1_logic), 
		.oNEXT_1_EX_SHIFT(decoder2matching_1_shift), 
		.oNEXT_1_EX_ADDER(decoder2matching_1_adder), 
		.oNEXT_1_EX_MUL(decoder2matching_1_mul), 
		.oNEXT_1_EX_SDIV(decoder2matching_1_sdiv), 
		.oNEXT_1_EX_UDIV(decoder2matching_1_udiv), 
		.oNEXT_1_EX_LDST(decoder2matching_1_ldst), 
		.oNEXT_1_EX_BRANCH(decoder2matching_1_branch), 
		.oNEXT_PC(decoder2matching_pc), 
		.iNEXT_LOCK(matching2decoder_lock)
	);
						
	
	/****************************************
	Stage : 3
	Matching Unit
	****************************************/
	matching SATGE3_MATCHING(
		//System
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),
		//Free
		.iFREE_DEFAULT(exception_event),
		.iFREE_RESTART(exception_restart),
		//Commit OFFSET
		.iCOMMIT_OFFSET(commit_offset),
		//Instruction Fetch Stop
		.oLOOPBUFFER_LIMIT(matching2fetch_loopbuffer_limit),
		.iOTHER_INFO_RENAME_0_VALID(stage_info_renaming_0_valid), 
		.iOTHER_INFO_RENAME_1_VALID(stage_info_renaming_1_valid),
		.iOTHER_INFO_SCHEDULER1_0_VALID(stage_info_scheduler1_0_valid), 
		.iOTHER_INFO_SCHEDULER1_1_VALID(stage_info_scheduler1_1_valid),
		.iOTHER_INFO_SCHEDULER1_REGIST_POINTER(stage_info_scheduler1_regist_pointer), 
		.iOTHER_INFO_SCHEDULER1_COMMIT_POINTER(stage_info_scheduler1_commit_pointer),
		//Prev
		.iPREVIOUS_0_VALID(decoder2matching_0_valid), 
		.iPREVIOUS_0_MMU_FLAGS(decoder2matching_0_mmu_flags),
		.iPREVIOUS_0_SOURCE0_ACTIVE(decoder2matching_0_source0_active), 
		.iPREVIOUS_0_SOURCE1_ACTIVE(decoder2matching_0_source1_active), 
		.iPREVIOUS_0_SOURCE0_SYSREG(decoder2matching_0_source0_sysreg), 
		.iPREVIOUS_0_SOURCE1_SYSREG(decoder2matching_0_source1_sysreg), 
		.iPREVIOUS_0_SOURCE0_SYSREG_RENAME(decoder2matching_0_source0_sysreg_rename), 
		.iPREVIOUS_0_SOURCE1_SYSREG_RENAME(decoder2matching_0_source1_sysreg_rename), 
		.iPREVIOUS_0_ADV_ACTIVE(decoder2matching_0_adv_active),	//++
		.iPREVIOUS_0_DESTINATION_SYSREG(decoder2matching_0_destination_sysreg), 
		.iPREVIOUS_0_DEST_RENAME(decoder2matching_0_dest_rename),
		.iPREVIOUS_0_WRITEBACK(decoder2matching_0_writeback), 
		.iPREVIOUS_0_FLAGS_WRITEBACK(decoder2mathsing_0_flags_writeback),
		.iPREVIOUS_0_FRONT_COMMIT_WAIT(decoder2matching_0_front_commit_wait),
		.iPREVIOUS_0_CMD(decoder2matching_0_cmd), 
		.iPREVIOUS_0_CC_AFE(decoder2matching_0_cc_afe), 
		.iPREVIOUS_0_SOURCE0(decoder2matching_0_source0),
		.iPREVIOUS_0_SOURCE1(decoder2matching_0_source1), 
		.iPREVIOUS_0_ADV_DATA(decoder2matching_0_adv_data),	//++
		.iPREVIOUS_0_SOURCE0_FLAGS(decoder2matching_0_source0_flags),
		.iPREVIOUS_0_SOURCE1_IMM(decoder2matching_0_source1_imm),
		.iPREVIOUS_0_DESTINATION(decoder2matching_0_destination), 
		.iPREVIOUS_0_EX_SYS_ADDER(decoder2matching_0_sys_reg),
		.iPREVIOUS_0_EX_SYS_LDST(decoder2matching_0_sys_ldst), 
		.iPREVIOUS_0_EX_LOGIC(decoder2matching_0_logic), 
		.iPREVIOUS_0_EX_SHIFT(decoder2matching_0_shift), 
		.iPREVIOUS_0_EX_ADDER(decoder2matching_0_adder), 
		.iPREVIOUS_0_EX_MUL(decoder2matching_0_mul), 
		.iPREVIOUS_0_EX_SDIV(decoder2matching_0_sdiv), 
		.iPREVIOUS_0_EX_UDIV(decoder2matching_0_udiv),  
		.iPREVIOUS_0_EX_LDST(decoder2matching_0_ldst), 
		.iPREVIOUS_0_EX_BRANCH(decoder2matching_0_branch),
		.iPREVIOUS_1_VALID(decoder2matching_1_valid), 
		.iPREVIOUS_1_MMU_FLAGS(decoder2matching_1_mmu_flags),
		.iPREVIOUS_1_SOURCE0_ACTIVE(decoder2matching_1_source0_active), 
		.iPREVIOUS_1_SOURCE1_ACTIVE(decoder2matching_1_source1_active), 
		.iPREVIOUS_1_SOURCE0_SYSREG(decoder2matching_1_source0_sysreg), 
		.iPREVIOUS_1_SOURCE1_SYSREG(decoder2matching_1_source1_sysreg), 
		.iPREVIOUS_1_SOURCE0_SYSREG_RENAME(decoder2matching_1_source0_sysreg_rename), 
		.iPREVIOUS_1_SOURCE1_SYSREG_RENAME(decoder2matching_1_source1_sysreg_rename), 
		.iPREVIOUS_1_ADV_ACTIVE(decoder2matching_1_adv_active),	//++
		.iPREVIOUS_1_DESTINATION_SYSREG(decoder2matching_1_destination_sysreg), 
		.iPREVIOUS_1_DEST_RENAME(decoder2matching_1_dest_rename),
		.iPREVIOUS_1_WRITEBACK(decoder2matching_1_writeback), 
		.iPREVIOUS_1_FLAGS_WRITEBACK(decoder2mathsing_1_flags_writeback),
		.iPREVIOUS_1_FRONT_COMMIT_WAIT(decoder2matching_1_front_commit_wait),
		.iPREVIOUS_1_CMD(decoder2matching_1_cmd), 
		.iPREVIOUS_1_CC_AFE(decoder2matching_1_cc_afe), 
		.iPREVIOUS_1_SOURCE0(decoder2matching_1_source0),
		.iPREVIOUS_1_SOURCE1(decoder2matching_1_source1), 
		.iPREVIOUS_1_ADV_DATA(decoder2matching_1_adv_data),	//++
		.iPREVIOUS_1_SOURCE0_FLAGS(decoder2matching_1_source0_flags),
		.iPREVIOUS_1_SOURCE1_IMM(decoder2matching_1_source1_imm),
		.iPREVIOUS_1_DESTINATION(decoder2matching_1_destination), 
		.iPREVIOUS_1_EX_SYS_ADDER(decoder2matching_1_sys_reg),
		.iPREVIOUS_1_EX_SYS_LDST(decoder2matching_1_sys_ldst), 
		.iPREVIOUS_1_EX_LOGIC(decoder2matching_1_logic), 
		.iPREVIOUS_1_EX_SHIFT(decoder2matching_1_shift), 
		.iPREVIOUS_1_EX_ADDER(decoder2matching_1_adder), 
		.iPREVIOUS_1_EX_MUL(decoder2matching_1_mul), 
		.iPREVIOUS_1_EX_SDIV(decoder2matching_1_sdiv), 
		.iPREVIOUS_1_EX_UDIV(decoder2matching_1_udiv), 
		.iPREVIOUS_1_EX_LDST(decoder2matching_1_ldst), 
		.iPREVIOUS_1_EX_BRANCH(decoder2matching_1_branch), 
		.iPREVIOUS_PC(decoder2matching_pc), 
		.oPREVIOUS_LOCK(matching2decoder_lock),
		//Next
		.oNEXT_0_VALID(matching2renaming_0_valid), 
		.oNEXT_0_SOURCE0_ACTIVE(matching2renaming_0_source0_active), 
		.oNEXT_0_SOURCE1_ACTIVE(matching2renaming_0_source1_active), 
		.oNEXT_0_SOURCE0_SYSREG(matching2renaming_0_source0_sysreg),  
		.oNEXT_0_SOURCE1_SYSREG(matching2renaming_0_source1_sysreg), 
		.oNEXT_0_SOURCE0_SYSREG_RENAME(matching2renaming_0_source0_sysreg_rename), 
		.oNEXT_0_SOURCE1_SYSREG_RENAME(matching2renaming_0_source1_sysreg_rename), 
		.oNEXT_0_ADV_ACTIVE(matching2renaming_0_adv_active),		//++
		.oNEXT_0_DESTINATION_SYSREG(matching2renaming_0_destination_sysreg), 
		.oNEXT_0_DEST_RENAME(matching2renaming_0_dest_rename),
		.oNEXT_0_WRITEBACK(matching2renaming_0_writeback), 
		.oNEXT_0_FLAGS_WRITEBACK(matching2renaming_0_flags_writeback),
		.oNEXT_0_CMD(matching2renaming_0_cmd), 
		.oNEXT_0_CC_AFE(matching2renaming_0_cc_afe), 
		.oNEXT_0_SOURCE0(matching2renaming_0_source0),
		.oNEXT_0_SOURCE1(matching2renaming_0_source1), 
		.oNEXT_0_ADV_DATA(matching2renaming_0_adv_data),		//++
		.oNEXT_0_SOURCE0_FLAGS(matching2renaming_0_source0_flags),
		.oNEXT_0_SOURCE1_IMM(matching2renaming_0_source1_imm),
		.oNEXT_0_DESTINATION(matching2renaming_0_destination), 
		.oNEXT_0_EX_SYS_ADDER(matching2renaming_0_sys_adder),
		.oNEXT_0_EX_SYS_LDST(matching2renaming_0_sys_ldst), 
		.oNEXT_0_EX_LOGIC(matching2renaming_0_logic), 
		.oNEXT_0_EX_SHIFT(matching2renaming_0_shift), 
		.oNEXT_0_EX_ADDER(matching2renaming_0_adder), 
		.oNEXT_0_EX_MUL(matching2renaming_0_mul), 
		.oNEXT_0_EX_SDIV(matching2renaming_0_sdiv), 
		.oNEXT_0_EX_UDIV(matching2renaming_0_udiv), 
		.oNEXT_0_EX_LDST(matching2renaming_0_ldst), 
		.oNEXT_0_EX_BRANCH(matching2renaming_0_branch),
		.oNEXT_1_VALID(matching2renaming_1_valid), 
		.oNEXT_1_SOURCE0_ACTIVE(matching2renaming_1_source0_active), 
		.oNEXT_1_SOURCE1_ACTIVE(matching2renaming_1_source1_active), 
		.oNEXT_1_SOURCE0_SYSREG(matching2renaming_1_source0_sysreg), 
		.oNEXT_1_SOURCE1_SYSREG(matching2renaming_1_source1_sysreg), 
		.oNEXT_1_SOURCE0_SYSREG_RENAME(matching2renaming_1_source0_sysreg_rename), 
		.oNEXT_1_SOURCE1_SYSREG_RENAME(matching2renaming_1_source1_sysreg_rename), 
		.oNEXT_1_ADV_ACTIVE(matching2renaming_1_adv_active),		//++
		.oNEXT_1_DESTINATION_SYSREG(matching2renaming_1_destination_sysreg), 
		.oNEXT_1_DEST_RENAME(matching2renaming_1_dest_rename),
		.oNEXT_1_WRITEBACK(matching2renaming_1_writeback), 
		.oNEXT_1_FLAGS_WRITEBACK(matching2renaming_1_flags_writeback),
		.oNEXT_1_CMD(matching2renaming_1_cmd), 
		.oNEXT_1_CC_AFE(matching2renaming_1_cc_afe), 
		.oNEXT_1_SOURCE0(matching2renaming_1_source0),
		.oNEXT_1_SOURCE1(matching2renaming_1_source1), 
		.oNEXT_1_ADV_DATA(matching2renaming_1_adv_data),		//++
		.oNEXT_1_SOURCE0_FLAGS(matching2renaming_1_source0_flags),
		.oNEXT_1_SOURCE1_IMM(matching2renaming_1_source1_imm),
		.oNEXT_1_DESTINATION(matching2renaming_1_destination), 
		.oNEXT_1_EX_SYS_ADDER(matching2renaming_1_sys_adder),
		.oNEXT_1_EX_SYS_LDST(matching2renaming_1_sys_ldst), 
		.oNEXT_1_EX_LOGIC(matching2renaming_1_logic), 
		.oNEXT_1_EX_SHIFT(matching2renaming_1_shift), 
		.oNEXT_1_EX_ADDER(matching2renaming_1_adder), 
		.oNEXT_1_EX_MUL(matching2renaming_1_mul), 
		.oNEXT_1_EX_SDIV(matching2renaming_1_sdiv), 
		.oNEXT_1_EX_UDIV(matching2renaming_1_udiv), 
		.oNEXT_1_EX_LDST(matching2renaming_1_ldst), 
		.oNEXT_1_EX_BRANCH(matching2renaming_1_branch), 
		.oNEXT_PC(matching2renaming_pc), 
		.iNEXT_LOCK(renaming2matching_lock)
	);
							
	/****************************************
	Stage : 4
	Rename Unit
	****************************************/
	rename SATGE4_RENAME(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iFREE_DEFAULT(exception_event), .iFREE_RESTART(exception_restart),
		.iROLLBACK_UPDATE_CANDIDATE0_VALID(scheduler12renaming_rollback_update_info0_valid), 
		.iROLLBACK_UPDATE_CANDIDATE0_LREGNAME(scheduler12renaming_rollback_update_info0_lregname), 
		.iROLLBACK_UPDATE_CANDIDATE0_PREGNAME(scheduler12renaming_rollback_update_info0_pregname), 
		.iROLLBACK_UPDATE_CANDIDATE0_SYSREG(scheduler12renaming_rollback_update_info0_sysreg),
		.iROLLBACK_UPDATE_CANDIDATE1_VALID(scheduler12renaming_rollback_update_info1_valid), 
		.iROLLBACK_UPDATE_CANDIDATE1_LREGNAME(scheduler12renaming_rollback_update_info1_lregname), 
		.iROLLBACK_UPDATE_CANDIDATE1_PREGNAME(scheduler12renaming_rollback_update_info1_pregname), 
		.iROLLBACK_UPDATE_CANDIDATE1_SYSREG(scheduler12renaming_rollback_update_info1_sysreg),
		.iROLLBACK_UPDATE_CANDIDATE2_VALID(scheduler12renaming_rollback_update_info2_valid), 
		.iROLLBACK_UPDATE_CANDIDATE2_LREGNAME(scheduler12renaming_rollback_update_info2_lregname), 
		.iROLLBACK_UPDATE_CANDIDATE2_PREGNAME(scheduler12renaming_rollback_update_info2_pregname), 
		.iROLLBACK_UPDATE_CANDIDATE2_SYSREG(scheduler12renaming_rollback_update_info2_sysreg),
		.iROLLBACK_UPDATE_CANDIDATE3_VALID(scheduler12renaming_rollback_update_info3_valid), 
		.iROLLBACK_UPDATE_CANDIDATE3_LREGNAME(scheduler12renaming_rollback_update_info3_lregname), 
		.iROLLBACK_UPDATE_CANDIDATE3_PREGNAME(scheduler12renaming_rollback_update_info3_pregname), 
		.iROLLBACK_UPDATE_CANDIDATE3_SYSREG(scheduler12renaming_rollback_update_info3_sysreg),
		.iFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_VALID(scheduler12renaming_flags_rollback_update_info0_valid),
		.iFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_PREGNAME(scheduler12renaming_flags_rollback_update_info0_pregname),
		.iFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_VALID(scheduler12renaming_flags_rollback_update_info1_valid),
		.iFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_PREGNAME(scheduler12renaming_flags_rollback_update_info1_pregname),
		.iFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_VALID(scheduler12renaming_flags_rollback_update_info2_valid),
		.iFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_PREGNAME(scheduler12renaming_flags_rollback_update_info2_pregname),
		.iFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_VALID(scheduler12renaming_flags_rollback_update_info3_valid),
		.iFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_PREGNAME(scheduler12renaming_flags_rollback_update_info3_pregname),
		.oSTAGE_INFO_0_VALID(stage_info_renaming_0_valid), 
		.oSTAGE_INFO_1_VALID(stage_info_renaming_1_valid), 
		.iPREVIOUS_0_VALID(matching2renaming_0_valid), 
		.iPREVIOUS_0_SOURCE0_ACTIVE(matching2renaming_0_source0_active), 
		.iPREVIOUS_0_SOURCE1_ACTIVE(matching2renaming_0_source1_active), 
		.iPREVIOUS_0_SOURCE0_SYSREG(matching2renaming_0_source0_sysreg), 
		.iPREVIOUS_0_SOURCE1_SYSREG(matching2renaming_0_source1_sysreg), 
		.iPREVIOUS_0_SOURCE0_SYSREG_RENAME(matching2renaming_0_source0_sysreg_rename), 
		.iPREVIOUS_0_SOURCE1_SYSREG_RENAME(matching2renaming_0_source1_sysreg_rename), 
		.iPREVIOUS_0_ADV_ACTIVE(matching2renaming_0_adv_active),
		.iPREVIOUS_0_DESTINATION_SYSREG(matching2renaming_0_destination_sysreg), 
		.iPREVIOUS_0_DEST_RENAME(matching2renaming_0_dest_rename),
		.iPREVIOUS_0_WRITEBACK(matching2renaming_0_writeback), 
		.iPREVIOUS_0_FLAGS_WRITEBACK(matching2renaming_0_flags_writeback),
		.iPREVIOUS_0_CMD(matching2renaming_0_cmd), 
		.iPREVIOUS_0_CC_AFE(matching2renaming_0_cc_afe), 
		.iPREVIOUS_0_SOURCE1(matching2renaming_0_source1), 
		.iPREVIOUS_0_SOURCE0(matching2renaming_0_source0),
		.iPREVIOUS_0_ADV_DATA(matching2renaming_0_adv_data),
		.iPREVIOUS_0_SOURCE0_FLAGS(matching2renaming_0_source0_flags),
		.iPREVIOUS_0_SOURCE1_IMM(matching2renaming_0_source1_imm), 
		.iPREVIOUS_0_DESTINATION(matching2renaming_0_destination), 
		.iPREVIOUS_0_EX_SYS_ADDER(matching2renaming_0_sys_adder), 
		.iPREVIOUS_0_EX_SYS_LDST(matching2renaming_0_sys_ldst), 
		.iPREVIOUS_0_EX_LOGIC(matching2renaming_0_logic), 
		.iPREVIOUS_0_EX_SHIFT(matching2renaming_0_shift), 
		.iPREVIOUS_0_EX_ADDER(matching2renaming_0_adder), 
		.iPREVIOUS_0_EX_MUL(matching2renaming_0_mul),
		.iPREVIOUS_0_EX_SDIV(matching2renaming_0_sdiv), 
		.iPREVIOUS_0_EX_UDIV(matching2renaming_0_udiv),
		.iPREVIOUS_0_EX_LDST(matching2renaming_0_ldst), 
		.iPREVIOUS_0_EX_BRANCH(matching2renaming_0_branch),
		.iPREVIOUS_1_VALID(matching2renaming_1_valid), 
		.iPREVIOUS_1_SOURCE0_ACTIVE(matching2renaming_1_source0_active), 
		.iPREVIOUS_1_SOURCE1_ACTIVE(matching2renaming_1_source1_active), 
		.iPREVIOUS_1_SOURCE0_SYSREG(matching2renaming_1_source0_sysreg), 
		.iPREVIOUS_1_SOURCE1_SYSREG(matching2renaming_1_source1_sysreg), 
		.iPREVIOUS_1_SOURCE0_SYSREG_RENAME(matching2renaming_1_source0_sysreg_rename), 
		.iPREVIOUS_1_SOURCE1_SYSREG_RENAME(matching2renaming_1_source1_sysreg_rename), 
		.iPREVIOUS_1_ADV_ACTIVE(matching2renaming_1_adv_active),
		.iPREVIOUS_1_DESTINATION_SYSREG(matching2renaming_1_destination_sysreg), 
		.iPREVIOUS_1_DEST_RENAME(matching2renaming_1_dest_rename),
		.iPREVIOUS_1_WRITEBACK(matching2renaming_1_writeback), 
		.iPREVIOUS_1_FLAGS_WRITEBACK(matching2renaming_1_flags_writeback),
		.iPREVIOUS_1_CMD(matching2renaming_1_cmd), 
		.iPREVIOUS_1_CC_AFE(matching2renaming_1_cc_afe), 
		.iPREVIOUS_1_SOURCE0(matching2renaming_1_source0),
		.iPREVIOUS_1_SOURCE1(matching2renaming_1_source1), 
		.iPREVIOUS_1_ADV_DATA(matching2renaming_1_adv_data),
		.iPREVIOUS_1_SOURCE0_FLAGS(matching2renaming_1_source0_flags),
		.iPREVIOUS_1_SOURCE1_IMM(matching2renaming_1_source1_imm), 
		.iPREVIOUS_1_DESTINATION(matching2renaming_1_destination),
		.iPREVIOUS_1_EX_SYS_ADDER(matching2renaming_1_sys_adder), 
		.iPREVIOUS_1_EX_SYS_LDST(matching2renaming_1_sys_ldst),
		.iPREVIOUS_1_EX_LOGIC(matching2renaming_1_logic), 
		.iPREVIOUS_1_EX_SHIFT(matching2renaming_1_shift), 
		.iPREVIOUS_1_EX_ADDER(matching2renaming_1_adder), 
		.iPREVIOUS_1_EX_MUL(matching2renaming_1_mul),
		.iPREVIOUS_1_EX_SDIV(matching2renaming_1_sdiv), 
		.iPREVIOUS_1_EX_UDIV(matching2renaming_1_udiv), 
		.iPREVIOUS_1_EX_LDST(matching2renaming_1_ldst), 
		.iPREVIOUS_1_EX_BRANCH(matching2renaming_1_branch),
		.iPREVIOUS_PC(matching2renaming_pc), 
		.oPREVIOUS_LOCK(renaming2matching_lock),
		//Register
		.oFLAG_REGISTER_0_RD(freereg_renaming2scheduler1_flag0_rd), 
		.iFLAG_REGISTER_0_NUM(freereg_renaming2scheduler1_flag0_num), 
		.iFLAG_REGISTER_0_EMPTY(freereg_renaming2scheduler1_flag0_empty),
		.oFLAG_REGISTER_1_RD(freereg_renaming2scheduler1_flag1_rd), 
		.iFLAG_REGISTER_1_NUM(freereg_renaming2scheduler1_flag1_num), 
		.iFLAG_REGISTER_1_EMPTY(freereg_renaming2scheduler1_flag1_empty),
		.oOTHER_REGISTER_0_RD(freereg_renaming2scheduler1_other0_rd), 
		.iOTHER_REGISTER_0_NUM(freereg_renaming2scheduler1_other0_num), 
		.iOTHER_REGISTER_0_EMPTY(freereg_renaming2scheduler1_other0_empty),
		.oOTHER_REGISTER_1_RD(freereg_renaming2scheduler1_other1_rd), 
		.iOTHER_REGISTER_1_NUM(freereg_renaming2scheduler1_other1_num), 
		.iOTHER_REGISTER_1_EMPTY(freereg_renaming2scheduler1_other1_empty),
		.oNEXT_0_VALID(renaming2scheduler1_0_valid), 
		.oNEXT_0_SOURCE0_ACTIVE(renaming2scheduler1_0_source0_active), 
		.oNEXT_0_SOURCE1_ACTIVE(renaming2scheduler1_0_source1_active), 
		.oNEXT_0_SOURCE0_SYSREG(renaming2scheduler1_0_source0_sysreg), 
		.oNEXT_0_SOURCE1_SYSREG(renaming2scheduler1_0_source1_sysreg), 
		.oNEXT_0_SOURCE0_SYSREG_RENAME(renaming2scheduler1_0_source0_sysreg_rename), 
		.oNEXT_0_SOURCE1_SYSREG_RENAME(renaming2scheduler1_0_source1_sysreg_rename),
		.oNEXT_0_ADV_ACTIVE(renaming2scheduler1_0_adv_active),		//++
		.oNEXT_0_DESTINATION_SYSREG(renaming2scheduler1_0_destination_sysreg), 
		.oNEXT_0_WRITEBACK(renaming2scheduler1_0_data_writeback), 
		.oNEXT_0_FLAGS_WRITEBACK(renaming2scheduler1_0_flags_writeback), 
		.oNEXT_0_CMD(renaming2scheduler1_0_cmd), 
		.oNEXT_0_CC_AFE(renaming2scheduler1_0_cc_afe), 
		.oNEXT_0_FLAGS_REGNAME(renaming2scheduler1_0_flags_regname),
		.oNEXT_0_DESTINATION_REGNAME(renaming2scheduler1_0_destination_regname), 
		.oNEXT_0_LOGIC_DESTINATION(renaming2scheduler1_0_logic_destination),
		.oNEXT_0_SOURCE0(renaming2scheduler1_0_source0), 
		.oNEXT_0_SOURCE1(renaming2scheduler1_0_source1), 
		.oNEXT_0_ADV_DATA(renaming2scheduler1_0_adv_data),		//++
		.oNEXT_0_SOURCE0_FLAGS(renaming2scheduler1_0_source0_flags),
		.oNEXT_0_SOURCE1_IMM(renaming2scheduler1_0_source1_imm), 
		.oNEXT_0_EX_SYS_ADDER(renaming2scheduler1_0_sys_adder),
		.oNEXT_0_EX_SYS_LDST(renaming2scheduler1_0_sys_ldst), 
		.oNEXT_0_EX_LOGIC(renaming2scheduler1_0_logic), 
		.oNEXT_0_EX_SHIFT(renaming2scheduler1_0_shift), 
		.oNEXT_0_EX_ADDER(renaming2scheduler1_0_adder), 
		.oNEXT_0_EX_MUL(renaming2scheduler1_0_mul), 
		.oNEXT_0_EX_SDIV(renaming2scheduler1_0_sdiv), 
		.oNEXT_0_EX_UDIV(renaming2scheduler1_0_udiv), 
		.oNEXT_0_EX_LDST(renaming2scheduler1_0_ldst), 
		.oNEXT_0_EX_BRANCH(renaming2scheduler1_0_branch),
		.oNEXT_1_VALID(renaming2scheduler1_1_valid), 
		.oNEXT_1_SOURCE0_ACTIVE(renaming2scheduler1_1_source0_active), 
		.oNEXT_1_SOURCE1_ACTIVE(renaming2scheduler1_1_source1_active), 
		.oNEXT_1_SOURCE0_SYSREG(renaming2scheduler1_1_source0_sysreg), 
		.oNEXT_1_SOURCE1_SYSREG(renaming2scheduler1_1_source1_sysreg), 
		.oNEXT_1_SOURCE0_SYSREG_RENAME(renaming2scheduler1_1_source0_sysreg_rename), 
		.oNEXT_1_SOURCE1_SYSREG_RENAME(renaming2scheduler1_1_source1_sysreg_rename),
		.oNEXT_1_ADV_ACTIVE(renaming2scheduler1_1_adv_active),		//++
		.oNEXT_1_DESTINATION_SYSREG(renaming2scheduler1_1_destination_sysreg), 
		.oNEXT_1_WRITEBACK(renaming2scheduler1_1_data_writeback), 
		.oNEXT_1_FLAGS_WRITEBACK(renaming2scheduler1_1_flags_writeback), 
		.oNEXT_1_CMD(renaming2scheduler1_1_cmd), 
		.oNEXT_1_CC_AFE(renaming2scheduler1_1_cc_afe), 
		.oNEXT_1_FLAGS_REGNAME(renaming2scheduler1_1_flags_regname),
		.oNEXT_1_DESTINATION_REGNAME(renaming2scheduler1_1_destination_regname), 
		.oNEXT_1_LOGIC_DESTINATION(renaming2scheduler1_1_logic_destination), 
		.oNEXT_1_SOURCE0(renaming2scheduler1_1_source0), 
		.oNEXT_1_SOURCE1(renaming2scheduler1_1_source1), 
		.oNEXT_1_ADV_DATA(renaming2scheduler1_1_adv_data),		//++
		.oNEXT_1_SOURCE0_FLAGS(renaming2scheduler1_1_source0_flags),
		.oNEXT_1_SOURCE1_IMM(renaming2scheduler1_1_source_imm), 
		.oNEXT_1_EX_SYS_ADDER(renaming2scheduler1_1_sys_adder),
		.oNEXT_1_EX_SYS_LDST(renaming2scheduler1_1_sys_ldst), 
		.oNEXT_1_EX_LOGIC(renaming2scheduler1_1_logic), 
		.oNEXT_1_EX_SHIFT(renaming2scheduler1_1_shift), 
		.oNEXT_1_EX_ADDER(renaming2scheduler1_1_adder), 
		.oNEXT_1_EX_MUL(renaming2scheduler1_1_mul), 
		.oNEXT_1_EX_SDIV(renaming2scheduler1_1_sdiv), 
		.oNEXT_1_EX_UDIV(renaming2scheduler1_1_udiv),
		.oNEXT_1_EX_LDST(renaming2scheduler1_1_ldst), 
		.oNEXT_1_EX_BRANCH(renaming2scheduler1_1_branch),
		.oNEXT_PC(renaming2scheduler1_pc), .iNEXT_LOCK(scheduler12renaming_lock)
	);
						
						
						
	/****************************************
	Stage : 5
	Scheduler1 Unit
	****************************************/
	scheduler1 SATGE5_SCHEDULER1(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		//IRQ
		.iIRQ_VALID(1'b0),
		//FREE
		.iEXCEPTION_EVENT(exception_event),
		.iEXCEPTION_COMMIT_TAG(exception_commit_tag),
		.iEXCEPTION_RESTART(exception_restart), 
		.oFREE_CURRENT_PC(current_execution_pc),
		.oFREE_REGISTER(free_register),
		//Commit
		.oINFO_COMMIT_COUNTER(commit_counter),
		.oINFO_EXCEPTION_PROTECT(exception_protect),
		//Rollback
		.oRENAME_ROLLBACK_UPDATE_INFO0_VALID(scheduler12renaming_rollback_update_info0_valid), 
		.oRENAME_ROLLBACK_UPDATE_INFO0_LREGNAME(scheduler12renaming_rollback_update_info0_lregname), 
		.oRENAME_ROLLBACK_UPDATE_INFO0_PREGNAME(scheduler12renaming_rollback_update_info0_pregname), 
		.oRENAME_ROLLBACK_UPDATE_INFO0_SYSREG(scheduler12renaming_rollback_update_info0_sysreg),
		.oRENAME_ROLLBACK_UPDATE_INFO1_VALID(scheduler12renaming_rollback_update_info1_valid), 
		.oRENAME_ROLLBACK_UPDATE_INFO1_LREGNAME(scheduler12renaming_rollback_update_info1_lregname), 
		.oRENAME_ROLLBACK_UPDATE_INFO1_PREGNAME(scheduler12renaming_rollback_update_info1_pregname), 
		.oRENAME_ROLLBACK_UPDATE_INFO1_SYSREG(scheduler12renaming_rollback_update_info1_sysreg),
		.oRENAME_ROLLBACK_UPDATE_INFO2_VALID(scheduler12renaming_rollback_update_info2_valid), 
		.oRENAME_ROLLBACK_UPDATE_INFO2_LREGNAME(scheduler12renaming_rollback_update_info2_lregname),
		.oRENAME_ROLLBACK_UPDATE_INFO2_PREGNAME(scheduler12renaming_rollback_update_info2_pregname), 
		.oRENAME_ROLLBACK_UPDATE_INFO2_SYSREG(scheduler12renaming_rollback_update_info2_sysreg),
		.oRENAME_ROLLBACK_UPDATE_INFO3_VALID(scheduler12renaming_rollback_update_info3_valid), 
		.oRENAME_ROLLBACK_UPDATE_INFO3_LREGNAME(scheduler12renaming_rollback_update_info3_lregname), 
		.oRENAME_ROLLBACK_UPDATE_INFO3_PREGNAME(scheduler12renaming_rollback_update_info3_pregname), 
		.oRENAME_ROLLBACK_UPDATE_INFO3_SYSREG(scheduler12renaming_rollback_update_info3_sysreg),
		.oFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_VALID(scheduler12renaming_flags_rollback_update_info0_valid),
		.oFLAGR_RENAME_ROLLBACK_UPDATE_INFO0_PREGNAME(scheduler12renaming_flags_rollback_update_info0_pregname),
		.oFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_VALID(scheduler12renaming_flags_rollback_update_info1_valid),
		.oFLAGR_RENAME_ROLLBACK_UPDATE_INFO1_PREGNAME(scheduler12renaming_flags_rollback_update_info1_pregname),
		.oFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_VALID(scheduler12renaming_flags_rollback_update_info2_valid),
		.oFLAGR_RENAME_ROLLBACK_UPDATE_INFO2_PREGNAME(scheduler12renaming_flags_rollback_update_info2_pregname),
		.oFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_VALID(scheduler12renaming_flags_rollback_update_info3_valid),
		.oFLAGR_RENAME_ROLLBACK_UPDATE_INFO3_PREGNAME(scheduler12renaming_flags_rollback_update_info3_pregname),
		.oCOMMIT_ENTRY_COMMIT_VECTOR(commit_vector), 
		.oCOMMIT_OFFSET(commit_offset),
		//Write Back
		.iSCHE1_EX_BRANCH_VALID(ex_alu02scheduler1_branch_valid), .iSCHE1_EX_BRANCH_COMMIT_TAG(ex_alu02scheduler1_branch_commit_tag),
		.iSCHE1_EX_ALU1_VALID(ex_alu12scheduler1_valid), .iSCHE1_EX_ALU1_COMMIT_TAG(ex_alu12scheduler1_commit_tag),
		.iSCHE1_EX_ALU2_VALID(ex_alu22scheduler1_valid), .iSCHE1_EX_ALU2_COMMIT_TAG(ex_alu22scheduler1_commit_tag), 
		.iSCHE1_EX_ALU3_VALID(ex_alu32scheduler1_ldst_valid), .iSCHE1_EX_ALU3_COMMIT_TAG(ex_alu32scheduler1_ldst_commit_tag),
		.oSTAGE_INFO_0_VALID(stage_info_scheduler1_0_valid), .oSTAGE_INFO_1_VALID(stage_info_scheduler1_1_valid), 
		.oSTAGE_INFO_REGIST_POINTER(stage_info_scheduler1_regist_pointer), .oSTAGE_INFO_COMMIT_POINTER(stage_info_scheduler1_commit_pointer),
		//Previous
		.iPREVIOUS_0_VALID(renaming2scheduler1_0_valid), 
		.iPREVIOUS_0_SOURCE0_ACTIVE(renaming2scheduler1_0_source0_active), 
		.iPREVIOUS_0_SOURCE1_ACTIVE(renaming2scheduler1_0_source1_active), 
		.iPREVIOUS_0_SOURCE0_SYSREG(renaming2scheduler1_0_source0_sysreg), 
		.iPREVIOUS_0_SOURCE1_SYSREG(renaming2scheduler1_0_source1_sysreg), 
		.iPREVIOUS_0_SOURCE0_SYSREG_RENAME(renaming2scheduler1_0_source0_sysreg_rename), 
		.iPREVIOUS_0_SOURCE1_SYSREG_RENAME(renaming2scheduler1_0_source1_sysreg_rename), 
		.iPREVIOUS_0_ADV_ACTIVE(renaming2scheduler1_0_adv_active),
		.iPREVIOUS_0_DESTINATION_SYSREG(renaming2scheduler1_0_destination_sysreg), 
		.iPREVIOUS_0_WRITEBACK(renaming2scheduler1_0_data_writeback), 
		.iPREVIOUS_0_FLAGS_WRITEBACK(renaming2scheduler1_0_flags_writeback), 
		.iPREVIOUS_0_CMD(renaming2scheduler1_0_cmd), 
		.iPREVIOUS_0_CC_AFE(renaming2scheduler1_0_cc_afe), 
		.iPREVIOUS_0_FLAGS_REGNAME(renaming2scheduler1_0_flags_regname),
		.iPREVIOUS_0_DESTINATION_REGNAME(renaming2scheduler1_0_destination_regname), 
		.iPREVIOUS_0_LOGIC_DESTINATION(renaming2scheduler1_0_logic_destination), 
		.iPREVIOUS_0_SOURCE0(renaming2scheduler1_0_source0), 
		.iPREVIOUS_0_SOURCE1(renaming2scheduler1_0_source1), 
		.iPREVIOUS_0_ADV_DATA(renaming2scheduler1_0_adv_data),
		.iPREVIOUS_0_SOURCE0_FLAGS(renaming2scheduler1_0_source0_flags),
		.iPREVIOUS_0_SOURCE1_IMM(renaming2scheduler1_0_source1_imm), 
		.iPREVIOUS_0_EX_SYS_ADDER(renaming2scheduler1_0_sys_adder),
		.iPREVIOUS_0_EX_SYS_LDST(renaming2scheduler1_0_sys_ldst), 
		.iPREVIOUS_0_EX_LOGIC(renaming2scheduler1_0_logic), 
		.iPREVIOUS_0_EX_SHIFT(renaming2scheduler1_0_shift), 
		.iPREVIOUS_0_EX_ADDER(renaming2scheduler1_0_adder), 
		.iPREVIOUS_0_EX_MUL(renaming2scheduler1_0_mul), 
		.iPREVIOUS_0_EX_SDIV(renaming2scheduler1_0_sdiv), 
		.iPREVIOUS_0_EX_UDIV(renaming2scheduler1_0_udiv), 
		.iPREVIOUS_0_EX_LDST(renaming2scheduler1_0_ldst), 
		.iPREVIOUS_0_EX_BRANCH(renaming2scheduler1_0_branch),
		.iPREVIOUS_1_VALID(renaming2scheduler1_1_valid), 
		.iPREVIOUS_1_SOURCE0_ACTIVE(renaming2scheduler1_1_source0_active), 
		.iPREVIOUS_1_SOURCE1_ACTIVE(renaming2scheduler1_1_source1_active), 
		.iPREVIOUS_1_SOURCE0_SYSREG(renaming2scheduler1_1_source0_sysreg), 
		.iPREVIOUS_1_SOURCE1_SYSREG(renaming2scheduler1_1_source1_sysreg), 
		.iPREVIOUS_1_SOURCE0_SYSREG_RENAME(renaming2scheduler1_1_source0_sysreg_rename), 
		.iPREVIOUS_1_SOURCE1_SYSREG_RENAME(renaming2scheduler1_1_source1_sysreg_rename), 
		.iPREVIOUS_1_ADV_ACTIVE(renaming2scheduler1_1_adv_active),
		.iPREVIOUS_1_DESTINATION_SYSREG(renaming2scheduler1_1_destination_sysreg), 
		.iPREVIOUS_1_WRITEBACK(renaming2scheduler1_1_data_writeback), 
		.iPREVIOUS_1_FLAGS_WRITEBACK(renaming2scheduler1_1_flags_writeback), 
		.iPREVIOUS_1_CMD(renaming2scheduler1_1_cmd), 
		.iPREVIOUS_1_CC_AFE(renaming2scheduler1_1_cc_afe), 
		.iPREVIOUS_1_FLAGS_REGNAME(renaming2scheduler1_1_flags_regname),
		.iPREVIOUS_1_DESTINATION_REGNAME(renaming2scheduler1_1_destination_regname), 
		.iPREVIOUS_1_LOGIC_DESTINATION(renaming2scheduler1_1_logic_destination),
		.iPREVIOUS_1_SOURCE0(renaming2scheduler1_1_source0), 
		.iPREVIOUS_1_SOURCE1(renaming2scheduler1_1_source1), 
		.iPREVIOUS_1_ADV_DATA(renaming2scheduler1_1_adv_data),
		.iPREVIOUS_1_SOURCE0_FLAGS(renaming2scheduler1_1_source0_flags),
		.iPREVIOUS_1_SOURCE1_IMM(renaming2scheduler1_1_source_imm), 
		.iPREVIOUS_1_EX_SYS_ADDER(renaming2scheduler1_1_sys_adder),
		.iPREVIOUS_1_EX_SYS_LDST(renaming2scheduler1_1_sys_ldst), 
		.iPREVIOUS_1_EX_LOGIC(renaming2scheduler1_1_logic), 
		.iPREVIOUS_1_EX_SHIFT(renaming2scheduler1_1_shift), 
		.iPREVIOUS_1_EX_ADDER(renaming2scheduler1_1_adder), 
		.iPREVIOUS_1_EX_MUL(renaming2scheduler1_1_mul), 
		.iPREVIOUS_1_EX_SDIV(renaming2scheduler1_1_sdiv), 
		.iPREVIOUS_1_EX_UDIV(renaming2scheduler1_1_udiv),
		.iPREVIOUS_1_EX_LDST(renaming2scheduler1_1_ldst), 
		.iPREVIOUS_1_EX_BRANCH(renaming2scheduler1_1_branch),
		.iPREVIOUS_PC(renaming2scheduler1_pc), 
		.oPREVIOUS_LOCK(scheduler12renaming_lock),
		//Freelist
		.iFLAG_REGISTER_0_RD(freereg_renaming2scheduler1_flag0_rd), 
		.oFLAG_REGISTER_0_NUM(freereg_renaming2scheduler1_flag0_num), 
		.oFLAG_REGISTER_0_EMPTY(freereg_renaming2scheduler1_flag0_empty),
		.iFLAG_REGISTER_1_RD(freereg_renaming2scheduler1_flag1_rd), 
		.oFLAG_REGISTER_1_NUM(freereg_renaming2scheduler1_flag1_num), 
		.oFLAG_REGISTER_1_EMPTY(freereg_renaming2scheduler1_flag1_empty),
		.iOTHER_REGISTER_0_RD(freereg_renaming2scheduler1_other0_rd), 
		.oOTHER_REGISTER_0_NUM(freereg_renaming2scheduler1_other0_num), 
		.oOTHER_REGISTER_0_EMPTY(freereg_renaming2scheduler1_other0_empty),
		.iOTHER_REGISTER_1_RD(freereg_renaming2scheduler1_other1_rd), 
		.oOTHER_REGISTER_1_NUM(freereg_renaming2scheduler1_other1_num), 
		.oOTHER_REGISTER_1_EMPTY(freereg_renaming2scheduler1_other1_empty),		
		.iFLAG_REGISTER_0_WR(freereg_scheduler12scheduler2_flag0_wr), 
		.iFLAG_REGISTER_0_NUM(freereg_scheduler12scheduler2_flag0_num), 
		.oFLAG_REGISTER_0_FULL(freereg_scheduler12scheduler2_flag0_full), 
		.oFLAG_REGISTER_0_COUNT(freereg_scheduler12scheduler2_flag0_count),
		.iFLAG_REGISTER_1_WR(freereg_scheduler12scheduler2_flag1_wr), 
		.iFLAG_REGISTER_1_NUM(freereg_scheduler12scheduler2_flag1_num), 
		.oFLAG_REGISTER_1_FULL(freereg_scheduler12scheduler2_flag1_full), 
		.oFLAG_REGISTER_1_COUNT(freereg_scheduler12scheduler2_flag1_count),
		.iOTHER_REGISTER_0_WR(freereg_scheduler12scheduler2_other0_wr), 
		.iOTHER_REGISTER_0_NUM(freereg_scheduler12scheduler2_other0_num), 
		.oOTHER_REGISTER_0_FULL(freereg_scheduler12scheduler2_other0_full), 
		.oOTHER_REGISTER_0_COUNT(freereg_scheduler12scheduler2_other0_count),
		.iOTHER_REGISTER_1_WR(freereg_scheduler12scheduler2_other1_wr), 
		.iOTHER_REGISTER_1_NUM(freereg_scheduler12scheduler2_other1_num), 
		.oOTHER_REGISTER_1_FULL(freereg_scheduler12scheduler2_other1_full), 
		.oOTHER_REGISTER_1_COUNT(freereg_scheduler12scheduler2_other1_count),
		//Next
		.oNEXT_0_VALID(scheduler12scheduler2_0_valid), 
		.oNEXT_0_SOURCE0_ACTIVE(scheduler12scheduler2_0_source0_active), 
		.oNEXT_0_SOURCE1_ACTIVE(scheduler12scheduler2_0_source1_active), 
		.oNEXT_0_SOURCE0_SYSREG(scheduler12scheduler2_0_source0_sysreg), 
		.oNEXT_0_SOURCE1_SYSREG(scheduler12scheduler2_0_source1_sysreg), 
		.oNEXT_0_SOURCE0_SYSREG_RENAME(scheduler12scheduler2_0_source0_sysreg_rename), 
		.oNEXT_0_SOURCE1_SYSREG_RENAME(scheduler12scheduler2_0_source1_sysreg_rename), 
		.oNEXT_0_ADV_ACTIVE(scheduler12scheduler2_0_adv_active), 
		.oNEXT_0_DESTINATION_SYSREG(scheduler12scheduler2_0_destination_sysreg), 
		.oNEXT_0_WRITEBACK(scheduler12scheduler2_0_writeback), 
		.oNEXT_0_FLAGS_WRITEBACK(scheduler12scheduler2_0_flags_writeback), 
		.oNEXT_0_CMD(scheduler12scheduler2_0_cmd), 
		.oNEXT_0_COMMIT_TAG(scheduler12scheduler2_0_commit_tag), 
		.oNEXT_0_CC_AFE(scheduler12scheduler2_0_cc_afe), 
		.oNEXT_0_FLAGS_REGNAME(scheduler12scheduler2_0_flags_regname),
		.oNEXT_0_DESTINATION_REGNAME(scheduler12scheduler2_0_destination_regname), 
		.oNEXT_0_LOGIC_DESTINATION(scheduler12scheduler2_0_logic_destination), 
		.oNEXT_0_SOURCE0(scheduler12scheduler2_0_source0), 
		.oNEXT_0_SOURCE1(scheduler12scheduler2_0_source1), 
		.oNEXT_0_ADV_DATA(scheduler12scheduler2_0_adv_data), 
		.oNEXT_0_SOURCE0_FLAGS(scheduler12scheduler2_0_source0_flags),
		.oNEXT_0_SOURCE1_IMM(scheduler12scheduler2_0_source1_imm), 
		.oNEXT_0_EX_SYS_ADDER(scheduler12scheduler2_0_sys_reg), 
		.oNEXT_0_EX_SYS_LDST(scheduler12scheduler2_0_sys_ldst), 
		.oNEXT_0_EX_LOGIC(scheduler12scheduler2_0_logic), 
		.oNEXT_0_EX_SHIFT(scheduler12scheduler2_0_shift), 
		.oNEXT_0_EX_ADDER(scheduler12scheduler2_0_adder), 
		.oNEXT_0_EX_MUL(scheduler12scheduler2_0_mul), 
		.oNEXT_0_EX_SDIV(scheduler12scheduler2_0_sdiv), 
		.oNEXT_0_EX_UDIV(scheduler12scheduler2_0_udiv), 
		.oNEXT_0_EX_LDST(scheduler12scheduler2_0_ldst), 
		.oNEXT_0_EX_BRANCH(scheduler12scheduler2_0_branch),
		.oNEXT_1_VALID(scheduler12scheduler2_1_valid), 
		.oNEXT_1_SOURCE0_ACTIVE(scheduler12scheduler2_1_source0_active), 
		.oNEXT_1_SOURCE1_ACTIVE(scheduler12scheduler2_1_source1_active), 
		.oNEXT_1_SOURCE0_SYSREG(scheduler12scheduler2_1_source0_sysreg), 
		.oNEXT_1_SOURCE1_SYSREG(scheduler12scheduler2_1_source1_sysreg), 
		.oNEXT_1_SOURCE0_SYSREG_RENAME(scheduler12scheduler2_1_source0_sysreg_rename), 
		.oNEXT_1_SOURCE1_SYSREG_RENAME(scheduler12scheduler2_1_source1_sysreg_rename), 
		.oNEXT_1_ADV_ACTIVE(scheduler12scheduler2_1_adv_active), 
		.oNEXT_1_DESTINATION_SYSREG(scheduler12scheduler2_1_destination_sysreg), 
		.oNEXT_1_WRITEBACK(scheduler12scheduler2_1_writeback), 
		.oNEXT_1_FLAGS_WRITEBACK(scheduler12scheduler2_1_flags_writeback), 
		.oNEXT_1_CMD(scheduler12scheduler2_1_cmd), 
		.oNEXT_1_COMMIT_TAG(scheduler12scheduler2_1_commit_tag), 
		.oNEXT_1_CC_AFE(scheduler12scheduler2_1_cc_afe), 
		.oNEXT_1_FLAGS_REGNAME(scheduler12scheduler2_1_flags_regname),
		.oNEXT_1_DESTINATION_REGNAME(scheduler12scheduler2_1_destination_regname), 
		.oNEXT_1_LOGIC_DESTINATION(scheduler12scheduler2_1_logic_destination), 
		.oNEXT_1_SOURCE0(scheduler12scheduler2_1_source0), 
		.oNEXT_1_SOURCE1(scheduler12scheduler2_1_source1), 
		.oNEXT_1_ADV_DATA(scheduler12scheduler2_1_adv_data), 
		.oNEXT_1_SOURCE0_FLAGS(scheduler12scheduler2_1_source0_flags),
		.oNEXT_1_SOURCE1_IMM(scheduler12scheduler2_1_source1_imm), 
		.oNEXT_1_EX_SYS_ADDER(scheduler12scheduler2_1_sys_reg), 
		.oNEXT_1_EX_SYS_LDST(scheduler12scheduler2_1_sys_ldst),
		.oNEXT_1_EX_LOGIC(scheduler12scheduler2_1_logic), 
		.oNEXT_1_EX_SHIFT(scheduler12scheduler2_1_shift), 
		.oNEXT_1_EX_ADDER(scheduler12scheduler2_1_adder), 
		.oNEXT_1_EX_MUL(scheduler12scheduler2_1_mul),
		.oNEXT_1_EX_SDIV(scheduler12scheduler2_1_sdiv), 
		.oNEXT_1_EX_UDIV(scheduler12scheduler2_1_udiv),  
		.oNEXT_1_EX_LDST(scheduler12scheduler2_1_ldst),
		.oNEXT_1_EX_BRANCH(scheduler12scheduler2_1_branch),
		.oNEXT_PC(scheduler12scheduler2_pc), .iNEXT_LOCK(scheduler22scheduler1_lock)
	);
	
						
	
	/****************************************
	Stage : 6
	Scheduler2 Unit
	****************************************/
	scheduler2 #(32'h0) SATGE6_SCHEDULER2(
		//System
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),				
		//Exception
		.iFREE_DEFAULT(exception_event), 
		.iFREE_RESTART(exception_restart),
		.iFREE_RESERVATIONSTATION(exception_restart), 
		.iFREE_SYSREG_SET_IRQ_MODE(exception2scheduler2_irq_reqister_set),
		.iFREE_SYSREG_BACK_PREVIOUS(exception2scheduler2_irq_reqister_ret),
		.iFREE_CURRENT_PC(exception_current_pc),
		.iFREE_REGISTER(free_register), 
		.iCOMMIT_ENTRY_COMMIT_VECTOR(commit_vector), 
		.iSYSREGINFO_IOSR_VALID(iSYSINFO_IOSR_VALID), 
		.iSYSREGINFO_IOSR(iSYSINFO_IOSR),
		.oSYSREGINFO_TIDR(wire_sysreg_tidr),
		.oSYSREGINFO_PTIDR(wire_sysreg_ptidr),
		.oSYSREGINFO_PSR(wire_sysreg_psr),
		.oSYSREGINFO_PPSR(wire_sysreg_ppsr),
		.oSYSREGINFO_TISR(wire_sysreg_tisr),
		.oSYSREGINFO_PDTR(wire_sysreg_pdtr),
		.oSYSREGINFO_IDTR(wire_sysreg_idtr),
		.oSYSREGINFO_PPCR(wire_sysreg_ppcr),
		.iPREVIOUS_0_VALID(scheduler12scheduler2_0_valid), 
		.iPREVIOUS_0_SOURCE0_ACTIVE(scheduler12scheduler2_0_source0_active), 
		.iPREVIOUS_0_SOURCE1_ACTIVE(scheduler12scheduler2_0_source1_active), 
		.iPREVIOUS_0_SOURCE0_SYSREG(scheduler12scheduler2_0_source0_sysreg), 
		.iPREVIOUS_0_SOURCE1_SYSREG(scheduler12scheduler2_0_source1_sysreg), 
		.iPREVIOUS_0_SOURCE0_SYSREG_RENAME(scheduler12scheduler2_0_source0_sysreg_rename), 
		.iPREVIOUS_0_SOURCE1_SYSREG_RENAME(scheduler12scheduler2_0_source1_sysreg_rename), 
		.iPREVIOUS_0_ADV_ACTIVE(scheduler12scheduler2_0_adv_active),
		.iPREVIOUS_0_DESTINATION_SYSREG(scheduler12scheduler2_0_destination_sysreg), 
		.iPREVIOUS_0_WRITEBACK(scheduler12scheduler2_0_writeback), 
		.iPREVIOUS_0_FLAGS_WRITEBACK(scheduler12scheduler2_0_flags_writeback), 
		.iPREVIOUS_0_CMD(scheduler12scheduler2_0_cmd), 
		.iPREVIOUS_0_COMMIT_TAG(scheduler12scheduler2_0_commit_tag), 
		.iPREVIOUS_0_CC_AFE(scheduler12scheduler2_0_cc_afe), 
		.iPREVIOUS_0_FLAGS_REGNAME(scheduler12scheduler2_0_flags_regname),
		.iPREVIOUS_0_DESTINATION_REGNAME(scheduler12scheduler2_0_destination_regname), 
		.iPREVIOUS_0_LOGIC_DESTINATION(scheduler12scheduler2_0_logic_destination), 
		.iPREVIOUS_0_SOURCE0(scheduler12scheduler2_0_source0), 
		.iPREVIOUS_0_SOURCE1(scheduler12scheduler2_0_source1), 
		.iPREVIOUS_0_ADV_DATA(scheduler12scheduler2_0_adv_data),
		.iPREVIOUS_0_SOURCE0_FLAGS(scheduler12scheduler2_0_source0_flags),
		.iPREVIOUS_0_SOURCE1_IMM(scheduler12scheduler2_0_source1_imm),
		.iPREVIOUS_0_EX_SYS_REG(scheduler12scheduler2_0_sys_reg), 
		.iPREVIOUS_0_EX_SYS_LDST(scheduler12scheduler2_0_sys_ldst), 
		.iPREVIOUS_0_EX_LOGIC(scheduler12scheduler2_0_logic), 
		.iPREVIOUS_0_EX_SHIFT(scheduler12scheduler2_0_shift), 
		.iPREVIOUS_0_EX_ADDER(scheduler12scheduler2_0_adder), 
		.iPREVIOUS_0_EX_MUL(scheduler12scheduler2_0_mul), 
		.iPREVIOUS_0_EX_SDIV(scheduler12scheduler2_0_sdiv), 
		.iPREVIOUS_0_EX_UDIV(scheduler12scheduler2_0_udiv), 
		.iPREVIOUS_0_EX_LDST(scheduler12scheduler2_0_ldst), 
		.iPREVIOUS_0_EX_BRANCH(scheduler12scheduler2_0_branch),
		.iPREVIOUS_1_VALID(scheduler12scheduler2_1_valid), 
		.iPREVIOUS_1_SOURCE0_ACTIVE(scheduler12scheduler2_1_source0_active), 
		.iPREVIOUS_1_SOURCE1_ACTIVE(scheduler12scheduler2_1_source1_active), 
		.iPREVIOUS_1_SOURCE0_SYSREG(scheduler12scheduler2_1_source0_sysreg), 
		.iPREVIOUS_1_SOURCE1_SYSREG(scheduler12scheduler2_1_source1_sysreg), 
		.iPREVIOUS_1_SOURCE0_SYSREG_RENAME(scheduler12scheduler2_1_source0_sysreg_rename), 
		.iPREVIOUS_1_SOURCE1_SYSREG_RENAME(scheduler12scheduler2_1_source1_sysreg_rename), 
		.iPREVIOUS_1_ADV_ACTIVE(scheduler12scheduler2_1_adv_active),
		.iPREVIOUS_1_DESTINATION_SYSREG(scheduler12scheduler2_1_destination_sysreg), 
		.iPREVIOUS_1_WRITEBACK(scheduler12scheduler2_1_writeback), 
		.iPREVIOUS_1_FLAGS_WRITEBACK(scheduler12scheduler2_1_flags_writeback), 
		.iPREVIOUS_1_CMD(scheduler12scheduler2_1_cmd), 
		.iPREVIOUS_1_COMMIT_TAG(scheduler12scheduler2_1_commit_tag), 
		.iPREVIOUS_1_CC_AFE(scheduler12scheduler2_1_cc_afe), 
		.iPREVIOUS_1_FLAGS_REGNAME(scheduler12scheduler2_1_flags_regname),
		.iPREVIOUS_1_DESTINATION_REGNAME(scheduler12scheduler2_1_destination_regname), 
		.iPREVIOUS_1_LOGIC_DESTINATION(scheduler12scheduler2_1_logic_destination), 
		.iPREVIOUS_1_SOURCE0(scheduler12scheduler2_1_source0), 
		.iPREVIOUS_1_SOURCE1(scheduler12scheduler2_1_source1), 
		.iPREVIOUS_1_ADV_DATA(scheduler12scheduler2_1_adv_data),
		.iPREVIOUS_1_SOURCE0_FLAGS(scheduler12scheduler2_1_source0_flags),
		.iPREVIOUS_1_SOURCE1_IMM(scheduler12scheduler2_1_source1_imm), 
		.iPREVIOUS_1_EX_SYS_REG(scheduler12scheduler2_1_sys_reg), 
		.iPREVIOUS_1_EX_SYS_LDST(scheduler12scheduler2_1_sys_ldst), 
		.iPREVIOUS_1_EX_LOGIC(scheduler12scheduler2_1_logic), 
		.iPREVIOUS_1_EX_SHIFT(scheduler12scheduler2_1_shift), 
		.iPREVIOUS_1_EX_ADDER(scheduler12scheduler2_1_adder), 
		.iPREVIOUS_1_EX_MUL(scheduler12scheduler2_1_mul),  
		.iPREVIOUS_1_EX_SDIV(scheduler12scheduler2_1_sdiv), 
		.iPREVIOUS_1_EX_UDIV(scheduler12scheduler2_1_udiv),
		.iPREVIOUS_1_EX_LDST(scheduler12scheduler2_1_ldst), 
		.iPREVIOUS_1_EX_BRANCH(scheduler12scheduler2_1_branch),
		.iPREVIOUS_PC(scheduler12scheduler2_pc), 
		.oPREVIOUS_LOCK(scheduler22scheduler1_lock),
		.oFLAG_REGISTER_0_WR(freereg_scheduler12scheduler2_flag0_wr), 
		.oFLAG_REGISTER_0_NUM(freereg_scheduler12scheduler2_flag0_num),
		.iFLAG_REGISTER_0_FULL(freereg_scheduler12scheduler2_flag0_full), 
		.iFLAG_REGISTER_0_COUNT(freereg_scheduler12scheduler2_flag0_count),
		.oFLAG_REGISTER_1_WR(freereg_scheduler12scheduler2_flag1_wr), 
		.oFLAG_REGISTER_1_NUM(freereg_scheduler12scheduler2_flag1_num),
		.iFLAG_REGISTER_1_FULL(freereg_scheduler12scheduler2_flag1_full), 
		.iFLAG_REGISTER_1_COUNT(freereg_scheduler12scheduler2_flag1_count),
		.oOTHER_REGISTER_0_WR(freereg_scheduler12scheduler2_other0_wr), 
		.oOTHER_REGISTER_0_NUM(freereg_scheduler12scheduler2_other0_num), 
		.iOTHER_REGISTER_0_FULL(freereg_scheduler12scheduler2_other0_full), 
		.iOTHER_REGISTER_0_COUNT(freereg_scheduler12scheduler2_other0_count),
		.oOTHER_REGISTER_1_WR(freereg_scheduler12scheduler2_other1_wr), 
		.oOTHER_REGISTER_1_NUM(freereg_scheduler12scheduler2_other1_num), 
		.iOTHER_REGISTER_1_FULL(freereg_scheduler12scheduler2_other1_full), 
		.iOTHER_REGISTER_1_COUNT(freereg_scheduler12scheduler2_other1_count),
		.oNEXT_EX_BRANCH_VALID(scheduler22ex_alu0_valid), 
		.oNEXT_EX_BRANCH_COMMIT_TAG(scheduler22ex_alu0_commit_tag), 
		.oNEXT_EX_BRANCH_CMD(scheduler22ex_alu0_cmd), 
		.oNEXT_EX_BRANCH_CC(scheduler22ex_alu0_cc),
		.oNEXT_EX_BRANCH_FLAG(scheduler22ex_alu0_flag), 
		.oNEXT_EX_BRANCH_SOURCE(scheduler22ex_alu0_source), 
		.oNEXT_EX_PC(scheduler22ex_alu0_pc),
		.iNEXT_EX_BRANCH_LOCK(ex_alu02scheduler2_lock),
		.iSCHE2_EX_BRANCH_VALID(ex_alu02scheduler2_branch_valid), 
		.iSCHE2_EX_BRANCH_COMMIT_TAG(ex_alu02scheduler2_branch_commit_tag),			
		.oNEXT_EX_ALU1_VALID(scheduler22ex_alu1_valid), 
		.oNEXT_EX_ALU1_WRITEBACK(scheduler22ex_alu1_writeback), 
		.oNEXT_EX_ALU1_COMMIT_TAG(scheduler22ex_alu1_commit_tag), 
		.oNEXT_EX_ALU1_CMD(scheduler22ex_alu1_cmd),
		.oNEXT_EX_ALU1_AFE(scheduler22ex_alu1_afe),
		.oNEXT_EX_ALU1_SYS_REG(scheduler22ex_alu1_sys_reg),
		.oNEXT_EX_ALU1_LOGIC(scheduler22ex_alu1_logic),
		.oNEXT_EX_ALU1_SHIFT(scheduler22ex_alu1_shift), 
		.oNEXT_EX_ALU1_ADDER(scheduler22ex_alu1_adder),
		.oNEXT_EX_ALU1_MUL(scheduler22ex_alu1_mul),
		.oNEXT_EX_ALU1_SDIV(scheduler22ex_alu1_sdiv), 
		.oNEXT_EX_ALU1_UDIV(scheduler22ex_alu1_udiv),
		.oNEXT_EX_ALU1_SOURCE0(scheduler22ex_alu1_source0), 
		.oNEXT_EX_ALU1_SOURCE1(scheduler22ex_alu1_source1),
		.oNEXT_EX_ALU1_DESTINATION_SYSREG(scheduler22ex_alu1_destination_sysreg),
		.oNEXT_EX_ALU1_LOGIC_DEST(scheduler22ex_alu1_logic_dest),	//for debug
		.oNEXT_EX_ALU1_DESTINATION_REGNAME(scheduler22ex_alu1_destination_regname), 
		.oNEXT_EX_ALU1_FLAGS_WRITEBACK(scheduler22ex_alu1_flags_writeback), 
		.oNEXT_EX_ALU1_FLAGS_REGNAME(scheduler22ex_alu1_flags_regname),	
		.oNEXT_EX_ALU1_PCR(scheduler22ex_alu1_pcr),							
		.iNEXT_EX_ALU1_LOCK(ex_alu12scheduler2_lock),
		.iSCHE2_EX_ALU1_VALID(ex_alu12scheduler2_valid), 
		.iSCHE2_EX_ALU1_COMMIT_TAG(ex_alu12scheduler2_commit_tag),
		.iSCHE2_EX_ALU1_DESTINATION_SYSREG(ex_alu12scheduler2_destination_sysreg),
		.iSCHE2_EX_ALU1_DESTINATION_REGNAME(ex_alu12scheduler2_destination_regname), 
		.iSCHE2_EX_ALU1_WRITEBACK(ex_alu12scheduler2_writeback), 
		.iSCHE2_EX_ALU1_DATA(ex_alu12scheduler2_data),
		.iSCHE2_EX_ALU1_FLAG(ex_alu12scheduler2_flag), 
		.iSCHE2_EX_ALU1_FLAGS_WRITEBACK(ex_alu12scheduler2_flags_writeback),
		.iSCHE2_EX_ALU1_FLAGS_REGNAME(ex_alu12scheduler2_flags_regname),
		.oNEXT_EX_ALU2_VALID(scheduler22ex_alu2_valid), 
		.oNEXT_EX_ALU2_WRITEBACK(scheduler22ex_alu2_writeback), 
		.oNEXT_EX_ALU2_COMMIT_TAG(scheduler22ex_alu2_commit_tag), 
		.oNEXT_EX_ALU2_CMD(scheduler22ex_alu2_cmd),
		.oNEXT_EX_ALU2_AFE(scheduler22ex_alu2_afe),
		.oNEXT_EX_ALU2_SYS_REG(scheduler22ex_alu2_sys_reg),
		.oNEXT_EX_ALU2_LOGIC(scheduler22ex_alu2_logic),
		.oNEXT_EX_ALU2_SHIFT(scheduler22ex_alu2_shift), 
		.oNEXT_EX_ALU2_ADDER(scheduler22ex_alu2_adder),
		.oNEXT_EX_ALU2_SOURCE0(scheduler22ex_alu2_source0), 
		.oNEXT_EX_ALU2_SOURCE1(scheduler22ex_alu2_source1),
		.oNEXT_EX_ALU2_DESTINATION_SYSREG(scheduler22ex_alu2_destination_sysreg),
		.oNEXT_EX_ALU2_LOGIC_DEST(scheduler22ex_alu2_logic_dest), 	//for debug
		.oNEXT_EX_ALU2_DESTINATION_REGNAME(scheduler22ex_alu2_destination_regname), 
		.oNEXT_EX_ALU2_FLAGS_WRITEBACK(scheduler22ex_alu2_flags_writeback), 
		.oNEXT_EX_ALU2_FLAGS_REGNAME(scheduler22ex_alu2_flags_regname),	
		.oNEXT_EX_ALU2_PCR(scheduler22ex_alu2_pcr),						
		.iNEXT_EX_ALU2_LOCK(ex_alu22scheduler2_lock),
		.iSCHE2_EX_ALU2_VALID(ex_alu22scheduler2_valid), 
		.iSCHE2_EX_ALU2_COMMIT_TAG(ex_alu22scheduler2_commit_tag),
		.iSCHE2_EX_ALU2_DESTINATION_SYSREG(ex_alu22scheduler2_destination_sysreg),
		.iSCHE2_EX_ALU2_DESTINATION_REGNAME(ex_alu22scheduler2_destination_regname), 
		.iSCHE2_EX_ALU2_WRITEBACK(ex_alu22scheduler2_writeback), 
		.iSCHE2_EX_ALU2_DATA(ex_alu22scheduler2_data),
		.iSCHE2_EX_ALU2_FLAG(ex_alu22scheduler2_flag), 
		.iSCHE2_EX_ALU2_FLAGS_WRITEBACK(ex_alu22scheduler2_flags_writeback),
		.iSCHE2_EX_ALU2_FLAGS_REGNAME(ex_alu22scheduler2_flags_regname),
		.oNEXT_EX_ALU3_VALID(scheduler22ex_alu3_valid), 
		.oNEXT_EX_ALU3_DESTINATION_SYSREG(scheduler22ex_alu3_destination_sysreg),
		.oNEXT_EX_ALU3_COMMIT_TAG(scheduler22ex_alu3_commit_tag), 
		.oNEXT_EX_ALU3_CMD(scheduler22ex_alu3_cmd), 
		.oNEXT_EX_ALU3_SYS_LDST(scheduler22ex_alu3_sys_ldst),
		.oNEXT_EX_ALU3_LDST(scheduler22ex_alu3_ldst),
		.oNEXT_EX_ALU3_SOURCE0(scheduler22ex_alu3_source0),
		.oNEXT_EX_ALU3_SOURCE1(scheduler22ex_alu3_source1),
		.oNEXT_EX_ALU3_ADV_ACTIVE(scheduler22ex_alu3_adv_active),
		.oNEXT_EX_ALU3_ADV_DATA(scheduler22ex_alu3_adv_data),
		.oNEXT_EX_ALU3_LOGIC_DEST(scheduler22ex_alu3_logic_dest),	//for debug
		.oNEXT_EX_ALU3_DESTINATION_REGNAME(scheduler22ex_alu3_destination_regname), 
		.oNEXT_EX_ALU3_PC(scheduler22ex_alu3_pc),
		.iNEXT_EX_ALU3_LOCK(ex_alu32scheduler2_ldst_lock),
		.iSCHE2_ALU3_VALID(ex_alu32scheduler2_ldst_valid), .iSCHE2_ALU3_COMMIT_TAG(ex_alu32scheduler2_ldst_commit_tag),
		.iSCHE2_ALU3_DESTINATION_REGNAME(ex_alu32scheduler2_ldst_destination_regname), 
		.iSCHE2_ALU3_DESTINATION_SYSREG(ex_alu32scheduler2_ldst_destination_sysreg),
		.iSCHE2_ALU3_WRITEBACK(ex_alu32scheduler2_ldst_writeback),
		.iSCHE2_ALU3_DATA(ex_alu32scheduler2_ldst_data)
	);
						
	/****************************************
	Stage : 7
	Execution Unit
	****************************************/
	//Branch(alu0)
	execute_port0 SATGE7_EX_PORT0(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iFREE_RESTART(exception_restart),
		.iPREVIOUS_EX_BRANCH_VALID(scheduler22ex_alu0_valid), .iPREVIOUS_EX_BRANCH_COMMIT_TAG(scheduler22ex_alu0_commit_tag),
		.iPREVIOUS_EX_BRANCH_CMD(scheduler22ex_alu0_cmd), .iPREVIOUS_EX_BRANCH_CC(scheduler22ex_alu0_cc),
		.iPREVIOUS_EX_BRANCH_FLAG(scheduler22ex_alu0_flag), 
		.iPREVIOUS_EX_BRANCH_SOURCE(scheduler22ex_alu0_source), .iPREVIOUS_EX_BRANCH_PC(scheduler22ex_alu0_pc),
		.oPREVIOUS_EX_BRANCH_LOCK(ex_alu02scheduler2_lock),
		//To Exception Unit
		.oJUMP_ACTIVE(jump_active), 
		.oJUMP_ADDR(jump_addr),
		//To Internal Interrupt Controller 
		.oSWI_ACTIVE(ex_alu02iic_swi_active),
		.oSWI_NUMBER(ex_alu02iic_swi_number),
		//To Exception Manager
		.oINTR_ACTIVE(ex_alu02exception_intr_active),
		.oINTR_ADDR(ex_alu02exception_intr_addr),
		//IDT Write Action Request
		.oIDTS_ACTIVE(ex_alu02exception_idts_active),
		.oIDTS_R_ADDR(ex_alu02exception_idts_r_addr),
		.oIDTR_COMMIT_TAG(ex_alu02exception_idts_commit_tag),
		//To Scheduler1
		.oSCHE1_EX_BRANCH_VALID(ex_alu02scheduler1_branch_valid), 
		.oSCHE1_EX_BRANCH_COMMIT_TAG(ex_alu02scheduler1_branch_commit_tag), 
		//To Scheduler2
		.oSCHE2_EX_BRANCH_VALID(ex_alu02scheduler2_branch_valid), 
		.oSCHE2_EX_BRANCH_COMMIT_TAG(ex_alu02scheduler2_branch_commit_tag)
	);	
					
	//Complex Adder(alu1)
	execute_port1 SATGE7_EX_PORT1(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iFREE_EX(exception_restart),
		.iPREVIOUS_EX_ALU1_VALID(scheduler22ex_alu1_valid),
		.iPREVIOUS_EX_ALU1_WRITEBACK(scheduler22ex_alu1_writeback), 
		.iPREVIOUS_EX_ALU1_COMMIT_TAG(scheduler22ex_alu1_commit_tag), 
		.iPREVIOUS_EX_ALU1_CMD(scheduler22ex_alu1_cmd), 
		.iPREVIOUS_EX_ALU1_AFE(scheduler22ex_alu1_afe), 
		.iPREVIOUS_EX_ALU1_SYS_REG(scheduler22ex_alu1_sys_reg),
		.iPREVIOUS_EX_ALU1_LOGIC(scheduler22ex_alu1_logic), 
		.iPREVIOUS_EX_ALU1_SHIFT(scheduler22ex_alu1_shift), 
		.iPREVIOUS_EX_ALU1_ADDER(scheduler22ex_alu1_adder), 
		.iPREVIOUS_EX_ALU1_MUL(scheduler22ex_alu1_mul),
		.iPREVIOUS_EX_ALU1_SDIV(scheduler22ex_alu1_sdiv), 
		.iPREVIOUS_EX_ALU1_UDIV(scheduler22ex_alu1_udiv),
		.iPREVIOUS_EX_ALU1_SOURCE0(scheduler22ex_alu1_source0), 
		.iPREVIOUS_EX_ALU1_SOURCE1(scheduler22ex_alu1_source1), 
		.iPREVIOUS_EX_ALU1_DESTINATION_SYSREG(scheduler22ex_alu1_destination_sysreg),
		.iPREVIOUS_EX_ALU1_LOGIC_DEST(scheduler22ex_alu1_logic_dest),
		.iPREVIOUS_EX_ALU1_DESTINATION_REGNAME(scheduler22ex_alu1_destination_regname), 
		.iPREVIOUS_EX_ALU1_FLAGS_WRITEBACK(scheduler22ex_alu1_flags_writeback),
		.iPREVIOUS_EX_ALU1_FLAGS_REGNAME(scheduler22ex_alu1_flags_regname),
		.iPREVIOUS_EX_ALU1_PCR(scheduler22ex_alu1_pcr),
		.oPREVIOUS_EX_ALU1_LOCK(ex_alu12scheduler2_lock),
		//Exception
		.oINTERRUPT_ACTIVE(ex_alu12cim_valid),
		.oINTERRUPT_NUM(ex_alu12cim_num),
		//Scheduler
		.oSCHE1_EX_ALU1_VALID(ex_alu12scheduler1_valid), 
		.oSCHE1_EX_ALU1_COMMIT_TAG(ex_alu12scheduler1_commit_tag),
		.oSCHE2_EX_ALU1_VALID(ex_alu12scheduler2_valid), 
		.oSCHE2_EX_ALU1_COMMIT_TAG(ex_alu12scheduler2_commit_tag),
		.oSCHE2_EX_ALU1_SYSREG(ex_alu12scheduler2_destination_sysreg),
		.oSCHE2_EX_ALU1_LOGIC_DEST(),
		.oSCHE2_EX_ALU1_DESTINATION_REGNAME(ex_alu12scheduler2_destination_regname), 
		.oSCHE2_EX_ALU1_WRITEBACK(ex_alu12scheduler2_writeback), 
		.oSCHE2_EX_ALU1_DATA(ex_alu12scheduler2_data), 
		.oSCHE2_EX_ALU1_FLAG(ex_alu12scheduler2_flag), 
		.oSCHE2_EX_ALU1_FLAGS_WRITEBACK(ex_alu12scheduler2_flags_writeback),
		.oSCHE2_EX_ALU1_FLAGS_REGNAME(ex_alu12scheduler2_flags_regname)
	);	

	
	//Simple Adder(alu2)
	execute_port2 SATGE7_EX_PORT2(
		.iCLOCK(iCLOCK), .inRESET(inRESET),
		.iFREE_EX(exception_restart),
		.iPREVIOUS_EX_ALU2_VALID(scheduler22ex_alu2_valid), 
		.iPREVIOUS_EX_ALU2_WRITEBACK(scheduler22ex_alu2_writeback), 
		.iPREVIOUS_EX_ALU2_COMMIT_TAG(scheduler22ex_alu2_commit_tag), 
		.iPREVIOUS_EX_ALU2_CMD(scheduler22ex_alu2_cmd), 
		.iPREVIOUS_EX_ALU2_AFE(scheduler22ex_alu2_afe), 
		.iPREVIOUS_EX_ALU2_SYS_REG(scheduler22ex_alu2_sys_reg),
		.iPREVIOUS_EX_ALU2_LOGIC(scheduler22ex_alu2_logic), 
		.iPREVIOUS_EX_ALU2_SHIFT(scheduler22ex_alu2_shift), 
		.iPREVIOUS_EX_ALU2_ADDER(scheduler22ex_alu2_adder), 
		.iPREVIOUS_EX_ALU2_SOURCE0(scheduler22ex_alu2_source0), 
		.iPREVIOUS_EX_ALU2_SOURCE1(scheduler22ex_alu2_source1), 
		.iPREVIOUS_EX_ALU2_DESTINATION_SYSREG(scheduler22ex_alu2_destination_sysreg),
		.iPREVIOUS_EX_ALU2_LOGIC_DEST(scheduler22ex_alu2_logic_dest),
		.iPREVIOUS_EX_ALU2_DESTINATION_REGNAME(scheduler22ex_alu2_destination_regname), 
		.iPREVIOUS_EX_ALU2_FLAGS_WRITEBACK(scheduler22ex_alu2_flags_writeback),
		.iPREVIOUS_EX_ALU2_FLAGS_REGNAME(scheduler22ex_alu2_flags_regname),
		.iPREVIOUS_EX_ALU2_PCR(scheduler22ex_alu2_pcr),
		.oPREVIOUS_EX_ALU2_LOCK(ex_alu22scheduler2_lock),
		//Scheduler
		.oSCHE1_EX_ALU2_VALID(ex_alu22scheduler1_valid), 
		.oSCHE1_EX_ALU2_COMMIT_TAG(ex_alu22scheduler1_commit_tag),
		.oSCHE2_EX_ALU2_VALID(ex_alu22scheduler2_valid), 
		.oSCHE2_EX_ALU2_COMMIT_TAG(ex_alu22scheduler2_commit_tag),
		.oSCHE2_EX_ALU2_SYSREG(ex_alu22scheduler2_destination_sysreg),
		.oSCHE2_EX_ALU2_LOGIC_DEST(),
		.oSCHE2_EX_ALU2_DESTINATION_REGNAME(ex_alu22scheduler2_destination_regname), 
		.oSCHE2_EX_ALU2_WRITEBACK(ex_alu22scheduler2_writeback), 
		.oSCHE2_EX_ALU2_DATA(ex_alu22scheduler2_data), 
		.oSCHE2_EX_ALU2_FLAG(ex_alu22scheduler2_flag), 
		.oSCHE2_EX_ALU2_FLAGS_WRITEBACK(ex_alu22scheduler2_flags_writeback),
		.oSCHE2_EX_ALU2_FLAGS_REGNAME(ex_alu22scheduler2_flags_regname)
	);

	
	//Load/Store(alu3)
	execute_port3 SATGE7_EX_PORT3(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET),
		.iRESET_SYNC(1'b0),
		//Free
		.iFREE_EX(exception_restart),
		.iFREE_SYSREG_NEW_SPR_VALID(exception2alu0_new_spr_valid),	
		.iFREE_SYSREG_NEW_SPR(exception2alu0_new_spr),
		//Sysreg
		.iSYSREG_TIDR(wire_sysreg_tidr),
		.iSYSREG_PSR(wire_sysreg_psr),
		.iSYSREG_PDTR(wire_sysreg_pdtr),
		.oSYSREG_SPR(wire_sysreg_spr),
		//Data OI
		.oDATAIO_REQ(alu32ldst_ldst_req),
		.iDATAIO_BUSY(ldst2alu3_ldst_busy),
		.oDATAIO_ORDER(alu32ldst_ldst_order),
		.oDATAIO_MASK(alu32ldst_ldst_mask),
		.oDATAIO_RW(alu32ldst_ldst_rw),
		.oDATAIO_TID(alu32ldst_ldst_tid),
		.oDATAIO_MMUMOD(alu32ldst_ldst_mmumod),
		.oDATAIO_PDT(alu32ldst_ldst_pdt),
		.oDATAIO_ADDR(alu32ldst_ldst_addr),
		.oDATAIO_DATA(alu32ldst_ldst_data),
		.iDATAIO_REQ(ldst2alu3_ldst_req),
		.iDATAIO_DATA(ldst2alu3_ldst_data),	
		//Scheduler
		.iPREVIOUS_EX_ALU3_VALID(scheduler22ex_alu3_valid), 
		.iPREVIOUS_EX_ALU3_DESTINATION_SYSREG(scheduler22ex_alu3_destination_sysreg),
		.iPREVIOUS_EX_ALU3_COMMIT_TAG(scheduler22ex_alu3_commit_tag), 
		.iPREVIOUS_EX_ALU3_CMD(scheduler22ex_alu3_cmd), 
		.iPREVIOUS_EX_ALU3_SOURCE0(scheduler22ex_alu3_source0), 
		.iPREVIOUS_EX_ALU3_SOURCE1(scheduler22ex_alu3_source1), 
		.iPREVIOUS_EX_ALU3_ADV_ACTIVE(scheduler22ex_alu3_adv_active),
		.iPREVIOUS_EX_ALU3_ADV_DATA(scheduler22ex_alu3_adv_data),
		.iPREVIOUS_EX_ALU3_LOGIC_DEST(scheduler22ex_alu3_logic_dest),
		.iPREVIOUS_EX_ALU3_DESTINATION_REGNAME(scheduler22ex_alu3_destination_regname), .iPREVIOUS_EX_ALU3_PC(scheduler22ex_alu3_pc),
		.iPREVIOUS_EX_ALU3_SYS_LDST(scheduler22ex_alu3_sys_ldst), 
		.iPREVIOUS_EX_ALU3_LDST(scheduler22ex_alu3_ldst),
		.oPREVIOUS_EX_ALU3_LOCK(ex_alu32scheduler2_ldst_lock), 
		.oSCHE1_ALU3_VALID(ex_alu32scheduler1_ldst_valid), 
		.oSCHE1_ALU3_COMMIT_TAG(ex_alu32scheduler1_ldst_commit_tag),
		.oSCHE2_ALU3_VALID(ex_alu32scheduler2_ldst_valid), 
		.oSCHE2_ALU3_COMMIT_TAG(ex_alu32scheduler2_ldst_commit_tag),
		.oSCHE2_ALU3_LOGIC_DEST(),
		.oSCHE2_ALU3_DESTINATION_REGNAME(ex_alu32scheduler2_ldst_destination_regname), 
		.oSCHE2_ALU3_DESTINATION_SYSREG(ex_alu32scheduler2_ldst_destination_sysreg), 
		.oSCHE2_ALU3_WRITEBACK(ex_alu32scheduler2_ldst_writeback),
		.oSCHE2_ALU3_DATA(ex_alu32scheduler2_ldst_data)
	);	
	
	/****************************************
	Stage : 8
	Data Cache
	****************************************/
	wire ldst_arbiter2d_cache_req;
	wire d_cache2ldst_arbiter_busy;
	wire [1:0] ldst_arbiter2d_cache_order;
	wire [3:0] ldst_arbiter2d_cache_mask;
	wire ldst_arbiter2d_cache_rw;
	wire [31:0] ldst_arbiter2d_cache_tid;
	wire [1:0] ldst_arbiter2d_cache_mmumod;
	wire [31:0] ldst_arbiter2d_cache_pdt;
	wire [31:0] ldst_arbiter2d_cache_addr;
	wire [31:0] ldst_arbiter2d_cache_data;
	wire d_cache2ldst_arbiter_valid;
	wire d_cache2ldst_arbiter_pagefault;
	wire [13:0] d_cache2ldst_arbiter_mmu_flags;
	wire [31:0] d_cache2ldst_arbiter_data;

	l1_data_cache L1_DATA_CACHE(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Remove
		.iREMOVE(exception_restart),
		.iCACHE_FLASH(/*cache_flash || free_cache_flush*/1'b0),
		//IOSR
		.iSYSINFO_IOSR_VALID(iSYSINFO_IOSR_VALID),
		.iSYSINFO_IOSR(iSYSINFO_IOSR),
		/****************************************
		Load/Store Module
		****************************************/		
		//Load Store -> Cache
		.iLDST_REQ(ldst_arbiter2d_cache_req),
		.oLDST_BUSY(d_cache2ldst_arbiter_busy),
		.iLDST_ORDER(ldst_arbiter2d_cache_order),
		.iLDST_MASK(ldst_arbiter2d_cache_mask),
		.iLDST_RW(ldst_arbiter2d_cache_rw),
		.iLDST_TID(ldst_arbiter2d_cache_tid),
		.iLDST_MMUMOD(ldst_arbiter2d_cache_mmumod),
		.iLDST_PDT(ldst_arbiter2d_cache_pdt),
		.iLDST_ADDR(ldst_arbiter2d_cache_addr),
		.iLDST_DATA(ldst_arbiter2d_cache_data),
		//Cache -> Load Store
		.oLDST_VALID(d_cache2ldst_arbiter_valid),
		.oLDST_PAGEFAULT(d_cache2ldst_arbiter_pagefault),////////////////////////////////
		.oLDST_MMU_FLAGS(d_cache2ldst_arbiter_mmu_flags),////////////////////////////////
		.oLDST_DATA(d_cache2ldst_arbiter_data),
		/****************************************
		Data Memory
		****************************************/
		//Req
		.oDATA_REQ(oDATA_REQ),
		.iDATA_LOCK(iDATA_LOCK),
		.oDATA_ORDER(oDATA_ORDER),
		.oDATA_MASK(oDATA_MASK),
		.oDATA_RW(oDATA_RW),		//0=Write 1=Read
		.oDATA_TID(oDATA_TID),
		.oDATA_MMUMOD(oDATA_MMUMOD),
		.oDATA_PDT(oDATA_PDT),
		.oDATA_ADDR(oDATA_ADDR),
		//This -> Data RAM
		.oDATA_DATA(oDATA_DATA),
		//Data RAM -> This
		.iDATA_VALID(iDATA_VALID),
		.iDATA_PAGEFAULT(iDATA_PAGEFAULT),
		.iDATA_MMU_FLAGS(iDATA_MMU_FLAGS),
		.iDATA_DATA(iDATA_DATA),
		/****************************************  
		IO
		****************************************/
		//Req
		.oIO_REQ(oIO_REQ),
		.iIO_BUSY(iIO_BUSY),
		.oIO_ORDER(oIO_ORDER),
		.oIO_RW(oIO_RW),			//0=Write 1=Read
		.oIO_ADDR(oIO_ADDR),
		//Write
		.oIO_DATA(oIO_DATA),
		//Rec
		.iIO_VALID(iIO_VALID),
		.iIO_DATA(iIO_DATA)
	);
	

	
	
	/****************************************
	Load Store Port Selector
	****************************************/
	/*
	//Output Port
	assign		oLDST_REQ = alu32ldst_ldst_req;
	assign		oLDST_ORDER = alu32ldst_ldst_order;
	assign		oLDST_RW =  alu32ldst_ldst_rw;
	assign		oLDST_TID = alu32ldst_ldst_tid;		
	assign		oLDST_MMUMOD	=	alu32ldst_ldst_mmumod;		
	assign		oLDST_PDT = alu32ldst_ldst_pdt;
	assign		oLDST_ADDR = alu32ldst_ldst_addr;
	assign		oLDST_DATA = alu32ldst_ldst_data;
	
	
	//Exception Unit
	assign		ldst2exception_ldst_busy = 	(exception2ldst_ldst_use)? iLDST_BUSY  : 1'b1;
	assign		ldst2exception_ldst_req = (exception2ldst_ldst_use)? iLDST_VALID : 1'b0;
	assign		ldst2exception_ldst_data = 	iLDST_DATA;
	
	//ALU-LoadStore Unit
	assign		ldst2alu3_ldst_busy = (exception2ldst_ldst_use)? 1'b1 : iLDST_BUSY;
	assign		ldst2alu3_ldst_req = (exception2ldst_ldst_use)? 1'b0 : iLDST_VALID;
	assign		ldst2alu3_ldst_data = iLDST_DATA;
	*/
	
	

	/*
	//Output Port
	assign oLDST_REQ = (exception2ldst_ldst_use)? exception2ldst_ldst_req : alu32ldst_ldst_req;
	assign oLDST_ORDER = (exception2ldst_ldst_use)? exception2ldst_ldst_order : alu32ldst_ldst_order;
	assign oLDST_RW = (exception2ldst_ldst_use)? exception2ldst_ldst_rw : alu32ldst_ldst_rw;
	assign oLDST_TID = (exception2ldst_ldst_use)? exception2ldst_ldst_tid : alu32ldst_ldst_tid;		
	assign oLDST_MMUMOD	=	(exception2ldst_ldst_use)? exception2ldst_ldst_mmumod : alu32ldst_ldst_mmumod;		
	assign oLDST_PDT = (exception2ldst_ldst_use)? exception2ldst_ldst_pdt : alu32ldst_ldst_pdt;
	assign oLDST_ADDR = (exception2ldst_ldst_use)? exception2ldst_ldst_addr : alu32ldst_ldst_addr;
	assign oLDST_DATA = (exception2ldst_ldst_use)? exception2ldst_ldst_data : alu32ldst_ldst_data;

	
	//Exception Unit
	assign ldst2exception_ldst_busy = 	(exception2ldst_ldst_use)? iLDST_BUSY  : 1'b1;
	assign ldst2exception_ldst_req = (exception2ldst_ldst_use)? iLDST_VALID : 1'b0;
	assign ldst2exception_ldst_data = 	iLDST_DATA;
	
	//ALU-LoadStore Unit
	assign ldst2alu3_ldst_busy = (exception2ldst_ldst_use)? 1'b1 : iLDST_BUSY;
	assign ldst2alu3_ldst_req = (exception2ldst_ldst_use)? 1'b0 : iLDST_VALID;
	assign ldst2alu3_ldst_data = iLDST_DATA;
	*/

	
	losd_store_pipe_arbiter LDST_PIPE_ARBITOR(
		.oLDST_REQ(ldst_arbiter2d_cache_req),
		.iLDST_BUSY(d_cache2ldst_arbiter_busy),	
		.oLDST_ORDER(ldst_arbiter2d_cache_order),	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oLDST_MASK(ldst_arbiter2d_cache_mask),
		.oLDST_RW(ldst_arbiter2d_cache_rw),		//0=Read 1=Write
		.oLDST_TID(ldst_arbiter2d_cache_tid),
		.oLDST_MMUMOD(ldst_arbiter2d_cache_mmumod),
		.oLDST_PDT(ldst_arbiter2d_cache_pdt),	
		.oLDST_ADDR(ldst_arbiter2d_cache_addr),
		.oLDST_DATA(ldst_arbiter2d_cache_data),
		.iLDST_VALID(d_cache2ldst_arbiter_valid),
		.iLDST_PAGEFAULT(d_cache2ldst_arbiter_pagefault),
		.iLDST_MMU_FLAGS(d_cache2ldst_arbiter_mmu_flags),
		.iLDST_DATA(d_cache2ldst_arbiter_data),
		//Selector
		.iUSE_SEL(exception2ldst_ldst_use),		//0:Execution | 1:Exception
		//Execution Module
		.iEXE_REQ(alu32ldst_ldst_req),
		.oEXE_BUSY(ldst2alu3_ldst_busy),
		.iEXE_ORDER(alu32ldst_ldst_order),	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.iEXE_MASK(alu32ldst_ldst_mask),
		.iEXE_RW(alu32ldst_ldst_rw),		//0=Read 1=Write
		.iEXE_TID(alu32ldst_ldst_tid),
		.iEXE_MMUMOD(alu32ldst_ldst_mmumod),
		.iEXE_PDT(alu32ldst_ldst_pdt),
		.iEXE_ADDR(alu32ldst_ldst_addr),
		.iEXE_DATA(alu32ldst_ldst_data),
		.oEXE_REQ(ldst2alu3_ldst_req),
		.oEXE_PAGEFAULT(),
		.oEXE_MMU_FLAGS(),
		.oEXE_DATA(ldst2alu3_ldst_data),
		//Exception Module
		.iEXCEPT_REQ(exception2ldst_ldst_req),
		.oEXCEPT_BUSY(ldst2exception_ldst_busy),
		.iEXCEPT_ORDER(exception2ldst_ldst_order),	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.iEXCEPT_RW(exception2ldst_ldst_rw),		//0=Read 1=Write
		.iEXCEPT_TID(exception2ldst_ldst_tid),
		.iEXCEPT_MMUMOD(exception2ldst_ldst_mmumod),
		.iEXCEPT_PDT(exception2ldst_ldst_pdt),
		.iEXCEPT_ADDR(exception2ldst_ldst_addr),
		.iEXCEPT_DATA(exception2ldst_ldst_data),
		.oEXCEPT_REQ(ldst2exception_ldst_req),
		.oEXCEPT_DATA(ldst2exception_ldst_data)
	);
	

						
endmodule


`default_nettype wire


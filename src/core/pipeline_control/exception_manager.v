/****************************************
Exception Manager
	
	
	Make	:	2010/12/07
	Update	:		
****************************************/

//Forced to exit and microcode branch instruction is executed.


`include "core.h"
`include "global.h"
`default_nettype none

/**********Main State**********/
`define		STT_MAIN_IDLE			3'h0
`define		STT_MAIN_ALU_BRANCH		3'h1
`define		STT_MAIN_AUTO_CTXT_SW	3'h2
`define		STT_MAIN_IRQ_SET		3'h3
`define		STT_MAIN_IRQ_RET		3'h4
`define		STT_MAIN_IDTR_SET		3'h5

/**********Sub State**********/
//Core Branch
`define		STT_SUB_ALU_BRANCH_COMMIT_WAIT				3'h0
//Auto Context Switch 
`define		STT_SUB_AUTO_TSW_COMMIT_WAIT				3'h0
`define		STT_SUB_AUTO_TSW_STORE_MCODE				3'h1
`define		STT_SUB_AUTO_TSW_STORE_COMMIT_WAIT			3'h2
`define		STT_SUB_AUTO_TSW_SRCTHASK_MCODE				3'h3
`define		STT_SUB_AUTO_TSW_SRCTHASK_COMMIT_WAIT		3'h4
`define		STT_SUB_AUTO_TSW_LOAD_MCODE					3'h5	
`define		STT_SUB_AUTO_TSW_LOAD_COMMIT_WAIT			3'h6
//IRQ_SET
`define		STT_SUB_SET_IRQ_CORE_FREE_REQ				3'h0
`define		STT_SUB_SET_IRQ_VECTOR_LOAD_REQ				3'h1
`define		STT_SUB_SET_IRQ_VECTOR_LOAD_GETWAIT			3'h2
`define		STT_SUB_SET_IRQ_USER_SPR_WRITE				3'h3
`define		STT_SUB_SET_IRQ_KERNEL_SPR_REQ				3'h4
`define		STT_SUB_SET_IRQ_KERNEL_SPR_GETWAIT			3'h5
`define		STT_SUB_SET_IRQ_JUMP_HUNDLER				3'h6	
//IRQ_RET
`define		STT_SUB_RET_IRQ_COMMIT_WAIT					3'h0
`define		STT_SUB_RET_IRQ_KERNEL_SPR_WRITE			3'h1
`define		STT_SUB_RET_IRQ_USER_SPR_REQ				3'h2
`define		STT_SUB_RET_IRQ_USER_SPR_GETWAIT			3'h3
`define		STT_SUB_RET_IRQ_JUMP_PPCR					3'h4

//IDTR Set
`define		STT_SUB_SET_IDTR_COMMIT_WAIT				3'h0
`define		STT_SUB_SET_IDTR_LOAD_IDT_REQ				3'h1
`define		STT_SUB_SET_IDTR_LOAD_IDT_GETWAIT			3'h2

/**********Fetch Re-Start Mode**********/
`define		FETCH_NORMAL_MODE							2'h0
`define		FETCH_SET_IRQ_MODE							2'h1
`define		FETCH_RET_IRQ_MODE							2'h2

/**********Microcode Size**********/
`define		CONTEXT_STORE_MCODE_SIZE			32'h10
`define		CONTEXT_LOAD_MCODE_SIZE				32'h10
`define		TASK_SEARCH_MCODE_SIZE				32'h10
`define		GET_HUNDLE_MCODE_SIZE				32'h10


/**********IDT Set State**********/
`define		IDT_STT_REQ_WAIT		1'h0
`define		IDT_STT_LOAD			1'h1

`define		KSPR_STT_REQ_WAIT		1'b0
`define		KSPR_STT_LOAD			1'b1

`define		USPR_STT_REQ_WAIT		1'b0
`define		USPR_STT_LOAD			1'b1


module exception_manager(
		input wire iCLOCK,
		input wire inRESET,
		/*********************************
		Core
		*********************************/
		//Commit & Regist Info
		input wire [5:0] iCOREINFO_COMMIT_COUNTER,
		input wire iCOREINFO_EXCEPTION_PROTECT,	
		//Scheduler1
		input wire [31:0] iCOREINFO_CURRENT_PC,
		//Free
		output wire oCOREINFO_FREE_INST_DISCARD,
		output wire oCOREINFO_FREE_EVENT,
		output wire [5:0] oCOREINFO_FREE_COMMIT_TAG,
		output wire oCOREINFO_FREE_ADDR_SET,
		output wire [31:0] oCOREINFO_FREE_ADDR,
		output wire oCOREINFO_FREE_RESTART,
		output wire [31:0] oCOREINFO_FREE_CURRENT_PC,
		output wire oCOREINFO_FREE_SET_IRQ_MODE,
		output wire oCOREINFO_FREE_CLR_IRQ_MODE,
		//output wire [31:0] oCOREINFO_FREE_NEW_PSR,	
		output wire oCOREINFO_FREE_NEW_SPR_VALID,	
		output wire [31:0] oCOREINFO_FREE_NEW_SPR,
		//Order
		output wire oCOREINFO_MCODE0_VALID,
		output wire [31/*mitei*/:0] oCOREINFO_MCODE0,
		output wire oCOREINFO_MCODE1_VALID,
		output wire [31/*mitei*/:0] oCOREINFO_MCODE1,
		input wire iCODEINFO_MCODE_LOCK,
		//System Register Info
		input wire [31:0] iCOREINFO_SYSREG_IDTR,
		input wire [31:0] iCOREINFO_SYSREG_TISR,
		input wire [31:0] iCOREINFO_SYSREG_TIDR,
		input wire [31:0] iCOREINFO_SYSREG_PSR,
		input wire [31:0] iCOREINFO_SYSREG_PPSR,
		input wire [31:0] iCOREINFO_SYSREG_PPCR,
		input wire [31:0] iCOREINFO_SYSREG_SPR,
		//IO Port
		output wire oLDST_USE,
		output wire oLDST_REQ,
		input wire iLDST_BUSY,
		output wire [1:0] oLDST_ORDER,	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		output wire oLDST_RW,		//0=Read 1=Write
		output wire [13:0] oLDST_TID,
		output wire [1:0] oLDST_MMUMOD,
		output wire [31:0] oLDST_PDT,
		output wire [31:0] oLDST_ADDR,
		output wire [31:0] oLDST_DATA,
		input wire iLDST_REQ,
		input wire [31:0] iLDST_DATA,
		/*********************************
		Interrupt Configlation
		*********************************/	
		//GCI Interrupt Configlation Table
		output wire oIO_IRQ_CONFIG_TABLE_REQ,
		output wire [5:0] oIO_IRQ_CONFIG_TABLE_ENTRY,
		output wire oIO_IRQ_CONFIG_TABLE_FLAG_MASK,
		output wire oIO_IRQ_CONFIG_TABLE_FLAG_VALID,	
		output wire [1:0] oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL,	
		//Interrupt COnfiglation Table
		output wire oICT_REQ,
		output wire [5:0] oICT_ENTRY,
		output wire oICT_CONF_MASK,
		output wire oICT_CONF_VALID,	
		output wire [1:0] oICT_CONF_LEVEL,	
		/*********************************
		Exeption Source
		*********************************/
		//ALU Branch
		input wire iALU_BRANCH_REQ,
		input wire [31:0] iALU_BRANCH_ADDR,
		input wire [5:0] iALU_BRANCH_COMMIT_TAG,
		//IRQ-Ret
		input wire iALU_INTRET_REQ,
		input wire [31:0] iALU_INTRET_ADDR,
		input wire [5:0] iALU_INTRET_COMMIT_TAG,
		//IDT Set
		input wire iIDT_SET_REQ,
		input wire [31:0] iIDT_SET_R_ADDR,
		input wire [5:0] iIDT_SET_COMMIT_TAG,
		input wire [31:0] iIDT_SET_IDTR,
		//Hardware Task Switch
		input wire iHW_TS_REQ,
		input wire [31:0] iHW_TS_ADDR,
		output wire oHW_TS_BUSY,
		//IRQ-Set
		input wire iIRQ_REQ,
		input wire [6:0] iIRQ_NUM,
		output wire oIRQ_ACK,
		output wire oIRQ_BUSY
	);
	

	//Main State
	reg [2:0] b_main_state;
	reg [2:0] b_sub_state;
	reg [2:0] b_req_state;
	reg [31:0] b_branch_addr;
	reg [5:0] b_restart_commit_tag;
	reg b_fetch_restart;
	reg [1:0] b_fetch_restart_mode;
	reg [31:0] b_microcode_addr;
	reg b_new_spr_write_req;
	reg [31:0] b_new_spr;
	reg b_idt_read_req;
	reg b_inthundl_read_req;
	reg b_kspr_read_req;
	reg b_uspr_read_req;
	reg b_spr_mem_write_req;
	reg [31:0] b_spr_mem_write_addr;
	reg [31:0] b_spr_mem_write_spr;
	reg [6:0] b_irq_num;
	//IDT Read State
	reg [6:0] b_idt_read_counter;
	reg [6:0] b_idt_get_counter;
	reg b_idt_readend;
	reg b_idt_read_state;
	reg b_idt_idt_data_valid;
	reg [31:0] b_idt_idt_data;
	wire [31:0] idt_read_addr = iCOREINFO_SYSREG_IDTR + {b_idt_get_counter, 3'h0};
	wire idt_read_condition = (b_idt_read_state == `IDT_STT_LOAD) && (b_idt_read_counter < (7'd64 + 7'h1)) && !iLDST_BUSY;
	//Hundler Get
	wire [31:0] inthundle_read_addr = iCOREINFO_SYSREG_IDTR + {b_irq_num, 3'h0} + 32'h4;
	reg b_inthundl_read_state;
	reg b_inthundl_read;
	reg b_inthundl_readend;
	reg [31:0] b_inthundl_idt_data;
	//Kernel Spr Read	
	reg b_kspr_read_state;
	reg b_kspr_read;
	reg b_kspr_readend;
	reg [31:0] b_kspr_idt_data;
	wire [31:0] kspr_read_addr = iCOREINFO_SYSREG_TISR + {iCOREINFO_SYSREG_TIDR[13:0], 8'h0} + `TST_KSPR;
	//User Spr Read
	reg b_uspr_read_state;
	reg b_uspr_read;
	reg b_uspr_readend;
	reg [31:0] b_uspr_idt_data;
	wire [31:0] uspr_read_addr = iCOREINFO_SYSREG_TISR + {iCOREINFO_SYSREG_TIDR[13:0], 8'h0} + `TST_USPR;	
	//Debug
	reg	[31:0] b_debug_branch_counter;	
	//Lock
	wire microcode_request_lock_cc = iCODEINFO_MCODE_LOCK;
	wire exception_request_lock_cc = iCOREINFO_EXCEPTION_PROTECT && (b_main_state != `STT_MAIN_IDLE);
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_main_state <= `STT_MAIN_IDLE;
			b_sub_state <= 3'h0;
			b_fetch_restart <= 1'b0;
			b_microcode_addr <= 32'h0;
			b_new_spr_write_req <= 1'b0;
			b_spr_mem_write_req <= 1'b0;
			if(`PROCESSOR_DATA_RESET_EN)begin		
				b_debug_branch_counter <= 32'h0;				//debug
				b_req_state <= `STT_MAIN_IDLE;
				b_branch_addr <= {32{1'b0}};
				b_restart_commit_tag <= 6'h0;
				b_new_spr <= {32{1'b0}};
				b_fetch_restart_mode <= `FETCH_NORMAL_MODE;
				b_spr_mem_write_addr <= 32'h0;
				b_spr_mem_write_spr <= 32'h0;
			end
			b_idt_read_req <= 1'b0;
			b_inthundl_read_req <= 1'b0;
			b_kspr_read_req <= 1'b0;
			b_irq_num	 <= 7'h00;
		end
		else begin
			case(b_main_state)
				`STT_MAIN_IDLE:
					begin
						b_fetch_restart <= 1'b0;
						b_new_spr_write_req <= 1'b0;
						b_sub_state <= 3'h0;
						b_spr_mem_write_req <= 1'b0;
						//Core Branch
						if(iALU_BRANCH_REQ)begin
							b_main_state <= `STT_MAIN_ALU_BRANCH;
							b_req_state <= `STT_MAIN_ALU_BRANCH;	
							b_branch_addr <= iALU_BRANCH_ADDR;
							b_restart_commit_tag <= iALU_BRANCH_COMMIT_TAG;
							b_fetch_restart_mode <= `FETCH_NORMAL_MODE;
							b_debug_branch_counter <= 32'h1 + b_debug_branch_counter;				//debug
						end
						//IDTR SET
						else if(iIDT_SET_REQ)begin
							b_main_state <= `STT_MAIN_IDTR_SET;
							b_req_state <= `STT_MAIN_IDTR_SET;
							b_branch_addr <= iIDT_SET_R_ADDR;
							b_restart_commit_tag <= iIDT_SET_COMMIT_TAG;
							b_fetch_restart_mode <= `FETCH_RET_IRQ_MODE;
						end
						//IRQ-Ret
						else if(iALU_INTRET_REQ)begin
							b_main_state <= `STT_MAIN_IRQ_RET;
							b_req_state <= `STT_MAIN_IRQ_RET;	
							b_restart_commit_tag <= iALU_INTRET_COMMIT_TAG;
							b_fetch_restart_mode <= `FETCH_RET_IRQ_MODE;
						end
						//Hardware Task Switch
						else if(iHW_TS_REQ && !exception_request_lock_cc)begin
							b_main_state <= `STT_MAIN_AUTO_CTXT_SW;
							b_req_state <= `STT_MAIN_AUTO_CTXT_SW;
						end
						//IRQ-Set
						else if(iIRQ_REQ && !exception_request_lock_cc)begin
							b_main_state <= `STT_MAIN_IRQ_SET;
							b_req_state <= `STT_MAIN_IRQ_SET;
							b_fetch_restart_mode <= `FETCH_SET_IRQ_MODE;
							b_irq_num <= iIRQ_NUM;
							b_restart_commit_tag <= iCOREINFO_COMMIT_COUNTER;
						end
					end
				`STT_MAIN_ALU_BRANCH:
					begin
						case(b_sub_state)
							`STT_SUB_ALU_BRANCH_COMMIT_WAIT:
								begin
									if(iCOREINFO_COMMIT_COUNTER == b_restart_commit_tag)begin
										b_main_state <= `STT_MAIN_IDLE;
										b_sub_state <= 3'h0;	
										b_fetch_restart <= 1'b1;
										b_fetch_restart_mode <= `FETCH_NORMAL_MODE;
									end
								end
							default:
								begin
									$display("ERROR : exception_manager.v STT_MAIN_ALU_BRANCH->b_sub_state Error");
									b_sub_state <= `STT_SUB_ALU_BRANCH_COMMIT_WAIT;
								end
						endcase
					end
				`STT_MAIN_IRQ_SET:
					begin
						case(b_sub_state)
							`STT_SUB_SET_IRQ_CORE_FREE_REQ:
								begin
									if(!iCOREINFO_EXCEPTION_PROTECT)begin
										b_sub_state <= `STT_SUB_SET_IRQ_VECTOR_LOAD_REQ;	
									end
								end
							`STT_SUB_SET_IRQ_VECTOR_LOAD_REQ:
								begin
									b_inthundl_read_req <= 1'b1;
									b_sub_state <= `STT_SUB_SET_IRQ_VECTOR_LOAD_GETWAIT;	
								end
							`STT_SUB_SET_IRQ_VECTOR_LOAD_GETWAIT:
								begin
									b_inthundl_read_req <= 1'b0;
									//Next Condition Check
									if(b_inthundl_readend)begin	
										b_branch_addr <= b_inthundl_idt_data;
										if(iCOREINFO_SYSREG_PSR[6:5] == `CORE_MODE_KERNEL)begin
											//Hundler Jump
											b_sub_state <= `STT_SUB_SET_IRQ_JUMP_HUNDLER;
										end
										else begin
											//Kernel SPR Read
											b_sub_state <= `STT_SUB_SET_IRQ_USER_SPR_WRITE;	
										end
									end
								end
							`STT_SUB_SET_IRQ_USER_SPR_WRITE:
								begin
									if(!iLDST_BUSY)begin
										b_sub_state <= `STT_SUB_SET_IRQ_KERNEL_SPR_REQ;
										b_spr_mem_write_req <= 1'b1;
										b_spr_mem_write_addr <= iCOREINFO_SYSREG_TISR + {iCOREINFO_SYSREG_TIDR[13:0], 8'h0} + `TST_USPR;
										b_spr_mem_write_spr <= iCOREINFO_SYSREG_SPR;
									end
								end
							`STT_SUB_SET_IRQ_KERNEL_SPR_REQ:
								begin
									b_spr_mem_write_req <= 1'b0;
									b_kspr_read_req <= 1'b1;
									b_sub_state <= `STT_SUB_SET_IRQ_KERNEL_SPR_GETWAIT;	
								end
							`STT_SUB_SET_IRQ_KERNEL_SPR_GETWAIT:
								begin
									b_kspr_read_req <= 1'b0;
									if(b_kspr_readend)begin
										b_sub_state <= `STT_SUB_SET_IRQ_JUMP_HUNDLER;	
										b_new_spr_write_req <= 1'b1;
										b_new_spr <= b_kspr_idt_data;
									end
								end
							`STT_SUB_SET_IRQ_JUMP_HUNDLER:
								begin
									b_main_state <= `STT_MAIN_IDLE;
									b_sub_state <= 3'h0;	
									b_fetch_restart <= 1'b1;
									b_fetch_restart_mode <= `FETCH_SET_IRQ_MODE;
								end
							default:
								begin
									//$display("ERROR : exception_manager.v STT_MAIN_IRQ_SET->b_sub_state Error :b_sub_state = %x", b_sub_state);
									b_sub_state <= `STT_SUB_SET_IRQ_CORE_FREE_REQ;
								end
						endcase
					end
				`STT_MAIN_IRQ_RET:
					begin
						case(b_sub_state)
							`STT_SUB_RET_IRQ_COMMIT_WAIT:
								begin
									if(iCOREINFO_COMMIT_COUNTER == b_restart_commit_tag)begin
										b_branch_addr <= iCOREINFO_SYSREG_PPCR;
										if(iCOREINFO_SYSREG_PPSR[6:5] == `CORE_MODE_USER)begin
											b_sub_state <= `STT_SUB_RET_IRQ_KERNEL_SPR_WRITE;	
										end
										else begin
											b_sub_state <= `STT_SUB_RET_IRQ_JUMP_PPCR;
										end
									end
								end
							//spr set check
							`STT_SUB_RET_IRQ_KERNEL_SPR_WRITE:
								begin
									if(!iLDST_BUSY)begin
										b_sub_state <= `STT_SUB_RET_IRQ_USER_SPR_REQ;
										b_spr_mem_write_req <= 1'b1;
										b_spr_mem_write_addr <= iCOREINFO_SYSREG_TISR + {iCOREINFO_SYSREG_TIDR[13:0], 8'h0} + `TST_KSPR;
										b_spr_mem_write_spr <= iCOREINFO_SYSREG_SPR;
									end
								end
							`STT_SUB_RET_IRQ_USER_SPR_REQ:
								begin
									b_spr_mem_write_req <= 1'b0;
									b_uspr_read_req <= 1'b1;
									b_sub_state <= `STT_SUB_RET_IRQ_USER_SPR_GETWAIT;	
								end
							`STT_SUB_RET_IRQ_USER_SPR_GETWAIT:
								begin
									b_uspr_read_req <= 1'b0;
									if(b_uspr_readend)begin
										b_sub_state <= `STT_SUB_RET_IRQ_JUMP_PPCR;	
										b_new_spr_write_req <= 1'b1;
										b_new_spr <= b_uspr_idt_data;
									end
								end
							`STT_SUB_RET_IRQ_JUMP_PPCR:
								begin
									b_main_state <= `STT_MAIN_IDLE;
									b_sub_state <= 3'h0;	
									b_fetch_restart <= 1'b1;
									b_fetch_restart_mode <= `FETCH_RET_IRQ_MODE;
								end
							default:
								begin
									$display("ERROR : exception_manager.v STT_MAIN_IRQ_RET->b_sub_state Error");
									b_sub_state <= `STT_SUB_RET_IRQ_COMMIT_WAIT;
								end
						endcase
					end
				`STT_MAIN_IDTR_SET:
					begin
						case(b_sub_state)
							`STT_SUB_SET_IDTR_COMMIT_WAIT:
								begin
									if(iCOREINFO_COMMIT_COUNTER == b_restart_commit_tag)begin
										b_sub_state <= `STT_SUB_SET_IDTR_LOAD_IDT_REQ;
									end
								end
							`STT_SUB_SET_IDTR_LOAD_IDT_REQ:
								begin
									b_sub_state <= `STT_SUB_SET_IDTR_LOAD_IDT_GETWAIT;
									b_idt_read_req <= 1'b1;
								end
							`STT_SUB_SET_IDTR_LOAD_IDT_GETWAIT:
								begin
									b_idt_read_req <= 1'b0;
									if(b_idt_readend)begin
										b_main_state <= `STT_MAIN_IDLE;
										b_sub_state <= 3'h0;	
										b_fetch_restart <= 1'b1;
										b_fetch_restart_mode <= `FETCH_NORMAL_MODE;
									end
								end
						endcase
					end
			endcase
		end
	end
	

	/****************************************
	IDT Read
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_idt_read_state <= `IDT_STT_REQ_WAIT;
			b_idt_read_counter <= 7'h0;
			b_idt_get_counter <= 7'h0;
			b_idt_readend <= 1'b0;
			b_idt_idt_data_valid <= 1'b0;
			b_idt_idt_data <= {32{1'b0}};
		end
		else begin
			case(b_idt_read_state)
				`IDT_STT_REQ_WAIT:
					begin
						if(b_idt_read_req)begin
							b_idt_read_state <= `IDT_STT_LOAD;
							b_idt_read_counter <= 7'h0;
							b_idt_get_counter <= 7'h0;
						end
						b_idt_readend <= 1'b0;
						b_idt_idt_data_valid <= 1'b0;
						b_idt_idt_data <= {32{1'b0}};
					end
				`IDT_STT_LOAD:
					begin
						if(b_idt_read_counter < 7'd64 + 7'h1)begin
							//Request Check
							if(!iLDST_BUSY)begin
								b_idt_read_counter <= b_idt_read_counter + 7'h1;
							end
						end
						//Get Check
						if(b_idt_get_counter < 7'd64 + 7'h1)begin
							if(iLDST_REQ)begin
								b_idt_get_counter <= b_idt_get_counter + 7'h1;
								b_idt_idt_data_valid <= iLDST_REQ;
								b_idt_idt_data <= iLDST_DATA;
							end
						end
						else begin
							b_idt_readend <= 1'b1;		
							b_idt_read_state <= `IDT_STT_REQ_WAIT;
						end
					end
			endcase
		end
	end
	

	/****************************************
	Interrupt Hundler Get
	****************************************/	
	`define		INTHUNDL_STT_REQ_WAIT		1'b0
	`define		INTHUNDL_STT_LOAD			1'b1

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_inthundl_read_state <= `INTHUNDL_STT_REQ_WAIT;
			b_inthundl_read <= 1'b0;
			b_inthundl_readend <= 1'b0;
			b_inthundl_idt_data <= 32'h0;
		end
		else begin
			case(b_inthundl_read_state)
				`INTHUNDL_STT_REQ_WAIT:
					begin
						if(b_inthundl_read_req)begin
							b_inthundl_read_state <= `INTHUNDL_STT_LOAD;
							b_inthundl_read <= 1'b1;
						end
						else begin
							b_inthundl_read <= 1'b0;
						end
						b_inthundl_readend <= 1'b0;
					end
				`INTHUNDL_STT_LOAD:
					begin
						//Read Request
						if(!iLDST_BUSY && b_inthundl_read)begin
							b_inthundl_read <= 1'b0;
						end
						//Get Check
						if(iLDST_REQ)begin
							b_inthundl_readend <= 1'b1;
							b_inthundl_read_state <= `INTHUNDL_STT_REQ_WAIT;
							b_inthundl_idt_data <= iLDST_DATA;
						end
					end
			endcase
		end
	end
	
	
	
	
	/****************************************
	Kernel Spr Read
	****************************************/	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_kspr_read_state <= `KSPR_STT_REQ_WAIT;
			b_kspr_read <= 1'b0;
			b_kspr_readend <= 1'b0;
			b_kspr_idt_data <= 32'h0;
		end
		else begin
			case(b_kspr_read_state)
				`KSPR_STT_REQ_WAIT:
					begin
						if(b_kspr_read_req)begin
							b_kspr_read_state <= `KSPR_STT_LOAD;
							b_kspr_read <= 1'b1;
						end
						else begin
							b_kspr_read <= 1'b0;
						end
						b_kspr_readend <= 1'b0;
						b_kspr_idt_data <= {32{1'b0}};
					end
				`KSPR_STT_LOAD:
					begin
						//Read Request
						if(!iLDST_BUSY && b_kspr_read)begin
							b_kspr_read <= 1'b0;
						end
						//Get Check
						if(iLDST_REQ)begin
							b_kspr_readend <= 1'b1;
							b_kspr_read_state <= `KSPR_STT_REQ_WAIT;
							b_kspr_idt_data <= iLDST_DATA;
						end
					end
			endcase
		end
	end
	

	
	/****************************************
	User Spr Read
	****************************************/	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_uspr_read_state <= `USPR_STT_REQ_WAIT;
			b_uspr_read <= 1'b0;
			b_uspr_readend <= 1'b0;
			b_uspr_idt_data <= 32'h0;
		end
		else begin
			case(b_uspr_read_state)
				`USPR_STT_REQ_WAIT:
					begin
						if(b_uspr_read_req)begin
							b_uspr_read_state <= `USPR_STT_LOAD;
							b_uspr_read <= 1'b1;
						end
						else begin
							b_uspr_read <= 1'b0;
						end
						b_uspr_readend <= 1'b0;
						b_uspr_idt_data <= {32{1'b0}};
					end
				`USPR_STT_LOAD:
					begin
						//Read Request
						if(!iLDST_BUSY && b_uspr_read)begin
							b_uspr_read <= 1'b0;
						end
						//Get Check
						if(iLDST_REQ)begin
							b_uspr_readend <= 1'b1;
							b_uspr_read_state <= `USPR_STT_REQ_WAIT;
							b_uspr_idt_data <= iLDST_DATA;
						end
					end
			endcase
		end
	end
	
	
	
	/********************************************************************
	Micro Code
	********************************************************************/
	//Damy
	assign		oCOREINFO_MCODE0_VALID = 1'b0;
	assign		oCOREINFO_MCODE0	 = {32{1'b0}};
	assign		oCOREINFO_MCODE1_VALID = 1'b0;
	assign		oCOREINFO_MCODE1	 = {32{1'b0}};
	
	/********************************************************************
	Load Store 
	********************************************************************/
	assign		oLDST_USE			 = (b_main_state != `STT_MAIN_IDLE) || iALU_BRANCH_REQ || iIDT_SET_REQ;
	assign		oLDST_REQ			 = (b_main_state != `STT_MAIN_IDLE) && (b_main_state != `STT_MAIN_ALU_BRANCH) && !iLDST_BUSY && (b_uspr_read || b_kspr_read || b_inthundl_read || idt_read_condition || b_spr_mem_write_req);
	assign		oLDST_ORDER			 = 2'b10;//Word Order
	assign		oLDST_RW			 = b_spr_mem_write_req;
	assign		oLDST_TID			 = iCOREINFO_SYSREG_TIDR[13:0];
	assign		oLDST_MMUMOD		 = 2'h0;
	assign		oLDST_PDT			 = 32'h0;
	assign		oLDST_ADDR			 = (b_uspr_read)? uspr_read_addr : (
															(b_kspr_read)? kspr_read_addr : (
																(b_inthundl_read)? inthundle_read_addr : (
																	(idt_read_condition)? idt_read_addr : b_spr_mem_write_addr
																)
															)
														);
	assign		oLDST_DATA			 = b_spr_mem_write_spr;	
	
	/********************************************************************
	GCI-Interrupt Configlation Table
	********************************************************************/
	assign		oIO_IRQ_CONFIG_TABLE_REQ = b_idt_idt_data_valid;
	assign		oIO_IRQ_CONFIG_TABLE_ENTRY = b_idt_get_counter[5:0] - 6'h1;
	assign		oIO_IRQ_CONFIG_TABLE_FLAG_MASK = b_idt_idt_data[1];
	assign		oIO_IRQ_CONFIG_TABLE_FLAG_VALID	=		b_idt_idt_data[0];
	assign		oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL	=		b_idt_idt_data[17:16];
	
	/********************************************************************
	Core-Interrupt Configlation Table
	********************************************************************/
	assign		oICT_REQ = b_idt_idt_data_valid;
	assign		oICT_ENTRY = b_idt_get_counter[5:0] - 6'h1;
	assign		oICT_CONF_MASK = b_idt_idt_data[1];
	assign		oICT_CONF_VALID = b_idt_idt_data[0];
	assign		oICT_CONF_LEVEL = b_idt_idt_data[17:16];
	

	/********************************************************************
	Core Free
	********************************************************************/	
	assign		oCOREINFO_FREE_NEW_SPR_VALID	=		b_new_spr_write_req;
	assign		oCOREINFO_FREE_NEW_SPR = b_new_spr;
	
	assign		oCOREINFO_FREE_SET_IRQ_MODE = (b_fetch_restart_mode == `FETCH_SET_IRQ_MODE)? b_fetch_restart : 1'b0;
	assign		oCOREINFO_FREE_CLR_IRQ_MODE = (b_fetch_restart_mode == `FETCH_RET_IRQ_MODE)? b_fetch_restart : 1'b0; 
	
	assign		oCOREINFO_FREE_INST_DISCARD = (b_main_state != `STT_MAIN_IDLE)? /*1'b1*/(
															(b_main_state == `STT_MAIN_IRQ_SET && b_sub_state == `STT_SUB_SET_IRQ_CORE_FREE_REQ)? !iCOREINFO_EXCEPTION_PROTECT : 1'b1) : 
															b_main_state == `STT_MAIN_IRQ_SET && b_sub_state == `STT_SUB_SET_IRQ_CORE_FREE_REQ && !iCOREINFO_EXCEPTION_PROTECT;//(b_main_state != `STT_MAIN_IDLE)? 1'b1 : 1'b0;
	assign		oCOREINFO_FREE_EVENT = (
															(b_main_state == `STT_MAIN_IDLE && (iALU_BRANCH_REQ || iALU_INTRET_REQ || iIDT_SET_REQ || (iIRQ_REQ && !iCOREINFO_EXCEPTION_PROTECT) || iHW_TS_REQ)) || 
															(b_main_state == `STT_MAIN_IRQ_SET && b_sub_state == `STT_SUB_SET_IRQ_CORE_FREE_REQ && !iCOREINFO_EXCEPTION_PROTECT) || 
															(b_main_state == `STT_MAIN_IRQ_RET && b_sub_state == `STT_SUB_RET_IRQ_COMMIT_WAIT) || 
															(b_main_state == `STT_MAIN_IDTR_SET && b_sub_state == `STT_SUB_SET_IDTR_COMMIT_WAIT)
														);
														/*!iCOREINFO_EXCEPTION_PROTECT && (
															(b_main_state == `STT_MAIN_IDLE && (iALU_BRANCH_REQ || iALU_INTRET_REQ || iIDT_SET_REQ || iIRQ_REQ || iHW_TS_REQ)) || 
															(b_main_state == `STT_MAIN_IRQ_SET && b_sub_state == `STT_SUB_SET_IRQ_CORE_FREE_REQ) || 
															(b_main_state == `STT_MAIN_IRQ_RET && b_sub_state == `STT_SUB_RET_IRQ_COMMIT_WAIT) || 
															(b_main_state == `STT_MAIN_IDTR_SET && b_sub_state == `STT_SUB_SET_IDTR_COMMIT_WAIT)
														);*/
	assign		oCOREINFO_FREE_COMMIT_TAG = (b_main_state == `STT_MAIN_IDLE && iALU_BRANCH_REQ)? iALU_BRANCH_COMMIT_TAG : b_restart_commit_tag;
	assign		oCOREINFO_FREE_ADDR_SET = b_fetch_restart;
	assign		oCOREINFO_FREE_ADDR	 = b_branch_addr;
	assign		oCOREINFO_FREE_RESTART = b_fetch_restart;
	assign		oCOREINFO_FREE_CURRENT_PC = iCOREINFO_CURRENT_PC;
	
	/********************************************************************
	Interrupt
	********************************************************************/	
	assign		oHW_TS_BUSY			 = 1'b0;
	assign		oIRQ_ACK			 = (b_fetch_restart_mode == `FETCH_SET_IRQ_MODE)? b_fetch_restart : 1'b0;	//(b_main_state == `STT_MAIN_IRQ_SET && b_sub_state == `STT_SUB_SET_IRQ_JUMP_HUNDLER)? 1'b1 : 1'b0;	
	assign		oIRQ_BUSY			 = (b_main_state != `STT_MAIN_IDLE)? 1'b1 : 1'b0;
	
	
endmodule



`default_nettype wire 



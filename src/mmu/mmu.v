/****************************************
Memory Management Unit
	- MMU V1
	- 1page = 16KB
****************************************/
`default_nettype none
`include "processor.h"



module mmu(			
		//System
		input wire iCLOCK,
		input wire inRESET,
		//TLB Flash
		input wire iTLB_FLASH,
		/***********************
		Logic Addres Request
		***********************/
		input wire iLOGIC_REQ,
		output wire oLOGIC_LOCK,
		input wire iLOGIC_DATA_STORE_ACK,
		input wire [1:0] iLOGIC_MODE,		//0=NoConvertion 1=none 2=1LevelConvertion 3=2LevelConvertion
		input wire [31:0] iLOGIC_PDT,		//Page Directory Table 
		input wire [1:0] iLOGIC_ORDER,
		input wire [3:0] iLOGIC_MASK,
		input wire iLOGIC_RW,				//0=Read 1=Write
		input wire [31:0] iLOGIC_ADDR,
		input wire [31:0] iLOGIC_DATA,		
		/***********************
		MMU Flags Output
		***********************/
		output wire oMMUFLAGS_REQ,
		input wire iMMUFLAGS_LOCK,
		output wire [27:0] oMMUFLAGS_FLAGS,		
		/***********************
		Page Fault
		***********************/
		output wire oPAGEFAULT_VALID,
		/***********************
		To Memory
		***********************/
		output wire oMEMORY_REQ,
		input wire iMEMORY_LOCK,			
		output wire oMEMORY_DATA_STORE_ACK,
		output wire oMEMORY_MMU_USE,
		output wire [1:0] oMEMORY_ORDER,
		output wire [3:0] oMEMORY_MASK,
		output wire oMEMORY_RW,
		output wire [31:0] oMEMORY_ADDR,
		output wire [31:0] oMEMORY_DATA,
		//Data RAM -> This
		input wire iMEMORY_VALID,
		output wire oMEMORY_LOCK,
		input wire [63:0] iMEMORY_DATA
	);

	
	localparam MAIN_STT_CACHE = 3'h0;
	//localparam MAIN_STT_PDR_MEM = 3'h1
	localparam MAIN_STT_1ST_MEM	= 3'h2;
	localparam MAIN_STT_2ST_MEM	= 3'h3;
	localparam MAIN_STT_REQ_MEM	= 3'h4;

	localparam SUB_STT_REQ = 1'h0;
	localparam SUB_STT_GET = 1'h1;

	
	/************************************************************
	Wire and Register
	************************************************************/
	//MMU Main State
	reg [1:0] b_main_state;
	reg b_invalid_page;
	//Memory Selector Line
	wire matching_bridge_full;
	wire matching_bridge_valid;
	//Busy Controll
	wire cache_request_busy;
	//TLB Check
	wire tlb_rd_valid;
	wire tlb_rd_hit;
	wire [27:0] tlb_rd_flags;
	wire [63:0] tlb_rd_physical_addr;
	//Input Buffer
	reg b_req;
	reg b_data_store_ack;
	reg [1:0] b_order;
	reg [3:0] b_mask;
	reg b_rw;
	reg [31:0] b_pdt;
	reg [1:0] b_mode;
	reg [31:0] b_logic_addr;
	reg [31:0] b_data;


	
	/************************************************************
	State & Latch
	************************************************************/	
	//Condition
	wire mmu_memory_ls_valid = tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0;
	
	//Request Latch
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_req <= 1'b0;
			b_data_store_ack <= 1'b0;
			b_order <= 2'h0;
			b_mask <= 4'h0;
			b_rw <= 1'b0;
			b_mode <= 2'h0;
			b_pdt <= {32{1'b0}};
			b_logic_addr <= {32{1'b0}};
			b_data <= {32{1'b0}};
		end
		else begin
			if(!cache_request_busy && !iMEMORY_LOCK)begin
				b_req <= iLOGIC_REQ;
				b_data_store_ack <= iLOGIC_DATA_STORE_ACK;
				b_order <= iLOGIC_ORDER;
				b_mask <= iLOGIC_MASK;
				b_rw <= iLOGIC_RW;
				b_mode <= iLOGIC_MODE;
				b_pdt <= iLOGIC_PDT;
				b_logic_addr <= iLOGIC_ADDR;
				b_data <= iLOGIC_DATA;
			end
		end
	end
	
	//Memory Read State
	localparam L_PARAM_MMU_LS_IDLE = 2'h0;
	localparam L_PARAM_MMU_LS_LDREQ = 2'h1;
	localparam L_PARAM_MMU_LS_GETWAIT = 2'h2;
	
	reg [1:0] b_mmu_ls_state;
	reg [31:0] b_mmu_ls_req_addr;
	reg [63:0] b_mmu_ls_get_data; 
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_mmu_ls_state <= L_PARAM_MMU_LS_IDLE;
			b_mmu_ls_req_addr <= 32'h0;
			b_mmu_ls_get_data <= 64'h0;
		end
		else begin
			case(b_mmu_ls_state)
				L_PARAM_MMU_LS_IDLE:
					begin
						if(mmu_memory_ls_valid)begin
							b_mmu_ls_state <= L_PARAM_MMU_LS_LDREQ;
							//Load Address
							case(b_main_state)
								MAIN_STT_1ST_MEM : 
									begin
										if(b_mode == 2'h1)begin
											b_mmu_ls_req_addr <= {b_pdt[31:14], 14'h0} + {b_logic_addr[31:14], 2'h0};
										end
										else begin
											b_mmu_ls_req_addr <= {b_pdt[31:14], 14'h0} + {b_logic_addr[31:23], 2'h0};
										end
									end
								MAIN_STT_2ST_MEM : 
									begin
										if(!b_logic_addr[2])begin
											b_mmu_ls_req_addr <= {b_mmu_ls_get_data[31:14], 14'h0} + {b_logic_addr[22:14], 2'h0};
										end
										else begin
											b_mmu_ls_req_addr <= {b_mmu_ls_get_data[63:46], 14'h0} + {b_logic_addr[22:14], 2'h0};
										end
									end
								MAIN_STT_REQ_MEM : 
									begin
										if(!b_logic_addr[2])begin
											b_mmu_ls_req_addr <= {b_mmu_ls_get_data[31:14], b_logic_addr[22:14]};
										end
										else begin
											b_mmu_ls_req_addr <= {b_mmu_ls_get_data[63:46], b_logic_addr[22:14]};
										end
									end
							endcase
							b_mmu_ls_get_data <= 64'h0;
						end
						else begin
							b_mmu_ls_state <= L_PARAM_MMU_LS_IDLE;
							b_mmu_ls_req_addr <= 32'h0;
						end
					end
				L_PARAM_MMU_LS_LDREQ:
					begin
						if(!iMEMORY_LOCK)begin
							b_mmu_ls_state <= L_PARAM_MMU_LS_GETWAIT;
						end
					end
				L_PARAM_MMU_LS_GETWAIT:
					begin
						if(iMEMORY_VALID)begin
							b_mmu_ls_state <= L_PARAM_MMU_LS_IDLE;
							b_mmu_ls_get_data <= iMEMORY_DATA;
						end
					end
				default: //ERROR
					begin
						b_mmu_ls_state <= L_PARAM_MMU_LS_IDLE;
					end
			endcase
		end
	end
	
	
	//Main State
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_main_state <= MAIN_STT_CACHE;
			b_invalid_page <= 1'b0;
		end
		else begin
			case(b_main_state)
				MAIN_STT_CACHE:
					begin
						b_invalid_page <= 1'b0;
						if(mmu_memory_ls_valid)begin
							b_main_state <= MAIN_STT_1ST_MEM;
						end
					end
				MAIN_STT_1ST_MEM:
					begin
						if(b_mmu_ls_state == L_PARAM_MMU_LS_GETWAIT && iMEMORY_VALID)begin
							//Page Fault Check
							if(!b_logic_addr[2] && !iMEMORY_DATA[0] || b_logic_addr[2] && !iMEMORY_DATA[32])begin
								b_main_state <= MAIN_STT_CACHE;
								b_invalid_page <= 1'b1;
							end
							else begin
								if(b_mode == 2'h1)begin
									b_main_state <= MAIN_STT_CACHE;
								end
								else begin
									b_main_state <= MAIN_STT_REQ_MEM;
								end
							end
						end
					end
				MAIN_STT_2ST_MEM:
					begin
						if(b_mmu_ls_state == L_PARAM_MMU_LS_GETWAIT && iMEMORY_VALID)begin
							//Page Fault Check
							if(!b_logic_addr[2] && !iMEMORY_DATA[0] || b_logic_addr[2] && !iMEMORY_DATA[32])begin
								b_main_state <= MAIN_STT_CACHE;
								b_invalid_page <= 1'b1;
							end
							else begin
								b_main_state <= MAIN_STT_REQ_MEM;
							end
						end
					end
				MAIN_STT_REQ_MEM:	
					begin
						if(b_mmu_ls_state == L_PARAM_MMU_LS_GETWAIT && iMEMORY_VALID)begin
							b_main_state <= MAIN_STT_CACHE;
						end
					end
			endcase
		end
	end
	
	//TLB Write Condition
	reg tlb_write_condition;
	always @* begin
		if(b_mode != 2'h0)begin
			//Memory Load Check
			if(b_mmu_ls_state == L_PARAM_MMU_LS_GETWAIT && iMEMORY_VALID)begin
				//Pagind Mode Check
				if(b_mode == 2'h1)begin
					tlb_write_condition = 1'b1;
				end
				else if(b_mode == 2'h2 && b_main_state == MAIN_STT_2ST_MEM)begin
					tlb_write_condition = 1'b1;
				end
				else begin
					tlb_write_condition = 1'b0;
				end
			end
			else begin
				tlb_write_condition = 1'b0;
			end
		end
		else begin
			tlb_write_condition = 1'b0;
		end
	end
	
	/************************************************************
	Matching Bridge
	************************************************************/	
	//Matching Bridge 
	mist1032sa_arbiter_matching_queue #(16, 4, 1) MMU_MATCHING_BRIDGE(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Flash
		.iFLASH(iTLB_FLASH),
		//Write
		.iWR_REQ(tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0),
		.iWR_FLAG(1'b0),
		.oWR_FULL(matching_bridge_full),
		//Read
		.iRD_REQ(tlb_write_condition),
		.oRD_VALID(matching_bridge_valid),
		.oRD_FLAG(/* Not Use */),
		.oRD_EMPTY(/* Not Use */)
	);
	
	
	/************************************************************
	Busy Controll
	************************************************************/
	assign cache_request_busy = (tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0) || b_main_state != MAIN_STT_CACHE;
	
	/************************************************************
	TLB Check
	************************************************************/	
	tlb #(/*LRU Timing N*/10) TLB(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Core Info
		.iREMOVE(iTLB_FLASH/* Context Switch */),			
		//Read
		.iRD_REQ(iLOGIC_REQ && !cache_request_busy),
		.iRD_ADDR(iLOGIC_ADDR),	
		.oRD_VALID(tlb_rd_valid),
		.oRD_HIT(tlb_rd_hit),
		.oRD_FLAGS(tlb_rd_flags),
		.oRD_PHYS_ADDR(tlb_rd_physical_addr),
		//Write
		.iWR_REQ(tlb_write_condition && matching_bridge_valid),
		.iWR_ADDR(b_logic_addr),
		.iWR_FLAGS({iMEMORY_DATA[45:32], iMEMORY_DATA[13:0]}),
		.iWR_PHYS_ADDR(iMEMORY_DATA[63:0])	
	);
	
	
	/*************************************************************
	Assign
	*************************************************************/
	assign oMEMORY_LOCK = 1'b0;
	
	assign oLOGIC_LOCK = iMEMORY_LOCK || iMMUFLAGS_LOCK || (b_main_state != MAIN_STT_CACHE)? 1'b1 : (tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0);
	
	assign oMMUFLAGS_REQ = (tlb_rd_hit && tlb_rd_valid && b_mode != 2'h0) || (b_main_state == MAIN_STT_REQ_MEM) && (b_mmu_ls_state == L_PARAM_MMU_LS_LDREQ);
	assign oMMUFLAGS_FLAGS = (tlb_rd_hit && tlb_rd_valid && b_mode != 2'h0)? tlb_rd_flags : (
								(b_logic_addr[2])? b_mmu_ls_get_data[45:32] : b_mmu_ls_get_data[13:0]
							);	
	
	assign oPAGEFAULT_VALID = b_invalid_page;
	
	assign oMEMORY_REQ = (b_req && b_mode == 2'h0) || (tlb_rd_hit && tlb_rd_valid && b_mode != 2'h0)  || (b_mmu_ls_state == L_PARAM_MMU_LS_LDREQ);
	assign oMEMORY_DATA_STORE_ACK = b_data_store_ack;
	assign oMEMORY_MMU_USE = (b_mode == 2'h0)? 1'b0 : 1'b1;
	assign oMEMORY_ORDER = (b_main_state == MAIN_STT_REQ_MEM || b_mode == 2'h0)? b_order : 2'h2;
	assign oMEMORY_MASK = (b_main_state == MAIN_STT_REQ_MEM || b_mode == 2'h0)? b_mask : 4'hf;
	assign oMEMORY_RW = (b_main_state == MAIN_STT_REQ_MEM || b_mode == 2'h0)? b_rw : 1'b0;
	assign oMEMORY_DATA = b_data;
	reg [31:0] memory_addr;
	always @* begin
		if(tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0)begin
			memory_addr = (b_logic_addr[14])? tlb_rd_physical_addr[63:32] + b_logic_addr[13:0] : tlb_rd_physical_addr[31:0] + b_logic_addr[13:0];
		end
		else if(b_mmu_ls_state == L_PARAM_MMU_LS_LDREQ) begin
			memory_addr = b_mmu_ls_req_addr;
		end
		else begin
			memory_addr = b_logic_addr;
		end
	end	
	assign oMEMORY_ADDR = memory_addr;
	
	
endmodule

`default_nettype wire


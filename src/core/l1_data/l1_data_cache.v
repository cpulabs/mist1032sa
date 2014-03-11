
//`include "processor.h"
`default_nettype none
`include "common.h"

module l1_data_cache(
		input wire iCLOCK,
		input wire inRESET,
		//Remove
		input wire iREMOVE,
		input wire iCACHE_FLASH,
		//IOSR
		input wire iSYSINFO_IOSR_VALID,
		input wire [31:0] iSYSINFO_IOSR,
		/****************************************
		Load/Store Module
		****************************************/
		//Load Store -> Cache
		input wire iLDST_REQ,
		output wire oLDST_BUSY,
		input wire [1:0] iLDST_ORDER,
		input wire [3:0] iLDST_MASK,
		input wire iLDST_RW,
		input wire [31:0] iLDST_TID,
		input wire [1:0] iLDST_MMUMOD,
		input wire [31:0] iLDST_PDT,
		input wire [31:0] iLDST_ADDR,
		input wire [31:0] iLDST_DATA,
		//Cache -> Load Store
		output wire oLDST_VALID,
		output wire oLDST_PAGEFAULT,
		output wire [13:0] oLDST_MMU_FLAGS,
		output wire [31:0] oLDST_DATA,
		/****************************************
		Data Memory
		****************************************/
		//Req
		output wire oDATA_REQ,
		input wire iDATA_LOCK,
		output wire [1:0] oDATA_ORDER,
		output wire [3:0] oDATA_MASK,		//	
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
		input wire [27:0] iDATA_MMU_FLAGS,
		input wire [63:0] iDATA_DATA,
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
		input wire [31:0] iIO_DATA		
	);
	
	//IO Start Address Buffer
	reg b_io_startaddr_valid;
	reg [31:0] b_io_startaddr;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_io_startaddr_valid <= 1'b0;	
			b_io_startaddr <= {32{1'b0}};
		end
		else begin
			`ifdef MIST1032SA_IOSTART_ADDR_OPTION
				b_io_startaddr_valid <= 1'b1;
				b_io_startaddr <= `MIST1032SA_IOSTART_ADDR_OPTION;
			`else
				if(iSYSINFO_IOSR_VALID)begin
					b_io_startaddr_valid <= 1'b1;
					b_io_startaddr <= iSYSINFO_IOSR;
				end
			`endif
		end
	end
	
	
	wire data_request_lock = iDATA_LOCK;
	wire io_request_lock = iIO_BUSY;
	
	wire data_request = iLDST_REQ && !(iLDST_ADDR >= b_io_startaddr);
	wire io_request = iLDST_REQ && (iLDST_ADDR >= b_io_startaddr);
	
	
	/****************************************
	Instruction Access 
	****************************************/
	localparam L_PARAM_IDLE = 3'h0;
	localparam L_PARAM_MEMREQ = 3'h1;
	localparam L_PARAM_MEMGET = 3'h2;
	localparam L_PARAM_OUTDATA = 3'h3;
	localparam L_PARAM_WR_MEMREQ = 3'h4;
	localparam L_PARAM_WR_MEMGET = 3'h5;
	localparam L_PARAM_WR_OUTDATA = 3'h6;
	
	//Controlor
	reg [2:0] b_req_main_state;
	reg [3:0] b_req_state;
	reg [3:0] b_get_state;
	reg b_req_valid;
	reg [1:0] b_req_order;
	reg [3:0] b_req_mask;
	reg b_req_rw;
	reg [13:0] b_req_tid;
	reg [1:0] b_req_mmumod;
	reg [31:0] b_req_pdt;
	reg [31:0] b_req_addr;
	reg [31:0] b_req_data;
	
	reg [31:0] b_mem_result_data;
	reg [13:0] b_mem_result_mmu_flags; 
	
	//Cache
	reg b_cache_req_valid;
	reg [1:0] b_cache_req_order;
	reg [3:0] b_cache_req_mask;
	reg b_cache_req_rw;
	reg [13:0] b_cache_req_tid;
	reg [1:0] b_cache_req_mmumod;
	reg [31:0] b_cache_req_pdt;
	reg [31:0] b_cache_req_addr;
	reg [31:0] b_cache_req_data;
	reg [511:0] b_cache_result_data;
	reg [255:0] b_cache_result_mmu_flags;
	reg b_pagefault;

	
	wire cache_req_busy;
	wire cache_result_valid;
	wire cache_result_hit;
	wire [31:0] cache_result_data;
	wire [13:0] cache_result_mmu_flags;
	
	
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_req_main_state <= 3'b0;
			b_req_state <= 4'h0;
			b_get_state <= 4'h0;
			b_req_valid <= 1'b0;
			b_req_order <= 2'h0;
			b_req_mask <= 4'h0;
			b_req_rw <= 12'b0;
			b_req_tid <= 14'h0;
			b_req_mmumod <= 2'h0;
			b_req_pdt <= 32'h0;
			b_req_addr <= {32{1'b0}};
			b_req_data <= 32'h0;
			b_mem_result_data <= 32'h0;
			b_mem_result_mmu_flags <= 14'h0; 
			//Cache
			b_cache_req_valid <= 1'b0;
			b_cache_req_order <= 2'h0;
			b_cache_req_mask <= 4'h0;
			b_cache_req_rw <= 1'b0;
			b_cache_req_tid <= 14'h0;
			b_cache_req_mmumod <= 2'h0;
			b_cache_req_pdt <= 32'h0;
			b_cache_req_addr <= 32'h0;
			b_cache_req_data <= 32'h0;
			b_cache_result_data <= 512'h0;
			b_cache_result_mmu_flags <= 256'h0;
			b_pagefault <= 1'b0;
		end	
		else begin
			//Memory State
			case(b_req_main_state) 
				L_PARAM_IDLE:	//Idle
					begin
						//Read
						if(cache_result_valid && !cache_result_hit)begin
							b_req_main_state <= L_PARAM_MEMREQ;
						end
						//Write
						else if(b_cache_req_rw && /*b_req_valid*/b_cache_req_valid)begin
							b_req_main_state <= L_PARAM_WR_MEMREQ;
						end
						
						if(!data_request_lock && data_request && !cache_req_busy)begin
							b_cache_req_valid <= iLDST_REQ;
							b_cache_req_order <= iLDST_ORDER;
							b_cache_req_mask <= iLDST_MASK;
							b_cache_req_rw <= iLDST_RW;
							b_cache_req_tid <= iLDST_TID;
							b_cache_req_mmumod <= iLDST_MMUMOD;
							b_cache_req_pdt <= iLDST_PDT;
							b_cache_req_addr <= iLDST_ADDR;
							b_cache_req_data <= iLDST_DATA;
						end
						
						
						b_req_valid <= b_cache_req_valid;
						b_req_order <= b_cache_req_order;
						b_req_mask <= b_cache_req_mask;
						b_req_rw <= b_cache_req_rw;
						b_req_tid <= b_cache_req_tid;
						b_req_mmumod <= b_cache_req_mmumod;
						b_req_pdt <= b_cache_req_pdt;
						b_req_addr <= b_cache_req_addr;
						b_req_data <= b_cache_req_data;
						b_pagefault <= 1'b0;
					end
				L_PARAM_MEMREQ:	//Request State
					begin
						//Cache ON
						`ifdef MIST1032SA_DATA_L1_CACHE
							if(iDATA_VALID && iDATA_PAGEFAULT)begin
								//Pagefault
								b_req_state <= 4'h0;
								b_req_main_state <= L_PARAM_OUTDATA;
								b_pagefault <= 1'b1;
							end
							//IO Address Check			--iranai?
							else if(b_io_startaddr-32'h4 <= {b_req_addr[31:6], b_req_state[2:0], 3'h0})begin
								b_req_main_state <= L_PARAM_MEMGET;
								b_req_state <= 4'h0;
							end
							//Next State Check
							else if(b_req_state == 4'h7 && !data_request_lock)begin
								b_req_main_state <= L_PARAM_MEMGET;
								b_req_state <= 4'h0;
							end
							//Request
							else if(!data_request_lock) begin
								b_req_state <= b_req_state + 4'h1;
							end	
							//Get Check
							if(iDATA_VALID)begin
								b_get_state <= b_get_state + 4'h1;
								b_cache_result_data <= {iDATA_DATA, b_cache_result_data[511:64]};
								b_cache_result_mmu_flags <= {2'h0, iDATA_MMU_FLAGS[27:14], 2'h0, iDATA_MMU_FLAGS[13:0], b_cache_result_mmu_flags[255:31]};
								if(b_req_addr[5:3] == b_get_state[3:0])begin
									if(!b_req_addr[2])begin
										b_mem_result_data <= iDATA_DATA[31:0];
										b_mem_result_mmu_flags <= iDATA_MMU_FLAGS[13:0];
									end
									else begin
										b_mem_result_data <= iDATA_DATA[63:32];
										b_mem_result_mmu_flags <= iDATA_MMU_FLAGS[27:14];
									end
								end
							end
						//Cache OFF
						`else
							if(!data_request_lock)begin
								b_req_main_state <= L_PARAM_MEMGET;
								b_req_state <= 4'h0;
							end
						`endif
					end
				L_PARAM_MEMGET:	//Get Wait State
					begin
						//Cache ON
						`ifdef MIST1032SA_DATA_L1_CACHE
							if(iDATA_VALID)begin
								//Latch Data
								b_cache_result_data <= {iDATA_DATA, b_cache_result_data[511:64]};
								b_cache_result_mmu_flags <= {2'h0, iDATA_MMU_FLAGS[27:14], 2'h0, iDATA_MMU_FLAGS[13:0], b_cache_result_mmu_flags[255:31]};
								if(b_req_addr[5:3] == b_get_state[3:0])begin
									if(!b_req_addr[2])begin
										b_mem_result_data <= iDATA_DATA[31:0];
										b_mem_result_mmu_flags <= iDATA_MMU_FLAGS[13:0];
									end
									else begin
										b_mem_result_data <= iDATA_DATA[63:32];
										b_mem_result_mmu_flags <= iDATA_MMU_FLAGS[27:14];
									end
								end
								//State Check
								if(iDATA_VALID && iDATA_PAGEFAULT)begin
									//Pagefault
									b_get_state <= 4'h0;
									b_req_main_state <= L_PARAM_OUTDATA;
									b_pagefault <= 1'b1;
								end
								if(b_get_state == 4'h7)begin
									b_get_state <= 4'h0;
									b_req_main_state <= L_PARAM_OUTDATA;
								end
								//IO Address Check			--iranai?
								else if(b_io_startaddr-32'h4 <= {b_req_addr[31:6], b_get_state[2:0], 3'h0})begin
									b_get_state <= 4'h0;
									b_req_main_state <= L_PARAM_OUTDATA;
								end
								else begin
									b_get_state <= b_get_state + 4'h1;
								end
							end
						`else
						//Cache OFF
							if(iDATA_VALID)begin
								b_get_state <= 4'h0;
								b_pagefault <= iDATA_PAGEFAULT;
								b_req_main_state <= L_PARAM_OUTDATA;
								if(!b_req_addr[2])begin
									b_mem_result_data <= iDATA_DATA[31:0];
									b_mem_result_mmu_flags <= iDATA_MMU_FLAGS[13:0];
								end
								else begin
									b_mem_result_data <= iDATA_DATA[63:32];
									b_mem_result_mmu_flags <= iDATA_MMU_FLAGS[27:14];
								end
							end
						`endif
					end
				L_PARAM_OUTDATA:
					begin
						b_req_main_state <= L_PARAM_IDLE;
						b_req_valid <= 1'b0;
						b_cache_req_valid <= 1'b0;
					end
				//Write
				L_PARAM_WR_MEMREQ:
					begin
						if(!data_request_lock)begin
							b_req_main_state <= L_PARAM_WR_MEMGET;
						end
					end
				L_PARAM_WR_MEMGET:
					begin
						if(iDATA_VALID)begin
							b_req_main_state <= L_PARAM_WR_OUTDATA;
						end
					end
				L_PARAM_WR_OUTDATA:
					begin
						b_req_main_state <= L_PARAM_IDLE;
						b_req_valid <= 1'b0;
						b_cache_req_valid <= 1'b0;
					end
			endcase
		end	
	end
	
	/*
	//Cache Hit Counter
	wire [6:0] cache_hit_counter;
	l1_data_cache_counter L1_CACHE_HIT_COUNTER(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Hit Infomation
		.iCACHE_VALID(cache_result_valid),
		.iCACHE_HIT(cache_result_hit),
		//Infomation
		.oINFO_COUNT(cache_hit_counter)
	);
	*/
	

	
	`ifdef MIST1032SA_DATA_L1_CACHE
		l1_data_cache_64entry_4way_line64b_bus_8b CACHE_MODULE(
			/********************************
			System
			********************************/
			.iCLOCK(iCLOCK),
			.inRESET(inRESET),
			//Remove
			.iREMOVE(iCACHE_FLASH),
			/********************************
			Search
			********************************/
			//Search Request 
			.iRD_REQ((b_req_main_state == L_PARAM_IDLE) && !data_request_lock && data_request && !iLDST_RW),
			.oRD_BUSY(cache_req_busy),		
			.iRD_ADDR({iLDST_ADDR[31:2], 2'h0}),		//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
			//Search Output Result
			.oRD_VALID(cache_result_valid),
			.oRD_HIT(cache_result_hit),
			.iRD_BUSY(b_req_main_state != L_PARAM_IDLE),	
			.oRD_DATA(cache_result_data),
			.oRD_MMU_FLAGS(cache_result_mmu_flags),	
			/********************************
			Upload
			********************************/
			.iUP_REQ((b_req_main_state == L_PARAM_WR_MEMREQ) && !data_request_lock),
			.oUP_BUSY(),
			.iUP_ORDER(b_req_order),
			.iUP_MASK(b_req_mask),
			.iUP_ADDR(b_req_addr),				
			.iUP_DATA(b_req_data),
			/********************************
			Write Request
			********************************/
			.iWR_REQ((b_req_main_state == L_PARAM_OUTDATA) && !b_pagefault),
			.oWR_BUSY(),
			.iWR_ADDR({b_req_addr[31:6], 6'h0}),	//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
			.iWR_DATA(b_cache_result_data),
			.iWR_MMU_FLAGS(b_cache_result_mmu_flags)
		);
	`else
		l1_data_cache_64entry_4way_line64b_bus_8b_damy CACHE_MODULE_DAMY(
			/********************************
			System
			********************************/
			.iCLOCK(iCLOCK),
			.inRESET(inRESET),
			//Remove
			.iREMOVE(iCACHE_FLASH),
			/********************************
			Search
			********************************/
			//Search Request 
			.iRD_REQ((b_req_main_state == L_PARAM_IDLE) && !data_request_lock && data_request && !iLDST_RW),
			.oRD_BUSY(cache_req_busy),		
			.iRD_ADDR({iLDST_ADDR[31:3], 3'h0}),		//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
			//Search Output Result
			.oRD_VALID(cache_result_valid),
			.oRD_HIT(cache_result_hit),
			.iRD_BUSY(b_req_main_state != L_PARAM_IDLE),	
			.oRD_DATA(cache_result_data),
			.oRD_MMU_FLAGS(cache_result_mmu_flags),	
			/********************************
			Upload
			********************************/
			.iUP_REQ((b_req_main_state == L_PARAM_WR_MEMREQ) && !data_request_lock),
			.oUP_BUSY(),
			.iUP_ORDER(b_req_order),
			.iUP_MASK(b_req_mask),
			.iUP_ADDR(b_req_addr),				
			.iUP_DATA(b_req_data),
			/********************************
			Write Request
			********************************/
			.iWR_REQ(1'b0),
			.oWR_BUSY(),
			.iWR_ADDR(32'h0),	//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
			.iWR_DATA({512{1'b0}}),
			.iWR_MMU_FLAGS(256'h000000)
		);
	`endif
				

	reg next_data_valid;
	reg [31:0] next_data_data;
	reg [13:0] next_data_mmu_flags;
	always @* begin
		if(b_req_main_state == L_PARAM_OUTDATA || b_req_main_state == L_PARAM_WR_OUTDATA)begin
			next_data_valid = 1'b1;
			next_data_data = b_mem_result_data;
			next_data_mmu_flags = b_mem_result_mmu_flags;
		end
		else begin
			next_data_valid = cache_result_valid && cache_result_hit;
			next_data_data = cache_result_data;
			next_data_mmu_flags = cache_result_mmu_flags;
		end
	end
	
	/*************************
	Outpu Assign
	*************************/
	//Memory
	assign oDATA_REQ = (b_req_main_state == L_PARAM_MEMREQ) || (b_req_main_state == L_PARAM_WR_MEMREQ);
	assign oDATA_ORDER = b_req_order;
	assign oDATA_MASK = b_req_mask;
	assign oDATA_RW = (b_req_main_state == L_PARAM_MEMREQ)? b_req_rw : 1'b1;
	assign oDATA_TID = b_req_tid;
	assign oDATA_MMUMOD = b_req_mmumod;
	assign oDATA_PDT = b_req_pdt;

		
	`ifdef MIST1032SA_DATA_L1_CACHE
		//Cache ON
		assign oDATA_ADDR = (b_req_main_state == L_PARAM_WR_MEMREQ)? b_req_addr : {b_req_addr[31:6], b_req_state[2:0], 3'h0};
	`else
		//Cache OFF
		assign oDATA_ADDR = (b_req_main_state == L_PARAM_WR_MEMREQ)? b_req_addr : {b_req_addr[31:3], 1'b0, b_req_addr[1:0]};
	`endif
	assign oDATA_DATA = b_req_data;
	
	assign oLDST_BUSY = !b_io_startaddr_valid || data_request_lock || io_request_lock || cache_req_busy || (b_req_main_state != L_PARAM_IDLE) || (cache_result_valid && !cache_result_hit);
	
	//IO
	assign oIO_REQ = io_request;
	assign oIO_ORDER = 2'h2;
	assign oIO_RW = iLDST_RW;			//0=Write 1=Read
	assign oIO_ADDR = iLDST_ADDR - b_io_startaddr;
	//Write
	assign oIO_DATA = iLDST_DATA;
	
	//This -> Load Store Module
	assign oLDST_VALID = next_data_valid || iIO_VALID;
	assign oLDST_PAGEFAULT = b_pagefault;
	assign oLDST_MMU_FLAGS = next_data_mmu_flags;
	assign oLDST_DATA = (iIO_VALID)? iIO_DATA : next_data_data;
	
endmodule


`default_nettype wire


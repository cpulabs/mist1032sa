/****************************************
	MIST1032 - Core
	
	Version	:	A0001
	Make	:	2011/01/20
	Update	:	2011/12/21
	
	Include file
		- core_info.h
		
	Update Histry
		2011/12/21 - IO Connect
		2011/01/20 - Make
****************************************/
`default_nettype none
`include "global.h"


`define		INST_STT_IDLE			2'h0
`define		INST_STT_CACHE_CHECK	2'h1
`define		INST_STT_MEM_REQUEST	2'h2
`define		INST_STT_MEM_GETWAIT	2'h3


module core
	#(
		parameter		CORE_ID		=	32'h0
	)(
		/****************************************
		System
		****************************************/
		input					iCLOCK,
		input					inRESET,	
		/****************************************
		Core
		****************************************/
		output					oCORE_FLASH,
		/****************************************
		GCI Controll
		****************************************/
		//Interrupt Controll
		output					oIO_IRQ_CONFIG_TABLE_REQ,
		output	[5:0]			oIO_IRQ_CONFIG_TABLE_ENTRY,
		output					oIO_IRQ_CONFIG_TABLE_FLAG_MASK,
		output					oIO_IRQ_CONFIG_TABLE_FLAG_VALID,
		output	[1:0]			oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL,		
		/****************************************
		Instruction Memory
		****************************************/
		//Req
		output					oINST_REQ,
		input					iINST_LOCK,
		output	[13:0]			oINST_TID,
		output	[1:0]			oINST_MMUMOD,
		output	[31:0]			oINST_PDT,
		output	[31:0]			oINST_ADDR,
		//This -> Data RAM
		//output	[31:0]			oINST_DATA,
		//Data RAM -> This
		input					iINST_VALID,
		output					oINST_BUSY,		//new
		input	[63:0]			iINST_DATA,
		input	[11:0]			iINST_MMU_FLAGS,
		/****************************************
		Data Memory
		****************************************/
		//Req
		output					oDATA_REQ,
		input					iDATA_LOCK,
		output	[1:0]			oDATA_ORDER,
		output					oDATA_RW,		//0=Write 1=Read
		output	[13:0]			oDATA_TID,
		output	[1:0]			oDATA_MMUMOD,
		output	[31:0]			oDATA_PDT,
		output	[31:0]			oDATA_ADDR,
		//This -> Data RAM
		output	[31:0]			oDATA_DATA,
		//Data RAM -> This
		input					iDATA_VALID,
		input	[63:0]			iDATA_DATA,
		/****************************************
		IO
		****************************************/
		//Req
		output					oIO_REQ,
		input					iIO_BUSY,
		output	[1:0]			oIO_ORDER,
		output					oIO_RW,			//0=Write 1=Read
		output	[31:0]			oIO_ADDR,
		//Write
		output	[31:0]			oIO_DATA,
		//Rec
		input					iIO_VALID,
		input	[31:0]			iIO_DATA,
		/****************************************
		Interrupt
		****************************************/
		input					iINTERRUPT_VALID,
		output					oINTERRUPT_ACK,
		input	[5:0]			iINTERRUPT_NUM,
		/****************************************
		System Infomation
		****************************************/
		input					iSYSINFO_IOSR_VALID,
		input	[31:0]			iSYSINFO_IOSR
	);
		
		
	
	wire			inst_fetch2cache_request_lock_cc;
	wire			inst_cache2memory_request_lock_cc;
	wire			inst_cache_mem2fetch_request_lock_cc;
				
	/************************************************************************************
	Wire and Register
	************************************************************************************/		
	//IO Start Address Buffer
	reg				b_io_startaddr_valid;
	reg		[31:0]	b_io_startaddr;
	//Load State 
	reg				b_ldst_state;
	reg				b_ldst_type;	//0:IO | 1:DATA
	//Core Info
	wire			core_flash;
	//Instruction
	wire			core2inst_fetch_req;
	wire	[13:0]	core2inst_fetch_tid;
	wire	[1:0]	core2inst_fetch_mmumod;
	wire	[31:0]	core2inst_fetch_pdt;
	wire	[31:0]	core2inst_fetch_addr;
	wire			core2inst_fetch_busy;
	//Load Store
	wire			core2ldst_req;
	wire	[1:0]	core2ldst_order;
	wire			core2ldst_rw;
	wire	[13:0]	core2ldst_tid;
	wire	[1:0]	core2ldst_mmumod;
	wire	[31:0]	core2ldst_pdt;
	wire	[31:0]	core2ldst_addr;
	wire	[31:0]	core2ldst_data;
	//Instruction Cache
	wire			inst_l1_cache_rd_lock;
	wire			inst_l1_cache_rd_valid;
	wire			inst_l1_cache_rd_hit;
	wire	[63:0]	inst_l1_cache_rd_data;
	wire	[11:0]	inst_l1_cache_rd_mmuflags;		
	wire			inst_l1_cache_wr_lock;
	//Instruction Memory Acess Controllor
	reg				b_inst_mem_state;
	reg		[31:0]	b_inst_core2mem_addr;
	reg		[13:0]	b_inst_core2mem_tid;
	reg		[1:0]	b_inst_core2mem_mmumod;
	reg		[31:0]	b_inst_core2mem_pdt;
	//instruction Memory Matching Bridge
	wire		inst_matching_bridge_full;
	wire		inst_matching_bridge_valid;
	//Data Memory matching Bridge
	wire		dataio_matching_bridge_full;
	wire		dataio_valid;
	
	/************************************************************************************
	Core - Main Pipeline
	************************************************************************************/	
	core_pipeline #(CORE_ID) CORE_PIPELINE(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Core
		.oCORE_FLASH(core_flash),	
		//GCI Interrupt Controll
		//Interrupt Control
		.oIO_IRQ_CONFIG_TABLE_REQ(oIO_IRQ_CONFIG_TABLE_REQ),
		.oIO_IRQ_CONFIG_TABLE_ENTRY(oIO_IRQ_CONFIG_TABLE_ENTRY),
		.oIO_IRQ_CONFIG_TABLE_FLAG_MASK(oIO_IRQ_CONFIG_TABLE_FLAG_MASK),
		.oIO_IRQ_CONFIG_TABLE_FLAG_VALID(oIO_IRQ_CONFIG_TABLE_FLAG_VALID),
		.oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL(oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL),
		//Instruction Memory Request
		.oINST_FETCH_REQ(core2inst_fetch_req),
		.iINST_FETCH_BUSY(inst_fetch2cache_request_lock_cc || b_inst_mem_state || iINST_LOCK),
		.oINST_FETCH_TID(core2inst_fetch_tid),
		.oINST_FETCH_MMUMOD(core2inst_fetch_mmumod),
		.oINST_FETCH_PDT(core2inst_fetch_pdt),
		.oINST_FETCH_ADDR(core2inst_fetch_addr),
		//Instruction Memory Get
		.iINST_VALID0(!inst_cache_mem2fetch_request_lock_cc && ((inst_l1_cache_rd_valid && inst_l1_cache_rd_hit && inst_matching_bridge_valid) || (inst_matching_bridge_valid && b_inst_mem_state && iINST_VALID))),
		.iINST_VALID1(!inst_cache_mem2fetch_request_lock_cc && ((inst_l1_cache_rd_valid && inst_l1_cache_rd_hit && inst_matching_bridge_valid) || (inst_matching_bridge_valid && b_inst_mem_state && iINST_VALID))),
		.iINST_MMU_FLAGS0((b_inst_mem_state)? iINST_MMU_FLAGS[5:0] : inst_l1_cache_rd_mmuflags[5:0]),
		.iINST_MMU_FLAGS1((b_inst_mem_state)? iINST_MMU_FLAGS[11:6] : inst_l1_cache_rd_mmuflags[11:6]),
		.oINST_BUSY(core2inst_fetch_busy),
		.iINST_DATA0((b_inst_mem_state)? iINST_DATA[31:0] : inst_l1_cache_rd_data[31:0]),
		.iINST_DATA1((b_inst_mem_state)? iINST_DATA[63:32] : inst_l1_cache_rd_data[63:32]),
		//Load/Store Access
		.oLDST_REQ(core2ldst_req),
		.iLDST_BUSY(/*iINST_LOCK*/iDATA_LOCK || iIO_BUSY || !b_io_startaddr_valid || b_ldst_state),
		.oLDST_ORDER(core2ldst_order),
		.oLDST_RW(core2ldst_rw),		//0=Read 1=Write
		.oLDST_TID(core2ldst_tid),
		.oLDST_MMUMOD(core2ldst_mmumod),
		.oLDST_PDT(core2ldst_pdt),
		.oLDST_ADDR(core2ldst_addr),
		.oLDST_DATA(core2ldst_data),
		.iLDST_VALID(dataio_valid && (iIO_VALID || iDATA_VALID)),
		.iLDST_DATA((b_ldst_type)? iDATA_DATA[31:0] : iIO_DATA),
		//Interrupt
		.iINTERRUPT_VALID(iINTERRUPT_VALID),
		.oINTERRUPT_ACK(oINTERRUPT_ACK),
		.iINTERRUPT_NUM(iINTERRUPT_NUM),
		.iSYSINFO_IOSR_VALID(iSYSINFO_IOSR_VALID),
		.iSYSINFO_IOSR(iSYSINFO_IOSR)
	);
	
	
	assign			inst_fetch2cache_request_lock_cc		=	inst_matching_bridge_full || iINST_LOCK || inst_l1_cache_rd_lock || (inst_l1_cache_rd_valid && !inst_l1_cache_rd_hit);
	
	assign			inst_cache2memory_request_lock_cc		=	iINST_LOCK;
	
	assign			inst_cache_mem2fetch_request_lock_cc	=	core2inst_fetch_busy || inst_l1_cache_wr_lock || iINST_LOCK;
	
	
	
	/************************************************************************************
	Instruction Pipeline
	************************************************************************************/	
	
	/****************************************
	Instruction Cache
	****************************************/
	l1_cache_512entry_4way_line8b INST_1L_CACHE( 
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Remove
		.iREMOVE(/*Context Switch*/),
		//Search
		.iRD_REQ(core2inst_fetch_req && !inst_fetch2cache_request_lock_cc && !b_inst_mem_state),
		.oRD_BUSY(inst_l1_cache_rd_lock),
		.iRD_ADDR(core2inst_fetch_addr),//core2inst_fetch_addr<<2),
		.oRD_VALID(inst_l1_cache_rd_valid),
		.oRD_HIT(inst_l1_cache_rd_hit),
		.iRD_BUSY(inst_cache_mem2fetch_request_lock_cc),
		.oRD_DATA(inst_l1_cache_rd_data),
		.oRD_MMU_FLAGS(inst_l1_cache_rd_mmuflags),
		//Upload
		.iUP_REQ(1'b0),
		.iUP_ORDER(2'h0),
		.iUP_ADDR(32'h0),
		.iUP_DATA(32'h0),
		.iUP_MMU_FLAGS(6'h0),
		//Write Request
		.iWR_REQ(b_inst_mem_state && !inst_cache_mem2fetch_request_lock_cc && iINST_VALID),
		.oWR_BUSY(inst_l1_cache_wr_lock),
		.iWR_ADDR(b_inst_core2mem_addr/*b_inst_core2mem_addr << 2*/),//b_inst_core2mem_addr<<2),
		.iWR_DATA(iINST_DATA),
		.iWR_MMU_FLAGS(iINST_MMU_FLAGS)
	);
	
	
	
	/****************************************
	Instruction Memory Access Controllir
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_inst_mem_state			<=		1'b0;
			b_inst_core2mem_addr		<=		{32{1'b0}};
			b_inst_core2mem_tid			<=		{14{1'b0}};
			b_inst_core2mem_mmumod		<=		2'h0;
			b_inst_core2mem_pdt			<=		{32{1'b0}};
		end	
		else begin
			//Buffer 
			if(!inst_fetch2cache_request_lock_cc && core2inst_fetch_req && !b_inst_mem_state)begin
				b_inst_core2mem_addr		<=		core2inst_fetch_addr;
				b_inst_core2mem_tid			<=		core2inst_fetch_tid;
				b_inst_core2mem_mmumod		<=		core2inst_fetch_mmumod;
				b_inst_core2mem_pdt			<=		core2inst_fetch_pdt;
			end
			//Memory State
			case(b_inst_mem_state)
				1'b0:
					begin	
						if(inst_l1_cache_rd_valid && !inst_l1_cache_rd_hit && !inst_cache2memory_request_lock_cc)begin
							b_inst_mem_state	<=		1'b1;
						end
					end
				1'h1:
					begin
						if(!inst_cache2memory_request_lock_cc && iINST_VALID)begin
							b_inst_mem_state	<=		1'b0;
						end
					end
			endcase
		end	
	end
	
	
	/****************************************
	Instruction Access Reservation Bridge
	****************************************/	
	//Matching Bridge 
	arbiter_matching_bridge #(16, 4) INST_MATCHING_BRIDGE(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Flash
		.iFLASH(core_flash),
		//Write
		.iWR_REQ(core2inst_fetch_req && !inst_fetch2cache_request_lock_cc && !b_inst_mem_state),
		.iWR_TYPE(1'b0),
		.oWR_FULL(inst_matching_bridge_full),
		//Read
		.iRD_REQ(!inst_cache_mem2fetch_request_lock_cc && ((inst_l1_cache_rd_valid && inst_l1_cache_rd_hit) || (b_inst_mem_state && iINST_VALID))/*(b_inst_mem_state && iINST_VALID && !inst_cache_mem2fetch_request_lock_cc) || (!b_inst_mem_state && !inst_cache_mem2fetch_request_lock_cc && inst_l1_cache_rd_valid && inst_l1_cache_rd_hit)*/),
		.oRD_VALID(inst_matching_bridge_valid),
		.oRD_TYPE(/* Not Use */),
		.oRD_EMPTY(/* Not Use */)
	);
	
	

	
	
	
	
	/************************************************************************************
	Data I/O Pipeline
	************************************************************************************/	
	/*
		//Load/Store Access
		.oLDST_REQ(core2ldst_req),
		.iLDST_BUSY(iDATA_LOCK || iIO_BUSY || !b_io_startaddr_valid || b_ldst_state),
		.oLDST_ORDER(core2ldst_order),
		.oLDST_RW(core2ldst_rw),		//0=Read 1=Write
		.oLDST_TID(core2ldst_tid),
		.oLDST_MMUMOD(core2ldst_mmumod),
		.oLDST_PDT(core2ldst_pdt),
		.oLDST_ADDR(core2ldst_addr),
		.oLDST_DATA(core2ldst_data),
		.iLDST_VALID(iIO_VALID || iDATA_VALID),
		.iLDST_DATA((b_ldst_type)? iDATA_DATA[31:0] : iIO_DATA),
	*/
	
	//Matching Bridge 
	arbiter_matching_bridge #(4, 2) DATA_MATCHING_BRIDGE(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Flash
		.iFLASH(core_flash),
		//Write
		.iWR_REQ(core2ldst_req && !iDATA_LOCK && !iIO_BUSY && b_io_startaddr_valid && !b_ldst_state && !core2ldst_rw),
		.iWR_TYPE(1'b0),
		.oWR_FULL(dataio_matching_bridge_full),
		//Read
		.iRD_REQ(iIO_VALID || iDATA_VALID),
		.oRD_VALID(dataio_valid),
		.oRD_TYPE(/* Not Use */),
		.oRD_EMPTY(/* Not Use */)
	);
	
	
	
	//IO Start Address Buffer
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_io_startaddr_valid	<=		1'b0;	
			b_io_startaddr			<=		{32{1'b0}};
		end
		else begin
			if(iSYSINFO_IOSR_VALID)begin
				b_io_startaddr_valid	<=		1'b1;
				b_io_startaddr			<=		iSYSINFO_IOSR;
			end
		end
	end
	
	//Load State 
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ldst_state		<=		1'h0;
			b_ldst_type			<=		1'b0;
		end
		else begin
			case(b_ldst_state)
				1'h0:
					begin
						if(!iDATA_LOCK && !iIO_BUSY && b_io_startaddr_valid)begin
							if(core2ldst_req && !core2ldst_rw)begin
								b_ldst_state		<=		1'h1;
								b_ldst_type			<=		(core2ldst_addr >= b_io_startaddr)? 1'b0 : 1'b1;
							end
						end
					end
				1'h1:
					begin	
						if(iDATA_VALID || iIO_VALID)begin
							b_ldst_state		<=		1'h0;
						end
					end
			endcase
		end
	end
	
	
	/****************************************
	Assign
	****************************************/
	//Core
	assign		oCORE_FLASH			=		core_flash;
	//Instruction Memory
	assign		oINST_REQ			=		inst_l1_cache_rd_valid && !inst_l1_cache_rd_hit && !iINST_LOCK;
	assign		oINST_TID			=		b_inst_core2mem_tid;
	assign		oINST_MMUMOD		=		b_inst_core2mem_mmumod;
	assign		oINST_PDT			=		b_inst_core2mem_pdt;
	assign		oINST_ADDR			=		b_inst_core2mem_addr;
	assign		oINST_BUSY			=		inst_cache_mem2fetch_request_lock_cc;
	//Data Memory
	assign		oDATA_REQ			=		core2ldst_req && !(core2ldst_addr >= b_io_startaddr);
	assign		oDATA_ORDER			=		core2ldst_order;
	assign		oDATA_RW			=		core2ldst_rw;
	assign		oDATA_TID			=		core2ldst_tid;
	assign		oDATA_MMUMOD		=		core2ldst_mmumod;
	assign		oDATA_PDT			=		core2ldst_pdt;
	assign		oDATA_ADDR			=		core2ldst_addr;
	assign		oDATA_DATA			=		core2ldst_data;
	//IO
	assign		oIO_REQ				=		core2ldst_req && (core2ldst_addr >= b_io_startaddr);
	assign		oIO_ORDER			=		core2ldst_order;
	assign		oIO_RW				=		!core2ldst_rw;
	assign		oIO_ADDR			=		core2ldst_addr - b_io_startaddr;
	assign		oIO_DATA			=		core2ldst_data;
					
endmodule


`default_nettype wire
			
			
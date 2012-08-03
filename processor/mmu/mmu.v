/****************************************
	Memory Management Unit
	- MMU V1
	
	
	Make	:	2011/03/@@
	Update	:	
****************************************/
`default_nettype none		
`include	"global.h"

`define		MAIN_STT_CACHE		2'h0
`define		MAIN_STT_1ST_MEM	2'h1
`define		MAIN_STT_2ST_MEM	2'h2

`define		SUB_STT_REQ			1'h0
`define		SUB_STT_GET			1'h1



module mmu(			
				//System
				input					iCLOCK,
				input					inRESET,
				//TLB Flash
				input					iTLB_FLASH,
				//CORE REGISTER
				input	[1:0]			iCOREINFO_MODE,			//0=NoConvertion 1=none 2=1LevelConvertion 3=2LevelConvertion
				input	[31:0]			iCOREINFO_PDT,			//Page Directory Table 
				input	[13:0]			iCOREINFO_TID,			//Task Id 
				//LOGIC Address Request
				input					iLOGIC_REQ,
				input					iLOGIC_RW,				//0=Read 1=Write
				input					iLOGIC_TYPE,			//0:Data 1:Instruction	
				input	[31:0]			iLOGIC_ADDR,
				output					oLOGIC_LOCK,
				//Physical Output
				output					oPHYSICAL_VALID,
				input					iPHYSICAL_LOCK,
				output	[31:0]			oPHYSICAL_ADDR,
				output	[5:0]			oPHYSICAL_FLAGS,
				//Memory <--->
				//Req
				output					oMEMORY_REQ,
				input					iMEMORY_LOCK,
				output	[31:0]			oMEMORY_ADDR,
				//Data RAM -> This
				input					iMEMORY_VALID,
				output					oMEMORY_LOCK,
				input	[63:0]			iMEMORY_DATA
	);

	/************************************************************
	Wire and Register
	************************************************************/
	reg					physical_out_req;
	reg		[31:0]		physical_out_addr;
	//MMU Main State
	reg		[1:0]		b_main_state;
	reg		[1:0]		b_sub_state;
	reg		[31:0]		b_1l_mem_data;
	reg		[31:0]		b_2l_mem_data;
	reg					b_writeback;
	//TLB Write Condition
	wire				tlb_write_condition;
	//Memory Selector Line
	wire				matching_bridge_full;
	wire				matching_bridge_valid;
	//Busy Controll
	wire				cache_request_busy;
	//TLB Check
	wire				tlb_rd_valid;
	wire				tlb_rd_hit;
	wire	[13:0]		tlb_rd_flags;
	wire	[17:0]		tlb_rd_physical_addr;
	//Input Buffer
	reg					b_req;
	reg					b_rw;
	reg					b_type;
	reg		[31:0]		b_pdt;
	reg		[13:0]		b_tid;
	reg		[1:0]		b_mode;
	reg		[31:0]		b_logic_addr;


	always@* begin
		case(b_mode)
			2'h0:	
				begin
					physical_out_req		=		b_req;
					physical_out_addr		=		b_logic_addr;
				end
			2'h1:
				begin
					physical_out_req		=		b_writeback;
					physical_out_addr		=		{b_1l_mem_data[31:14], b_logic_addr[13:0]};
				end
			2'h2:	
				begin
					physical_out_req		=		b_writeback;
					physical_out_addr		=		{b_2l_mem_data[31:14], b_logic_addr[13:0]};
				end
			default:	
				begin
					physical_out_req		=		b_req;
					physical_out_addr		=		b_logic_addr;
				end
		endcase
	end
	
	
	
	
	
	/************************************************************
	State
	************************************************************/	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_main_state		<=		`MAIN_STT_CACHE;
			b_sub_state			<=		`SUB_STT_REQ;
			b_writeback			<=		1'b0;
			if(`DATA_RESET_ENABLE)begin
				b_1l_mem_data		<=		{32{1'b0}};
				b_2l_mem_data		<=		{32{1'b0}};
			end
		end
		else begin
			case(b_main_state)
				`MAIN_STT_CACHE:
					begin
						b_writeback			<=		1'b0;
						if(tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0)begin
							b_main_state		<=		`MAIN_STT_1ST_MEM;
						end
					end
				`MAIN_STT_1ST_MEM:
					begin
						if(b_sub_state == `SUB_STT_REQ)begin	
							if(!iMEMORY_LOCK)begin
								b_sub_state			<=		`SUB_STT_GET;
							end
						end
						else begin
							if(iMEMORY_VALID && !iPHYSICAL_LOCK)begin
								if(b_mode == 2'h1)begin
									b_main_state		<=		`MAIN_STT_CACHE;
									b_sub_state			<=		`SUB_STT_REQ;
									b_1l_mem_data		<=		(b_pdt[0])? iMEMORY_DATA[63:32] : iMEMORY_DATA[31:0];
									b_writeback			<=		1'b1;
								end
								else begin
									b_main_state		<=		`MAIN_STT_2ST_MEM;
									b_sub_state			<=		`SUB_STT_REQ;
									b_1l_mem_data		<=		(b_pdt[0])? iMEMORY_DATA[63:32] : iMEMORY_DATA[31:0];
								end
							end
						end
					end
				`MAIN_STT_2ST_MEM:
					begin
						if(b_sub_state == `SUB_STT_REQ)begin	
							if(!iMEMORY_LOCK)begin
								b_sub_state			<=		`SUB_STT_GET;
							end
						end
						else begin
							if(iMEMORY_VALID && !iPHYSICAL_LOCK)begin
								b_sub_state			<=		`SUB_STT_REQ;
								b_main_state		<=		`MAIN_STT_CACHE;
								b_2l_mem_data		<=		(b_1l_mem_data[0])? iMEMORY_DATA[63:32] : iMEMORY_DATA[31:0];
								b_writeback			<=		1'b1;
							end
						end
					end
				default:	
					begin
						b_main_state		<=		`MAIN_STT_CACHE;
						$display("[ERRPR] : mmu.v b_main_state Errpr");
					end
			endcase
		end
	end //always State
	
	assign		tlb_write_condition		=	iMEMORY_VALID && (b_mode == 2'h1 && b_main_state == `MAIN_STT_1ST_MEM && b_sub_state == `SUB_STT_GET) || (b_mode == 2'h2 && b_main_state == `MAIN_STT_2ST_MEM && b_sub_state == `SUB_STT_GET);	
	
	
	/************************************************************
	Matching Bridge
	************************************************************/	
	//Matching Bridge 
	arbiter_matching_bridge #(16, 4) MMU_MATCHING_BRIDGE(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Flash
		.iFLASH(iTLB_FLASH),
		//Write
		.iWR_REQ(tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0),
		.iWR_TYPE(1'b0),
		.oWR_FULL(matching_bridge_full),
		//Read
		.iRD_REQ(tlb_write_condition),
		.oRD_VALID(matching_bridge_valid),
		.oRD_TYPE(/* Not Use */),
		.oRD_EMPTY(/* Not Use */)
	);
	
	
	/************************************************************
	Busy Controll
	************************************************************/
	assign		cache_request_busy		=		(tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0) || b_main_state != `MAIN_STT_CACHE;
	
	
	
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
		.iRD_ADDR(iLOGIC_ADDR[31:14]),	//AddressTag:16bit | Index:2bit
		.iRD_TID(iCOREINFO_TID),		//Task ID
		.oRD_VALID(tlb_rd_valid),
		.oRD_HIT(tlb_rd_hit),
		.oRD_FLAGS(tlb_rd_flags),
		.oRD_PHYS_ADDR(tlb_rd_physical_addr),
		//Write
		.iWR_REQ(tlb_write_condition && matching_bridge_valid),
		.iWR_ADDR(b_pdt[31:14]),
		.iWR_TID(b_tid),
		.iWR_FLAGS(iMEMORY_DATA[13:0]),
		.iWR_PHYS_ADDR(iMEMORY_DATA[31:14])	
	);
	
	
	
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_req	<=		1'b0;
			b_rw	<=		1'b0;
			b_typr	<=		1'b0;
			b_pdt	<=		{32{1'b0}};
			b_tid	<=		{14{1'b0}};
			b_mode	<=		2'h0;
			b_logic_addr	<=		{32{1'b0}};
		end
		else begin
			if(iLOGIC_REQ && !cache_request_busy)begin
				b_req	<=		iLOGIC_REQ;
				b_rw	<=		iLOGIC_RW;
				b_type	<=		iLOGIC_TYPE;
				b_mode	<=		iCOREINFO_MODE;
				b_pdt	<=		iCOREINFO_PDT;
				b_tid	<=		iCOREINFO_TID;
				b_logic_addr	<=		iLOGIC_ADDR;
			end
		end
	end
	
	/*************************************************************
	Assign
	*************************************************************/
	assign		oMEMORY_LOCK			=		iPHYSICAL_LOCK;

	assign		oLOGIC_LOCK				=		(b_main_state != `MAIN_STT_CACHE)? 1'b1 : tlb_rd_valid && !tlb_rd_hit && b_mode != 2'h0;
	
	
	assign		oPHYSICAL_VALID			=		physical_out_req;
	assign		oPHYSICAL_ADDR			=		physical_out_addr;
	assign		oPHYSICAL_FLAGS			=		(tlb_rd_hit && tlb_rd_valid)? !tlb_rd_flags[5:0] : b_2l_mem_data[5:0];
	

	
	assign		oMEMORY_REQ				=		(b_main_state == `MAIN_STT_1ST_MEM && b_sub_state == `SUB_STT_REQ) || (b_main_state == `MAIN_STT_2ST_MEM && b_sub_state == `SUB_STT_REQ);
	assign		oMEMORY_ADDR			=		(b_main_state == `MAIN_STT_1ST_MEM)? b_pdt + b_logic_addr[31:23] : b_1l_mem_data + b_logic_addr[22:14];

	
endmodule

`default_nettype wire


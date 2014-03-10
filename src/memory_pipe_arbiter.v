
`default_nettype none

module memory_pipe_arbiter(
		input wire iCLOCK,
		input wire inRESET,
		//Data(Core -> Memory)
		input wire iDATA_REQ,
		output wire oDATA_LOCK,
		input wire [1:0] iDATA_ORDER,
		input wire [3:0] iDATA_MASK,
		input wire iDATA_RW,
		input wire [13:0] iDATA_TID,
		input wire [1:0] iDATA_MMUMOD,
		input wire [31:0] iDATA_PDT,
		input wire [31:0] iDATA_ADDR,
		input wire [31:0] iDATA_DATA,
		//Data(Memory -> Core)
		output wire oDATA_REQ,
		input wire iDATA_BUSY,
		output wire oDATA_PAGEFAULT,	
		output wire [63:0] oDATA_DATA,
		output wire [27:0] oDATA_MMU_FLAGS,
		//Inst(Core -> Memory)
		input wire iINST_REQ,
		output wire oINST_LOCK,
		input wire [1:0] iINST_MMUMOD,
		input wire [31:0] iINST_PDT,
		input wire [31:0] iINST_ADDR,
		//Inst(Memory -> Core)
		output wire oINST_REQ,
		input wire iINST_BUSY,
		output wire oINST_PAGEFAULT,		
		output wire oINST_QUEUE_FLUSH,		
		output wire [63:0] oINST_DATA,
		output wire [27:0] oINST_MMU_FLAGS,
		//Memory(OutPort)
		output wire oMEMORY_REQ,
		input wire iMEMORY_LOCK,
		output wire oMEMORY_DATA_STORE_ACK,			//1:Data Access && Store(MMUFlag read only. Not Memory access.)
		output wire [1:0] oMEMORY_MMU_MODE,
		output wire [31:0] oMEMORY_PDT,
		output wire [1:0] oMEMORY_ORDER,
		output wire [3:0] oMEMORY_MASK,
		output wire oMEMORY_RW,
		output wire [31:0] oMEMORY_ADDR,
		output wire [31:0] oMEMORY_DATA,
		//Memory(InPort)
		input wire iMEMORY_VALID,
		output wire oMEMORY_BUSY,
		input wire iMEMORY_STORE_ACK,
		input wire iMEMORY_PAGEFAULT,
		input wire iMEMORY_QUEUE_FLUSH,
		input wire [63:0] iMEMORY_DATA,
		input wire [27:0] iMEMORY_MMU_FLAGS
	);
				
	
	/*********************************************************
	Wire and Register
	*********************************************************/
	//Matching Bridge
	wire matching_bridfe_wr_full;
	wire matching_bridge_rd_valid;
	wire matching_bridge_rd_type;
	//Core -> Memory
	wire mem2core_inst_lock;
	wire mem2core_data_lock;
	wire core2mem_inst_condition;
	wire core2mem_data_condition;
	wire core2mem_data_lock = 1'b0;
	reg b_core2mem_req;
	reg b_core2mem_data_store_ack;
	reg [1:0] b_core2mem_order;
	reg [3:0] b_core2mem_mask;
	reg b_core2mem_rw;
	reg [1:0] b_core2mem_mmumod;
	reg [13:0] b_core2mem_pdt;
	reg [31:0] b_core2mem_addr;
	reg [31:0] b_core2mem_data;
	//Memory -> Core
	reg b_mem2core_inst_valid;
	reg b_mem2core_inst_pagefault;
	reg b_mem2core_inst_queue_flush;
	reg [63:0] b_mem2core_inst_data;
	reg [27:0] b_mem2core_inst_mmu_flags;
	reg b_mem2core_data_valid;
	reg b_mem2core_data_pagefault;
	reg [63:0] b_mem2core_data_data;
	reg [27:0] b_mem2core_data_mmu_flags;	

	//Condition
	wire mem2core_common_lock = matching_bridfe_wr_full || iMEMORY_LOCK;
	wire core2mem_data_write_ack_condition = iDATA_RW && core2mem_data_condition;
	wire core2mem_normal_memory_access_condition = (!iDATA_RW && core2mem_data_condition) || core2mem_inst_condition;
	
	/*********************************************************
	Memory Matching Controal
	*********************************************************/	
	mist1032sa_arbiter_matching_queue #(16, 4, 1) MEM_MATCHING_BRIDGE(	//Queue deep : 16, Queue deep_n : 4, Flag_n : 1
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Flash
		.iFLASH(iMEMORY_QUEUE_FLUSH),
		//Write
		.iWR_REQ(!mem2core_common_lock && core2mem_normal_memory_access_condition),
		.iWR_FLAG(core2mem_data_condition),		//0:Inst, 1:Data
		.oWR_FULL(matching_bridfe_wr_full),
		//Read
		.iRD_REQ(iMEMORY_VALID  && (matching_bridge_rd_type && !core2mem_data_lock || !matching_bridge_rd_type && !iINST_BUSY) && !iMEMORY_STORE_ACK),
		.oRD_VALID(matching_bridge_rd_valid),
		.oRD_FLAG(matching_bridge_rd_type),		//0:Inst, 1:Data
		.oRD_EMPTY()
	);

	
	
	/*********************************************************
	Buffer & Assign(Core -> Memory)
	*********************************************************/
	//assign
	assign mem2core_inst_lock = mem2core_common_lock || core2mem_data_condition;
	assign mem2core_data_lock = mem2core_common_lock || core2mem_inst_condition;
	assign core2mem_inst_condition = !iDATA_REQ && iINST_REQ;
	assign core2mem_data_condition = iDATA_REQ;

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_core2mem_req <= 1'b0;
			b_core2mem_order <= 2'h0;
			b_core2mem_mask <= 4'h0;
			b_core2mem_rw <= 1'b0;
			b_core2mem_data_store_ack <= 1'b0;
			b_core2mem_mmumod <= 2'h0;
			b_core2mem_pdt <= {32{1'b0}};
			b_core2mem_addr <= {32{1'b0}};
			b_core2mem_data <= {32{1'b0}};
		end
		else if(iMEMORY_QUEUE_FLUSH)begin
			b_core2mem_req <= 1'b0;
			b_core2mem_order <= 2'h0;
			b_core2mem_mask <= 4'h0;
			b_core2mem_rw <= 1'b0;
			b_core2mem_data_store_ack <= 1'b0;
			b_core2mem_mmumod <= 2'h0;
			b_core2mem_pdt <= {32{1'b0}};
			b_core2mem_addr <= {32{1'b0}};
			b_core2mem_data <= {32{1'b0}};
		end
		else begin
			if(!mem2core_common_lock)begin
				//if(b_io_startaddr_valid )
				if(core2mem_data_condition)begin
					b_core2mem_req <= 1'b1;
					b_core2mem_order <= iDATA_ORDER;
					b_core2mem_mask <= iDATA_MASK;
					b_core2mem_rw <= iDATA_RW;
					b_core2mem_data_store_ack <= core2mem_data_write_ack_condition;
					b_core2mem_mmumod <= iDATA_MMUMOD;
					b_core2mem_pdt <= iDATA_PDT;
					b_core2mem_addr <= iDATA_ADDR;
					b_core2mem_data <= iDATA_DATA;
				end
				else if(core2mem_inst_condition)begin
					b_core2mem_req <= 1'b1;
					b_core2mem_order <= 2'h2;
					b_core2mem_mask <= 4'hff;
					b_core2mem_rw <= 1'b0;
					b_core2mem_data_store_ack <= 1'b0;
					b_core2mem_mmumod <= iINST_MMUMOD;
					b_core2mem_pdt <= iINST_PDT;
					b_core2mem_addr <= iINST_ADDR;
					b_core2mem_data <= {32{1'b0}};
				end
				else begin
					b_core2mem_req <= 1'b0;
				end
			end
		end
	end
	
	
	
	/*********************************************************
	Inst Data Selector & Buffer & assign (Memory -> Core)
	*********************************************************/	
	//Inst
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_mem2core_inst_valid <= 1'b0;
			b_mem2core_inst_pagefault <= 1'b0;
			b_mem2core_inst_queue_flush <= 1'b0;
			b_mem2core_inst_data <= {63{1'b0}};
			b_mem2core_inst_mmu_flags <= 28'h0;
		end
		else begin
			if(!iINST_BUSY)begin
				b_mem2core_inst_valid <= !matching_bridge_rd_type && matching_bridge_rd_valid && !iMEMORY_STORE_ACK && iMEMORY_VALID;
				b_mem2core_inst_pagefault <= iMEMORY_PAGEFAULT;
				b_mem2core_inst_queue_flush <= iMEMORY_QUEUE_FLUSH;
				b_mem2core_inst_data <= iMEMORY_DATA;
				b_mem2core_inst_mmu_flags <= iMEMORY_MMU_FLAGS;
			end
		end
	end
	
	//Data
	assign core2mem_data_lock = 1'b0;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_mem2core_data_valid <= 1'b0;
			b_mem2core_data_pagefault <= 1'b0;
			b_mem2core_data_data <= {63{1'b0}};
			b_mem2core_data_mmu_flags <= 28'h0;
		end
		else begin
			if(!core2mem_data_lock)begin
				b_mem2core_data_valid <= ((matching_bridge_rd_type && matching_bridge_rd_valid) || iMEMORY_STORE_ACK) && iMEMORY_VALID;
				b_mem2core_data_pagefault <= iMEMORY_PAGEFAULT;
				b_mem2core_data_data <= iMEMORY_DATA;
				b_mem2core_data_mmu_flags <= iMEMORY_MMU_FLAGS;
			end
		end
	end
	

	
	
	/*********************************************************
	Assign
	*********************************************************/
	assign oDATA_LOCK = mem2core_data_lock;
	assign oINST_LOCK = mem2core_inst_lock;
	
	assign oMEMORY_REQ = b_core2mem_req;
	assign oMEMORY_DATA_STORE_ACK = b_core2mem_data_store_ack;
	assign oMEMORY_MMU_MODE = b_core2mem_mmumod;
	assign oMEMORY_PDT = b_core2mem_pdt;
	assign oMEMORY_ORDER = b_core2mem_order;
	assign oMEMORY_MASK = b_core2mem_mask;
	assign oMEMORY_RW = b_core2mem_rw;
	assign oMEMORY_ADDR = b_core2mem_addr;
	assign oMEMORY_DATA = b_core2mem_data;
	
	assign oMEMORY_BUSY = iDATA_BUSY || iINST_BUSY;
	
	assign oDATA_REQ = b_mem2core_data_valid && !core2mem_data_lock;
	assign oDATA_PAGEFAULT = b_mem2core_data_pagefault;
	assign oDATA_DATA = b_mem2core_data_data;
	assign oDATA_MMU_FLAGS = b_mem2core_data_mmu_flags;
	
	assign oINST_REQ = b_mem2core_inst_valid && !iINST_BUSY;
	assign oINST_PAGEFAULT = b_mem2core_inst_pagefault;	
	assign oINST_QUEUE_FLUSH = b_mem2core_inst_queue_flush;
	assign oINST_DATA = b_mem2core_inst_data;
	assign oINST_MMU_FLAGS = b_mem2core_inst_mmu_flags;
	
endmodule


`default_nettype wire



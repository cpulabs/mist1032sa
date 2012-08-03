
`default_nettype none

module core_if
	#(
		parameter		CORE_ID		=	32'h0
	)(
		/****************************************
		System
		****************************************/
		//Common
		input					inRESET,
		//Core
		input					iCORE_CLOCK,
		//Interface
		input					iIF_CLOCK,
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
		//Data RAM -> This
		input					iINST_VALID,
		output					oINST_BUSY,		
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
	
	
	/**************************************************************************************
	Interface 2 Core
	**************************************************************************************/
	`define			IOSR_STT_WAIT			2'h0
	`define			IOSR_STT_ASYNC_CAN1		2'h1
	`define			IOSR_STT_ASYNC_CAN2		2'h2
	`define			IOSR_STT_IOSR_GET		2'h3	
	
	reg		[1:0]	b_iosr_state;
	reg				b_iosr_valid;
	reg		[31:0]	b_iosr;
	always@(posedge iCORE_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_iosr_state		<=		2'h0;
			b_iosr_valid		<=		1'b0;
			b_iosr				<=		32'h0;
		end
		else begin
			if(!b_iosr_valid)begin
				case(b_iosr_state)
					`IOSR_STT_WAIT:
						begin
							if(iSYSINFO_IOSR_VALID)begin
								b_iosr_state		<=		`IOSR_STT_ASYNC_CAN1;
							end
						end
					`IOSR_STT_ASYNC_CAN1:
						begin
							if(iSYSINFO_IOSR_VALID)begin
								b_iosr_state		<=		`IOSR_STT_ASYNC_CAN2;
							end
							else begin
								b_iosr_state		<=		`IOSR_STT_WAIT;
							end
						end
					`IOSR_STT_ASYNC_CAN2:
						begin
							if(iSYSINFO_IOSR_VALID)begin
								b_iosr_state		<=		`IOSR_STT_IOSR_GET;
							end
							else begin
								b_iosr_state		<=		`IOSR_STT_WAIT;
							end
						end
					`IOSR_STT_IOSR_GET:
						begin
							if(iSYSINFO_IOSR_VALID)begin
								b_iosr_valid		<=		1'b1;
								b_iosr				<=		iSYSINFO_IOSR;
							end
							else begin
								b_iosr_state		<=		`IOSR_STT_WAIT;
							end
						end
				endcase
			end
			else begin
				b_iosr_valid		<=		1'b1;
				b_iosr				<=		b_iosr;
			end
		end
	end
	
	
	
	/**************************************************************************************
	Core to Mem
	**************************************************************************************/	
	//interrupt Control Queue
	wire				core2fifo_irq_empty;
	async_fifo #(.N(10), .DEPTH(128), .D_N(7)) CORE2MEM_INTFLAGS
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iCORE_CLOCK),
		.iWR_EN(core2fifo_io_conf_table_irq),
		.iWR_DATA({core2fifo_io_conf_table_entry, core2fifo_io_conf_table_valid, core2fifo_io_conf_table_mask, core2fifo_io_conf_table_level}),
		.oWR_FULL(/* Not Use */),
		//RD
		.iRD_CLOCK(iIF_CLOCK),
		.iRD_EN(!core2fifo_irq_empty),
		.oRD_DATA({oIO_IRQ_CONFIG_TABLE_ENTRY, oIO_IRQ_CONFIG_TABLE_FLAG_VALID, oIO_IRQ_CONFIG_TABLE_FLAG_MASK, oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL}),
		.oRD_EMPTY(core2fifo_irq_empty)
	);
	assign		oIO_IRQ_CONFIG_TABLE_REQ		=		!core2fifo_irq_empty;

	
	//instruction Request
	wire				core2fifo_inst_fetch_empty;
	async_fifo #(.N(80), .DEPTH(4), .D_N(2)) CORE2MEM_INST
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iCORE_CLOCK),
		.iWR_EN(core2fifo_inst_fetch_req),
		.iWR_DATA({core2fifo_inst_fetch_tid, core2fifo_inst_fetch_mmumod, core2fifo_inst_fetch_pdt, core2fifo_inst_fetch_addr}),
		.oWR_FULL(fifo2core_inst_fetch_lock),
		//RD
		.iRD_CLOCK(iIF_CLOCK),
		.iRD_EN(!iINST_LOCK && !core2fifo_inst_fetch_empty),
		.oRD_DATA({oINST_TID, oINST_MMUMOD, oINST_PDT, oINST_ADDR}),
		.oRD_EMPTY(core2fifo_inst_fetch_empty)
	);
	assign		oINST_REQ						=		!iINST_LOCK && !core2fifo_inst_fetch_empty;
	
	


	//Data Request
	wire				core2fifo_data_empty;
	async_fifo #(.N(115), .DEPTH(4), .D_N(2)) CORE2MEM_DATA
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iCORE_CLOCK),
		.iWR_EN(core2fifo_data_req),
		.iWR_DATA({core2fifo_data_order, core2fifo_data_rw, core2fifo_data_tid, core2fifo_data_mmumod, core2fifo_data_pdt, core2fifo_data_addr, core2fifo_data_data}),
		.oWR_FULL(fifo2core_data_lock),
		//RD
		.iRD_CLOCK(iIF_CLOCK),
		.iRD_EN(!iDATA_LOCK && !core2fifo_data_empty),
		.oRD_DATA({oDATA_ORDER, oDATA_RW, oDATA_TID, oDATA_MMUMOD, oDATA_PDT, oDATA_ADDR, oDATA_DATA}),
		.oRD_EMPTY(core2fifo_data_empty)
	);
	assign		oDATA_REQ						=		!iDATA_LOCK && !core2fifo_data_empty;
	

	//IO Request
	wire				core2fifo_io_empty;
	async_fifo #(.N(67), .DEPTH(4), .D_N(2)) CORE2MEM_IO
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iCORE_CLOCK),
		.iWR_EN(core2fifo_io_req),
		.iWR_DATA({core2fifo_io_order, core2fifo_io_rw, core2fifo_io_addr, core2fifo_io_data}),
		.oWR_FULL(fifo2core_io_lock),
		//RD
		.iRD_CLOCK(iIF_CLOCK),
		.iRD_EN(!iIO_BUSY && !core2fifo_io_empty),
		.oRD_DATA({oIO_ORDER, oIO_RW, oIO_ADDR, oIO_DATA}),
		.oRD_EMPTY(core2fifo_io_empty)
	);
	assign		oIO_REQ							=		!iIO_BUSY && !core2fifo_io_empty;
	

	
	/********************************************
	Core -> External 
	********************************************/
	//interrupt Control Queue
	wire 				core2fifo_io_conf_table_irq;
	wire 	[5:0]		core2fifo_io_conf_table_entry;
	wire				core2fifo_io_conf_table_valid;
	wire				core2fifo_io_conf_table_mask;
	wire	[1:0]		core2fifo_io_conf_table_level;
	//Instruction Request
	wire				core2fifo_inst_fetch_req;
	wire				fifo2core_inst_fetch_lock;
	wire	[13:0]		core2fifo_inst_fetch_tid;
	wire	[1:0]		core2fifo_inst_fetch_mmumod;
	wire	[31:0]		core2fifo_inst_fetch_pdt;
	wire	[31:0]		core2fifo_inst_fetch_addr;
	//Instruction Request
	wire				core2fifo_data_req;
	wire				fifo2core_data_lock;
	wire	[1:0]		core2fifo_data_order;
	wire				core2fifo_data_rw;
	wire	[13:0]		core2fifo_data_tid;
	wire	[1:0]		core2fifo_data_mmumod;
	wire	[31:0]		core2fifo_data_pdt;
	wire	[31:0]		core2fifo_data_addr;
	wire	[31:0]		core2fifo_data_data;		
	//IO Request
	wire				core2fifo_io_req;
	wire				fifo2core_io_lock;
	wire	[1:0]		core2fifo_io_order;
	wire				core2fifo_io_rw;
	wire	[31:0]		core2fifo_io_addr;
	wire	[31:0]		core2fifo_io_data;
	
	/********************************************
	External -> Core
	********************************************/
	//Inst
	wire				fifo2core_inst_valid;
	wire				core2fifo_inst_busy;
	wire	[63:0]		fifo2core_inst_inst;
	wire	[11:0]		fifo2core_inst_mmu_flags;
	//Data
	wire				fifo2core_data_valid;
	wire	[63:0]		fifo2core_data_data;
	//IO
	wire				fifo2core_io_valid;
	wire	[31:0]		fifo2core_io_data;	
	/********************************************
	IRQ
	********************************************/
	wire				fifo2core_irq_valid;
	wire	[5:0]		fifo2core_irq_num;
	wire				core2fifo_irq_ack;
	
	
	
	core #(CORE_ID) CORE(
		/****************************************
		System
		****************************************/
		.iCLOCK(iCORE_CLOCK),
		.inRESET(inRESET),	
		/****************************************
		Core
		****************************************/
		.oCORE_FLASH(/* Not Use */),
		/****************************************
		GCI Controll
		****************************************/	
		//Interrupt Control
		.oIO_IRQ_CONFIG_TABLE_REQ(core2fifo_io_conf_table_irq),
		.oIO_IRQ_CONFIG_TABLE_ENTRY(core2fifo_io_conf_table_entry),
		.oIO_IRQ_CONFIG_TABLE_FLAG_VALID(core2fifo_io_conf_table_valid),
		.oIO_IRQ_CONFIG_TABLE_FLAG_MASK(core2fifo_io_conf_table_mask),
		.oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL(core2fifo_io_conf_table_level),
		/****************************************
		Instruction Memory
		****************************************/
		//Req
		.oINST_REQ(core2fifo_inst_fetch_req),
		.iINST_LOCK(fifo2core_inst_fetch_lock),
		.oINST_TID(core2fifo_inst_fetch_tid),
		.oINST_MMUMOD(core2fifo_inst_fetch_mmumod),
		.oINST_PDT(core2fifo_inst_fetch_pdt),
		.oINST_ADDR(core2fifo_inst_fetch_addr),
		//Data RAM -> This
		.iINST_VALID(fifo2core_inst_valid),
		.oINST_BUSY(core2fifo_inst_busy),		
		.iINST_DATA(fifo2core_inst_inst),
		.iINST_MMU_FLAGS(fifo2core_inst_mmu_flags),
		/****************************************
		Data Memory
		****************************************/
		//Req
		.oDATA_REQ(core2fifo_data_req),
		.iDATA_LOCK(fifo2core_data_lock),
		.oDATA_ORDER(core2fifo_data_order),	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oDATA_RW(core2fifo_data_rw),			//1=Write 0=Read
		.oDATA_TID(core2fifo_data_tid),
		.oDATA_MMUMOD(core2fifo_data_mmumod),
		.oDATA_PDT(core2fifo_data_pdt),
		.oDATA_ADDR(core2fifo_data_addr),
		//This -> Data RAM
		.oDATA_DATA(core2fifo_data_data),
		//Data RAM -> This
		.iDATA_VALID(fifo2core_data_valid),
		.iDATA_DATA(fifo2core_data_data),
		/****************************************
		IO
		****************************************/
		//Req
		.oIO_REQ(core2fifo_io_req),
		.iIO_BUSY(fifo2core_io_lock),
		.oIO_ORDER(core2fifo_io_order),		//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oIO_RW(core2fifo_io_rw),			//0=Write 1=Read
		.oIO_ADDR(core2fifo_io_addr),
		//Write
		.oIO_DATA(core2fifo_io_data),
		//Rec
		.iIO_VALID(fifo2core_io_valid),
		.iIO_DATA(fifo2core_io_data),	
		/****************************************
		Interrupt
		****************************************/
		.iINTERRUPT_VALID(fifo2core_irq_valid),
		.oINTERRUPT_ACK(core2fifo_irq_ack),
		.iINTERRUPT_NUM(fifo2core_irq_num),
		/****************************************
		System Infomation
		****************************************/
		.iSYSINFO_IOSR_VALID(b_iosr_valid),
		.iSYSINFO_IOSR(b_iosr)
	);
	

	
	/**************************************************************************************
	Memory 2 Core
	**************************************************************************************/
	//Instruction
	wire			fifo2core_inst_empty;
	async_fifo #(.N(76), .DEPTH(4), .D_N(2)) MEM2CORE_INST
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iIF_CLOCK),
		.iWR_EN(iINST_VALID),
		.iWR_DATA({iINST_DATA, iINST_MMU_FLAGS}),
		.oWR_FULL(oINST_BUSY),
		//RD
		.iRD_CLOCK(iCORE_CLOCK),
		.iRD_EN(!fifo2core_inst_empty && !core2fifo_inst_busy),
		.oRD_DATA({fifo2core_inst_inst, fifo2core_inst_mmu_flags}),
		.oRD_EMPTY(fifo2core_inst_empty)
	);
	assign		fifo2core_inst_valid		=		!fifo2core_inst_empty && !core2fifo_inst_busy;
	
	
	//DATA
	wire			fifo2core_data_empty;
	async_fifo #(.N(64), .DEPTH(4), .D_N(2)) MEM2CORE_DATA
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iIF_CLOCK),
		.iWR_EN(iDATA_VALID),
		.iWR_DATA(iDATA_DATA),
		.oWR_FULL(/* Not Use */),
		//RD
		.iRD_CLOCK(iCORE_CLOCK),
		.iRD_EN(!fifo2core_data_empty),
		.oRD_DATA(fifo2core_data_data),
		.oRD_EMPTY(fifo2core_data_empty)
	);
	assign		fifo2core_data_valid		=		!fifo2core_data_empty;
	
	//IO
	wire			fifo2core_io_empty;
	async_fifo #(.N(32), .DEPTH(4), .D_N(2)) MEM2CORE_IO
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iIF_CLOCK),
		.iWR_EN(iIO_VALID),
		.iWR_DATA(iIO_DATA),
		.oWR_FULL(/* Not Use */),
		//RD
		.iRD_CLOCK(iCORE_CLOCK),
		.iRD_EN(!fifo2core_io_empty),
		.oRD_DATA(fifo2core_io_data),
		.oRD_EMPTY(fifo2core_io_empty)
	);
	assign		fifo2core_io_valid		=		!fifo2core_io_empty;
	
	
	
	/**************************************************************************************
	Interrupt
	**************************************************************************************/
	//IF 2 Core
	reg					b_if2core_irq_state;
	reg					b_if2core_irq_valid;
	reg		[5:0]		b_if2core_irq_num;
	reg					b_if2core_irq_ack;
	always@(posedge iIF_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_if2core_irq_state		<=		1'b0;
			b_if2core_irq_valid		<=		1'b0;
			b_if2core_irq_num		<=		6'h0;
			b_if2core_irq_ack		<=		1'b0;
		end
		else begin
			case(b_if2core_irq_state)
				1'h0:
					begin
						b_if2core_irq_ack		<=		1'b0;
						if(iINTERRUPT_VALID)begin
							b_if2core_irq_state		<=		1'b1;
							b_if2core_irq_valid		<=		iINTERRUPT_VALID;
							b_if2core_irq_num		<=		iINTERRUPT_NUM;
						end
					end
				1'h1:
					begin
						b_if2core_irq_valid		<=		1'b0;
						if(!core2if_irq_empty)begin
							b_if2core_irq_state		<=		1'b0;
							b_if2core_irq_num		<=		6'h0;
							b_if2core_irq_ack		<=		1'b1;
						end
					end
			endcase
		end
	end
	assign	oINTERRUPT_ACK		=		b_if2core_irq_ack;
	
	//IF 2 Core FIFO
	wire			if2core_irq_empty;	
	wire	[5:0]	if2core_irq_num;
	async_fifo #(.N(6), .DEPTH(4), .D_N(2)) IF2CORE_FIFO
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iIF_CLOCK),
		.iWR_EN(b_if2core_irq_valid),
		.iWR_DATA(b_if2core_irq_num),
		.oWR_FULL(/* Not Use */),
		//RD
		.iRD_CLOCK(iCORE_CLOCK),
		.iRD_EN(!if2core_irq_empty),
		.oRD_DATA(if2core_irq_num),
		.oRD_EMPTY(if2core_irq_empty)
	);
	
	
	//Core 2 If FIFO
	wire			core2if_irq_empty;
	async_fifo #(.N(1), .DEPTH(4), .D_N(2)) CORE2IF_FIFO
	(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iCORE_CLOCK),
		.iWR_EN(core2fifo_irq_ack),
		.iWR_DATA(1'b1),
		.oWR_FULL(/* Not Use */),
		//RD
		.iRD_CLOCK(iIF_CLOCK),
		.iRD_EN(!core2if_irq_empty),
		.oRD_DATA(/* Not Use */),
		.oRD_EMPTY(core2if_irq_empty)
	);
	
	reg					b_core2if_irq_state;
	reg					b_core2if_irq_valid;
	reg		[5:0]		b_core2if_irq_num;
	always@(posedge iCORE_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_core2if_irq_state		<=		1'b0;
			b_core2if_irq_valid		<=		1'b0;
			b_core2if_irq_num		<=		6'h0;
		end
		else begin
			case(b_core2if_irq_state)
				1'h0:
					begin
						//IF IRQ Request
						if(!if2core_irq_empty)begin
							b_core2if_irq_state		<=		1'b1;
							b_core2if_irq_valid		<=		!if2core_irq_empty;
							b_core2if_irq_num		<=		if2core_irq_num;
						end
					end
				1'h1:
					begin
						if(core2fifo_irq_ack)begin
							b_core2if_irq_valid		<=		1'b0;
							b_core2if_irq_state		<=		1'b0;
							b_core2if_irq_num		<=		6'h0;
						end
					end
			endcase
		end
	end
	assign		fifo2core_irq_valid		=		b_core2if_irq_valid;
	assign		fifo2core_irq_num		=		b_core2if_irq_num;
	

endmodule

`default_nettype wire

		
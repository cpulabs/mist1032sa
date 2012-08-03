/****************************************
	MIST1032SA Processor
	
	
	Make	:	2011/10/04
	Update	:	2011/11/15
****************************************/
`default_nettype none	
`include "global.h"



module mist1032sa(
				/****************************************
				System
				****************************************/
				input				iCORE_CLOCK,
				input				iBUS_CLOCK,
				input				iDPS_CLOCK,
				input				inRESET,
				/****************************************
				SCI
				****************************************/
				output				oSCI_TXD,
				input				iSCI_RXD,
				/****************************************
				Memory BUS
				****************************************/
				//Req
				output				oMEMORY_REQ,
				input				iMEMORY_LOCK,
				output	[1:0]		oMEMORY_ORDER,					//00=Byte Order 01=2Byte Order 10= Word Order 11= None
				output				oMEMORY_RW,						//1:Write | 0:Read
				output	[31:0]		oMEMORY_ADDR,
				//This -> Data RAM
				output	[31:0]		oMEMORY_DATA,
				//Data RAM -> This
				input				iMEMORY_VALID,
				output				oMEMORY_BUSY,		//new
				input	[63:0]		iMEMORY_DATA,	
				/****************************************
				GCI BUS
				****************************************/
				//Request
				output				oGCI_REQ,				//Input
				input				iGCI_BUSY,
				output				oGCI_RW,				//0=Read : 1=Write
				output	[31:0]		oGCI_ADDR,
				output	[31:0]		oGCI_DATA,
				//Return
				input				iGCI_REQ,				//Output
				output				oGCI_BUSY,
				input	[31:0]		iGCI_DATA,
				//Interrupt
				input				iGCI_IRQ_REQ,
				input	[5:0]		iGCI_IRQ_NUM,
				output				oGCI_IRQ_ACK,
				//Interrupt Controll
				output				oIO_IRQ_CONFIG_TABLE_REQ,
				output	[5:0]		oIO_IRQ_CONFIG_TABLE_ENTRY,
				output				oIO_IRQ_CONFIG_TABLE_FLAG_MASK,
				output				oIO_IRQ_CONFIG_TABLE_FLAG_VALID,
				output	[1:0]		oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL
	);
			
			
	/****************************************
	Register and Wire
	****************************************/
	//Memory
	wire				core2mem_inst_req;
	wire				mem2core_inst_lock;
	wire	[13:0]		core2mem_inst_tid;
	wire	[1:0]		core2mem_inst_mmumod;
	wire	[31:0]		core2mem_inst_pdt;
	wire	[31:0]		core2mem_inst_addr;
	wire				mem2core_inst_valid;
	wire				core2mem_inst_lock;
	wire	[63:0]		mem2core_inst_data;
	wire	[11:0]		mem2core_inst_mmu_flags;
	wire				core2mem_data_req;
	wire				mem2core_data_lock;
	wire	[1:0]		core2mem_data_order;	
	wire				core2mem_data_rw;		//0=Read | 1=Write
	wire	[13:0]		core2mem_data_tid;
	wire	[1:0]		core2mem_data_mmumod;
	wire	[31:0]		core2mem_data_pdt;
	wire	[31:0]		core2mem_data_addr;
	wire	[31:0]		core2mem_data_data;
	wire				mem2core_data_valid;
	wire				core2mem_data_lock;
	wire	[63:0]		mem2core_data_data;
	//IO
	wire				io2cpu_sysinfo_iosr_valid;
	wire	[31:0]		io2cpu_sysinfo_iosr;
	wire				cpu2io_req;
	wire				io2cpu_busy;
	wire	[1:0]		cpu2io_order;
	wire				cpu2io_rw;
	wire	[31:0]		cpu2io_addr;
	wire	[31:0]		cpu2io_data;
	wire				io2cpu_valid;
	wire	[31:0]		io2cpu_data;
	wire				io2cpu_interrupt_valid;
	wire				cpu2io_interrupt_ack;
	wire	[5:0]		io2cpu_interrupt_num;
	//DPS
	wire				pic2dps_req;
	wire				dps2pic_busy;
	wire				pic2dps_rw;	
	wire	[31:0]		pic2dps_addr;	
	wire	[31:0]		pic2dps_data;	
	wire				dps2pic_req;
	wire	[31:0]		dps2pic_data;
	wire				dps2pic_irq_valid;
	wire	[5:0]		dps2pic_irq_num;
	wire				pic2dps_irq_ack;
	//Memory Matching Controal
	wire				matching_bridfe_wr_full;
	wire				matching_bridge_rd_valid;
	wire				matching_bridge_rd_type;	//0:Inst, 1:Data
	wire				matching_bridge_rd_empty;
	//Memory Access Condition State
	wire				core2mem_inst_condition;
	wire				core2mem_data_condition;
	//Memory Request Buffer
	reg					b_core2mem_req;
	reg		[1:0]		b_core2mem_order;	
	reg					b_core2mem_rw;		//0=Read | 1=Write
	reg		[13:0]		b_core2mem_tid;
	reg		[1:0]		b_core2mem_mmumod;
	reg		[31:0]		b_core2mem_pdt;
	reg		[31:0]		b_core2mem_addr;
	reg		[31:0]		b_core2mem_data;
	//Data Selector - INST
	reg					b_mem2core_inst_valid;	
	reg		[63:0]		b_mem2core_inst_data;	
	//Data Selector - DATA	
	reg					b_mem2core_data_valid;	
	reg		[63:0]		b_mem2core_data_data;
	
			
	/********************************************************************************
	Processor Core
	********************************************************************************/
	wire				core2io_irq_tables_req;
	wire	[5:0]		core2io_irq_tables_entry;
	wire				core2io_irq_tables_flag_mask;
	wire				core2io_irq_tables_flag_valid;
	wire	[1:0]		core2io_irq_tables_flag_level;
	
	
	assign				oIO_IRQ_CONFIG_TABLE_REQ			=		core2io_irq_tables_req;
	assign				oIO_IRQ_CONFIG_TABLE_ENTRY			=		core2io_irq_tables_entry;
	assign				oIO_IRQ_CONFIG_TABLE_FLAG_MASK		=		core2io_irq_tables_flag_mask;
	assign				oIO_IRQ_CONFIG_TABLE_FLAG_VALID		=		core2io_irq_tables_flag_valid;
	assign				oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL		=		core2io_irq_tables_flag_level;
	
	core_if #(32'h0) CORE_IF(
		/****************************************
		System
		****************************************/
		.iIF_CLOCK(iBUS_CLOCK),
		.iCORE_CLOCK(iCORE_CLOCK),
		.inRESET(inRESET),	
		/****************************************
		GCI Controll
		****************************************/	
		//Interrupt Control
		.oIO_IRQ_CONFIG_TABLE_REQ(core2io_irq_tables_req),
		.oIO_IRQ_CONFIG_TABLE_ENTRY(core2io_irq_tables_entry),
		.oIO_IRQ_CONFIG_TABLE_FLAG_MASK(core2io_irq_tables_flag_mask),
		.oIO_IRQ_CONFIG_TABLE_FLAG_VALID(core2io_irq_tables_flag_valid),
		.oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL(core2io_irq_tables_flag_level),
		/****************************************
		Instruction Memory
		****************************************/
		//Req
		.oINST_REQ(core2mem_inst_req),
		.iINST_LOCK(mem2core_inst_lock),
		.oINST_TID(core2mem_inst_tid),
		.oINST_MMUMOD(core2mem_inst_mmumod),
		.oINST_PDT(core2mem_inst_pdt),
		.oINST_ADDR(core2mem_inst_addr),
		//Data RAM -> This
		.iINST_VALID(mem2core_inst_valid),
		.oINST_BUSY(core2mem_inst_lock),		//new
		.iINST_DATA(mem2core_inst_data),
		.iINST_MMU_FLAGS(/*mem2core_inst_mmu_flags*/12'h0),
		/****************************************
		Data Memory
		****************************************/
		//Req
		.oDATA_REQ(core2mem_data_req),
		.iDATA_LOCK(mem2core_data_lock),
		.oDATA_ORDER(core2mem_data_order),	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oDATA_RW(core2mem_data_rw),			//1=Write 0=Read
		.oDATA_TID(core2mem_data_tid),
		.oDATA_MMUMOD(core2mem_data_mmumod),
		.oDATA_PDT(core2mem_data_pdt),
		.oDATA_ADDR(core2mem_data_addr),
		//This -> Data RAM
		.oDATA_DATA(core2mem_data_data),
		//Data RAM -> This
		.iDATA_VALID(mem2core_data_valid),
		.iDATA_DATA(mem2core_data_data),
		/****************************************
		IO
		****************************************/
		//Req
		.oIO_REQ(cpu2io_req),
		.iIO_BUSY(io2cpu_busy),
		.oIO_ORDER(cpu2io_order),		//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oIO_RW(cpu2io_rw),			//0=Write 1=Read
		.oIO_ADDR(cpu2io_addr),
		//Write
		.oIO_DATA(cpu2io_data),
		//Rec
		.iIO_VALID(io2cpu_valid),
		.iIO_DATA(io2cpu_data),
		/****************************************
		Interrupt
		****************************************/
		.iINTERRUPT_VALID(io2cpu_interrupt_valid),
		.oINTERRUPT_ACK(cpu2io_interrupt_ack),
		.iINTERRUPT_NUM(io2cpu_interrupt_num),
		/****************************************
		System Infomation
		****************************************/
		.iSYSINFO_IOSR_VALID(io2cpu_sysinfo_iosr_valid),
		.iSYSINFO_IOSR(io2cpu_sysinfo_iosr)
	);
	
	/********************************************************************************
	MMU
	********************************************************************************/
/*	
	mmu MMU_MODULE(			
		//System
		.iBUS_CLOCK(iBUS_CLOCK),
		.inRESET(inRESET),
		//TLB Flash
		.iTLB_FLASH(),
		//Req IRQ
		.oINTERRUPT_VALID(),
		//CORE REGISTER
		.iCOREINFO_MODE(),			//0=NoConvertion 1=none 2=1LevelConvertion 3=2LevelConvertion
		.iCOREINFO_PDT(),			//Page Directory Table 
		.iCOREINFO_TID(),			//Task Id 
		//LOGIC Address Request
		.iLOGIC_REQ(),
		.iLOGIC_RW(),				//0=Read 1=Write
		.iLOGIC_TYPE(),			//0:Data 1:Instruction	
		.iLOGIC_ADDR(),
		.oLOGIC_LOCK(),
		//Physical Output
		.oPHYSICAL_VALID(),
		.iPHYSICAL_LOCK(),
		.oPHYSICAL_ADDR(),
		//Memory <--->
		//Req
		.oMEMORY_REQ(),
		.iMEMORY_LOCK(),
		.oMEMORY_ADDR(),
		//Data RAM -> This
		.iMEMORY_VALID(),
		.oMEMORY_LOCK(),
		.iMEMORY_DATA()
	);
	*/
	
	/********************************************************************************
	IO Interface
	********************************************************************************/		
	//Peripheral Interface Controller
	peripheral_interface_controller PIC(
		/****************************************
		System
		****************************************/
		.iCLOCK(iBUS_CLOCK),
		.inRESET(inRESET),
		/****************************************
		System Infomation
		****************************************/
		.oSYSINFO_IOSR_VALID(io2cpu_sysinfo_iosr_valid),
		.oSYSINFO_IOSR(io2cpu_sysinfo_iosr),			//IO Start Address
		/****************************************
		IO - CPU Connection
		****************************************/
		//Req
		.iIO_REQ(cpu2io_req),
		.oIO_BUSY(io2cpu_busy),
		.iIO_ORDER(cpu2io_order),				//if (!iIO_RW && iIO_ORDER!=2'h2) then Alignment Fault
		.iIO_RW(cpu2io_rw),					//0=Write 1=Read
		.iIO_ADDR(cpu2io_addr),
		.iIO_DATA(cpu2io_data),
		//Output
		.oIO_VALID(io2cpu_valid),
		.iIO_BUSY(1'b0),
		.oIO_DATA(io2cpu_data),
		//Interrupt
		.oIO_INTERRUPT_VALID(io2cpu_interrupt_valid),
		.iIO_INTERRUPT_ACK(cpu2io_interrupt_ack),
		.oIO_INTERRUPT_NUM(io2cpu_interrupt_num),
		/****************************************
		To DPS Connection (Not Use)
		****************************************/
		//Request
		.oDPS_REQ(pic2dps_req),				//Input
		.iDPS_BUSY(dps2pic_busy),
		.oDPS_RW(pic2dps_rw),				//0=Read : 1=Write
		.oDPS_ADDR(pic2dps_addr),
		.oDPS_DATA(pic2dps_data),
		//Return
		.iDPS_REQ(dps2pic_req),			
		.oDPS_BUSY(),
		.iDPS_DATA(dps2pic_data),
		//Interrupt
		.iDPS_IRQ_REQ(dps2pic_irq_valid),
		.iDPS_IRQ_NUM(dps2pic_irq_num),
		.oDPS_IRQ_ACK(pic2dps_irq_ack),	
		/****************************************
		To GCI Connection
		****************************************/						
		//Request
		.oGCI_REQ(oGCI_REQ),				
		.iGCI_BUSY(iGCI_BUSY),
		.oGCI_DD(oGCI_RW),				//0=Read : 1=Write
		.oGCI_ADDR(oGCI_ADDR),
		.oGCI_DATA(oGCI_DATA),
		//Return
		.iGCI_REQ(iGCI_REQ),				
		.oGCI_BUSY(oGCI_BUSY),
		.iGCI_DATA(iGCI_DATA),
		//Interrupt
		.iGCI_IRQ_REQ(iGCI_IRQ_REQ),
		.iGCI_IRQ_NUM(iGCI_IRQ_NUM),
		.oGCI_IRQ_ACK(oGCI_IRQ_ACK)
	);	
	
	
		
	/********************************************************************************
	DPS
	********************************************************************************/
	wire	[5:0]	core2dps_irq_tables_entry_tmp;
	assign			core2dps_irq_tables_entry_tmp		=	core2io_irq_tables_entry - 6'd46;
	
	default_peripheral_system DPS(
		.iCLOCK(iBUS_CLOCK),
		.iDPS_BASE_CLOCK(iDPS_CLOCK),			//49.5120MHz
		.inRESET(inRESET),
		/****************************************
		IO
		****************************************/
		//IRQ Tables	
		.oDPS_IRQ_CONFIG_TABLE_REQ(core2io_irq_tables_req && (core2io_irq_tables_entry == 6'd36 || core2io_irq_tables_entry == 6'd37)),
		.oDPS_IRQ_CONFIG_TABLE_ENTRY(core2dps_irq_tables_entry_tmp[0]),
		.oDPS_IRQ_CONFIG_TABLE_FLAG_MASK(core2io_irq_tables_flag_mask),
		.oDPS_IRQ_CONFIG_TABLE_FLAG_VALID(core2io_irq_tables_flag_valid),
		.oDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL(core2io_irq_tables_flag_level),
		//Req
		.iDPS_REQ(pic2dps_req),
		.oDPS_BUSY(dps2pic_busy),
		.iDPS_RW(pic2dps_rw),					//1:Write
		.iDPS_ADDR(pic2dps_addr),
		.iDPS_DATA(pic2dps_data),
		//Output
		.oDPS_VALID(dps2pic_req),
		.oDPS_DATA(dps2pic_data),
		/****************************************
		Interrupt
		****************************************/
		.oDPS_IRQ_REQ(dps2pic_irq_valid),
		.oDPS_IRQ_NUM(dps2pic_irq_num),
		.iDPS_IRQ_ACK(pic2dps_irq_ack),
		/****************************************
		Device
		****************************************/
		.oSCI_TXD(oSCI_TXD),
		.iSCI_RXD(iSCI_RXD)
	);	
	
	/********************************************************************************
	Memory Interface
	********************************************************************************/	
	/*********************************************************
	Memory Matching Controal
	*********************************************************/	
	arbiter_matching_bridge #(16, 4) MEM_MATCHING_BRIDGE(	//Queue deep : 16, Queue deep_n : 4
		.iCLOCK(iBUS_CLOCK),
		.inRESET(inRESET),
		//Flash
		.iFLASH(1'b0),
		//Write
		.iWR_REQ(!matching_bridfe_wr_full && !iMEMORY_LOCK && (core2mem_inst_condition || (core2mem_data_condition && !core2mem_data_rw))),
		.iWR_TYPE(core2mem_data_condition),		//0:Inst, 1:Data
		.oWR_FULL(matching_bridfe_wr_full),
		//Read
		.iRD_REQ(iMEMORY_VALID && !matching_bridge_rd_empty && (matching_bridge_rd_type && !core2mem_data_lock || !matching_bridge_rd_type && !core2mem_inst_lock)),
		.oRD_VALID(matching_bridge_rd_valid),
		.oRD_TYPE(matching_bridge_rd_type),		//0:Inst, 1:Data
		.oRD_EMPTY(matching_bridge_rd_empty)
	);
	
	/*********************************************************
	Buffer & Assign(Core -> Memory)
	*********************************************************/
	//assign
	assign				mem2core_inst_lock				=		iMEMORY_LOCK || matching_bridfe_wr_full || core2mem_data_condition;
	assign				mem2core_data_lock				=		iMEMORY_LOCK || matching_bridfe_wr_full;/* || core2mem_inst_condition*/

	assign				core2mem_inst_condition			=		!core2mem_data_condition && core2mem_inst_req;
	assign				core2mem_data_condition			=		core2mem_data_req;

	always@(posedge iBUS_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_core2mem_req		<=		1'b0;
			b_core2mem_order	<=		2'h0;
			b_core2mem_rw		<=		1'b0;
			b_core2mem_tid		<=		{14{1'b0}};
			b_core2mem_mmumod	<=		2'h0;
			b_core2mem_pdt		<=		{32{1'b0}};
			b_core2mem_addr		<=		{32{1'b0}};
			b_core2mem_data		<=		{32{1'b0}};
		end
		else begin
			if(!iMEMORY_LOCK)begin
				if(core2mem_data_condition)begin
					b_core2mem_req		<=		1'b1;
					b_core2mem_order	<=		core2mem_data_order;
					b_core2mem_rw		<=		core2mem_data_rw;
					b_core2mem_tid		<=		core2mem_data_tid;
					b_core2mem_mmumod	<=		core2mem_data_mmumod;
					b_core2mem_pdt		<=		core2mem_data_pdt;
					b_core2mem_addr		<=		core2mem_data_addr;
					b_core2mem_data		<=		core2mem_data_data;
				end
				else if(core2mem_inst_condition)begin
					b_core2mem_req		<=		1'b1;
					b_core2mem_order	<=		2'h2;
					b_core2mem_rw		<=		1'b0;
					b_core2mem_tid		<=		core2mem_inst_tid;
					b_core2mem_mmumod	<=		core2mem_inst_mmumod;
					b_core2mem_pdt		<=		core2mem_inst_pdt;
					b_core2mem_addr		<=		core2mem_inst_addr;
					b_core2mem_data		<=		{32{1'b0}};
				end
				else begin
					b_core2mem_req		<=		1'b0;
				end
			end
		end
	end
	
	
	/*********************************************************
	Inst Data Selector & Buffer & assign (Memory -> Core)
	*********************************************************/
	//Inst
	always@(posedge iBUS_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_mem2core_inst_valid		<=		1'b0;
			b_mem2core_inst_data		<=		{63{1'b0}};
		end
		else begin
			if(!core2mem_inst_lock)begin
				b_mem2core_inst_valid		<=		!matching_bridge_rd_type && matching_bridge_rd_valid && iMEMORY_VALID;
				b_mem2core_inst_data		<=		iMEMORY_DATA;
			end
		end
	end
	
	//Data
	assign		core2mem_data_lock		=		1'b0;
	always@(posedge iBUS_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_mem2core_data_valid		<=		1'b0;
			b_mem2core_data_data		<=		{63{1'b0}};
		end
		else begin
			if(!core2mem_data_lock)begin
				b_mem2core_data_valid		<=		matching_bridge_rd_type && matching_bridge_rd_valid && iMEMORY_VALID;
				b_mem2core_data_data		<=		iMEMORY_DATA;
			end
		end
	end
	
	//Inst Assign
	assign			mem2core_inst_valid		=		b_mem2core_inst_valid && !core2mem_inst_lock;
	assign			mem2core_inst_data		=		b_mem2core_inst_data;
	//Data Assign
	assign			mem2core_data_valid		=		b_mem2core_data_valid && !core2mem_data_lock;
	assign			mem2core_data_data		=		b_mem2core_data_data;
	
	
	//Assign
	assign		oMEMORY_REQ		=	b_core2mem_req;
	assign		oMEMORY_ORDER	=	b_core2mem_order;
	assign		oMEMORY_RW		=	b_core2mem_rw;
	assign		oMEMORY_ADDR	=	b_core2mem_addr;
	assign		oMEMORY_DATA	=	b_core2mem_data;
	assign		oMEMORY_BUSY	=	(!matching_bridge_rd_type && core2mem_inst_lock) || (matching_bridge_rd_type && core2mem_data_lock);
	
endmodule


`default_nettype wire


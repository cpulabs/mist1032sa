/*************************************************************************************************************
MIST1032SA
Open Source 32bit Out-of-Order Processor

Files that are included in this project is deliverable by all Open Design Computer Project.
http://open-arch.org

All files included in this project have been allocated in the BSD licence.	
Open Design Computer Project @Takahiro Ito (Twitter : @cpu_labs)
*************************************************************************************************************/


`default_nettype none
`include "processor.h"
`include "common.h"	


module mist1032sa(
		/****************************************
		System
		****************************************/
		input wire iCORE_CLOCK,
		input wire iBUS_CLOCK,
		input wire iDPS_CLOCK,
		input wire inRESET,
		input wire iRESET_SYNC,
		/****************************************
		SCI
		****************************************/
		output wire oSCI_TXD,
		input wire iSCI_RXD,
		/****************************************
		Memory BUS
		****************************************/
		//Req
		output wire oMEMORY_REQ,
		input wire iMEMORY_LOCK,
		output wire [1:0] oMEMORY_ORDER,				//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		output wire [3:0] oMEMORY_MASK,
		output wire oMEMORY_RW,						//1:Write | 0:Read
		output wire [31:0] oMEMORY_ADDR,
		//This -> Data RAM
		output wire [31:0] oMEMORY_DATA,
		//Data RAM -> This
		input wire iMEMORY_VALID,
		output wire oMEMORY_BUSY,
		input wire [63:0] iMEMORY_DATA,	
		/****************************************
		GCI BUS
		****************************************/
		//Request
		output wire oGCI_REQ,					//Input
		input wire iGCI_BUSY,
		output wire oGCI_RW,						//0=Read : 1=Write
		output wire [31:0] oGCI_ADDR,
		output wire [31:0] oGCI_DATA,
		//Return
		input wire iGCI_REQ,						//Output
		output wire oGCI_BUSY,
		input wire [31:0] iGCI_DATA,
		//Interrupt
		input wire iGCI_IRQ_REQ,
		input wire [5:0] iGCI_IRQ_NUM,
		output wire oGCI_IRQ_ACK,
		//Interrupt Controll
		output wire oIO_IRQ_CONFIG_TABLE_REQ,
		output wire [5:0] oIO_IRQ_CONFIG_TABLE_ENTRY,
		output wire oIO_IRQ_CONFIG_TABLE_FLAG_MASK,
		output wire oIO_IRQ_CONFIG_TABLE_FLAG_VALID,
		output wire [1:0] oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL,
		output wire [31:0] oDEBUG_PC,
		output wire [31:0] oDEBUG0,
		/****************************************
		Debug
		****************************************/
		input wire iDEBUG_UART_RXD,
		output wire oDEBUG_UART_TXD,
		input wire iDEBUG_PARA_REQ,
		output wire oDEBUG_PARA_BUSY,
		input wire [7:0] iDEBUG_PARA_CMD,
		input wire [31:0] iDEBUG_PARA_DATA,
		output wire oDEBUG_PARA_VALID,
		input wire iDEBUG_PARA_BUSY,
		output wire oDEBUG_PARA_ERROR,
		output wire [31:0] oDEBUG_PARA_DATA
	);

	/********************************************************************************
	DPS Dummy
	********************************************************************************/
	assign oDEBUG_UART_TXD = 1'b1;
	assign oDEBUG_PARA_BUSY = 1'b0;
	assign oDEBUG_PARA_VALID = 1'b0;
	assign oDEBUG_PARA_ERROR = 1'b0;
	assign oDEBUG_PARA_DATA = 32'h0;
	
	/********************************************************************************
	Wire
	********************************************************************************/
	//Core 2 This
	wire free_tlb_flush;
	//Memory
	wire core2mem_inst_req;
	wire mem2core_inst_lock;
	wire [1:0] core2mem_inst_mmumod;
	wire [31:0] core2mem_inst_pdt;
	wire [31:0] core2mem_inst_addr;
	wire mem2core_inst_valid;
	wire core2mem_inst_lock;
	wire mem2core_inst_pagefault;
	wire mem2core_inst_queue_flush;
	wire [63:0] mem2core_inst_data;
	wire [27:0] mem2core_inst_mmu_flags;
	wire core2mem_data_req;
	wire mem2core_data_lock;
	wire [1:0] core2mem_data_order;	
	wire [3:0] core2mem_data_mask;
	wire core2mem_data_rw;		//0=Read | 1=Write
	wire [13:0] core2mem_data_tid;
	wire [1:0] core2mem_data_mmumod;
	wire [31:0] core2mem_data_pdt;
	wire [31:0] core2mem_data_addr;
	wire [31:0] core2mem_data_data;
	wire mem2core_data_valid;
	wire mem2core_data_pagefault;
	wire core2mem_data_lock;
	wire [63:0] mem2core_data_data;
	wire [27:0] mem2core_data_flags;
	//IO
	wire io2cpu_sysinfo_iosr_valid;
	wire [31:0] io2cpu_sysinfo_iosr;
	wire cpu2io_req;
	wire io2cpu_busy;
	wire [1:0] cpu2io_order;
	wire cpu2io_rw;
	wire [31:0] cpu2io_addr;
	wire [31:0] cpu2io_data;
	wire io2cpu_valid;
	wire [31:0] io2cpu_data;
	wire io2cpu_interrupt_valid;
	wire cpu2io_interrupt_ack;
	wire [5:0] io2cpu_interrupt_num;
	//DPS
	wire pic2dps_req;
	wire dps2pic_busy;
	wire pic2dps_rw;	
	wire [31:0] pic2dps_addr;	
	wire [31:0] pic2dps_data;	
	wire dps2pic_req;
	wire [31:0] dps2pic_data;
	wire dps2pic_irq_valid;
	wire [5:0] dps2pic_irq_num;
	wire pic2dps_irq_ack;
	//Memory Port
	wire processor2memory_req;
	wire memory2processor_lock;
	wire [1:0] processor2memory_order;
	wire [3:0] processor2memory_mask;
	wire processor2memory_rw;
	wire [31:0] processor2memory_addr;
	wire [31:0] processor2memory_data;
	wire memory2processor_req;
	wire processor2memory_busy;
	wire [63:0] memory2processor_data;
	
	wire mmu_lock = memory2processor_lock;
	
	wire debuger2processor_cmd_req;
	wire processor2debuger_cmd_busy;
	wire [3:0] debuger2processor_cmd_command;
	wire [7:0] debuger2processor_cmd_target;
	wire [31:0] debuger2processor_cmd_data;
	wire processor2debuger_cmd_valid;
	wire processor2debuger_cmd_error;
	wire [31:0] processor2debuger_cmd_data;
	
	reg b_io_write_ack;
	

	/********************************************************************************
	Memory Mode
	********************************************************************************/
	`ifdef MIST1032SA_FIRST_SIM
		
		assign oMEMORY_REQ = 1'b0;
		assign oMEMORY_ORDER = 2'h0;
		assign oMEMORY_RW = 1'b0;
		assign oMEMORY_ADDR = 32'h0;
		assign oMEMORY_DATA = 32'h0;
		assign oMEMORY_BUSY = 1'b0;
		
		sim_memory_model SIM_MEMORY_MODEL(
			.iCLOCK(iBUS_CLOCK),
			.inRESET(inRESET),
			//Req
			.iMEMORY_REQ(processor2memory_req),
			.oMEMORY_LOCK(memory2processor_lock),
			.iMEMORY_ORDER(processor2memory_order),				//00=Byte Order 01=2Byte Order 10= Word Order 11= None
			.iMEMORY_MASK(processor2memory_mask),
			.iMEMORY_RW(processor2memory_rw),						//1:Write | 0:Read
			.iMEMORY_ADDR(processor2memory_addr),
			//This -> Data RAM
			.iMEMORY_DATA(processor2memory_data),
			//Data RAM -> This
			.oMEMORY_VALID(memory2processor_req),
			.iMEMORY_LOCK(processor2memory_busy),
			.oMEMORY_DATA(memory2processor_data)
		);
	`else
		//Processor -> Memory
		assign oMEMORY_REQ = processor2memory_req;
		assign oMEMORY_ORDER = processor2memory_order;
		assign oMEMORY_MASK = processor2memory_mask;
		assign oMEMORY_RW = processor2memory_rw;
		assign oMEMORY_ADDR = processor2memory_addr;
		assign oMEMORY_DATA = processor2memory_data;
		assign oMEMORY_BUSY = processor2memory_busy;
		//Memory -> Processor
		assign memory2processor_lock = iMEMORY_LOCK;
		assign memory2processor_req = iMEMORY_VALID;
		assign memory2processor_data = iMEMORY_DATA;
	`endif
	


	/********************************************************************************
	Core 
	********************************************************************************/
	wire core2io_irq_tables_req;
	wire [5:0] core2io_irq_tables_entry;
	wire core2io_irq_tables_flag_mask;
	wire core2io_irq_tables_flag_valid;
	wire [1:0] core2io_irq_tables_flag_level;
	
	assign oIO_IRQ_CONFIG_TABLE_REQ = core2io_irq_tables_req;
	assign oIO_IRQ_CONFIG_TABLE_ENTRY = core2io_irq_tables_entry;
	assign oIO_IRQ_CONFIG_TABLE_FLAG_MASK = core2io_irq_tables_flag_mask;
	assign oIO_IRQ_CONFIG_TABLE_FLAG_VALID = core2io_irq_tables_flag_valid;
	assign oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL = core2io_irq_tables_flag_level;
	
	core_if #(32'h0) CORE_IF(
		/****************************************
		System
		****************************************/
		.iIF_CLOCK(iBUS_CLOCK),
		.iCORE_CLOCK(iCORE_CLOCK),
		.inRESET(inRESET),
		.iRESET_SYNC(iRESET_SYNC),
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
		.oINST_TID(),
		.oINST_MMUMOD(core2mem_inst_mmumod),
		.oINST_PDT(core2mem_inst_pdt),
		.oINST_ADDR(core2mem_inst_addr),
		//Data RAM -> This
		.iINST_VALID(mem2core_inst_valid),
		.oINST_BUSY(core2mem_inst_lock),
		.iINST_PAGEFAULT(mem2core_inst_pagefault),	
		.iINST_QUEUE_FLUSH(mem2core_inst_queue_flush),
		.iINST_DATA(mem2core_inst_data),
		.iINST_MMU_FLAGS(mem2core_inst_mmu_flags),
		/****************************************
		Data Memory
		****************************************/
		//Req
		.oDATA_REQ(core2mem_data_req),
		.iDATA_LOCK(mem2core_data_lock),
		.oDATA_ORDER(core2mem_data_order),	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oDATA_MASK(core2mem_data_mask),	
		.oDATA_RW(core2mem_data_rw),			//1=Write 0=Read
		.oDATA_TID(core2mem_data_tid),
		.oDATA_MMUMOD(core2mem_data_mmumod),
		.oDATA_PDT(core2mem_data_pdt),
		.oDATA_ADDR(core2mem_data_addr),
		//This -> Data RAM
		.oDATA_DATA(core2mem_data_data),
		//Data RAM -> This
		.iDATA_VALID(mem2core_data_valid),
		.iDATA_PAGEFAULT(mem2core_data_pagefault),
		.iDATA_DATA(mem2core_data_data),
		.iDATA_MMU_FLAGS(mem2core_data_flags),
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
		.iIO_VALID(io2cpu_valid || b_io_write_ack),
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
	Memory Interface
	********************************************************************************/
	//Arbiter to MMU
	wire m_arbiter2mmu_req;
	wire mmu2m_arbiter_lock;
	wire m_arbiter2mmu_data_store_ack;
	wire [1:0] m_arbiter2mmu_mmu_mode;
	wire [31:0] m_arbiter2mmu_pdt;
	wire [1:0] m_arbiter2mmu_order;
	wire [3:0] m_arbiter2mmu_mask;
	wire m_arbiter2mmu_rw;
	wire [31:0] m_arbiter2mmu_addr;
	wire [31:0] m_arbiter2mmu_data;
	wire mmu2m_arbiter_req;
	wire m_arbiter2mmu_lock;
	wire mmu2m_arbiter_store_ack;
	wire mmu2m_arbiter_pagefault;
	wire mmu2m_arbiter_queue_flush;
	wire [63:0] mmu2m_arbiter_data;
	wire [27:0] mmu2m_arbiter_mmu_flags;

	//Memory Pipe Arbiter
	memory_pipe_arbiter MEM_ARBITER(
		.iCLOCK(iBUS_CLOCK),
		.inRESET(inRESET),
		//Data(Core -> Memory)
		.iDATA_REQ(core2mem_data_req),
		.oDATA_LOCK(mem2core_data_lock),
		.iDATA_ORDER(core2mem_data_order),
		.iDATA_MASK(core2mem_data_mask),
		.iDATA_RW(core2mem_data_rw),
		.iDATA_TID(core2mem_data_tid),
		.iDATA_MMUMOD(core2mem_data_mmumod),
		.iDATA_PDT(core2mem_data_pdt),
		.iDATA_ADDR(core2mem_data_addr),
		.iDATA_DATA(core2mem_data_data),
		//Data(Memory -> Core)
		.oDATA_REQ(mem2core_data_valid),
		.iDATA_BUSY(1'b0),
		.oDATA_PAGEFAULT(mem2core_data_pagefault),
		.oDATA_DATA(mem2core_data_data),
		.oDATA_MMU_FLAGS(mem2core_data_flags),
		//Inst(Core -> Memory)
		.iINST_REQ(core2mem_inst_req),
		.oINST_LOCK(mem2core_inst_lock),
		.iINST_MMUMOD(core2mem_inst_mmumod),
		.iINST_PDT(core2mem_inst_pdt),
		.iINST_ADDR(core2mem_inst_addr),
		//Inst(Memory -> Core)
		.oINST_REQ(mem2core_inst_valid),
		.iINST_BUSY(core2mem_inst_lock),
		.oINST_PAGEFAULT(mem2core_inst_pagefault),
		.oINST_QUEUE_FLUSH(mem2core_inst_queue_flush),
		.oINST_DATA(mem2core_inst_data),
		.oINST_MMU_FLAGS(mem2core_inst_mmu_flags),
		//Memory(OutPort)
		.oMEMORY_REQ(m_arbiter2mmu_req),
		.iMEMORY_LOCK(mmu2m_arbiter_lock),
		.oMEMORY_DATA_STORE_ACK(m_arbiter2mmu_data_store_ack),
		.oMEMORY_MMU_MODE(m_arbiter2mmu_mmu_mode),
		.oMEMORY_PDT(m_arbiter2mmu_pdt),
		.oMEMORY_ORDER(m_arbiter2mmu_order),
		.oMEMORY_MASK(m_arbiter2mmu_mask),
		.oMEMORY_RW(m_arbiter2mmu_rw),
		.oMEMORY_ADDR(m_arbiter2mmu_addr),
		.oMEMORY_DATA(m_arbiter2mmu_data),
		//Memory(InPort)
		.iMEMORY_VALID(mmu2m_arbiter_req),
		.oMEMORY_BUSY(m_arbiter2mmu_lock),
		.iMEMORY_STORE_ACK(mmu2m_arbiter_store_ack),
		.iMEMORY_PAGEFAULT(mmu2m_arbiter_pagefault),
		.iMEMORY_QUEUE_FLUSH(mmu2m_arbiter_queue_flush),
		.iMEMORY_DATA(mmu2m_arbiter_data),
		.iMEMORY_MMU_FLAGS(mmu2m_arbiter_mmu_flags)
	);
	
	//MMU
	wire [3:0] processor2endian_mask;
	wire [31:0] processor2endian_data;
	
	wire [63:0] endian2processor_data;
	
	mmu_if MMU_IF(
		.iCLOCK(iBUS_CLOCK),
		.inRESET(inRESET),
		.iFREE_TLB_FLUSH(free_tlb_flush),
		/*************************
		To Core
		*************************/
		//Core -> This
		.iCORE_REQ(m_arbiter2mmu_req),
		.oCORE_LOCK(mmu2m_arbiter_lock),
		.iCORE_DATA_STORE_ACK(m_arbiter2mmu_data_store_ack),
		.iCORE_MMU_MODE(m_arbiter2mmu_mmu_mode),		//0=NoConvertion 1=none 2=1LevelConvertion 3=2LevelConvertion
		.iCORE_PDT(m_arbiter2mmu_pdt),					//Page Table Register
		.iCORE_ORDER(m_arbiter2mmu_order),
		.iCORE_MASK(m_arbiter2mmu_mask),
		.iCORE_RW(m_arbiter2mmu_rw),
		.iCORE_ADDR(m_arbiter2mmu_addr),
		.iCORE_DATA(m_arbiter2mmu_data),
		//This -> Core
		.oCORE_REQ(mmu2m_arbiter_req),
		.iCORE_LOCK(m_arbiter2mmu_lock),
		.oCORE_STORE_ACK(mmu2m_arbiter_store_ack),
		.oCORE_PAGE_FAULT(mmu2m_arbiter_pagefault),
		.oCORE_QUEUE_FLUSH(mmu2m_arbiter_queue_flush),
		.oCORE_DATA(mmu2m_arbiter_data),
		.oCORE_MMU_FLAGS(mmu2m_arbiter_mmu_flags),
		/************************
		To Memory
		************************/
		//This -> Memory
		.oMEMORY_REQ(processor2memory_req),
		.iMEMORY_LOCK(memory2processor_lock),
		.oMEMORY_ORDER(processor2memory_order),
		.oMEMORY_MASK(processor2endian_mask),
		.oMEMORY_RW(processor2memory_rw),
		.oMEMORY_ADDR(processor2memory_addr),
		.oMEMORY_DATA(processor2endian_data),
		//Memory -> This
		.iMEMORY_REQ(memory2processor_req),
		.oMEMORY_LOCK(processor2memory_busy),
		.iMEMORY_DATA(endian2processor_data)
	); 
	
	//Endian Control
	endian_controller ENDIAN_TO_MEM(
		//Source
		.iSRC_MASK(processor2endian_mask),
		.iSRC_DATA(processor2endian_data),
		//Destnation
		.oDEST_MASK(processor2memory_mask),
		.oDEST_DATA(processor2memory_data)
	);
	
	endian_controller ENDIAN_TO_CPU_L(
		//Source
		.iSRC_MASK(4'hf),
		.iSRC_DATA(memory2processor_data[31:0]),
		//Destnation
		.oDEST_MASK(),
		.oDEST_DATA(endian2processor_data[31:0])
	);
	
	endian_controller ENDIAN_TO_CPU_H(
		//Source
		.iSRC_MASK(4'hf),
		.iSRC_DATA(memory2processor_data[63:32]),
		//Destnation
		.oDEST_MASK(),
		.oDEST_DATA(endian2processor_data[63:32])
	);

	/********************************************************************************
	IO Interface
	********************************************************************************/		
	//Peripheral Interface Controller
	pic PIC( //peripheral_interface_controller
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
		.oGCI_RW(oGCI_RW),				//0=Read : 1=Write
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
	wire [5:0] core2dps_irq_tables_entry_dps = core2io_irq_tables_entry - 6'd36;
	
	dps DPS( //default_peripheral_system
		.iCLOCK(iBUS_CLOCK),
		.iDPS_BASE_CLOCK(iDPS_CLOCK),			//49.5120MHz
		.inRESET(inRESET),
		/****************************************
		IO
		****************************************/
		//IRQ Tables	
		.iDPS_IRQ_CONFIG_TABLE_REQ(core2io_irq_tables_req && (core2io_irq_tables_entry == 6'd36 || core2io_irq_tables_entry == 6'd37)),
		.iDPS_IRQ_CONFIG_TABLE_ENTRY(core2dps_irq_tables_entry_dps[1:0]),
		.iDPS_IRQ_CONFIG_TABLE_FLAG_MASK(core2io_irq_tables_flag_mask),
		.iDPS_IRQ_CONFIG_TABLE_FLAG_VALID(core2io_irq_tables_flag_valid),
		.iDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL(core2io_irq_tables_flag_level),
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
	

		
	/*********************************************************
	Write Ack(Data Pipe)
	*********************************************************/	
	//IO
	always@(posedge iBUS_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_io_write_ack <= 1'b0;
		end
		else begin
			case(b_io_write_ack)
				1'b0:
					begin
						if(!io2cpu_busy && cpu2io_req && cpu2io_rw)begin
							b_io_write_ack <= 1'b1;
						end
					end
				1'b1:
					begin
						b_io_write_ack <= 1'b0;
					end
			endcase
		end
	end

endmodule


`default_nettype wire


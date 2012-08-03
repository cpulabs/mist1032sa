/*****************************************************************************************************
MIST32 Architecture MIST1032SA Base System
	- Processor				: MIST1032SA
	- ISA Version 			: MIST32 ISA1.0
	- GCI(IO_BUS)			: GCI1.0
	- Bus Clock				: 50MHz
	- Core Clock			: 10MHz
	- memory Controller		: SDRAM
	- Data Memory			: SDRAM
	- Device List			: PS/2 Keyboard, VGA Charactor Display
	
Files that are included in this project is deliverable by all Open Design Computer Project.
http://open-arch.org

All files included in this project have been allocated in the BSD licence.	
Open Design Computer Project @Takahiro Ito
	
Make	:	2012/08/04
*****************************************************************************************************/
`include			"sdramc_50mhz.h"

`default_nettype none


module mist32_bs0(
				/******************************************************************************
				System
				******************************************************************************/
				input									iCORE_CLOCK,
				input									iBUS_CLOCK,
				input									iDPS_CLOCK,
				input									inRESET,
				/******************************************************************************
				Debug
				******************************************************************************/
				input									iDEBUG_VALID,
				input									iDEBUG_MEMIF_REQ_VALID,
				input									iDEBUG_MEMIF_REQ_DQM0,
				input									iDEBUG_MEMIF_REQ_DQM1,
				input									iDEBUG_MEMIF_REQ_DQM2,
				input									iDEBUG_MEMIF_REQ_DQM3,
				input									iDEBUG_MEMIF_REQ_RW,
				input	[24:0]							iDEBUG_MEMIF_REQ_ADDR,
				input	[31:0]							iDEBUG_MEMIF_REQ_DATA,
				output									oDEBUG_MEMIF_REQ_LOCK,
				input									iDEBUG_MEMIF_RD_VALID,
				output	[31:0]							oDEBUG_MEMIF_RD_DATA,
				output									oDEBUG_MEMIF_RD_EMPTY,
				/******************************************************************************
				SCI
				******************************************************************************/
				output									oSCI_TXD,
				input									iSCI_RXD,
				/******************************************************************************
				Memory IF
				******************************************************************************/
				output	[`ROW_BIT-1:0]					oSDRAM_ADDR,
				output	[1:0]							oSDRAM_BA,
				inout	[`IO_BIT-1:0]					ioSDRAM_DATA,
				output									onSDRAM_CS,
				output									onSDRAM_RAS,
				output									onSDRAM_CAS,
				output									onSDRAM_WE,
				output									onSDRAM_LDQM0,
				output									onSDRAM_UDQM0,
				output									onSDRAM_LDQM1,
				output									onSDRAM_UDQM1,
				output									oSDRAM_CKE,
				output									oSDRAM_CLK,
				/******************************************************************************
				GCI - IO
				******************************************************************************/
				//DEV1
				input									iDEV1_VALID,
				input									iDEV1_REQ,			//Inpuit
				output									oDEV1_BUSY,
				input	[31:0]							iDEV1_DATA,
				output									oDEV1_REQ,			//Output
				input									iDEV1_BUSY,
				output									oDEV1_RW,
				output	[31:0]							oDEV1_ADDR,
				output	[31:0]							oDEV1_DATA,
				input									iDEV1_IRQ_REQ,		//IRQ
				output									oDEV1_IRQ_BUSY,
				input	[23:0]							iDEV1_IRQ_DATA,
				output									oDEV1_IRQ_ACK,
				//DEV2
				input									iDEV2_VALID,
				input									iDEV2_REQ,			//Inpuit
				output									oDEV2_BUSY,
				input	[31:0]							iDEV2_DATA,
				output									oDEV2_REQ,			//Output
				input									iDEV2_BUSY,
				output									oDEV2_RW,
				output	[31:0]							oDEV2_ADDR,
				output	[31:0]							oDEV2_DATA,
				input									iDEV2_IRQ_REQ,		//IRQ
				output									oDEV2_IRQ_BUSY,
				input	[23:0]							iDEV2_IRQ_DATA,
				output									oDEV2_IRQ_ACK,
				//DEV3
				input									iDEV3_VALID,
				input									iDEV3_REQ,			//Inpuit
				output									oDEV3_BUSY,
				input	[31:0]							iDEV3_DATA,
				output									oDEV3_REQ,			//Output
				input									iDEV3_BUSY,
				output									oDEV3_RW,
				output	[31:0]							oDEV3_ADDR,
				output	[31:0]							oDEV3_DATA,
				input									iDEV3_IRQ_REQ,		//IRQ
				output									oDEV3_IRQ_BUSY,
				input	[23:0]							iDEV3_IRQ_DATA,
				output									oDEV3_IRQ_ACK,
				//DEV4
				input									iDEV4_VALID,
				input									iDEV4_REQ,			//Inpuit
				output									oDEV4_BUSY,
				input	[31:0]							iDEV4_DATA,
				output									oDEV4_REQ,			//Output
				input									iDEV4_BUSY,
				output									oDEV4_RW,
				output	[31:0]							oDEV4_ADDR,
				output	[31:0]							oDEV4_DATA,
				input									iDEV4_IRQ_REQ,		//IRQ
				output									oDEV4_IRQ_BUSY,
				input	[23:0]							iDEV4_IRQ_DATA,
				output									oDEV4_IRQ_ACK
	);
				
	
	
	/**************************************************************************************
	Wire & Register
	**************************************************************************************/
	//Connection (Memory)
	wire				mist1032sa2memory_req;
	wire				memory2mist1032sa_lock;
	wire	[1:0]		mist1032sa2memory_order;
	wire				mist1032sa2memory_rw;
	wire	[31:0]		mist1032sa2memory_addr;
	wire	[31:0]		mist1032sa2memory_data;
	wire				mist1032sa2memory_lock;
	//Connection (GCI)
	wire				pic2gci_req;
	wire				gci2pic_busy;
	wire				pic2gci_rw;
	wire	[31:0]		pic2gci_addr;
	wire	[31:0]		pic2gci_data;
	wire				gci2pic_req;
	wire				pic2gci_busy;
	wire	[31:0]		gci2pic_data;
	wire				gci2pic_irq_req;
	wire				pic2gci_irq_ack;
	wire	[5:0]		gci2pic_irq_num;
	wire				io_irq_ctrl_req;
	wire	[5:0]		io_irq_ctrl_entry;
	wire				io_irq_ctrl_info_mask;
	wire				io_irq_ctrl_info_valid;
	wire	[1:0]		io_irq_ctrl_info_mode;
	//Memory Controll
	wire	[3:0]		mem_request_mask;
	reg		[1:0]		b_mem_receive_state;
	reg		[63:0]		b_mem_receive_data;
	//Debug CPU Selector
	wire				memif_req_valid;
	wire				memif_req_udqm0;
	wire				memif_req_ldqm0;
	wire				memif_req_udqm1;
	wire				memif_req_ldqm1;
	wire				memif_req_rw;
	wire	[24:0]		memif_req_addr;
	wire	[31:0]		memif_req_data;
	wire				memif_rd_valid;
	//Memory Controlor
	wire				sdram_user_req_busy;
	wire				sdram_user_out_empty;
	wire	[31:0]		sdram_user_out_data;
	
	/**************************************************************************************
	Processor
	**************************************************************************************/
	mist1032sa PROCESSOR(
		/****************************************
		System
		****************************************/
		.iCORE_CLOCK(iCORE_CLOCK),
		.iBUS_CLOCK(iBUS_CLOCK),
		.iDPS_CLOCK(iDPS_CLOCK),
		.inRESET(inRESET),
		/****************************************
		SCI
		****************************************/
		.oSCI_TXD(oSCI_TXD),
		.iSCI_RXD(iSCI_RXD),
		/****************************************
		Memory BUS
		****************************************/
		//Req
		.oMEMORY_REQ(mist1032sa2memory_req),
		.iMEMORY_LOCK(memory2mist1032sa_lock || iDEBUG_VALID),
		.oMEMORY_ORDER(mist1032sa2memory_order),					//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oMEMORY_RW(mist1032sa2memory_rw),						//1:Write | 0:Read
		.oMEMORY_ADDR(mist1032sa2memory_addr),
		//This -> Data RAM
		.oMEMORY_DATA(mist1032sa2memory_data),
		//Data RAM -> This
		.iMEMORY_VALID(b_mem_receive_state == 2'h2),
		.oMEMORY_BUSY(mist1032sa2memory_lock),		//new
		.iMEMORY_DATA(b_mem_receive_data),	
		/****************************************
		GCI BUS
		****************************************/
		//Request
		.oGCI_REQ(pic2gci_req),				//Input
		.iGCI_BUSY(gci2pic_busy),
		.oGCI_RW(pic2gci_rw),				//0=Read : 1=Write
		.oGCI_ADDR(pic2gci_addr),
		.oGCI_DATA(pic2gci_data),
		//Return
		.iGCI_REQ(gci2pic_req),				//Output
		.oGCI_BUSY(pic2gci_busy),
		.iGCI_DATA(gci2pic_data),
		//Interrupt
		.iGCI_IRQ_REQ(gci2pic_irq_req),
		.iGCI_IRQ_NUM(gci2pic_irq_num),
		.oGCI_IRQ_ACK(pic2gci_irq_ack),	
		//Interrupt Controll
		.oIO_IRQ_CONFIG_TABLE_REQ(io_irq_ctrl_req),
		.oIO_IRQ_CONFIG_TABLE_ENTRY(io_irq_ctrl_entry),
		.oIO_IRQ_CONFIG_TABLE_FLAG_MASK(io_irq_ctrl_info_mask),
		.oIO_IRQ_CONFIG_TABLE_FLAG_VALID(io_irq_ctrl_info_valid),
		.oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL(io_irq_ctrl_info_mode)
	);
	
	/**************************************************************************************
	Memory Controllor
	**************************************************************************************/
	
	function [3:0] func_byte_addressing_controllor;
		input	[1:0]		func_order;
		input	[1:0]		func_address;
		begin
			if(func_address == 2'h0)begin
				case(func_order)
					2'h0:		func_byte_addressing_controllor	=	4'b0001;
					2'h1:		func_byte_addressing_controllor	=	4'b0011;
					2'h2:		func_byte_addressing_controllor	=	4'b1111;
					default:	func_byte_addressing_controllor	=	4'b0000;
				endcase
			end
			else if(func_address == 2'h1)begin
				case(func_order)
					2'h0:		func_byte_addressing_controllor	=	4'b0010;
					2'h1:		func_byte_addressing_controllor	=	4'b0110;
					default:	func_byte_addressing_controllor	=	4'b0000;
				endcase
			end
			else if(func_address == 2'h2)begin			
				case(func_order)
					2'h0:		func_byte_addressing_controllor	=	4'b0100;
					2'h1:		func_byte_addressing_controllor	=	4'b1100;
					default:	func_byte_addressing_controllor	=	4'b0000;
				endcase
			end
			else begin
				func_byte_addressing_controllor	=	4'b1000;
			end
		end
	endfunction

	

	reg		[1:0]		b_mem_request_state;
	reg		[1:0]		b_mem_request_order;
	reg		[31:0]		b_mem_request_addr;
	reg		[31:0]		b_mem_request_data;
	
	assign	memory2mist1032sa_lock		=		sdram_user_req_busy || b_mem_request_state != 2'h0;
	assign	mem_request_mask		=		func_byte_addressing_controllor(b_mem_request_order, b_mem_request_addr[1:0]);
		
	always@(posedge iBUS_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_mem_request_state		<=		2'h0;
			b_mem_request_order		<=		2'h0;
			b_mem_request_addr		<=		{32{1'h0}};
			b_mem_request_data		<=		{32{1'h0}};		
		end
		else begin
			if(!sdram_user_req_busy)begin
				case(b_mem_request_state)//synthesis parallel_case full_case
					2'h0	:	//IDLE
						begin
							if(mist1032sa2memory_req && !iDEBUG_VALID)begin
								if(!mist1032sa2memory_rw)begin
									//Read
									b_mem_request_state		<=		2'h2;
									b_mem_request_order		<=		mist1032sa2memory_order;
									b_mem_request_addr		<=		mist1032sa2memory_addr;
								end
								else begin
									//Write
									b_mem_request_state		<=		2'h1;
									b_mem_request_order		<=		mist1032sa2memory_order;
									b_mem_request_addr		<=		mist1032sa2memory_addr;
									b_mem_request_data		<=		mist1032sa2memory_data;		
								end
							end
						end
					2'h1	:	//WRITE
						begin
							b_mem_request_state		<=		2'h0;
						end
					2'h2	:	//READ1
						begin	
							b_mem_request_state		<=		2'h3;
						end
					2'h3	:	//READ2
						begin
							b_mem_request_state		<=		2'h0;
						end
				endcase
			end
		end
	end
	

	//Memory Receive	
	always@(posedge iBUS_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_mem_receive_state		<=		2'h0;
			b_mem_receive_data		<=		{64{1'b0}};
		end
		else begin
			case(b_mem_receive_state)
				2'h0	:	//IDLE	//1st Data Wait
					begin 
						if(!sdram_user_out_empty)begin
							b_mem_receive_state		<=		2'h1;
							b_mem_receive_data		<=		{32'h0, sdram_user_out_data};
						end
					end
				2'h1	:	//DGET	//2rd Data Get
					begin
						if(!sdram_user_out_empty)begin
							b_mem_receive_state		<=		2'h2;
							b_mem_receive_data		<=		{sdram_user_out_data, b_mem_receive_data[31:0]};
						end
					end
				default	:	//DATASEND
					begin
						if(!mist1032sa2memory_lock)begin
							b_mem_receive_state		<=		2'h0;
						end
					end
			endcase	
		end
	end
	
	assign			memif_req_valid		=	(iDEBUG_VALID)? iDEBUG_MEMIF_REQ_VALID : b_mem_request_state != 2'h0;
	assign			memif_req_ldqm0		=	(iDEBUG_VALID)? iDEBUG_MEMIF_REQ_DQM1 : ((b_mem_request_state == 2'h1)? !mem_request_mask[0] : 1'b0);
	assign			memif_req_udqm0		=	(iDEBUG_VALID)? iDEBUG_MEMIF_REQ_DQM0 : ((b_mem_request_state == 2'h1)? !mem_request_mask[1] : 1'b0);
	assign			memif_req_ldqm1		=	(iDEBUG_VALID)? iDEBUG_MEMIF_REQ_DQM3 : ((b_mem_request_state == 2'h1)? !mem_request_mask[2] : 1'b0);
	assign			memif_req_udqm1		=	(iDEBUG_VALID)? iDEBUG_MEMIF_REQ_DQM2 : ((b_mem_request_state == 2'h1)? !mem_request_mask[3] : 1'b0);
	assign			memif_req_rw		=	(iDEBUG_VALID)? iDEBUG_MEMIF_REQ_RW : (b_mem_request_state == 2'h1);
	assign			memif_req_addr		=	(iDEBUG_VALID)? iDEBUG_MEMIF_REQ_ADDR : ((b_mem_request_state == 2'h3)? ((b_mem_request_addr[26:2])+25'h1) : (b_mem_request_addr[26:2]));//((b_mem_request_addr>>2) : b_mem_request_addr>>2));

	assign			memif_req_data		=	(iDEBUG_VALID)? iDEBUG_MEMIF_REQ_DATA : (b_mem_request_order == 2'h0)? b_mem_request_data << (8*b_mem_request_addr[1:0]) : (
																						(b_mem_request_order == 2'h1)? b_mem_request_data << (16*b_mem_request_addr[1]) : b_mem_request_data
																					);	
	
	assign			memif_rd_valid		=	(iDEBUG_VALID)? iDEBUG_MEMIF_RD_VALID : (!sdram_user_out_empty && b_mem_receive_state != 2'h2);
	
	
	//Memory Controlor	
	sdram_controller SDRAM_C(
		//System
		.iCLOCK(iBUS_CLOCK), 
		.inRESET(inRESET),
		.iUSER_REQ_VALID(memif_req_valid), 
		.inUSER_REQ_DQM({memif_req_udqm1, memif_req_ldqm1, memif_req_udqm0, memif_req_ldqm0}),
		.iUSER_REQ_RW(memif_req_rw), 
		.iUSER_REQ_ADDR(memif_req_addr[24:0]), 
		.iUSER_REQ_DATA(memif_req_data), 
		.oUSER_REQ_LOCK(sdram_user_req_busy),
		.iUSER_OUT_VALID(memif_rd_valid), 
		.oUSER_OUT_DATA(sdram_user_out_data), 
		.oUSER_OUT_EMPTY(sdram_user_out_empty),
		.oSDRAM_ADDR(oSDRAM_ADDR), 
		.oSDRAM_BA(oSDRAM_BA), 
		.ioSDRAM_DATA(ioSDRAM_DATA), 
		.onSDRAM_CS(onSDRAM_CS), 
		.onSDRAM_RAS(onSDRAM_RAS), 
		.onSDRAM_CAS(onSDRAM_CAS), 
		.onSDRAM_WE(onSDRAM_WE), 
		.onSDRAM_DQM({onSDRAM_UDQM1, onSDRAM_LDQM1, onSDRAM_UDQM0, onSDRAM_LDQM0}),
		.oSDRAM_CKE(oSDRAM_CKE), 
		.oSDRAM_CLK(oSDRAM_CLK)
	);
	
		
	/**************************************************************************************
	GCI
	**************************************************************************************/
	wire	[5:0]		gci_irq_entry_buffer;
	assign				gci_irq_entry_buffer		=		io_irq_ctrl_entry - 6'h4;
	gci_hub GCI1_0_IO_BUS(
		/****************************************
		System
		****************************************/
		.iCLOCK(iBUS_CLOCK),
		.inRESET(inRESET),
		/****************************************
		IRQ Controllor
		****************************************/
		.iIRQ_CTRL_REQ(io_irq_ctrl_req && (io_irq_ctrl_entry >= 6'd4 && io_irq_ctrl_entry <= 6'd35)),
		.iIRQ_CTRL_ENTRY(gci_irq_entry_buffer[4:0]),
		.iIRQ_CTRL_INFO_MASK(io_irq_ctrl_info_mask),
		.iIRQ_CTRL_INFO_VALID(io_irq_ctrl_info_valid),
		.iIRQ_CTRL_INFO_MODE(io_irq_ctrl_info_mode),
		/****************************************
		PIC
		****************************************/
		.iCPU_REQ(pic2gci_req),
		.oCPU_BUSY(gci2pic_busy),
		.iCPU_RW(pic2gci_rw),
		.iCPU_ADDR(pic2gci_addr),
		.iCPU_DATA(pic2gci_data),
		.oCPU_REQ(gci2pic_req),
		.iCPU_BUSY(pic2gci_busy),
		.oCPU_DATA(gci2pic_data),
		.oCPU_IRQ_REQ(gci2pic_irq_req),
		.oCPU_IRQ_NUM(gci2pic_irq_num),
		.iCPU_IRQ_ACK(pic2gci_irq_ack),
		/****************************************
		Device Interface1
		****************************************/
		.iDEV1_VALID(iDEV1_VALID),
		.iDEV1_REQ(iDEV1_REQ),
		.oDEV1_BUSY(oDEV1_BUSY),
		.iDEV1_DATA(iDEV1_DATA),
		.oDEV1_REQ(oDEV1_REQ),
		.iDEV1_BUSY(iDEV1_BUSY),
		.oDEV1_RW(oDEV1_RW),
		.oDEV1_ADDR(oDEV1_ADDR),
		.oDEV1_DATA(oDEV1_DATA),
		.iDEV1_IRQ_REQ(iDEV1_IRQ_REQ),
		.oDEV1_IRQ_BUSY(oDEV1_IRQ_BUSY),
		.iDEV1_IRQ_DATA(iDEV1_IRQ_DATA),
		.oDEV1_IRQ_ACK(oDEV1_IRQ_ACK),
		/****************************************
		Device Interface2
		****************************************/
		.iDEV2_VALID(iDEV2_VALID),
		.iDEV2_REQ(iDEV2_REQ),
		.oDEV2_BUSY(oDEV2_BUSY),
		.iDEV2_DATA(iDEV2_DATA),
		.oDEV2_REQ(oDEV2_REQ),
		.iDEV2_BUSY(iDEV2_BUSY),
		.oDEV2_RW(oDEV2_RW),
		.oDEV2_ADDR(oDEV2_ADDR),
		.oDEV2_DATA(oDEV2_DATA),
		.iDEV2_IRQ_REQ(iDEV2_IRQ_REQ),
		.oDEV2_IRQ_BUSY(oDEV2_IRQ_BUSY),
		.iDEV2_IRQ_DATA(iDEV2_IRQ_DATA),
		.oDEV2_IRQ_ACK(oDEV2_IRQ_ACK),
		/****************************************
		Device Interface3
		****************************************/
		.iDEV3_VALID(iDEV3_VALID),
		.iDEV3_REQ(iDEV3_REQ),
		.oDEV3_BUSY(oDEV3_BUSY),
		.iDEV3_DATA(iDEV3_DATA),
		.oDEV3_REQ(oDEV3_REQ),
		.iDEV3_BUSY(iDEV3_BUSY),
		.oDEV3_RW(oDEV3_RW),
		.oDEV3_ADDR(oDEV3_ADDR),
		.oDEV3_DATA(oDEV3_DATA),
		.iDEV3_IRQ_REQ(iDEV3_IRQ_REQ),
		.oDEV3_IRQ_BUSY(oDEV3_IRQ_BUSY),
		.iDEV3_IRQ_DATA(iDEV3_IRQ_DATA),
		.oDEV3_IRQ_ACK(oDEV3_IRQ_ACK),
		/****************************************
		Device Interface4
		****************************************/
		.iDEV4_VALID(iDEV4_VALID),
		.iDEV4_REQ(iDEV4_REQ),
		.oDEV4_BUSY(oDEV4_BUSY),
		.iDEV4_DATA(iDEV4_DATA),
		.oDEV4_REQ(oDEV4_REQ),
		.iDEV4_BUSY(iDEV4_BUSY),
		.oDEV4_RW(oDEV4_RW),
		.oDEV4_ADDR(oDEV4_ADDR),
		.oDEV4_DATA(oDEV4_DATA),
		.iDEV4_IRQ_REQ(iDEV4_IRQ_REQ),
		.oDEV4_IRQ_BUSY(oDEV4_IRQ_BUSY),
		.iDEV4_IRQ_DATA(iDEV4_IRQ_DATA),
		.oDEV4_IRQ_ACK(oDEV4_IRQ_ACK)
	);
	
	
	//Memory IF Debug
	assign		oDEBUG_MEMIF_REQ_LOCK		=		sdram_user_req_busy;
	assign		oDEBUG_MEMIF_RD_DATA		=		sdram_user_out_data;
	assign		oDEBUG_MEMIF_RD_EMPTY		=		sdram_user_out_empty;
				
endmodule

`default_nettype wire


				
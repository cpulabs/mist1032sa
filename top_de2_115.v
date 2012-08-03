/*****************************************************************************************************
Files that are included in this project is deliverable by all Open Design Computer Project.
http://open-arch.org

All files included in this project have been allocated in the BSD licence.	
Open Design Computer Project @Takahiro Ito
	
Make	:	2012/08/04
*****************************************************************************************************/

`include "global.h"
`default_nettype none

module top_de2_115(
				//System
				input					CLOCK_50,				//Main Clock 50MHz
				//UART IF
				input					UART_RXD,
				output					UART_TXD,
				//SDRAM IF
				output					DRAM_CKE,
				output					DRAM_CLK,
				output					DRAM_WE_N,
				output					DRAM_CAS_N,
				output					DRAM_RAS_N,
				output					DRAM_CS_N,
				output					DRAM_DQM0,
				output					DRAM_DQM1,
				output					DRAM_DQM2,
				output					DRAM_DQM3,
				output	[1:0]			DRAM_BA,
				output	[12:0]			DRAM_ADDR,
				inout	[31:0]			DRAM_DQ,	
				//SRAM IF
				output					SRAM_CE_N,
				output					SRAM_OE_N,
				output					SRAM_WE_N,
				output					SRAM_LB_N,
				output					SRAM_UB_N,
				output	[19:0]			SRAM_ADDR,
				inout	[15:0]			SRAM_DQ,
				//VGA
				output					VGA_HS,
				output					VGA_VS,
				output	[7:0]			VGA_R,
				output	[7:0]			VGA_G,
				output	[7:0]			VGA_B,
				output					VGA_CLK,
				output					VGA_BLANK_N,
				output					VGA_SYNC_N,
				//PS2
				input					PS2_CLK,
				input					PS2_DAT,
				//SW
				input	[3:0]			KEY,					//Tact SW
				input	[17:0]			SW,						//Slide SW
				//LED
				output	[17:0]			LEDR,					//Red LED
				output	[7:0]			LEDG,					//Green LED
				//Flash
				output		[22:0]		FL_ADDR,
				inout		[7:0]		FL_DQ,
				output					FL_WE_N,
				output					FL_RST_N,
				output					FL_WP_N,
				input					FL_RY,
				output					FL_CE_N,
				output					FL_OE_N
		);
		
	
	/******************************************************************************
	Wire & Register
	******************************************************************************/
	//Clock Reset
	wire					core_clock;
	wire					reset;
	wire					pll_clock_25dot2mhz;
	wire					pll_clock_49dot512mhz_clock;
	wire					bus_clock;
	//Debugg
	wire					debug_valid;
	wire					debug_req_valid;
	wire					debug_req_dqm0;
	wire					debug_req_dqm1;
	wire					debug_req_dqm2;
	wire					debug_req_dqm3;
	wire					debug_req_rw;
	wire	[24:0]			debug_req_addr;
	wire	[31:0]			debug_req_data;
	wire					debug_req_lock;
	//GCI - Device Connection Wire
	//Device0 <---> Keyboard
	wire					keyboard2dev1_req;
	wire					dev12keyboard_busy;
	wire	[31:0]			keyboard2dev1_data;
	wire					dev12keyboard_req;
	wire					keyboard2dev1_busy;
	wire					dev12keyboard_rw;
	wire	[31:0]			dev12keyboard_addr;
	wire	[31:0]			dev12keyboard_data;
	wire					keyboard2dev1_irq_req;
	wire					dev12keyboard_irq_busy;
	wire	[23:0]			keyboard2dev1_irq_data;
	wire					dev12keyboard_irq_ack;
	//Device2 <---> Display
	wire					cuidisplay2dev2_req;
	wire					dev22cuidisplay_busy;
	wire	[31:0]			cuidisplay2dev2_data;
	wire					dev22cuidisplay_req;
	wire					cuidisplay2dev2_busy;
	wire					dev22cuidisplay_rw;
	wire	[31:0]			dev22cuidisplay_addr;
	wire	[31:0]			dev22cuidisplay_data;
	wire					cuidisplay2dev2_irq_req;
	wire					dev22cuidisplay_irq_busy;
	wire	[23:0]			cuidisplay2dev2_irq_data;
	wire					dev22keyboard_irq_ack;
	/******************************************************************************
	System Reset & Clock
	******************************************************************************/
	assign					reset		=		KEY[0];
	
	
	global_lock TOP_CLOCK(
		.iCLOCK_50(CLOCK_50),							//50MHz
		.oCORE_CLOCK(core_clock),							//50MHz
		.oDPS_CLOCK(pll_clock_49dot512mhz_clock),			//49.1520MHz
		.oBUS_CLOCK(bus_clock),								//25MHz
		.oDISP_CLOCK(pll_clock_25dot2mhz)
	);
	
	
	
	/******************************************************************************
	Debug Module
	******************************************************************************/
	generate 
		if(`DEBUG_MODE)begin
			//Flash ROM
			flash_debug FLASH_DEBUG_ROM(
				.iCLOCK(bus_clock),
				.inRESET(reset),
				//Debugg
				.oDEBUG_VALID(debug_valid),
				.oDEBUG_MEMIF_REQ_VALID(debug_req_valid),
				.oDEBUG_MEMIF_REQ_DQM0(debug_req_dqm0),
				.oDEBUG_MEMIF_REQ_DQM1(debug_req_dqm1),
				.oDEBUG_MEMIF_REQ_DQM2(debug_req_dqm2),
				.oDEBUG_MEMIF_REQ_DQM3(debug_req_dqm3),
				.oDEBUG_MEMIF_REQ_RW(debug_req_rw),
				.oDEBUG_MEMIF_REQ_ADDR(debug_req_addr),
				.oDEBUG_MEMIF_REQ_DATA(debug_req_data),
				.iDEBUG_MEMIF_REQ_LOCK(debug_req_lock),
				//Flash
				.oFLASH_ADDR(FL_ADDR),
				.iFLASH_DQ(FL_DQ),
				.onFLASH_CE(FL_CE_N),
				.onFLASH_OE(FL_OE_N),
				.onFLASH_WE(FL_WE_N),
				.onFLASH_RESET(FL_RST_N),
				.onFLASH_WP(FL_WP_N),
				.onFLASH_BYTE(),
				.inFLASH_RY(FL_RY)
			);
		end
		else begin
			//Simple ROM
			debug_rom DEBUG_ROM(
				.iCLOCK(bus_clock),
				.inRESET(reset),
				//Debugg
				.oDEBUG_VALID(debug_valid),
				.oDEBUG_MEMIF_REQ_VALID(debug_req_valid),
				.oDEBUG_MEMIF_REQ_DQM0(debug_req_dqm0),
				.oDEBUG_MEMIF_REQ_DQM1(debug_req_dqm1),
				.oDEBUG_MEMIF_REQ_DQM2(debug_req_dqm2),
				.oDEBUG_MEMIF_REQ_DQM3(debug_req_dqm3),
				.oDEBUG_MEMIF_REQ_RW(debug_req_rw),
				.oDEBUG_MEMIF_REQ_ADDR(debug_req_addr),
				.oDEBUG_MEMIF_REQ_DATA(debug_req_data),
				.iDEBUG_MEMIF_REQ_LOCK(debug_req_lock)
			);
		end
	endgenerate

	
	/******************************************************************************
	MIST32_BS0
	******************************************************************************/
	mist32_bs0 MIST32_BS0(
		/**************************************
		System
		**************************************/
		.iCORE_CLOCK(core_clock),
		.iBUS_CLOCK(bus_clock),
		.iDPS_CLOCK(pll_clock_49dot512mhz_clock),	//49.5120MHz
		.inRESET(reset),
		/**************************************
		Debugg
		**************************************/
		.iDEBUG_VALID(debug_valid),
		.iDEBUG_MEMIF_REQ_VALID(debug_req_valid),
		.iDEBUG_MEMIF_REQ_DQM0(debug_req_dqm0),
		.iDEBUG_MEMIF_REQ_DQM1(debug_req_dqm1),
		.iDEBUG_MEMIF_REQ_DQM2(debug_req_dqm2),
		.iDEBUG_MEMIF_REQ_DQM3(debug_req_dqm3),
		.iDEBUG_MEMIF_REQ_RW(debug_req_rw),
		.iDEBUG_MEMIF_REQ_ADDR(debug_req_addr),
		.iDEBUG_MEMIF_REQ_DATA(debug_req_data),
		.oDEBUG_MEMIF_REQ_LOCK(debug_req_lock),
		.iDEBUG_MEMIF_RD_VALID(1'b0),
		.oDEBUG_MEMIF_RD_DATA(/* Not Use */),
		.oDEBUG_MEMIF_RD_EMPTY(/* Not Use */),
		/****************************************
		SCI
		****************************************/
		.oSCI_TXD(UART_TXD),
		.iSCI_RXD(UART_RXD),
		/**************************************
		Memory IF
		**************************************/		
		.oSDRAM_ADDR(DRAM_ADDR),
		.oSDRAM_BA(DRAM_BA),
		.ioSDRAM_DATA(DRAM_DQ),
		.onSDRAM_CS(DRAM_CS_N),
		.onSDRAM_RAS(DRAM_RAS_N),
		.onSDRAM_CAS(DRAM_CAS_N),
		.onSDRAM_WE(DRAM_WE_N),
		.onSDRAM_LDQM0(DRAM_DQM0),
		.onSDRAM_UDQM0(DRAM_DQM1),
		.onSDRAM_LDQM1(DRAM_DQM2),
		.onSDRAM_UDQM1(DRAM_DQM3),
		.oSDRAM_CKE(DRAM_CKE),
		.oSDRAM_CLK(DRAM_CLK),
		/****************************************
		Device Interface1
		****************************************/
		.iDEV1_VALID(1'b1),								
		.iDEV1_REQ(keyboard2dev1_req),
		.oDEV1_BUSY(dev12keyboard_busy),
		.iDEV1_DATA(keyboard2dev1_data),
		.oDEV1_REQ(dev12keyboard_req),
		.iDEV1_BUSY(keyboard2dev1_busy),
		.oDEV1_RW(dev12keyboard_rw),
		.oDEV1_ADDR(dev12keyboard_addr),
		.oDEV1_DATA(dev12keyboard_data),
		.iDEV1_IRQ_REQ(keyboard2dev1_irq_req),
		.oDEV1_IRQ_BUSY(dev12keyboard_irq_busy),
		.iDEV1_IRQ_DATA(keyboard2dev1_irq_data),
		.oDEV1_IRQ_ACK(dev12keyboard_irq_ack),
		/****************************************
		Device Interface2
		****************************************/
		.iDEV2_VALID(1'b1),							
		.iDEV2_REQ(cuidisplay2dev2_req),		//
		.oDEV2_BUSY(dev22cuidisplay_busy),
		.iDEV2_DATA(cuidisplay2dev2_data),
		.oDEV2_REQ(dev22cuidisplay_req),
		.iDEV2_BUSY(cuidisplay2dev2_busy),
		.oDEV2_RW(dev22cuidisplay_rw),
		.oDEV2_ADDR(dev22cuidisplay_addr),
		.oDEV2_DATA(dev22cuidisplay_data),
		.iDEV2_IRQ_REQ(cuidisplay2dev2_irq_req),
		.oDEV2_IRQ_BUSY(dev22cuidisplay_irq_busy),
		.iDEV2_IRQ_DATA(cuidisplay2dev2_irq_data),	
		.oDEV2_IRQ_ACK(dev22keyboard_irq_ack),
		/****************************************
		Device Interface3
		****************************************/
		.iDEV3_VALID(1'b0),
		.iDEV3_REQ(1'b0),
		.oDEV3_BUSY(),
		.iDEV3_DATA({32{1'b0}}),
		.oDEV3_REQ(),
		.iDEV3_BUSY(1'b1),
		.oDEV3_RW(),
		.oDEV3_ADDR(),
		.oDEV3_DATA(),
		.iDEV3_IRQ_REQ(1'b0),
		.oDEV3_IRQ_BUSY(),
		.iDEV3_IRQ_DATA({24{1'b0}}),
		.oDEV3_IRQ_ACK(),
		/****************************************
		Device Interface4
		****************************************/
		.iDEV4_VALID(1'b0),
		.iDEV4_REQ(1'b0),
		.oDEV4_BUSY(),
		.iDEV4_DATA({32{1'b0}}),
		.oDEV4_REQ(),
		.iDEV4_BUSY(1'b01),
		.oDEV4_RW(),
		.oDEV4_ADDR(),
		.oDEV4_DATA(),
		.iDEV4_IRQ_REQ(1'b0),
		.oDEV4_IRQ_BUSY(),
		.iDEV4_IRQ_DATA({24{1'b0}}),
		.oDEV4_IRQ_ACK()
	);
	

	
	
	//Device 1 - Keyboard (This Module Output Port assign)				
	mist32_device_ps2_keyboard DEVICE0_KEYBOARD(
		.iCLOCK(bus_clock),
		.inRESET(reset),
		.iDEV_REQ(dev12keyboard_req),
		.oDEV_BUSY(keyboard2dev1_busy),
		.iDEV_RW(dev12keyboard_rw),
		.iDEV_ADDR(dev12keyboard_addr),
		.iDEV_DATA(dev12keyboard_data),
		.oDEV_REQ(keyboard2dev1_req),
		.iDEV_BUSY(dev12keyboard_busy),
		.oDEV_DATA(keyboard2dev1_data),
		.oDEV_IRQ_REQ(keyboard2dev1_irq_req),
		.iDEV_IRQ_BUSY(dev12keyboard_irq_busy),
		.oDEV_IRQ_DATA(keyboard2dev1_irq_data),
		.iDEV_IRQ_ACK(dev12keyboard_irq_ack),
		.iPS2_CLOCK(PS2_CLK),
		.iPS2_DATA(PS2_DAT)
	);

	
	
	//Device 2 - Charactor Display (This Module Output Port assign)
	mist32_device_vga640x480_60hz_adv7123 DEVICE1_DISPLAY(
		//System
		.iCLOCK(bus_clock),
		.inRESET(reset),
		.iDEV_REQ(dev22cuidisplay_req),
		.oDEV_BUSY(cuidisplay2dev2_busy),
		.iDEV_RW(dev22cuidisplay_rw),
		.iDEV_ADDR(dev22cuidisplay_addr),
		.iDEV_DATA(dev22cuidisplay_data),
		.oDEV_REQ(cuidisplay2dev2_req),
		.iDEV_BUSY(dev22cuidisplay_busy),
		.oDEV_DATA(cuidisplay2dev2_data),
		.oDEV_IRQ_REQ(cuidisplay2dev2_irq_req),
		.iDEV_IRQ_BUSY(dev22cuidisplay_irq_busy),
		.oDEV_IRQ_DATA(cuidisplay2dev2_irq_data),	
		.iDEV_IRQ_ACK(dev22keyboard_irq_ack),
		//Display Clock
		.iVGA_CLOCK(pll_clock_25dot2mhz),
		//SRAM
		.onSRAM_CE(SRAM_CE_N),
		.onSRAM_WE(SRAM_WE_N),
		.onSRAM_OE(SRAM_OE_N),
		.onSRAM_UB(SRAM_UB_N),
		.onSRAM_LB(SRAM_LB_N),
		.oSRAM_ADDR(SRAM_ADDR),
		.ioSRAM_DATA(SRAM_DQ),
		//Display
		.oDISP_HSYNC(VGA_HS),
		.oDISP_VSYNC(VGA_VS),
		//ADV7123 Output
		.oADV_CLOCK(VGA_CLK),
		.onADV_BLANK(VGA_BLANK_N),
		.onADV_SYNC(VGA_SYNC_N),
		.oADV_R(VGA_R),
		.oADV_G(VGA_G),
		.oADV_B(VGA_B)
	);		
	
	/******************************************************************************
	Module Assign
	******************************************************************************/	
	assign		LEDG		=		DRAM_ADDR[7:0];
	assign		LEDR		=		{debug_valid, 16'h0, debug_valid};//DRAM_ADDR[25:8];
	
	
		
endmodule
	
`default_nettype wire 

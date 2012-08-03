/*******************************************************
	MIST32 Default Device : Display Device
	- Display Area 640*480
	- Framelate 60Hz
	- Dot Clock 25.17MHz
	- DAC is ADV7123
	- Charactor Size : 14*8
	- Display Size(Charactor Count)
				80
		|---------------|
		|				|
	34	|				|
		|				|
		|---------------|
		
	- Memory MAP
		0~3FF			: Node Special Memory
		400				: 1Line Charactor Set (Data : ANSI Charactor = 7bit) {BackColor[31:20], CharactorColor[19:8], none[7], Charactor[6:0]}
		800				: 2Line Charactor Set (Data : ANSI Charactor = 7bit) {BackColor[31:20], CharactorColor[19:8], none[7], Charactor[6:0]}
		~
		8400			: 32Line Charactor Set (Data : ANSI Charactor = 7bit) {BackColor[31:20], CharactorColor[19:8], none[7], Charactor[6:0]}
		C000			: Display Clear CMD (Data : Collor 16bit = 5R6G5B) {none[31:16], Color[15:0]}
		C400			: Bitmap 0 (Data : Collor 15bit = 5R6G5B) {none[31:16], Color[15:0]}
		~
		1383FC			: Bitmap 307199 (Data : Collor 15bit = 5R6G5B) {none[31:16], Color[15:0]}
		
		
	
	Make	:	2011/07/17
	Update	:	2011/10/08
	
	2011/10/08
		Bug Fix : (Final Line Bug)
		Charactor Color & Charactor Back Color Adding
	2011/10/01
		Memory Access Timing Miss Fix
	2011/09/25
		Memory Write Timing Optimization
*******************************************************/
`default_nettype none


/*
`define		IRQCODE_MEMOVER			24'h000000			//Charactor Display Device Memory Size Over Access
`define		IRQCODE_READACC			24'h000001			//Read Access
*/

module mist32_device_vga640x480_60hz_adv7123(
						//System
						input				iCLOCK,
						input				inRESET,
						//BUS(DATA)-Input
						input				iDEV_REQ,		
						output				oDEV_BUSY,
						input				iDEV_RW,
						input	[31:0]		iDEV_ADDR,
						input	[31:0]		iDEV_DATA,
						//BUS(DATA)-Output
						output				oDEV_REQ,		
						input				iDEV_BUSY,
						output	[31:0]		oDEV_DATA,
						//IRQ
						output				oDEV_IRQ_REQ,		
						input				iDEV_IRQ_BUSY, 
						output	[23:0]		oDEV_IRQ_DATA, 	
						input				iDEV_IRQ_ACK,
						//Display Clock
						input				iVGA_CLOCK,
						//SRAM
						output				onSRAM_CE,
						output				onSRAM_WE,
						output				onSRAM_OE,
						output				onSRAM_UB,
						output				onSRAM_LB,
						output	[19:0]		oSRAM_ADDR,
						inout	[15:0]		ioSRAM_DATA,
						//Display
						output				oDISP_HSYNC,
						output				oDISP_VSYNC,
						//ADV7123 Output
						output				oADV_CLOCK,
						output				onADV_BLANK,
						output				onADV_SYNC,
						output	[7:0]		oADV_R,
						output	[7:0]		oADV_G,
						output	[7:0]		oADV_B
	);					
	
	/************************************************************
	Wire
	************************************************************/
	//Display Controllor
	wire				displaycontroller_wait;
	//Condition
	wire				special_addr_use_condition;
	wire				display_addr_wr_condition;
	//Special Memory
	wire	[31:0]		special_memory_rd_data;
	//Data Output Buffer
	reg					b_req;
	reg		[31:0]		b_data;
	
	/************************************************************
	Condition
	************************************************************/
	assign		special_addr_use_condition	=		iDEV_REQ && (iDEV_ADDR < 32'h00000400) && !displaycontroller_wait;
	assign		display_addr_wr_condition	=		iDEV_REQ && (iDEV_ADDR >= 32'h00000400) && !displaycontroller_wait;
	
	
	/************************************************************
	Special Memory
	************************************************************/	
	device_special_memory #(32'h001383FC + 32'h4, 32'h00000000, 32'h00000002) VGA640X480_60HZ_SPECIAL_MEM(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iSPECIAL_REQ(special_addr_use_condition),
		.iSPECIAL_RW(iDEV_RW),
		.iSPECIAL_ADDR(iDEV_ADDR[9:2]),
		.iSPECIAL_DATA(iDEV_DATA),
		.oSPECIAL_DATA(special_memory_rd_data));
	
	/************************************************************
	Display Controller
	************************************************************/		
	vga640x480_60hz_adv7123 DISPLAY_MODULE(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),				
		//Write Reqest
		.iDISP_WR_REQ(display_addr_wr_condition),
		.oDISP_WR_BUSY(displaycontroller_wait),
		.iDISP_WR_ADDR({2'h0, iDEV_ADDR[31:2]}),
		.iDISP_WR_DATA(iDEV_DATA),
		//Display Clock
		.iVGA_CLOCK(iVGA_CLOCK),
		//SRAM
		.onSRAM_CE(onSRAM_CE),
		.onSRAM_WE(onSRAM_WE),
		.onSRAM_OE(onSRAM_OE),
		.onSRAM_UB(onSRAM_UB),
		.onSRAM_LB(onSRAM_LB),
		.oSRAM_ADDR(oSRAM_ADDR),
		.ioSRAM_DATA(ioSRAM_DATA),
		//Display
		.oDISP_HSYNC(oDISP_HSYNC),
		.oDISP_VSYNC(oDISP_VSYNC),
		//ADV7123 Output
		.oADV_CLOCK(oADV_CLOCK),
		.onADV_BLANK(onADV_BLANK),
		.onADV_SYNC(onADV_SYNC),
		.oADV_R(oADV_R),
		.oADV_G(oADV_G),
		.oADV_B(oADV_B)
	);	
	
	/************************************************************
	Output Buffer
	************************************************************/	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_req			<=		1'b0;
			b_data			<=		{32{1'b0}};
		end
		else begin
			b_req			<=		(special_addr_use_condition || display_addr_wr_condition);
			b_data			<=		(special_addr_use_condition)? special_memory_rd_data : {32{1'b0}};
		end
	end
	
	
	/************************************************************
	Assign
	************************************************************/	
	assign	oDEV_BUSY		=		displaycontroller_wait;//b_data_out_wait_flag || b_specialdata_out_wait_data;
	assign	oDEV_REQ		=		b_req;//specialmemory_use_condition || data_rd_condition;
	assign	oDEV_DATA		=		b_data;//(specialmemory_use_condition)? special_memory_rd_data : {{24{1'b0}}, data_fifo_data};
	assign	oDEV_IRQ_REQ	=		1'b0;
	assign	oDEV_IRQ_DATA	=		{24{1'b0}};
	

endmodule


`default_nettype wire




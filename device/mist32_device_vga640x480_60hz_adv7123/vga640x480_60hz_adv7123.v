
`default_nettype none

module vga640x480_60hz_adv7123(
						//System
						input				iCLOCK,
						input				inRESET,				
						//Write Reqest
						input				iDISP_WR_REQ,
						output				oDISP_WR_BUSY,
						input	[31:0]		iDISP_WR_ADDR,
						input	[31:0]		iDISP_WR_DATA,
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

	//VRAM Write Command Controller 
	wire			bus_req_wait;
	wire			vram_write_req;
	wire	[18:0]	vram_write_addr;
	wire	[15:0]	vram_write_data;
	// VRAM Controll 
	wire			VramWriteFull;
	wire	[15:0]	VramReadData;
	wire			SramRw;
	wire	[15:0]	SramWriteData;
	//Display Timing
	wire			disptiming_data_req;
	wire			disptiming_blank;
	
	//VRAM Write Command Controller 
	vga_command_controller CMD_CONTROLLER(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iBUSMOD_REQ(iDISP_WR_REQ && !bus_req_wait),
		.iBUSMOD_ADDR(iDISP_WR_ADDR),
		.iBUSMOD_DATA(iDISP_WR_DATA),
		.oBUSMOD_WAIT(bus_req_wait),
		.iVRAM_WAIT(VramWriteFull),
		.oVRAM_WRITE_REQ(vram_write_req),
		.oVRAM_WRITE_ADDR(vram_write_addr),
		.oVRAM_WRITE_DATA(vram_write_data)
	);

	//Vram Controll
	vram_ctrl VRAM_CTRL(
		.iGCI_CLOCK(iCLOCK),
		.iVGA_CLOCK(iVGA_CLOCK),
		.inRESET(inRESET),
		.iBMP_WRITE_REQ(vram_write_req),
		.iBMP_WRITE_ADDR(vram_write_addr),
		.iBMP_WRITE_DATA(vram_write_data),
		.oBMP_WRITE_FULL(VramWriteFull),
		.iBMP_READ_REQ(disptiming_data_req),
		.oBMP_READ_DATA(VramReadData),
		.oBMP_READ_EMPTY(),
		.onSRAM_CE(onSRAM_CE),
		.onSRAM_WE(onSRAM_WE),
		.onSRAM_OE(onSRAM_OE),
		.onSRAM_UB(onSRAM_UB),
		.onSRAM_LB(onSRAM_LB),
		.oSRAM_ADDR(oSRAM_ADDR),
		.oSRAM_RW(SramRw),
		.iSRAM_DATA(ioSRAM_DATA),
		.oSRAM_DATA(SramWriteData)
	);
	
	
	//Display timing 
	vgatiming_640x480_60hz DISPTIMING(
		.iVGA_CLOCK(iVGA_CLOCK),
		.inRESET(inRESET),
		.oDATA_REQ(disptiming_data_req),
		.oDISP_VSYNC(oDISP_VSYNC),
		.oDISP_HSYNC(oDISP_HSYNC),
		.oDISP_BLANK(disptiming_blank)
	);
	
	//Assign
	assign		onADV_SYNC		=		1'b0;
	assign		onADV_BLANK		=		!disptiming_blank;
	assign		oADV_CLOCK		=		iVGA_CLOCK;
					
	assign		oDISP_WR_BUSY	=		bus_req_wait;
				
	assign		oADV_R			=		{VramReadData[15:11], VramReadData[11], VramReadData[11], VramReadData[11]};
	assign		oADV_G			=		{VramReadData[10:5], VramReadData[5], VramReadData[5]};
	assign		oADV_B			=		{VramReadData[4:0], VramReadData[0], VramReadData[0], VramReadData[0]};
	assign		ioSRAM_DATA		=		(SramRw)? SramWriteData : {16{1'bz}};
	
	
endmodule

`default_nettype wire


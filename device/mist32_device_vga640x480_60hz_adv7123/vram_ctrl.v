
`default_nettype none

module vram_ctrl(
						//System
						input				iGCI_CLOCK,
						input				iVGA_CLOCK,
						input				inRESET,
						//IF	
						input				iBMP_WRITE_REQ,
						input	[18:0]		iBMP_WRITE_ADDR,
						input	[15:0]		iBMP_WRITE_DATA,
						output				oBMP_WRITE_FULL,
						input				iBMP_READ_REQ,
						output	[15:0]		oBMP_READ_DATA,
						output				oBMP_READ_EMPTY,
						//SRAM
						output				onSRAM_CE,
						output				onSRAM_WE,
						output				onSRAM_OE,
						output				onSRAM_UB,
						output				onSRAM_LB,
						output	[19:0]		oSRAM_ADDR,
						output				oSRAM_RW,		//Read:0 Write:1
						input	[15:0]		iSRAM_DATA,
						output	[15:0]		oSRAM_DATA);
	
	
	//Write FIFO Wire
	wire				VramWriteFifoEmpty;
	wire	[18:0]		VramWriteFifoData_Addr;
	wire	[15:0]		VramWriteFifoData_Data;
	//VRAM Read Fifo1
	wire				VramReadFifoFull;
	wire				VramReadFifo0_Empty;
	wire	[15:0]		VramReadFifo0_Data;
	//VRAM Read Fifo2
	wire				VramReadFifo1_Full;
	wire				VramReadFifo1_Empty;
	wire	[15:0]		VramReadFifo1_Data;
	//VRAM Read Fifo3
	wire				VramReadFifo2_Full;	
	//State Buffer
	reg		[2:0]	state;
	reg		[18:0]	rWriteAddr;
	reg		[15:0]	rWriteData;
	reg		[18:0]	rReadAddr;
	reg		[4:0]	b_write_counter;
	
	
	
	/*
	sync_fifo #(35, 32, 5)	VRAMWRITE_FIFO(
		.inRESET(inRESET),
		.iCLOCK(iGCI_CLOCK),
		.iREMOVE(1'b0),
		.oCOUNT(),
		.iWR_EN(iBMP_WRITE_REQ),
		.iWR_DATA({iBMP_WRITE_ADDR, iBMP_WRITE_DATA}),
		.oWR_FULL(oBMP_WRITE_FULL),
		.iRD_EN(state == 3'h2),
		.oRD_DATA({VramWriteFifoData_Addr, VramWriteFifoData_Data}),
		.oRD_EMPTY(VramWriteFifoEmpty)
	);
	*/
	
	
	/*
	async_fifo #(35, 32, 5)	VRAMWRITE_FIFO(
		.inRESET(inRESET),
		.iREMOVE(1'b0),
		.oCOUNT(),
		.iWR_CLOCK(iGCI_CLOCK),
		.iWR_EN(iBMP_WRITE_REQ),
		.iWR_DATA({iBMP_WRITE_ADDR, iBMP_WRITE_DATA}),
		.oWR_FULL(oBMP_WRITE_FULL),
		.iRD_CLOCK(iVGA_CLOCK),
		.iRD_EN(state == 3'h2),
		.oRD_DATA({VramWriteFifoData_Addr, VramWriteFifoData_Data}),
		.oRD_EMPTY(VramWriteFifoEmpty)
	);
	*/
	
	
	/*
	async_fifo_as #(35, 5) VRAMWRITE_FIFO(
		.irst(!inRESET),
		.iclk(iGCI_CLOCK),
		.idata({iBMP_WRITE_ADDR, iBMP_WRITE_DATA}),
		.we(iBMP_WRITE_REQ),
		.full(oBMP_WRITE_FULL),
		.orst(!inRESET),
		.oclk(iVGA_CLOCK),
		.odata({VramWriteFifoData_Addr, VramWriteFifoData_Data}),
		.re(state == 3'h2),
		.empty(VramWriteFifoEmpty)
	);
	*/
	
	async_fifo #(35, 32, 5)	VRAMWRITE_FIFO(
		.inRESET(inRESET),
		.iREMOVE(1'b0),
		.iWR_CLOCK(iGCI_CLOCK),
		.iWR_EN(iBMP_WRITE_REQ),
		.iWR_DATA({iBMP_WRITE_ADDR, iBMP_WRITE_DATA}),
		.oWR_FULL(oBMP_WRITE_FULL),
		.iRD_CLOCK(iVGA_CLOCK),
		.iRD_EN(state == 3'h2),
		.oRD_DATA({VramWriteFifoData_Addr, VramWriteFifoData_Data}),
		.oRD_EMPTY(VramWriteFifoEmpty)
	);
		
	
	always@(posedge iVGA_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			state			<=		3'h0;
			rWriteAddr		<=		{19{1'b0}};
			rWriteData		<=		{16{1'b0}};
			rReadAddr		<=		{19{1'b0}};
			b_write_counter	<=		5'h00;
		end
		else begin
			case(state)
				/*Idle*/
				3'h0:
					begin
						if(VramReadFifo0_Empty)begin
							state			<=		3'h5;		//Read
						end
						else if(!VramWriteFifoEmpty)begin
							state			<=		3'h1;		//Write
							rWriteAddr		<=		VramWriteFifoData_Addr;
							rWriteData		<=		VramWriteFifoData_Data;
						end
						else begin
							state			<=		3'h0;
						end
					end
				/*Write*/
				3'h1:
					begin
							state			<=		3'h2;
					end
				3'h2:
					begin
							state			<=		3'h3;
					end
				3'h3:
					begin
						if(VramReadFifo0_Empty || VramWriteFifoEmpty)begin
							state			<=		3'h4;
						end
						else begin
							state			<=		3'h2;
							rWriteAddr		<=		VramWriteFifoData_Addr;
							rWriteData		<=		VramWriteFifoData_Data;
						end
					end
				3'h4:
					begin
						//Read
						if(VramReadFifo0_Empty)begin
							state			<=		3'h5;
						end
						else begin
							state			<=		3'h0;
						end
					end
				/*Read*/
				3'h5:			//1St
					begin
						state			<=		3'h6;		
					end
				3'h6:			//2d ~ 
					begin
						if(rReadAddr >= 19'h4B000 -1)begin
							rReadAddr		<=		{19{1'b0}};
						end 
						else begin
							rReadAddr		<=		rReadAddr + {{18{1'b0}}, 1'b1};
						end
					
						if(VramReadFifo1_Full)begin
							state			<=		3'h7;
						end
						else begin
							state			<=		3'h6;
						end
						
						b_write_counter	<=		b_write_counter + 5'h1;
					end
				3'h7:
					begin		//Read Finalize
						if(rReadAddr >= 19'h4B000 -1)begin
							rReadAddr		<=		{19{1'b0}};
						end 
						else begin
							rReadAddr		<=		rReadAddr + {{18{1'b0}}, 1'b1};
						end
						b_write_counter	<=		5'h00;
						state			<=		3'h0;
					end
			endcase
		end
	end
	
	sync_fifo #(16, 4, 2)	VRAMREAD_FIFO_0(
		.iCLOCK(iVGA_CLOCK),
		.inRESET(inRESET),
		.iREMOVE(1'b0),
		.oCOUNT(),
		.iWR_EN(state == 3'h6 | state == 3'h7),
		.iWR_DATA(iSRAM_DATA),
		.oWR_FULL(VramReadFifoFull),
		.iRD_EN(!VramReadFifo1_Full && !VramReadFifo0_Empty),
		.oRD_DATA(VramReadFifo0_Data),
		.oRD_EMPTY(VramReadFifo0_Empty)
	);
	
	sync_fifo #(16, 64, 6)	VRAMREAD_FIFO_1(
		.iCLOCK(iVGA_CLOCK),
		.inRESET(inRESET),
		.iREMOVE(1'b0),
		.oCOUNT(),
		.iWR_EN(!VramReadFifo1_Full && !VramReadFifo0_Empty),
		.iWR_DATA(VramReadFifo0_Data),
		.oWR_FULL(VramReadFifo1_Full),
		.iRD_EN(!VramReadFifo2_Full && !VramReadFifo1_Empty),
		.oRD_DATA(VramReadFifo1_Data),
		.oRD_EMPTY(VramReadFifo1_Empty)
	);
	
	sync_fifo #(16, 4, 2)	VRAMREAD_FIFO_2(
		.iCLOCK(iVGA_CLOCK),
		.inRESET(inRESET),
		.iREMOVE(1'b0),
		.oCOUNT(/* Not Use*/),
		.iWR_EN(!VramReadFifo2_Full && !VramReadFifo1_Empty),
		.iWR_DATA(VramReadFifo1_Data),
		.oWR_FULL(VramReadFifo2_Full),
		.iRD_EN(iBMP_READ_REQ),
		.oRD_DATA(oBMP_READ_DATA),
		.oRD_EMPTY(oBMP_READ_EMPTY)
	);

	
	/*
	async_fifo #(16, 32, 5)	VRAMREAD_FIFO(
		.inRESET(inRESET),
		.iREMOVE(1'b0),
		.oCOUNT(VramReadFifoCount),
		.iWR_CLOCK(iGCI_CLOCK),
		.iWR_EN(state == 3'h6 | state == 3'h7),
		.iWR_DATA(iSRAM_DATA),
		.oWR_FULL(VramReadFifoFull),
		.iRD_CLOCK(iVGA_CLOCK),
		.iRD_EN(iBMP_READ_REQ),
		.oRD_DATA(oBMP_READ_DATA),
		.oRD_EMPTY(oBMP_READ_EMPTY)
	);*/
	
	
	//Memory IF
	assign	onSRAM_CE		=		(state == 3'h1 || state == 3'h2 || state == 3'h3 || state == 3'h5 || state == 3'h6)? 1'b0 : 1'b1;
	assign	onSRAM_WE		=		(state == 3'h1 || state == 3'h2 || state == 3'h3)? 1'b0 : 1'b1;
	assign	onSRAM_OE		=		1'b0;
	assign	onSRAM_UB		=		(state == 3'h2 || state == 3'h5 || state == 3'h6)? 1'b0 : 1'b1;
	assign	onSRAM_LB		=		(state == 3'h2 || state == 3'h5 || state == 3'h6)? 1'b0 : 1'b1;
	assign	oSRAM_ADDR		=		(state == 3'h1 || state == 3'h2 || state == 3'h3/*state == 3'h1*/)? rWriteAddr : rReadAddr;	
	assign	oSRAM_RW		=		(state == 3'h2/*state == 3'h2*//*state == 3'h1 || state == 3'h2*//*3'h1*/)? 1'b1 : 1'b0;
	assign	oSRAM_DATA		=		rWriteData;
	
	
endmodule


`default_nettype wire

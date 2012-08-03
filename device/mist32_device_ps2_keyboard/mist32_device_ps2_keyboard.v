/*******************************************************
	MIST32 Default Device : PS2 Keyboard Controller
		
	- Memory MAP
		0~255(0~3FF)		: System Special Addr
		32'h00000100(400)	: Key Scancode Output ([8]Valid bit  [7:0]Key Scan code)
		
	Make	:	2011/07/17
	Update	:	
*******************************************************/



`default_nettype none

module mist32_device_ps2_keyboard
	#(	
		parameter		BUFFER_COUNT		=		32,
		parameter		BUFFER_COUNT_N		=		5
	)(
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
		//PS2
		input				iPS2_CLOCK,
		input				iPS2_DATA
	);	
					
	/************************************************************
	Wire & Register
	************************************************************/						
	//Data Output Buffer
	reg					b_req;
	reg		[31:0]		b_data;
	//PS2 Interface
	wire				ps2_if_req;
	wire	[7:0]		ps2_if_data;
	//Write Condition
	wire				specialmemory_use_condition;
	wire				queue_write_condition;
	wire				data_rd_condition;	
	wire				irq_rd_condition;
	//Special Memory
	wire	[31:0]		special_memory_rd_data;
	//Keyboard Queue
	wire				data_fifo_full;
	wire				data_fifo_empty;
	wire	[7:0]		data_fifo_data;
	//IRQ Buffer
	wire				irq_counter_full;
	wire				irq_counter_empty;
	
	/************************************************************
	PS2 Interface 
	************************************************************/	
	ps2_receive PS2_IF_KEYBOARD(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Receive
		.oPS2MOD_REQ(ps2_if_req),
		.oPS2MOD_DATA(ps2_if_data),
		//PS2
		.iPS2_CLOCK(iPS2_CLOCK),
		.iPS2_DATA(iPS2_DATA)
	);
	
	/************************************************************
	Condition CTRL
	************************************************************/	
	assign				specialmemory_use_condition	=		iDEV_REQ && iDEV_ADDR < 32'h00000400;
	assign				queue_write_condition		=		ps2_if_req && !data_fifo_full && !irq_counter_full;
	assign				data_rd_condition			=		/*!data_fifo_empty && 2011/10/05*/(iDEV_REQ && iDEV_ADDR == 32'h00000400);                //iDEV_REQ & (iDEV_ADDR < 32'h00000100);
	assign				irq_rd_condition			=		!irq_counter_empty && !iDEV_IRQ_BUSY;
	
	
	/************************************************************
	Special Memory
	************************************************************/	
	//Use Size  (GCI-Node Special Memory : 0~3FF) + (Use IO : 0x4) = 401  Entry
	device_special_memory #(32'h00000400 + 32'h4, 32'h0000000A, 32'h00000001) PS2_KEYBOARD_SPECIAL_MEM(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iSPECIAL_REQ(specialmemory_use_condition),
		.iSPECIAL_RW(iDEV_RW),
		.iSPECIAL_ADDR(iDEV_ADDR[9:2]),
		.iSPECIAL_DATA(iDEV_DATA),
		.oSPECIAL_DATA(special_memory_rd_data));
	
	/************************************************************
	Data Queue
	************************************************************/	
	sync_fifo #(8, BUFFER_COUNT, BUFFER_COUNT_N) KEYBOARD_DATA_FIFO(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(1'b0),
		.oCOUNT(/*Not Use*/),
		.iWR_EN(queue_write_condition),
		.iWR_DATA(ps2_if_data),
		.oWR_FULL(data_fifo_full),
		.iRD_EN(data_rd_condition && !data_fifo_empty),
		.oRD_DATA(data_fifo_data),
		.oRD_EMPTY(data_fifo_empty)
	);
	
	/************************************************************
	IRQ Queue (Counter)
	************************************************************/		
	reg	[BUFFER_COUNT_N-1:0]	b_irq_counter;
	
	assign		irq_counter_full		=		(b_irq_counter == {BUFFER_COUNT_N{1'b1}})? 1'b1 : 1'b0;
	assign		irq_counter_empty		=		(b_irq_counter == {BUFFER_COUNT_N{1'b0}})? 1'b1 : 1'b0;		
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_counter		<=		{BUFFER_COUNT_N{1'b0}};
		end
		else begin
			//IRQ Regist
			if(queue_write_condition)begin
				if(!irq_rd_condition)begin
					b_irq_counter		<=		b_irq_counter + {{BUFFER_COUNT_N-1{1'b0}}, 1'b1};
				end
			end
			//No IRQ Regist
			else begin
				if(irq_rd_condition)begin
					b_irq_counter		<=		b_irq_counter - {{BUFFER_COUNT_N-1{1'b0}}, 1'b1};
				end
			end
		end
	end //always
	
	
	//Data Output Buffer
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_req			<=		1'b0;
			b_data			<=		{32{1'b0}};
		end
		else begin
			b_req			<=		(specialmemory_use_condition || data_rd_condition);
			b_data			<=		(specialmemory_use_condition)? special_memory_rd_data : (!data_fifo_empty)?/*2011/10/05*/ {{23{1'b0}}, 1'b1, data_fifo_data} : {32{1'b0}}/*2011/10/05*/;
		end
	end

	
	
	
	/************************************************************
	Assign
	************************************************************/	
	assign	oDEV_BUSY		=		iDEV_BUSY;//b_data_out_wait_flag || b_specialdata_out_wait_data;
	assign	oDEV_REQ		=		b_req;//specialmemory_use_condition || data_rd_condition;
	assign	oDEV_DATA		=		b_data;//(specialmemory_use_condition)? special_memory_rd_data : {{24{1'b0}}, data_fifo_data};
	assign	oDEV_IRQ_REQ	=		irq_rd_condition;
	assign	oDEV_IRQ_DATA	=		{24{1'b0}};
	
endmodule


`default_nettype wire

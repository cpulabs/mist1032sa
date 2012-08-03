`default_nettype none


`define		INI0_WAIRT				3'h0
`define		INI1_GET_MEMSIZE		3'h1	
`define		INI2_GET_PRIORITY		3'h2
`define		IDLE					3'h3
`define		WRITE					3'h4
`define		READ					3'h5
`define		DATAOUT					3'h6

`define		MEMSIZE_ADDR			32'h00000000
`define		PRIORITY_ADDR			32'h00000004
`define		INTFLAG_ADDR			32'h00000008

module gci_node
	#(
		parameter		NODE_ID			=		8'h01,
		parameter		RESET_CYCLE		=		8'h0F
	)(
		//System
		input				iCLOCK,
		input				inRESET,
		//Node Valid
		output				oNODE_VALID,
		//Node Info
		output				oNODEINFO_VALID,
		output	[7:0]		oNODEINFO_PRIORITY,
		output	[31:0]		oNODEINFO_MEMSIZE,
		//MASTER-DATA
		input				iMASTER_REQ,	//Inpuit
		output				oMASTER_BUSY,
		input				iMASTER_RW,
		input	[31:0]		iMASTER_ADDR,
		input	[31:0]		iMASTER_DATA,
		output				oMASTER_REQ,	//Output
		input				iMASTER_BUSY,
		output	[31:0]		oMASTER_DATA,
		//MASTER-IRQ
		output				oMASTER_IRQ_REQ,
		input				iMASTER_IRQ_ACK,
		input				iMASTER_IRQ_BUSY,
		//DEV-DATA
		input				iDEV_VALID,
		input				iDEV_REQ,		//Inpuit
		output				oDEV_BUSY,	
		input	[31:0]		iDEV_DATA,
		output				oDEV_REQ,		//Output
		input				iDEV_BUSY,
		output				oDEV_RW,
		output	[31:0]		oDEV_ADDR,
		output	[31:0]		oDEV_DATA,
		//DEV-IRQ
		input				iDEV_IRQ_REQ,
		output				oDEV_IRQ_BUSY,
		input	[23:0]		iDEV_IRQ_DATA,
		output				oDEV_IRQ_ACK
	);
						
						

	
	
	/************************************************************
	Device Valid Check
	************************************************************/
	/*
	reg		device_valid;
	always@(posedge ICLOCK or negedge inRESET)begin
		if(!inRESET)begin
			device_valid		<=		1'b0;
		end
		else begin
			if(iRESETAFTER_1CYCLE)begin
				device_valid		<=		iDEV_VALID
			end
		end
	end // Degice
	*/
	
	
	
	/************************************************************
	State(IRQ)
	************************************************************/
	`define				IRQ_STT_IDLE			2'h0
	`define				IRQ_STT_ACK_WAIT		2'h1
	`define				IRQ_STT_FLAGGET_WAIT	2'h2
	reg					b_irq_valid;
	reg		[1:0]		b_irq_state;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_valid				<=			1'b0;
			b_irq_state				<=			`IRQ_STT_IDLE;
		end
		else begin	
			if(iDEV_VALID && !iMASTER_IRQ_BUSY)begin		
				//Device Valid
				case(b_irq_state)
					`IRQ_STT_IDLE:
						begin
							if(iDEV_IRQ_REQ)begin
								b_irq_valid				<=			1'b1;	
								b_irq_state				<=			`IRQ_STT_ACK_WAIT;
							end
						end
					`IRQ_STT_ACK_WAIT:
						begin
							if(iMASTER_IRQ_ACK)begin
								b_irq_valid				<=			1'b0;	
								b_irq_state				<=			`IRQ_STT_FLAGGET_WAIT;
							end
						end
					`IRQ_STT_FLAGGET_WAIT:
						begin
							if(iMASTER_ADDR == `INTFLAG_ADDR && iMASTER_REQ && !iMASTER_RW)begin
								b_irq_state				<=			`IRQ_STT_IDLE;
							end
						end
				endcase
			end
		end
	end //IRQ State
	
	
	
	/************************************************************
	State(Data)
	************************************************************/
	
	reg		[2:0]		b_state;
	reg					b_rw;			//Write=1 : Read = 0
	reg		[31:0]		b_waddr;
	reg		[31:0]		b_wdata;
	reg					b_rwait;
	reg		[31:0]		b_rdata;
	//Initial
	reg					bn_initialmode;
	reg		[7:0]		b_resetcounter;
	reg		[7:0]		b_priority;
	reg		[31:0]		b_memsize;
	

	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state			<=			3'h0;
			b_rw			<=			1'b0;
			b_waddr			<=			{32{1'b0}};
			b_wdata			<=			{32{1'b0}};
			b_rwait			<=			1'b0;
			b_rdata			<=			{32{1'b0}};
			bn_initialmode	<=			1'b0;
			b_resetcounter	<=			8'h00;
			b_priority		<=			8'h00;
			b_memsize		<=			{32{1'b0}};
		end
		else begin
			if(iDEV_VALID)begin		
				//Device Valid		
				//Read & Write Wait
				if(b_rwait)begin
					if(iDEV_REQ)begin
						if(bn_initialmode)begin
							//Write
							if(b_state == `WRITE)begin
								b_state			<=			`DATAOUT;
								b_rwait			<=			1'b0;
								b_rdata			<=			32'h00000000;
							end
							//Read
							else begin
								b_state			<=			`DATAOUT;
								b_rwait			<=			1'b0;
								b_rdata			<=			iDEV_DATA;
							end
						end
						else begin
							//Init Mode
							if(b_state == `INI1_GET_MEMSIZE)begin
								b_state			<=			`INI2_GET_PRIORITY;
								b_rwait			<=			1'b0;
								b_memsize		<=			iDEV_DATA;//[7:0];
							end
							else begin
								b_state			<=			`IDLE;
								bn_initialmode	<=			1'b1;
								b_rwait			<=			1'b0;
								b_priority		<=			iDEV_DATA[7:0];
							end
						end
					end
				end
				//State
				else begin 
					case(b_state)
						`INI0_WAIRT:
							begin
								if(b_resetcounter > RESET_CYCLE[7:0])begin
									b_state			<=			`INI1_GET_MEMSIZE;	
									b_waddr			<=			`MEMSIZE_ADDR;
									b_resetcounter	<=			8'h00;
								end
								else begin
									b_resetcounter	<=			b_resetcounter + 8'h01;
								end
							end
						`INI1_GET_MEMSIZE:
							begin
								b_waddr			<=			`PRIORITY_ADDR;
								b_rwait			<=			1'b1;
							end
						`INI2_GET_PRIORITY:
							begin
								b_rwait			<=			1'b1;
							end
						`IDLE:
							begin
								if(!iDEV_BUSY)begin
									if(iMASTER_REQ)begin
										if(iMASTER_RW)begin
											b_state			<=			`WRITE;		
											b_rw			<=			1'b1;
											b_waddr			<=			iMASTER_ADDR;
											b_wdata			<=			iMASTER_DATA;
										end
										else begin
											b_state			<=			`READ;
											b_rw			<=			1'b0;
											b_waddr			<=			iMASTER_ADDR;
										end
									end
								end
							end
						`WRITE:
							begin
								b_rwait			<=			1'b1;
							end
						`READ:	
							begin
								b_rwait			<=			1'b1;
							end
						`DATAOUT:
							begin
								if(iMASTER_REQ && !iDEV_BUSY)begin
									if(iMASTER_RW)begin
										b_state			<=			`WRITE;
										b_rw			<=			1'b1;
										b_waddr			<=			iMASTER_ADDR;
										b_wdata			<=			iMASTER_DATA;
									end
									else begin
										b_state			<=			`READ;
										b_rw			<=			1'b0;
										b_waddr			<=			iMASTER_ADDR;
									end
								end
								else begin
									b_state			<=			`IDLE;
								end
							end
					endcase
				end
			end
		end 
		
	end //End State Control always
	
	
	
	/************************************************************
	Assign
	************************************************************/
	//Device Valid
	assign			oNODE_VALID				=	iDEV_VALID;
	//Node Info
	assign			oNODEINFO_VALID			=	bn_initialmode;
	assign			oNODEINFO_PRIORITY		=	b_priority;
	assign			oNODEINFO_MEMSIZE		=	b_memsize;
	//MASTER-DATA Input
	assign			oMASTER_BUSY			=	!(b_state == `IDLE || b_state == `DATAOUT) || iDEV_BUSY;
	//MASTER-DATA Output
	assign			oMASTER_REQ				=	b_state == `DATAOUT;
	assign			oMASTER_DATA			=	b_rdata;
	//MASTER-IRQ
	assign			oMASTER_IRQ_REQ			=	b_irq_valid;
	//DEVICE-DATA Input
	assign			oDEV_BUSY				=	1'b0;
	//DEVICE-DATA Output
	assign			oDEV_REQ				=	(b_state == `WRITE || b_state == `READ || b_state == `INI1_GET_MEMSIZE || b_state == `INI2_GET_PRIORITY) && !b_rwait;
	assign			oDEV_RW					=	b_rw;
	assign			oDEV_ADDR				=	b_waddr;
	assign			oDEV_DATA				=	(b_state == `READ)? {32{1'b0}} : b_wdata;
	//DEVICE-IRQ
	assign			oDEV_IRQ_BUSY			=	iMASTER_IRQ_BUSY;
	assign			oDEV_IRQ_ACK			=	(iMASTER_ADDR == `INTFLAG_ADDR && iMASTER_REQ && !iMASTER_RW)? 1'b1 : 1'b0;
	
	
endmodule



`default_nettype wire

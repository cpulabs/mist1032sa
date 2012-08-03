//DPS is 256Word Address 

`default_nettype none	


module default_peripheral_system(
							input						iCLOCK,
							input						iDPS_BASE_CLOCK,			//49.5120MHz
							input						inRESET,
							
							/****************************************
							IO
							****************************************/	
							//IRQ Tables	
							input						oDPS_IRQ_CONFIG_TABLE_REQ,
							input						oDPS_IRQ_CONFIG_TABLE_ENTRY,			//UTIM64_IRT | LSFLAGS_IRT 
							input						oDPS_IRQ_CONFIG_TABLE_FLAG_MASK,
							input						oDPS_IRQ_CONFIG_TABLE_FLAG_VALID,
							input		[1:0]			oDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL,
							//Req
							input						iDPS_REQ,
							output						oDPS_BUSY,
							input						iDPS_RW,			//1:Write
							input		[31:0]			iDPS_ADDR,
							//
							input		[31:0]			iDPS_DATA,
							//Output
							output						oDPS_VALID,
							output		[31:0]			oDPS_DATA,
							/****************************************
							Interrupt
							****************************************/
							output						oDPS_IRQ_REQ,
							output		[5:0]			oDPS_IRQ_NUM,
							input						iDPS_IRQ_ACK,
							/****************************************
							Device
							****************************************/
							output						oSCI_TXD,
							input						iSCI_RXD
	);
	


	/*********************************
	Condition
	*********************************/
	wire			utim64_condition;
	wire			sci_condition;
	assign			utim64_condition		=	!utim64_busy && !sci_busy && iDPS_REQ && (iDPS_ADDR <= 32'h74);
	assign			sci_condition			=	!utim64_busy && !sci_busy && iDPS_REQ && ((iDPS_ADDR == 100) || (iDPS_ADDR == 108));
	
	wire			utim64_busy;
	wire			sci_busy;
	
	
	/*********************************
	DPD Acess Stamp
	*********************************/
	`define		MAIN_STT_IDLE		1'h0
	`define		MAIN_STT_RD_WAIT	1'h1
	
	wire			utim64_r_valid;
	wire	[31:0]	utim64_r_data;
	wire			sci_r_valid;
	wire	[31:0]	sci_r_data;
	
	reg				b_stamp_state;
	reg				b_stamp;				//0:UTIM64 | 1:SCI
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_stamp_state		<=		`MAIN_STT_IDLE;
			b_stamp				<=		1'b0;
		end
		else begin
			case(b_stamp_state)
				`MAIN_STT_IDLE:
					begin
						if(iDPS_RW)begin
							if(utim64_condition)begin
								b_stamp_state		<=		`MAIN_STT_RD_WAIT;
								b_stamp				<=		1'b0;
							end
							else if(sci_condition)begin
								b_stamp_state		<=		`MAIN_STT_RD_WAIT;
								b_stamp				<=		1'b1;
							end
						end
					end
				`MAIN_STT_RD_WAIT:
					begin
						if(utim64_r_valid || sci_r_valid)begin
							b_stamp_state		<=		`MAIN_STT_IDLE;
						end
					end
			endcase
		end
	end
	
	
	/*********************************
	DPS Device
	*********************************/
	wire	[4:0]	utim64_mode;
	assign			utim64_mode				=	iDPS_ADDR[6:2];
	wire			utim64_irq;
	wire			utim64_ack;
	
	
	dps_utim64 DPS_UTIM64(
		//System
		.iCLOCK(iCLOCK),				//Global Clock
		.inRESET(inRESET),
		//Timer Clock
		.iTIMER_CLOCK(iDPS_BASE_CLOCK),
		//Counter
		.iREQ_VALID(utim64_condition),
		.oREQ_BUSY(utim64_busy),
		.iREQ_RW(iDPS_RW),
		.iREQ_ADDR(utim64_mode),
		.iREQ_DATA(iDPS_DATA),
		.oREQ_VALID(utim64_r_valid),
		.oREQ_DATA(utim64_r_data),
		//Interrupt
		.oIRQ_VALID(utim64_irq),
		.iIRQ_ACK(utim64_ack)
	);
	
	
	wire	[1:0]	sci_addr;
	assign			sci_addr				=	iDPS_ADDR[3:2];
	wire			sci_irq;
	wire			sci_ack;
	dps_sci DPS_SCI(
		.iIF_CLOCK(iCLOCK),
		.iDPS_BASE_CLOCK(iDPS_BASE_CLOCK),
		//Reset
		.inRESET(inRESET),
		//CPU Interface
		.iREQ_VALID(sci_condition),
		.oREQ_BUSY(sci_busy),		//Ignore
		.iREQ_RW(iDPS_RW),
		.iREQ_ADDR(sci_addr),
		.iREQ_DATA(iDPS_DATA),
		.oREQ_VALID(sci_r_valid),
		.oREQ_DATA(sci_r_data),
		//UART
		.oUART_TXD(oSCI_TXD),
		.iUART_RXD(iSCI_RXD),
		//IRQ
		.oIRQ_VALID(sci_irq),
		.iIRQ_ACK(sci_ack)
	);
	
	/*********************************
	IRQ Controlor
	*********************************/
	wire			irq_bum_buffer;
	//IRQ Controlor
	dps_irq IRQ_MNGR(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//IRQ Tables	
		.oDPS_IRQ_CONFIG_TABLE_REQ(oDPS_IRQ_CONFIG_TABLE_REQ),
		.oDPS_IRQ_CONFIG_TABLE_ENTRY(oDPS_IRQ_CONFIG_TABLE_ENTRY),
		.oDPS_IRQ_CONFIG_TABLE_FLAG_MASK(oDPS_IRQ_CONFIG_TABLE_FLAG_MASK),
		.oDPS_IRQ_CONFIG_TABLE_FLAG_VALID(oDPS_IRQ_CONFIG_TABLE_FLAG_VALID),
		.oDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL(oDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL),
		//IRQ
		.iUTIM64FLAGS_IRQ(utim64_irq),			//IRQ Req Enable
		.oUTIM64FLAGS_ACK(utim64_ack),			
		.iLSFLAGS_IRQ(sci_irq),
		.oLSFLAGS_ACK(sci_ack),		
		//IRQ Out
		.oIRQ_VALID(oDPS_IRQ_REQ),
		.oIRQ_NUM(irq_bum_buffer),
		.iIRQ_ACK(iDPS_IRQ_ACK)
	);
	
	assign		oDPS_IRQ_NUM	=		6'h36 + {5'h00, irq_bum_buffer};
	
	assign		oDPS_BUSY		=		!b_stamp_state || utim64_busy || sci_busy;
	assign		oDPS_VALID		=		(b_stamp)? sci_r_valid : utim64_r_valid;
	assign		oDPS_DATA		=		(b_stamp)? sci_r_data : utim64_r_data;
	
endmodule


`default_nettype wire


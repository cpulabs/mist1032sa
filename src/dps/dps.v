
`default_nettype none	


module dps(
		input wire iCLOCK,
		input wire iDPS_BASE_CLOCK,			//49.5120MHz
		input wire inRESET,
		/****************************************
		IO
		****************************************/	
		//IRQ Tables	
		input wire iDPS_IRQ_CONFIG_TABLE_REQ,
		input wire [1:0] iDPS_IRQ_CONFIG_TABLE_ENTRY,			//[0]UTIM64_IRT | [1]LSFLAGS_IRT | [2~3]Reserved 
		input wire iDPS_IRQ_CONFIG_TABLE_FLAG_MASK,
		input wire iDPS_IRQ_CONFIG_TABLE_FLAG_VALID,
		input wire [1:0] iDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL,
		//Req
		input wire iDPS_REQ,
		output wire oDPS_BUSY,
		input wire iDPS_RW,			//1:Write
		input wire [31:0] iDPS_ADDR,
		//
		input wire [31:0] iDPS_DATA,
		//Output
		output wire oDPS_VALID,
		output wire [31:0] oDPS_DATA,
		/****************************************
		Interrupt
		****************************************/
		output wire oDPS_IRQ_REQ,
		output wire [5:0] oDPS_IRQ_NUM,
		input wire iDPS_IRQ_ACK,
		/****************************************
		Device
		****************************************/
		output wire oSCI_TXD,
		input wire iSCI_RXD
	);
	
	/*********************************
	State
	*********************************/
	localparam MAIN_STT_IDLE = 1'h0;
	localparam MAIN_STT_RD_WAIT = 1'h1;
	
	/*********************************
	Wire
	*********************************/
	//Busy
	wire utim64_busy;
	wire sci_busy;
	//Module - > This Module
	wire utim64_r_valid;
	wire [31:0] utim64_r_data;
	wire [4:0] utim64_mode = iDPS_ADDR[6:2];
	wire utim64_irq;
	wire utim64_ack;
	wire sci_tire_irq;
	wire sci_rire_irq;
	wire [1:0] sci_addr = iDPS_ADDR[3:2];
	wire sci_irq;
	wire sci_ack;
	wire sci_r_valid;
	wire [31:0] sci_r_data;
	wire mimsr_r_valid;
	wire [31:0] mimsr_r_data;
	wire lsflags_r_valid;
	wire [31:0] lsflags_r_data;
	reg b_stamp_state;
	reg [1:0] b_stamp;
	//IRQ NUM Check
	wire irq_bum_buffer;
	
	//Condition
	wire dps_request_lock = oDPS_BUSY || utim64_busy || sci_busy;
	wire utim64_condition = !dps_request_lock && iDPS_REQ && ((iDPS_ADDR <= 32'h74) || (iDPS_ADDR == 32'h7c));
	wire sci_condition = !dps_request_lock && iDPS_REQ && ((iDPS_ADDR == 32'h100) || (iDPS_ADDR == 32'h104) || (iDPS_ADDR == 32'h108));
	wire mimsr_condition = !dps_request_lock && iDPS_REQ && (iDPS_ADDR == 32'h120);
	wire lsflags_condition = !dps_request_lock && iDPS_REQ && (iDPS_ADDR == 32'h1FC);
	
	localparam PL_LOAD_STT_UTIM64 = 2'h0;
	localparam PL_LOAD_STT_SCI = 2'h1;
	localparam PL_LOAD_STT_MIMSR = 2'h2;
	localparam PL_LOAD_STT_LSFLAGS = 2'h3;
	
	/*********************************
	Read Wait State
	*********************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_stamp_state <= MAIN_STT_IDLE;
			b_stamp <= PL_LOAD_STT_UTIM64;
		end
		else begin
			case(b_stamp_state)
				MAIN_STT_IDLE:
					begin
						if(!iDPS_RW)begin
							if(utim64_condition)begin
								b_stamp_state <= MAIN_STT_RD_WAIT;
								b_stamp <= PL_LOAD_STT_UTIM64;
							end
							else if(sci_condition)begin
								b_stamp_state <= MAIN_STT_RD_WAIT;
								b_stamp <= PL_LOAD_STT_SCI;
							end
							else if(mimsr_condition)begin
								b_stamp_state <= MAIN_STT_RD_WAIT;
								b_stamp <= PL_LOAD_STT_MIMSR;
							end
							else if(lsflags_condition)begin
								b_stamp_state <= MAIN_STT_RD_WAIT;
								b_stamp <= PL_LOAD_STT_LSFLAGS;
							end
						end
					end
				MAIN_STT_RD_WAIT:
					begin
						if(utim64_r_valid || sci_r_valid || mimsr_r_valid || lsflags_r_valid)begin
							b_stamp_state <= MAIN_STT_IDLE;
							b_stamp <= 2'h0;
						end
					end
			endcase
		end
	end

	
	/*********************************
	DPS Device
	*********************************/
	//DPS-UTIM
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
	
	//DPS-SCI
	dps_sci DPS_SCI(
		.iIF_CLOCK(iCLOCK),
		.iDPS_BASE_CLOCK(iDPS_BASE_CLOCK),
		//Reset
		.inRESET(inRESET),
		//LSFLAGS
		.oLSFLAGS_TIRE_IRQ(sci_tire_irq),
		.oLSFLAGS_RIRE_IRQ(sci_rire_irq),
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
	
	//DPS-MIMSR
	dps_mimsr DPS_MIMSR(
		.iCLOCK(iCLOCK),
		//Reset
		.inRESET(inRESET),
		//CPU Interface
		.iREQ_VALID(mimsr_condition),
		.oREQ_VALID(mimsr_r_valid),
		.oREQ_DATA(mimsr_r_data)
	);
	
	dps_lsflags DPS_FLAGS(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iRESET_SYNC(1'b0),
		//
		.iSCI_VALID(sci_irq),
		.iSCI_SCITIE(sci_tire_irq),
		.iSCI_SCIRIE(sci_rire_irq),
		//
		.iREAD_VALID(lsflags_condition),
		//
		.oLSFLAGS_VALID(lsflags_r_valid),
		.oLSFLAGS(lsflags_r_data)
	);
	
	/*********************************
	IRQ Controlor
	*********************************/
	//IRQ Controlor
	dps_irq IRQ_MNGR(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//IRQ Tables	
		.iDPS_IRQ_CONFIG_TABLE_REQ(iDPS_IRQ_CONFIG_TABLE_REQ),
		.iDPS_IRQ_CONFIG_TABLE_ENTRY(iDPS_IRQ_CONFIG_TABLE_ENTRY),
		.iDPS_IRQ_CONFIG_TABLE_FLAG_MASK(iDPS_IRQ_CONFIG_TABLE_FLAG_MASK),
		.iDPS_IRQ_CONFIG_TABLE_FLAG_VALID(iDPS_IRQ_CONFIG_TABLE_FLAG_VALID),
		.iDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL(iDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL),
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
	
	assign oDPS_IRQ_NUM = 6'd36 + {5'h00, irq_bum_buffer};
	assign oDPS_BUSY = b_stamp_state || utim64_busy || sci_busy;
	assign oDPS_VALID = sci_r_valid || utim64_r_valid || mimsr_r_valid || lsflags_r_valid;
	assign oDPS_DATA = (b_stamp == PL_LOAD_STT_UTIM64)? utim64_r_data : (b_stamp == PL_LOAD_STT_SCI)? sci_r_data : (b_stamp == PL_LOAD_STT_MIMSR)? mimsr_r_data : lsflags_r_data;
	
endmodule


`default_nettype wire


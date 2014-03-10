
`default_nettype none	

module pic(
		//System
		input wire iCLOCK,
		input wire inRESET,
		/****************************************
		System Infomation
		****************************************/
		output wire oSYSINFO_IOSR_VALID,
		output wire [31:0] oSYSINFO_IOSR,			//IO Start Address
		/****************************************
		IO - CPU Connection
		****************************************/
		//Req
		input wire iIO_REQ,
		output wire oIO_BUSY,
		input wire [1:0] iIO_ORDER,				//if (!iIO_RW && iIO_ORDER!=2'h2) then Alignment Fault
		input wire iIO_RW,					//0=Write 1=Read
		input wire [31:0] iIO_ADDR,
		input wire [31:0] iIO_DATA,
		//Output
		output wire oIO_VALID,
		input wire iIO_BUSY,
		output wire [31:0] oIO_DATA,
		//Interrupt
		output wire oIO_INTERRUPT_VALID,
		output wire [5:0] oIO_INTERRUPT_NUM,
		input wire iIO_INTERRUPT_ACK,
		/****************************************
		To DPS Connection
		****************************************/
		//Request
		output wire oDPS_REQ,				//Input
		input wire iDPS_BUSY,
		output wire oDPS_RW,				//0=Read : 1=Write
		output wire [31:0] oDPS_ADDR,
		output wire [31:0] oDPS_DATA,
		//Return
		input wire iDPS_REQ,				//Output
		output wire oDPS_BUSY,
		input wire [31:0] iDPS_DATA,
		//Interrupt
		input wire iDPS_IRQ_REQ,
		input wire [5:0] iDPS_IRQ_NUM,	
		output wire oDPS_IRQ_ACK,
		/****************************************
		To GCI Connection
		****************************************/						
		//Request
		output wire oGCI_REQ,				//Input
		input wire iGCI_BUSY,
		output wire oGCI_RW,				//0=Read : 1=Write
		output wire [31:0] oGCI_ADDR,
		output wire [31:0] oGCI_DATA,
		//Return
		input wire iGCI_REQ,				//Output
		output wire oGCI_BUSY,
		input wire [31:0] iGCI_DATA,
		//Interrupt
		input wire iGCI_IRQ_REQ,
		input wire [5:0] iGCI_IRQ_NUM,
		output wire oGCI_IRQ_ACK
							
	);
	
	
	/******************************************************************************************
	Assign
	******************************************************************************************/
	//GCI SIze
	//wire [32:0] gci_use_size;
	//IRQ Controll
	reg b_irq_state;
	reg b_irq_gci_ack_mask;
	reg b_irq_dps_ack_mask;
	//CPU2IO State
	reg b_cpu_error;		//<- Interrupt Triger
	reg b_cpu_req;
	reg b_cpu_rw;
	reg [31:0] b_cpu_addr;
	reg [31:0] b_cpu_data;
	//GCI Use Size Controllor
	reg [1:0] b_iosize_state;
	reg b_iosize_gci_size_valid;
	reg [31:0] b_iosize_gci_size;
	
	/******************************************************************************************
	IOSR
	******************************************************************************************/
	//assign gci_use_size = 33'h100000000 - b_iosize_gci_size;
	assign oSYSINFO_IOSR_VALID = b_iosize_gci_size_valid;
	//assign oSYSINFO_IOSR = (b_iosize_gci_size_valid)? gci_use_size[31:0] + 32'h00000200 : 32'h00000000;
	assign oSYSINFO_IOSR = ~(b_iosize_gci_size[31:0] + 32'h00000200) + 32'h1;//(b_iosize_gci_size_valid)? 33'h100000000 - (b_iosize_gci_size[31:0] + 32'h00000200) : 32'h00000000;
	
	
	/******************************************************************************************
	IRQ Controll
	******************************************************************************************/
	localparam L_PARAM_IRQ_STT_IDLE = 1'b0;
	localparam L_PARAM_IRQ_STT_ACK_WAIT = 1'b1;
	
	//Interrupt Controllor
	assign oGCI_IRQ_ACK = b_irq_gci_ack_mask && iIO_INTERRUPT_ACK;
	assign oDPS_IRQ_ACK = b_irq_dps_ack_mask && iIO_INTERRUPT_ACK;

	assign oIO_INTERRUPT_VALID = (b_irq_state == L_PARAM_IRQ_STT_IDLE)? (iGCI_IRQ_REQ || iDPS_IRQ_REQ) : 1'b0;
	assign oIO_INTERRUPT_NUM = (iGCI_IRQ_REQ)? iGCI_IRQ_NUM + 6'h4 : iDPS_IRQ_NUM;
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_state <= L_PARAM_IRQ_STT_IDLE;
			b_irq_gci_ack_mask <= 1'b0;		
			b_irq_dps_ack_mask <= 1'b0;
		end
		else begin
			case(b_irq_state)
				L_PARAM_IRQ_STT_IDLE:
					begin
						b_irq_gci_ack_mask <= 1'b0;		
						b_irq_dps_ack_mask <= 1'b0;
						if(iGCI_IRQ_REQ)begin
							b_irq_state <= L_PARAM_IRQ_STT_ACK_WAIT;
							b_irq_gci_ack_mask <= iGCI_IRQ_REQ;	
						end
						else if(iDPS_IRQ_REQ)begin
							b_irq_state <= L_PARAM_IRQ_STT_ACK_WAIT;
							b_irq_dps_ack_mask <= iDPS_IRQ_REQ;
						end
					end
				L_PARAM_IRQ_STT_ACK_WAIT:
					begin
						if(iIO_INTERRUPT_ACK)begin
							b_irq_state <= L_PARAM_IRQ_STT_IDLE;
						end
					end
			endcase
		end
	end
	
	
	
	/******************************************************************************************
	CPU
	******************************************************************************************/
	//CPU -> IO Buffer & Error Check
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_cpu_error <= 1'b0;
			b_cpu_req <= 1'b0;
			b_cpu_rw <= 1'b0;
			b_cpu_addr <= {32{1'b0}};
			b_cpu_data <= {32{1'b0}};
		end
		else begin
			if(!iGCI_BUSY || !iDPS_BUSY)begin
				//Error Check
				if(iIO_REQ && iIO_ORDER != 2'h2 && !iIO_RW)begin				
					b_cpu_error <= 1'b1;
					b_cpu_req <= 1'b0;
					b_cpu_rw <= 1'b0;
					b_cpu_addr <= {32{1'b0}};
					b_cpu_data <= {32{1'b0}};
				end
				else begin
					b_cpu_error <= 1'b0;
					b_cpu_req <= iIO_REQ;
					b_cpu_rw <= iIO_RW;
					b_cpu_addr <= iIO_ADDR;
					b_cpu_data <= iIO_DATA;
				end
			end
		end
	end
	

	
	/******************************************************************************************
	GCI
	******************************************************************************************/
	//GCI Use Size Controllor
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_iosize_state <= 2'h0;
			b_iosize_gci_size_valid <= 1'b0;
			b_iosize_gci_size <= {32{1'b0}};
		end
		else begin
			case(b_iosize_state)//synthesis parallel_case full_case
				2'h0:	//IDLE
					begin
						if(!iGCI_BUSY)begin
							b_iosize_state <= 2'h1;
						end
					end
				2'h1:	//REQUEST
					begin
						if(!iGCI_BUSY)begin
							b_iosize_state <= 2'h2;
						end
					end
				2'h2:	//WAIT
					begin
						if(iGCI_REQ)begin
							b_iosize_state <= 2'h3;
							b_iosize_gci_size_valid <= 1'b1;
							b_iosize_gci_size <= iGCI_DATA;
						end
					end
				2'h3:	//INITIAL_END
					begin
						b_iosize_gci_size_valid <= b_iosize_gci_size_valid;
						b_iosize_gci_size <= b_iosize_gci_size;
					end
			endcase
		end
	end
	
	
	/******************************************************************************************
	Assign
	******************************************************************************************/
	//Connect (This -> CPU)
	assign oIO_BUSY = iGCI_BUSY || iDPS_BUSY || !b_iosize_gci_size_valid/*Initial END*/;
	assign oIO_VALID = (b_iosize_state == 2'h3)? iGCI_REQ || iDPS_REQ : 1'b0;
	assign oIO_DATA = (iGCI_REQ)? iGCI_DATA : iDPS_DATA;
	
	wire device_select = (b_cpu_addr >= 32'h00000200)? 1'b1 : 1'b0;
	
	//DPS
	assign oDPS_REQ = b_cpu_req && !device_select;
	assign oDPS_RW = (b_iosize_state == 2'h1)? 1'b0 : b_cpu_rw;
	assign oDPS_ADDR = (b_iosize_state == 2'h1)? 32'h4 : b_cpu_addr;
	assign oDPS_DATA = (b_iosize_state == 2'h1)? 32'h0 : b_cpu_data;
	assign oDPS_BUSY = (b_iosize_state == 2'h1)? 1'b0 : iIO_BUSY;
	//Connection (This -> GCI)
	assign oGCI_REQ = b_iosize_state == 2'h1 || b_cpu_req && device_select;
	assign oGCI_RW = (b_iosize_state == 2'h1)? 1'b0 : b_cpu_rw;
	assign oGCI_ADDR = (b_iosize_state == 2'h1)? 32'h4 : b_cpu_addr - 32'h00000200;
	assign oGCI_DATA = (b_iosize_state == 2'h1)? 32'h0 : b_cpu_data;
	assign oGCI_BUSY = (b_iosize_state == 2'h1)? 1'b0 : iIO_BUSY;
	
	//Connection (This -> CPU)
	

endmodule

							
	
`default_nettype wire						

		
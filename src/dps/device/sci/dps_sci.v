`default_nettype none


module dps_sci(
		input wire iIF_CLOCK,
		input wire iDPS_BASE_CLOCK,
		//Reset
		input wire inRESET,
		//LSFLAGS
		output wire oLSFLAGS_TIRE_IRQ,
		output wire oLSFLAGS_RIRE_IRQ,
		//CPU Interface
		input wire iREQ_VALID,
		output wire oREQ_BUSY,		//Ignore
		input wire iREQ_RW,
		input wire [1:0] iREQ_ADDR,
		input wire [31:0] iREQ_DATA,
		output wire oREQ_VALID,
		output wire [31:0] oREQ_DATA,
		//IRQ
		output wire oIRQ_VALID,
		input wire iIRQ_ACK,
		//UART
		output wire oUART_TXD,
		input wire iUART_RXD
	);

	localparam SCITX = 2'h0;
	localparam SCIRX = 2'h1;
	localparam SCICFG = 2'h2;
	
	//SCI Config Register
	reg b_scicfg_ten;
	reg b_scicfg_ren;
	reg [3:0] b_scicfg_bdr;
	reg [2:0] b_scicfg_tire;
	reg [2:0] b_scicfg_rire;
	reg b_scicfg_tcrl;
	reg b_scicfg_rcrl;
	//SCI Module
	wire uart_mod_full;
	wire [3:0] uart_mod_txd_fifo_counter;
	wire uart_mod_txd_transmit;
	wire uart_mod_empty;
	wire [7:0] uart_mod_data;
	wire [3:0] uart_mod_rxd_fifo_counter;
	wire uart_mod_rxd_receive;
	//Transmit Buffer
	reg b_irq_transmit_buff_irq;
	reg b_irq_transmit_buff_resresh_wait;
	reg [3:0] b_irq_transmit_buff_resresh_count;
	//Receive Buffer
	reg b_irq_receive_buff_irq;
	reg b_irq_receive_buff_resresh_wait;
	reg [3:0] b_irq_receive_buff_resresh_count;
	//IRQ State
	reg b_irq_state;
	reg b_irq_transmit_ack;
	reg b_irq_receive_ack;
	
	
	/**********************************
	SCI Config Register
	**********************************/
	wire scicfg_write_condition = iREQ_ADDR == SCICFG && iREQ_VALID && iREQ_RW;
	always@(posedge iIF_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_scicfg_ten <= 1'b0;
			b_scicfg_ren <= 1'b0;
			b_scicfg_bdr <= 4'b0;
			b_scicfg_tire <= 3'b0;
			b_scicfg_rire <= 3'b0;
			b_scicfg_tcrl <= 1'b0;
			b_scicfg_rcrl <= 1'b0;
		end
		else begin
			if(scicfg_write_condition)begin
				b_scicfg_ten <= iREQ_DATA[0];					
				b_scicfg_ren <= iREQ_DATA[1];
				b_scicfg_bdr <= iREQ_DATA[5:2];
				b_scicfg_tire <= iREQ_DATA[8:6];
				b_scicfg_rire <= iREQ_DATA[11:9];
				b_scicfg_tcrl <= iREQ_DATA[12];
				b_scicfg_rcrl <= iREQ_DATA[13];
			end
			else begin
				b_scicfg_tcrl <= 1'b0;
				b_scicfg_rcrl <= 1'b0;
			end
		end
	end
	
	
	
	/**********************************
	SCI Module
	**********************************/
	dps_uart UARTMOD(
		//Clock
		.iCLOCK(iIF_CLOCK),
		.inRESET(inRESET),
		//Request
		.iBAUDRATE(b_scicfg_bdr),
		.iTX_EN(b_scicfg_ten),
		.iTX_CLEAR(b_scicfg_tcrl),
		.iTX_REQ(iREQ_VALID && !uart_mod_full && (iREQ_ADDR == SCITX) && iREQ_RW),
		.oTX_BUSY(uart_mod_full),
		.iTX_DATA(iREQ_DATA[7:0]),
		.oTX_BUFF_CNT(uart_mod_txd_fifo_counter),
		.oTX_TRANSMIT(uart_mod_txd_transmit),
		.iRX_EN(b_scicfg_ren),
		.iRX_CLEAR(b_scicfg_rcrl),
		.iRX_REQ(iREQ_VALID && !uart_mod_empty && (iREQ_ADDR == SCIRX) && !iREQ_RW),
		.oRX_EMPTY(uart_mod_empty),
		.oRX_DATA(uart_mod_data),
		.oRX_BUFF_CNT(uart_mod_rxd_fifo_counter),
		.oRX_RECEIVE(uart_mod_rxd_receive),
		//UART
		.oUART_TXD(oUART_TXD),
		.iUART_RXD(iUART_RXD)
	);

	/**********************************
	IRQ - SCICFG_TIRE & SCICFG_RIRE Register
	**********************************/
	//Transmit Buffer
	always@(posedge iIF_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_transmit_buff_irq <= 1'b0;
			b_irq_transmit_buff_resresh_wait <= 1'b0;
			b_irq_transmit_buff_resresh_count <= 4'h0;
		end
		//Reset
		else if(scicfg_write_condition)begin
			b_irq_transmit_buff_irq <= 1'b0;
			b_irq_transmit_buff_resresh_wait <= 1'b0;
			b_irq_transmit_buff_resresh_count <= 4'h0;
		end
		//FIFO Resresh Wait
		else if(b_irq_transmit_buff_resresh_wait)begin
			b_irq_transmit_buff_irq <= 1'b0;
			if(b_irq_transmit_buff_resresh_count > uart_mod_txd_fifo_counter)begin
				b_irq_transmit_buff_resresh_wait <= 1'b0;
			end
		end
		//Normal State
		else begin
			//IRQ Watch
			if(!b_irq_transmit_buff_irq)begin
				if(uart_mod_txd_transmit)begin
					case(b_scicfg_tire)
						3'h0 : b_irq_transmit_buff_irq <= 1'b0;
						3'h1 : 
							begin
								if(uart_mod_txd_fifo_counter <= 4'h1)begin
									b_irq_transmit_buff_irq <= 1'b1;
									b_irq_transmit_buff_resresh_count <= 4'h1;
								end
							end
						3'h2 : 
							begin
								if(uart_mod_txd_fifo_counter <= 4'h2)begin
									b_irq_transmit_buff_irq <= 1'b1;
									b_irq_transmit_buff_resresh_count <= 4'h2;
								end
							end
						3'h3 : 
							begin
								if(uart_mod_txd_fifo_counter <= 4'h4)begin
									b_irq_transmit_buff_irq <= 1'b1;
									b_irq_transmit_buff_resresh_count <= 4'h4;
								end
							end
						3'h4 : 
							begin
								if(uart_mod_txd_fifo_counter <= 4'h8)begin
									b_irq_transmit_buff_irq <= 1'b1;
									b_irq_transmit_buff_resresh_count <= 4'h8;
								end
							end
						default : b_irq_transmit_buff_irq <= 1'b0;
					endcase
				end
			end
			//Busy State
			else begin
				if(b_irq_transmit_ack)begin
					b_irq_transmit_buff_irq <= 1'b0;
					b_irq_transmit_buff_resresh_wait <= 1'b1;
				end
			end
		end
	end
	
	//Receive Buffer
	always@(posedge iIF_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_receive_buff_irq <= 1'b0;
			b_irq_receive_buff_resresh_wait <= 1'b0;
			b_irq_receive_buff_resresh_count <= 4'h0;
		end
		//Reset
		else if(scicfg_write_condition)begin
			b_irq_receive_buff_irq <= 1'b0;
			b_irq_receive_buff_resresh_wait <= 1'b0;
			b_irq_receive_buff_resresh_count <= 4'h0;
		end
		//FIFO Resresh Wait
		else if(b_irq_receive_buff_resresh_wait)begin
			b_irq_receive_buff_irq <= 1'b0;///////////////////////
			if(b_irq_receive_buff_resresh_count < uart_mod_rxd_fifo_counter)begin
				b_irq_receive_buff_resresh_wait <= 1'b0;
			end
		end
		//Normal State
		else begin
			//IRQ Watch
			if(!b_irq_receive_buff_irq)begin
				if(uart_mod_rxd_receive)begin
					case(b_scicfg_tire)
						3'h0 : b_irq_receive_buff_irq <= 1'b0;
						3'h1 : 
							begin
								if(uart_mod_rxd_fifo_counter >= 4'h1)begin
									b_irq_receive_buff_irq <= 1'b1;
									b_irq_receive_buff_resresh_count <= 4'h1;
								end
							end
						3'h2 : 
							begin
								if(uart_mod_rxd_fifo_counter >= 4'h2)begin
									b_irq_receive_buff_irq <= 1'b1;
									b_irq_receive_buff_resresh_count <= 4'h1;
								end
							end
						3'h3 : 
							begin
								if(uart_mod_rxd_fifo_counter >= 4'h4)begin
									b_irq_receive_buff_irq <= 1'b1;
									b_irq_receive_buff_resresh_count <= 4'h1;
								end
							end
						3'h4 : 
							begin
								if(uart_mod_rxd_fifo_counter >= 4'h8)begin
									b_irq_receive_buff_irq <= 1'b1;
									b_irq_receive_buff_resresh_count <= 4'h1;
								end
							end
						3'h5 : 
							begin
								if(uart_mod_rxd_fifo_counter == 4'hF)begin
									b_irq_receive_buff_irq <= 1'b1;
									b_irq_receive_buff_resresh_count <= 4'h1;
								end
							end
						default : b_irq_receive_buff_irq <= 1'b0;
					endcase
				end
			end
			//Busy State
			else begin
				if(b_irq_receive_ack)begin
					b_irq_receive_buff_irq <= 1'b0;
					b_irq_receive_buff_resresh_wait <= 1'b1;
				end
			end
		end
	end
	
	localparam IRQ_STT_IDLE = 1'b0;
	localparam IRQ_STT_IRQ = 1'b1;
	
	always@(posedge iIF_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_state <= IRQ_STT_IDLE;
			b_irq_transmit_ack <= 1'b0;
			b_irq_receive_ack <= 1'b0;
		end
		else begin
			case(b_irq_state)
				IRQ_STT_IDLE:
					begin
						//Transmit IRQ Check
						if(b_irq_receive_buff_irq) begin
							b_irq_receive_ack <= 1'b1;
							b_irq_state <= IRQ_STT_IRQ;
						end
						//Receive IRQ Check
						else if(b_irq_transmit_buff_irq)begin
							b_irq_transmit_ack <= 1'b1;
							b_irq_state <= IRQ_STT_IRQ;
						end
						else begin
							b_irq_transmit_ack <= 1'b0;
							b_irq_receive_ack <= 1'b0;
						end
					end
				IRQ_STT_IRQ:
					begin
						b_irq_transmit_ack <= 1'b0;
						b_irq_receive_ack <= 1'b0;
						if(iIRQ_ACK)begin
							b_irq_state <= IRQ_STT_IDLE;
						end
					end
			endcase
		end
	end
	
	
	reg b_ack_buffer_ack;
	reg [31:0] b_ack_buffer_data;
	
	//Request Ack
	always@(posedge iIF_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ack_buffer_ack <= 1'b0;
		end
		else begin
			b_ack_buffer_ack <= (iREQ_VALID && /*!uart_mod_empty &&*/ (iREQ_ADDR == SCIRX) && !iREQ_RW) || iREQ_VALID && (iREQ_ADDR == SCICFG) && !iREQ_RW;
		end
	end
	
	always@(posedge iIF_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ack_buffer_data <= 32'h0;
		end
		else begin
			b_ack_buffer_data <= (iREQ_ADDR == SCICFG)? {18'h0, b_scicfg_rcrl, b_scicfg_tcrl, b_scicfg_rire, b_scicfg_tire, b_scicfg_bdr, b_scicfg_ren, b_scicfg_ten} : ((uart_mod_empty)? 32'h0 : 32'h80000000 | uart_mod_data);
		end
	end
	
	assign oLSFLAGS_TIRE_IRQ = b_irq_transmit_buff_irq;
	assign oLSFLAGS_RIRE_IRQ = b_irq_receive_buff_irq;
	
	assign oREQ_BUSY = uart_mod_full;//1'b0;//!(iREQ_VALID && !uart_mod_full && (iREQ_ADDR == `SCITX) && iREQ_RW);
	assign oREQ_VALID = b_ack_buffer_ack;//(iREQ_VALID && !uart_mod_empty && (iREQ_ADDR == SCIRX) && !iREQ_RW) || iREQ_VALID && (iREQ_ADDR == SCICFG) && !iREQ_RW;
	assign oREQ_DATA = b_ack_buffer_data;//(iREQ_ADDR == SCICFG)? {18'h0, b_scicfg_rcrl, b_scicfg_tcrl, b_scicfg_rire, b_scicfg_tire, b_scicfg_bdr, b_scicfg_ren, b_scicfg_ten} : ((uart_mod_empty)? 32'h0 : 32'h80000000 | uart_mod_data);
	assign oIRQ_VALID = (b_irq_state == IRQ_STT_IRQ);
	
endmodule
			
`default_nettype wire


`default_nettype none


module uart(
						//Clock
						input			iIF_CLOCK,
						input			iUART_CLOCK,
						input			inRESET,
						//Request
						input			iTX_EN,
						input			iTX_REQ,
						output			oTX_BUSY,
						input	[7:0]	iTX_DATA,	
						input			iRX_EN,
						input			iRX_REQ,
						output			oRX_EMPTY,
						output	[7:0]	oRX_DATA,
						//IRQ
						output			oIRQ_VALID,
						//UART
						output			oUART_TXD,
						input			iUART_RXD
	);				
	
	
	/**************************************************************
	Tx and Rx Common Define
	**************************************************************/
	`define		IDLE		1'b0
	`define		WORKING		1'b1
	
	
	/**************************************************************
	Async FIFO Input Queue
	**************************************************************/
	wire	[7:0]	tx_fifo_data;
	wire			tx_fifo_empty;
	
	async_fifo #(8, 4, 2) TX_AS_FIFO(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iIF_CLOCK),
		.iWR_EN(iTX_REQ),
		.iWR_DATA(iTX_DATA),
		.oWR_FULL(oTX_BUSY),
		//RD
		.iRD_CLOCK(iUART_CLOCK),
		.iRD_EN(!tx_fifo_empty && b_tx_state == `IDLE && iTX_EN),
		.oRD_DATA(tx_fifo_data),
		.oRD_EMPTY(tx_fifo_empty)
	);
	
	wire			rd_fifo_en;
	wire	[7:0]	rd_fifo_data;
	wire			rd_fifo_full;
	
	async_fifo #(8, 4, 2) RX_AS_FIFO(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iUART_CLOCK),
		.iWR_EN(rd_fifo_en && !rd_fifo_full),
		.iWR_DATA(rd_fifo_data),
		.oWR_FULL(rd_fifo_full),
		//RD
		.iRD_CLOCK(iIF_CLOCK),
		.iRD_EN(iRX_REQ),
		.oRD_DATA(oRX_DATA),
		.oRD_EMPTY(oRX_EMPTY)
	);

	
	/**************************************************************
	Tx Module
	**************************************************************/
	reg					b_tx_state;
	reg		[7:0]		b_tx_buffer;
	reg		[3:0]		b_tx_counter;
	

	assign				oUART_TXD		=		(b_tx_state == `IDLE)? 1'b1 : func_txd(b_tx_counter, b_tx_buffer);
	
	function func_txd;
		input	[3:0]		func_counter;
		input	[7:0]		func_data;
		begin
			case(func_counter)
				4'h0:	func_txd	=	1'b0;
				4'h1:	func_txd	=	func_data[7];
				4'h2:	func_txd	=	func_data[6];
				4'h3:	func_txd	=	func_data[5];
				4'h4:	func_txd	=	func_data[4];
				4'h5:	func_txd	=	func_data[3];
				4'h6:	func_txd	=	func_data[2];
				4'h7:	func_txd	=	func_data[1];
				4'h8:	func_txd	=	func_data[0];
			endcase
		end
	endfunction
				
	
	always@(posedge iUART_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_tx_state		<=		`IDLE;
			b_tx_buffer		<=		8'h0;
			b_tx_counter	<=		4'h0;
		end
		else begin
			case(b_tx_state)
				`IDLE:
					begin
						if(!tx_fifo_empty && iTX_EN)begin
							b_tx_state		<=		`WORKING;
							b_tx_buffer		<=		{tx_fifo_data[0], tx_fifo_data[1], tx_fifo_data[2], tx_fifo_data[3], 
													tx_fifo_data[4], tx_fifo_data[5], tx_fifo_data[6], tx_fifo_data[7]};
						end
						b_tx_counter	<=		4'h0;
					end
				`WORKING:
					begin
						if(b_tx_counter == 4'h8)begin
							b_tx_state		<=		`IDLE;
						end
						else begin
							b_tx_counter	<=		b_tx_counter + 4'h1;
						end
					end
			endcase
		end
	end
	
	
	/**************************************************************
	Rx Module
	**************************************************************/	
	assign		rd_fifo_en			=		b_rx_end;
	assign		rd_fifo_data		=		{b_rx_buffer[0], b_rx_buffer[1], b_rx_buffer[2], b_rx_buffer[3], 
											b_rx_buffer[4], b_rx_buffer[5], b_rx_buffer[6], b_rx_buffer[7]};
	
	
	reg					b_rx_state;
	reg		[7:0]		b_rx_buffer;
	reg		[3:0]		b_rx_counter;
	reg					b_rx_end;
	
	always@(posedge iUART_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_rx_state		<=		`IDLE;
			b_rx_buffer		<=		8'h0;
			b_rx_counter	<=		4'h0;
			b_rx_end		<=		1'b0;
		end
		else begin
			case(b_rx_state)
				`IDLE:
					begin
						if(iUART_RXD == 1'b0 && iRX_EN)begin
							b_rx_state		<=		`WORKING;
						end
						b_rx_end		<=		1'b0;
						b_rx_counter	<=		4'h0;
					end
				`WORKING:
					begin
						if(b_rx_counter == 4'h8)begin
							b_rx_state		<=		`IDLE;
							b_rx_end		<=		1'b1;
						end
						else begin	
							if(b_rx_counter < 4'h8)begin
								b_rx_buffer		<=		{b_rx_buffer, iUART_RXD};
							end
							b_rx_counter	<=		b_rx_counter + 4'h1;
						end
					end
			endcase
		end
	end
	
	
	
	//IRQ_State
	reg		[1:0]	b_irq_state;
	always@(posedge iIF_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_state		<=		2'h0;
		end
		else begin
			case(b_irq_state)
				2'h0:
					begin
						if(b_rx_end)begin
							b_irq_state		<=		2'h1;
						end
					end
				2'h1:
					begin
						if(!b_rx_end)begin
							b_irq_state		<=		2'h2;
						end
					end
				2'h2:
					begin
						b_irq_state		<=		2'h0;
					end
			endcase
		end
	end
	
	assign		oIRQ_VALID		=		(b_irq_state == 2'h2)? 1'b1 : 1'b0;		//TMP
	
endmodule

`default_nettype wire

	

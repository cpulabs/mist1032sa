/**************************************************************************
UART Transmitter Module



-Clock Rate
	x4

-parameter BAUDRATE_COUNTER
	Uart Baudrate Parameter	(Clock / Baudrate)/4-1
	BAUDRATE_COUNTER is must be greater than 4. (BAUDRATE_COUNTER >= 20'h4)
	Example : Clock : 50MHz
		9600bps		: 13'd1301
		115.2Kbps	: 13'd108

-SDF Settings
	Asynchronus Clock : b_bd_clock

		
-Make	: 2013/2/21
-Update	: 2013/10/13

Takahiro Ito
**************************************************************************/

`default_nettype none


module mist1032sa_uart_transmitter #(
		parameter BAUDRATE_FIXED = 1'b1,		//0:Use iEXTBAUD_COUNT | 1:Use Parameter BAUDRATE_COUNTER
		parameter BAUDRATE_COUNTER = 20'd108	//(Clock / Baudrate) / 4 - 1
	)(
		//Clock
		input wire iCLOCK,
		input wire inRESET,
		//External Baudrate Timing
		input wire [19:0] iEXTBAUD_COUNT,
		//Request
		input wire iTX_REQ,
		output wire oTX_BUSY,
		input wire [7:0] iTX_DATA,
		//UART
		output wire oUART_TXD
	);	
	

	/**************************************************************
	Parameter & Wire & Register
	**************************************************************/
	localparam TXD_IDLE = 1'h0;
	localparam TXD_WORKING = 1'h1;
	
	localparam IF_IDLE = 2'h0;
	localparam IF_START = 2'h1;
	localparam IF_WORKING = 2'h2;
	
	//Interface Latch
	reg [1:0] b_if_state;
	reg [7:0] b_if_data;
	reg b_if_start;
	//Metastable Cancel
	wire dflipflop_if_start;
	//Async 2 Sync
	wire async2sync_if_start;
	//TxD Module
	reg b_txd_state;
	reg [5:0] b_txd_counter;
	reg b_txd_ack;
	reg b_txd_end;
	//Baudrate 
	reg [19:0] b_bd_wait_counter;
	reg b_bd_clock;
	
	/**************************************************************
	Interface
	**************************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_if_state <= IF_IDLE;
			b_if_data <= 8'h0;
			b_if_start <= 1'b0;
		end
		else begin
			case(b_if_state)
				IF_IDLE:
					begin
						if(iTX_REQ)begin
							b_if_state <= IF_START;
							b_if_data <= iTX_DATA;
							b_if_start <= 1'b1;
						end
					end
				IF_START:	
					begin
						if(b_txd_ack)begin
							b_if_state <= IF_WORKING;
							b_if_start <= 1'b0;
						end
					end
				IF_WORKING:
					begin
						if(b_txd_end)begin
							b_if_state <= IF_IDLE;
						end
					end
			endcase
		end
	end
	
	
	/**************************************************************
	TxD Module
	**************************************************************/
	function func_txd;
		input [3:0] func_counter;
		input [7:0] func_data;
		begin
			case(func_counter)
				4'h0: func_txd = 1'b0;
				4'h1: func_txd = func_data[0];
				4'h2: func_txd = func_data[1];
				4'h3: func_txd = func_data[2];
				4'h4: func_txd = func_data[3];
				4'h5: func_txd = func_data[4];
				4'h6: func_txd = func_data[5];
				4'h7: func_txd = func_data[6];
				4'h8: func_txd = func_data[7];
				default: func_txd = 1'b1;
			endcase
		end
	endfunction
	
	//Metastable Cancel
	mist1032sa_uart_transmitter_double_flipflop #(1) DOUBLE_FLIPFLOP(
		.iCLOCK(b_bd_clock),
		.inRESET(inRESET),
		//Input
		.iREQ_DATA(b_if_start),
		//Output
		.oOUT_DATA(dflipflop_if_start)
	);
	
	//Async 2 Sync
	mist1032sa_uart_transmitter_async2sync #(1) ASYNC2SYNC(
		.iCLOCK(b_bd_clock),
		.inRESET(inRESET),
		//Ena-Signal
		.iSIGNAL(dflipflop_if_start),
		.oSIGNAL(async2sync_if_start)
	);
	
	//State	
	always@(posedge b_bd_clock or negedge inRESET)begin
		if(!inRESET)begin
			b_txd_state <= TXD_IDLE;
			b_txd_counter <= 6'h0;
			b_txd_ack <= 1'b0;
			b_txd_end <= 1'b0;
		end
		else begin
			case(b_txd_state)
				TXD_IDLE:
					begin
						if(async2sync_if_start)begin
							b_txd_state <= TXD_WORKING;
							b_txd_ack <= 1'b1;
						end
						b_txd_counter <= 6'h0;
						b_txd_end <= 1'b0;
					end
				TXD_WORKING:
					begin
						b_txd_ack <= 1'b0;
						if(b_txd_counter == 6'd36)begin
							b_txd_state <= TXD_IDLE;
							b_txd_end <= 1'b1;
						end
						else begin
							b_txd_counter <= b_txd_counter + 6'h1;
						end
					end
			endcase
		end
	end

	/**************************************************************
	Baudrate Clock
	**************************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_bd_wait_counter <= 20'h0;
			b_bd_clock <= 1'b0;
		end
		else begin
			if((BAUDRATE_FIXED && b_bd_wait_counter == BAUDRATE_COUNTER) || (!BAUDRATE_FIXED && b_bd_wait_counter == iEXTBAUD_COUNT))begin
				b_bd_wait_counter <= 20'h0;
				b_bd_clock <= 1'b1;
			end
			else begin
				b_bd_wait_counter <= b_bd_wait_counter + 20'h1;
				b_bd_clock <= 1'b0;
			end
		end
	end
	
	/**************************************************************
	Assign
	**************************************************************/
	assign oUART_TXD = (b_txd_state == TXD_WORKING)? func_txd(b_txd_counter[5:2], b_if_data) : 1'b1;
	assign oTX_BUSY = (b_if_state == IF_IDLE)? 1'b0 : 1'b1;
	
endmodule


`default_nettype wire

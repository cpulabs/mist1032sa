/**************************************************************************
UART Receiver Module



-Sampling speed
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
-Update	: 

Takahiro Ito
**************************************************************************/



`default_nettype none

module mist1032sa_uart_receiver #(
		parameter BAUDRATE_FIXED = 1'b1,		//0:Use iEXTBAUD_COUNT | 1:Use Parameter BAUDRATE_COUNTER
		parameter BAUDRATE_COUNTER = 20'd108	//(Clock / Baudrate) / 4 - 1
	)(
		//Clock
		input wire iCLOCK,
		input wire inRESET,
		//External Baudrate Timing
		input wire [19:0] iEXTBAUD_COUNT,
		//R Data	
		output wire oRX_VALID,
		output wire [7:0] oRX_DATA,
		//UART
		input wire iUART_RXD
	);	

	
	/**************************************************************
	Parameter & Wire & Register
	**************************************************************/
	localparam IF_IDLE = 2'h0;
	localparam IF_RECEIVED = 2'h1;
	localparam IF_IDLEWAIT = 2'h2;
	
	localparam RXD_IDLE = 2'h0;
	localparam RXD_RECEIVING = 2'h1;
	localparam RXD_RECEIVED = 2'h2;
	
	//UART Metastable Cancel
	wire uart_rxd;
	//RXD Module
	reg bn_rxd_init;
	reg [1:0] b_rxd_state;
	reg [7:0] b_rxd_buffer;
	reg [5:0] b_rxd_counter;
	reg b_rxd_data_req;
	reg b_rxd_idle_req;
	//Metastable Cancel
	wire dflipflop_idle_req;
	wire dflipflop_data_req;
	//Async 2 Sync
	wire sync_idle_req;
	wire sync_data_req;
	//Interface
	reg [1:0] b_if_state;
	reg [7:0] b_if_data;
	reg b_if_end;
	//Baudrate 
	reg [19:0] b_bd_wait_counter;
	reg b_bd_clock;
	
	/**************************************************************
	RxD
	**************************************************************/	
	//Metastable Cancel
	mist1032sa_uart_receiver_double_flipflop #(1) RXD_DOUBLE_FLIPFLOP(
		.iCLOCK(b_bd_clock),
		.inRESET(inRESET),
		//Input
		.iREQ_DATA(iUART_RXD),
		//Output
		.oOUT_DATA(uart_rxd)
	);
	
	//Uart State
	always@(posedge b_bd_clock or negedge inRESET)begin
		if(!inRESET)begin
			bn_rxd_init <= 1'b0;
			b_rxd_state <= RXD_IDLE;
			b_rxd_buffer <= 8'h0;
			b_rxd_counter <= 6'h0;
			b_rxd_data_req <= 1'b0;
			b_rxd_idle_req <= 1'b0;
		end
		else if(!bn_rxd_init)begin
			bn_rxd_init = 1'b1;
			b_rxd_buffer <= 8'hFF;
		end
		else begin
			case(b_rxd_state)
				RXD_IDLE:
					begin
						//Stat bit Check
						if(b_rxd_buffer[5:4] == 2'h0)begin
							b_rxd_state <= RXD_RECEIVING;
						end
						b_rxd_buffer <= {uart_rxd, b_rxd_buffer[7:1]};
						b_rxd_counter <= 6'h0;
						b_rxd_data_req <= 1'b0;
						b_rxd_idle_req <= 1'b0;	
					end
				RXD_RECEIVING:
					begin
						b_rxd_idle_req <= 1'b0;
						if(b_rxd_counter == 6'd32)begin
							b_rxd_state <= RXD_RECEIVED;
							b_rxd_data_req <= 1'b1;
						end
						else begin
							if(b_rxd_counter[1:0] == 2'h1)begin	//Uart center pickup
								b_rxd_buffer <= {uart_rxd, b_rxd_buffer[7:1]};
							end
							b_rxd_counter <= b_rxd_counter + 6'h1;
						end
					end
				RXD_RECEIVED:
					begin
						b_rxd_state <= RXD_IDLE;
						b_rxd_buffer <= 8'hFF;
						b_rxd_data_req <= 1'b0;
						b_rxd_idle_req <= 1'b1;	
					end
			endcase
		end
	end
	
	//Metastable Cancel
	mist1032sa_uart_receiver_double_flipflop #(2) DOUBLE_FLIPFLOP(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Input
		.iREQ_DATA({b_rxd_idle_req, b_rxd_data_req}),
		//Output
		.oOUT_DATA({dflipflop_idle_req, dflipflop_data_req})
	);
	
	//Async 2 Sync
	mist1032sa_uart_receiver_async2sync #(2) ASYNC2SYNC(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Ena-Signal
		.iSIGNAL({dflipflop_idle_req, dflipflop_data_req}),
		.oSIGNAL({sync_idle_req, sync_data_req})
	);
	
	//Interface State
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_if_state <= IF_IDLE;
			b_if_data <= 8'h0;
			b_if_end <= 1'b0;
		end
		else begin
			case(b_if_state)
				IF_IDLE:
					begin
						if(sync_data_req)begin
							b_if_state <= IF_RECEIVED;
							b_if_data <= b_rxd_buffer;//dflipflop_data;
							b_if_end <= 1'b1;
						end
					end
				IF_RECEIVED:
					begin
						b_if_state <= IF_IDLEWAIT;
						b_if_end <= 1'b0;
					end
				IF_IDLEWAIT:
					begin
						if(sync_idle_req)begin
							b_if_state <= IF_IDLE;
						end
					end
				default:
					begin
						b_if_state <= IF_IDLE;
						b_if_data <= 8'h0;
						b_if_end <= 1'b0;
					end
			endcase
		end
	end
	
	/**************************************************************
	Baudrate Counter
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
	
	assign oRX_VALID = b_if_end;
	assign oRX_DATA = b_if_data;
	
endmodule


`default_nettype wire

`default_nettype none
`include "common.h"

/* Baudrate Select
	0x0		:	9600 (Reset After)
	0x1		:	110
	0x2		:	300
	0x3		:	600
	0x4		:	1200
	0x5		:	2400
	0x6		:	4800
	0x7		:	14400
	0x8		:	19200
	0x9		:	38400
	0xA		:	57600
	0xB		:	115200
	0xC		:	230400
	0xD		:	460800
	0xE		:	921600
	0xF		:	Reserved
*/



module dps_uart(
		//Clock
		input wire iCLOCK,
		input wire inRESET,
		//Baudrate
		input wire [3:0] iBAUDRATE,
		//Transmit
		input wire iTX_EN,
		input wire iTX_CLEAR,
		input wire iTX_REQ,
		output wire oTX_BUSY,
		input wire [7:0] iTX_DATA,
		output wire [3:0] oTX_BUFF_CNT,
		output wire oTX_TRANSMIT,
		//Receive
		input wire iRX_EN,
		input wire iRX_CLEAR,
		input wire iRX_REQ,
		output wire oRX_EMPTY,
		output wire [7:0] oRX_DATA,
		output wire [3:0] oRX_BUFF_CNT,
		output wire oRX_RECEIVE,
		//IRQ
		output wire oIRQ_VALID,
		//UART
		output wire oUART_TXD,
		input wire iUART_RXD
	);
	
	
	/*********************************************
	* Baudrate Enable
	*********************************************/
	reg [18:0] baudrate_compare;
	always @* begin
		case(iBAUDRATE)
			4'h0: baudrate_compare <= 19'd1302;		//9600
			4'h1: baudrate_compare <= 19'd113636;	//110
			4'h2: baudrate_compare <= 19'd166666;	//300
			4'h3: baudrate_compare <= 19'd41666;	//600
			4'h4: baudrate_compare <= 19'd41666;	//1200
			4'h5: baudrate_compare <= 19'd10416;	//2400
			4'h6: baudrate_compare <= 19'd2604;		//4800
			4'h7: baudrate_compare <= 19'd868;		//14400
			4'h8: baudrate_compare <= 19'd2604;		//19200
			4'h9: baudrate_compare <= 19'd651;		//38400
			4'hA: baudrate_compare <= 19'd217;		//57600
			4'hB: baudrate_compare <= 19'd108;		//115200
			4'hC: baudrate_compare <= 19'd54;		//230400
			4'hD: baudrate_compare <= 19'd27;		//460800
			4'hE: baudrate_compare <= 19'd11;		//921600
			default: baudrate_compare <= 19'd1302;	//9600
		endcase
	end
	
	/*********************************************
	* Uart FIFO
	*********************************************/
	
	wire transmitter_tx_enable;
	wire transmitter_tx_busy;
	wire [7:0] transmitter_tx_data;
	
	wire receiver_rx_enable;
	wire receiver_rx_busy;
	wire [7:0] receiver_rx_data;

	//Txd Buffer
	`ifdef MIST1032ISA_ALTERA_PRIMITIVE
		//FIFO Mode				: Show Ahead Synchronous FIFO Mode
		//Width					: 8bit
		//Depth					: 16Word
		//Asynchronous Reset	: Use
		//Synchronous Reset		: Use
		//Usedw					: Use
		//Full					: Use
		//Empty					: Use
		//Almost Full			: Use(Value=2)
		//Almost Empty			: Use(Value=14)
		//Overflow Checking		: Disable
		//Undesflow Checking	: Disable
		altera_primitive_sync_fifo_8in_8out_16depth TX_FIFO(
			.aclr(!inRESET),				//Asynchronous Reset
			.clock(iCLOCK),				//Clock
			.data(iTX_DATA),				//Data-In
			.rdreq(!transmitter_tx_enable && !transmitter_tx_busy),				//Read Data Request
			.sclr(iTX_CLEAR),				//Synchthronous Reset
			.wrreq(iTX_EN && iTX_REQ),				//Write Req
			.almost_empty(),		
			.almost_full(),
			.empty(transmitter_tx_enable),
			.full(oTX_BUSY),
			.q(transmitter_tx_data),					//Dataout
			.usedw(oTX_BUFF_CNT)
		);
	`elsif MIST1032ISA_XILINX_PRIMITIVE

	`else
		mist1032isa_sync_fifo #(8, 16, 4) TX_FIFO(
			//System
			.iCLOCK(iCLOCK),
			.inRESET(inRESET),
			.iREMOVE(iTX_CLEAR),
			.oCOUNT(oTX_BUFF_CNT),
			//WR
			.iWR_EN(iTX_EN && iTX_REQ),
			.iWR_DATA(iTX_DATA),
			.oWR_FULL(oTX_BUSY),
			//RD
			.iRD_EN(!transmitter_tx_enable && !transmitter_tx_busy),
			.oRD_DATA(transmitter_tx_data),
			.oRD_EMPTY(transmitter_tx_enable)
		);
	`endif
	
	//Rxd Buffer
	`ifdef MIST1032ISA_ALTERA_PRIMITIVE
		//FIFO Mode				: Show Ahead Synchronous FIFO Mode
		//Width					: 8bit
		//Depth					: 16Word
		//Asynchronous Reset	: Use
		//Synchronous Reset		: Use
		//Usedw					: Use
		//Full					: Use
		//Empty					: Use
		//Almost Full			: Use(Value=2)
		//Almost Empty			: Use(Value=14)
		//Overflow Checking		: Disable
		//Undesflow Checking	: Disable
		altera_primitive_sync_fifo_8in_8out_16depth RX_FIFO(
			.aclr(!inRESET),				//Asynchronous Reset
			.clock(iCLOCK),				//Clock
			.data(receiver_rx_data),				//Data-In
			.rdreq(iRX_EN && iRX_REQ),				//Read Data Request
			.sclr(iRX_CLEAR),				//Synchthronous Reset
			.wrreq(receiver_rx_enable && !receiver_rx_busy),				//Write Req
			.almost_empty(),		
			.almost_full(),
			.empty(oRX_EMPTY),
			.full(receiver_rx_busy),
			.q(oRX_DATA),					//Dataout
			.usedw(oRX_BUFF_CNT)
		);
	`elsif MIST1032ISA_XILINX_PRIMITIVE

	`else
		mist1032isa_sync_fifo #(8, 16, 4) RX_FIFO(
			//System
			.iCLOCK(iCLOCK),
			.inRESET(inRESET),
			.iREMOVE(iRX_CLEAR),
			.oCOUNT(oRX_BUFF_CNT),
			//WR
			.iWR_EN(receiver_rx_enable && !receiver_rx_busy),
			.iWR_DATA(receiver_rx_data),
			.oWR_FULL(receiver_rx_busy),
			//RD
			.iRD_EN(iRX_EN && iRX_REQ),
			.oRD_DATA(oRX_DATA),
			.oRD_EMPTY(oRX_EMPTY)
		);
	`endif
	
	
	/*********************************************
	* Uart Transmitter
	*********************************************/
	mist1032isa_uart_transmitter #(1'b1, 20'd108) UART_TRANSMITTER(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//External Baudrate Timing
		.iEXTBAUD_COUNT({1'b0, baudrate_compare}),
		//Request
		.iTX_REQ(!transmitter_tx_enable && !transmitter_tx_busy),
		.oTX_BUSY(transmitter_tx_busy),
		.iTX_DATA(transmitter_tx_data),
		//UART
		.oUART_TXD(oUART_TXD)
	);
	
	/*********************************************
	* Uart Receiver
	*********************************************/
	mist1032isa_uart_receiver #(1'b1, 20'd108) UART_RECEIVER(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//External Baudrate Timing
		.iEXTBAUD_COUNT({1'b0, baudrate_compare}),
		//R Data	
		.oRX_VALID(receiver_rx_enable),
		.oRX_DATA(receiver_rx_data),
		//UART
		.iUART_RXD(iUART_RXD)
	);
	
	/*********************************************
	* Assign
	*********************************************/
	assign oTX_TRANSMIT = !transmitter_tx_enable && !transmitter_tx_busy;
	assign oRX_RECEIVE = receiver_rx_enable;

	
endmodule


`default_nettype wire

	

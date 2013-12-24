
`default_nettype none
`timescale 1ns/1ns

module tb_inst_level;
	localparam PL_CORE_CYCLE = 20;		//It's necessary "Core Clock == Bus Clock". This restriction is removed near future.
	localparam PL_BUS_CYCLE = 20;		//
	localparam PL_DPS_CYCLE = 18;
	localparam PL_RESET_TIME = 20;

	localparam PL_GCI_SIZE = 32'h0001_0000;

	/****************************************
	System
	****************************************/
	reg iCORE_CLOCK;
	reg iBUS_CLOCK;
	reg iDPS_CLOCK;
	reg inRESET;
	/****************************************
	SCI
	****************************************/
	wire oSCI_TXD;
	reg iSCI_RXD;
	/****************************************
	Memory BUS
	****************************************/
	//Req
	wire oMEMORY_REQ;
	wire  iMEMORY_LOCK;
	wire [1:0] oMEMORY_ORDER;				//00=Byte Order 01=2Byte Order 10= Word Order 11= None
	wire oMEMORY_RW;						//1:Write | 0:Read
	wire [31:0] oMEMORY_ADDR;
	//This -> Data RAM
	wire [31:0] oMEMORY_DATA;
	//Data RAM -> This
	wire iMEMORY_VALID;
	wire oMEMORY_BUSY;
	wire [63:0] iMEMORY_DATA;	
	/****************************************
	GCI BUS
	****************************************/
	//Request
	wire oGCI_REQ;					//Input
	reg iGCI_BUSY;
	wire oGCI_RW;						//0=Read : 1=Write
	wire [31:0] oGCI_ADDR;
	wire [31:0] oGCI_DATA;
	//Return
	reg iGCI_REQ;						//Output
	wire oGCI_BUSY;
	reg [31:0] iGCI_DATA;
	//Interrupt
	reg iGCI_IRQ_REQ;
	reg [5:0] iGCI_IRQ_NUM;
	wire oGCI_IRQ_ACK;
	//Interrupt Controll
	wire oIO_IRQ_CONFIG_TABLE_REQ;
	wire [5:0] oIO_IRQ_CONFIG_TABLE_ENTRY;
	wire oIO_IRQ_CONFIG_TABLE_FLAG_MASK;
	wire oIO_IRQ_CONFIG_TABLE_FLAG_VALID;
	wire [1:0] oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL;
	wire [31:0] oDEBUG_PC;
	wire [31:0] oDEBUG0;
	/****************************************
	Debug
	****************************************/
	reg iDEBUG_UART_RXD;
	wire oDEBUG_UART_TXD;
	reg iDEBUG_PARA_REQ;
	wire oDEBUG_PARA_BUSY;
	reg [7:0] iDEBUG_PARA_CMD;
	reg [31:0] iDEBUG_PARA_DATA;
	wire oDEBUG_PARA_VALID;
	reg iDEBUG_PARA_BUSY;
	wire oDEBUG_PARA_ERROR;
	wire [31:0] oDEBUG_PARA_DATA;



	/******************************************************
	Target
	******************************************************/
	mist1032isa TARGET(
		/****************************************
		System
		****************************************/
		.iCORE_CLOCK(iCORE_CLOCK),
		.iBUS_CLOCK(iBUS_CLOCK),
		.iDPS_CLOCK(iDPS_CLOCK),
		.inRESET(inRESET),
		/****************************************
		SCI
		****************************************/
		.oSCI_TXD(oSCI_TXD),
		.iSCI_RXD(iSCI_RXD),
		/****************************************
		Memory BUS
		****************************************/
		//Req
		.oMEMORY_REQ(oMEMORY_REQ),
		.iMEMORY_LOCK(iMEMORY_LOCK),
		.oMEMORY_ORDER(oMEMORY_ORDER),				//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oMEMORY_RW(oMEMORY_RW),						//1:Write | 0:Read
		.oMEMORY_ADDR(oMEMORY_ADDR),
		//This -> Data RAM
		.oMEMORY_DATA(oMEMORY_DATA),
		//Data RAM -> This
		.iMEMORY_VALID(iMEMORY_VALID),
		.oMEMORY_BUSY(oMEMORY_BUSY),
		.iMEMORY_DATA(iMEMORY_DATA),	
		/****************************************
		GCI BUS
		****************************************/
		//Request
		.oGCI_REQ(oGCI_REQ),					//Input
		.iGCI_BUSY(iGCI_BUSY),
		.oGCI_RW(oGCI_RW),						//0=Read : 1=Write
		.oGCI_ADDR(oGCI_ADDR),
		.oGCI_DATA(oGCI_DATA),
		//Return
		.iGCI_REQ(iGCI_REQ),						//Output
		.oGCI_BUSY(oGCI_BUSY),
		.iGCI_DATA(iGCI_DATA),
		//Interrupt
		.iGCI_IRQ_REQ(iGCI_IRQ_REQ),
		.iGCI_IRQ_NUM(iGCI_IRQ_NUM),
		.oGCI_IRQ_ACK(oGCI_IRQ_ACK),
		//Interrupt Controll
		.oIO_IRQ_CONFIG_TABLE_REQ(oIO_IRQ_CONFIG_TABLE_REQ),
		.oIO_IRQ_CONFIG_TABLE_ENTRY(oIO_IRQ_CONFIG_TABLE_ENTRY),
		.oIO_IRQ_CONFIG_TABLE_FLAG_MASK(oIO_IRQ_CONFIG_TABLE_FLAG_MASK),
		.oIO_IRQ_CONFIG_TABLE_FLAG_VALID(oIO_IRQ_CONFIG_TABLE_FLAG_VALID),
		.oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL(oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL),
		.oDEBUG_PC(oDEBUG_PC),
		.oDEBUG0(oDEBUG0),
		/****************************************
		Debug
		****************************************/
		.iDEBUG_UART_RXD(iDEBUG_UART_RXD),
		.oDEBUG_UART_TXD(oDEBUG_UART_TXD),
		.iDEBUG_PARA_REQ(iDEBUG_PARA_REQ),
		.oDEBUG_PARA_BUSY(oDEBUG_PARA_BUSY),
		.iDEBUG_PARA_CMD(iDEBUG_PARA_CMD),
		.iDEBUG_PARA_DATA(iDEBUG_PARA_DATA),
		.oDEBUG_PARA_VALID(oDEBUG_PARA_VALID),
		.iDEBUG_PARA_BUSY(iDEBUG_PARA_BUSY),
		.oDEBUG_PARA_ERROR(oDEBUG_PARA_ERROR),
		.oDEBUG_PARA_DATA(oDEBUG_PARA_DATA)
	);


	/******************************************************
	Clock
	******************************************************/
	always#(PL_CORE_CYCLE/2)begin
		iCORE_CLOCK = !iCORE_CLOCK;
	end

	always#(PL_BUS_CYCLE/2)begin
		iBUS_CLOCK = !iBUS_CLOCK;
	end

	always#(PL_DPS_CYCLE/2)begin
		iDPS_CLOCK = !iDPS_CLOCK;
	end
	

	/******************************************************
	State
	******************************************************/
	initial begin
		$display("Check Start");
		//Initial
		iCORE_CLOCK = 1'b0;
		iBUS_CLOCK = 1'b0;
		iDPS_CLOCK = 1'b0;
		inRESET = 1'b0;		
		iSCI_RXD = 1'b1;	
		iGCI_BUSY = 1'b0;
		iGCI_REQ = 1'b0;
		iGCI_DATA = 32'h0;
		iGCI_IRQ_REQ = 1'b0;
		iGCI_IRQ_NUM = 6'h0;
		iDEBUG_UART_RXD = 1'b1;
		iDEBUG_PARA_REQ = 1'b0;
		iDEBUG_PARA_CMD = 8'h0;
		iDEBUG_PARA_DATA = 32'h0;
		iDEBUG_PARA_BUSY = 1'b0;

		//Reset After
		#(PL_RESET_TIME);
		inRESET = 1'b1;

		//GCI Init
		#(PL_BUS_CYCLE*32);
		while(oGCI_BUSY) #(PL_BUS_CYCLE);
		iGCI_REQ = 1'b1;
		iGCI_DATA = PL_GCI_SIZE;
		#(PL_BUS_CYCLE);
		iGCI_REQ = 1'b0;
		iGCI_DATA = 32'h0;


		#15000000 begin
			$stop;
		end
	end


	/******************************************************
	Memory Model
	******************************************************/
	sim_memory_model #(1, "tb_inst_test.hex") MEMORY_MODEL(
		.iCLOCK(iCORE_CLOCK),
		.inRESET(inRESET),
		//Req
		.iMEMORY_REQ(oMEMORY_REQ),
		.oMEMORY_LOCK(iMEMORY_LOCK),
		.iMEMORY_ORDER(oMEMORY_ORDER),				//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.iMEMORY_RW(oMEMORY_RW),						//1:Write | 0:Read
		.iMEMORY_ADDR(oMEMORY_ADDR),
		//This -> Data RAM
		.iMEMORY_DATA(oMEMORY_DATA),
		//Data RAM -> This
		.oMEMORY_VALID(iMEMORY_VALID),
		.iMEMORY_LOCK(oMEMORY_BUSY),
		.oMEMORY_DATA(iMEMORY_DATA)
	);

	/******************************************************
	Assertion
	******************************************************/
	reg assert_check_flag;
	reg [31:0] assert_wrong_number;
	reg [31:0] assert_wrong_type;
	reg [31:0] assert_result;
	reg [31:0] assert_expect;

		always@(posedge iCORE_CLOCK)begin
		if(inRESET && oMEMORY_REQ && !iMEMORY_LOCK && oMEMORY_ORDER == 2'h2 && oMEMORY_RW)begin
			//Finish Check
			if(oMEMORY_ADDR == 32'h0002_0004)begin
				if(!assert_check_flag)begin
					$display("[SIM-ERR]Wrong Data.");
					$display("[SIM-ERR]Wrong Type : %d", assert_wrong_type);
					$display("[SIM-ERR]Index:%d, Expect:%x, Result:%x", assert_wrong_number, assert_expect, assert_result);
					$display("[SIM-ERR]Simulation Finished.");
					$stop;
				end
				else begin
					$display("[SIM-OK]Simulation Finished.");
					$stop;
				end
			end
			//Check Flag
			else if(oMEMORY_ADDR == 32'h0002_0000)begin
				assert_check_flag = oMEMORY_DATA[24];
			end
			//Error Number
			else if(oMEMORY_ADDR == 32'h0002_000c)begin
				assert_wrong_number = {oMEMORY_DATA[7:0], oMEMORY_DATA[15:8], oMEMORY_DATA[23:16], oMEMORY_DATA[31:24]};
			end
			//Error Type
			else if(oMEMORY_ADDR == 32'h0002_0008)begin
				assert_wrong_type = {oMEMORY_DATA[7:0], oMEMORY_DATA[15:8], oMEMORY_DATA[23:16], oMEMORY_DATA[31:24]};
			end
			//Error Result
			else if(oMEMORY_ADDR == 32'h0002_0010)begin
				assert_result = {oMEMORY_DATA[7:0], oMEMORY_DATA[15:8], oMEMORY_DATA[23:16], oMEMORY_DATA[31:24]};
			end
			//Error Expect
			else if(oMEMORY_ADDR == 32'h0002_0014)begin
				assert_expect = {oMEMORY_DATA[7:0], oMEMORY_DATA[15:8], oMEMORY_DATA[23:16], oMEMORY_DATA[31:24]};
			end
			
		end
	end
	

endmodule

`default_nettype wire


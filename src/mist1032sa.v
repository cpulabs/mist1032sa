/*************************************************************************************************************
MIST1032SA
Open Source 32bit Out-of-Order Processor

Files that are included in this project is deliverable by all Open Design Computer Project.
http://open-arch.org

All files included in this project have been allocated in the BSD licence.	
Open Design Computer Project @Takahiro Ito (Twitter : @cpu_labs)
*************************************************************************************************************/


`default_nettype none
`include "common.h"	


module mist1032sa(
		/****************************************
		System
		****************************************/
		input wire iCORE_CLOCK,
		input wire iBUS_CLOCK,
		input wire iDPS_CLOCK,
		input wire inRESET,
		input wire iRESET_SYNC,
		/****************************************
		SCI
		****************************************/
		output wire oSCI_TXD,
		input wire iSCI_RXD,
		/****************************************
		Memory BUS
		****************************************/
		//Req
		output wire oMEMORY_REQ,
		input wire iMEMORY_LOCK,
		output wire [1:0] oMEMORY_ORDER,				//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		output wire [3:0] oMEMORY_MASK,
		output wire oMEMORY_RW,						//1:Write | 0:Read
		output wire [31:0] oMEMORY_ADDR,
		//This -> Data RAM
		output wire [31:0] oMEMORY_DATA,
		//Data RAM -> This
		input wire iMEMORY_VALID,
		output wire oMEMORY_BUSY,
		input wire [63:0] iMEMORY_DATA,	
		/****************************************
		GCI BUS
		****************************************/
		//Request
		output wire oGCI_REQ,					//Input
		input wire iGCI_BUSY,
		output wire oGCI_RW,						//0=Read : 1=Write
		output wire [31:0] oGCI_ADDR,
		output wire [31:0] oGCI_DATA,
		//Return
		input wire iGCI_REQ,						//Output
		output wire oGCI_BUSY,
		input wire [31:0] iGCI_DATA,
		//Interrupt
		input wire iGCI_IRQ_REQ,
		input wire [5:0] iGCI_IRQ_NUM,
		output wire oGCI_IRQ_ACK,
		//Interrupt Controll
		output wire oIO_IRQ_CONFIG_TABLE_REQ,
		output wire [5:0] oIO_IRQ_CONFIG_TABLE_ENTRY,
		output wire oIO_IRQ_CONFIG_TABLE_FLAG_MASK,
		output wire oIO_IRQ_CONFIG_TABLE_FLAG_VALID,
		output wire [1:0] oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL,
		output wire [31:0] oDEBUG_PC,
		output wire [31:0] oDEBUG0,
		/****************************************
		Debug
		****************************************/
		input wire iDEBUG_UART_RXD,
		output wire oDEBUG_UART_TXD,
		input wire iDEBUG_PARA_REQ,
		output wire oDEBUG_PARA_BUSY,
		input wire [7:0] iDEBUG_PARA_CMD,
		input wire [31:0] iDEBUG_PARA_DATA,
		output wire oDEBUG_PARA_VALID,
		input wire iDEBUG_PARA_BUSY,
		output wire oDEBUG_PARA_ERROR,
		output wire [31:0] oDEBUG_PARA_DATA
	);
			

			
			
	/****************************************
	Register and Wire
	****************************************/

	/****************************************
	Core Interface
	****************************************/
	core_if #(32'h0) CORE_IF(
		/****************************************
		System
		****************************************/
		.iIF_CLOCK(iBUS_CLOCK),
		.iCORE_CLOCK(iCORE_CLOCK),
		.inRESET(inRESET),
		.iRESET_SYNC(iRESET_SYNC),
		/****************************************
		GCI Controll
		****************************************/	
		//Interrupt Control
		.oIO_IRQ_CONFIG_TABLE_REQ(),
		.oIO_IRQ_CONFIG_TABLE_ENTRY(),
		.oIO_IRQ_CONFIG_TABLE_FLAG_MASK(),
		.oIO_IRQ_CONFIG_TABLE_FLAG_VALID(),
		.oIO_IRQ_CONFIG_TABLE_FLAG_LEVEL(),
		/****************************************
		Instruction Memory
		****************************************/
		//Req
		.oINST_REQ(),
		.iINST_LOCK(),
		.oINST_TID(),
		.oINST_MMUMOD(),
		.oINST_PDT(),
		.oINST_ADDR(),
		//Data RAM -> This
		.iINST_VALID(),
		.oINST_BUSY(),		//new
		.iINST_DATA(),
		.iINST_MMU_FLAGS(),
		/****************************************
		Data Memory
		****************************************/
		//Req
		.oDATA_REQ(),
		.iDATA_LOCK(),
		.oDATA_ORDER(),	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oDATA_RW(),			//1=Write 0=Read
		.oDATA_TID(),
		.oDATA_MMUMOD(),
		.oDATA_PDT(),
		.oDATA_ADDR(),
		//This -> Data RAM
		.oDATA_DATA(),
		//Data RAM -> This
		.iDATA_VALID(),
		.iDATA_DATA(),
		/****************************************
		IO
		****************************************/
		//Req
		.oIO_REQ(),
		.iIO_BUSY(),
		.oIO_ORDER(),		//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		.oIO_RW(),			//0=Write 1=Read
		.oIO_ADDR(),
		//Write
		.oIO_DATA(),
		//Rec
		.iIO_VALID(),
		.iIO_DATA(),
		/****************************************
		Interrupt
		****************************************/
		.iINTERRUPT_VALID(),
		.oINTERRUPT_ACK(),
		.iINTERRUPT_NUM(),
		/****************************************
		System Infomation
		****************************************/
		.iSYSINFO_IOSR_VALID(),
		.iSYSINFO_IOSR()
	);
	

endmodule


`default_nettype wire


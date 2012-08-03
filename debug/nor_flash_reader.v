/*****************************************************************************************************
Files that are included in this project is deliverable by all Open Design Computer Project.
http://open-arch.org

All files included in this project have been allocated in the BSD licence.	
Open Design Computer Project @Takahiro Ito
	
Make	:	2012/08/04
*****************************************************************************************************/


`default_nettype none
`define		STT_INIT		3'b0
`define		STT_IDLE		3'h1
`define		STT_WAIT1		3'h2
`define		STT_WAIT2		3'h3
`define		STT_WAIT3		3'h4
`define		STT_WAIT4		3'h5
`define		STT_GET			3'h6


module nor_flash_reader
	#(
		parameter		AN			=	21,
		parameter		DN			=	16,
		parameter		QUEUE		=	8,
		parameter		QUEUE_N		=	3
	)(
		//iCLOCK
		input					iCLOCK,
		input					inRESET,
		//CPU-Request
		input					iCPU_RQ_REQ,
		output					oCPU_RQ_BUSY,
		input	[AN-1:0]		iCPU_RQ_ADDR,		
		//CPU-Output
		input					iCPU_RD_REQ,
		output					oCPU_RD_BUSY,
		output	[DN-1:0]		oCPU_RD_DATA,
		//Flash
		output	[AN-1:0]		oFLASH_ADDR,
		input	[DN-1:0]		iFLASH_DQ,
		output					onFLASH_CE,
		output					onFLASH_OE,
		output					onFLASH_WE,
		output					onFLASH_RESET,
		output					onFLASH_WP,
		output					onFLASH_BYTE,
		input					inFLASH_RY
	);
					
				
	

	/****************************************
	Wire & Register
	****************************************/
	//Request Queue
	wire	[AN-1:0]		req_queue_addr;
	wire					req_queue_empty;
	wire					rq_busy;
	//Output Queue
	wire					out_queue_full;
	wire					rd_busy;
	//State Register
	reg		[2:0]			b_state;
	reg		[AN-1:0]		b_addr;
	
	
	/****************************************
	Request Queue
	****************************************/
	sync_fifo #(AN, QUEUE, QUEUE_N) REQUEST_QUEUE(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET), 
		.iREMOVE(1'b0), 
		.oCOUNT(/* Not Use */), 	
		.iWR_EN(iCPU_RQ_REQ && !rq_busy), 
		.iWR_DATA(iCPU_RQ_ADDR), 
		.oWR_FULL(rq_busy),
		.iRD_EN(!req_queue_empty && b_state == `STT_IDLE), 
		.oRD_DATA(req_queue_addr), 
		.oRD_EMPTY(req_queue_empty)
	);
	
	
	/****************************************
	State
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state		<=		`STT_INIT;
			b_addr		<=		{AN{1'b0}};
		end
		else begin
			case(b_state)
				`STT_INIT:
					begin
						b_state		<=		`STT_IDLE;
					end
				`STT_IDLE:
					begin
						if(!req_queue_empty)begin
							b_state		<=		`STT_WAIT1;
						end
					end
				`STT_WAIT1:
					begin
						b_state		<=		`STT_WAIT2;
						b_addr		<=		req_queue_addr;
					end
				`STT_WAIT2:
					begin
						b_state		<=		`STT_WAIT3;
					end
				`STT_WAIT3:
					begin
						b_state		<=		`STT_WAIT4;
					end
				`STT_WAIT4:
					begin
						b_state		<=		`STT_GET;
					end
				`STT_GET:
					begin
						if(!out_queue_full)begin
							b_state		<=		`STT_IDLE;
						end
					end
			endcase
		end
	end			
	
	
	
	/****************************************
	Output Queue
	****************************************/
	sync_fifo #(DN, QUEUE, QUEUE_N) OUTPUT_QUEUE(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET), 
		.iREMOVE(1'b0), 
		.oCOUNT(/* Not Use */), 	
		.iWR_EN(!out_queue_full && b_state == `STT_GET), 
		.iWR_DATA(iFLASH_DQ), 
		.oWR_FULL(out_queue_full),
		.iRD_EN(iCPU_RD_REQ && !rd_busy), 
		.oRD_DATA(oCPU_RD_DATA), 
		.oRD_EMPTY(rd_busy)
	);
	
	
	/****************************************
	Assign
	****************************************/
	//Flash
	assign		oFLASH_ADDR		=		b_addr;
	assign		onFLASH_CE		=		(b_state == `STT_INIT)? 1'b1 : 1'b0;
	assign		onFLASH_OE		=		(b_state == `STT_INIT)? 1'b1 : 1'b0;
	assign		onFLASH_WE		=		1'b1;
	assign		onFLASH_RESET	=		1'b1;
	assign		onFLASH_WP		=		1'b0;
	assign		onFLASH_BYTE	=		1'b1;
	//CPU
	assign		oCPU_RQ_BUSY	=		rq_busy;
	assign		oCPU_RD_BUSY	=		rd_busy;
	
	
endmodule

`default_nettype wire




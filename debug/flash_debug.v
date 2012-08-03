/*****************************************************************************************************
Files that are included in this project is deliverable by all Open Design Computer Project.
http://open-arch.org

All files included in this project have been allocated in the BSD licence.	
Open Design Computer Project @Takahiro Ito
	
Make	:	2012/08/04
*****************************************************************************************************/


`default_nettype none

`define		STT_GET0		3'h0
`define		STT_GET1		3'h1
`define		STT_GET2		3'h2
`define		STT_GET3		3'h3
`define		STT_WRITE		3'h4
`define		STT_END			3'h5	

module flash_debug(
				//System
				input				iCLOCK,
				input				inRESET,
				//Debugg
				output				oDEBUG_VALID,
				output				oDEBUG_MEMIF_REQ_VALID,
				output				oDEBUG_MEMIF_REQ_DQM0,
				output				oDEBUG_MEMIF_REQ_DQM1,
				output				oDEBUG_MEMIF_REQ_DQM2,
				output				oDEBUG_MEMIF_REQ_DQM3,
				output				oDEBUG_MEMIF_REQ_RW,
				output	[24:0]		oDEBUG_MEMIF_REQ_ADDR,
				output	[31:0]		oDEBUG_MEMIF_REQ_DATA,
				input				iDEBUG_MEMIF_REQ_LOCK,
				//Flash
				output	[22:0]		oFLASH_ADDR,
				input	[7:0]		iFLASH_DQ,
				output				onFLASH_CE,
				output				onFLASH_OE,
				output				onFLASH_WE,
				output				onFLASH_RESET,
				output				onFLASH_WP,
				output				onFLASH_BYTE,
				input				inFLASH_RY
	);
	
	
	//Flash Read Request State
	reg			[23:0]			b_rd_counter;
	//Flash Get State
	reg							b_get_end;
	reg			[21:0]			b_get_counter;
	reg			[2:0]			b_get_state;
	reg			[7:0]			b_get_data0;
	reg			[7:0]			b_get_data1;
	reg			[7:0]			b_get_data2;
	reg			[7:0]			b_get_data3;
	//Flash Controllor Instance
	wire						rd_req_busy;
	wire						get_empty;
	wire	[7:0]				get_data;
	wire						get_rd_condition;
	
	
	/****************************
	Flash Instance
	****************************/
	nor_flash_reader #(23, 8, 8, 3) FLASH_CONTROLLOR(
		//iCLOCK
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//CPU-Request
		.iCPU_RQ_REQ(!b_get_end),
		.oCPU_RQ_BUSY(rd_req_busy),
		.iCPU_RQ_ADDR(b_rd_counter[22:0]),		
		//CPU-Output
		.iCPU_RD_REQ(get_rd_condition),
		.oCPU_RD_BUSY(get_empty),
		.oCPU_RD_DATA(get_data),
		//Flash
		.oFLASH_ADDR(oFLASH_ADDR),
		.iFLASH_DQ(iFLASH_DQ),
		.onFLASH_CE(onFLASH_CE),
		.onFLASH_OE(onFLASH_OE),
		.onFLASH_WE(onFLASH_WE),
		.onFLASH_RESET(onFLASH_RESET),
		.onFLASH_WP(onFLASH_WP),
		.onFLASH_BYTE(onFLASH_BYTE),
		.inFLASH_RY(inFLASH_RY)
	);
	assign			get_rd_condition		=		(b_get_state == `STT_GET0 || b_get_state == `STT_GET1 || b_get_state == `STT_GET2 || b_get_state == `STT_GET3)? !get_empty && !b_get_end : 1'b0;
	
	
	//Flash Read 
	reg			b_rd_ini_state;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_rd_ini_state		<=		1'b0;
			b_rd_counter		<=		24'h0;
		end
		else begin
			if(!b_get_end)begin
				if(!rd_req_busy)begin
					if(!b_rd_ini_state)begin
						b_rd_ini_state		<=		1'b1;
					end
					else begin	
						b_rd_counter		<=		b_rd_counter + 24'h1;
					end
					
				end
			end
		end
	end
			
	//Flash Get State
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_get_end			<=		1'b0;
			b_get_counter		<=		22'h0;
			b_get_state			<=		3'h0;
			b_get_data0			<=		8'h0;
			b_get_data1			<=		8'h0;
			b_get_data2			<=		8'h0;
			b_get_data3			<=		8'h0;
		end
		else begin
			case(b_get_state)
				`STT_GET0:
					begin
						if(b_get_counter == 22'h200000)begin
							b_get_state			<=		`STT_END;	
							b_get_end			<=		1'b1;
						end
						else begin
							if(!get_empty)begin
								b_get_state			<=		`STT_GET1;
								b_get_data0			<=		get_data;
							end
						end
					end
				`STT_GET1:
					begin
						if(!get_empty)begin
							b_get_state			<=		`STT_GET2;
							b_get_data1			<=		get_data;
						end
					end
				`STT_GET2:
					begin
						if(!get_empty)begin
							b_get_state			<=		`STT_GET3;
							b_get_data2			<=		get_data;
						end
					end
				`STT_GET3:
					begin
						if(!get_empty)begin
							b_get_state			<=		`STT_WRITE;
							b_get_data3			<=		get_data;
						end
					end
				`STT_WRITE:
					begin
						if(!iDEBUG_MEMIF_REQ_LOCK)begin
							b_get_state			<=		`STT_GET0;		
							b_get_counter		<=		b_get_counter + 22'h1;
						end
					end
				`STT_END:
					begin
						b_get_end			<=		1'b1;
					end
			endcase	
		end
	end
	
	
	assign		oDEBUG_VALID				=		!b_get_end;//!(b_get_end && b_rd_end);
	assign		oDEBUG_MEMIF_REQ_VALID		=		(b_get_state == `STT_WRITE)? !iDEBUG_MEMIF_REQ_LOCK : 1'b0;
	assign		oDEBUG_MEMIF_REQ_DQM0		=		1'b0;
	assign		oDEBUG_MEMIF_REQ_DQM1		=		1'b0;
	assign		oDEBUG_MEMIF_REQ_DQM2		=		1'b0;
	assign		oDEBUG_MEMIF_REQ_DQM3		=		1'b0;
	assign		oDEBUG_MEMIF_REQ_RW			=		1'b1;	//0:Read 1:Write
	assign		oDEBUG_MEMIF_REQ_ADDR		=		{3'h0, b_get_counter};
	assign		oDEBUG_MEMIF_REQ_DATA		=		{b_get_data0, b_get_data1, b_get_data2, b_get_data3};
	



endmodule


`default_nettype wire


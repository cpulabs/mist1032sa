/****************************************
Execute Port3 Load/Store Unit
****************************************/
`include "core.h"
`default_nettype none



module ex_port3(
				//System
				input wire iCLOCK,
				input wire inRESET,
				//Free
				input wire iFREE_EX,
				input wire iFREE_SYSREG_NEW_SPR_VALID,
				input wire [31:0] iFREE_SYSREG_NEW_SPR,	
				//Sysreg
				input wire [31:0] iSYSREG_TIDR,
				input wire [31:0] iSYSREG_PSR,
				input wire [31:0] iSYSREG_PDTR,
				output wire [31:0] oSYSREG_SPR,
				//Data Port
				output wire oDATAIO_REQ,
				input wire iDATAIO_BUSY,
				output wire [1:0] oDATAIO_ORDER,	//00=Byte Order 01=2Byte Order 10= Word Order 11= None
				output wire oDATAIO_RW,		//0=Read 1=Write
				output wire [13:0] oDATAIO_TID,
				output wire [1:0] oDATAIO_MMUMOD,
				output wire [31:0] oDATAIO_PDT,
				output wire [31:0] oDATAIO_ADDR,
				output wire [31:0] oDATAIO_DATA,
				input wire iDATAIO_REQ,
				input wire [31:0] iDATAIO_DATA,
				//output wire oOUT_PORT_DATA_VALID, 2011/10/05		
				//Scheduler2-Input
				input wire iPREVIOUS_EX_ALU3_VALID,
				input wire iPREVIOUS_EX_ALU3_DESTINATION_SYSREG,	//NEW
				input wire [5:0] iPREVIOUS_EX_ALU3_COMMIT_TAG,
				input wire [4:0] iPREVIOUS_EX_ALU3_CMD,
				input wire [31:0] iPREVIOUS_EX_ALU3_SOURCE0,			
				input wire [31:0] iPREVIOUS_EX_ALU3_SOURCE1,			
				input wire [5:0] iPREVIOUS_EX_ALU3_DESTINATION_REGNAME,		
				input wire [31:0] iPREVIOUS_EX_ALU3_PC,	
				input wire iPREVIOUS_EX_ALU3_SYS_LDST,		
				input wire iPREVIOUS_EX_ALU3_LDST,			
				output wire oPREVIOUS_EX_ALU3_LOCK,
				//Scheduler1-Output
				output wire oSCHE1_ALU3_VALID,
				output wire [5:0] oSCHE1_ALU3_COMMIT_TAG,
				//Scheduler2-Output
				output wire oSCHE2_ALU3_VALID,
				output wire [5:0] oSCHE2_ALU3_COMMIT_TAG,
				output wire [5:0] oSCHE2_ALU3_DESTINATION_REGNAME,
				output wire oSCHE2_ALU3_DESTINATION_SYSREG,		//NEW
				output wire oSCHE2_ALU3_WRITEBACK,
				output wire [31:0] oSCHE2_ALU3_DATA
	);
				

	reg		[1:0]	b_mode;
	reg				b_this_reset;
	reg		[1:0]	b_read_shift;
	reg		[1:0]	b_read_mask;
	reg				b_writeback;
	reg		[5:0]	b_commit_tag;
	reg		[31:0]	b_addr;
	reg		[31:0]	b_data;
	reg		[5:0]	b_r_addr;
	reg		[1:0]	b_order;
	reg				b_dataio_req;
	reg		[31:0]	b_pc;
	//reg				b_dataio_req_end;
	
	/****************************************
	Lock
	****************************************/
	wire		this_lock;
	assign		this_lock			=		(b_mode == 2'h0)? iDATAIO_BUSY : 1'b1;
	
	
	
	/****************************************
	SPR Register
	****************************************/	
	wire			push_condition;
	wire			pop_condition;
	wire			sysreg_write_condition;

	wire			spr_write_condition;
	wire	[31:0]	spr_data_info;
		
	assign			push_condition			=		iPREVIOUS_EX_ALU3_LDST && (iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_PUSH || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_PPUSH);
	assign			pop_condition			=		iPREVIOUS_EX_ALU3_LDST && iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_POP;		
	assign			sysreg_write_condition	=		iPREVIOUS_EX_ALU3_SYS_LDST && iPREVIOUS_EX_ALU3_DESTINATION_SYSREG && iPREVIOUS_EX_ALU3_CMD == `EXE_SYS_LDST_WRITE_SPR;

	assign			spr_write_condition		=		iFREE_SYSREG_NEW_SPR_VALID || (!this_lock && iPREVIOUS_EX_ALU3_VALID && (sysreg_write_condition || push_condition || pop_condition));
	
	
	sysreg_spr_register	SPR_REGISTER(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Register
		.iREGIST_REQ(spr_write_condition),
		.iREGIST_DATA((iFREE_SYSREG_NEW_SPR_VALID)? iFREE_SYSREG_NEW_SPR : (pop_condition)? spr_data_info + 32'h4 : ((push_condition)? spr_data_info - 32'h4 : iPREVIOUS_EX_ALU3_SOURCE0)),
		//Info
		.oINFO_DATA(spr_data_info)
	);
	
	
	
	/*****************************************************
	b_read_shift and b_read_mask comment
	*****************************************************/
	/*
	Memory--->---Shifter---Mask--->---Register
	
	Shifter(b_read_shift)
		0	:	None Shift
		1	:	>>1
		2	:	>>2
		3	:	>>3
		
	Mask(b_read_mask)
		0	:	Data & 0x000000FF
		1	:	Data & 0x0000FFFF
		2	:	Data & 0x00FFFFFF
		3	:	Data & 0xFFFFFFFF
	*/
	/****************************************************/
	
	function [31:0] func_load_mask;	
		input wire [1:0]		func_mask;
		input wire [31:0]		func_data;
		begin
			//Altera Worning Option
			case(func_mask)//synthesis parallel_case full_case
				2'h0:	func_load_mask	=	func_data & 32'h000000FF;
				2'h1:	func_load_mask	=	func_data & 32'h0000FFFF;
				2'h2:	func_load_mask	=	func_data & 32'h00FFFFFF;
				2'h3:	func_load_mask	=	func_data & 32'hFFFFFFFF;
			endcase
		end
	endfunction
	
	
	/****************************************
	Load / Store
	****************************************/
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_mode				<=			2'h0;
			b_this_reset		<=			1'b0;
			b_read_shift		<=			2'h0;
			b_read_mask			<=			2'h0;
			b_writeback			<=			1'b0;
			b_commit_tag		<=			6'h00;
			b_addr				<=			{32{1'b0}};
			b_order				<=			2'h0;
			b_data				<=			{32{1'b0}};
			b_r_addr			<=			6'h00;
			b_dataio_req		<=			1'b0;
			b_pc				<=			32'h0;
			//b_dataio_req_end	<=			1'b0;
		end
		else if(b_this_reset | iFREE_EX)begin
			b_mode				<=			2'h0;
			b_this_reset		<=			1'b0;
			b_read_shift		<=			2'h0;
			b_read_mask			<=			2'h0;
			b_writeback			<=			1'b0;
			b_commit_tag		<=			6'h00;
			b_addr				<=			{32{1'b0}};
			b_order				<=			2'h0;
			b_data				<=			{32{1'b0}};
			b_r_addr			<=			6'h00;
			b_dataio_req		<=			1'b0;
			b_pc				<=			32'h0;
			//b_dataio_req_end	<=			1'b0;
		end
		else begin
			case(b_mode)
				2'h0 :		//Wait State
					begin
						if(iPREVIOUS_EX_ALU3_VALID && !iDATAIO_BUSY)begin
							b_commit_tag		<=			iPREVIOUS_EX_ALU3_COMMIT_TAG;
							if(iPREVIOUS_EX_ALU3_LDST)begin
								if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LD8 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LD16 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LD32)begin
									b_mode				<=			2'h1;
									b_this_reset		<=			1'b0;
									b_writeback			<=			1'b1;
									if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LD8)begin
										b_order				<=			2'h0;
										b_addr				<=			iPREVIOUS_EX_ALU3_SOURCE1;
										b_read_shift		<=			iPREVIOUS_EX_ALU3_SOURCE1[1:0];
										b_read_mask			<=			2'h0;
									end
									else if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LD16)begin
										b_order				<=			2'h1;
										b_addr				<=			iPREVIOUS_EX_ALU3_SOURCE1;
										b_read_shift		<=			iPREVIOUS_EX_ALU3_SOURCE1[1:0];
										b_read_mask			<=			2'h1;
									end
									else begin
										b_order				<=			2'h2;
										b_addr				<=			iPREVIOUS_EX_ALU3_SOURCE1;
										b_read_shift		<=			2'h0;
										b_read_mask			<=			2'h3;
									end
									b_data				<=			{32{1'b0}};
									b_r_addr			<=			iPREVIOUS_EX_ALU3_DESTINATION_REGNAME;
									b_dataio_req		<=			1'b1;							
									b_pc				<=			iPREVIOUS_EX_ALU3_PC;
									//b_dataio_req_end	<=			1'b0;
								end
								else if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_ST8 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_ST16 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_ST32)begin
									b_mode				<=			2'h2;
									b_this_reset		<=			1'b0;
									b_writeback			<=			1'b0;
									if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_ST8)begin
										b_order				<=			2'h0;
										b_addr				<=			iPREVIOUS_EX_ALU3_SOURCE1;
									end
									else if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_ST16)begin
										b_order				<=			2'h1;
										b_addr				<=			iPREVIOUS_EX_ALU3_SOURCE1;
									end
									else begin
										b_order				<=			2'h2;
										b_addr				<=			iPREVIOUS_EX_ALU3_SOURCE1;
									end
									b_data				<=			iPREVIOUS_EX_ALU3_SOURCE0;
									b_r_addr			<=			{6{1'b0}};
									b_dataio_req		<=			1'b1;			
									b_pc				<=			iPREVIOUS_EX_ALU3_PC;
									//b_dataio_req_end	<=			1'b0;
								end	
								else if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_PUSH)begin
									b_mode				<=			2'h2;
									b_this_reset		<=			1'b0;
									b_writeback			<=			1'b0;
									b_addr				<=			spr_data_info - 32'h4;
									b_order				<=			2'h2;
									b_data				<=			iPREVIOUS_EX_ALU3_SOURCE0;
									b_r_addr			<=			{6{1'b0}};
									b_dataio_req		<=			1'b1;			
									b_pc				<=			iPREVIOUS_EX_ALU3_PC;
									//b_dataio_req_end	<=			1'b0;
								end
								else if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_PPUSH)begin
									b_mode				<=			2'h2;
									b_this_reset		<=			1'b0;
									b_writeback			<=			1'b0;
									b_addr				<=			spr_data_info - 32'h4;
									b_order				<=			2'h2;
									b_data				<=			iPREVIOUS_EX_ALU3_PC;
									b_r_addr			<=			{6{1'b0}};
									b_dataio_req		<=			1'b1;			
									b_pc				<=			iPREVIOUS_EX_ALU3_PC;
									//b_dataio_req_end	<=			1'b0;
								end
								else if(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_POP)begin
									b_mode				<=			2'h1;
									b_this_reset		<=			1'b0;
									b_read_shift		<=			2'h0;
									b_read_mask			<=			2'h3;
									b_writeback			<=			1'b1;
									b_addr				<=			spr_data_info;// + 32'h4;
									b_order				<=			2'h2;
									b_data				<=			{32{1'b0}};
									b_r_addr			<=			iPREVIOUS_EX_ALU3_DESTINATION_REGNAME;
									b_dataio_req		<=			1'b1;			
									b_pc				<=			iPREVIOUS_EX_ALU3_PC;
									//b_dataio_req_end	<=			1'b0;
								end
							end
							//SPR
							else if(iPREVIOUS_EX_ALU3_SYS_LDST)begin	
								if(iPREVIOUS_EX_ALU3_CMD == `EXE_SYS_LDST_READ_SPR)begin
									b_this_reset		<=			1'b1;
									b_read_shift		<=			2'h0;
									b_read_mask			<=			2'h3;
									b_data				<=			spr_data_info;
									b_r_addr			<=			iPREVIOUS_EX_ALU3_DESTINATION_REGNAME;
									b_writeback			<=			1'b1;			
									b_pc				<=			iPREVIOUS_EX_ALU3_PC;
								end	
								else if(iPREVIOUS_EX_ALU3_CMD == `EXE_SYS_LDST_WRITE_SPR)begin
									b_this_reset		<=			1'b1;
									b_writeback			<=			1'b0;			
									b_pc				<=			iPREVIOUS_EX_ALU3_PC;
								end
							end
							else begin
								//Error
								b_this_reset		<=			1'b1;
								b_writeback			<=			1'b0;
							end
						end
					end
				2'h1 : 		//Load / Push / Ppush
					begin
						if(b_dataio_req)begin
							if(iDATAIO_BUSY)begin
								b_dataio_req		<=			1'b1;
							end
							else begin
								b_dataio_req		<=			1'b0;
							end
						end
						//b_dataio_req		<=			1'b0;
						//Get Wait
						if(iDATAIO_REQ)begin
							b_data				<=			iDATAIO_DATA;
							b_this_reset		<=			1'b1;	//Exeend out
						end	
					end
				default :	//Store / Pop
					begin							
						if(b_dataio_req)begin
							if(iDATAIO_BUSY)begin
								b_dataio_req		<=			1'b1;
								b_this_reset		<=			1'b0;	//Exeend
							end
							else begin
								b_dataio_req		<=			1'b0;
								b_this_reset		<=			1'b1;	//Exeend
							end
						end
						/*
						b_dataio_req		<=			1'b0;
						b_this_reset		<=			1'b1;	//Exeend
						*/
					end
			endcase
		end
	end
	
	/****************************************
	Data & IO Port
	****************************************/
	assign	oPREVIOUS_EX_ALU3_LOCK				=		this_lock;
		
	assign	oSCHE2_ALU3_DESTINATION_SYSREG		=		1'b0;
	
	assign	oDATAIO_TID							=		iSYSREG_TIDR[13:0];
	assign	oDATAIO_MMUMOD						=		iSYSREG_PSR[1:0];
	assign	oDATAIO_PDT							=		iSYSREG_PDTR;
	
	assign	oSYSREG_SPR							=		spr_data_info;
	
	assign	oDATAIO_REQ							=	b_dataio_req;	//20120525//(!iDATAIO_BUSY && (b_mode == 2'h1 | b_mode == 2'h2))? 1'b1 : 1'b0;
	assign	oDATAIO_ORDER						=	b_order;
	assign	oDATAIO_RW							=	(b_mode == 2'h2)? 1'b1 : 1'b0;
	assign	oDATAIO_ADDR						=	b_addr;
	assign	oDATAIO_DATA						=	b_data;
	
	/****************************************
	Scheduler1 and 2 Output
	Select
	****************************************/
	assign	oSCHE1_ALU3_VALID						=		b_this_reset;
	assign	oSCHE1_ALU3_COMMIT_TAG					=		b_commit_tag;
	assign	oSCHE2_ALU3_VALID						=		b_this_reset;
	assign	oSCHE2_ALU3_DESTINATION_REGNAME			=		b_r_addr;
	assign	oSCHE2_ALU3_COMMIT_TAG					=		b_commit_tag;
	assign	oSCHE2_ALU3_WRITEBACK					=		b_writeback;
	assign	oSCHE2_ALU3_DATA						=		func_load_mask(b_read_mask, b_data >> (b_read_shift*8));

endmodule


`default_nettype wire




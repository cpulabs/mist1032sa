/****************************************
MIST1032SA
OoO Processor

for Open Design Computer Project

Takahiro Ito @cpu_labs
****************************************/

`include "core.h"
`default_nettype none

module execute_port3(
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


	/****************************************
	Lock
	****************************************/
	wire this_lock = b_ldst_state == !PL_LDST_STT_IDLE ||  iDATAIO_BUSY;

	/****************************************
	SPR Register
	****************************************/	
	wire push_condition;
	wire pop_condition;
	wire sysreg_write_condition;

	wire spr_write_condition;
	wire [31:0] spr_data_info;

	assign sysreg_write_condition = iPREVIOUS_EX_ALU3_SYS_LDST && iPREVIOUS_EX_ALU3_DESTINATION_SYSREG && iPREVIOUS_EX_ALU3_CMD == `EXE_SYS_LDST_WRITE_SPR;
	assign spr_write_condition = iFREE_SYSREG_NEW_SPR_VALID || (!this_lock && iPREVIOUS_EX_ALU3_VALID && (sysreg_write_condition || push_condition || pop_condition));
	
	
	sysreg_spr_register	SPR_REGISTER(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Register
		.iREGIST_REQ(spr_write_condition),
		.iREGIST_DATA((iFREE_SYSREG_NEW_SPR_VALID)? iFREE_SYSREG_NEW_SPR : (ldst_spr_out_valid)? ldst_spr_out_data : iPREVIOUS_EX_ALU3_SOURCE0),
		//Info
		.oINFO_DATA(spr_data_info)
	);
	

	//SPR
	wire ldst_spr_out_valid;
	wire [31:0] ldst_spr_out_data;
	//Data
	wire [31:0] ldst_data;
	//Load Store Pipe
	wire ldst_pipe_rw;
	wire [31:0] ldst_pipe_addr;
	wire [31:0] ldst_pipe_data;
	wire [1:0] ldst_pipe_order;
	wire [1:0] ldst_pipe_shift;
	wire [3:0] ldst_pipe_mask;


	/****************************************
	Load Store Combination
	****************************************/	
	execute_load_store EXEC_LOAD_STORE(
		//Prev
		.iCMD(iPREVIOUS_EX_ALU3_CMD),
		.iLOADSTORE_MODE(iPREVIOUS_EX_ALU3_VALID),		//0:SYS_LDST | 1:LDST
		.iSOURCE0(iPREVIOUS_EX_ALU3_SOURCE0),
		.iSOURCE1(iPREVIOUS_EX_ALU3_SOURCE1),
		.iADV_ACTIVE(1'b0),
		.iADV_DATA(32'h0),
		.iSPR(spr_data_info),
		.iPC(iPREVIOUS_EX_ALU3_PC - 32'h00000004),
		//Output - Writeback
		.oOUT_SPR_VALID(ldst_spr_out_valid),
		.oOUT_SPR(ldst_spr_out_data),
		.oOUT_DATA(ldst_data),
		//Output - LDST Pipe
		.oLDST_RW(ldst_pipe_rw),
		.oLDST_ADDR(ldst_pipe_addr),
		.oLDST_DATA(ldst_pipe_data),
		.oLDST_ORDER(ldst_pipe_order),
		.oLOAD_SHIFT(ldst_pipe_shift),		
		.oLOAD_MASK(ldst_pipe_mask)		//2bit -> 4bit
	);


	reg b_ldst_pipe_valid;
	reg b_ldst_pipe_rw;
	reg [31:0] b_ldst_pipe_addr;
	reg [31:0] b_ldst_pipe_data;
	reg [1:0] b_ldst_pipe_order;
	reg [1:0] b_ldst_pipe_shift;
	reg [3:0] b_ldst_pipe_mask;

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ldst_pipe_valid <= 1'b0;
			b_ldst_pipe_rw <= 1'b0;
			b_ldst_pipe_addr <= 32'h0;
			b_ldst_pipe_data <= 32'h0;
			b_ldst_pipe_order <= 2'h0;
			b_ldst_pipe_shift <= 2'h0;
			b_ldst_pipe_mask <= 4'h0;
		end
		else if(inRESET)begin
			b_ldst_pipe_valid <= 1'b0;
			b_ldst_pipe_rw <= 1'b0;
			b_ldst_pipe_addr <= 32'h0;
			b_ldst_pipe_data <= 32'h0;
			b_ldst_pipe_order <= 2'h0;
			b_ldst_pipe_shift <= 2'h0;
			b_ldst_pipe_mask <= 4'h0;
		end
		else begin
			if(!this_lock)begin
				b_ldst_pipe_valid <= iPREVIOUS_EX_ALU3_VALID;
				b_ldst_pipe_rw <= ldst_pipe_rw;
				b_ldst_pipe_addr <= ldst_pipe_addr; 
				b_ldst_pipe_data <= ldst_pipe_data;
				b_ldst_pipe_order <= ldst_pipe_order;
				b_ldst_pipe_shift <= b_ldst_pipe_shift;
				b_ldst_pipe_mask <= ldst_pipe_mask;
			end
		end
	end


	/****************************************
	Load State
	****************************************/
	localparam PL_LDST_STT_IDLE = 1'h0;
	localparam PL_LDST_STT_LDWAIT = 1'h1;

	reg b_ldst_state;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ldst_state <= PL_LDST_STT_IDLE;
		end
		else if(iRESET_SYNC)begin
			b_ldst_state <= PL_LDST_STT_IDLE;
		end
		else begin
			case(b_ldst_state)
				PL_LDST_STT_IDLE:
					begin
						if(ldst_pipe_rw && iPREVIOUS_EX_ALU3_VALID && !this_lock)begin
							b_ldst_state <= PL_LDST_STT_LDWAIT;
						end
					end
				PL_LDST_STT_LDWAIT:
					begin
						if(iDATAIO_REQ)begin
							b_ldst_state <= PL_LDST_STT_IDLE;
						end
					end
			endcase
		end
	end

	/****************************************
	Request Buffer
	****************************************/
	reg [5:0] b_latch_commit_tag;
	reg [5:0] b_latch_phisical_dest_addr;

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_latch_commit_tag <= 6'h0;
			b_latch_phisical_dest_addr <= 6'h0;
		end
		else if(iRESET_SYNC)begin
			b_latch_commit_tag <= 6'h0;
			b_latch_phisical_dest_addr <= 6'h0;
		end
		else begin
			if(!this_lock)begin
				b_latch_commit_tag <= iPREVIOUS_EX_ALU3_COMMIT_TAG;
				b_latch_phisical_dest_addr <= iPREVIOUS_EX_ALU3_DESTINATION_REGNAME;
			end
		end
	end

	/****************************************
	Load Data
	****************************************/
	wire [31:0] ldst_pipe_load_data;
	execute_load_data EXEC_LOAD_DATA(
		.iMASK(b_ldst_pipe_mask),
		.iSHIFT(b_ldst_pipe_shift),
		.iDATA(iDATAIO_DATA),
		.oDATA(ldst_pipe_load_data)
	);

	/****************************************
	AFE
	****************************************/
	wire [31:0] ldst_pipe_with_afe_data;
	execute_afe_load_store EXEC_AFE_LDST(
		//AFE-Conrtol
		.iAFE_CODE(),
		//Data-In/Out
		.iDATA(ldst_pipe_load_data),
		.oDATA(ldst_pipe_with_afe_data)
	);



	/****************************************
	Data & IO Port
	****************************************/
	assign oPREVIOUS_EX_ALU3_LOCK = this_lock;
		
	assign oSCHE2_ALU3_DESTINATION_SYSREG = 1'b0;
	
	assign oDATAIO_TID = iSYSREG_TIDR[13:0];
	assign oDATAIO_MMUMOD = iSYSREG_PSR[1:0];
	assign oDATAIO_PDT = iSYSREG_PDTR;
	
	assign oSYSREG_SPR = spr_data_info;
	
	assign oDATAIO_REQ = b_ldst_pipe_valid;
	assign oDATAIO_ORDER = b_ldst_pipe_order;
	assign oDATAIO_RW = b_ldst_pipe_rw;
	assign oDATAIO_ADDR = b_ldst_pipe_addr;
	assign oDATAIO_DATA = b_ldst_pipe_data;
	
	/****************************************
	Scheduler1 and 2 Output
	****************************************/
	wire execute_done = (b_ldst_pipe_valid && b_ldst_pipe_rw) || (b_ldst_pipe_valid && !b_ldst_pipe_rw && iDATAIO_REQ);

	assign oSCHE1_ALU3_VALID = execute_done;
	assign oSCHE1_ALU3_COMMIT_TAG = b_latch_commit_tag;
	assign oSCHE2_ALU3_VALID = execute_done;
	assign oSCHE2_ALU3_DESTINATION_REGNAME = b_latch_phisical_dest_addr;
	assign oSCHE2_ALU3_COMMIT_TAG = b_latch_commit_tag;
	assign oSCHE2_ALU3_WRITEBACK = !b_ldst_pipe_rw;
	assign oSCHE2_ALU3_DATA = ldst_pipe_with_afe_data;


endmodule


`default_nettype wire




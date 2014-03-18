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
		input wire iRESET_SYNC,
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
		output wire [3:0] oDATAIO_MASK,
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
		input wire iPREVIOUS_EX_ALU3_DESTINATION_SYSREG,
		input wire [5:0] iPREVIOUS_EX_ALU3_COMMIT_TAG,
		input wire [4:0] iPREVIOUS_EX_ALU3_CMD,
		input wire [31:0] iPREVIOUS_EX_ALU3_SOURCE0,			
		input wire [31:0] iPREVIOUS_EX_ALU3_SOURCE1,
		input wire iPREVIOUS_EX_ALU3_ADV_ACTIVE,
		input wire [5:0] iPREVIOUS_EX_ALU3_ADV_DATA,
		input wire [4:0] iPREVIOUS_EX_ALU3_LOGIC_DEST,		// for debug
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
		output wire [4:0] oSCHE2_ALU3_LOGIC_DEST,			//for debug
		output wire [5:0] oSCHE2_ALU3_DESTINATION_REGNAME,
		output wire oSCHE2_ALU3_DESTINATION_SYSREG,	
		output wire oSCHE2_ALU3_WRITEBACK,
		output wire [31:0] oSCHE2_ALU3_DATA
	);


	localparam PL_LDST_STT_IDLE = 3'h0;
	localparam PL_LDST_STT_LDREQ = 3'h1;
	localparam PL_LDST_STT_LDWAIT = 3'h2;
	localparam PL_LDST_STT_STREQ = 3'h3;
	localparam PL_LDST_STT_STWAIT = 3'h4;
	localparam PL_LDST_STT_SPRWAIT = 3'h5;

	reg [2:0] b_ldst_state;
	
	wire load_condition = iPREVIOUS_EX_ALU3_LDST && 
							(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LD8 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LD16 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LD32 || 
							iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LDD8 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LDD16 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_LDD32); 
	wire store_condition = iPREVIOUS_EX_ALU3_LDST && 
							(iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_ST8 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_ST16 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_ST32 || 
							iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_STD8 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_STD16 || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_STD32); 
	wire push_condition = iPREVIOUS_EX_ALU3_LDST && (iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_PUSH || iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_PPUSH);
	wire pop_condition = iPREVIOUS_EX_ALU3_LDST && (iPREVIOUS_EX_ALU3_CMD == `EXE_LDSW_POP);
	wire write_spr_condition = iPREVIOUS_EX_ALU3_SYS_LDST && (iPREVIOUS_EX_ALU3_CMD == `EXE_SYS_LDST_WRITE_SPR);
	wire read_spr_condition = iPREVIOUS_EX_ALU3_SYS_LDST && (iPREVIOUS_EX_ALU3_CMD == `EXE_SYS_LDST_READ_SPR);
	wire add_spr_condition = iPREVIOUS_EX_ALU3_SYS_LDST && (iPREVIOUS_EX_ALU3_CMD == `EXE_SYS_LDST_ADD_SPR);

	/****************************************
	Lock
	****************************************/
	wire this_lock = b_ldst_state != PL_LDST_STT_IDLE || iDATAIO_BUSY;

	/****************************************
	SPR Register
	****************************************/	
	wire [31:0] spr_data_info;

	//SPR
	wire ldst_spr_out_valid;
	wire [31:0] ldst_spr_out_data;
	
	wire sysreg_spr_write_condition = iFREE_SYSREG_NEW_SPR_VALID || (!this_lock && iPREVIOUS_EX_ALU3_VALID && (push_condition || pop_condition || write_spr_condition || add_spr_condition));
	
	reg [31:0] spr_write_data;
	always @* begin
		if(iFREE_SYSREG_NEW_SPR_VALID)begin
			spr_write_data = iFREE_SYSREG_NEW_SPR;
		end
		else if(ldst_spr_out_valid)begin
			spr_write_data = ldst_spr_out_data;
		end
		else if(add_spr_condition)begin
			spr_write_data = spr_data_info + iPREVIOUS_EX_ALU3_SOURCE1;
		end
		else begin
			spr_write_data = iPREVIOUS_EX_ALU3_SOURCE0;
		end
	end
	
	
	sysreg_spr_register	SPR_REGISTER(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Register
		.iREGIST_REQ(sysreg_spr_write_condition),
		.iREGIST_DATA(spr_write_data),
		//Info
		.oINFO_DATA(spr_data_info)
	);
	
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


	/****************************************
	Load State
	****************************************/
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
						if((load_condition || pop_condition) && !ldst_pipe_rw && iPREVIOUS_EX_ALU3_VALID && !this_lock)begin
							b_ldst_state <= PL_LDST_STT_LDREQ;
						end
						else if((store_condition || push_condition) && ldst_pipe_rw && iPREVIOUS_EX_ALU3_VALID && !this_lock)begin
							b_ldst_state <= PL_LDST_STT_STREQ;
						end
					end
				PL_LDST_STT_LDREQ:
					begin
						if(!iDATAIO_BUSY)begin
							b_ldst_state <= PL_LDST_STT_LDWAIT;
						end
					end
				PL_LDST_STT_LDWAIT:
					begin
						if(iDATAIO_REQ)begin
							b_ldst_state <= PL_LDST_STT_IDLE;
						end
					end
				PL_LDST_STT_STREQ:
					begin
						if(!iDATAIO_BUSY)begin
							b_ldst_state <= PL_LDST_STT_STWAIT;
						end
					end
				PL_LDST_STT_STWAIT:
					begin
						if(iDATAIO_REQ)begin
							b_ldst_state <= PL_LDST_STT_IDLE;
						end
					end
				PL_LDST_STT_SPRWAIT:
					begin
						b_ldst_state <= PL_LDST_STT_IDLE;
					end
				default:
					begin
						b_ldst_state <= PL_LDST_STT_IDLE;
					end
			endcase
		end
	end


	reg b_ldst_pipe_valid;
	reg b_ldst_pipe_rw;
	reg [31:0] b_ldst_pipe_addr;
	reg [31:0] b_ldst_pipe_data;
	reg [1:0] b_ldst_pipe_order;
	reg [1:0] b_ldst_pipe_shift;
	reg [3:0] b_ldst_pipe_mask;
	reg [31:0] b_ldst_pipe_pcr;

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ldst_pipe_valid <= 1'b0;
			b_ldst_pipe_rw <= 1'b0;
			b_ldst_pipe_addr <= 32'h0;
			b_ldst_pipe_data <= 32'h0;
			b_ldst_pipe_order <= 2'h0;
			b_ldst_pipe_shift <= 2'h0;
			b_ldst_pipe_mask <= 4'h0;
			b_ldst_pipe_pcr <= 32'h0;
		end
		else if(iRESET_SYNC)begin
			b_ldst_pipe_valid <= 1'b0;
			b_ldst_pipe_rw <= 1'b0;
			b_ldst_pipe_addr <= 32'h0;
			b_ldst_pipe_data <= 32'h0;
			b_ldst_pipe_order <= 2'h0;
			b_ldst_pipe_shift <= 2'h0;
			b_ldst_pipe_mask <= 4'h0;
			b_ldst_pipe_pcr <= 32'h0;
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
				b_ldst_pipe_pcr <= iPREVIOUS_EX_ALU3_PC;
			end
		end
	end


	/****************************************
	Request Buffer
	****************************************/
	reg [5:0] b_latch_commit_tag;
	reg [5:0] b_latch_phisical_dest_addr;
	reg [4:0] b_latch_logic_dest;
	reg b_latch_adv_active;
	reg [5:0] b_latch_adv_data;
	reg b_latch_done_exe;

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_latch_commit_tag <= 6'h0;
			b_latch_phisical_dest_addr <= 6'h0;
			b_latch_logic_dest <= 5'h0;
			b_latch_adv_active <= 1'b0;
			b_latch_adv_data <= 6'h0;
			b_latch_done_exe <= 1'h0;
		end
		else if(iRESET_SYNC)begin
			b_latch_commit_tag <= 6'h0;
			b_latch_phisical_dest_addr <= 6'h0;
			b_latch_logic_dest <= 5'h0;
			b_latch_adv_active <= 1'b0;
			b_latch_adv_data <= 6'h0;
		end
		else begin
			if(!this_lock)begin
				b_latch_commit_tag <= iPREVIOUS_EX_ALU3_COMMIT_TAG;
				b_latch_phisical_dest_addr <= iPREVIOUS_EX_ALU3_DESTINATION_REGNAME;
				b_latch_logic_dest <= iPREVIOUS_EX_ALU3_LOGIC_DEST;
				b_latch_adv_active <= iPREVIOUS_EX_ALU3_ADV_ACTIVE;
				b_latch_adv_data <= iPREVIOUS_EX_ALU3_ADV_DATA;
				b_latch_done_exe <= iPREVIOUS_EX_ALU3_VALID && (write_spr_condition || read_spr_condition || add_spr_condition);
			end
			else begin
				b_latch_done_exe <= 1'b0;
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
		.iAFE_CODE(b_latch_adv_data),
		//Data-In/Out
		.iDATA(ldst_pipe_load_data),
		.oDATA(ldst_pipe_with_afe_data)
	);
	wire [31:0] load_data = (b_latch_adv_active)? ldst_pipe_with_afe_data : ldst_pipe_load_data;



	/****************************************
	Data & IO Port
	****************************************/
	assign oPREVIOUS_EX_ALU3_LOCK = this_lock;
		
	assign oSCHE2_ALU3_DESTINATION_SYSREG = 1'b0;
	
	assign oDATAIO_TID = iSYSREG_TIDR[13:0];
	assign oDATAIO_MMUMOD = iSYSREG_PSR[1:0];
	assign oDATAIO_PDT = iSYSREG_PDTR;
	
	assign oSYSREG_SPR = spr_data_info;
	
	assign oDATAIO_REQ = b_ldst_pipe_valid && (b_ldst_state == PL_LDST_STT_LDREQ || b_ldst_state == PL_LDST_STT_STREQ) && !iDATAIO_BUSY;
	assign oDATAIO_ORDER = b_ldst_pipe_order;
	assign oDATAIO_MASK = b_ldst_pipe_mask;
	assign oDATAIO_RW = b_ldst_pipe_rw;
	assign oDATAIO_ADDR = b_ldst_pipe_addr;
	assign oDATAIO_DATA = b_ldst_pipe_data;
	
	/****************************************
	Scheduler1 and 2 Output
	****************************************/
	wire store_done = (b_ldst_state == PL_LDST_STT_STWAIT) && iDATAIO_REQ;
	wire load_done = (b_ldst_state == PL_LDST_STT_LDWAIT) && iDATAIO_REQ;
	wire spr_done = b_latch_done_exe;
	wire execute_done = store_done || load_done || spr_done;

	assign oSCHE1_ALU3_VALID = execute_done;
	assign oSCHE1_ALU3_COMMIT_TAG = b_latch_commit_tag;
	assign oSCHE2_ALU3_VALID = execute_done;
	assign oSCHE2_ALU3_LOGIC_DEST = b_latch_logic_dest;
	assign oSCHE2_ALU3_DESTINATION_REGNAME = b_latch_phisical_dest_addr;
	assign oSCHE2_ALU3_COMMIT_TAG = b_latch_commit_tag;
	assign oSCHE2_ALU3_WRITEBACK = !b_ldst_pipe_rw;
	assign oSCHE2_ALU3_DATA = (b_latch_done_exe)? spr_data_info : load_data;


endmodule


`default_nettype wire




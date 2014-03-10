/****************************************
	Fetch Unit
	- 2 instruction multi fetch
	
	
	Make	:	2010/09/23
	Update	:	2010/10/03
****************************************/
`default_nettype none

module fetch(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Exception
		input wire iEXCEPTION_INST_DISCARD,
		input wire iEXCEPTION_EVENT,
		input wire iEXCEPTION_ADDR_SET,
		input wire [31:0] iEXCEPTION_ADDR,
		input wire iEXCEPTION_RESTART,
		//Fetch Stop
		input wire iFETCH_STOP_LOOPBUFFER_LIMIT,
		//Previous
		input wire iPREVIOUS_0_INST_VALID,
		input wire [5:0] iPREVIOUS_0_MMU_FLAGS,
		input wire [31:0] iPREVIOUS_0_INST,
		input wire iPREVIOUS_1_INST_VALID,
		input wire [5:0] iPREVIOUS_1_MMU_FLAGS,
		input wire [31:0] iPREVIOUS_1_INST,
		output wire oPREVIOUS_LOCK,
		//Fetch
		output wire oPREVIOUS_FETCH_REQ,
		output wire [31:0] oPREVIOUS_FETCH_ADDR,
		input wire iPREVIOUS_FETCH_LOCK,
		//Next
		output wire oNEXT_0_INST_VALID,
		output wire [5:0] oNEXT_0_MMU_FLAGS,
		output wire [31:0] oNEXT_0_INST,
		output wire oNEXT_1_INST_VALID,
		output wire [5:0] oNEXT_1_MMU_FLAGS,
		output wire [31:0] oNEXT_1_INST,
		output wire [31:0] oNEXT_PC,
		input wire iNEXT_LOCK
	);
				

	/****************************************
	Register and Wire
	****************************************/
	//Fetch Address Queue
	wire fetch_addr_queue_full;
	wire [31:0] fetch_addr_queue_addr;
	//Lock
	wire this_lock;
	//PC Request
	reg [31:0] b_pc;
	reg b_fetch_valid;
	reg [1:0] b_fetch_state;
	//Next Output Buffer
	reg [31:0] b0_next_inst;
	reg b0_next_inst_valid;
	reg [5:0] b0_next_mmu_flags;
	reg [31:0] b1_next_inst;
	reg b1_next_inst_valid;
	reg [5:0] b1_next_mmu_flags;
	reg [31:0] b_pc_out;
	reg b_jump_after_change_flag;
	
	
	/****************************************
	Fetch Address Queue
	****************************************/
	mist1032sa_sync_fifo #(32, 8, 3) FETCH_REQ_ADDR_TABLE(
		.iCLOCK(iCLOCK), .inRESET(inRESET), 
		.iREMOVE(iEXCEPTION_RESTART), 
		.oCOUNT(/* Not Use */), 	
		.iWR_EN(!iEXCEPTION_EVENT && b_fetch_valid && !fetch_addr_queue_full && !iPREVIOUS_FETCH_LOCK && !iFETCH_STOP_LOOPBUFFER_LIMIT), 
		.iWR_DATA(b_pc), 
		.oWR_FULL(fetch_addr_queue_full),
		.iRD_EN(oNEXT_0_INST_VALID || oNEXT_1_INST_VALID), 
		.oRD_DATA(fetch_addr_queue_addr), 
		.oRD_EMPTY(/* Not Use */)
	);
	
	/****************************************
	This -> Previous
	****************************************/
	assign this_lock = iNEXT_LOCK || fetch_addr_queue_full || iPREVIOUS_FETCH_LOCK;		//iPREVIOUS_FETCH_LOCK ga lock site naitoki nimo fetch ga tomatte simau
	assign oPREVIOUS_LOCK = (iEXCEPTION_INST_DISCARD)? 1'b0 : iNEXT_LOCK;

	assign oPREVIOUS_FETCH_REQ = !iEXCEPTION_EVENT && b_fetch_valid && !fetch_addr_queue_full && !iPREVIOUS_FETCH_LOCK && !iFETCH_STOP_LOOPBUFFER_LIMIT; 
	assign oPREVIOUS_FETCH_ADDR	= b_pc[31:0];//{1'b0, (b_pc[31:0] >> 1)};

	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_pc <= {32{1'b0}};
			b_fetch_valid <= 1'b0;
			b_fetch_state <= 2'b00;
		end
		
		else if(iEXCEPTION_EVENT)begin		//Jump
			b_fetch_valid <= 1'b0;
			b_fetch_state <= 2'h2;
		end
		/*else if(iEXCEPTION_ADDR_SET && iEXCEPTION_RESTART)begin
			b_pc <= {iEXCEPTION_ADDR[31:1], 1'b0};
			b_fetch_valid <= 1'b1;
			b_fetch_state <= 2'h1;
		end*/
		else begin
			case(b_fetch_state)
				2'h0 :		//Reset Start
					begin
						b_fetch_valid <= 1'b1;
						b_fetch_state <= 2'h1;
						b_pc <= 32'h00000000;
					end
				2'h1 : 		//Fetch State
					begin
						if(/*!this_lock*/!iEXCEPTION_EVENT && !fetch_addr_queue_full && !iPREVIOUS_FETCH_LOCK && !iFETCH_STOP_LOOPBUFFER_LIMIT)begin	
							b_pc <= b_pc + 32'h8;
							b_fetch_valid <= 1'b1;
						end
					end
				2'h2:
					begin
						if(iEXCEPTION_ADDR_SET && iEXCEPTION_RESTART)begin
							b_pc <= {iEXCEPTION_ADDR[31:1], 1'b0};
							b_fetch_valid <= 1'b1;
							b_fetch_state <= 2'h1;
						end
					end
				default :
					begin
						b_pc <= b_pc;
					end	
			endcase
		end
	end //always
	
	/****************************************
	Previous -> Next
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_next_inst <= {32{1'b0}};
			b0_next_inst_valid <= 1'b0;
			b0_next_mmu_flags <= 6'h0;
			b1_next_inst <= {32{1'b0}};
			b1_next_inst_valid <= 1'b0;
			b1_next_mmu_flags <= 6'h0;
			b_pc_out <= {32{1'b0}};
		end
		else if(iEXCEPTION_EVENT)begin
			b0_next_inst <= {32{1'b0}};
			b0_next_inst_valid <= 1'b0;
			b0_next_mmu_flags <= 6'h0;
			b1_next_inst <= {32{1'b0}};
			b1_next_inst_valid <= 1'b0;
			b1_next_mmu_flags <= 6'h0;
			b_pc_out <= {32{1'b0}};
		end
		else begin
			if(!iNEXT_LOCK)begin
				b0_next_inst <= (b_jump_after_change_flag)? iPREVIOUS_1_INST : iPREVIOUS_0_INST;
				b0_next_inst_valid <= !iEXCEPTION_INST_DISCARD && iPREVIOUS_0_INST_VALID;
				b0_next_mmu_flags <= (b_jump_after_change_flag)? iPREVIOUS_1_MMU_FLAGS : iPREVIOUS_0_MMU_FLAGS;
				b1_next_inst <= iPREVIOUS_1_INST;
				b1_next_inst_valid <= (b_jump_after_change_flag)? 1'b0 : (!iEXCEPTION_INST_DISCARD && iPREVIOUS_1_INST_VALID);
				b1_next_mmu_flags <= iPREVIOUS_1_MMU_FLAGS;
				b_pc_out	 <= (b_jump_after_change_flag)? fetch_addr_queue_addr + 32'h1 : fetch_addr_queue_addr;
			end
		end
	end	//always
	
	/****************************************
	Contrall - Change (Jump After Aliment That spans)
	****************************************/
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_jump_after_change_flag <= 1'b0;
		end
		else begin
			//Jump Event
			if(iEXCEPTION_EVENT && iEXCEPTION_ADDR[0])begin			//ayasii
				b_jump_after_change_flag <= 1'b1;
			end
			//Fetch State
			else begin
				if(!iNEXT_LOCK)begin
					if(!iEXCEPTION_INST_DISCARD && (iPREVIOUS_0_INST_VALID && iPREVIOUS_1_INST_VALID))begin
						b_jump_after_change_flag <= 1'b0;
					end
				end
			end
		end
	end
	
	
	assign oNEXT_0_INST = b0_next_inst;
	assign oNEXT_0_INST_VALID = (!iNEXT_LOCK)? b0_next_inst_valid : 1'b0;
	assign oNEXT_0_MMU_FLAGS = b0_next_mmu_flags;
	assign oNEXT_1_INST = b1_next_inst;
	assign oNEXT_1_INST_VALID = (!iNEXT_LOCK)? b1_next_inst_valid : 1'b0;	
	assign oNEXT_1_MMU_FLAGS = b1_next_mmu_flags;
	
	assign oNEXT_PC = b_pc_out;

	
endmodule



`default_nettype wire



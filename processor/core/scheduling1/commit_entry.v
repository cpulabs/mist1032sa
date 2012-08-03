

`default_nettype none

module commit_entry
	#(
		parameter	ENTRY_ID	=		6'h00
	)(
		//System
		input					iCLOCK,
		input					inRESET,	
		//LOCK
		input					iLOCK,
		//Exception
		input					iRESTART_VALID,
		//Regist
		input	[5:0]			iREGIST_POINTER,
		input					iREGIST_0_VALID,
		input					iREGIST_0_MAKE_FLAGS,		
		input					iREGIST_0_WRITEBACK,	
		input	[3:0]			iREGIST_0_FLAGS_PREG_POINTER,	
		input	[5:0]			iREGIST_0_DEST_PREG_POINTER,
		input	[4:0]			iREGIST_0_DEST_LREG_POINTER,	
		input					iREGIST_0_DEST_SYSREG,			
		input					iREGIST_0_EX_BRANCH,
		input					iREGIST_1_VALID,
		input					iREGIST_1_MAKE_FLAGS,			
		input					iREGIST_1_WRITEBACK,			
		input	[3:0]			iREGIST_1_FLAGS_PREG_POINTER,	
		input	[5:0]			iREGIST_1_DEST_PREG_POINTER,
		input	[4:0]			iREGIST_1_DEST_LREG_POINTER,	
		input					iREGIST_1_DEST_SYSREG,			
		input					iREGIST_1_EX_BRANCH,
		input	[31:0]			iREGIST_PC,
		//Commit Pointer
		input					iCOMMIT_VALID,
		//EX-END
		input					iEXEND_ALU0_VALID,
		input	[5:0]			iEXEND_ALU0_COMMIT_TAG,
		input					iEXEND_ALU1_VALID,
		input	[5:0]			iEXEND_ALU1_COMMIT_TAG,
		input					iEXEND_ALU2_VALID,
		input	[5:0]			iEXEND_ALU2_COMMIT_TAG,
		input					iEXEND_ALU3_VALID,
		input	[5:0]			iEXEND_ALU3_COMMIT_TAG,
		//Infomation
		output					oINFO_VALID,
		output					oINFO_MAKE_FLAGS_VALID,			
		output					oINFO_WRITEBACK_VALID,	
		output	[31:0]			oINFO_PC,
		output	[3:0]			oINFO_FLAGS_PREG_POINTER,	
		output	[5:0]			oINFO_DEST_PREG_POINTER,
		output	[4:0]			oINFO_DEST_LREG_POINTER,	
		output					oINFO_DEST_SYSREG,			
		output					oINFO_EX_BRANCH,
		output					oINFO_EX_END,
		output					oINFO_FREE
	);
	
	
	/****************************************
	Previous <-> This
	****************************************/
	/*List Format
	PC, EX_END(LDST_END) 
	*/
	reg		[1:0]		b_state;
	reg		[31:0]		b_pc;
	reg					b_make_flags_validl;
	reg					b_writeback;
	reg		[3:0]		b_flags_preg_pointer;
	reg		[5:0]		b_destination_regname;
	reg		[4:0]		b_logic_destination;
	reg					b_dest_sysreg;
	reg					b_ex_branch;
	
	wire		[5:0]		w_regist_pointer0;
	wire		[5:0]		w_regist_pointer1;
	
	assign					w_regist_pointer0		=		iREGIST_POINTER;
	assign					w_regist_pointer1		=		iREGIST_POINTER + 6'h1;
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state		[1:0]		<=		2'h0;
			b_pc					<=		{32{1'b0}};
			b_make_flags_validl		<=		1'b0;
			b_writeback				<=		1'b0;
			b_flags_preg_pointer	<=		4'h0;
			b_destination_regname	<=		{6{1'b0}};
			b_logic_destination		<=		{5{1'b0}};
			b_dest_sysreg			<=		1'b0;
			b_ex_branch				<=		1'b0;
		end
		else if(b_state == 2'h3 || iRESTART_VALID)begin
			b_state		[1:0]		<=		2'h0;
			b_pc					<=		{32{1'b0}};
			b_make_flags_validl		<=		1'b0;
			b_writeback				<=		1'b0;
			b_flags_preg_pointer	<=		4'h0;
			b_destination_regname	<=		{6{1'b0}};
			b_logic_destination		<=		{5{1'b0}};
			b_dest_sysreg			<=		1'b0;
			b_ex_branch				<=		1'b0;
		end
		else begin
				case(b_state)
					2'h0 :			//Entry Regist Wait
						begin
							if(!iLOCK)begin
								if(iREGIST_0_VALID && ENTRY_ID[5:0] == w_regist_pointer0)begin
									b_state					<=		2'h1;
									b_pc					<=		iREGIST_PC;
									b_make_flags_validl		<=		iREGIST_0_MAKE_FLAGS;
									b_writeback				<=		iREGIST_0_WRITEBACK;
									b_flags_preg_pointer	<=		iREGIST_0_FLAGS_PREG_POINTER;
									b_destination_regname	<=		iREGIST_0_DEST_PREG_POINTER;
									b_logic_destination		<=		iREGIST_0_DEST_LREG_POINTER;
									b_dest_sysreg			<=		iREGIST_0_DEST_SYSREG;
									b_ex_branch				<=		iREGIST_0_EX_BRANCH;
								end
								else if(iREGIST_1_VALID && ENTRY_ID[5:0] == w_regist_pointer1)begin
									b_state					<=		2'h1;
									b_pc					<=		iREGIST_PC + 32'h4;
									b_make_flags_validl		<=		iREGIST_1_MAKE_FLAGS;
									b_writeback				<=		iREGIST_1_WRITEBACK;
									b_flags_preg_pointer	<=		iREGIST_1_FLAGS_PREG_POINTER;
									b_destination_regname	<=		iREGIST_1_DEST_PREG_POINTER;
									b_logic_destination		<=		iREGIST_1_DEST_LREG_POINTER;
									b_dest_sysreg			<=		iREGIST_1_DEST_SYSREG;
									b_ex_branch				<=		iREGIST_1_EX_BRANCH;
								end
							end
						end
					2'h1 :			//Execution End Wait
						begin
							if(iEXEND_ALU0_VALID && iEXEND_ALU0_COMMIT_TAG == ENTRY_ID[5:0])begin
								b_state					<=		2'h2;
							end
							else if(iEXEND_ALU1_VALID && iEXEND_ALU1_COMMIT_TAG == ENTRY_ID[5:0])begin	
								b_state					<=		2'h2;
							end
							else if(iEXEND_ALU2_VALID && iEXEND_ALU2_COMMIT_TAG == ENTRY_ID[5:0])begin
								b_state					<=		2'h2;
							end
							else if(iEXEND_ALU3_VALID && iEXEND_ALU3_COMMIT_TAG == ENTRY_ID[5:0])begin
								b_state					<=		2'h2;
							end
						end
					default :
						begin
							if(iCOMMIT_VALID)begin
								b_state		[1:0]		<=		2'h0;
								//b_pc					<=		{32{1'b0}};
								b_make_flags_validl		<=		1'b0;
								b_writeback				<=		1'b0;
								b_flags_preg_pointer	<=		4'h0;
								b_destination_regname	<=		{6{1'b0}};
								b_logic_destination		<=		{5{1'b0}};
								b_dest_sysreg			<=		1'b0;
								b_ex_branch				<=		b_ex_branch;
							end
						end
				endcase
			//end
		end
	end //always
	
	assign		oINFO_VALID					=		(b_state == 2'h1 || b_state == 2'h2)? 1'b1 : 1'b0;
	assign		oINFO_MAKE_FLAGS_VALID		=		b_make_flags_validl;
	assign		oINFO_WRITEBACK_VALID		=		b_writeback;
	assign		oINFO_PC					=		b_pc;
	assign		oINFO_FLAGS_PREG_POINTER	=		b_flags_preg_pointer;
	assign		oINFO_DEST_PREG_POINTER		=		b_destination_regname;
	assign		oINFO_DEST_LREG_POINTER		=		b_logic_destination;
	assign		oINFO_DEST_SYSREG			=		b_dest_sysreg;
	assign		oINFO_EX_BRANCH				=		b_ex_branch;
	assign		oINFO_EX_END				=		(b_state == 2'h2)? 1'b1 : 1'b0; 
	assign		oINFO_FREE					=		(iRESTART_VALID && ((b_state == 2'h1) || (b_state == 2'h2)))? 1'b1 : 1'b0;
	
	
endmodule


`default_nettype wire


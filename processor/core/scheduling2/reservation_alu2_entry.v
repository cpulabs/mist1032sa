
`default_nettype none


module reservation_alu2_entry(
				//System
				input					iCLOCK,
				input					inRESET,
				//Entry Remove
				input					iREMOVE_VALID,
				//Regist
				input					iREGIST_VALID,
				output					oINFO_REGIST_LOCK,
				input					iREGIST_DESTINATION_SYSREG,
				input					iREGIST_WRITEBACK,
				input	[4:0]			iREGIST_CMD,
				input	[3:0]			iREGIST_AFE,
				input					iREGIST_SYS_REG,	
				input					iREGIST_LOGIC,
				input					iREGIST_SHIFT,
				input					iREGIST_ADDER,
				input					iREGIST_FLAGS_OPT_VALID,	
				input	[3:0]			iREGIST_FLAGS_REGNAME,			
				input					iREGIST_SOURCE0_VALID,
				input	[31:0]			iREGIST_SOURCE0,		
				input					iREGIST_SOURCE1_VALID,
				input	[31:0]			iREGIST_SOURCE1,
				input	[5:0]			iREGIST_DESTINATION_REGNAME,
				input	[5:0]			iREGIST_COMMIT_TAG,
				//Common Data Bus CDB(CH0, ADDER)
				input					iALU1_VALID,
				input	[5:0]			iALU1_DESTINATION_REGNAME,
				input					iALU1_WRITEBACK,
				input	[31:0]			iALU1_DATA,
				//Common Data Bus CDB(CH1, MULDIV)
				input					iALU2_VALID,
				input	[5:0]			iALU2_DESTINATION_REGNAME,
				input					iALU2_WRITEBACK,
				input	[31:0]			iALU2_DATA,	
				//Common Data Bus CDB(CH1, LDST)
				input					iALU3_VALID,
				input	[5:0]			iALU3_DESTINATION_REGNAME,
				input	[31:0]			iALU3_DATA,
				//Request Execution
				input					iEXOUT_VALID,
				//Info
				output					oINFO_ENTRY_VALID,
				output					oINFO_MATCHING,
				output					oINFO_DESTINATION_SYSREG,
				output					oINFO_WRITEBACK,
				output	[4:0]			oINFO_CMD,
				output	[3:0]			oINFO_AFE,
				output					oINFO_SYS_REG,		
				output					oINFO_LOGIC,
				output					oINFO_SHIFT,
				output					oINFO_ADDER,
				output					oINFO_FLAGS_OPT_VALID,
				output	[3:0]			oINFO_FLAGS_REGNAME,
				output					oINFO_SOURCE0_VALID,
				output	[31:0]			oINFO_SOURCE0,
				output					oINFO_SOURCE1_VALID,
				output	[31:0]			oINFO_SOURCE1,
				output	[5:0]			oINFO_DESTINATION_REGNAME,
				output	[5:0]			oINFO_COMMIT_TAG);
				

				
	reg					b0_state;
	reg					b0_reg_lock;
	reg					b0_destination_sysreg;
	reg					b0_writeback;
	reg		[4:0]		b0_cmd;
	reg		[3:0]		b0_afe;
	reg					b0_sys_reg;
	reg					b0_logic;
	reg					b0_shift;
	reg					b0_adder;
	reg					b0_flag_opt_valid;
	reg		[3:0]		b0_flags_regname;
	reg					b0_source0_valid;
	reg		[31:0]		b0_source0;
	reg					b0_source1_valid;
	reg		[31:0]		b0_source1;
	reg		[5:0]		b0_destination_regname;
	reg		[5:0]		b0_commit_tag;
	

	always@(negedge inRESET or posedge iCLOCK)begin
		if(!inRESET)begin
			b0_state					<=		1'h0;
			b0_reg_lock					<=		1'b0;
			b0_destination_sysreg		<=		1'b0;
			b0_writeback				<=		1'b0;
			b0_cmd						<=		{5{1'b0}};
			b0_afe						<=		{4{1'b0}};
			b0_sys_reg					<=		1'b0;
			b0_logic					<=		1'b0;
			b0_shift					<=		1'b0;
			b0_adder					<=		1'b0;
			b0_flag_opt_valid			<=		1'b0;
			b0_flags_regname			<=		4'h0;
			b0_source0_valid			<=		1'b0;
			b0_source0					<=		{31{1'b0}};
			b0_source1_valid			<=		1'b0;
			b0_source1					<=		{31{1'b0}};
			b0_destination_regname		<=		{6{1'b0}};
			b0_commit_tag				<=		{6{1'b0}};
		end
		else if(iREMOVE_VALID || iEXOUT_VALID)begin
			b0_state					<=		1'h0;
			b0_reg_lock					<=		1'b1;
			b0_destination_sysreg		<=		1'b0;
			b0_writeback				<=		1'b0;
			b0_cmd						<=		{5{1'b0}};
			b0_afe						<=		{4{1'b0}};
			b0_sys_reg					<=		1'b0;
			b0_logic					<=		1'b0;
			b0_shift					<=		1'b0;
			b0_adder					<=		1'b0;
			b0_flag_opt_valid			<=		1'b0;
			b0_flags_regname			<=		4'h0;
			b0_source0_valid			<=		1'b0;
			b0_source0					<=		{31{1'b0}};
			b0_source1_valid			<=		1'b0;
			b0_source1					<=		{31{1'b0}};
			b0_destination_regname		<=		{6{1'b0}};
			b0_commit_tag				<=		{6{1'b0}};
		end
		else begin
			case(b0_state)
				1'h0 :			//Entry Regist Wait
					begin
						if(iREGIST_VALID)begin
							b0_state					<=		1'h1;
							b0_reg_lock					<=		1'b1;
							b0_destination_sysreg		<=		iREGIST_DESTINATION_SYSREG;
							b0_writeback				<=		iREGIST_WRITEBACK;
							b0_cmd						<=		iREGIST_CMD;
							b0_afe						<=		iREGIST_AFE;
							b0_sys_reg					<=		iREGIST_SYS_REG;
							b0_logic					<=		iREGIST_LOGIC;
							b0_shift					<=		iREGIST_SHIFT;
							b0_adder					<=		iREGIST_ADDER;
							//Source 0
							if(iREGIST_SOURCE0_VALID)begin
								b0_source0_valid			<=		1'b1;
								b0_source0					<=		iREGIST_SOURCE0;
							end
							else if(iALU1_VALID & iALU1_WRITEBACK && iREGIST_SOURCE0[5:0] == iALU1_DESTINATION_REGNAME)begin
								b0_source0_valid			<=		1'b1;
								b0_source0					<=		iALU1_DATA;
							end
							else if(iALU2_VALID & iALU2_WRITEBACK && iREGIST_SOURCE0[5:0] == iALU2_DESTINATION_REGNAME)begin
								b0_source0_valid			<=		1'b1;
								b0_source0					<=		iALU2_DATA;
							end
							else if(iALU3_VALID && iREGIST_SOURCE0[5:0] == iALU3_DESTINATION_REGNAME)begin
								b0_source0_valid			<=		1'b1;
								b0_source0					<=		iALU3_DATA;
							end
							else begin
								b0_source0_valid			<=		1'b0;
								b0_source0					<=		{{26{1'b0}}, iREGIST_SOURCE0[5:0]};
							end	
							
							//Source1 
							if(iREGIST_SOURCE1_VALID)begin
								b0_source1_valid			<=		1'b1;
								b0_source1					<=		iREGIST_SOURCE1;
							end
							else if(iALU1_VALID & iALU1_WRITEBACK && iREGIST_SOURCE1[5:0] == iALU1_DESTINATION_REGNAME)begin
								b0_source1_valid			<=		1'b1;
								b0_source1					<=		iALU1_DATA;
							end
							else if(iALU2_VALID & iALU2_WRITEBACK && iREGIST_SOURCE1[5:0] == iALU2_DESTINATION_REGNAME)begin
								b0_source1_valid			<=		1'b1;
								b0_source1					<=		iALU2_DATA;
							end
							else if(iALU3_VALID && iREGIST_SOURCE1[5:0] == iALU3_DESTINATION_REGNAME)begin
								b0_source1_valid			<=		1'b1;
								b0_source1					<=		iALU3_DATA;
							end
							else begin
								b0_source1_valid			<=		1'b0;
								b0_source1					<=		{{26{1'b0}}, iREGIST_SOURCE1[5:0]};
							end
							b0_flag_opt_valid			<=		iREGIST_FLAGS_OPT_VALID;
							b0_flags_regname			<=		iREGIST_FLAGS_REGNAME;
							b0_destination_regname		<=		iREGIST_DESTINATION_REGNAME;
							b0_commit_tag				<=		iREGIST_COMMIT_TAG;
						end
						else begin
							b0_reg_lock					<=		1'b0;
						end
					end
				default :
					begin
						//Source0 Matching Check
						if(!b0_source0_valid & iALU1_VALID & iALU1_WRITEBACK && b0_source0[5:0] == iALU1_DESTINATION_REGNAME)begin
							b0_source0_valid			<=		1'b1;
							b0_source0					<=		iALU1_DATA;
						end
						else if(!b0_source0_valid & iALU2_VALID & iALU2_WRITEBACK  && b0_source0[5:0] == iALU2_DESTINATION_REGNAME)begin
							b0_source0_valid			<=		1'b1;
							b0_source0					<=		iALU2_DATA;
						end
						else if(!b0_source0_valid & iALU3_VALID && b0_source0[5:0] == iALU3_DESTINATION_REGNAME)begin
							b0_source0_valid			<=		1'b1;
							b0_source0					<=		iALU3_DATA;
						end	
						//Source1 Matching Check
						if(!b0_source1_valid & iALU1_VALID & iALU1_WRITEBACK  && b0_source1[5:0] == iALU1_DESTINATION_REGNAME)begin
							b0_source1_valid			<=		1'b1;
							b0_source1					<=		iALU1_DATA;
						end
						else if(!b0_source1_valid & iALU2_VALID & iALU2_WRITEBACK  && b0_source1[5:0] == iALU2_DESTINATION_REGNAME)begin
							b0_source1_valid			<=		1'b1;
							b0_source1					<=		iALU2_DATA;
						end
						else if(!b0_source1_valid & iALU3_VALID && b0_source1[5:0] == iALU3_DESTINATION_REGNAME)begin
							b0_source1_valid			<=		1'b1;
							b0_source1					<=		iALU3_DATA;
						end	
					end
			endcase
		end	
	end //always
	
	//Output
	assign	oINFO_ENTRY_VALID			=		b0_state;
	assign	oINFO_REGIST_LOCK			=		b0_reg_lock;
	assign	oINFO_MATCHING				=		b0_source0_valid & b0_source1_valid;
	assign	oINFO_DESTINATION_SYSREG	=		b0_destination_sysreg;
	assign	oINFO_WRITEBACK				=		b0_writeback;
	assign	oINFO_CMD					=		b0_cmd;
	assign	oINFO_AFE					=		b0_afe;
	assign	oINFO_SYS_REG				=		b0_sys_reg;
	assign	oINFO_LOGIC					=		b0_logic;
	assign	oINFO_SHIFT					=		b0_shift;
	assign	oINFO_ADDER					=		b0_adder;
	assign	oINFO_FLAGS_OPT_VALID		=		b0_flag_opt_valid;
	assign	oINFO_FLAGS_REGNAME			=		b0_flags_regname;
	assign	oINFO_SOURCE0_VALID			=		b0_source0_valid;
	assign	oINFO_SOURCE0				=		b0_source0;
	assign	oINFO_SOURCE1_VALID			=		b0_source1_valid;
	assign	oINFO_SOURCE1				=		b0_source1;
	assign	oINFO_DESTINATION_REGNAME	=		b0_destination_regname;
	assign	oINFO_COMMIT_TAG			=		b0_commit_tag;
	
	
endmodule



`default_nettype wire

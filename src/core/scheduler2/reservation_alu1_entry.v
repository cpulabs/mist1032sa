
`default_nettype none


module reservation_alu1_entry(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Entry Remove
		input wire iREMOVE_VALID,
		//Regist
		input wire iREGISTER_VALID,
		output wire oINFO_REGIST_LOCK,
		input wire iREGISTER_DESTINATION_SYSREG,
		input wire iREGISTER_WRITEBACK,
		input wire [4:0] iREGISTER_CMD,
		input wire [3:0] iREGISTER_AFE,
		input wire iREGISTER_SYS_REG,
		input wire iREGISTER_LOGIC,
		input wire iREGISTER_SHIFT,
		input wire iREGISTER_ADDER,
		input wire iREGISTER_MUL,
		input wire iREGISTER_SDIV,
		input wire iREGISTER_UDIV,
		input wire iREGISTER_FLAGS_OPT_VALID,		
		input wire [3:0] iREGISTER_FLAGS_REGNAME,	
		input wire iREGISTER_SOURCE0_VALID,
		input wire [31:0] iREGISTER_SOURCE0,		
		input wire iREGISTER_SOURCE1_VALID,
		input wire [31:0] iREGISTER_SOURCE1,
		input wire [31:0] iREGISTER_PCR,
		input wire [5:0] iREGISTER_DESTINATION_REGNAME,
		input wire [5:0] iREGISTER_COMMIT_TAG,
		//Common Data Bus CDB(CH0, ADDER)
		input wire iALU1_VALID,
		input wire [5:0] iALU1_DESTINATION_REGNAME,
		input wire iALU1_WRITEBACK,
		input wire [31:0] iALU1_DATA,
		//Common Data Bus CDB(CH1, MULDIV)
		input wire iALU2_VALID,
		input wire [5:0] iALU2_DESTINATION_REGNAME,
		input wire iALU2_WRITEBACK,
		input wire [31:0] iALU2_DATA,	
		//Common Data Bus CDB(CH2, LDST)
		input wire iALU3_VALID,
		input wire [5:0] iALU3_DESTINATION_REGNAME,
		input wire [31:0] iALU3_DATA,
		//Request Execution
		input wire iEXOUT_VALID,
		//Info
		output wire oINFO_ENTRY_VALID,
		output wire oINFO_MATCHING,
		output wire oINFO_DESTINATION_SYSREG,
		output wire oINFO_WRITEBACK,
		output wire [4:0] oINFO_CMD,
		output wire [3:0] oINFO_AFE,
		output wire oINFO_SYS_REG,	
		output wire oINFO_LOGIC,
		output wire oINFO_SHIFT,
		output wire oINFO_ADDER,
		output wire oINFO_MUL,
		output wire oINFO_SDIV,
		output wire oINFO_UDIV,
		output wire oINFO_FLAGS_OPT_VALID,
		output wire [3:0] oINFO_FLAGS_REGNAME,
		output wire oINFO_SOURCE0_VALID,
		output wire [31:0] oINFO_SOURCE0,
		output wire oINFO_SOURCE1_VALID,
		output wire [31:0] oINFO_SOURCE1,
		output wire [31:0] oINFO_PCR,
		output wire [5:0] oINFO_DESTINATION_REGNAME,
		output wire [5:0] oINFO_COMMIT_TAG
	);
				

				
	reg b0_state;
	reg b0_reg_lock;
	reg b0_destination_sysreg;
	reg b0_writeback;
	reg [4:0] b0_cmd;
	reg [3:0] b0_afe;
	reg b0_sys_reg;
	reg b0_logic;
	reg b0_shift;
	reg b0_adder;
	reg b0_mul;
	reg b0_sdiv;
	reg b0_udiv;
	reg b0_flags_opt_valid;
	reg [3:0] b0_flags_regname;
	reg b0_source0_valid;
	reg [31:0] b0_source0;
	reg b0_source1_valid;
	reg [31:0] b0_source1;
	reg [31:0] b0_pcr;
	reg [5:0] b0_destination_regname;
	reg [5:0] b0_commit_tag;
	
	
	always@(negedge inRESET or posedge iCLOCK)begin
		if(!inRESET)begin
			b0_state <= 1'h0;
			b0_reg_lock <= 1'b0;
			b0_destination_sysreg <= 1'b0;
			b0_writeback <= 1'b0;
			b0_cmd <= {5{1'b0}};
			b0_afe <= {4{1'b0}};
			b0_sys_reg <= 1'b0;
			b0_logic <= 1'b0;
			b0_shift <= 1'b0;
			b0_adder <= 1'b0;
			b0_mul <= 1'b0;
			b0_sdiv <= 1'b0;
			b0_udiv <= 1'b0;
			b0_flags_opt_valid <= 1'b0;
			b0_flags_regname <= 4'h0;
			b0_source0_valid <= 1'b0;
			b0_source0 <= {32{1'b0}};
			b0_source1_valid <= 1'b0;
			b0_source1 <= {32{1'b0}};
			b0_pcr <= 32'h0;
			b0_destination_regname <= {6{1'b0}};
			b0_commit_tag <= {6{1'b0}};
		end
		else if(iREMOVE_VALID || iEXOUT_VALID)begin
			b0_state <= 1'h0;
			b0_reg_lock <= 1'b1;
			b0_destination_sysreg <= 1'b0;
			b0_writeback <= 1'b0;
			b0_cmd <= {5{1'b0}};
			b0_afe <= {4{1'b0}};
			b0_sys_reg <= 1'b0;
			b0_logic <= 1'b0;
			b0_shift <= 1'b0;
			b0_adder <= 1'b0;
			b0_mul <= 1'b0;
			b0_sdiv <= 1'b0;
			b0_udiv <= 1'b0;
			b0_flags_opt_valid <= 1'b0;
			b0_flags_regname <= 4'h0;
			b0_source0_valid <= 1'b0;
			b0_source0 <= {32{1'b0}};
			b0_source1_valid <= 1'b0;
			b0_source1 <= {32{1'b0}};
			b0_pcr <= 32'h0;
			b0_destination_regname <= {6{1'b0}};
			b0_commit_tag <= {6{1'b0}};
		end
		else begin
			case(b0_state)
				1'h0 :			//Entry Regist Wait
					begin
						if(iREGISTER_VALID)begin
							b0_state <= 1'h1;
							b0_reg_lock <= 1'b1;
							b0_destination_sysreg <= iREGISTER_DESTINATION_SYSREG;
							b0_writeback <= iREGISTER_WRITEBACK;
							b0_cmd <= iREGISTER_CMD;
							b0_afe <= iREGISTER_AFE;
							b0_sys_reg <= iREGISTER_SYS_REG;
							b0_logic <= iREGISTER_LOGIC;
							b0_shift <= iREGISTER_SHIFT;
							b0_adder <= iREGISTER_ADDER;
							b0_mul <= iREGISTER_MUL;
							b0_sdiv <= iREGISTER_SDIV;
							b0_udiv <= iREGISTER_UDIV;
							//Source 0
							if(iREGISTER_SOURCE0_VALID)begin
								b0_source0_valid <= 1'b1;
								b0_source0 <= iREGISTER_SOURCE0;
							end
							else if(iALU1_VALID & iALU1_WRITEBACK && iREGISTER_SOURCE0[5:0] == iALU1_DESTINATION_REGNAME)begin
								b0_source0_valid <= 1'b1;
								b0_source0 <= iALU1_DATA;
							end
							else if(iALU2_VALID & iALU2_WRITEBACK && iREGISTER_SOURCE0[5:0] == iALU2_DESTINATION_REGNAME)begin
								b0_source0_valid <= 1'b1;
								b0_source0 <= iALU2_DATA;
							end
							else if(iALU3_VALID && iREGISTER_SOURCE0[5:0] == iALU3_DESTINATION_REGNAME)begin
								b0_source0_valid <= 1'b1;
								b0_source0 <= iALU3_DATA;
							end
							else begin
								b0_source0_valid <= 1'b0;
								b0_source0 <= {{26{1'b0}}, iREGISTER_SOURCE0[5:0]};
							end	
							
							//Source1 
							if(iREGISTER_SOURCE1_VALID)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iREGISTER_SOURCE1;
							end
							else if(iALU1_VALID & iALU1_WRITEBACK && iREGISTER_SOURCE1[5:0] == iALU1_DESTINATION_REGNAME)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iALU1_DATA;
							end
							else if(iALU2_VALID & iALU2_WRITEBACK && iREGISTER_SOURCE1[5:0] == iALU2_DESTINATION_REGNAME)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iALU2_DATA;
							end
							else if(iALU3_VALID && iREGISTER_SOURCE1[5:0] == iALU3_DESTINATION_REGNAME)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iALU3_DATA;
							end
							else begin
								b0_source1_valid <= 1'b0;
								b0_source1 <= {{26{1'b0}}, iREGISTER_SOURCE1[5:0]};
							end
							b0_flags_opt_valid <= iREGISTER_FLAGS_OPT_VALID;
							b0_flags_regname <= iREGISTER_FLAGS_REGNAME;
							b0_destination_regname <= iREGISTER_DESTINATION_REGNAME;
							b0_commit_tag <= iREGISTER_COMMIT_TAG;
							b0_pcr <= iREGISTER_PCR;
						end
						else begin
							b0_reg_lock <= 1'b0;
						end
					end
				default :
					begin
						//Source0 Matching Check
						if(!b0_source0_valid & iALU1_VALID & iALU1_WRITEBACK && b0_source0[5:0] == iALU1_DESTINATION_REGNAME)begin
							b0_source0_valid <= 1'b1;
							b0_source0 <= iALU1_DATA;
						end
						else if(!b0_source0_valid & iALU2_VALID & iALU2_WRITEBACK  && b0_source0[5:0] == iALU2_DESTINATION_REGNAME)begin
							b0_source0_valid <= 1'b1;
							b0_source0 <= iALU2_DATA;
						end
						else if(!b0_source0_valid & iALU3_VALID && b0_source0[5:0] == iALU3_DESTINATION_REGNAME)begin
							b0_source0_valid <= 1'b1;
							b0_source0 <= iALU3_DATA;
						end	
						//Source1 Matching Check
						if(!b0_source1_valid & iALU1_VALID & iALU1_WRITEBACK  && b0_source1[5:0] == iALU1_DESTINATION_REGNAME)begin
							b0_source1_valid <= 1'b1;
							b0_source1 <= iALU1_DATA;
						end
						else if(!b0_source1_valid & iALU2_VALID & iALU2_WRITEBACK  && b0_source1[5:0] == iALU2_DESTINATION_REGNAME)begin
							b0_source1_valid <= 1'b1;
							b0_source1 <= iALU2_DATA;
						end
						else if(!b0_source1_valid & iALU3_VALID && b0_source1[5:0] == iALU3_DESTINATION_REGNAME)begin
							b0_source1_valid <= 1'b1;
							b0_source1 <= iALU3_DATA;
						end	
					end
			endcase
		end	
	end //always
	
	//Output
	assign oINFO_ENTRY_VALID = b0_state;
	assign oINFO_REGIST_LOCK = b0_reg_lock;
	assign oINFO_MATCHING = b0_source0_valid && b0_source1_valid;
	assign oINFO_DESTINATION_SYSREG = b0_destination_sysreg;
	assign oINFO_WRITEBACK = b0_writeback;
	assign oINFO_CMD = b0_cmd;
	assign oINFO_AFE = b0_afe;
	assign oINFO_SYS_REG = b0_sys_reg;
	assign oINFO_LOGIC = b0_logic;
	assign oINFO_SHIFT = b0_shift;
	assign oINFO_ADDER = b0_adder;
	assign oINFO_MUL = b0_mul;
	assign oINFO_SDIV = b0_sdiv;
	assign oINFO_UDIV = b0_udiv;
	assign oINFO_FLAGS_OPT_VALID = b0_flags_opt_valid;
	assign oINFO_FLAGS_REGNAME = b0_flags_regname;
	assign oINFO_SOURCE0_VALID = b0_source0_valid;
	assign oINFO_SOURCE0 = b0_source0;
	assign oINFO_SOURCE1_VALID = b0_source1_valid;
	assign oINFO_SOURCE1 = b0_source1;
	assign oINFO_PCR = b0_pcr;
	assign oINFO_DESTINATION_REGNAME = b0_destination_regname;
	assign oINFO_COMMIT_TAG = b0_commit_tag;

	
	
endmodule



`default_nettype wire

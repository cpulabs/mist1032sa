`include "core.h"
`default_nettype none


module reservation_alu0_entry(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//LOCK
		//input wire iLOCK,
		//Entry Remove
		input wire iREMOVE_VALID,
		//Regist
		input wire iREGIST_VALID,
		input wire [4:0] iREGIST_CMD,
		input wire [3:0] iREGIST_CC,
		input wire iREGIST_FLAGS_VALID,
		input wire [4:0] iREGIST_FLAGS,
		input wire iREGIST_SOURCE1_VALID,
		input wire [31:0] iREGIST_SOURCE1,
		input wire [31:0] iREGIST_PC,
		input wire [5:0] iREGIST_DESTINATION_REGNAME,
		input wire [5:0] iREGIST_COMMIT_TAG,	
		input wire [3:0] iREGIST_EX_REGIST_POINTER,		
		//Common Data Bus CDB(CH1, ADDER)
		input wire iALU1_VALID,
		input wire iALU1_FLAGS_OPT_VALID,	
		input wire [3:0] iALU1_FLAGS_REGNAME,				//NEW
		input wire [5:0] iALU1_DESTINATION_REGNAME,
		input wire iALU1_WRITEBACK,
		input wire [31:0] iALU1_DATA,
		input wire [4:0] iALU1_FLAGS,
		//Common Data Bus CDB(CH2, MULDIV)
		input wire iALU2_VALID,
		input wire iALU2_FLAGS_OPT_VALID,		
		input wire [3:0] iALU2_FLAGS_REGNAME,				//NEW	
		input wire [5:0] iALU2_DESTINATION_REGNAME,
		input wire iALU2_WRITEBACK,	
		input wire [31:0] iALU2_DATA,
		input wire [4:0] iALU2_FLAGS,
		//Common Data Bus CDB(CH3, LDST)
		input wire iALU3_VALID,
		input wire [5:0] iALU3_DESTINATION_REGNAME,
		input wire [31:0] iALU3_DATA,
		//EX Execution Pointer
		input wire [3:0] iEX_EXECUTION_POINTER,
		//Request Execution
		input wire iEXOUT_VALID,
		//Info
		output wire oINFO_ENTRY_VALID,
		output wire oINFO_MATCHING,
		output wire [4:0] oINFO_CMD,
		output wire [3:0] oINFO_CC,
		output wire oINFO_FLAG_VALID,
		output wire [4:0] oINFO_FLAG,
		output wire oINFO_SOURCE1_VALID,
		output wire [31:0] oINFO_SOURCE1,
		output wire [31:0] oINFO_PC,
		output wire [5:0] oINFO_DESTINATION_REGNAME,
		output wire [5:0] oINFO_COMMIT_TAG
	);
					
	reg [1:0] b0_state;
	reg b0_entry_valid;
	reg [4:0] b0_cmd;
	reg [3:0] b0_cc;
	reg b0_flag_valid;
	reg [4:0] b0_flag;
	reg b0_source1_valid;
	reg [31:0] b0_source1;
	reg [31:0] b0_pc;
	reg [5:0] b0_destination_regname;
	reg [5:0] b0_commit_tag;
	reg b0_ex_pointer_matching;
	reg [3:0] b0_ex_pointer;	//iREGIST_EX_REGIST_POINTER
					
					
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_state <= 2'h0;
			b0_entry_valid <= 1'b0;
			b0_cmd <= {5{1'b0}};
			b0_cc <= {4{1'b0}};
			b0_flag_valid <= 1'b0;
			b0_flag <= {5{1'b0}};
			b0_source1_valid <= 1'b0;
			b0_source1 <= {32{1'b0}};
			b0_pc <= {32{1'b0}};
			b0_destination_regname <= {6{1'b0}};
			b0_commit_tag <= {6{1'b0}};
			b0_ex_pointer_matching <= 1'b0;
			b0_ex_pointer <= {4{1'b0}};
		end
		else if(iEXOUT_VALID || iREMOVE_VALID)begin
			b0_state <= 2'h0;
			b0_entry_valid <= 1'b0;
			b0_cmd <= {5{1'b0}};
			b0_cc <= {4{1'b0}};
			b0_flag_valid <= 1'b0;
			b0_flag <= {5{1'b0}};
			b0_source1_valid <= 1'b0;
			b0_source1 <= {32{1'b0}};
			b0_pc <= {32{1'b0}};
			b0_destination_regname <= {6{1'b0}};
			b0_commit_tag <= {6{1'b0}};
			b0_ex_pointer_matching <= 1'b0;
			b0_ex_pointer <= {4{1'b0}};
		end
		else begin
			case(b0_state)
				2'h0 :
					begin
						//Regist
						if(iREGIST_VALID)begin
							b0_state <= 2'h1;
							b0_entry_valid <= 1'b1;
							b0_cmd <= iREGIST_CMD;
							b0_cc <= iREGIST_CC;
							//Source 1
							if(iREGIST_SOURCE1_VALID)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iREGIST_SOURCE1;
							end
							else if(iALU1_VALID & iALU1_WRITEBACK && iREGIST_SOURCE1[5:0] == iALU1_DESTINATION_REGNAME)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iALU1_DATA;
							end
							else if(iALU2_VALID & iALU2_WRITEBACK && iREGIST_SOURCE1[5:0] == iALU2_DESTINATION_REGNAME)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iALU2_DATA;
							end
							else if(iALU3_VALID && iREGIST_SOURCE1[5:0] == iALU3_DESTINATION_REGNAME)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iALU3_DATA;
							end
							else begin
								b0_source1_valid <= 1'b0;
								b0_source1 <= {{26{1'b0}}, iREGIST_SOURCE1[5:0]};
							end
							//Flag
							if(iREGIST_CC == `CC_AL)begin
								b0_flag_valid <= 1'b1;
								b0_flag <= 5'h0;
							end
							else if(iREGIST_FLAGS_VALID)begin
								b0_flag_valid <= 1'b1;
								b0_flag <= iREGIST_FLAGS;
							end
							else begin
								if(iALU1_VALID && iALU1_FLAGS_OPT_VALID && iALU1_FLAGS_REGNAME == iREGIST_FLAGS[3:0])begin
									b0_flag_valid <= 1'b1;
									b0_flag <= iALU1_FLAGS;
								end
								else if(iALU2_VALID && iALU2_FLAGS_OPT_VALID && iALU2_FLAGS_REGNAME == iREGIST_FLAGS[3:0])begin
									b0_flag_valid <= 1'b1;
									b0_flag <= iALU2_FLAGS;
								end
								else begin
									b0_flag_valid <= 1'b0;
									b0_flag <= iREGIST_FLAGS;
								end
							end
							
							b0_pc <= iREGIST_PC;
							b0_destination_regname <= iREGIST_DESTINATION_REGNAME;
							b0_commit_tag <= iREGIST_COMMIT_TAG;
							
							//Ex Inorder Pointer
							if(iREGIST_EX_REGIST_POINTER == iEX_EXECUTION_POINTER)begin
								b0_ex_pointer_matching <= 1'b1;
								b0_ex_pointer <= {4{1'b0}};
							end
							else begin
								b0_ex_pointer_matching <= 1'b0;
								b0_ex_pointer <= iREGIST_EX_REGIST_POINTER;
							end
						end
					end
				2'h1 :
					begin
						//Source 1 Matching
						if(!b0_source1_valid && iALU1_VALID && iALU1_WRITEBACK && b0_source1[5:0] == iALU1_DESTINATION_REGNAME)begin
							b0_source1_valid <= 1'b1;
							b0_source1 <= iALU1_DATA;
						end
						else if(!b0_source1_valid && iALU2_VALID && iALU2_WRITEBACK && b0_source1[5:0] == iALU2_DESTINATION_REGNAME)begin
							b0_source1_valid <= 1'b1;
							b0_source1 <= iALU2_DATA;
						end
						else if(!b0_source1_valid && iALU3_VALID && b0_source1[5:0] == iALU3_DESTINATION_REGNAME)begin
							b0_source1_valid <= 1'b1;
							b0_source1 <= iALU3_DATA;
						end
						
						//Flag
						if(!b0_flag_valid)begin
							if(iALU1_VALID && iALU1_FLAGS_OPT_VALID && iALU1_FLAGS_REGNAME == b0_flag[3:0])begin
								b0_flag_valid <= 1'b1;
								b0_flag <= iALU1_FLAGS;
							end
							else if(iALU2_VALID && iALU2_FLAGS_OPT_VALID && iALU2_FLAGS_REGNAME == b0_flag[3:0])begin
								b0_flag_valid <= 1'b1;
								b0_flag <= iALU2_FLAGS;
							end
						end
						
						//Ex Inorder Pointer
						if(!b0_ex_pointer_matching & b0_ex_pointer == iEX_EXECUTION_POINTER)begin
							b0_ex_pointer_matching <= 1'b1;
							b0_ex_pointer <= {4{1'b0}};
						end
					end	
			endcase
		end
	end //always
	
	//Module Output
	assign oINFO_ENTRY_VALID = b0_entry_valid;
	assign oINFO_MATCHING = b0_entry_valid && b0_flag_valid && b0_source1_valid && b0_ex_pointer_matching;
	assign oINFO_CMD = b0_cmd;
	assign oINFO_CC = b0_cc;
	assign oINFO_FLAG_VALID = b0_flag_valid;
	assign oINFO_FLAG = b0_flag[4:0];
	assign oINFO_SOURCE1_VALID = b0_source1_valid;
	assign oINFO_SOURCE1 = b0_source1;
	assign oINFO_PC = b0_pc;
	assign oINFO_DESTINATION_REGNAME = b0_destination_regname;
	assign oINFO_COMMIT_TAG = b0_commit_tag;
	
endmodule


`default_nettype wire

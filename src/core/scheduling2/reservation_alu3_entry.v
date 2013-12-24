`include "core.h"
`default_nettype none


module reservation_alu3_entry(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Entry Remove
		input wire iREMOVE_VALID,
		//Regist
		input wire iREGIST_VALID,
		input wire [4:0] iREGIST_CMD,	
		input wire iREGIST_SYS_LDST,		
		input wire iREGIST_LDST,			
		input wire iREGIST_SOURCE0_VALID,
		input wire iREGIST_SOURCE0_SYSREG,		
		input wire [31:0] iREGIST_SOURCE0,
		input wire iREGIST_SOURCE1_VALID,
		input wire iREGIST_SOURCE1_SYSREG,		
		input wire [31:0] iREGIST_SOURCE1,
		input wire [5:0] iREGIST_DESTINATION_REGNAME,
		input wire iREGIST_DESTINATION_SYSREG,		//NEW 2012/02/7
		input wire [5:0] iREGIST_COMMIT_TAG,			
		input wire [31:0] iREGIST_PC,					
		input wire [3:0] iREGIST_EX_REGIST_POINTER,		
		//Common Data Bus CDB(CH0, ADDER)
		input wire iADDER_VALID,
		input wire [5:0] iADDER_DESTINATION_REGNAME,
		input wire iADDER_WRITEBACK,
		input wire [31:0] iADDER_DATA,
		//Common Data Bus CDB(CH1, MULDIV)
		input wire iMULDIV_VALID,
		input wire [5:0] iMULDIV_DESTINATION_REGNAME,
		input wire iMULDIV_WRITEBACK,	
		input wire [31:0] iMULDIV_DATA,
		//Common Data Bus CDB(CH1, LDST)
		input wire iLDST_VALID,
		input wire [5:0] iLDST_DESTINATION_REGNAME,
		input wire [31:0] iLDST_DATA,
		//Ex Execution Pointer
		input wire [3:0] iEX_EXECUTION_POINTER,
		//Request Execution
		input wire iEXOUT_VALID,
		//Info
		output wire oINFO_ENTRY_VALID,
		output wire oINFO_MATCHING,
		output wire [4:0] oINFO_CMD,		
		output wire oINFO_SYS_LDST,			
		output wire oINFO_LDST,				
		output wire oINFO_SOURCE0_VALID,
		output wire oINFO_SOURCE0_SYSREG,		
		output wire [31:0] oINFO_SOURCE0,
		output wire oINFO_SOURCE1_VALID,
		output wire oINFO_SOURCE1_SYSREG,	
		output wire [31:0] oINFO_SOURCE1,
		output wire [5:0] oINFO_DESTINATION_REGNAME,
		output wire oINFO_DESTINATION_SYSREG,		//NEW 2012/02/7
		output wire [5:0] oINFO_COMMIT_TAG,
		output wire [31:0] oINFO_PC
	);			
				
					
	reg b0_state;
	reg [4:0] b0_cmd;
	reg b0_sys_ldst;
	reg b0_ldst;
	reg b0_source0_valid;
	reg b0_source0_sysreg;
	reg [31:0] b0_source0;
	reg b0_source1_valid;
	reg b0_source1_sysreg;
	reg [31:0] b0_source1;
	reg [5:0] b0_destination_regname;
	reg b0_destination_sysreg;
	reg [5:0] b0_commit_tag;
	reg [31:0] b0_pc;
	reg b0_ex_pointer_matching;
	reg [3:0] b0_ex_pointer;	//iREGIST_EX_REGIST_POINTER
	
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_state <= 1'h0;
			b0_cmd <= {5{1'b0}};
			b0_sys_ldst <= 1'b0;
			b0_ldst <= 1'b0;
			b0_source0_valid <= 1'b0;
			b0_source0_sysreg <= 1'b0;			
			b0_source0 <= {31{1'b0}};
			b0_source1_valid <= 1'b0;
			b0_source1 <= {31{1'b0}};
			b0_source1_sysreg <= 1'b0;	
			b0_destination_regname <= {6{1'b0}};
			b0_destination_sysreg <= 1'b0;
			b0_commit_tag <= {6{1'b0}};
			b0_pc <= {32{1'b0}};
			b0_ex_pointer_matching <= 1'b0;
			b0_ex_pointer <= {4{1'b0}};
		end
		else if(iREMOVE_VALID | iEXOUT_VALID)begin
			b0_state <= 1'h0;
			b0_cmd <= {5{1'b0}};
			b0_sys_ldst <= 1'b0;
			b0_ldst <= 1'b0;
			b0_source0_valid <= 1'b0;
			b0_source0_sysreg <= 1'b0;			
			b0_source0 <= {31{1'b0}};
			b0_source1_valid <= 1'b0;
			b0_source1 <= {31{1'b0}};
			b0_source1_sysreg <= 1'b0;	
			b0_destination_regname <= {6{1'b0}};
			b0_destination_sysreg <= 1'b0;
			b0_commit_tag <= {6{1'b0}};
			b0_pc <= {32{1'b0}};
			b0_ex_pointer_matching <= 1'b0;
			b0_ex_pointer <= {4{1'b0}};
		end
		else begin
			case(b0_state)
				1'h0:			//Entry Regist Wait
					begin
						if(iREGIST_VALID)begin
							b0_state <= 1'h1;
							b0_cmd <= iREGIST_CMD;
							b0_sys_ldst <= iREGIST_SYS_LDST;
							b0_ldst <= iREGIST_LDST;
							//Source 0
							if(iREGIST_SOURCE0_SYSREG)begin
								//Sysreg
								b0_source0_valid <= 1'b1;
								b0_source0 <= iREGIST_SOURCE0;
							end
							else begin
								if(iREGIST_SOURCE0_VALID)begin
									b0_source0_valid <= 1'b1;
									b0_source0 <= iREGIST_SOURCE0;
								end
								else if(iREGIST_SOURCE0[5:0] == iADDER_DESTINATION_REGNAME && iADDER_WRITEBACK && iADDER_VALID)begin
									b0_source0_valid <= 1'b1;
									b0_source0 <= iADDER_DATA;
								end
								else if(iREGIST_SOURCE0[5:0] == iMULDIV_DESTINATION_REGNAME && iMULDIV_WRITEBACK && iMULDIV_VALID)begin
									b0_source0_valid <= 1'b1;
									b0_source0 <= iMULDIV_DATA;
								end
								else if(iREGIST_SOURCE0[5:0] == iLDST_DESTINATION_REGNAME && iLDST_VALID)begin
									b0_source0_valid <= 1'b1;
									b0_source0 <= iLDST_DATA;
								end
								else begin
									b0_source0_valid <= 1'b0;
									b0_source0 <= iREGIST_SOURCE0;	
								end
							end
							//Source 1
							if(iREGIST_SOURCE1_SYSREG)begin
								//Sysreg
								b0_source1_valid <= 1'b1;
								b0_source1 <= iREGIST_SOURCE1;
							end
							else begin
								if(iREGIST_SOURCE1_VALID)begin
									b0_source1_valid <= 1'b1;
									b0_source1 <= iREGIST_SOURCE1;
								end
								else if(iREGIST_SOURCE1[5:0] == iADDER_DESTINATION_REGNAME && iADDER_WRITEBACK && iADDER_VALID)begin
									b0_source1_valid <= 1'b1;
									b0_source1 <= iADDER_DATA;
								end
								else if(iREGIST_SOURCE1[5:0] == iMULDIV_DESTINATION_REGNAME && iMULDIV_WRITEBACK && iMULDIV_VALID)begin
									b0_source1_valid <= 1'b1;
									b0_source1 <= iMULDIV_DATA;
								end
								else if(iREGIST_SOURCE1[5:0] == iLDST_DESTINATION_REGNAME && iLDST_VALID)begin
									b0_source1_valid <= 1'b1;
									b0_source1 <= iLDST_DATA;
								end
								else begin
									b0_source1_valid <= 1'b0;
									b0_source1 <= iREGIST_SOURCE1;	
								end
							end
							b0_source0_sysreg <= iREGIST_SOURCE0_SYSREG;
							b0_source1_sysreg <= iREGIST_SOURCE1_SYSREG;
							b0_destination_regname <= iREGIST_DESTINATION_REGNAME;
							b0_destination_sysreg <= iREGIST_DESTINATION_SYSREG;
							b0_commit_tag <= iREGIST_COMMIT_TAG;
							b0_pc <= iREGIST_PC;
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
				1'h1:			//Entry Matching Wait
					begin
						//Source 0
						if(!b0_source0_valid)begin
							if(b0_source0[5:0] == iADDER_DESTINATION_REGNAME && iADDER_WRITEBACK && iADDER_VALID)begin
								b0_source0_valid <= 1'b1;
								b0_source0 <= iADDER_DATA;
							end
							else if(b0_source0[5:0] == iMULDIV_DESTINATION_REGNAME && iMULDIV_WRITEBACK && iMULDIV_VALID)begin
								b0_source0_valid <= 1'b1;
								b0_source0 <= iMULDIV_DATA;
							end
							else if(b0_source0[5:0] == iLDST_DESTINATION_REGNAME && iLDST_VALID)begin
								b0_source0_valid <= 1'b1;
								b0_source0 <= iLDST_DATA;
							end
							else begin
								b0_source0_valid <= 1'b0;
								b0_source0 <= b0_source0;	
							end
						end
						//Source 1
						if(!b0_source1_valid)begin
							if(b0_source1[5:0] == iADDER_DESTINATION_REGNAME && iADDER_WRITEBACK && iADDER_VALID)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iADDER_DATA;
							end
							else if(b0_source1[5:0] == iMULDIV_DESTINATION_REGNAME && iMULDIV_WRITEBACK && iMULDIV_VALID)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iMULDIV_DATA;
							end
							else if(b0_source1[5:0] == iLDST_DESTINATION_REGNAME && iLDST_VALID)begin
								b0_source1_valid <= 1'b1;
								b0_source1 <= iLDST_DATA;
							end
							else begin
								b0_source1_valid <= 1'b0;
								b0_source1 <= b0_source1;	
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
	assign oINFO_ENTRY_VALID = b0_state;
	assign oINFO_MATCHING = b0_state & b0_source0_valid & b0_source1_valid & b0_ex_pointer_matching;
	assign oINFO_CMD = b0_cmd;
	assign oINFO_SYS_LDST = b0_sys_ldst;
	assign oINFO_LDST = b0_ldst;
	assign oINFO_SOURCE0_VALID = b0_source0_valid;
	assign oINFO_SOURCE0_SYSREG = b0_source0_sysreg;
	assign oINFO_SOURCE0 = b0_source0;
	assign oINFO_SOURCE1_VALID = b0_source1_valid;
	assign oINFO_SOURCE1_SYSREG = b0_source1_sysreg;
	assign oINFO_SOURCE1 = b0_source1;
	assign oINFO_DESTINATION_REGNAME = b0_destination_regname;
	assign oINFO_DESTINATION_SYSREG = b0_destination_sysreg;
	assign oINFO_COMMIT_TAG = b0_commit_tag;
	assign oINFO_PC = b0_pc;
	
endmodule


`default_nettype wire


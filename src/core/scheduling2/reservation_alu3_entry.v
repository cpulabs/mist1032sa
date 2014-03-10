`include "core.h"
`default_nettype none


module reservation_alu3_entry(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Entry Remove
		input wire iREMOVE_VALID,
		//Regist
		input wire iREGISTER_VALID,
		input wire [4:0] iREGISTER_CMD,	
		input wire iREGISTER_SYS_LDST,		
		input wire iREGISTER_LDST,			
		input wire iREGISTER_SOURCE0_VALID,
		input wire iREGISTER_SOURCE0_SYSREG,		
		input wire [31:0] iREGISTER_SOURCE0,
		input wire iREGISTER_SOURCE1_VALID,
		input wire iREGISTER_SOURCE1_SYSREG,		
		input wire [31:0] iREGISTER_SOURCE1,
		input wire iREGISTER_ADV_ACTIVE,
		input wire [5:0] iREGISTER_ADV_DATA,
		input wire [5:0] iREGISTER_DESTINATION_REGNAME,
		input wire iREGISTER_DESTINATION_SYSREG,
		input wire [5:0] iREGISTER_COMMIT_TAG,			
		input wire [31:0] iREGISTER_PC,					
		input wire [3:0] iREGISTER_EX_REGIST_POINTER,		
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
		output wire oINFO_ADV_ACTIVE,
		output wire [5:0] oINFO_ADV_DATA,
		output wire [5:0] oINFO_DESTINATION_REGNAME,
		output wire oINFO_DESTINATION_SYSREG,
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
	reg b0_adv_active;
	reg [5:0] b0_adv_data;
	reg [5:0] b0_destination_regname;
	reg b0_destination_sysreg;
	reg [5:0] b0_commit_tag;
	reg [31:0] b0_pc;
	reg b0_ex_pointer_matching;
	reg [3:0] b0_ex_pointer;	//iREGISTER_EX_REGIST_POINTER
	
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b0_state <= 1'h0;
			b0_cmd <= {5{1'b0}};
			b0_sys_ldst <= 1'b0;
			b0_ldst <= 1'b0;
			b0_source0_valid <= 1'b0;
			b0_source0_sysreg <= 1'b0;			
			b0_source0 <= {32{1'b0}};
			b0_source1_valid <= 1'b0;
			b0_source1 <= {32{1'b0}};
			b0_adv_active <= 1'b0;
			b0_adv_data <= 6'h0;
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
			b0_source0 <= {32{1'b0}};
			b0_source1_valid <= 1'b0;
			b0_source1 <= {32{1'b0}};
			b0_adv_active <= 1'b0;
			b0_adv_data <= 6'h0;
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
						if(iREGISTER_VALID)begin
							b0_state <= 1'h1;
							b0_cmd <= iREGISTER_CMD;
							b0_sys_ldst <= iREGISTER_SYS_LDST;
							b0_ldst <= iREGISTER_LDST;
							b0_adv_active <= iREGISTER_ADV_ACTIVE;
							b0_adv_data <= iREGISTER_ADV_DATA;
							//Source 0
							if(iREGISTER_SOURCE0_SYSREG)begin
								//Sysreg
								b0_source0_valid <= 1'b1;
								b0_source0 <= iREGISTER_SOURCE0;
							end
							else begin
								if(iREGISTER_SOURCE0_VALID)begin
									b0_source0_valid <= 1'b1;
									b0_source0 <= iREGISTER_SOURCE0;
								end
								else if(iREGISTER_SOURCE0[5:0] == iADDER_DESTINATION_REGNAME && iADDER_WRITEBACK && iADDER_VALID)begin
									b0_source0_valid <= 1'b1;
									b0_source0 <= iADDER_DATA;
								end
								else if(iREGISTER_SOURCE0[5:0] == iMULDIV_DESTINATION_REGNAME && iMULDIV_WRITEBACK && iMULDIV_VALID)begin
									b0_source0_valid <= 1'b1;
									b0_source0 <= iMULDIV_DATA;
								end
								else if(iREGISTER_SOURCE0[5:0] == iLDST_DESTINATION_REGNAME && iLDST_VALID)begin
									b0_source0_valid <= 1'b1;
									b0_source0 <= iLDST_DATA;
								end
								else begin
									b0_source0_valid <= 1'b0;
									b0_source0 <= iREGISTER_SOURCE0;	
								end
							end
							//Source 1
							if(iREGISTER_SOURCE1_SYSREG)begin
								//Sysreg
								b0_source1_valid <= 1'b1;
								b0_source1 <= iREGISTER_SOURCE1;
							end
							else begin
								if(iREGISTER_SOURCE1_VALID)begin
									b0_source1_valid <= 1'b1;
									b0_source1 <= iREGISTER_SOURCE1;
								end
								else if(iREGISTER_SOURCE1[5:0] == iADDER_DESTINATION_REGNAME && iADDER_WRITEBACK && iADDER_VALID)begin
									b0_source1_valid <= 1'b1;
									b0_source1 <= iADDER_DATA;
								end
								else if(iREGISTER_SOURCE1[5:0] == iMULDIV_DESTINATION_REGNAME && iMULDIV_WRITEBACK && iMULDIV_VALID)begin
									b0_source1_valid <= 1'b1;
									b0_source1 <= iMULDIV_DATA;
								end
								else if(iREGISTER_SOURCE1[5:0] == iLDST_DESTINATION_REGNAME && iLDST_VALID)begin
									b0_source1_valid <= 1'b1;
									b0_source1 <= iLDST_DATA;
								end
								else begin
									b0_source1_valid <= 1'b0;
									b0_source1 <= iREGISTER_SOURCE1;	
								end
							end
							b0_source0_sysreg <= iREGISTER_SOURCE0_SYSREG;
							b0_source1_sysreg <= iREGISTER_SOURCE1_SYSREG;
							b0_destination_regname <= iREGISTER_DESTINATION_REGNAME;
							b0_destination_sysreg <= iREGISTER_DESTINATION_SYSREG;
							b0_commit_tag <= iREGISTER_COMMIT_TAG;
							b0_pc <= iREGISTER_PC;
							//Ex Inorder Pointer
							if(iREGISTER_EX_REGIST_POINTER == iEX_EXECUTION_POINTER)begin		
								b0_ex_pointer_matching <= 1'b1;
								b0_ex_pointer <= {4{1'b0}};
							end
							else begin
								b0_ex_pointer_matching <= 1'b0;
								b0_ex_pointer <= iREGISTER_EX_REGIST_POINTER;
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
	assign oINFO_ADV_ACTIVE = b0_adv_active;
	assign oINFO_ADV_DATA = b0_adv_data;
	assign oINFO_DESTINATION_REGNAME = b0_destination_regname;
	assign oINFO_DESTINATION_SYSREG = b0_destination_sysreg;
	assign oINFO_COMMIT_TAG = b0_commit_tag;
	assign oINFO_PC = b0_pc;
	
endmodule


`default_nettype wire


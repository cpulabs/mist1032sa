

`default_nettype none

module regist_rbuffer_select(
				input					iORDER_LOCK,
				input					iORDER_0_VALID,
				input					iORDER_0_EX_SYS_REG,	
				input					iORDER_0_EX_SYS_LDST,		
				input					iORDER_0_EX_LOGIC,
				input					iORDER_0_EX_SHIFT,
				input					iORDER_0_EX_ADDER,
				input					iORDER_0_EX_MUL,
				input					iORDER_0_EX_SDIV,
				input					iORDER_0_EX_UDIV,
				input					iORDER_0_EX_LDST,
				input					iORDER_0_EX_BRANCH,
				input					iORDER_1_VALID,
				input					iORDER_1_EX_SYS_REG,	
				input					iORDER_1_EX_SYS_LDST,		
				input					iORDER_1_EX_LOGIC,
				input					iORDER_1_EX_SHIFT,
				input					iORDER_1_EX_ADDER,
				input					iORDER_1_EX_MUL,
				input					iORDER_1_EX_SDIV,
				input					iORDER_1_EX_UDIV,
				input					iORDER_1_EX_LDST,
				input					iORDER_1_EX_BRANCH,
				//RS-INFO
				input		[3:0]		iRS1_COUNT,
				input		[3:0]		iRS2_COUNT,
				//Output
				output					oRS0_0_VALID,
				output					oRS1_0_VALID,
				output					oRS2_0_VALID,
				output					oRS3_0_VALID,
				output					oRS0_1_VALID,
				output					oRS1_1_VALID,
				output					oRS2_1_VALID,
				output					oRS3_1_VALID
				);

	//RS0
	assign		oRS0_0_VALID		=			!iORDER_LOCK && iORDER_0_VALID && iORDER_0_EX_BRANCH;
	assign		oRS0_1_VALID		=			!iORDER_LOCK && iORDER_1_VALID && iORDER_1_EX_BRANCH;	

	//RS1										
	assign		oRS1_0_VALID		=			!iORDER_LOCK && iORDER_0_VALID && (iORDER_0_EX_MUL || iORDER_0_EX_SDIV || iORDER_0_EX_UDIV || ((iRS1_COUNT < iRS2_COUNT)? iORDER_0_EX_LOGIC || iORDER_0_EX_SHIFT || iORDER_0_EX_ADDER || iORDER_0_EX_SYS_REG : 1'b0));
	assign		oRS1_1_VALID		=			!iORDER_LOCK && iORDER_1_VALID && (iORDER_1_EX_MUL || iORDER_1_EX_SDIV || iORDER_1_EX_UDIV || ((iRS1_COUNT < iRS2_COUNT)? iORDER_1_EX_LOGIC || iORDER_1_EX_SHIFT || iORDER_1_EX_ADDER || iORDER_1_EX_SYS_REG : 1'b0));								
	
	//RS2										
	assign		oRS2_0_VALID		=			!iORDER_LOCK && iORDER_0_VALID && ((iRS1_COUNT < iRS2_COUNT)? 1'b0 : iORDER_0_EX_LOGIC || iORDER_0_EX_SHIFT || iORDER_0_EX_ADDER || iORDER_0_EX_SYS_REG);
	assign		oRS2_1_VALID		=			!iORDER_LOCK && iORDER_1_VALID && ((iRS1_COUNT < iRS2_COUNT)? 1'b0 : iORDER_1_EX_LOGIC || iORDER_1_EX_SHIFT || iORDER_1_EX_ADDER || iORDER_1_EX_SYS_REG);								
			
	
	//RS3
	assign		oRS3_0_VALID		=			!iORDER_LOCK && iORDER_0_VALID && (iORDER_0_EX_LDST || iORDER_0_EX_SYS_LDST);
	assign		oRS3_1_VALID		=			!iORDER_LOCK && iORDER_1_VALID && (iORDER_1_EX_LDST || iORDER_1_EX_SYS_LDST);
	

	
endmodule



`default_nettype wire


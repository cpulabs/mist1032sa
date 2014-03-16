`default_nettype none
`include "core.h"

module decode_function(
		//Input
		input wire [31:0] iINSTLUCTION,
		//Info
		output wire oINF_ERROR,
		//
		output wire oDECODE_SOURCE0_ACTIVE,			
		output wire oDECODE_SOURCE1_ACTIVE,		
		output wire oDECODE_SOURCE0_SYSREG,		
		output wire oDECODE_SOURCE1_SYSREG,		
		output wire oDECODE_SOURCE0_SYSREG_RENAME,	
		output wire oDECODE_SOURCE1_SYSREG_RENAME,
		output wire oDECODE_ADV_ACTIVE,	
		output wire oDECODE_DESTINATION_SYSREG,	
		output wire oDECODE_DEST_RENAME,	
		output wire oDECODE_WRITEBACK,
		output wire oDECODE_FLAGS_WRITEBACK,
		output wire oDECODE_FRONT_COMMIT_WAIT,				
		output wire [4:0] oDECODE_CMD,
		output wire [3:0] oDECODE_CC_AFE,
		output wire [4:0] oDECODE_SOURCE0,
		output wire [31:0] oDECODE_SOURCE1,
		output wire [5:0] oDECODE_ADV_DATA,
		output wire oDECODE_SOURCE0_FLAGS,
		output wire oDECODE_SOURCE1_IMM,
		output wire [4:0] oDECODE_DESTINATION,
		output wire oDECODE_EX_SYS_REG,	
		output wire oDECODE_EX_SYS_LDST,	
		output wire oDECODE_EX_LOGIC,
		output wire oDECODE_EX_SHIFT,
		output wire oDECODE_EX_ADDER,
		output wire oDECODE_EX_MUL,			
		output wire oDECODE_EX_SDIV,		
		output wire oDECODE_EX_UDIV,		
		output wire oDECODE_EX_LDST,
		output wire oDECODE_EX_BRANCH
	);


	function [81:0]	f_decode;
		input [31:0] f_decode_inst;
		begin
			case(f_decode_inst[30 : 21])
				/*******************
				Integer
				*******************/
				`OC_ADD :
					begin	
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,//++
								/* Displacement Data -> ADV Enable */	1'b0,//++
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_ADD,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_ADD,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
				`OC_SUB :
					begin	
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_SUB,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_SUB,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
				`OC_MULL : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_MUL_MULL,
								/* Execute Module */					`EXE_SELECT_MUL
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_MUL_MULL,
								/* Execute Module */					`EXE_SELECT_MUL
							};
						end
					end
				`OC_MULH : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_MUL_MULH,
								/* Execute Module */					`EXE_SELECT_MUL
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_MUL_MULH,
								/* Execute Module */					`EXE_SELECT_MUL
							};
						end
					end
				`OC_UDIV : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_DIV_UDIV,
								/* Execute Module */					`EXE_SELECT_UDIV
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_DIV_UDIV,
								/* Execute Module */					`EXE_SELECT_UDIV
							};
						end
					end
				`OC_UMOD :
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_DIV_UMOD,
								/* Execute Module */					`EXE_SELECT_UDIV
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_DIV_UMOD,
								/* Execute Module */					`EXE_SELECT_UDIV
							};
						end
					end
				`OC_CMP : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_ADDER_SUB,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_ADDER_SUB,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
				`OC_DIV : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_DIV_DIV,
								/* Execute Module */					`EXE_SELECT_SDIV
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_DIV_DIV,
								/* Execute Module */					`EXE_SELECT_SDIV
							};
						end
					end
				`OC_MOD :
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_DIV_MOD,
								/* Execute Module */					`EXE_SELECT_SDIV
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_DIV_MOD,
								/* Execute Module */					`EXE_SELECT_SDIV
							};
						end
					end
				`OC_NEG :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[4:0],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_NEG,
							/* Execute Module */					`EXE_SELECT_ADDER
							};
					end


				`OC_UMULL : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_MUL_UMULL,
								/* Execute Module */					`EXE_SELECT_MUL
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_MUL_UMULL,
								/* Execute Module */					`EXE_SELECT_MUL
							};
						end
					end

				`OC_UMULH : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_MUL_UMULH,
								/* Execute Module */					`EXE_SELECT_MUL
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_MUL_UMULH,
								/* Execute Module */					`EXE_SELECT_MUL
							};
						end
					end


					
				`OC_IC :
					begin
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[4:0],
							/* Source1 */							32'h1,
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_COUT,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				`OC_ADDC :
					begin	
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_COUT,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_COUT,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
				`OC_INC	:
					begin
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[4:0],
							/* Source1 */							32'h1,
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_ADD,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				`OC_DEC	:
					begin
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[4:0],
							/* Source1 */							32'h1,
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_SUB,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				`OC_MAX :
					begin	
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_MAX,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_MAX,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
				`OC_MIN :
					begin	
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_MIN,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_MIN,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
				`OC_UMAX :
					begin	
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_UMAX,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_UMAX,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
				`OC_UMIN :
					begin	
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_UMIN,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_UMIN,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
					
					
				`OC_SEXT8 :
					begin		//O2	
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_SEXT8,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				`OC_SEXT16 :
					begin		//O2	
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_SEXT16,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				/*******************
				Floating
				*******************/
				/*******************
				Shift
				*******************/
				`OC_SHL : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_LOGICL,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_LOGICL,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
					end
				`OC_SHR : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_LOGICR,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_LOGICR,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
					end
				`OC_SAR : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_ALITHMETICR,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_ALITHMETICR,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
					end
				`OC_ROL : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_ROTATEL,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_ROTATEL,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
					end
				`OC_ROR : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_ROTATER,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b1,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_SHIFT_ROTATER,
								/* Execute Module */					`EXE_SELECT_SHIFT
							};
						end
					end
				/*******************
				Logic
				*******************/
				`OC_AND :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_AND,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_OR :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_OR,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_XOR :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_XOR,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_NOT :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[4:0],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_NOT,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_NAND :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_NAND,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_NOR :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_NOR,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_XNOR :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_XNOR,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end	
				`OC_TEST :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LOGIC_TEST,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end	
				`OC_WL16 :
					begin									//I16
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{16{1'b0}}, f_decode_inst[20:10], f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_WBL,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_WH16 :
					begin									//I16
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{16{1'b0}}, f_decode_inst[20:10], f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_WBH,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_CLRB :
					begin									//I11
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_CLB,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_SETB :
					begin									//I11
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_STB,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_CLR :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_CLW,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end	
				`OC_SET :				//okasi
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b1}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_STW,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_REVB :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[4:0],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_BITREV,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_REV8 :
					begin									//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[4:0],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_BYTEREV,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_GETB : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LOGIC_GETBIT,
								/* Execute Module */					`EXE_SELECT_LOGIC
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LOGIC_GETBIT,
								/* Execute Module */					`EXE_SELECT_LOGIC
							};
						end
					end
				`OC_GET8 : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LOGIC_GETBYTE,
								/* Execute Module */					`EXE_SELECT_LOGIC
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LOGIC_GETBYTE,
								/* Execute Module */					`EXE_SELECT_LOGIC
							};
						end
					end
				`OC_LIL	:	
					begin									//I16
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{16{1'b0}}, f_decode_inst[20:10], f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_LIL,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_LIH	:	
					begin									//I16
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{f_decode_inst[20:10], f_decode_inst[4:0], {16{1'b0}}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_LIH,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_ULIL	:	
					begin									//I16
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{16{1'b0}}, f_decode_inst[20:10], f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_ULIL,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				/*******************
				Load/Store
				*******************/
				`OC_LD8 : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},									//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LDSW_LD8,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},				//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LDSW_LD8,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
					end
				`OC_LD16 : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},									//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LDSW_LD16,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},
								/* Source1 */							{{20{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0], 1'b0},				//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LDSW_LD16,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
					end
				`OC_LD32 : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},									//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LDSW_LD32,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},
								/* Source1 */							{{19{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0], 2'b00},				//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_LDSW_LD32,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
					end
				`OC_ST8 : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],						//Rd
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},		//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						5'h00,		//Memory
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_LDSW_ST8,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],											//Rd
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},		//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						5'h00,		//Memory
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_LDSW_ST8,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
					end
				`OC_ST16 : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],						//Rd
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},		//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						5'h00,		//Memory
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_LDSW_ST16,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],											//Rd
								/* Source1 */							{{20{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0], 1'b0},		//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						5'h00,		//Memory
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_LDSW_ST16,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
					end
				`OC_ST32 : 
					begin
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],						//Rd
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},		//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						5'h00,		//Memory
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_LDSW_ST32,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],											//Rd
								/* Source1 */							{{19{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0], 2'b00},		//Rs
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						5'h00,		//Memory
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_LDSW_ST32,
								/* Execute Module */					`EXE_SELECT_LDST
							};
						end
					end
				`OC_PUSH :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				`OC_PUSHPC :
					begin									//C
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PCR,								//PC
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PPUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				`OC_POP :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							5'h00,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				`OC_LDD8 : 
					begin			//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							{5{1'b0}},
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},									//Rs
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_LDD8,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				`OC_LDD16 : 
					begin			//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							{5{1'b0}},
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},									//Rs
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_LDD16,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				`OC_LDD32 : 
					begin			//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							{5{1'b0}},
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},									//Rs
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_LDD32,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				`OC_STD8 : 
					begin			//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],						//Rd
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},		//Rs
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_STD8,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				`OC_STD16 : 
					begin			//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],						//Rd
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},		//Rs
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_STD16,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				`OC_STD32 : 
					begin			//O2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],						//Rd
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},		//Rs
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_STD32,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				/*******************
				Branch
				*******************/
				`OC_BUR :
					begin	
						if(!f_decode_inst[20])begin			//JO1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],//	/* Source0 */							`SYSREG_PC,							//PC
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},	//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,		//Flag
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,//	/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_BUR,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
						else begin							//JI16
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],//	/* Source0 */							`SYSREG_PC,							//PC
								/* Source1 */							{{14{1'b0}}, f_decode_inst[15:0], 2'h0},	//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,		//Flag
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,//	/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_BUR,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
					end
				`OC_BR :
					begin	
						if(!f_decode_inst[20])begin			//JO1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],//	/* Source0 */							`SYSREG_PC,							//PC
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},	//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,		//Flag
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,//	/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_BR,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
						else begin							//JI16
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],//	/* Source0 */							`SYSREG_PC,							//PC
								/* Source1 */							{{14{f_decode_inst[15]}}, f_decode_inst[15:0], 2'h0}, //{{16{1'b0}}, f_decode_inst[15:0]},	//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,		//Flag
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,//	/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_BR,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
					end
				`OC_B :
					begin	
						if(!f_decode_inst[20])begin			//JO1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},								//none
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},		//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,//1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_B,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
						else begin							//JI16
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},								//none		
								/* Source1 */							{{14{1'b0}}, f_decode_inst[15:0], 2'b0},		//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,//1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_B,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
					end
				`OC_IB :
					begin	
						if(!f_decode_inst[20])begin			//JO1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},								//none
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},		//Rd
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_INTB,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
						else begin							//JI16
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},								//none		
								/* Source1 */							{{14{1'b0}}, f_decode_inst[15:0], 2'h0},		//Rd
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_INTB,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
					end
				`OC_BURN :
					begin	
						if(!f_decode_inst[20])begin			//JO1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],//	/* Source0 */							`SYSREG_PC,							//PC
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},	//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,		//Flag
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,//	/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_BUR,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
						else begin							//JI16
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],//	/* Source0 */							`SYSREG_PC,							//PC
								/* Source1 */							{{14{1'b0}}, f_decode_inst[15:0], 2'h0},	//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,		//Flag
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,//	/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_BUR,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
					end
				`OC_BRN :
					begin	
						if(!f_decode_inst[20])begin			//JO1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],//	/* Source0 */							`SYSREG_PC,							//PC
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},	//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,		//Flag
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,//	/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_BR,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
						else begin							//JI16
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							f_decode_inst[9:5],//	/* Source0 */							`SYSREG_PC,							//PC
								/* Source1 */							{{14{f_decode_inst[15]}}, f_decode_inst[15:0], 2'h0}, //{{16{1'b0}}, f_decode_inst[15:0]},	//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,		//Flag
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,//	/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_BR,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
					end
				`OC_BN :
					begin	
						if(!f_decode_inst[20])begin			//JO1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},								//none
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},		//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,//1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_B,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
						else begin							//JI16
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							{5{1'b0}},								//none		
								/* Source1 */							{{14{1'b0}}, f_decode_inst[15:0], 2'b0},		//Rd
								/* Source0 Use Flags*/					1'b1,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,//1'b0,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,//1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PCR,
								/* Write Back Enable */					1'b0,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_BRANCH_B,
								/* Execute Module */					`EXE_SELECT_BRANCH
							};
						end
					end
				/*******************
				System Read
				*******************/			
				`OC_SRSPR :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_SPR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_LDST_READ_SPR,
							/* Execute Module */					`EXE_SELECT_SYS_LDST
						};
					end
				`OC_SRPDTR :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PDTR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end				
				`OC_SRPIDR :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_CPUIDR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRCIDR : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_COREIDR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_MODER : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PSR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_SR1_CMOD_R,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRIEIR : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PSR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_SR1_IM_R,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRTISR : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_TISR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRKPDTR : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_KPDTR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRMMUR : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PSR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_SR1_MMUMOD_R,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRIOSR : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_IOSR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRTIDR : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_TIDR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPPSR: 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PPSR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPPCR: 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PPCR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPPDTR: 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PPDTR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPTIDR: 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PTIDR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPSR: 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PSR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRFRCR: 
					begin									//C
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							5'h0,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_FRCR2FRCXR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRFRCLR: 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_FRCLR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRFRCHR: 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_FRCHR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPFLAGR: 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_PFLAGR,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
					
				/*******************
				System Write
				*******************/
				`OC_SRSPW :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_SPR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_LDST_WRITE_SPR,
							/* Execute Module */					`EXE_SELECT_SYS_LDST
						};
					end
				`OC_SRPDTW : 
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_PDTR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_LDST
						};
					end
				`OC_SRIEIW : 
					begin
						if(!f_decode_inst[20])begin			//O1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b1,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							`SYSREG_PSR,
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PSR,
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_SYS_REG_SR1_IM_W,
								/* Execute Module */					`EXE_SELECT_SYS_REG
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b1,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							`SYSREG_PSR,
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PSR,
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_SYS_REG_SR1_IM_W,
								/* Execute Module */					`EXE_SELECT_SYS_REG
							};
						end
					end
				`OC_SRTISW :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_TISR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRKPDTW :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_KPDTR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRMMUW : 
					begin
						if(!f_decode_inst[20])begin			//O1
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b1,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							`SYSREG_PSR,
								/* Source1 */							{{27{1'b0}}, f_decode_inst[9:5]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PSR,
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_SYS_REG_SR1_MMUMOD_W,
								/* Execute Module */					`EXE_SELECT_SYS_REG
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b1,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							`SYSREG_PSR,
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						`SYSREG_PSR,
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b1,
								/* Destination Rename*/					1'b0,
								/* Execute Module Command */			`EXE_SYS_REG_SR1_MMUMOD_W,
								/* Execute Module */					`EXE_SELECT_SYS_REG
							};
						end
					end
				`OC_SRPPSW :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_PPSR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPPCW :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_PPCR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPPDTW :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_PPDTR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPTIDW :
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_PTIDR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRIDTW:
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_IDTR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRPSW:
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_PSR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRFRCW:
					begin									//C
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							5'h0,
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_FRCR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRFRCLR:
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_FRCLR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRFRCHR:
					begin									//O1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_FRCHR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				`OC_SRSPWADD : 
					begin						//CI16
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							`SYSREG_SPR,
							/* Source1 */							{{14{f_decode_inst[15]}}, f_decode_inst[15:0], 2'h0},//{{16{1'b0}}, f_decode_inst[15:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_SPR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_LDST_ADD_SPR,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end

				/*******************
				Other
				*******************/
				`OC_NOP :
					begin									//C
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						{5{1'b0}},
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_ADDER_ADD,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				`OC_HALT :
					begin									//C
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						{5{1'b0}},
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_BRANCH_HALT,
							/* Execute Module */					`EXE_SELECT_BRANCH
						};	
					end
				`OC_MOVE : 
					begin
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_BUFFER1,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				`OC_MOVEPC	:	
					begin	
						if(!f_decode_inst[20])begin			//O2
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							`SYSREG_PCR,
								/* Source1 */							{{27{1'b0}}, f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b0,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_ADD,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
						else begin							//I11
							f_decode	=	{
								/* Decode Error */						1'b0,
								/* Commit Wait Instruction */			1'b0,
								/* Condition Code & AFE */				f_decode_inst[19:16],
								/* Source0 */							`SYSREG_PCR,
								/* Source1 */							{{19{f_decode_inst[15]}}, f_decode_inst[15:10], f_decode_inst[4:0], 2'b0},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b1,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
								/* Displacement Data -> ADV */			6'h0,
								/* Displacement Data -> ADV Enable */	1'b0,
								/* Destination */						f_decode_inst[9:5],
								/* Write Back Enable */					1'b1,
								/* Make Flag Instruction */				1'b0,
								/* Destination is System Register */	1'b0,
								/* Destination Rename*/					1'b1,
								/* Execute Module Command */			`EXE_ADDER_ADD,
								/* Execute Module */					`EXE_SELECT_ADDER
							};
						end
					end
				/*******************
				OS Support
				*******************/
				`OC_SWI	:	
					begin					//I11
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							{5{1'b0}},								//none		
							/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						`SYSREG_PCR,
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_BRANCH_SWI,
							/* Execute Module */					`EXE_SELECT_BRANCH
						};
					end
				`OC_IDTS :
					begin									//C
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				f_decode_inst[19:16],
							/* Source0 */							f_decode_inst[9:5],
							/* Source1 */							{32{1'b0}},
							/* Source0 Use Flags*/					1'b0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Displacement Data -> ADV */			6'h0,
							/* Displacement Data -> ADV Enable */	1'b0,
							/* Destination */						{5{1'b0}},
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_BRANCH_IDTS,
							/* Execute Module */					`EXE_SELECT_BRANCH
						};
					end	
				//Error
				default :
					begin
						f_decode				=		{1'b1, {81{1'b0}}};
						/*
						$display("Instruction Error : Decoder > Not Match Instruction(TIME:%t, Line0 Valid0:%d, Line1 Valid:%d)", $stime, iPREVIOUS_0_INST_VALID, iPREVIOUS_1_INST_VALID);
						*/
					end
			endcase
		end
	endfunction
	


	assign {
		oINF_ERROR,
		oDECODE_FRONT_COMMIT_WAIT,
		oDECODE_CC_AFE,
		oDECODE_SOURCE0,
		oDECODE_SOURCE1,
		oDECODE_SOURCE0_FLAGS,
		oDECODE_SOURCE1_IMM,
		oDECODE_SOURCE0_ACTIVE,			
		oDECODE_SOURCE1_ACTIVE,		
		oDECODE_SOURCE0_SYSREG,		
		oDECODE_SOURCE1_SYSREG,		
		oDECODE_SOURCE0_SYSREG_RENAME,	
		oDECODE_SOURCE1_SYSREG_RENAME,
		oDECODE_ADV_DATA,
		oDECODE_ADV_ACTIVE,	
		oDECODE_DESTINATION,
		oDECODE_WRITEBACK,
		oDECODE_FLAGS_WRITEBACK,
		oDECODE_DESTINATION_SYSREG,	
		oDECODE_DEST_RENAME,		
		oDECODE_CMD,
		oDECODE_EX_SYS_REG,	
		oDECODE_EX_SYS_LDST,	
		oDECODE_EX_LOGIC,
		oDECODE_EX_SHIFT,
		oDECODE_EX_ADDER,		
		oDECODE_EX_SDIV,		
		oDECODE_EX_UDIV,
		oDECODE_EX_MUL,			
		oDECODE_EX_LDST,
		oDECODE_EX_BRANCH
	} = f_decode(iINSTLUCTION);



endmodule

`default_nettype wire 

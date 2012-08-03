/****************************************
	Decode Unit
	- 2 instruction multi decode
	- Source ga 1tu notoki Source0 wo yuusenn 
	- oNEXT_0_SOURCE_SYSREG notoki ha Source 1wo yuusenn
	
	
	
	Make	:	2011/01/20
	Update	:	2011/01/23
****************************************/
`include "core.h"
`default_nettype none			


module decoder(
				//System
				input					iCLOCK,
				input					inRESET,
				//Free
				input					iFREE_DEFAULT,	
				//Previous
				input					iPREVIOUS_0_INST_VALID,
				input	[5:0]			iPREVIOUS_0_MMU_FLAGS,
				input	[31:0]			iPREVIOUS_0_INST,
				input					iPREVIOUS_1_INST_VALID,
				input	[5:0]			iPREVIOUS_1_MMU_FLAGS,
				input	[31:0]			iPREVIOUS_1_INST,
				input	[31:0]			iPREVIOUS_PC,
				output					oPREVIOUS_LOCK,
				//Next-0		
				output					oNEXT_0_VALID,
				output	[5:0]			oNEXT_0_MMU_FLAGS,
				output					oNEXT_0_SOURCE0_ACTIVE,			
				output					oNEXT_0_SOURCE1_ACTIVE,		
				output					oNEXT_0_SOURCE0_SYSREG,		
				output					oNEXT_0_SOURCE1_SYSREG,		
				output					oNEXT_0_SOURCE0_SYSREG_RENAME,		//2012/01/26
				output					oNEXT_0_SOURCE1_SYSREG_RENAME,		//2012/01/26
				output					oNEXT_0_DESTINATION_SYSREG,	
				output					oNEXT_0_DEST_RENAME,		//2012/01/24
				output					oNEXT_0_WRITEBACK,
				output					oNEXT_0_FLAGS_WRITEBACK,
				output					oNEXT_0_FRONT_COMMIT_WAIT,				
				output	[4:0]			oNEXT_0_CMD,
				output	[3:0]			oNEXT_0_CC_AFE,
				output	[4:0]			oNEXT_0_SOURCE0,
				output	[31:0]			oNEXT_0_SOURCE1,
				output					oNEXT_0_SOURCE0_FLAGS,
				output					oNEXT_0_SOURCE1_IMM,
				output	[4:0]			oNEXT_0_DESTINATION,
				output					oNEXT_0_EX_SYS_REG,		//new
				output					oNEXT_0_EX_SYS_LDST,		//new
				output					oNEXT_0_EX_LOGIC,
				output					oNEXT_0_EX_SHIFT,
				output					oNEXT_0_EX_ADDER,
				output					oNEXT_0_EX_MUL,				//Change
				output					oNEXT_0_EX_SDIV,			//NEW
				output					oNEXT_0_EX_UDIV,			//NEW
				output					oNEXT_0_EX_LDST,
				output					oNEXT_0_EX_BRANCH,
				//Next-1				
				output					oNEXT_1_VALID,
				output	[5:0]			oNEXT_1_MMU_FLAGS,
				output					oNEXT_1_SOURCE0_ACTIVE,		
				output					oNEXT_1_SOURCE1_ACTIVE,		
				output					oNEXT_1_SOURCE0_SYSREG,		
				output					oNEXT_1_SOURCE1_SYSREG,		
				output					oNEXT_1_SOURCE0_SYSREG_RENAME,		//2012/01/26
				output					oNEXT_1_SOURCE1_SYSREG_RENAME,		//2012/01/26
				output					oNEXT_1_DESTINATION_SYSREG,
				output					oNEXT_1_DEST_RENAME,		//2012/01/24
				output					oNEXT_1_WRITEBACK,
				output					oNEXT_1_FLAGS_WRITEBACK,				
				output					oNEXT_1_FRONT_COMMIT_WAIT,					
				output	[4:0]			oNEXT_1_CMD,
				output	[3:0]			oNEXT_1_CC_AFE,
				output	[4:0]			oNEXT_1_SOURCE0,
				output	[31:0]			oNEXT_1_SOURCE1,
				output					oNEXT_1_SOURCE0_FLAGS,
				output					oNEXT_1_SOURCE1_IMM,
				output	[4:0]			oNEXT_1_DESTINATION,
				output					oNEXT_1_EX_SYS_REG,		//new
				output					oNEXT_1_EX_SYS_LDST,		//new
				output					oNEXT_1_EX_LOGIC,
				output					oNEXT_1_EX_SHIFT,
				output					oNEXT_1_EX_ADDER,
				output					oNEXT_1_EX_MUL,				//Change
				output					oNEXT_1_EX_SDIV,			//NEW
				output					oNEXT_1_EX_UDIV,			//NEW
				output					oNEXT_1_EX_LDST,
				output					oNEXT_1_EX_BRANCH,
				output	[31:0]			oNEXT_PC,
				input					iNEXT_LOCK);

	
	
	//Reg
	//Pipeline 0
	reg					b0_valid;		
	reg		[5:0]		b0_mmu_flags;
	reg					b0_destination_sysreg;	
	reg					b0_dest_rename;
	reg					b0_writeback;	
	reg					b0_flag_writeback;
	reg					b0_commit_wait_inst;					
	reg		[4:0]		b0_cmd;
	reg		[3:0]		b0_cc_afe;
	reg		[4:0]		b0_source0;
	reg		[31:0]		b0_source1;
	reg					b0_source0_flags;
	reg					b0_source1_imm;
	reg					b0_source0_active;	
	reg					b0_source1_active;	
	reg					b0_source0_sysreg;				
	reg					b0_source1_sysreg;	
	reg					b0_source0_sysreg_rename;
	reg					b0_source1_sysreg_rename;
	reg		[4:0]		b0_destination;	
	reg					b0_ex_sys_reg;
	reg					b0_ex_sys_ldst;
	reg					b0_ex_logic;
	reg					b0_ex_shift;
	reg					b0_ex_adder;
	reg					b0_ex_mul;
	reg					b0_ex_sdiv;
	reg					b0_ex_udiv;
	reg					b0_ex_ldst;
	reg					b0_ex_branch;
	reg					b0_error;
	//Pipeline 1
	reg					b1_valid;	
	reg		[5:0]		b1_mmu_flags;
	reg					b1_destination_sysreg;			
	reg					b1_dest_rename;			
	reg					b1_writeback;	
	reg					b1_flag_writeback;
	reg					b1_commit_wait_inst;					
	reg		[4:0]		b1_cmd;
	reg		[3:0]		b1_cc_afe;
	reg		[4:0]		b1_source0;
	reg		[31:0]		b1_source1;
	reg					b1_source0_flags;
	reg					b1_source1_imm;
	reg					b1_source0_active;	
	reg					b1_source1_active;	
	reg					b1_source0_sysreg;				
	reg					b1_source1_sysreg;	
	reg					b1_source0_sysreg_rename;
	reg					b1_source1_sysreg_rename;
	reg		[4:0]		b1_destination;	
	reg					b1_ex_sys_reg;
	reg					b1_ex_sys_ldst;
	reg					b1_ex_logic;
	reg					b1_ex_shift;
	reg					b1_ex_adder;
	reg					b1_ex_mul;
	reg					b1_ex_sdiv;
	reg					b1_ex_udiv;
	reg					b1_ex_ldst;
	reg					b1_ex_branch;
	reg					b1_error;
	reg		[31:0]		b_pc;
	
	
	always@(posedge iCLOCK, negedge inRESET)begin
		if(!inRESET)begin
			//Pipeline 0
			b0_valid					<=		1'b0;		
			b0_mmu_flags				<=		6'h0;
			b0_source0_active			<=		1'b0;			
			b0_source1_active			<=		1'b0;	
			b0_source0_sysreg			<=		1'b0;	
			b0_source1_sysreg			<=		1'b0;	
			b0_source0_sysreg_rename	<=		1'b0;	
			b0_source1_sysreg_rename	<=		1'b0;
			b0_destination_sysreg		<=		1'b0;			
			b0_dest_rename				<=		1'b0;			
			b0_writeback				<=		1'b0;	
			b0_flag_writeback			<=		1'b0;
			b0_commit_wait_inst			<=		1'b0;					
			b0_cmd						<=		{5{1'b0}};
			b0_cc_afe					<=		{4{1'b0}};
			b0_source0					<=		{5{1'b0}};
			b0_source1					<=		{32{1'b0}};
			b0_source0_flags			<=		1'b0;
			b0_source1_imm				<=		1'b0;
			b0_destination				<=		{5{1'b0}};	
			b0_ex_sys_reg				<=		1'b0;
			b0_ex_sys_ldst				<=		1'b0;
			b0_ex_logic					<=		1'b0;
			b0_ex_shift					<=		1'b0;
			b0_ex_adder					<=		1'b0;
			b0_ex_mul					<=		1'b0;
			b0_ex_sdiv					<=		1'b0;
			b0_ex_udiv					<=		1'b0;
			b0_ex_ldst					<=		1'b0;
			b0_ex_branch				<=		1'b0;
			b0_error					<=		1'b0;
			//Pipeline 1
			b1_valid					<=		1'b0;			
			b1_mmu_flags				<=		6'h0;		
			b1_source0_active			<=		1'b0;			
			b1_source1_active			<=		1'b0;	
			b1_source0_sysreg			<=		1'b0;	
			b1_source1_sysreg			<=		1'b0;		
			b1_source0_sysreg_rename	<=		1'b0;	
			b1_source1_sysreg_rename	<=		1'b0;				
			b1_destination_sysreg		<=		1'b0;	
			b1_dest_rename				<=		1'b0;
			b1_writeback				<=		1'b0;		
			b1_flag_writeback			<=		1'b0;			
			b1_commit_wait_inst			<=		1'b0;					
			b1_cmd						<=		{5{1'b0}};
			b1_cc_afe					<=		{4{1'b0}};
			b1_source0					<=		{5{1'b0}};
			b1_source1					<=		{32{1'b0}};
			b1_source0_flags			<=		1'b0;
			b1_source1_imm				<=		1'b0;
			b1_destination				<=		{5{1'b0}};
			b1_ex_sys_reg				<=		1'b0;
			b1_ex_sys_ldst				<=		1'b0;
			b1_ex_logic					<=		1'b0;
			b1_ex_shift					<=		1'b0;
			b1_ex_adder					<=		1'b0;
			b1_ex_mul					<=		1'b0;
			b1_ex_sdiv					<=		1'b0;
			b1_ex_udiv					<=		1'b0;
			b1_ex_ldst					<=		1'b0;
			b1_ex_branch				<=		1'b0;
			b1_error					<=		1'b0;
			b_pc						<=		32'h0;
		end
		else if(iFREE_DEFAULT)begin
			//Pipeline 0
			b0_valid					<=		1'b0;			
			b0_mmu_flags				<=		6'h0;		
			b0_source0_active			<=		1'b0;			
			b0_source1_active			<=		1'b0;	
			b0_source0_sysreg			<=		1'b0;	
			b0_source1_sysreg			<=		1'b0;	
			b0_source0_sysreg_rename	<=		1'b0;	
			b0_source1_sysreg_rename	<=		1'b0;
			b0_destination_sysreg		<=		1'b0;			
			b0_dest_rename				<=		1'b0;			
			b0_writeback				<=		1'b0;	
			b0_flag_writeback			<=		1'b0;
			b0_commit_wait_inst			<=		1'b0;					
			b0_cmd						<=		{5{1'b0}};
			b0_cc_afe					<=		{4{1'b0}};
			b0_source0					<=		{5{1'b0}};
			b0_source1					<=		{32{1'b0}};
			b0_source0_flags			<=		1'b0;
			b0_source1_imm				<=		1'b0;
			b0_destination				<=		{5{1'b0}};	
			b0_ex_sys_reg				<=		1'b0;
			b0_ex_sys_ldst				<=		1'b0;
			b0_ex_logic					<=		1'b0;
			b0_ex_shift					<=		1'b0;
			b0_ex_adder					<=		1'b0;
			b0_ex_mul					<=		1'b0;
			b0_ex_sdiv					<=		1'b0;
			b0_ex_udiv					<=		1'b0;
			b0_ex_ldst					<=		1'b0;
			b0_ex_branch				<=		1'b0;
			b0_error					<=		1'b0;
			//Pipeline 1
			b1_valid					<=		1'b0;			
			b1_mmu_flags				<=		6'h0;		
			b1_source0_active			<=		1'b0;			
			b1_source1_active			<=		1'b0;	
			b1_source0_sysreg			<=		1'b0;	
			b1_source1_sysreg			<=		1'b0;		
			b1_source0_sysreg_rename	<=		1'b0;	
			b1_source1_sysreg_rename	<=		1'b0;				
			b1_destination_sysreg		<=		1'b0;	
			b1_dest_rename				<=		1'b0;
			b1_writeback				<=		1'b0;		
			b1_flag_writeback			<=		1'b0;			
			b1_commit_wait_inst			<=		1'b0;					
			b1_cmd						<=		{5{1'b0}};
			b1_cc_afe					<=		{4{1'b0}};
			b1_source0					<=		{5{1'b0}};
			b1_source1					<=		{32{1'b0}};
			b1_source0_flags			<=		1'b0;
			b1_source1_imm				<=		1'b0;
			b1_destination				<=		{5{1'b0}};
			b1_ex_sys_reg				<=		1'b0;
			b1_ex_sys_ldst				<=		1'b0;
			b1_ex_logic					<=		1'b0;
			b1_ex_shift					<=		1'b0;
			b1_ex_adder					<=		1'b0;
			b1_ex_mul					<=		1'b0;
			b1_ex_sdiv					<=		1'b0;
			b1_ex_udiv					<=		1'b0;
			b1_ex_ldst					<=		1'b0;
			b1_ex_branch				<=		1'b0;
			b1_error					<=		1'b0;
			b_pc						<=		32'h0;
		end
		else begin
			if(!iNEXT_LOCK)begin
				//Pipeline 0
				b0_valid					<=		iPREVIOUS_0_INST_VALID;
				b0_mmu_flags				<=		iPREVIOUS_0_MMU_FLAGS;
				{
					b0_error, b0_commit_wait_inst, b0_cc_afe,
					b0_source0, b0_source1, b0_source0_flags, b0_source1_imm,
					b0_source0_active, b0_source1_active, 
					b0_source0_sysreg, b0_source1_sysreg,
					b0_source0_sysreg_rename, b0_source1_sysreg_rename,
					b0_destination, b0_writeback, b0_flag_writeback, 
					b0_destination_sysreg, b0_dest_rename, b0_cmd, b0_ex_sys_reg, b0_ex_sys_ldst,  
					b0_ex_logic, b0_ex_shift, b0_ex_adder, b0_ex_sdiv, 
					b0_ex_udiv, b0_ex_mul, b0_ex_ldst, b0_ex_branch
				}							<=		f_decode(iPREVIOUS_0_INST);	
				//Pipeline 1
				b1_valid					<=		iPREVIOUS_1_INST_VALID;
				b1_mmu_flags				<=		iPREVIOUS_1_MMU_FLAGS;
				{
					b1_error, b1_commit_wait_inst, b1_cc_afe,
					b1_source0, b1_source1, b1_source0_flags, b1_source1_imm,
					b1_source0_active, b1_source1_active, 
					b1_source0_sysreg, b1_source1_sysreg,
					b1_source0_sysreg_rename, b1_source1_sysreg_rename,
					b1_destination, b1_writeback, b1_flag_writeback, 
					b1_destination_sysreg, b1_dest_rename, b1_cmd, b1_ex_sys_reg, b1_ex_sys_ldst,  
					b1_ex_logic, b1_ex_shift, b1_ex_adder, b1_ex_sdiv, 
					b1_ex_udiv, b1_ex_mul, b1_ex_ldst, b1_ex_branch
				}							<=		f_decode(iPREVIOUS_1_INST);
				//Program Counter
				b_pc						<=		iPREVIOUS_PC;
			end
		end
	end //always
			
	
	
	
	function [74:0]	f_decode;
		input	[31:0]			f_decode_inst;
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
								/* Source1 */							{{21{1'b0}}, f_decode_inst[15:10], f_decode_inst[4:0]},
								/* Source0 Use Flags*/					1'b0,
								/* Source1-Immediate */					1'b1,
								/* Source0 Active */					1'b1,
								/* Source1 Active */					1'b1,
								/* Source0 System Register */			1'b0,
								/* Source1 System Register */			1'b0,
								/* Source0 System Register Rename */	1'b0,
								/* Source1 System Register Rename */	1'b0,
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
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_NEG,
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
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
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
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b1,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_SUB,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
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
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						f_decode_inst[9:5],
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
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
				//`OC_BURN
				//`OC_BRN
				//`OC_BN
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
							/* Destination */						`SYSREG_SPR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_LDST_WRITE_SPR,
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
							/* Destination */						`SYSREG_FRCHR,
							/* Write Back Enable */					1'b1,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
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
							/* Destination */						{5{1'b0}},
							/* Write Back Enable */					1'b0,
							/* Make Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_ADDER_ADD,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				//HALT
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
						f_decode				=		{1'b1, {74{1'b0}}};
						/*
						$display("Instruction Error : Decoder > Not Match Instruction(TIME:%t, Line0 Valid0:%d, Line1 Valid:%d)", $stime, iPREVIOUS_0_INST_VALID, iPREVIOUS_1_INST_VALID);
						*/
					end
			endcase
		end
	endfunction
	
	
	
	/****************************************
	This -> Previous
	****************************************/			
	assign	oPREVIOUS_LOCK			=		iNEXT_LOCK;
				
	/****************************************
	This -> Next
	****************************************/
	//Pipeline0
	assign					oNEXT_0_VALID					=		b0_valid;
	assign					oNEXT_0_MMU_FLAGS				=		b0_mmu_flags;
	assign					oNEXT_0_SOURCE0_ACTIVE			=		b0_source0_active;
	assign					oNEXT_0_SOURCE1_ACTIVE			=		b0_source1_active;//assign					oNEXT_0_1SOURCE					=		b0_1source;
	assign					oNEXT_0_SOURCE0_SYSREG			=		b0_source0_sysreg;//assign					oNEXT_0_0SOURCE					=		b0_0source;
	assign					oNEXT_0_SOURCE1_SYSREG			=		b0_source1_sysreg;
	assign					oNEXT_0_SOURCE0_SYSREG_RENAME	=		b0_source0_sysreg_rename;
	assign					oNEXT_0_SOURCE1_SYSREG_RENAME	=		b0_source1_sysreg_rename;
	assign					oNEXT_0_DESTINATION_SYSREG		=		b0_destination_sysreg;
	assign					oNEXT_0_DEST_RENAME				=		b0_dest_rename;
	assign					oNEXT_0_WRITEBACK				=		b0_writeback;
	assign					oNEXT_0_FLAGS_WRITEBACK			=		b0_flag_writeback;
	assign					oNEXT_0_FRONT_COMMIT_WAIT		=		b0_commit_wait_inst;
	assign					oNEXT_0_CMD						=		b0_cmd;
	assign					oNEXT_0_CC_AFE					=		b0_cc_afe;
	assign					oNEXT_0_SOURCE0					=		b0_source0;
	assign					oNEXT_0_SOURCE1					=		b0_source1;
	assign					oNEXT_0_SOURCE0_FLAGS			=		b0_source0_flags;
	assign					oNEXT_0_SOURCE1_IMM				=		b0_source1_imm;
	assign					oNEXT_0_DESTINATION				=		b0_destination;
	assign					oNEXT_0_EX_SYS_REG				=		b0_ex_sys_reg;
	assign					oNEXT_0_EX_SYS_LDST				=		b0_ex_sys_ldst;
	assign					oNEXT_0_EX_LOGIC				=		b0_ex_logic;
	assign					oNEXT_0_EX_SHIFT				=		b0_ex_shift;
	assign					oNEXT_0_EX_ADDER				=		b0_ex_adder;
	assign					oNEXT_0_EX_MUL					=		b0_ex_mul;
	assign					oNEXT_0_EX_SDIV					=		b0_ex_sdiv;
	assign					oNEXT_0_EX_UDIV					=		b0_ex_udiv;
	assign					oNEXT_0_EX_LDST					=		b0_ex_ldst;
	assign					oNEXT_0_EX_BRANCH				=		b0_ex_branch;
	//Pipeline1
	assign					oNEXT_1_VALID					=		b1_valid;
	assign					oNEXT_1_MMU_FLAGS				=		b1_mmu_flags;
	assign					oNEXT_1_SOURCE0_ACTIVE			=		b1_source0_active;
	assign					oNEXT_1_SOURCE1_ACTIVE			=		b1_source1_active;
	assign					oNEXT_1_SOURCE0_SYSREG			=		b1_source0_sysreg;
	assign					oNEXT_1_SOURCE1_SYSREG			=		b1_source1_sysreg;
	assign					oNEXT_1_SOURCE0_SYSREG_RENAME	=		b1_source0_sysreg_rename;
	assign					oNEXT_1_SOURCE1_SYSREG_RENAME	=		b1_source1_sysreg_rename;
	assign					oNEXT_1_DESTINATION_SYSREG		=		b1_destination_sysreg;
	assign					oNEXT_1_DEST_RENAME				=		b1_dest_rename;
	assign					oNEXT_1_WRITEBACK				=		b1_writeback;
	assign					oNEXT_1_FLAGS_WRITEBACK			=		b1_flag_writeback;
	assign					oNEXT_1_FRONT_COMMIT_WAIT		=		b1_commit_wait_inst;
	assign					oNEXT_1_CMD						=		b1_cmd;
	assign					oNEXT_1_CC_AFE					=		b1_cc_afe;
	assign					oNEXT_1_SOURCE0					=		b1_source0;
	assign					oNEXT_1_SOURCE1					=		b1_source1;
	assign					oNEXT_1_SOURCE0_FLAGS			=		b1_source0_flags;
	assign					oNEXT_1_SOURCE1_IMM				=		b1_source1_imm;
	assign					oNEXT_1_DESTINATION				=		b1_destination;
	assign					oNEXT_1_EX_SYS_REG				=		b1_ex_sys_reg;
	assign					oNEXT_1_EX_SYS_LDST				=		b1_ex_sys_ldst;
	assign					oNEXT_1_EX_LOGIC				=		b1_ex_logic;
	assign					oNEXT_1_EX_SHIFT				=		b1_ex_shift;
	assign					oNEXT_1_EX_ADDER				=		b1_ex_adder;
	assign					oNEXT_1_EX_MUL					=		b1_ex_mul;
	assign					oNEXT_1_EX_SDIV					=		b1_ex_sdiv;
	assign					oNEXT_1_EX_UDIV					=		b1_ex_udiv;
	assign					oNEXT_1_EX_LDST					=		b1_ex_ldst;
	assign					oNEXT_1_EX_BRANCH				=		b1_ex_branch;
	assign					oNEXT_PC						=		b_pc;

	
	
endmodule


`default_nettype wire



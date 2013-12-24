`include "core.h"
`default_nettype none	

`define		MICROCODE_SIZE			32'h10

module microcode_context_load(
					input					iCLOCK,
					input					inRESET,
					//Select
					input		[31:0]		iSELECT,
					//Output
					output		[31:0]		oCODE_SIZE,
					input		[72:0]		oCODE0,
					input		[72:0]		oCODE1
				);
				
				
	wire	[73:0]	tmp0;
	wire	[73:0]	tmp1;

	assign			tmp0		=		func_microcode(iSELECT<<1);
	assign			tmp1		=		func_microcode((iSELECT<<1) + 32'h1);
	
			
	assign		oCODE_SIZE		=		`MICROCODE_SIZE;
	assign		oCODE0			=		tmp0[72:0];
	assign		oCODE1			=		tmp1[72:0];
	
	/*
	//Set SPR
	srtisr		r0
	add			r0,		268	//128 + 140
	srtidr		r1
	mull		r1,		144
	add			r0,		r1
	srspw		r1
	//PDTR Reserved
	pop			ssr0
	//SPR Reserved
	pop			ssr1
	//PCR Reserved
	pop			ssr2
	//General Register
	pop			r31
	pop			r30
	pop			r29
	pop			r28
	pop			r27
	pop			r26
	pop			r25
	pop			r24
	pop			r23
	pop			r22
	pop			r21
	pop			r20
	pop			r19
	pop			r18
	pop			r17
	pop			r16
	pop			r15
	pop			r14
	pop			r13
	pop			r12
	pop			r11
	pop			r10
	pop			r9
	pop			r8
	pop			r7
	pop			r6
	pop			r5
	pop			r4
	pop			r3
	pop			r2
	pop			r1
	pop			r0
	//Set PDTR		
	srpdtw		ssr0
	//Set SPR
	srspw		ssr1
	//Set Userlevel Privilege ...
	//Jump New Task
	b			ssr2
	*/
	function [73:0] func_microcode;
		input			func_addr;
		begin
			case(func_addr)
				32'd0 :
					begin		//SRTISR	R0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_TISR,
							/* Source1 */							{32{1'b0}},
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`LOGICREG_R0,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				32'd1 : 
					begin		//ADD		R0,			268
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R0,
							/* Source1 */							32'd268,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`LOGICREG_R0,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_ADD,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				32'd2 : 
					begin		//SRTIDR	R1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_TIDR,
							/* Source1 */							{32{1'b0}},
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`LOGICREG_R1,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				32'd3 :
					begin		//MULL		R1,		144
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R1,
							/* Source1 */							32'd144,
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`LOGICREG_R1,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_MULDIV_MULL,
							/* Execute Module */					`EXE_SELECT_MUL
						};
					end
				32'd4 :
					begin		//ADD		R0,		R1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R0,
							/* Source1 */							{{27{1'b0}}, `LOGICREG_R1},
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`LOGICREG_R0,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_ADD,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end	
				32'd5 :
					begin		//SRSPW		R0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R0,
							/* Source1 */							{{27{1'b0}}, `LOGICREG_R1},
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`LOGICREG_R0,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b0,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_ADDER_ADD,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end	
				32'd6 :
					begin		//SRSPW		R0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R0,
							/* Source1 */							{32{1'b0}},
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`SYSREG_SPR,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_LDST_WRITE_SPR,
							/* Execute Module */					`EXE_SELECT_SYS_LDST
						};
					end
				32'd7 :
					begin		//POP		SSR0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_SSR0,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd8 :
					begin		//POP		SSR1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_SSR1,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd9 :
					begin		//POP		SSR2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_SSR2,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd10 :
					begin		//POP		R0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R0,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd11 :
					begin		//POP		R1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R1,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd12 :
					begin		//POP		R2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R2,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd13 :
					begin		//POP		R3
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R3,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd14 :
					begin		//POP		R4
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R4,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd15 :
					begin		//POP		R5
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R5,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd16 :
					begin		//POP		R6
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R6,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd17 :
					begin		//POP		R7
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R7,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd18 :
					begin		//POP		R8
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R8,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd19 :
					begin		//POP		R9
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R9,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd20 :
					begin		//POP		R10
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R10,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd21 :
					begin		//POP		R11
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R11,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd22 :
					begin		//POP		R12
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R12,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd23 :
					begin		//POP		R13
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R13,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd24 :
					begin		//POP		R14
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R14,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd25 :
					begin		//POP		R15
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R15,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd26 :
					begin		//POP		R16
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R16,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd27 :
					begin		//POP		R17
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R17,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd28 :
					begin		//POP		R18
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R18,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd29 :
					begin		//POP		R19
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R19,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd30 :
					begin		//POP		R20
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R20,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd31 :
					begin		//POP		R21
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R21,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd32 :
					begin		//POP		R22
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R22,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd33 :
					begin		//POP		R23
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R23,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd34 :
					begin		//POP		R24
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R24,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd35 :
					begin		//POP		R25
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R25,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd36 :
					begin		//POP		R26
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R26,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd37 :
					begin		//POP		R27
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R27,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd38 :
					begin		//POP		R28
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R28,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd39 :
					begin		//POP		R29
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R29,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd40 :
					begin		//POP		R30
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R30,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd41 :
					begin		//POP		R31
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Destination */						`LOGICREG_R31,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LDSW_POP,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'h42 :
					begin		//[SRPDTW_Micro_Code]	SSR0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_SSR0,
							/* Source1 */							{32{1'b0}},
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`SYSREG_PDTR,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_REG_BUFFER0,
							/* Execute Module */					`EXE_SELECT_SYS_REG
						};
					end
				32'h43 :
					begin		//SRSPW		SSR1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_SSR1,
							/* Source1 */							{32{1'b0}},
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`SYSREG_SPR,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_LDST_WRITE_SPR,
							/* Execute Module */					`EXE_SELECT_SYS_LDST
						};
					end
				32'h44 :
					begin		//B			SSR2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				`CC_AL,
							/* Source0 */							{5{1'b0}},								//none
							/* Source1 */							{{27{1'b0}}, `SYSREG_SSR2},		//Rd
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`SYSREG_PCR,
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_BRANCH_DJMP,
							/* Execute Module */					`EXE_SELECT_BRANCH
						};
					end
				default:
					begin
						$display("[ERROR] : microcode_context_load.v case Error");
						f_decode	=	{74{1'b1}};
					end
			endcase
		end
	endfunction
	
endmodule
	
	
	
`default_nettype wire
	
	
	
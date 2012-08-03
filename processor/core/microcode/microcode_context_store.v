`include "core.h"
`default_nettype none	

`define		MICROCODE_SIZE			32'h10

module microcode_context_store(
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
    //PC Reserved
    movepc      srr0,   -1
    //SPR Reserved
    srspr       ssr1
    //R0, R1 Reserved
    move        ssr2    r0
    move        ssr3    r1
    //Set SPR
    srtisr      r0
    add         r0,     128
    srtidr      r1
    mull        r1,     144
    add         r1,     r0
    srspw       r1
    //General Register Store
    push        ssr2
    push        ssr3
    push        r2
    push        r3
    push        r4
    push        r5
    push        r6
    push        r7
    push        r8
    push        r9
    push        r10
    push        r11
    push        r12
    push        r13
    push        r14
    push        r15
    push        r16
    push        r17
    push        r18
    push        r19
    push        r20
    push        r21
    push        r22
    push        r23
    push        r24
    push        r25
    push        r26
    push        r27
    push        r28
    push        r29
    push        r30
    push        r31
    //Push PC       
    push        srr0
    //Push SPR
    push        srr1
    //Push PDTR
    srpdtr      r0
    push        r0
	*/
	function [73:0] func_microcode;
		input			func_addr;
		begin
			case(func_addr)
				32'd0 :		//MOVEPC		SSR0,		-1
					begin	
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_PC,
							/* Source1 */							32'hFFFFFFFF,//-1
							/* Source1-Immediate */					1'b1,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`SYSREG_SSR0,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_ADDER_ADD,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
				32'd1 :
					begin		//SRSPR		SSR1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_SPR,
							/* Source1 */							{32{1'b0}},
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b0,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`SYSREG_SSR1,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_SYS_LDST_READ_SPR,
							/* Execute Module */					`EXE_SELECT_SYS_LDST
						};
					end
				32'd2 :
					begin		//MOVE		SSR2,		R0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							`LOGICREG_R0,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`SYSREG_SSR2,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_BUFFER1,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				32'd3 :
					begin		//MOVE		SSR3,		R1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							5'h0,
							/* Source1 */							`LOGICREG_R1,
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b0,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b0,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						`SYSREG_SSR3,
							/* Write Back Enable */					1'b1,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b1,
							/* Execute Module Command */			`EXE_LOGIC_BUFFER1,
							/* Execute Module */					`EXE_SELECT_LOGIC
						};
					end
				32'd4 : 
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
				32'd5 : 
					begin		//ADD		R0,			128
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R0,
							/* Source1 */							32'd128,
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
				32'd6 : 
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
				32'd7 :
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
				32'd8 :
					begin		//ADD		R1,		R0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R1,
							/* Source1 */							{{27{1'b0}}, `LOGICREG_R0},
							/* Source1-Immediate */					1'b0,
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
							/* Execute Module Command */			`EXE_ADDER_ADD,
							/* Execute Module */					`EXE_SELECT_ADDER
						};
					end
				32'd9 :
					begin		//SRSPW		R1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R1,
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
				32'd10 :
					begin		//PUSH		SSR2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_SSR2,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd11 :
					begin		//PUSH		SSR3
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_SSR3,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b1,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd12 :
					begin		//PUSH		R2
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R2,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd13 :
					begin		//PUSH		R3
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R3,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd14 :
					begin		//PUSH		R4
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R4,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd15 :
					begin		//PUSH		R5
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R5,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd16 :
					begin		//PUSH		R6
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R6,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd17 :
					begin		//PUSH		R7
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R7,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd18 :
					begin		//PUSH		R8
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R8,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd19 :
					begin		//PUSH		R9
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R9,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd20 :
					begin		//PUSH		R10
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R10,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd21 :
					begin		//PUSH		R11
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R11,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd22 :
					begin		//PUSH		R12
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R12,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd23 :
					begin		//PUSH		R13
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R13,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd24 :
					begin		//PUSH		R14
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R14,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd25 :
					begin		//PUSH		R15
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R15,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd26 :
					begin		//PUSH		R16
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R16,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd27 :
					begin		//PUSH		R17
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R17,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd28 :
					begin		//PUSH		R18
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R18,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd29 :
					begin		//PUSH		R19
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R19,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd30 :
					begin		//PUSH		R20
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R20,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd31 :
					begin		//PUSH		R21
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R21,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd32 :
					begin		//PUSH		R22
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R22,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd33 :
					begin		//PUSH		R23
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R23,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd34 :
					begin		//PUSH		R24
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R24,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd35 :
					begin		//PUSH		R25
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R25,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd36 :
					begin		//PUSH		R26
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R26,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd37 :
					begin		//PUSH		R27
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R27,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd38 :
					begin		//PUSH		R28
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R28,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd39 :
					begin		//PUSH		R29
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R29,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd40 :
					begin		//PUSH		R30
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R30,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd41 :
					begin		//PUSH		R31
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R31,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd42 :
					begin		//PUSH		SSR0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_SSR0,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd43 :
					begin		//PUSH		SSR1
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_SSR1,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				32'd44 :
					begin		//SRPDTR	R0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b0,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`SYSREG_PDTR,
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
				32'd45 :
					begin		//PUSH		R0
						f_decode	=	{
							/* Decode Error */						1'b0,
							/* Commit Wait Instruction */			1'b1,
							/* Condition Code & AFE */				4'h0,
							/* Source0 */							`LOGICREG_R0,						//Rs
							/* Source1 */							{{27{1'b0}}, `SYSREG_SPR},				//SPR
							/* Source1-Immediate */					1'b0,
							/* Source0 Active */					1'b1,
							/* Source1 Active */					1'b1,
							/* Source0 System Register */			1'b0,
							/* Source1 System Register */			1'b1,
							/* Source0 System Register Rename */	1'b0,
							/* Source1 System Register Rename */	1'b0,
							/* Destination */						5'h00,		//Memory
							/* Write Back Enable */					1'b0,
							/* Use Flag Instruction */				1'b0,
							/* Destination is System Register */	1'b1,
							/* Destination Rename*/					1'b0,
							/* Execute Module Command */			`EXE_LDSW_PUSH,
							/* Execute Module */					`EXE_SELECT_LDST
						};
					end
				
				default:
					begin
						$display("[ERROR] : microcode_context_store.v case Error");
						f_decode	=	{74{1'b1}};
					end
			endcase
		end
	endfunction
	
endmodule
	
	

`default_nettype wire
	
	
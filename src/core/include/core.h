/****************************************
	Core Header File
	- 
	
	
	Make	:	2010/@@/@@
	Update	:	
****************************************/

/******************************
Instruction Set
******************************/
//Integer
`define		OC_ADD		10'h000
`define		OC_SUB		10'h001
`define		OC_MULL		10'h002
`define		OC_MULH		10'h003
`define		OC_UDIV		10'h004
`define		OC_UMOD		10'h005
`define		OC_CMP		10'h006
`define		OC_DIV		10'h007
`define		OC_MOD		10'h008
`define		OC_NEG		10'h009
`define		OC_UMULL	10'h00A
`define		OC_UMULH	10'h00B
`define		OC_IC		10'h00D
`define		OC_ADDC		10'h00E
`define		OC_INC		10'h010
`define		OC_DEC		10'h011
`define		OC_MAX		10'h013
`define		OC_MIN		10'h014
`define		OC_UMAX		10'h015
`define		OC_UMIN		10'h016
`define		OC_SEXT8	10'h01C
`define		OC_SEXT16	10'h01D
//Floating

//Shift
`define		OC_SHL		10'h040
`define		OC_SHR		10'h041
`define		OC_SAR		10'h045
`define		OC_ROL		10'h048
`define		OC_ROR		10'h049
//Logic
`define		OC_AND		10'h060
`define		OC_OR		10'h061
`define		OC_XOR		10'h062
`define		OC_NOT		10'h063
`define		OC_NAND		10'h064
`define		OC_NOR		10'h065
`define		OC_XNOR		10'h066
`define		OC_TEST		10'h067
`define		OC_WL16		10'h06A
`define		OC_WH16		10'h06B
`define		OC_CLRB		10'h06C
`define		OC_SETB		10'h06D
`define		OC_CLR		10'h06E
`define		OC_SET		10'h06F
`define		OC_REVB		10'h070
`define		OC_REV8		10'h071
`define		OC_GETB		10'h072
`define		OC_GET8		10'h073
`define		OC_LIL		10'h076
`define		OC_LIH		10'h077
`define		OC_ULIL		10'h07A
//Memory Access
`define		OC_LD8		10'h080
`define		OC_LD16		10'h081
`define		OC_LD32		10'h082
`define		OC_ST8		10'h083
`define		OC_ST16		10'h084
`define		OC_ST32		10'h085
`define		OC_PUSH		10'h088
`define		OC_PUSHPC	10'h089
`define		OC_POP		10'h090
`define		OC_LDD8		10'h09A		
`define		OC_LDD16	10'h09B		
`define		OC_LDD32	10'h09C	
`define		OC_STD8		10'h09D		
`define		OC_STD16	10'h09E		
`define		OC_STD32	10'h09F		
//Branch
`define		OC_BUR		10'h0A0		
`define		OC_BR		10'h0A1
`define		OC_B		10'h0A2	
`define		OC_IB		10'h0A3
`define		OC_BURN		10'h0B0		
`define		OC_BRN		10'h0B1
`define		OC_BN		10'h0B2		
//System Register Read
`define		OC_SRSPR		10'h0C0
`define		OC_SRPDTR		10'h0C1
`define		OC_SRPIDR		10'h0C2
`define		OC_SRCIDR		10'h0C3
`define		OC_MODER		10'h0C4
`define		OC_SRIEIR		10'h0C5
`define		OC_SRTISR		10'h0C8
`define		OC_SRKPDTR		10'h0C9
`define		OC_SRMMUR		10'h0CA
`define		OC_SRIOSR		10'h0CB
`define		OC_SRTIDR		10'h0CC
`define		OC_SRPPSR		10'h0CD
`define		OC_SRPPCR		10'h0CE
`define		OC_SRPPDTR		10'h0D0
`define		OC_SRPTIDR		10'h0D1
`define		OC_SRPSR		10'h0D3
`define		OC_SRFRCR		10'h0D4
`define		OC_SRFRCLR		10'h0D5
`define		OC_SRFRCHR		10'h0D6
`define 	OC_SRPFLAGR		10'h0d7
//System Register Write
`define 	OC_SRSPW		10'h0E0
`define		OC_SRPDTW		10'h0E1
`define 	OC_SRIEIW		10'h0E5
`define 	OC_SRTISW		10'h0E8
`define 	OC_SRKPDTW		10'h0E9
`define		OC_SRMMUW		10'h0EA
`define		OC_SRPPSW		10'h0ED
`define		OC_SRPPCW		10'h0EE
`define		OC_SRPPDTW		10'h0F0
`define		OC_SRPTIDW		10'h0F1
`define		OC_SRIDTW		10'h0F2
`define		OC_SRPSW		10'h0F3
`define		OC_SRFRCW		10'h0F4
`define		OC_SRFCLW		10'h0F5
`define		OC_SRFCHW		10'h0F6
`define		OC_SRSPWADD		10'h0ff
//Other
`define		OC_NOP			10'h100
`define		OC_HALT			10'h101
`define		OC_MOVE			10'h102
`define		OC_MOVEPC		10'h103
//Operating System Support
`define		OC_SWI			10'h120
`define		OC_IDTS			10'h122

/******************************
Microcode Set
******************************/
/*
`define		MC_MOVE			10'h000
`define		MC_SET_TIDR		10'h001
`define		MC_SET_PDTR		10'h002
`define		MC_MOVEPC		10'h003
*/


/******************************
Execution CMD Set
******************************/
//Logic Unit
`define		EXE_LOGIC_BUFFER0		5'h00
`define		EXE_LOGIC_BUFFER1		5'h01
`define		EXE_LOGIC_AND			5'h02
`define		EXE_LOGIC_OR			5'h03
`define		EXE_LOGIC_XOR			5'h04
`define		EXE_LOGIC_NOT			5'h05
`define		EXE_LOGIC_NAND			5'h06
`define		EXE_LOGIC_NOR			5'h07
`define		EXE_LOGIC_XNOR			5'h08
`define		EXE_LOGIC_TEST			5'h08
`define		EXE_LOGIC_WBL			5'h0A
`define		EXE_LOGIC_WBH			5'h0B
`define		EXE_LOGIC_CLB			5'h0C
`define		EXE_LOGIC_STB			5'h0D
`define		EXE_LOGIC_CLW			5'h0E
`define		EXE_LOGIC_STW			5'h0F
`define		EXE_LOGIC_BITREV		5'h10
`define		EXE_LOGIC_BYTEREV		5'h11
`define		EXE_LOGIC_GETBIT		5'h12
`define		EXE_LOGIC_GETBYTE		5'h13
`define		EXE_LOGIC_LIL			5'h14
`define		EXE_LOGIC_LIH			5'h15
`define		EXE_LOGIC_ULIL			5'h16
//Shift Unit
`define		EXE_SHIFT_BUFFER		5'h00
`define		EXE_SHIFT_LOGICL		5'h01
`define		EXE_SHIFT_LOGICR		5'h02
`define		EXE_SHIFT_ALITHMETICR	5'h03
`define		EXE_SHIFT_ROTATEL		5'h04
`define		EXE_SHIFT_ROTATER		5'h05
//Adder Unit
`define		EXE_ADDER_ADD			5'h01
`define		EXE_ADDER_SUB			5'h02
`define		EXE_ADDER_NEG			5'h03
`define		EXE_ADDER_COUT			5'h04
`define		EXE_ADDER_SEXT8			5'h05
`define		EXE_ADDER_SEXT16		5'h06
`define		EXE_ADDER_MAX			5'h07
`define		EXE_ADDER_MIN			5'h08
`define		EXE_ADDER_UMAX			5'h09
`define		EXE_ADDER_UMIN			5'h0a
//Mul/Div Unit
`define		EXE_MUL_BUFFER			5'h00
`define		EXE_MUL_MULL			5'h01
`define		EXE_MUL_MULH			5'h02
`define		EXE_MUL_UMULL			5'h03
`define		EXE_MUL_UMULH			5'h04
//DIV
`define		EXE_DIV_BUFFER			5'h00
`define		EXE_DIV_DIV				5'h01
`define		EXE_DIV_MOD				5'h02
`define		EXE_DIV_UDIV			5'h03
`define		EXE_DIV_UMOD			5'h04
//Load / Store Unit
`define		EXE_LDSW_LD8			5'h00
`define		EXE_LDSW_LD16			5'h02
`define		EXE_LDSW_LD32			5'h03
`define		EXE_LDSW_ST8			5'h04
`define		EXE_LDSW_ST16			5'h05
`define		EXE_LDSW_ST32			5'h06
`define		EXE_LDSW_PUSH			5'h07
`define		EXE_LDSW_PPUSH			5'h08
`define		EXE_LDSW_POP			5'h09
`define		EXE_LDSW_LDD8			5'h0A
`define		EXE_LDSW_LDD16			5'h0B
`define		EXE_LDSW_LDD32			5'h0C
`define		EXE_LDSW_STD8			5'h0D
`define		EXE_LDSW_STD16			5'h0E
`define		EXE_LDSW_STD32			5'h0F

//Branch Unit
`define		EXE_BRANCH_BUR		5'h00
`define		EXE_BRANCH_BR		5'h01
`define		EXE_BRANCH_B			5'h02
`define		EXE_BRANCH_SWI			5'h03
`define		EXE_BRANCH_INTB			5'h04
`define		EXE_BRANCH_IDTS			5'h05	
`define		EXE_BRANCH_HALT			5'h06
//Load / Store System Register
`define		EXE_SYS_LDST_READ_SPR	5'h00
`define		EXE_SYS_LDST_WRITE_SPR	5'h01
`define		EXE_SYS_LDST_ADD_SPR	5'h02	
//System Register Unit
`define		EXE_SYS_REG_BUFFER0			5'h00
`define		EXE_SYS_REG_BUFFER1			5'h01
`define		EXE_SYS_REG_SR1_MMUMOD_R	5'h02
`define		EXE_SYS_REG_SR1_IM_R		5'h03
`define		EXE_SYS_REG_SR1_CMOD_R		5'h04
`define		EXE_SYS_REG_SR1_MMUMOD_W	5'h05
`define		EXE_SYS_REG_SR1_IM_W		5'h06
`define		EXE_SYS_REG_SR1_CMOD_W		5'h07


/******************************
Fault - User mode Prohibition
******************************/
`define FAULT_INSTRUCTION_SRTISR 10'h0c8
`define FAULT_INSTRUCTION_SRKPDTR 10'h0c9
`define FAULT_INSTRUCTION_SRPDTW 10'h0e1
`define FAULT_INSTRUCTION_SRIEIW 10'h0e5
`define FAULT_INSTRUCTION_SRTISW 10'h0e8
`define FAULT_INSTRUCTION_SRKPDTW 10'h0e9
`define FAULT_INSTRUCTION_SRMMUW 10'h0ea
`define FAULT_INSTRUCTION_HALT 10'h101
`define FAULT_INSTRUCTION_IDTS 10'h122



/******************************
Logic Register Set
******************************/
`define		LOGICREG_R0			5'h00
`define		LOGICREG_R1			5'h01
`define		LOGICREG_R2			5'h02
`define		LOGICREG_R3			5'h03
`define		LOGICREG_R4			5'h04
`define		LOGICREG_R5			5'h05
`define		LOGICREG_R6			5'h06
`define		LOGICREG_R7			5'h07
`define		LOGICREG_R8			5'h08
`define		LOGICREG_R9			5'h09
`define		LOGICREG_R10		5'h0A
`define		LOGICREG_R11		5'h0B
`define		LOGICREG_R12		5'h0C
`define		LOGICREG_R13		5'h0D
`define		LOGICREG_R14		5'h0E
`define		LOGICREG_R15		5'h0F
`define		LOGICREG_R16		5'h10
`define		LOGICREG_R17		5'h11
`define		LOGICREG_R18		5'h12
`define		LOGICREG_R19		5'h13
`define		LOGICREG_R20		5'h14
`define		LOGICREG_R21		5'h15
`define		LOGICREG_R22		5'h16
`define		LOGICREG_R23		5'h17
`define		LOGICREG_R24		5'h18
`define		LOGICREG_R25		5'h19
`define		LOGICREG_R26		5'h1A
`define		LOGICREG_R27		5'h1B
`define		LOGICREG_R28		5'h1C
`define		LOGICREG_R29		5'h1D
`define		LOGICREG_R30		5'h1E
`define		LOGICREG_R31		5'h1F
/******************************
System Register Set
******************************/
//User System Register
`define		SYSREG_CPUIDR		5'h00
`define		SYSREG_COREIDR		5'h01
`define		SYSREG_TIDR			5'h02
`define		SYSREG_FLAGR		5'h03	
`define		SYSREG_PCR			5'h04		
`define		SYSREG_SPR			5'h05
`define		SYSREG_PSR			5'h06
`define		SYSREG_IDTR			5'h07
`define		SYSREG_PDTR			5'h08
`define		SYSREG_TISR			5'h09
`define		SYSREG_KPDTR		5'h0A
`define		SYSREG_IOSR			5'h0B
`define		SYSREG_PPSR			5'h0C
`define		SYSREG_PPCR			5'h0E	
`define		SYSREG_PPDTR		5'h0F
`define		SYSREG_PTIDR		5'h10
`define		SYSREG_FRCR			5'h11
`define		SYSREG_FRCLR		5'h12
`define		SYSREG_FRCHR		5'h13
`define		SYSREG_FRCR2FRCXR	5'h14
`define		SYSREG_PFLAGR		5'h15

//Microcode Use System Register
`define		SYSREG_SSR0			5'h1C
`define		SYSREG_SSR1			5'h1D
`define		SYSREG_SSR2			5'h1E
`define		SYSREG_SSR3			5'h1F

/******************************
Execution Unit Select
******************************/
`define		EXE_SELECT_BRANCH		10'h001
`define		EXE_SELECT_LDST			10'h002
`define		EXE_SELECT_MUL			10'h004
`define		EXE_SELECT_UDIV			10'h008
`define		EXE_SELECT_SDIV			10'h010
`define		EXE_SELECT_ADDER		10'h020
`define		EXE_SELECT_SHIFT		10'h040
`define		EXE_SELECT_LOGIC		10'h080
`define		EXE_SELECT_SYS_LDST		10'h100
`define		EXE_SELECT_SYS_REG		10'h200
/******************************
Flags Select
******************************/
`define		FLAGS_SF				4
`define		FLAGS_OF				3
`define		FLAGS_CF				2
`define		FLAGS_PF				1
`define		FLAGS_ZF				0

/******************************
Core Mode
******************************/
`define		CORE_MODE_KERNEL			3'h0
`define		CORE_MODE_USER				3'h3


/******************************
Task Structure 
******************************/
`define		TST_TASKINF					8'h0
`define		TST_GR0						8'h4
`define		TST_GR1						8'h8
`define		TST_GR2						8'hC
`define		TST_GR3						8'h10
`define		TST_GR4						8'h14
`define		TST_GR5						8'h18
`define		TST_GR6						8'h1C
`define		TST_GR7						8'h20
`define		TST_GR8						8'h24
`define		TST_GR9						8'h28
`define		TST_GR10					8'h2C
`define		TST_GR11					8'h30
`define		TST_GR12					8'h34
`define		TST_GR13					8'h38
`define		TST_GR14					8'h3C
`define		TST_GR15					8'h40
`define		TST_GR16					8'h44
`define		TST_GR17					8'h48
`define		TST_GR18					8'h4C
`define		TST_GR19					8'h50
`define		TST_GR20					8'h54
`define		TST_GR21					8'h58
`define		TST_GR22					8'h5C
`define		TST_GR23					8'h60
`define		TST_GR24					8'h64
`define		TST_GR25					8'h68
`define		TST_GR26					8'h6C
`define		TST_GR27					8'h70
`define		TST_GR28					8'h74
`define		TST_GR29					8'h78
`define		TST_GR30					8'h7C
`define		TST_GR31					8'h80
`define		TST_PCR						8'h84
`define		TST_USPR					8'h88
`define		TST_KSPR					8'h8C
`define		TST_PDTR					8'h90
`define		TST_PSR						8'h94
`define		TST_FLAGR					8'h98




/******************************
CC
******************************/
`define		CC_AL		4'h0		//Allways
`define		CC_EQ		4'h1		//Equal[==](Z = 1)
`define		CC_NEQ		4'h2		//Not Equal(Z = 0)
`define		CC_MI		4'h3		//Minus(S = 1)
`define		CC_PL		4'h4		//Plus(S = 0)
`define		CC_EN		4'h5		//Even Number(P = 1)
`define		CC_ON		4'h6		//Odd Number(P = 0)
`define		CC_OVF		4'h7		//Overflow(O = 1)
`define		CC_UEO		4'h8		//Cary Set[unsigned =>](C = 1)		
`define		CC_UU		4'h9		//Not Cary Set[unsigned <](C = 0)
`define		CC_UO		4'hA		//[unsigned >](C = 1 and Z = 0)
`define		CC_UEU		4'hB		//[unsigned =<](C = 0 or Z = 1)
`define		CC_SEO		4'hC		//[signed =>]((N = 1 and O = 1) or (N = 0 and O = 0))		
`define		CC_SU		4'hD		//[signed <]((N = 1 and O = 0) or (N = 0 and O = 1))
`define		CC_SO		4'hE		//[signed >](Z = 0 and S = V)
`define		CC_SEU		4'hF		//[signed =<](Z = 1 or N! = V)


/******************************
Execution AFE(After Execution Enhancing)
******************************/
//Load Store AFE
`define		AFE_LDST_NONE		4'h0	//AFE None
`define		AFE_LDST_SEXT8_32	4'h1	//AFE 8bit->32bit Signe Extension
`define		AFE_LDST_SEXT16_32	4'h2	//AFE 16bit->32bit Signe Extension






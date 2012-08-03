`default_nettype none
`include "global.h"

`define		STT_IDLE			2'h0
`define		STT_COMP_WAIT		2'h1


module core_interrupt_manager(
								//System
								input				iCLOCK,
								input				inRESET,
								//Free
								input				iFREE_IRQ_SETCONDITION,
								//Interrupt Configlation Table
								input				iICT_VALID,
								input	[5:0]		iICT_ENTRY,
								input				iICT_CONF_MASK,
								input				iICT_CONF_VALID,
								input	[1:0]		iICT_CONF_LEVEL,
								//Core Info
								input	[31:0]		iSYSREGINFO_PSR,
								//External
								input				iEXT_ACTIVE,
								input	[5:0]		iEXT_NUM,
								output				oEXT_ACK,
								//output				oEXT_BUSY,
								//Core-ALU1
								input				iSWI_ACTIVE,
								input	[6:0]		iSWI_NUM,	
								///To Exception Manager
								input				iEXCEPTION_LOCK,
								output				oEXCEPTION_ACTIVE,
								output	[6:0]		oEXCEPTION_IRQ_NUM,
								input				iEXCEPTION_IRQ_ACK
	);

	/****************************************************
	Register and Wire
	***************************************************/
	//Interrupt Valid
	wire	software_interrupt_valid;
	wire	hardware_interrupt_valid;
	//Interrupt Config Table
	reg				ict_conf_mask[0:63];
	reg				ict_conf_valid[0:63];
	reg	[1:0]		ict_conf_level[0:63];
	//Instruction State
	reg		[1:0]		b_state;
	reg		[6:0]		b_irq_num;	
	//Generate
	integer			i;
	
	
	
	
	/****************************************************
	Instruction Config Table
	***************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 64; i = i + 1)begin
				ict_conf_valid		[i]		=		1'b0;
			end
			if(`DATA_RESET_ENABLE)begin
				for(i = 0; i < 64; i = i + 1)begin
					ict_conf_mask	[i]		=		1'b0;
					ict_conf_level	[i]		=		2'h0;
				end
			end
		end
		else begin 
			if(iICT_VALID)begin	
				ict_conf_mask		[iICT_ENTRY]		<=		iICT_CONF_MASK;
				ict_conf_valid		[iICT_ENTRY]		<=		iICT_CONF_VALID;
				ict_conf_level		[iICT_ENTRY]		<=		iICT_CONF_LEVEL;
			end
		end
	end
	
	
	assign	software_interrupt_valid		=	!iEXCEPTION_LOCK && iSYSREGINFO_PSR[2] && iSWI_ACTIVE;	
	assign	hardware_interrupt_valid		=	!iEXCEPTION_LOCK && iSYSREGINFO_PSR[2] && iEXT_ACTIVE && (!ict_conf_valid[iEXT_NUM] || (ict_conf_valid[iEXT_NUM] && ict_conf_mask[iEXT_NUM]));

			
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state			<=		`STT_IDLE;
			b_irq_num		<=		{7{1'b0}};
		end
		else begin
			case(b_state)
				`STT_IDLE :
					begin
						if(software_interrupt_valid)begin
							b_state			<=		`STT_COMP_WAIT;
							b_irq_num		<=		iSWI_NUM;
						end
						else if(hardware_interrupt_valid)begin
							b_state			<=		`STT_COMP_WAIT;
							b_irq_num		<=		{1'b0, iEXT_NUM};
						end
					end
				`STT_COMP_WAIT :
					begin
						if(iEXCEPTION_IRQ_ACK)begin
							b_state			<=		`STT_IDLE;
						end
					end
				default :
					begin
						$display("ERROR : core_interrupt_manager.v ERROR");
						b_state			<=		`STT_IDLE;			
					end
			endcase	
		end
	end
	
	assign	oEXT_ACK						=	(b_state == `STT_COMP_WAIT && !software_interrupt_valid)? hardware_interrupt_valid : 1'b0;
	assign	oEXCEPTION_ACTIVE				=	(b_state == `STT_COMP_WAIT)? !iFREE_IRQ_SETCONDITION : software_interrupt_valid || hardware_interrupt_valid;
	assign	oEXCEPTION_IRQ_NUM				=	(b_state == `STT_COMP_WAIT)? b_irq_num : ((software_interrupt_valid)? iSWI_NUM : {1'b0, iEXT_NUM});

			
endmodule


`default_nettype wire

				
`default_nettype none
`include "processor.h"

module core_interrupt_manager(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Free
		input wire iFREE_IRQ_SETCONDITION,
		//Interrupt Configlation Table
		input wire iICT_VALID,
		input wire [5:0] iICT_ENTRY,
		input wire iICT_CONF_MASK,
		input wire iICT_CONF_VALID,
		input wire [1:0] iICT_CONF_LEVEL,
		//Core Info
		input wire [31:0] iSYSREGINFO_PSR,
		//External
		input wire iEXT_ACTIVE,
		input wire [5:0] iEXT_NUM,
		output wire oEXT_ACK,
		//output				oEXT_BUSY,
		//Core-ALU
		input wire iFAULT_ACTIVE,
		input wire [6:0] iFAULT_NUM,	
		input wire [31:0] iFAULT_FI0R,
		///To Exception Manager
		input wire iEXCEPTION_LOCK,
		output wire oEXCEPTION_ACTIVE,
		output wire [6:0] oEXCEPTION_IRQ_NUM,
		output wire [31:0] oEXCEPTION_IRQ_FI0R,
		input wire iEXCEPTION_IRQ_ACK
	);
	
	
	localparam STT_IDLE = 2'h0;
	localparam STT_COMP_WAIT = 2'h1;

	/****************************************************
	Register and Wire
	***************************************************/
	//Interrupt Valid
	wire software_interrupt_valid;
	wire hardware_interrupt_valid;
	//Interrupt Config Table
	reg ict_conf_mask[0:63];
	reg ict_conf_valid[0:63];
	reg	[1:0] ict_conf_level[0:63];
	//Instruction State
	reg [1:0] b_state;
	reg [6:0] b_irq_num;	
	reg [31:0] b_irq_fi0r;
	reg b_irq_type;
	reg b_irq_ack;
	//Generate
	
	integer i;
	
	/****************************************************
	Instruction Config Table
	***************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 64; i = i + 1)begin
				ict_conf_valid [i] = 1'b0;
			end
			if(`PROCESSOR_DATA_RESET_EN)begin
				for(i = 0; i < 64; i = i + 1)begin
					ict_conf_mask [i] = 1'b0;
					ict_conf_level [i] = 2'h0;
				end
			end
		end
		else begin 
			if(iICT_VALID)begin	
				ict_conf_mask [iICT_ENTRY] <= iICT_CONF_MASK;
				ict_conf_valid [iICT_ENTRY] <= iICT_CONF_VALID;
				ict_conf_level [iICT_ENTRY] <= iICT_CONF_LEVEL;
			end
		end
	end
	
	
	assign software_interrupt_valid = !iEXCEPTION_LOCK/* && iSYSREGINFO_PSR[2]*/ && iFAULT_ACTIVE;	
	assign hardware_interrupt_valid = !iEXCEPTION_LOCK/* && iSYSREGINFO_PSR[2]*/ && iEXT_ACTIVE && (!ict_conf_valid[iEXT_NUM] || (ict_conf_valid[iEXT_NUM] && ict_conf_mask[iEXT_NUM]));

	
	//Hardware Irq Latch
	reg b_hw_irq_valid;
	reg [6:0] b_hw_irq_num;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_hw_irq_valid <= 1'b0;
			b_hw_irq_num <= 7'h0;
		end
		else begin
			if(!b_hw_irq_valid)begin
				if(iEXT_ACTIVE && (!ict_conf_valid[iEXT_NUM] || (ict_conf_valid[iEXT_NUM] && ict_conf_mask[iEXT_NUM])))begin
					b_hw_irq_valid <= 1'b1;
					b_hw_irq_num <= {1'b0, iEXT_NUM};
				end
			end
			else begin
				if(!software_interrupt_valid && b_state == STT_IDLE && !iEXCEPTION_LOCK)begin
					b_hw_irq_valid <= 1'b0;
				end
			end
		end
	end
	
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state <= STT_IDLE;
			b_irq_num <= {7{1'b0}};
			b_irq_fi0r <= 32'h0;
			b_irq_type <= 1'b0;
			b_irq_ack <= 1'b0;
		end
		else begin
			case(b_state)
				STT_IDLE :
					begin
						if(software_interrupt_valid)begin
							b_state <= STT_COMP_WAIT;
							b_irq_num <= iFAULT_NUM;
							b_irq_fi0r <= iFAULT_FI0R;
							b_irq_type <= 1'b0;
							b_irq_ack <= 1'b1;
						end
						else if(b_hw_irq_valid && !iEXCEPTION_LOCK)begin
							b_state <= STT_COMP_WAIT;
							b_irq_num <= b_hw_irq_num;
							b_irq_fi0r <= 32'h0;
							b_irq_type <= 1'b1;
							b_irq_ack <= 1'b1;
						end
					end
				STT_COMP_WAIT :
					begin
						b_irq_ack <= 1'b0;
						if(iEXCEPTION_IRQ_ACK)begin
							b_state <= STT_IDLE;
						end
					end
				default :
					begin
						b_state <= STT_IDLE;			
					end
			endcase	
		end
	end
	
	assign oEXT_ACK = b_irq_ack && b_irq_type;//(b_state == `STT_COMP_WAIT && !software_interrupt_valid)? hardware_interrupt_valid : 1'b0;
	assign oEXCEPTION_ACTIVE = (b_state == STT_COMP_WAIT)? !iEXCEPTION_IRQ_ACK : software_interrupt_valid || hardware_interrupt_valid || b_hw_irq_valid;//(b_state == `STT_COMP_WAIT)? !iFREE_IRQ_SETCONDITION : software_interrupt_valid || hardware_interrupt_valid;
	assign oEXCEPTION_IRQ_NUM = (b_state == STT_COMP_WAIT)? b_irq_num : ((software_interrupt_valid)? iFAULT_NUM : {1'b0, iEXT_NUM});
	assign oEXCEPTION_IRQ_FI0R = b_irq_fi0r;

			
endmodule

`default_nettype wire

				

`default_nettype none
`include "processor.h"


module dps_irq(
		input wire iCLOCK,
		input wire inRESET,
		//IRQ Tables	
		input wire iDPS_IRQ_CONFIG_TABLE_REQ,
		input wire [1:0] iDPS_IRQ_CONFIG_TABLE_ENTRY,			//[0]UTIM64_IRT | [1]LSFLAGS_IRT | [2~3]Reserved 
		input wire iDPS_IRQ_CONFIG_TABLE_FLAG_MASK,
		input wire iDPS_IRQ_CONFIG_TABLE_FLAG_VALID,
		input wire [1:0] iDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL,
		//IRQ
		input wire iUTIM64FLAGS_IRQ,			//IRQ Req Enable
		output wire oUTIM64FLAGS_ACK,			
		input wire iLSFLAGS_IRQ,
		output wire oLSFLAGS_ACK,		
		//IRQ Out
		output wire oIRQ_VALID,
		output wire oIRQ_NUM,
		input wire iIRQ_ACK
	);
	
	
	//Generate
	integer i;
	
	/*******************************************************
	Interrupt Infomation Memory
	*******************************************************/
	//Interrupt Infomation Memory
	reg b_ctrl_mem_mask[0:3];
	reg b_ctrl_mem_valid[0:3];
	reg [1:0] b_ctrl_mem_mode[0:3];

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 2; i = i + 1)begin
				b_ctrl_mem_valid [i] <= 1'b0;
				b_ctrl_mem_mask [i] <= 1'b0;
				if(`PROCESSOR_DATA_RESET_EN)begin
					b_ctrl_mem_mode [i] <= 2'h0;
				end
			end
		end
		else begin 
			if(iDPS_IRQ_CONFIG_TABLE_REQ)begin	
				b_ctrl_mem_mask [iDPS_IRQ_CONFIG_TABLE_ENTRY] <= iDPS_IRQ_CONFIG_TABLE_FLAG_MASK;
				b_ctrl_mem_valid [iDPS_IRQ_CONFIG_TABLE_ENTRY] <= iDPS_IRQ_CONFIG_TABLE_FLAG_VALID;
				b_ctrl_mem_mode [iDPS_IRQ_CONFIG_TABLE_ENTRY] <= iDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL;
			end
		end
	end
	
	/*******************************************************
	IRQ Check
	*******************************************************/
	reg irq_valid;	//IRQ Valid
	reg irq_num;	//0:TIMER | 1:SCI
	always @* begin
		if(iUTIM64FLAGS_IRQ && (!b_ctrl_mem_valid[0] || (b_ctrl_mem_valid[0] && b_ctrl_mem_mask[0])))begin
			irq_valid <= 1'b1;
			irq_num <= 1'b0;
		end
		else if(iLSFLAGS_IRQ && (!b_ctrl_mem_valid[1] || (b_ctrl_mem_valid[1] && b_ctrl_mem_mask[1])))begin
			irq_valid <= 1'b1;
			irq_num <= 1'b1;
		end
		else begin
			irq_valid <= 1'b0;
			irq_num <= 1'b0;
		end
	end

	/*******************************************************
	IRQ State
	*******************************************************/
	localparam L_PARAM_IRQ_STT_IDLE = 1'b0;
	localparam L_PARAM_IRQ_STT_ACK_WAIT = 1'b1;

	//IRQ State
	reg b_irq_state;
	reg b_irq_num;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_state <= L_PARAM_IRQ_STT_IDLE;
			b_irq_num <= 1'b0;
		end
		else begin
			case(b_irq_state)
				L_PARAM_IRQ_STT_IDLE:
					begin
						b_irq_num <= irq_num;
						if(irq_valid)begin
							b_irq_state <= L_PARAM_IRQ_STT_ACK_WAIT;
						end
					end
				L_PARAM_IRQ_STT_ACK_WAIT:
					begin
						if(iIRQ_ACK)begin
							b_irq_state <= L_PARAM_IRQ_STT_IDLE;
						end
					end
			endcase
		end
	end
	
	
	assign oUTIM64FLAGS_ACK = (b_irq_state == L_PARAM_IRQ_STT_IDLE)? ((irq_num == 1'b0) && irq_valid) : 1'b0;
	assign oLSFLAGS_ACK = (b_irq_state == L_PARAM_IRQ_STT_IDLE)? ((irq_num == 1'b1) && irq_valid) : 1'b0;		
	//IRQ Out
	assign oIRQ_VALID = (b_irq_state == L_PARAM_IRQ_STT_ACK_WAIT)? 1'b1 : 1'b0;
	assign oIRQ_NUM = b_irq_num;
	
endmodule

`default_nettype wire
		
		
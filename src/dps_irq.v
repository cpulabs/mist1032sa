
`default_nettype none
`include "global.h"


module dps_irq(
		input				iCLOCK,
		input				inRESET,
		//IRQ Tables	
		input				oDPS_IRQ_CONFIG_TABLE_REQ,
		input				oDPS_IRQ_CONFIG_TABLE_ENTRY,			//UTIM64_IRT | LSFLAGS_IRT 
		input				oDPS_IRQ_CONFIG_TABLE_FLAG_MASK,
		input				oDPS_IRQ_CONFIG_TABLE_FLAG_VALID,
		input	[1:0]		oDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL,
		//IRQ
		input				iUTIM64FLAGS_IRQ,			//IRQ Req Enable
		output				oUTIM64FLAGS_ACK,			
		input				iLSFLAGS_IRQ,
		output				oLSFLAGS_ACK,		
		//IRQ Out
		output				oIRQ_VALID,
		output				oIRQ_NUM,
		input				iIRQ_ACK
	);
	
	
	//Generate
	integer				i;
	
	/*******************************************************
	Interrupt Infomation Memory
	*******************************************************/
	//Interrupt Infomation Memory
	reg					b_ctrl_mem_mask[0:1];
	reg					b_ctrl_mem_valid[0:1];
	reg		[1:0]		b_ctrl_mem_mode[0:1];

	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 2; i = i + 1)begin
				b_ctrl_mem_valid	[i]						<=		1'b0;
				b_ctrl_mem_mask		[i]						<=		1'b0;
				if(`DATA_RESET_ENABLE)begin
					b_ctrl_mem_mode		[i]						<=		2'h0;
				end
			end
		end
		else begin 
			if(oDPS_IRQ_CONFIG_TABLE_REQ)begin	
				b_ctrl_mem_mask		[oDPS_IRQ_CONFIG_TABLE_ENTRY]		<=		oDPS_IRQ_CONFIG_TABLE_FLAG_MASK;
				b_ctrl_mem_valid	[oDPS_IRQ_CONFIG_TABLE_ENTRY]		<=		oDPS_IRQ_CONFIG_TABLE_FLAG_VALID;
				b_ctrl_mem_mode		[oDPS_IRQ_CONFIG_TABLE_ENTRY]		<=		oDPS_IRQ_CONFIG_TABLE_FLAG_LEVEL;
			end
		end
	end
	
	/*******************************************************
	IRQ Check
	*******************************************************/
	reg			irq_valid;	//IRQ Valid
	reg			irq_num;	//0:SCI | 1:TIMER
	always @* begin
		if(iUTIM64FLAGS_IRQ && (!b_ctrl_mem_valid[0] || (b_ctrl_mem_valid[0] && b_ctrl_mem_mask[0])))begin
			irq_valid	<=		1'b1;
			irq_num		<=		1'b1;
		end
		else if(iLSFLAGS_IRQ && (!b_ctrl_mem_valid[1] || (b_ctrl_mem_valid[1] && b_ctrl_mem_mask[1])))begin
			irq_valid	<=		1'b1;
			irq_num		<=		1'b0;
		end
		else begin
			irq_valid	<=		1'b0;
			irq_num		<=		1'b0;
		end
	end

	/*******************************************************
	IRQ State
	*******************************************************/
	`define		IRQ_STT_IDLE		1'b0
	`define		IRQ_STT_ACK_WAIT	1'b1

	//IRQ State
	reg					b_irq_state;
	reg					b_irq_num;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_state			<=		`IRQ_STT_IDLE;
			b_irq_num			<=		1'b0;
		end
		else begin
			case(b_irq_state)
				`IRQ_STT_IDLE:
					begin
						b_irq_num			<=		irq_num;
						if(irq_valid)begin
							b_irq_state			<=		`IRQ_STT_ACK_WAIT;
						end
					end
				`IRQ_STT_ACK_WAIT:
					begin
						if(iIRQ_ACK)begin
							b_irq_state			<=		`IRQ_STT_IDLE;
						end
					end
			endcase
		end
	end
	
	
	assign		oUTIM64FLAGS_ACK	=	(b_irq_state == `IRQ_STT_IDLE)? (irq_num == 1'b1) && irq_valid : 1'b0;
	assign		oLSFLAGS_ACK		=	(b_irq_state == `IRQ_STT_IDLE)? (irq_num == 1'b0) && irq_valid : 1'b0;		
	//IRQ Out
	assign		oIRQ_VALID			=	(b_irq_state == `IRQ_STT_ACK_WAIT)? 1'b1 : 1'b0;
	assign		oIRQ_NUM			=	b_irq_num;
	
endmodule

`default_nettype wire
		
		
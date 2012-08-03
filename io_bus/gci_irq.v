`default_nettype none
`include "global.h"

`define		IRQ_STT_IDLE		1'b0
`define		IRQ_STT_ACK_WAIT	1'b1

module gci_irq(
						//System
						input				iCLOCK,
						input				inRESET,
						//IRQ Controll Register
						input				iIRQ_CTRL_REQ,
						input	[4:0]		iIRQ_CTRL_ENTRY,
						input				iIRQ_CTRL_INFO_MASK,
						input				iIRQ_CTRL_INFO_VALID,
						input	[1:0]		iIRQ_CTRL_INFO_MODE,
						//Node Info
						input				iNODEINF_VALID,
						input	[7:0]		iNODE1_NODEINFO_PRIORITY,			
						input	[7:0]		iNODE2_NODEINFO_PRIORITY,	
						input	[7:0]		iNODE3_NODEINFO_PRIORITY,	
						input	[7:0]		iNODE4_NODEINFO_PRIORITY,
						//IRQ
						output				iNODE_IRQ_BUSY,
						input				iNODE1_IRQ,			//IRQ Req Enable
						output				oNODE1_ACK,			
						input				iNODE2_IRQ,
						output				oNODE2_ACK,			
						input				iNODE3_IRQ,
						output				oNODE3_ACK,			
						input				iNODE4_IRQ,
						output				oNODE4_ACK,			
						//IRQ Out
						output				oIRQ_EMPTY,
						output				oIRQ_VALID,
						output	[5:0]		oIRQ_NUM,
						input				iIRQ_ACK
				);
				
				
				

	/*******************************************************
	Register & Wire
	*******************************************************/
	//Generate
	integer				i;
	//Interrupt Infomation Memory
	reg					b_ctrl_mem_mask[0:31];
	reg					b_ctrl_mem_valid[0:31];
	reg		[1:0]		b_ctrl_mem_mode[0:31];
	//IRQ State
	reg					b_irq_state;
	reg		[5:0]		b_irq_num;
	//IRQ State
	wire	[5:0]		irq_select_func_out;


	
	/*******************************************************
	Interrupt Infomation Memory
	*******************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 32; i = i + 1)begin
				b_ctrl_mem_valid	[i]						<=		1'b0;
				b_ctrl_mem_mask		[i]						<=		1'b0;
				if(`DATA_RESET_ENABLE)begin
					b_ctrl_mem_mode		[i]						<=		2'h0;
				end
			end
		end
		else begin 
			if(iIRQ_CTRL_REQ)begin	
				b_ctrl_mem_mask		[iIRQ_CTRL_ENTRY]		<=		iIRQ_CTRL_INFO_MASK;
				b_ctrl_mem_valid	[iIRQ_CTRL_ENTRY]		<=		iIRQ_CTRL_INFO_VALID;
				b_ctrl_mem_mode		[iIRQ_CTRL_ENTRY]		<=		iIRQ_CTRL_INFO_MODE;
			end
		end
	end
	



	

	assign				irq_select_func_out		=		func_select_irq_source(
															iNODE1_NODEINFO_PRIORITY,
															iNODE2_NODEINFO_PRIORITY,
															iNODE3_NODEINFO_PRIORITY,
															iNODE4_NODEINFO_PRIORITY,
															iNODE1_IRQ && (!b_ctrl_mem_valid[0] || (b_ctrl_mem_valid[0] && b_ctrl_mem_mask[0])),
															iNODE2_IRQ && (!b_ctrl_mem_valid[1] || (b_ctrl_mem_valid[1] && b_ctrl_mem_mask[1])),
															iNODE3_IRQ && (!b_ctrl_mem_valid[2] || (b_ctrl_mem_valid[2] && b_ctrl_mem_mask[2])),
															iNODE4_IRQ && (!b_ctrl_mem_valid[3] || (b_ctrl_mem_valid[3] && b_ctrl_mem_mask[3]))
														);

	
	/*******************************************************
	IRQ State
	*******************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_state			<=		`IRQ_STT_IDLE;
			b_irq_num			<=		6'h0;
		end
		else begin
			case(b_irq_state)
				`IRQ_STT_IDLE:
					begin
						b_irq_num			<=		irq_select_func_out[4:0];
						if(irq_select_func_out[5] && iNODEINF_VALID)begin
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
											
	

	//[5]Irq Request, [4:0]Irq Number
	function [5:0] func_select_irq_source;
		input	[7:0]	func_node1_info_priority;
		input	[7:0]	func_node2_info_priority;
		input	[7:0]	func_node3_info_priority;
		input	[7:0]	func_node4_info_priority;
		input			func_node1_irq;
		input			func_node2_irq;
		input			func_node3_irq;
		input			func_node4_irq;
		begin
			if(func_node1_irq & 
			(!func_node2_irq || func_node2_irq & (func_node1_info_priority > func_node2_info_priority)) & 
			(!func_node3_irq || func_node3_irq & (func_node1_info_priority > func_node3_info_priority)) & 
			(!func_node4_irq || func_node4_irq & (func_node1_info_priority > func_node4_info_priority)))begin
				func_select_irq_source		=		{1'b1, 5'h1};
			end
			else if(func_node2_irq & 
			(!func_node1_irq || func_node1_irq & (func_node2_info_priority > func_node1_info_priority)) & 
			(!func_node3_irq || func_node3_irq & (func_node2_info_priority > func_node3_info_priority)) & 
			(!func_node4_irq || func_node4_irq & (func_node2_info_priority > func_node4_info_priority)))begin
				func_select_irq_source		=		{1'b1, 5'h2};
			end
			else if(func_node3_irq & 
			(!func_node1_irq || func_node1_irq & (func_node3_info_priority > func_node1_info_priority)) & 
			(!func_node2_irq || func_node2_irq & (func_node3_info_priority > func_node2_info_priority)) & 
			(!func_node4_irq || func_node4_irq & (func_node3_info_priority > func_node4_info_priority)))begin
				func_select_irq_source		=		{1'b1, 5'h3};
			end
			else if(func_node4_irq & 
			(!func_node1_irq || func_node1_irq & (func_node4_info_priority > func_node1_info_priority)) & 
			(!func_node2_irq || func_node2_irq & (func_node4_info_priority > func_node2_info_priority)) & 
			(!func_node3_irq || func_node3_irq & (func_node4_info_priority > func_node3_info_priority)))begin
				func_select_irq_source		=		{1'b1, 5'h4};
			end
			else begin
				func_select_irq_source		=		6'h0;
			end			
		end
	endfunction
	
	
	assign		iNODE_IRQ_BUSY		=		!iNODEINF_VALID;

	assign		oIRQ_EMPTY			=		1'b0;
	assign		oIRQ_VALID			=		(b_irq_state == `IRQ_STT_ACK_WAIT) && iNODEINF_VALID;
	assign		oIRQ_NUM			=		b_irq_num;
	
	assign		oNODE1_ACK			=		(b_irq_state == `IRQ_STT_IDLE)? (irq_select_func_out[4:0] == 5'h1) && irq_select_func_out[5] : 1'b0;
	assign		oNODE2_ACK			=		(b_irq_state == `IRQ_STT_IDLE)? (irq_select_func_out[4:0] == 5'h2) && irq_select_func_out[5] : 1'b0;
	assign		oNODE3_ACK			=		(b_irq_state == `IRQ_STT_IDLE)? (irq_select_func_out[4:0] == 5'h3) && irq_select_func_out[5] : 1'b0;
	assign		oNODE4_ACK			=		(b_irq_state == `IRQ_STT_IDLE)? (irq_select_func_out[4:0] == 5'h4) && irq_select_func_out[5] : 1'b0;


		
endmodule


`default_nettype wire
					
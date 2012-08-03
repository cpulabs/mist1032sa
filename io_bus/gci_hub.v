/****************************************
	GCI 1.0
	
	
	
	Make	:	2011/09/23
	Update	:	2011/12/18
	
2011/12/18 : ADD GCI Master Special Memory
****************************************/
`default_nettype none



module gci_hub(
						//System
						input				iCLOCK,
						input				inRESET,						
						//IRQ Controll Register
						input				iIRQ_CTRL_REQ,
						input	[4:0]		iIRQ_CTRL_ENTRY,
						input				iIRQ_CTRL_INFO_MASK,
						input				iIRQ_CTRL_INFO_VALID,
						input	[1:0]		iIRQ_CTRL_INFO_MODE,
						//CPU - Data
						input				iCPU_REQ,	//Input
						output				oCPU_BUSY,
						input				iCPU_RW,
						input	[31:0]		iCPU_ADDR,
						input	[31:0]		iCPU_DATA,
						output				oCPU_REQ,	//Output
						input				iCPU_BUSY,
						output	[31:0]		oCPU_DATA,
						//CPU - Irq
						output				oCPU_IRQ_REQ,
						output	[5:0]		oCPU_IRQ_NUM,
						input				iCPU_IRQ_ACK,					
						//DEV1
						input				iDEV1_VALID,
						input				iDEV1_REQ,			//Inpuit
						output				oDEV1_BUSY,
						input	[31:0]		iDEV1_DATA,
						output				oDEV1_REQ,			//Output
						input				iDEV1_BUSY,
						output				oDEV1_RW,
						output	[31:0]		oDEV1_ADDR,
						output	[31:0]		oDEV1_DATA,
						input				iDEV1_IRQ_REQ,		//IRQ
						output				oDEV1_IRQ_BUSY,
						input	[23:0]		iDEV1_IRQ_DATA,
						output				oDEV1_IRQ_ACK,
						//DEV2
						input				iDEV2_VALID,
						input				iDEV2_REQ,			//Inpuit
						output				oDEV2_BUSY,
						input	[31:0]		iDEV2_DATA,
						output				oDEV2_REQ,			//Output
						input				iDEV2_BUSY,
						output				oDEV2_RW,
						output	[31:0]		oDEV2_ADDR,
						output	[31:0]		oDEV2_DATA,
						input				iDEV2_IRQ_REQ,		//IRQ
						output				oDEV2_IRQ_BUSY,
						input	[23:0]		iDEV2_IRQ_DATA,
						output				oDEV2_IRQ_ACK,
						//DEV3
						input				iDEV3_VALID,
						input				iDEV3_REQ,			//Inpuit
						output				oDEV3_BUSY,
						input	[31:0]		iDEV3_DATA,
						output				oDEV3_REQ,			//Output
						input				iDEV3_BUSY,
						output				oDEV3_RW,
						output	[31:0]		oDEV3_ADDR,
						output	[31:0]		oDEV3_DATA,
						input				iDEV3_IRQ_REQ,		//IRQ
						output				oDEV3_IRQ_BUSY,
						input	[23:0]		iDEV3_IRQ_DATA,
						output				oDEV3_IRQ_ACK,
						//DEV4
						input				iDEV4_VALID,
						input				iDEV4_REQ,			//Inpuit
						output				oDEV4_BUSY,
						input	[31:0]		iDEV4_DATA,
						output				oDEV4_REQ,			//Output
						input				iDEV4_BUSY,
						output				oDEV4_RW,
						output	[31:0]		oDEV4_ADDR,
						output	[31:0]		oDEV4_DATA,
						input				iDEV4_IRQ_REQ,		//IRQ
						output				oDEV4_IRQ_BUSY,
						input	[23:0]		iDEV4_IRQ_DATA,
						output				oDEV4_IRQ_ACK
	);
					
		
	/************************************************************
	Wire & Register
	************************************************************/
	//GCI Node1
	wire			node1_node_valid;
	wire			node1_nodeinfo_valid;
	wire	[7:0]	node1_nodeinfo_priority;
	wire	[31:0]	node1_nodeinfo_memsize;
	wire			node1_node2master_busy;
	wire			node1_node2master_req;
	wire	[31:0]	node1_node2master_data;
	wire			node1_node2irq_req;
	wire			node1_io2dev_busy;
	wire			node1_io2dev_req;
	wire			node1_io2dev_rw;
	wire	[31:0]	node1_io2dev_addr;
	wire	[31:0]	node1_io2dev_data;
	wire			node1_io2dev_irq_busy;
	wire			node1_io2dev_irq_ack;
	//GCI Node2
	wire			node2_node_valid;
	wire			node2_nodeinfo_valid;
	wire	[7:0]	node2_nodeinfo_priority;
	wire	[31:0]	node2_nodeinfo_memsize;
	wire			node2_node2master_busy;
	wire			node2_node2master_req;
	wire	[31:0]	node2_node2master_data;
	wire			node2_node2irq_req;
	wire			node2_io2dev_busy;
	wire			node2_io2dev_req;
	wire			node2_io2dev_rw;
	wire	[31:0]	node2_io2dev_addr;
	wire	[31:0]	node2_io2dev_data;
	wire			node2_io2dev_irq_busy;
	wire			node2_io2dev_irq_ack;
	//GCI Node3
	wire			node3_node_valid;
	wire			node3_nodeinfo_valid;
	wire	[7:0]	node3_nodeinfo_priority;
	wire	[31:0]	node3_nodeinfo_memsize;
	wire			node3_node2master_busy;
	wire			node3_node2master_req;
	wire	[31:0]	node3_node2master_data;
	wire			node3_node2irq_req;
	wire			node3_io2dev_busy;
	wire			node3_io2dev_req;
	wire			node3_io2dev_rw;
	wire	[31:0]	node3_io2dev_addr;
	wire	[31:0]	node3_io2dev_data;
	wire			node3_io2dev_irq_busy;
	wire			node3_io2dev_irq_ack;
	//GCI Node4
	wire			node4_node_valid;
	wire			node4_nodeinfo_valid;
	wire	[7:0]	node4_nodeinfo_priority;
	wire	[31:0]	node4_nodeinfo_memsize;
	wire			node4_node2master_busy;
	wire			node4_node2master_req;
	wire	[31:0]	node4_node2master_data;
	wire			node4_node2irq_req;
	wire			node4_io2dev_busy;
	wire			node4_io2dev_req;
	wire			node4_io2dev_rw;
	wire	[31:0]	node4_io2dev_addr;
	wire	[31:0]	node4_io2dev_data;
	wire			node4_io2dev_irq_busy;
	wire			node4_io2dev_irq_ack;			
	//State
	wire	[7:0]	state_current_nodeid;
	wire	[31:0]	state_current_addr;	
	wire			state_req_condition;
	wire			state_current_req;
	//State Wait
	reg				b_receive_wait;
	reg				b_transmit_wait;
	//IO>DEVICE
	reg				b_node_req;
	reg		[7:0]	b_node_id;
	reg		[31:0]	b_node_addr;
	reg		[31:0]	b_node_data;
	reg				b_rw;			//1:Write | 0:Read
	//Recieve
	reg		[31:0]	b_node_rdata;
	//IRQ Pryority
	wire			node1_irq2node_ack;
	wire			node2_irq2node_ack;
	wire			node3_irq2node_ack;
	wire			node4_irq2node_ack;
	wire			irq_queue_out_req;
	wire	[5:0]	irq_queue_out_num;
	wire			node_irq_busy;
	//Master Special memory
	wire			master_smem_valid;
	wire	[31:0]	master_smem_data;	
	//
	
	/************************************************************
	Node Info
	************************************************************/	
	reg				b_node1_nodeinfo_valid;
	reg		[7:0]	b_node1_nodeinfo_priority;
	reg		[31:0]	b_node1_nodeinfo_memsize;
	reg				b_node2_nodeinfo_valid;
	reg		[7:0]	b_node2_nodeinfo_priority;
	reg		[31:0]	b_node2_nodeinfo_memsize;
	reg				b_node3_nodeinfo_valid;
	reg		[7:0]	b_node3_nodeinfo_priority;
	reg		[31:0]	b_node3_nodeinfo_memsize;
	reg				b_node4_nodeinfo_valid;
	reg		[7:0]	b_node4_nodeinfo_priority;
	reg		[31:0]	b_node4_nodeinfo_memsize;
	
	wire			nodeinfo_all_received;
	assign			nodeinfo_all_received		=	(!node1_node_valid || b_node1_nodeinfo_valid) && (!node2_node_valid || b_node2_nodeinfo_valid) && 
													(!node3_node_valid || b_node3_nodeinfo_valid) && (!node4_node_valid || b_node4_nodeinfo_valid);

	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_node1_nodeinfo_valid		<=		1'b0;
			b_node1_nodeinfo_priority	<=		{8{1'b0}};
			b_node1_nodeinfo_memsize	<=		{32{1'b0}};
			b_node2_nodeinfo_valid		<=		1'b0;
			b_node2_nodeinfo_priority	<=		{8{1'b0}};
			b_node2_nodeinfo_memsize	<=		{32{1'b0}};
			b_node3_nodeinfo_valid		<=		1'b0;
			b_node3_nodeinfo_priority	<=		{8{1'b0}};
			b_node3_nodeinfo_memsize	<=		{32{1'b0}};
			b_node4_nodeinfo_valid		<=		1'b0;
			b_node4_nodeinfo_priority	<=		{8{1'b0}};
			b_node4_nodeinfo_memsize	<=		{32{1'b0}};
		end
		else begin
			//Node 1
			if(node1_nodeinfo_valid)begin
				if(b_node1_nodeinfo_valid)begin
					b_node1_nodeinfo_priority	<=		node1_nodeinfo_priority;
				end
				else begin
					b_node1_nodeinfo_valid		<=		1'b1;
					b_node1_nodeinfo_priority	<=		node1_nodeinfo_priority;
					b_node1_nodeinfo_memsize	<=		node1_nodeinfo_memsize;
				end
			end
			//Node 2
			if(node2_nodeinfo_valid)begin
				if(b_node2_nodeinfo_valid)begin
					b_node2_nodeinfo_priority	<=		node2_nodeinfo_priority;
				end
				else begin
					b_node2_nodeinfo_valid		<=		1'b1;
					b_node2_nodeinfo_priority	<=		node2_nodeinfo_priority;
					b_node2_nodeinfo_memsize	<=		node2_nodeinfo_memsize;
				end
			end
			//Node 3
			if(node3_nodeinfo_valid)begin
				if(b_node3_nodeinfo_valid)begin
					b_node3_nodeinfo_priority	<=		node3_nodeinfo_priority;
				end
				else begin
					b_node3_nodeinfo_valid		<=		1'b1;
					b_node3_nodeinfo_priority	<=		node3_nodeinfo_priority;
					b_node3_nodeinfo_memsize	<=		node3_nodeinfo_memsize;
				end
			end
			//Node 4
			if(node4_nodeinfo_valid)begin
				if(b_node4_nodeinfo_valid)begin
					b_node4_nodeinfo_priority	<=		node4_nodeinfo_priority;
				end
				else begin
					b_node4_nodeinfo_valid		<=		1'b1;
					b_node4_nodeinfo_priority	<=		node4_nodeinfo_priority;
					b_node4_nodeinfo_memsize	<=		node4_nodeinfo_memsize;
				end
			end
		end
	end //Node Info FF
	
	
	/************************************************************
	State
	************************************************************/	
	assign				{state_current_nodeid, state_current_addr}	
							=	funt_get_nodeid_and_addr(
								iCPU_ADDR, b_node1_nodeinfo_memsize, b_node2_nodeinfo_memsize, b_node3_nodeinfo_memsize, b_node4_nodeinfo_memsize
							);
	
	assign		state_req_condition		=		iCPU_REQ && 
												((iDEV1_VALID)? !iDEV1_BUSY : 1'b1) && 
												((iDEV2_VALID)? !iDEV2_BUSY : 1'b1) && 
												((iDEV3_VALID)? !iDEV3_BUSY : 1'b1) && 
												((iDEV4_VALID)? !iDEV4_BUSY : 1'b1);
	
	assign		state_current_req		=		func_get_currentreq(b_node_id, master_smem_valid, node1_node2master_req, node2_node2master_req, node3_node2master_req, node4_node2master_req);
	
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_receive_wait	<=			1'b0;
			b_transmit_wait	<=			1'b0;
			b_node_req		<=			1'b0;
			b_node_id		<=			{8{1'b0}};
			b_node_addr		<=			{32{1'b0}};
			b_node_data		<=			{32{1'b0}};
			b_rw			<=			1'b0;
			b_node_rdata	<=			{32{1'b0}};
		end
		else begin
			//Device Info Received (Init END)
			if(nodeinfo_all_received)begin	
				if(b_receive_wait)begin
					//Device Data Recieve Wait
					b_node_req		<=		1'b0;
					if(state_current_req)begin
						b_receive_wait	<=		1'b0;
						b_transmit_wait	<=		1'b1;
						b_node_rdata	<=		func_get_current_data(b_node_id, master_smem_data, node1_node2master_data, node2_node2master_data, node3_node2master_data, node4_node2master_data);
					end	
				end
				if(b_transmit_wait)begin
					//Processor Busy Wait
					if(!iCPU_BUSY)begin
						b_transmit_wait	<=		1'b0;
					end
				end
				else if(state_req_condition)begin
					//Device Reqest
					b_receive_wait	<=			1'b1;
					b_node_req		<=			1'b1;
					b_node_id		<=			state_current_nodeid;
					b_node_addr		<=			state_current_addr;
					b_node_data		<=			iCPU_DATA;
					b_rw			<=			iCPU_RW;
				end
			end
		end
	end //always
	
	function [31:0] func_get_current_data;
		input		[7:0]		func_nodeid;
		input		[31:0]		func_master_smem_data;
		input		[31:0]		func_node1_data;
		input		[31:0]		func_node2_data;
		input		[31:0]		func_node3_data;
		input		[31:0]		func_node4_data;
		begin
			case(func_nodeid)
				8'h00: func_get_current_data		=		func_master_smem_data;
				8'h01: func_get_current_data		=		func_node1_data;
				8'h02: func_get_current_data		=		func_node2_data;
				8'h03: func_get_current_data		=		func_node3_data;
				8'h04: func_get_current_data		=		func_node4_data;
				default : func_get_current_data		=		{32{1'b0}};
			endcase
		end
	endfunction
	
	

	function func_get_currentreq;
		input		[7:0]		func_nodeid;
		input					func_master_smem_req;
		input					func_node1_req;
		input					func_node2_req;
		input					func_node3_req;
		input					func_node4_req;
		begin
			case(func_nodeid)
				8'h00: func_get_currentreq		=		func_master_smem_req;
				8'h01: func_get_currentreq		=		func_node1_req;
				8'h02: func_get_currentreq		=		func_node2_req;
				8'h03: func_get_currentreq		=		func_node3_req;
				8'h04: func_get_currentreq		=		func_node4_req;
				default : func_get_currentreq		=		0;
			endcase
		end
	endfunction
	
	
	//NodeID & Device Address Get Function
	function [39:0] funt_get_nodeid_and_addr;
		input	[31:0]	func_reqest_addr;
		input	[31:0]	func_node1_usememsize;
		input	[31:0]	func_node2_usememsize;
		input	[31:0]	func_node3_usememsize;
		input	[31:0]	func_node4_usememsize;
		begin
			if(func_reqest_addr < 32'h400)begin
				funt_get_nodeid_and_addr		=		{8'h00, func_reqest_addr};
			end
			else if(func_reqest_addr < (func_node1_usememsize  + 32'h400))begin
				funt_get_nodeid_and_addr		=		{8'h01, func_reqest_addr  - 32'h400};
			end
			else if(func_reqest_addr < func_node1_usememsize + func_node2_usememsize  + 32'h400)begin
				funt_get_nodeid_and_addr		=		{8'h02, func_reqest_addr - func_node1_usememsize  - 32'h400};
			end
			else if(func_reqest_addr < func_node1_usememsize + func_node2_usememsize + func_node3_usememsize  + 32'h400)begin
				funt_get_nodeid_and_addr		=		{8'h03, func_reqest_addr - func_node1_usememsize - func_node2_usememsize  - 32'h400};
			end
			else if(func_reqest_addr < func_node1_usememsize + func_node2_usememsize + func_node3_usememsize + func_node4_usememsize  + 32'h400)begin
				funt_get_nodeid_and_addr		=		{8'h04, func_reqest_addr - func_node1_usememsize - func_node2_usememsize - func_node3_usememsize  - 32'h400};
			end
			else begin
				//$display("Node Address is Maximum Over Error (File & Module name is gci_master : funt_get_nodeid_and_addr)");
				funt_get_nodeid_and_addr		=		{40{1'b0}};
			end
		end
	endfunction //funt_get_nodeid_and_addr
	
	/************************************************************
	IRQ Priority
	************************************************************/
	gci_irq GCI_IRQ_MANAGER(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//IRQ Memory
		.iIRQ_CTRL_REQ(iIRQ_CTRL_REQ),
		.iIRQ_CTRL_ENTRY(iIRQ_CTRL_ENTRY),
		.iIRQ_CTRL_INFO_MASK(iIRQ_CTRL_INFO_MASK),
		.iIRQ_CTRL_INFO_VALID(iIRQ_CTRL_INFO_VALID),
		.iIRQ_CTRL_INFO_MODE(iIRQ_CTRL_INFO_MODE),
		//Node Info
		.iNODEINF_VALID(nodeinfo_all_received),
		.iNODE1_NODEINFO_PRIORITY(b_node1_nodeinfo_priority),
		.iNODE2_NODEINFO_PRIORITY(b_node2_nodeinfo_priority),
		.iNODE3_NODEINFO_PRIORITY(b_node3_nodeinfo_priority),
		.iNODE4_NODEINFO_PRIORITY(b_node4_nodeinfo_priority),
		//IRQ
		.iNODE_IRQ_BUSY(node_irq_busy),
		.iNODE1_IRQ(node1_node2irq_req),
		.oNODE1_ACK(node1_irq2node_ack),
		.iNODE2_IRQ(node2_node2irq_req),
		.oNODE2_ACK(node2_irq2node_ack),
		.iNODE3_IRQ(node3_node2irq_req),
		.oNODE3_ACK(node3_irq2node_ack),
		.iNODE4_IRQ(node4_node2irq_req),
		.oNODE4_ACK(node4_irq2node_ack),
		//IRQ Output
		.oIRQ_EMPTY(/*Not Use*/),
		.oIRQ_VALID(irq_queue_out_req),
		.oIRQ_NUM(irq_queue_out_num),
		.iIRQ_ACK(iCPU_IRQ_ACK)
	);
	
	/************************************************************
	Master Special Memory
	************************************************************/	
	gci_hub_specialmem GCI_MAIN_SMEM(
		.iREAD_REQ(b_node_id == 8'h00 && b_node_req),
		.iREAD_ADDR(b_node_addr[9:0]),
		.iNODE1_USEMEMSIZE(b_node1_nodeinfo_memsize),
		.iNODE1_PRIORITY(b_node1_nodeinfo_priority),
		.iNODE2_USEMEMSIZE(b_node2_nodeinfo_memsize),
		.iNODE2_PRIORITY(b_node2_nodeinfo_priority),
		.iNODE3_USEMEMSIZE(b_node3_nodeinfo_memsize),
		.iNODE3_PRIORITY(b_node3_nodeinfo_priority),
		.iNODE4_USEMEMSIZE(b_node4_nodeinfo_memsize),
		.iNODE4_PRIORITY(b_node4_nodeinfo_priority),
		.oDATA_VALID(master_smem_valid),
		.oDATA(master_smem_data)
	);
	
	
	/************************************************************
	Node 
	************************************************************/	
	gci_node #(1, 32) NODE1(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Node Valid
		.oNODE_VALID(node1_node_valid),
		//Node Info
		.oNODEINFO_VALID(node1_nodeinfo_valid),
		.oNODEINFO_PRIORITY(node1_nodeinfo_priority),
		.oNODEINFO_MEMSIZE(node1_nodeinfo_memsize),
		//MASTER
		.iMASTER_REQ(b_node_id == 8'h01 && b_node_req),		//Inpuit
		.oMASTER_BUSY(node1_node2master_busy),
		.iMASTER_RW(b_rw),
		.iMASTER_ADDR(b_node_addr),
		.iMASTER_DATA(b_node_data),
		.oMASTER_REQ(node1_node2master_req),				//Output
		.iMASTER_BUSY(1'b0),
		.oMASTER_DATA(node1_node2master_data),
		//MASTERIRQ
		.oMASTER_IRQ_REQ(node1_node2irq_req),
		.iMASTER_IRQ_ACK(node1_irq2node_ack),
		.iMASTER_IRQ_BUSY(node_irq_busy),
		//DEV
		.iDEV_VALID(iDEV1_VALID),
		.iDEV_REQ(iDEV1_REQ),								//Inpuit
		.oDEV_BUSY(node1_io2dev_busy),
		.iDEV_DATA(iDEV1_DATA),
		.oDEV_REQ(node1_io2dev_req),						//Output
		.iDEV_BUSY(iDEV1_BUSY),		
		.oDEV_RW(node1_io2dev_rw),
		.oDEV_ADDR(node1_io2dev_addr),
		.oDEV_DATA(node1_io2dev_data),
		//DEV-IRQ
		.iDEV_IRQ_REQ(iDEV1_IRQ_REQ),
		.oDEV_IRQ_BUSY(node1_io2dev_irq_busy),
		.iDEV_IRQ_DATA(iDEV1_IRQ_DATA),
		.oDEV_IRQ_ACK(node1_io2dev_irq_ack)
	);
	
	

	gci_node #(2, 32) NODE2(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Node Valid
		.oNODE_VALID(node2_node_valid),
		//Node Info
		.oNODEINFO_VALID(node2_nodeinfo_valid),
		.oNODEINFO_PRIORITY(node2_nodeinfo_priority),
		.oNODEINFO_MEMSIZE(node2_nodeinfo_memsize),
		//MASTER
		.iMASTER_REQ(b_node_id == 8'h02 && b_node_req),		//Inpuit
		.oMASTER_BUSY(node2_node2master_busy),
		.iMASTER_RW(b_rw),
		.iMASTER_ADDR(b_node_addr),
		.iMASTER_DATA(b_node_data),
		.oMASTER_REQ(node2_node2master_req),				//Output
		.iMASTER_BUSY(1'b0),
		.oMASTER_DATA(node2_node2master_data),
		//MASTERIRQ
		.oMASTER_IRQ_REQ(node2_node2irq_req),
		.iMASTER_IRQ_ACK(node2_irq2node_ack),
		.iMASTER_IRQ_BUSY(node_irq_busy),
		//DEV
		.iDEV_VALID(iDEV2_VALID),
		.iDEV_REQ(iDEV2_REQ),								//Inpuit
		.oDEV_BUSY(node2_io2dev_busy),
		.iDEV_DATA(iDEV2_DATA),
		.oDEV_REQ(node2_io2dev_req),						//Output
		.iDEV_BUSY(iDEV2_BUSY),		
		.oDEV_RW(node2_io2dev_rw),
		.oDEV_ADDR(node2_io2dev_addr),
		.oDEV_DATA(node2_io2dev_data),
		//DEV-IRQ
		.iDEV_IRQ_REQ(iDEV2_IRQ_REQ),
		.oDEV_IRQ_BUSY(node2_io2dev_irq_busy),
		.iDEV_IRQ_DATA(iDEV2_IRQ_DATA),
		.oDEV_IRQ_ACK(node2_io2dev_irq_ack)
	);
	
	
	gci_node #(3, 32) NODE3(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Node Valid
		.oNODE_VALID(node3_node_valid),
		//Node Info
		.oNODEINFO_VALID(node3_nodeinfo_valid),
		.oNODEINFO_PRIORITY(node3_nodeinfo_priority),
		.oNODEINFO_MEMSIZE(node3_nodeinfo_memsize),
		//MASTER
		.iMASTER_REQ(b_node_id == 8'h03 && b_node_req),		//Inpuit
		.oMASTER_BUSY(node3_node2master_busy),
		.iMASTER_RW(b_rw),
		.iMASTER_ADDR(b_node_addr),
		.iMASTER_DATA(b_node_data),
		.oMASTER_REQ(node3_node2master_req),				//Output
		.iMASTER_BUSY(1'b0),
		.oMASTER_DATA(node3_node2master_data),
		//MASTERIRQ
		.oMASTER_IRQ_REQ(node3_node2irq_req),
		.iMASTER_IRQ_ACK(node3_irq2node_ack),
		.iMASTER_IRQ_BUSY(node_irq_busy),
		//DEV
		.iDEV_VALID(iDEV3_VALID),
		.iDEV_REQ(iDEV3_REQ),								//Inpuit
		.oDEV_BUSY(node3_io2dev_busy),
		.iDEV_DATA(iDEV3_DATA),
		.oDEV_REQ(node3_io2dev_req),						//Output
		.iDEV_BUSY(iDEV3_BUSY),		
		.oDEV_RW(node3_io2dev_rw),
		.oDEV_ADDR(node3_io2dev_addr),
		.oDEV_DATA(node3_io2dev_data),
		//DEV-IRQ
		.iDEV_IRQ_REQ(iDEV3_IRQ_REQ),
		.oDEV_IRQ_BUSY(node3_io2dev_irq_busy),
		.iDEV_IRQ_DATA(iDEV3_IRQ_DATA),
		.oDEV_IRQ_ACK(node3_io2dev_irq_ack)
	);
	
	
	gci_node #(4, 32) NODE4(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		//Node Valid
		.oNODE_VALID(node4_node_valid),
		//Node Info
		.oNODEINFO_VALID(node4_nodeinfo_valid),
		.oNODEINFO_PRIORITY(node4_nodeinfo_priority),
		.oNODEINFO_MEMSIZE(node4_nodeinfo_memsize),
		//MASTER
		.iMASTER_REQ(b_node_id == 8'h04 && b_node_req),		//Inpuit
		.oMASTER_BUSY(node4_node2master_busy),
		.iMASTER_RW(b_rw),
		.iMASTER_ADDR(b_node_addr),
		.iMASTER_DATA(b_node_data),
		.oMASTER_REQ(node4_node2master_req),				//Output
		.iMASTER_BUSY(1'b0),
		.oMASTER_DATA(node4_node2master_data),
		//MASTERIRQ
		.oMASTER_IRQ_REQ(node4_node2irq_req),
		.iMASTER_IRQ_ACK(node4_irq2node_ack),
		.iMASTER_IRQ_BUSY(node_irq_busy),
		//DEV
		.iDEV_VALID(iDEV4_VALID),
		.iDEV_REQ(iDEV4_REQ),								//Inpuit
		.oDEV_BUSY(node4_io2dev_busy),
		.iDEV_DATA(iDEV4_DATA),
		.oDEV_REQ(node4_io2dev_req),						//Output
		.iDEV_BUSY(iDEV4_BUSY),		
		.oDEV_RW(node4_io2dev_rw),
		.oDEV_ADDR(node4_io2dev_addr),
		.oDEV_DATA(node4_io2dev_data),
		//DEV-IRQ
		.iDEV_IRQ_REQ(iDEV4_IRQ_REQ),
		.oDEV_IRQ_BUSY(node4_io2dev_irq_busy),
		.iDEV_IRQ_DATA(iDEV4_IRQ_DATA),
		.oDEV_IRQ_ACK(node4_io2dev_irq_ack)
	);
	
	
	/************************************************************
	Module Assign
	************************************************************/	
	//CPU-DATA Input
	assign		oCPU_BUSY		=		b_receive_wait || !nodeinfo_all_received ||
											((iDEV1_VALID)? iDEV1_BUSY : 1'b0) || 
											((iDEV2_VALID)? iDEV2_BUSY : 1'b0) || 
											((iDEV3_VALID)? iDEV3_BUSY : 1'b0) || 
											((iDEV4_VALID)? iDEV4_BUSY : 1'b0);
	//CPU-DATA Output
	assign		oCPU_REQ		=		/*b_rw && */b_transmit_wait && 
											((iDEV1_VALID)? !iDEV1_BUSY : 1'b1) && 
											((iDEV2_VALID)? !iDEV2_BUSY : 1'b1) && 
											((iDEV3_VALID)? !iDEV3_BUSY : 1'b1) && 
											((iDEV4_VALID)? !iDEV4_BUSY : 1'b1);
											
											
	assign		oCPU_DATA		=		b_node_rdata;
	//CPU-IRQ
	assign		oCPU_IRQ_REQ	=		irq_queue_out_req;
	assign		oCPU_IRQ_NUM	=		irq_queue_out_num;
	//IO > Device
	assign		oDEV1_BUSY		=		node1_io2dev_busy;
	assign		oDEV1_IRQ_BUSY	=		node1_io2dev_irq_busy;
	assign		oDEV1_IRQ_ACK	=		node1_io2dev_irq_ack;
	assign		oDEV2_BUSY		=		node2_io2dev_busy;
	assign		oDEV2_IRQ_BUSY	=		node2_io2dev_irq_busy;
	assign		oDEV2_IRQ_ACK	=		node2_io2dev_irq_ack;
	assign		oDEV3_BUSY		=		node3_io2dev_busy;
	assign		oDEV3_IRQ_BUSY	=		node3_io2dev_irq_busy;
	assign		oDEV3_IRQ_ACK	=		node3_io2dev_irq_ack;
	assign		oDEV4_BUSY		=		node4_io2dev_busy;
	assign		oDEV4_IRQ_BUSY	=		node4_io2dev_irq_busy;
	assign		oDEV4_IRQ_ACK	=		node4_io2dev_irq_ack;
	//Device > IO	
	assign		oDEV1_REQ		=		node1_io2dev_req;
	assign		oDEV1_RW		=		node1_io2dev_rw;
	assign		oDEV1_ADDR		=		node1_io2dev_addr;
	assign		oDEV1_DATA		=		node1_io2dev_data;
	assign		oDEV2_REQ		=		node2_io2dev_req;
	assign		oDEV2_RW		=		node2_io2dev_rw;
	assign		oDEV2_ADDR		=		node2_io2dev_addr;
	assign		oDEV2_DATA		=		node2_io2dev_data;
	assign		oDEV3_REQ		=		node3_io2dev_req;
	assign		oDEV3_RW		=		node3_io2dev_rw;
	assign		oDEV3_ADDR		=		node3_io2dev_addr;
	assign		oDEV3_DATA		=		node3_io2dev_data;
	assign		oDEV4_REQ		=		node4_io2dev_req;
	assign		oDEV4_RW		=		node4_io2dev_rw;
	assign		oDEV4_ADDR		=		node4_io2dev_addr;
	assign		oDEV4_DATA		=		node4_io2dev_data;
	
	
endmodule


`default_nettype wire

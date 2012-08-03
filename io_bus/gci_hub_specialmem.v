
`default_nettype none


module gci_hub_specialmem(
							input					iREAD_REQ,
							input	[9:0]			iREAD_ADDR,
							//GCI_NODE1
							input	[31:0]			iNODE1_USEMEMSIZE,
							input	[7:0]			iNODE1_PRIORITY,
							//GCI_NODE2
							input	[31:0]			iNODE2_USEMEMSIZE,
							input	[7:0]			iNODE2_PRIORITY,
							//GCI_NODE3
							input	[31:0]			iNODE3_USEMEMSIZE,
							input	[7:0]			iNODE3_PRIORITY,
							//GCI_NODE4
							input	[31:0]			iNODE4_USEMEMSIZE,
							input	[7:0]			iNODE4_PRIORITY,
							//Output
							output					oDATA_VALID,
							output	[31:0]			oDATA
	);
	

	function [31:0] func_master_specialmem;
		input	[9:0]	func_addr;
		input	[31:0]	func_node1_usemem;
		input	[7:0]	func_node1_priority;
		input	[31:0]	func_node2_usemem;
		input	[7:0]	func_node2_priority;
		input	[31:0]	func_node3_usemem;
		input	[7:0]	func_node3_priority;
		input	[31:0]	func_node4_usemem;
		input	[7:0]	func_node4_priority;
		begin
			case(func_addr)
				10'h0:
					func_master_specialmem		=		32'h4;
				10'h4:
					func_master_specialmem		=		func_node1_usemem + func_node2_usemem + func_node3_usemem + func_node4_usemem + 32'h400;
				10'h100:
					func_master_specialmem		=		func_node1_usemem;
				10'h104:
					func_master_specialmem		=		{24'h0, func_node1_priority};
				10'h120:
					func_master_specialmem		=		func_node2_usemem;
				10'h124:
					func_master_specialmem		=		{24'h0, func_node2_priority};
				10'h140:
					func_master_specialmem		=		func_node3_usemem;
				10'h144:
					func_master_specialmem		=		{24'h0, func_node3_priority};
				10'h160:
					func_master_specialmem		=		func_node4_usemem;
				10'h164:
					func_master_specialmem		=		{24'h0, func_node4_priority};
				default:
					begin	
						func_master_specialmem		=		{32{1'b0}};
						//$display("GCI-Master Special Memory : Request Error");
					end
			endcase
		end
	endfunction
	
	assign		oDATA_VALID		=		iREAD_REQ;
	assign		oDATA			=		func_master_specialmem(iREAD_ADDR, iNODE1_USEMEMSIZE, iNODE1_USEMEMSIZE, iNODE2_USEMEMSIZE, iNODE2_USEMEMSIZE, iNODE3_USEMEMSIZE, iNODE3_USEMEMSIZE, iNODE4_USEMEMSIZE, iNODE4_USEMEMSIZE);	
	
	
endmodule



`default_nettype wire

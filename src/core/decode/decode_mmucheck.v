

`include "core.h"
`default_nettype none			

module decode_mmucheck(
		input wire iPAGING_ENA,
		input wire iKERNEL_ACCESS,
		input wire [13:0] iMMU_FLAGS,
		output wire [2:0] oIRQ40,
		output wire [2:0] oIRQ41,
		output wire [2:0] oIRQ42
	);


	/*************************************************
	MMU Flag Check
	[0]	:	IRQ40 Invalid page.(Page fault)
	[1]	:	IRQ41 Privilege error.(Page)
	[2]	:	IRQ42 Invalid instruction.(Page)
	*************************************************/
	function [2:0] func_mmu_flags_fault_check;
		input func_paging;
		input func_kernel;				//1:kernel mode
		input [5:0] func_mmu_flags;
		begin
			if(func_paging)begin
				//Page fault check
				if(!func_mmu_flags[0])begin
					func_mmu_flags_fault_check = 3'h1;
				end
				//Invalid instruction check
				if(!func_mmu_flags[3])begin
					func_mmu_flags_fault_check = 3'h4;
				end
				//Privilege error check
				else begin
					//Page check
					if(func_kernel)begin			//Kernell Mode
						func_mmu_flags_fault_check = 3'h0;
					end
					else begin	//User Mode
						if(func_mmu_flags[5:4] != 2'h0)begin
							func_mmu_flags_fault_check = 3'h0;
						end
						else begin
							func_mmu_flags_fault_check = 3'h2;	//Privilege Error
						end
					end
				end
			end
			else begin
				func_mmu_flags_fault_check = 3'h0;
			end
		end
	endfunction

	assign {oIRQ42, oIRQ41, oIRQ40} = func_mmu_flags_fault_check(iPAGING_ENA, iKERNEL_ACCESS, iMMU_FLAGS[5:0]);

endmodule


`default_nettype wire 



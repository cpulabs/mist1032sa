

`include "core.h"
`default_nettype none			

module decode_authcheck(
		input wire [31:0] iINSTRUCTION,
		input wire iKERNEL_ACCESS,
		input wire [13:0] iMMU_FLAGS,
		output wire [2:0] oIRQ41
	);

	/*************************************************
	Instruction Check
	[0]	:	IRQ41 Privilege error.(Page)
	*************************************************/
	function func_instruction_fault_check;
		input [31:0] func_instruction;
		input func_kernel;				//[1]Kernel
		input [5:0] func_mmu_flags;
		begin
			if(func_kernel)begin			//Kernell Mode
				func_instruction_fault_check = 1'b0;
			end
			else begin
				case(func_instruction[30:21])
					`FAULT_INSTRUCTION_SRTISR,
					`FAULT_INSTRUCTION_SRKPDTR,
					`FAULT_INSTRUCTION_SRPDTW,
					`FAULT_INSTRUCTION_SRIEIW,
					`FAULT_INSTRUCTION_SRTISW,
					`FAULT_INSTRUCTION_SRKPDTW,
					`FAULT_INSTRUCTION_SRMMUW,
					`FAULT_INSTRUCTION_HALT,
					`FAULT_INSTRUCTION_IDTS	:	func_instruction_fault_check = 1'b1;
					default					:	func_instruction_fault_check = 1'b0;
				endcase
			end
		end
	endfunction

	assign oIRQ41 = func_instruction_fault_check(iINSTRUCTION, iKERNEL_ACCESS, iMMU_FLAGS[5:0]);

endmodule



`default_nettype wire 



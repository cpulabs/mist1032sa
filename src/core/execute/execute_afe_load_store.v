
`include "core.h"
`default_nettype none


module execute_afe_load_store(
		//AFE-Conrtol
		input wire [3:0] iAFE_CODE,
		//Data-In/Out
		input wire [31:0] iDATA,
		output wire [31:0] oDATA
	);


	function [31:0] func_afe;
		input [3:0] func_afe_code;
		input [31:0] func_data;
		begin
			case(func_afe_code)
				`AFE_LDST_NONE : func_afe = func_data;
				`AFE_LDST_SEXT8_32 : func_afe = {{24{func_data[7]}}, func_data[7:0]};
				`AFE_LDST_SEXT16_32 : func_afe = {{16{func_data[15]}}, func_data[15:0]};
				default : func_afe = func_data;
			endcase
		end
	endfunction
	
	
	assign oDATA = func_afe(iAFE_CODE, iDATA);
	
endmodule

`default_nettype wire 


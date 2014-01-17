

`include "core.h"
`default_nettype none
 
 
 
 module execute_sys_reg(
		input wire [4:0] iCMD,
		input wire [31:0] iSOURCE0,
		input wire [31:0] iSOURCE1,
		output wire [31:0] oOUT
	);
	

	reg [31:0] w_out;	
	//Combination Logic
	always @* begin
		case(iCMD)
			`EXE_SYS_REG_BUFFER0 : w_out = iSOURCE0;
			`EXE_SYS_REG_BUFFER1 : w_out = iSOURCE1;
			`EXE_SYS_REG_SR1_MMUMOD_R : w_out = {30'h0, iSOURCE0[1:0]};
			`EXE_SYS_REG_SR1_IM_R : w_out = {31'h0, iSOURCE0[2]};
			`EXE_SYS_REG_SR1_CMOD_R : w_out = {30'h0, iSOURCE0[6:5]};
			
			`EXE_SYS_REG_SR1_MMUMOD_W : w_out = {iSOURCE0[31:2], iSOURCE1[1:0]};
			`EXE_SYS_REG_SR1_IM_W : w_out = {iSOURCE0[31:3], iSOURCE1[0], iSOURCE0[1:0]};
			`EXE_SYS_REG_SR1_CMOD_W : w_out = {iSOURCE0[31:7], iSOURCE1[1:0], iSOURCE0[4:0]};
			default	:	
				begin
					w_out = iSOURCE0;
				end
		endcase
	end
	
	assign oOUT = w_out;
	
endmodule


`default_nettype wire


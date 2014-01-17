/****************************************
Load Store
for MIST32 Processor

Takahiro Ito @cpu_labs
****************************************/

`default_nettype none
`include "core.h"


module execute_load_store(
		//Prev
		input wire [4:0] iCMD,
		input wire iLOADSTORE_MODE,		//0:SYS_LDST | 1:LDST
		input wire [31:0] iSOURCE0,
		input wire [31:0] iSOURCE1,
		input wire iADV_ACTIVE,
		input wire [31:0] iADV_DATA,
		input wire [31:0] iSPR,
		input wire [31:0] iPC,
		//Output - Writeback
		output wire oOUT_SPR_VALID,
		output wire [31:0] oOUT_SPR,
		output wire [31:0] oOUT_DATA,
		//Output - LDST Pipe
		output wire oLDST_RW,
		output wire [31:0] oLDST_ADDR,
		output wire [31:0] oLDST_DATA,
		output wire [1:0] oLDST_ORDER,
		output wire [1:0] oLOAD_SHIFT,		
		output wire [3:0] oLOAD_MASK		//2bit -> 4bit
	);
	
	function [3:0] func_bytemask;
		input [1:0] func_order;
		input [1:0] func_address;
		begin
			case(func_order)
				2'h0 : 
					begin
						if(func_address[1:0] == 2'h0)begin
							func_bytemask = 4'b0001;
						end
						else if(func_address[1:0] == 2'h1)begin
							func_bytemask = 4'b0010;
						end
						else if(func_address[1:0] == 2'h2)begin
							func_bytemask = 4'b0100;
						end
						else begin
							func_bytemask = 4'b1000;
						end
					end
				2'h1 : 	
					begin
						if(func_address[1:0] == 2'h0)begin
							func_bytemask = 4'b0011;
						end
						else if(func_address[1:0] == 2'h2)begin
							func_bytemask = 4'b1100;
						end
						else begin
							func_bytemask = 4'b0000;
						end
					end
				2'h2 : 
					begin
						func_bytemask = 4'b1111;
					end
				default:
					begin
						func_bytemask = 4'b0000;
					end
			endcase
		end
	endfunction
	
	function [31:0] func_store_data8;
		input [1:0] func_shift;
		input [31:0] func_data;
		begin
			case(func_shift)
				2'h0 : func_store_data8 = {24'h0, func_data[7:0]};
				2'h1 : func_store_data8 = {16'h0, func_data[7:0], 8'h0};
				2'h2 : func_store_data8 = {8'h0, func_data[7:0], 16'h0};
				2'h3 : func_store_data8 = {func_data[7:0], 24'h0};
			endcase
		end
	endfunction
	
	
	function [31:0] func_store_data16;
		input [1:0] func_shift;
		input [31:0] func_data;
		begin
			case(func_shift)
				2'h0 : func_store_data16 = {16'h0, func_data[15:0]};
				2'h2 : func_store_data16 = {func_data[15:0], 16'h0};
				default : func_store_data16 = 32'hxxxxxxxx;
			endcase
		end
	endfunction
	
			

	reg spr_valid;
	reg [31:0] spr;
	reg [31:0] data;
	reg [31:0] ldst_addr;
	reg [31:0] ldst_data;
	reg ldst_rw;
	reg [1:0] ldst_order;
	reg [3:0] ldst_load_mask;
	reg [1:0] ldst_load_shift;
	always @* begin
		if(iLOADSTORE_MODE)begin
			case(iCMD)
				`EXE_LDSW_LD8:
					begin
						spr_valid = 1'b0;
						spr = iSPR;	
						data = 32'h0;
						ldst_addr = iSOURCE1;
						ldst_data = iSOURCE0;
						ldst_rw = 1'b0;
						ldst_order = 2'h0;
						ldst_load_mask = func_bytemask(2'h0, iSOURCE1[1:0]);
						ldst_load_shift = iSOURCE1[1:0];
					end
				`EXE_LDSW_LD16:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1;
						ldst_data = iSOURCE0;
						ldst_rw = 1'b0;
						ldst_order = 2'h1;
						ldst_load_mask = func_bytemask(2'h1, iSOURCE1[1:0]);
						ldst_load_shift = (iSOURCE1[1:0] == 2'h0)? 2'h0 : 2'h2;//2'h3 - iSOURCE1[1:0];
					end
				`EXE_LDSW_LD32:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1;
						ldst_data = iSOURCE0;
						ldst_rw = 1'b0;
						ldst_order = 2'h2;
						ldst_load_mask = func_bytemask(2'h2, iSOURCE1[1:0]);
						ldst_load_shift = 2'h0;
					end
				`EXE_LDSW_ST8:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1;
						ldst_data = func_store_data8(iSOURCE1[1:0], iSOURCE0);//iSOURCE0;
						ldst_rw = 1'b1;
						ldst_order = 2'h0;
						ldst_load_mask = func_bytemask(2'h0, iSOURCE1[1:0]);
						ldst_load_shift = iSOURCE1[1:0];
					end
				`EXE_LDSW_ST16:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1;
						ldst_data = func_store_data16((iSOURCE1[1:0] == 2'h0)? 2'h0 : 2'h2, iSOURCE0);//iSOURCE0;
						ldst_rw = 1'b1;
						ldst_order = 2'h1;
						ldst_load_mask = func_bytemask(2'h1, iSOURCE1[1:0]);
						ldst_load_shift = (iSOURCE1[1:0] == 2'h0)? 2'h0 : 2'h2;
					end
				`EXE_LDSW_ST32:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1;
						ldst_data = iSOURCE0;
						ldst_rw = 1'b1;
						ldst_order = 2'h2;
						ldst_load_mask = func_bytemask(2'h2, iSOURCE1[1:0]);
						ldst_load_shift = 2'h0;
					end
				`EXE_LDSW_PUSH:
					begin
						spr_valid = 1'b1;
						spr = iSPR - 32'h4;		
						data = 32'h0;
						ldst_addr = iSPR - 32'h4;
						ldst_data = iSOURCE0;
						ldst_rw = 1'b1;
						ldst_order = 2'h2;
						ldst_load_mask = 4'hf;
						ldst_load_shift = 2'h0;
					end
				`EXE_LDSW_PPUSH:
					begin
						spr_valid = 1'b1;
						spr = iSPR - 32'h4;		
						data = 32'h0;
						ldst_addr = iSPR - 32'h4;
						ldst_data = iPC;
						ldst_rw = 1'b1;
						ldst_order = 2'h2;
						ldst_load_mask = 4'hf;
						ldst_load_shift = 2'h0;
					end
				`EXE_LDSW_POP:
					begin
						spr_valid = 1'b1;
						spr = iSPR + 32'h4;	
						data = 32'h0;	
						ldst_addr = iSPR;
						ldst_data = 32'h0;
						ldst_rw = 1'b0;
						ldst_order = 2'h2;
						ldst_load_mask = 4'hf;
						ldst_load_shift = 2'h0;
					end
				`EXE_LDSW_LDD8:
					begin
						spr_valid = 1'b0;
						spr = iSPR;	
						data = 32'h0;
						ldst_addr = iSOURCE1 + iADV_DATA;
						ldst_data = iSOURCE0;
						ldst_rw = 1'b0;
						ldst_order = 2'h0;
						ldst_load_mask = func_bytemask(2'h0, (iSOURCE1[1:0] + iADV_DATA[1:0]));
						ldst_load_shift = iSOURCE1[1:0] + iADV_DATA[1:0];
					end
				`EXE_LDSW_LDD16:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1 + {iADV_DATA, 1'b0};
						ldst_data = iSOURCE0;
						ldst_rw = 1'b0;
						ldst_order = 2'h1;
						ldst_load_mask = func_bytemask(2'h1, (iSOURCE1[1:0] + {iADV_DATA[0], 1'b0}));
						ldst_load_shift = (iSOURCE1[1:0] + {iADV_DATA[0], 1'b0} == 2'h0)? 2'h0 : 2'h2;//2'h3 - iSOURCE1[1:0];
					end
				`EXE_LDSW_LDD32:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1 + {iADV_DATA, 2'b00};
						ldst_data = iSOURCE0;
						ldst_rw = 1'b0;
						ldst_order = 2'h2;
						ldst_load_mask = func_bytemask(2'h2, iSOURCE1[1:0]);
						ldst_load_shift = 2'h0;
					end
				`EXE_LDSW_STD8:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1 + iADV_DATA;
						ldst_data = func_store_data8(iSOURCE1[1:0] + iADV_DATA[1:0], iSOURCE0);//iSOURCE0;
						ldst_rw = 1'b1;
						ldst_order = 2'h0;
						ldst_load_mask = func_bytemask(2'h0, (iSOURCE1[1:0] + iADV_DATA[1:0]));
						ldst_load_shift = iSOURCE1[1:0] + iADV_DATA[1:0];
					end
				`EXE_LDSW_STD16:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1 + {iADV_DATA, 1'b0};
						ldst_data = func_store_data16((iSOURCE1[1:0] + {iADV_DATA[0], 1'b0} == 2'h0)? 2'h0 : 2'h2, iSOURCE0);//iSOURCE0;
						ldst_rw = 1'b1;
						ldst_order = 2'h1;
						ldst_load_mask = func_bytemask(2'h1, (iSOURCE1[1:0] + {iADV_DATA[0], 1'b0}));
						ldst_load_shift = (iSOURCE1[1:0] + {iADV_DATA[0], 1'b0} == 2'h0)? 2'h0 : 2'h2;
					end
				`EXE_LDSW_STD32:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1 + {iADV_DATA, 2'b00};
						ldst_data = iSOURCE0;
						ldst_rw = 1'b1;
						ldst_order = 2'h2;
						ldst_load_mask = func_bytemask(2'h2, iSOURCE1[1:0]);
						ldst_load_shift = 2'h0;
					end
				default:
					begin
						spr_valid = 1'b0;
						spr = iSPR;		
						data = 32'h0;
						ldst_addr = iSOURCE1;
						ldst_data = 32'h0;
						ldst_rw = 1'b0;
						ldst_order = 2'h0;
						ldst_load_mask = 4'h0;
						ldst_load_shift = 2'h0;
					end
			endcase
		end
		//Sys Load / Store
		else begin
			case(iCMD)
				`EXE_SYS_LDST_READ_SPR:
					begin
						spr_valid = 1'b1;
						spr = iSPR;		
						data = iSPR;
						ldst_addr = iSOURCE1;
						ldst_data = iSPR;
						ldst_rw = 1'b0;
						ldst_order = 2'h2;
						ldst_load_mask = 4'h0;
						ldst_load_shift = 2'h0;
					end
				`EXE_SYS_LDST_WRITE_SPR:
					begin
						spr_valid = 1'b1;
						spr = iSOURCE0;			
						data = 32'h0;
						ldst_addr = iSOURCE0;
						ldst_data = iSOURCE0;
						ldst_rw = 1'b1;
						ldst_order = 2'h2;
						ldst_load_mask = 4'h0;
						ldst_load_shift = 2'h0;
					end
				//EXE_SYS_LDST_ADD_SPR
				default:
					begin
						spr_valid = 1'b1;
						spr = iSOURCE0 + iSOURCE1;			
						data = 32'h0;
						ldst_addr = iSOURCE0;
						ldst_data = iSOURCE0 + iSOURCE1;
						ldst_rw = 1'b1;
						ldst_order = 2'h2;
						ldst_load_mask = 4'h0;
						ldst_load_shift = 2'h0;
					end
			endcase
		end
	end
	
	
	assign oOUT_SPR_VALID = spr_valid;
	assign oOUT_SPR = spr;
	assign oOUT_DATA = data;
	//Output - LDST Pipe
	assign oLDST_RW = ldst_rw;
	assign oLDST_ADDR = ldst_addr;
	assign oLDST_DATA = ldst_data;
	assign oLDST_ORDER = ldst_order;
	assign oLOAD_SHIFT = ldst_load_shift;
	assign oLOAD_MASK = ldst_load_mask;
	
	
endmodule

`default_nettype wire


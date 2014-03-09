`default_nettype none

module execute_load_data(
		input wire [3:0] iMASK,
		input wire [1:0] iSHIFT,
		input wire [31:0] iDATA,
		output wire [31:0] oDATA
	);

	assign oDATA = func_load_fairing(
		iMASK,
		iSHIFT,
		iDATA
	);


	function [31:0] func_load_fairing;	
		input [3:0] func_mask;
		input [1:0] func_shift;
		input [31:0] func_data;
		reg [7:0] func_tmp0, func_tmp1, func_tmp2, func_tmp3;
		begin
			if(func_mask == 4'hf)begin
				func_load_fairing = func_data;
			end
			else if(func_mask == 4'b0001)begin
				func_load_fairing = {24'h0, func_data[31:24]};
			end
			else if(func_mask == 4'b0010)begin
				func_load_fairing = {24'h0, func_data[23:16]};
			end
			else if(func_mask == 4'b0100)begin
				func_load_fairing = {24'h0, func_data[15:8]};
			end
			else if(func_mask == 4'b1000)begin
				func_load_fairing = {24'h0, func_data[7:0]};
			end
			else if(func_mask == 4'b0011)begin
				func_load_fairing = {24'h0, func_data[31:16]};
			end
			else begin
			//else if(func_mask == 4'b1100)begin
				func_load_fairing = {24'h0, func_data[15:0]};
			end
		end
	endfunction
	


endmodule

`default_nettype wire 



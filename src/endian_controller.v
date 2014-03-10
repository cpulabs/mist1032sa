
`default_nettype none 



module endian_controller(
		//Source
		input wire [3:0] iSRC_MASK,
		input wire [31:0] iSRC_DATA,
		//Destnation
		output wire [3:0] oDEST_MASK,
		output wire [31:0] oDEST_DATA
	);

	
	/*
	assign oDEST_MASK = func_bytemask({iSRC_MASK[0], iSRC_MASK[1], iSRC_MASK[2], iSRC_MASK[3]});
	assign oDEST_DATA = func_data(
							{iSRC_MASK[0], iSRC_MASK[1], iSRC_MASK[2], iSRC_MASK[3]}, 
							{iSRC_DATA[7:0], iSRC_DATA[15:8], iSRC_DATA[23:16], iSRC_DATA[31:24]}
						);
	*/
	assign oDEST_MASK = iSRC_MASK;
	assign oDEST_DATA = func_data(iSRC_MASK, iSRC_DATA);
	

	/*
	function [3:0] func_bytemask;
		input [3:0] func_little_bytemask;
		begin
			if(func_little_bytemask == 4'hf)begin
				func_bytemask = 4'hf;
			end
			else if(func_little_bytemask == 4'h3 || func_little_bytemask == 4'hc)begin
				func_bytemask = ~func_little_bytemask;
			end
			else if(func_little_bytemask == 4'b0001)begin
				func_bytemask = 4'b1000;
			end
			else if(func_little_bytemask == 4'b0010)begin
				func_bytemask = 4'b0100;
			end
			else if(func_little_bytemask == 4'b0100)begin
				func_bytemask = 4'b0010;
			end
			//else if(func_little_bytemask == 4'b10000)begin
			else begin
				func_bytemask = 4'b0001;
			end
		end
	endfunction
	*/
	
	function [31:0] func_data;
		input [3:0] func_little_bytemask;
		input [31:0] func_src_data; 
		begin
			if(func_little_bytemask == 4'hf)begin
				func_data = {func_src_data[7:0], func_src_data[15:8], func_src_data[23:16], func_src_data[31:24]};
			end
			
			else if(func_little_bytemask == 4'b0011)begin
				//func_data = {16'h0, func_src_data[7:0], func_src_data[15:8]};
				func_data = {16'h0, func_src_data[7:0], func_src_data[15:8]};
			end
			else if(func_little_bytemask == 4'b1100)begin
				//func_data = {func_src_data[7:0], func_src_data[15:8], 16'h0};
				func_data = {func_src_data[23:16], func_src_data[31:24], 16'h0};
			end

			else if(func_little_bytemask == 4'b0001)begin
				func_data = {24'h0, func_src_data[7:0]};
			end
			else if(func_little_bytemask == 4'b0010)begin
				func_data = {16'h0, func_src_data[15:8], 8'h0};
			end
			else if(func_little_bytemask == 4'b0100)begin
				func_data = {8'h0, func_src_data[23:16], 16'h0};
			end
			//else if(func_little_bytemask == 4'b10000)begin
			else begin
				func_data = {func_src_data[31:24], 24'h0};
			end
		end
	endfunction
endmodule


`default_nettype wire 

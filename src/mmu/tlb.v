/*
	Way				:	4Way Set Assicatiev
	Purging			:	Write Through Algorithm
	1Page			:	16KByte
	Line Size		:	2Word
	
	
	
	
*/

`include "processor.h"
`default_nettype none	
	
	
module tlb
	#(
		parameter LRU_TIMER_N = 10
	)(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Core Info
		input wire iREMOVE,			
		//Read
		input wire iRD_REQ,
		input wire [31:0] iRD_ADDR,	//[31:14]Tag([31:17]Address Tag | [16:15]Index | [14]Line:none) | [13:0]None
		output wire oRD_VALID,
		output wire oRD_HIT,
		output wire [27:0] oRD_FLAGS,
		output wire [63:0] oRD_PHYS_ADDR,
		//Write
		input wire iWR_REQ,
		input wire [31:0] iWR_ADDR,
		input wire [27:0] iWR_FLAGS,			
		input wire [63:0] iWR_PHYS_ADDR
	);
				
				
	/********************************************
	Register and Wire
	********************************************/
	//Output Buffer
	reg b_rd_hit;
	reg [6:0] b_rd_way;
	reg [1:0] b_rd_index;
	//Memory Control
	wire [1:0] write_index;
	wire [1:0] write_way;
	wire [1:0] read_index;
	wire read_hit;
	wire [1:0] read_way;
	wire this_read_lock;
	//Generate
	integer i;
	//Memory Cell
	/*
	reg		[1:0]	b_status0[0:3];		//0:Non Valid
	reg		[1:0]	b_status1[0:3];
	reg		[1:0]	b_status2[0:3];
	reg		[1:0]	b_status3[0:3];
	reg		[24:0]	b_tag0[0:3];	//TaskID:14bit | AddressTag:11bit
	reg		[24:0]	b_tag1[0:3];	
	reg		[24:0]	b_tag2[0:3];
	reg		[24:0]	b_tag3[0:3];
	reg		[17:0]	b_data0[0:3];
	reg		[17:0]	b_data1[0:3];
	reg		[17:0]	b_data2[0:3];
	reg		[17:0]	b_data3[0:3];
	reg		[13:0]	b_flags0[0:3];
	reg		[13:0]	b_flags1[0:3];
	reg		[13:0]	b_flags2[0:3];
	reg		[13:0]	b_flags3[0:3];
	*/
	reg [1:0] b_status0[0:3]; //0:Non Valid
	reg [1:0] b_status1[0:3];
	reg [1:0] b_status2[0:3];
	reg [1:0] b_status3[0:3];
	reg [14:0] b_tag0[0:3];	//AddressTag:15bit
	reg [14:0] b_tag1[0:3];	
	reg [14:0] b_tag2[0:3];
	reg [14:0] b_tag3[0:3];
	reg [35:0] b_data0[0:3]; //Real Address Index(2Line)
	reg [35:0] b_data1[0:3];
	reg [35:0] b_data2[0:3];
	reg [35:0] b_data3[0:3];
	reg [27:0] b_flags0[0:3]; //MMU Flag 14bit(2Line)
	reg [27:0] b_flags1[0:3];
	reg [27:0] b_flags2[0:3];
	reg [27:0] b_flags3[0:3];
	
	//Memory CELL Contoroll
	reg b_load_req_valid;	
	//LRU Controll
	wire lru_valid;
	
	/********************************************
	Output Buffer
	********************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_rd_hit <= 1'h0;
			b_rd_way <= 2'h0;
			b_rd_index <= 2'h0;
		end
		else begin
			if(!this_read_lock)begin
				b_rd_hit <= read_hit;
				b_rd_way <= read_way;
				b_rd_index <= read_index;
			end
		end
	end
	
	
	/********************************************
	Controll
	********************************************/
	assign write_index = iWR_ADDR[16:15];
	
	assign write_way = func_write_way_search(b_status0[write_index], b_status1[write_index], b_status2[write_index], b_status3[write_index]);
	assign read_index = iRD_ADDR[1:0];
	assign {read_hit, read_way}	= func_hit_check(
													iRD_ADDR[31:17],
													b_status0[read_index],
													b_status1[read_index],
													b_status2[read_index],
													b_status3[read_index],
													b_tag0[read_index],
													b_tag1[read_index],
													b_tag2[read_index],
													b_tag3[read_index]
												);
				
	assign this_read_lock = 1'b0;
	
	/********************************************
	Function
	********************************************/
	//Hit Check
	function [2:0] func_hit_check;	//[2]:Hit  |  [1:0] Hit Way
		input [15:0] func_request_tag;
		input [1:0] func_way0_status;
		input [1:0] func_way1_status;
		input [1:0] func_way2_status;
		input [1:0] func_way3_status;
		input [14:0] func_way0_tag;
		input [14:0] func_way1_tag;
		input [14:0] func_way2_tag;
		input [14:0] func_way3_tag;
		begin
			if(func_way0_status != 2'h0 && func_way0_tag == func_request_tag)begin
				func_hit_check = {1'b1, 2'h0};
			end
			else if(func_way1_status != 2'h0 && func_way1_tag == func_request_tag)begin
				func_hit_check = {1'b1, 2'h1};
			end
			else if(func_way2_status != 2'h0 && func_way2_tag == func_request_tag)begin
				func_hit_check = {1'b1, 2'h2};
			end
			else if(func_way3_status != 2'h0 && func_way3_tag == func_request_tag)begin
				func_hit_check = {1'b1, 2'h3};
			end
			else begin
				func_hit_check = 3'h0;
			end
		end
	endfunction
		
	
	//Low Pryority Line Search
	function [1:0] func_write_way_search;
		input [1:0] way0_status;
		input [1:0] way1_status;
		input [1:0] way2_status;
		input [1:0] way3_status;
		begin
			if(way0_status == 2'h0)
				func_write_way_search = 2'h0;
			else if(way1_status == 2'h0)
				func_write_way_search = 2'h1;
			else if(way2_status == 2'h0)
				func_write_way_search = 2'h2;
			else if(way3_status == 2'h0)
				func_write_way_search = 2'h3;
			else if(way0_status == 2'h1)
				func_write_way_search = 2'h0;
			else if(way1_status == 2'h1)
				func_write_way_search = 2'h1;
			else if(way2_status == 2'h1)
				func_write_way_search = 2'h2;
			else if(way3_status == 2'h1)
				func_write_way_search = 2'h3;
			else if(way0_status == 2'h2)
				func_write_way_search = 2'h0;
			else if(way1_status == 2'h2)
				func_write_way_search = 2'h1;
			else if(way2_status == 2'h2)
				func_write_way_search = 2'h2;
			else if(way3_status == 2'h2)
				func_write_way_search = 2'h3;
			else
				func_write_way_search = 2'h3;
		end
	endfunction
	

	
	/********************************************
	Tag Pryority & Tag Control
	********************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 4; i = i + 1)begin
				b_status0[i] <= {2{1'b0}};
				b_status1[i] <= {2{1'b0}};
				b_status2[i] <= {2{1'b0}};
				b_status3[i] <= {2{1'b0}};
				if(`PROCESSOR_DATA_RESET_EN)begin
					b_tag0[i] <= {15{1'b0}};
					b_tag1[i] <= {15{1'b0}};
					b_tag2[i] <= {15{1'b0}};
					b_tag3[i] <= {15{1'b0}};
					b_data0[i] <= {36{1'b0}};
					b_data1[i] <= {36{1'b0}};
					b_data2[i] <= {36{1'b0}};
					b_data3[i] <= {36{1'b0}};
					b_flags0[i] <= {28{1'b0}};
					b_flags1[i] <= {28{1'b0}};
					b_flags2[i] <= {28{1'b0}};
					b_flags3[i] <= {28{1'b0}};
				end
			end
			b_load_req_valid <= 1'b0;
		end
		else if(iREMOVE)begin
			for(i = 0; i < 4; i = i + 1)begin
				b_status0[i] <= {2{1'b0}};
				b_status1[i] <= {2{1'b0}};
				b_status2[i] <= {2{1'b0}};
				b_status3[i] <= {2{1'b0}};
				if(`PROCESSOR_DATA_RESET_EN)begin
					b_tag0[i] <= {15{1'b0}};
					b_tag1[i] <= {15{1'b0}};
					b_tag2[i] <= {15{1'b0}};
					b_tag3[i] <= {15{1'b0}};
					b_data0[i] <= {36{1'b0}};
					b_data1[i] <= {36{1'b0}};
					b_data2[i] <= {36{1'b0}};
					b_data3[i] <= {36{1'b0}};
					b_flags0[i] <= {28{1'b0}};
					b_flags1[i] <= {28{1'b0}};
					b_flags2[i] <= {28{1'b0}};
					b_flags3[i] <= {28{1'b0}};
				end
			end
			b_load_req_valid <= 1'b0;
		end
		else begin
			//Write
			if(iWR_REQ)begin
				(* full_case *)case(write_way)
					2'h0:	
						begin
							b_status0[write_index] <= 2'b11;
							b_tag0[write_index] <= iWR_ADDR[31:17];
							b_data0[write_index] <= {iWR_PHYS_ADDR[63:49], iWR_PHYS_ADDR[31:17]};
							b_flags0[write_index] <= iWR_FLAGS;
						end
					2'h1:
						begin
							b_status1[write_index] <= 2'b11;
							b_tag1[write_index] <= iWR_ADDR[31:17];
							b_data1[write_index] <= {iWR_PHYS_ADDR[63:49], iWR_PHYS_ADDR[31:17]};
							b_flags1[write_index] <= iWR_FLAGS;
						end
					2'h2:	
						begin
							b_status2[write_index] <= 2'b11;
							b_tag2[write_index] <= iWR_ADDR[31:17];
							b_data2[write_index] <= {iWR_PHYS_ADDR[63:49], iWR_PHYS_ADDR[31:17]};
							b_flags2[write_index] <= iWR_FLAGS;
						end
					2'h3:	
						begin
							b_status3[write_index] <= 2'b11;
							b_tag3[write_index] <= iWR_ADDR[31:17];
							b_data3[write_index] <= {iWR_PHYS_ADDR[63:49], iWR_PHYS_ADDR[31:17]};
							b_flags3[write_index] <= iWR_FLAGS;
						end
				endcase
			end
			
			//Request Valid
			if(!this_read_lock)begin
				b_load_req_valid <= iRD_REQ;
			end

			//Read & LRU Controal
			if(!this_read_lock)begin
				if(iRD_REQ && read_hit && lru_valid)begin
					for(i = 0; i < 4; i = i + 1)begin
						//TAG0
						if(read_index == i[1:0] && read_way == 2'h0)begin
							b_status0[read_index] <= 2'b11;
						end
						else begin
							if(b_status0[i] != 2'h0 && b_status0[i] != 2'h1)begin
								b_status0[i] <= b_status0[i] - 2'h1;
							end
						end
						//TAG1
						if(read_index == i[1:0] && read_way == 2'h1)begin
							b_status1[read_index] <= 2'b11;
						end
						else begin
							if(b_status1[i] != 2'h0 && b_status1[i] != 2'h1)begin
								b_status1[i] <= b_status1[i] - 2'h1;
							end
						end
						//TAG2
						if(read_index == i[1:0] && read_way == 2'h2)begin
							b_status2[read_index] <= 2'b11;
						end
						else begin
							if(b_status2[i] != 2'h0 && b_status2[i] != 2'h1)begin
								b_status2[i] <= b_status2[i] - 2'h1;
							end
						end
						//TAG3
						if(read_index == i[1:0] && read_way == 2'h3)begin
							b_status3[read_index] <= 2'b11;
						end
						else begin
							if(b_status3[i] != 2'h0 && b_status3[i] != 2'h1)begin
								b_status3[i] <= b_status3[i] - 2'h1;
							end
						end
					end
				end
				//Read Only
				else if(iRD_REQ && read_hit)begin
					(* full_case *)case(read_way)
						2'h0	:	b_status0[read_index] <= 2'h3;
						2'h1	:	b_status1[read_index] <= 2'h3;
						2'h2	:	b_status2[read_index] <= 2'h3;
						2'h3	:	b_status3[read_index] <= 2'h3;
					endcase
				end				
				//LRU Controal
				else if(lru_valid)begin
					for(i = 0; i < 4; i = i + 1)begin
						//TAG0
						if(b_status0[i] != 2'h0 && b_status0[i] != 2'h1)begin
							b_status0[i] <= b_status0[i] - 2'h1;
						end
						//TAG1
						if(b_status1[i] != 2'h0 && b_status1[i] != 2'h1)begin
							b_status1[i] <= b_status1[i] - 2'h1;
						end
						//TAG2
						if(b_status2[i] != 2'h0 && b_status2[i] != 2'h1)begin
							b_status2[i] <= b_status2[i] - 2'h1;
						end
						//TAG3
						if(b_status3[i] != 2'h0 && b_status3[i] != 2'h1)begin
							b_status3[i] <= b_status3[i] - 2'h1;
						end
					end
				end
			end //End !Lock
		end
	end //always
	
	
	/********************************************
	LRU Control - Timer
	********************************************/
	reg [LRU_TIMER_N-1:0] b_lru_timer;
	assign lru_valid = (b_lru_timer == {LRU_TIMER_N{1'b1}})? 1'b1 : 1'b0;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_lru_timer <= {LRU_TIMER_N{1'b0}};
		end
		else if(iREMOVE)begin
			b_lru_timer <= {LRU_TIMER_N{1'b0}};
		end
		else begin
			if(!this_read_lock)begin
				b_lru_timer <= b_lru_timer + {{LRU_TIMER_N-1{1'b0}}, 1'b1};
			end
		end
	end
	
	
	/********************************************
	Assign
	********************************************/
	function [63:0] func_line_data2output_data;
		input [35:0] func_linedata;
		begin
			func_line_data2output_data = 
										{
											func_linedata[35:18], 
											{14{1'b0}}, 
											func_linedata[17:0], 
											{14{1'b0}}
										};
		end
	endfunction
	
	assign oRD_VALID = !this_read_lock && b_load_req_valid;
	assign oRD_HIT = !this_read_lock && b_load_req_valid && b_rd_hit;
	assign oRD_FLAGS =
						(b_load_req_valid && !this_read_lock && b_rd_hit)? (
							(b_rd_way == 2'h0)? b_flags0[b_rd_index] : (
								(b_rd_way == 2'h1)? b_flags1[b_rd_index] : (
									(b_rd_way == 2'h2)? b_flags2[b_rd_index] : b_flags3[b_rd_index]
								)
							)
						) : 28'h0;
	
	assign oRD_PHYS_ADDR = 
						(b_load_req_valid && !this_read_lock && b_rd_hit)? (
							(b_rd_way == 2'h0)? func_line_data2output_data(b_data0[b_rd_index]) : (
								(b_rd_way == 2'h1)? func_line_data2output_data(b_data1[b_rd_index]) : (
									(b_rd_way == 2'h2)? func_line_data2output_data(b_data2[b_rd_index]) : func_line_data2output_data(b_data3[b_rd_index])
								)
							)
						) : 64'h0;
	
	
	
endmodule


`default_nettype wire

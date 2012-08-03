



/*
	Line Size		:	8byte	
	Way				:	4Way Set Assicatiev
	Tag				:	/2bit LRU Bit(VALID)/20bit Address/
	Purging			:	Write Through Algorithm
	
*/

`include	"global.h"
`default_nettype none




module l1_cache_512entry_4way_line8b__(
					/********************************
					System
					********************************/
					input				iCLOCK,
					input				inRESET,
					//Remove
					input				iREMOVE,
					/********************************
					Search
					********************************/
					//Search Request 
					input				iRD_REQ,
					output				oRD_BUSY,		//NEW
					input	[31:0]		iRD_ADDR,		//Tag:22bit | Index:7bit | Line:3bit
					//Search Output Result
					output				oRD_VALID,
					output				oRD_HIT,
					input				iRD_BUSY,		//NEW
					output	[63:0]		oRD_DATA,
					output	[11:0]		oRD_MMU_FLAGS,	
					/********************************
					Upload
					********************************/
					input				iUP_REQ,
					input	[1:0]		iUP_ORDER,
					input	[31:0]		iUP_ADDR,				
					input	[31:0]		iUP_DATA,
					input	[5:0]		iUP_MMU_FLAGS,
					/********************************
					Write Request
					********************************/
					input				iWR_REQ,
					output				oWR_BUSY,
					input	[31:0]		iWR_ADDR,	//Tag:22bit | Index:7bit | Line:3bit
					input	[63:0]		iWR_DATA,
					input	[11:0]		iWR_MMU_FLAGS
	);
			
	assign			oRD_BUSY		=		1'b0;
	
	reg				b_req_valid;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_req_valid		<=		1'b0;
		end
		else if(iREMOVE)begin
			b_req_valid		<=		1'b0;
		end
		else begin
			b_req_valid		<=		iRD_REQ;
		end
	end

	assign			oRD_VALID		=		b_req_valid;
	assign			oRD_HIT			=		1'b0;
	assign			oRD_DATA		=		64'h0;
	assign			oRD_MMU_FLAGS	=		12'h0;
	assign			oWR_BUSY		=		1'b0;
			

	
endmodule





module l1_cache_512entry_4way_line8b(
					/********************************
					System
					********************************/
					input				iCLOCK,
					input				inRESET,
					//Remove
					input				iREMOVE,
					/********************************
					Search
					********************************/
					//Search Request 
					input				iRD_REQ,
					output				oRD_BUSY,		//NEW
					input	[31:0]		iRD_ADDR,		//Tag:22bit | Index:7bit | Line:3bit
					//Search Output Result
					output				oRD_VALID,
					output				oRD_HIT,
					input				iRD_BUSY,		//NEW
					output	[63:0]		oRD_DATA,
					output	[11:0]		oRD_MMU_FLAGS,	
					/********************************
					Upload
					********************************/
					input				iUP_REQ,
					input	[1:0]		iUP_ORDER,
					input	[31:0]		iUP_ADDR,				
					input	[31:0]		iUP_DATA,
					input	[5:0]		iUP_MMU_FLAGS,
					/********************************
					Write Request
					********************************/
					input				iWR_REQ,
					output				oWR_BUSY,
					input	[31:0]		iWR_ADDR,	//Tag:22bit | Index:7bit | Line:3bit
					input	[63:0]		iWR_DATA,
					input	[11:0]		iWR_MMU_FLAGS
	);
			
	

			
	/**********************************************
	Wire and Register
	**********************************************/
	//Lock Condition
	wire			this_read_lock;
	wire			this_write_lock;
	//Output Buffer
	reg					b_rd_hit;
	reg		[6:0]		b_rd_way;
	//Cache Control
	wire				upload_need;		
	wire	[1:0]		upload_way;
	wire	[6:0]		upload_pointer;
	wire	[7:0]		upload_byte_enable;		
	wire	[6:0]		read_pointer;
	wire				read_hit;
	wire	[1:0]		read_way;
	wire	[6:0]		write_pointer;
	wire	[1:0]		write_way;	
	//Memory Block
	wire	[63:0]		memory_way0_out_data;
	wire	[63:0]		memory_way1_out_data;
	wire	[63:0]		memory_way2_out_data;
	wire	[63:0]		memory_way3_out_data;
	wire				memory_write_way0_condition;
	wire				memory_write_way1_condition;
	wire				memory_write_way2_condition;
	wire				memory_write_way3_condition;
	wire	[7:0]		memory_write_byte_enable;
	wire	[63:0]		memory_write_data;
	wire	[11:0]		memory_mmuflag_way0_out_data;
	wire	[11:0]		memory_mmuflag_way1_out_data;
	wire	[11:0]		memory_mmuflag_way2_out_data;
	wire	[11:0]		memory_mmuflag_way3_out_data;
	wire	[11:0]		memory_mmuflag_write_data;		
	//Generate
	integer			i;
	//Tag:22bit | Index:7bit | Line:3bit
	reg		[23:0]		tag0[0:127];	//LRU_Status:2bit | AddressTag:22bit
	reg		[23:0]		tag1[0:127];	//LRU_Status:2bit | AddressTag:22bit
	reg		[23:0]		tag2[0:127];	//LRU_Status:2bit | AddressTag:22bit
	reg		[23:0]		tag3[0:127];	//LRU_Status:2bit | AddressTag:22bit
	reg					b_load_req_valid;
	
	/**********************************************
	Lock
	**********************************************/
	assign			this_read_lock	=	iRD_BUSY;
	assign			this_write_lock	=	iUP_REQ;
	
	
	/********************************************
	LRU Control - Timer
	********************************************/
	wire					lru_valid;
	reg		[9:0]			b_lru_timer;
	assign					lru_valid		=		(b_lru_timer == 10'hFFF)? 1'b1 : 1'b0;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_lru_timer			<=		10'h0;
		end
		else if(iREMOVE)begin
			b_lru_timer			<=		10'h0;
		end
		else begin
			if(!this_read_lock)begin
				b_lru_timer			<=		b_lru_timer		+	10'h1;
			end
		end
	end



	/********************************************
	Control
	********************************************/
	assign				{upload_need, upload_way}	=		func_upload_check(iUP_ADDR[31:10], tag0[upload_pointer], tag1[upload_pointer], tag2[upload_pointer], tag3[upload_pointer]);
	assign				upload_pointer				=		iUP_ADDR[9:3];
	assign				upload_byte_enable			=		func_upload_enable_byte_gen(iUP_ADDR, iUP_ORDER);
	assign				read_pointer				=		iRD_ADDR[9:3];
	assign				{read_hit, read_way}		=		func_hit_check(iRD_ADDR[31:10], tag0[read_pointer], tag1[read_pointer], tag2[read_pointer], tag3[read_pointer]);
	assign				write_pointer				=		iWR_ADDR[9:3];
	assign				write_way					=		func_write_way_search(func_get_status_tag(tag0[write_pointer]), func_get_status_tag(tag1[write_pointer]), func_get_status_tag(tag2[write_pointer]), func_get_status_tag(tag3[write_pointer]));
	
	/********************************************
	Data Memory Block
	********************************************/	
	assign				memory_write_way0_condition				=		(!this_write_lock && iWR_REQ && write_way == 2'h0) || (iUP_REQ && upload_need && upload_way == 2'h0);
	assign				memory_write_way1_condition				=		(!this_write_lock && iWR_REQ && write_way == 2'h1) || (iUP_REQ && upload_need && upload_way == 2'h1);
	assign				memory_write_way2_condition				=		(!this_write_lock && iWR_REQ && write_way == 2'h2) || (iUP_REQ && upload_need && upload_way == 2'h2);
	assign				memory_write_way3_condition				=		(!this_write_lock && iWR_REQ && write_way == 2'h3) || (iUP_REQ && upload_need && upload_way == 2'h3);
	assign				memory_write_byte_enable				=		(iUP_REQ)? upload_byte_enable : 8'hFF;
	
	assign				memory_write_data						=		(iUP_REQ)? {iUP_DATA, iUP_DATA} : iWR_DATA;
	
	wire				memory_mmuflag_write_way0_condition;
	wire				memory_mmuflag_write_way1_condition;
	wire				memory_mmuflag_write_way2_condition;
	wire				memory_mmuflag_write_way3_condition;
	assign				memory_mmuflag_write_way0_condition		=		(!this_write_lock && iWR_REQ && write_way == 2'h0) || (iUP_REQ && upload_need && upload_way == 2'h0);
	assign				memory_mmuflag_write_way1_condition		=		(!this_write_lock && iWR_REQ && write_way == 2'h1) || (iUP_REQ && upload_need && upload_way == 2'h1);
	assign				memory_mmuflag_write_way2_condition		=		(!this_write_lock && iWR_REQ && write_way == 2'h2) || (iUP_REQ && upload_need && upload_way == 2'h2);
	assign				memory_mmuflag_write_way3_condition		=		(!this_write_lock && iWR_REQ && write_way == 2'h3) || (iUP_REQ && upload_need && upload_way == 2'h3);
		
	assign				memory_mmuflag_write_data				=		(iUP_REQ)? {iUP_MMU_FLAGS, iUP_MMU_FLAGS} : iWR_MMU_FLAGS;
	
	
	/*--------------------------------------- 
	Altera Quartus II MegaWizard
	
	Name			: Data RAM
	Type			: RAM
	Port			: Dual Port(1Read+1Write)
	ReadPort		: None Latch
	Memory Word		: 128W
	Data Bit		: 64bit
	Byte Enable		: YES(8bit)
	Read==Write		: Dont care
	---------------------------------------*/
	cache_ram_128word_64bit MEMORY_BLOCK0(
		.clock(iCLOCK),
		.data(memory_write_data),				//64bit
		.rdaddress(read_pointer),				//7bit
		.wraddress(write_pointer),				//7bit
		.byteena_a(memory_write_byte_enable),	//8bit
		.wren(memory_write_way0_condition),
		.q(memory_way0_out_data)				//64bit
	);
	
	cache_ram_128word_64bit MEMORY_BLOCK1(
		.clock(iCLOCK),
		.data(memory_write_data),				//64bit
		.rdaddress(read_pointer),				//7bit
		.wraddress(write_pointer),				//7bit
		.byteena_a(memory_write_byte_enable),	//8bit
		.wren(memory_write_way1_condition),
		.q(memory_way1_out_data)				//64bit
	);
	
	cache_ram_128word_64bit MEMORY_BLOCK2(
		.clock(iCLOCK),
		.data(memory_write_data),				//64bit
		.rdaddress(read_pointer),				//7bit
		.wraddress(write_pointer),				//7bit
		.byteena_a(memory_write_byte_enable),	//8bit
		.wren(memory_write_way2_condition),
		.q(memory_way2_out_data)				//64bit
	);
	
	cache_ram_128word_64bit MEMORY_BLOCK3(
		.clock(iCLOCK),
		.data(memory_write_data),				//64bit
		.rdaddress(read_pointer),				//7bit
		.wraddress(write_pointer),				//7bit
		.byteena_a(memory_write_byte_enable),	//8bit
		.wren(memory_write_way3_condition),
		.q(memory_way3_out_data)				//64bit
	);
	
	
	/*--------------------------------------- 
	Altera Quartus II MegaWizard
	
	Name			: MMU Flag RAM
	Type			: RAM
	Port			: Dual Port(1Read+1Write)
	ReadPort		: None Latch
	Memory Word		: 128W
	Data Bit		: 12bit
	Byte Enable		: YES(8bit)
	Read==Write		: Dont care
	---------------------------------------*/
	
	cache_ram_128word_12bit MEMORY_MMUFLAG_BLOCK0(
		.clock(iCLOCK),
		.data(memory_mmuflag_write_data),				//12bit
		.rdaddress(read_pointer),				//7bit
		.wraddress(write_pointer),				//7bit
		.wren(memory_mmuflag_write_way0_condition),
		.q(memory_mmuflag_way0_out_data)				//12bit
	);
	
	cache_ram_128word_12bit MEMORY_MMUFLAG_BLOCK1(
		.clock(iCLOCK),
		.data(memory_mmuflag_write_data),				//12bit
		.rdaddress(read_pointer),				//7bit
		.wraddress(write_pointer),				//7bit
		.wren(memory_mmuflag_write_way1_condition),
		.q(memory_mmuflag_way1_out_data)				//12bit
	);
	
	cache_ram_128word_12bit MEMORY_MMUFLAG_BLOCK2(
		.clock(iCLOCK),
		.data(memory_mmuflag_write_data),				//12bit
		.rdaddress(read_pointer),				//7bit
		.wraddress(write_pointer),				//7bit
		.wren(memory_mmuflag_write_way2_condition),
		.q(memory_mmuflag_way2_out_data)				//12bit
	);
	
	cache_ram_128word_12bit MEMORY_MMUFLAG_BLOCK3(
		.clock(iCLOCK),
		.data(memory_mmuflag_write_data),				//12bit
		.rdaddress(read_pointer),				//7bit
		.wraddress(write_pointer),				//7bit
		.wren(memory_mmuflag_write_way3_condition),
		.q(memory_mmuflag_way3_out_data)				//12bit
	);
	
	
	
	
	/********************************************
	Function
	********************************************/
	//Upload Check
	function [2:0] func_upload_check;	//[2]:Upload Need Flag  |  [1:0] Upload Way
		input	[21:0]		func_request_addr;
		input	[23:0]		func_way0;
		input	[23:0]		func_way1;
		input	[23:0]		func_way2;
		input	[23:0]		func_way3;
		begin
			if(func_request_addr == func_way0[21:0] && func_way0[23:22] != 2'h0)begin
				func_upload_check	=	{1'b1, 2'h0};
			end
			else if(func_request_addr == func_way1[21:0] && func_way0[23:22] != 2'h0)begin
				func_upload_check	=	{1'b1, 2'h1};
			end
			else if(func_request_addr == func_way2[21:0] && func_way0[23:22] != 2'h0)begin
				func_upload_check	=	{1'b1, 2'h2};
			end
			else if(func_request_addr == func_way3[21:0] && func_way0[23:22] != 2'h0)begin
				func_upload_check	=	{1'b1, 2'h3};
			end
			else begin
				func_upload_check	=	3'h0;
			end
		end
	endfunction
	
	//Upload Byte Enable Generate
	function [7:0] func_upload_enable_byte_gen;
		input	[2:0]		func_addr;
		input	[1:0]		func_order;
		begin
			case(func_order)
				2'h0	:
					begin
						func_upload_enable_byte_gen	=	8'h00 | (1'b1 << func_addr);
					end
				2'h1	:	
					begin
						func_upload_enable_byte_gen	=	8'h00 | (2'b11 << {func_addr[2:1], 1'b0});
					end
				2'h2	:
					begin
						func_upload_enable_byte_gen	=	8'h00 | (4'b1111 << {func_addr[2], 2'h0});
					end
				default	:
					begin
						func_upload_enable_byte_gen	=	8'h0;
						$display("[ERROR] : inst_l1_cache.v iUP_ORDER is %x", func_order);
					end
			endcase
		end
	endfunction
	
	//Low Pryority Line Search
	function [1:0] func_write_way_search;
		input	[1:0]	way0_status;
		input	[1:0]	way1_status;
		input	[1:0]	way2_status;
		input	[1:0]	way3_status;
		begin
			if(way0_status == 2'h0)
				func_write_way_search	=	2'h0;
			else if(way1_status == 2'h0)
				func_write_way_search	=	2'h1;
			else if(way2_status == 2'h0)
				func_write_way_search	=	2'h2;
			else if(way3_status == 2'h0)
				func_write_way_search	=	2'h3;
			else if(way0_status == 2'h1)
				func_write_way_search	=	2'h0;
			else if(way1_status == 2'h1)
				func_write_way_search	=	2'h1;
			else if(way2_status == 2'h1)
				func_write_way_search	=	2'h2;
			else if(way3_status == 2'h1)
				func_write_way_search	=	2'h3;
			else if(way0_status == 2'h2)
				func_write_way_search	=	2'h0;
			else if(way1_status == 2'h2)
				func_write_way_search	=	2'h1;
			else if(way2_status == 2'h2)
				func_write_way_search	=	2'h2;
			else if(way3_status == 2'h2)
				func_write_way_search	=	2'h3;
			else
				func_write_way_search	=	2'h3;
		end
	endfunction
	
	function [2:0] func_hit_check;	//[2]:Hit  |  [1:0] Hit Way
		input	[21:0]	func_request_addr;
		input	[23:0]	func_way0;
		input	[23:0]	func_way1;
		input	[23:0]	func_way2;
		input	[23:0]	func_way3;
		begin
			if(func_request_addr == func_way0[21:0] && func_way0[23:22] != 2'h0)begin
				func_hit_check	=	{1'b1, 2'h0};
			end
			else if(func_request_addr == func_way0[21:0] && func_way0[23:22] != 2'h0)begin
				func_hit_check	=	{1'b1, 2'h1};
			end
			else if(func_request_addr == func_way0[21:0] && func_way0[23:22] != 2'h0)begin
				func_hit_check	=	{1'b1, 2'h2};
			end
			else if(func_request_addr == func_way0[21:0] && func_way0[23:22] != 2'h0)begin
				func_hit_check	=	{1'b1, 2'h3};
			end
			else begin
				//No Hit
				func_hit_check	=	{1'b0, 2'h0};
			end
		end
	endfunction
			
	//Pryority & Valid
	function [1:0] func_get_status_tag;
		input	[23:0]		func_tag;
		begin
			func_get_status_tag		=	func_tag[23:22];
		end
	endfunction
	
	//Get Tag Address
	function [21:0] func_get_address_tag;
		input	[23:0]		func_tag;
		begin
			func_get_address_tag	=	func_tag[21:0];
		end
	endfunction
	
 
	/********************************************
	Tag Pryority & Tag Control
	********************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 128; i = i + 1)begin
				if(`DATA_RESET_ENABLE)begin
					tag0[i]					<=	tag0[i] & 23'h000000;		//Clear LRU_Status bit
					tag1[i]					<=	tag1[i] & 23'h000000;		//Clear LRU_Status bit
					tag2[i]					<=	tag2[i] & 23'h000000;		//Clear LRU_Status bit
					tag3[i]					<=	tag3[i] & 23'h000000;		//Clear LRU_Status bit
				end
				else begin
					tag0[i]					<=	tag0[i] & 23'h3FFFFF;		//Clear LRU_Status bit
					tag1[i]					<=	tag1[i] & 23'h3FFFFF;		//Clear LRU_Status bit
					tag2[i]					<=	tag2[i] & 23'h3FFFFF;		//Clear LRU_Status bit
					tag3[i]					<=	tag3[i] & 23'h3FFFFF;		//Clear LRU_Status bit
				end
			end
			b_load_req_valid			<=	1'b0;
		end
		else if(iREMOVE)begin
			for(i = 0; i < 128; i = i + 1)begin
				if(`DATA_RESET_ENABLE)begin
					tag0[i]					<=	tag0[i] & 23'h000000;		//Clear LRU_Status bit
					tag1[i]					<=	tag1[i] & 23'h000000;		//Clear LRU_Status bit
					tag2[i]					<=	tag2[i] & 23'h000000;		//Clear LRU_Status bit
					tag3[i]					<=	tag3[i] & 23'h000000;		//Clear LRU_Status bit
				end
				else begin
					tag0[i]					<=	tag0[i] & 23'h3FFFFF;		//Clear LRU_Status bit
					tag1[i]					<=	tag1[i] & 23'h3FFFFF;		//Clear LRU_Status bit
					tag2[i]					<=	tag2[i] & 23'h3FFFFF;		//Clear LRU_Status bit
					tag3[i]					<=	tag3[i] & 23'h3FFFFF;		//Clear LRU_Status bit
				end
			end
			b_load_req_valid			<=	1'b0;
		end
		else begin
			//Upload
			if(iUP_REQ)begin
				if(upload_need)begin
					case(upload_way)
						2'h0:	tag0[write_pointer]		<=	{((func_get_status_tag(tag0[upload_pointer]) != 2'b11)? func_get_status_tag(tag0[upload_pointer]) + 2'h1 : func_get_status_tag(tag0[upload_pointer])), func_get_address_tag(tag0[upload_pointer])};
						2'h1:	tag1[write_pointer]		<=	{((func_get_status_tag(tag1[upload_pointer]) != 2'b11)? func_get_status_tag(tag1[upload_pointer]) + 2'h1 : func_get_status_tag(tag1[upload_pointer])), func_get_address_tag(tag1[upload_pointer])};
						2'h2:	tag2[write_pointer]		<=	{((func_get_status_tag(tag2[upload_pointer]) != 2'b11)? func_get_status_tag(tag2[upload_pointer]) + 2'h1 : func_get_status_tag(tag2[upload_pointer])), func_get_address_tag(tag2[upload_pointer])};
						2'h3:	tag3[write_pointer]		<=	{((func_get_status_tag(tag3[upload_pointer]) != 2'b11)? func_get_status_tag(tag3[upload_pointer]) + 2'h1 : func_get_status_tag(tag3[upload_pointer])), func_get_address_tag(tag3[upload_pointer])};
					endcase
				end
			end
			//Write
			else if(iWR_REQ)begin
				case(write_way)
					2'h0:	tag0[write_pointer]		<=	{2'b11, iWR_ADDR[31:10]};
					2'h1:	tag1[write_pointer]		<=	{2'b11, iWR_ADDR[31:10]};
					2'h2:	tag2[write_pointer]		<=	{2'b11, iWR_ADDR[31:10]};
					2'h3:	tag3[write_pointer]		<=	{2'b11, iWR_ADDR[31:10]};
				endcase
			end
			//Request Valid
			if(!this_read_lock)begin
				b_load_req_valid			<=	iRD_REQ;
			end
			//Read & LRU Controal
			if(!this_read_lock)begin
				if(iRD_REQ && read_hit && lru_valid)begin
					for(i = 0; i < 128; i = i + 1)begin
						//TAG0
						if(read_pointer == i[6:0] && read_way == 2'h0)begin
							tag0[read_pointer]	<=	{2'b11, func_get_address_tag(tag0[read_pointer])};
						end
						else begin
							if(func_get_status_tag(tag0[i[6:0]]) != 2'h0 && func_get_status_tag(tag0[i[6:0]]) != 2'h1)begin
								tag0[i[6:0]]		<=	{(func_get_status_tag(tag0[i[6:0]]) - 2'h1), func_get_address_tag(tag0[i[6:0]])};
							end
						end
						//TAG1
						if(read_pointer == i[6:0] && read_way == 2'h1)begin
							tag1[read_pointer]	<=	{2'b11, func_get_address_tag(tag1[read_pointer])};
						end
						else begin
							if(func_get_status_tag(tag1[i[6:0]]) != 2'h0 && func_get_status_tag(tag1[i[6:0]]) != 2'h1)begin
								tag1[i[6:0]]		<=	{(func_get_status_tag(tag1[i[6:0]]) - 2'h1), func_get_address_tag(tag1[i[6:0]])};
							end
						end
						//TAG2
						if(read_pointer == i[6:0] && read_way == 2'h2)begin
							tag2[read_pointer]	<=	{2'b11, func_get_address_tag(tag2[read_pointer])};
						end
						else begin
							if(func_get_status_tag(tag2[i[6:0]]) != 2'h0 && func_get_status_tag(tag2[i[6:0]]) != 2'h1)begin
								tag2[i[6:0]]		<=	{(func_get_status_tag(tag2[i[6:0]]) - 2'h1), func_get_address_tag(tag2[i[6:0]])};
							end
						end
						//TAG3
						if(read_pointer == i[6:0] && read_way == 2'h3)begin
							tag3[read_pointer]	<=	{2'b11, func_get_address_tag(tag3[read_pointer])};
						end
						else begin
							if(func_get_status_tag(tag3[i[6:0]]) != 2'h0 && func_get_status_tag(tag3[i[6:0]]) != 2'h1)begin
								tag3[i[6:0]]		<=	{(func_get_status_tag(tag3[i[6:0]]) - 2'h1), func_get_address_tag(tag3[i[6:0]])};
							end
						end
					end
				end
				//Read Only
				else if(iRD_REQ && read_hit)begin
					case(read_way)//synthesis parallel_case full_case
						2'h0	:
							begin
								if(func_get_status_tag(tag0[read_pointer]) != 2'b11)begin
									tag0[read_pointer]	<=	{2'b11/*(func_get_status_tag(tag0[read_pointer]) + 2'h1)*/, func_get_address_tag(tag0[read_pointer])};
								end
							end
						2'h1	:
							begin
								if(func_get_status_tag(tag1[read_pointer]) != 2'b11)begin
									tag1[read_pointer]	<=	{2'b11, func_get_address_tag(tag1[read_pointer])};
								end
							end
						2'h2	:
							begin
								if(func_get_status_tag(tag2[read_pointer]) != 2'b11)begin
									tag2[read_pointer]	<=	{2'b11, func_get_address_tag(tag2[read_pointer])};
								end
							end
						2'h3	:
							begin
								if(func_get_status_tag(tag3[read_pointer]) != 2'b11)begin
									tag3[read_pointer]	<=	{2'b11, func_get_address_tag(tag3[read_pointer])};
								end
							end
					endcase
				end
				//LRU Controal
				else if(lru_valid)begin
					for(i = 0; i < 128; i = i + 1)begin
						//TAG0
						if(func_get_status_tag(tag0[i[6:0]]) != 2'h0 && func_get_status_tag(tag0[i[6:0]]) != 2'h1)begin
							tag0[i[6:0]]		<=	{(func_get_status_tag(tag0[i[6:0]]) - 2'h1), func_get_address_tag(tag0[i[6:0]])};
						end
						//TAG1
						if(func_get_status_tag(tag1[i[6:0]]) != 2'h0 && func_get_status_tag(tag1[i[6:0]]) != 2'h1)begin
							tag1[i[6:0]]		<=	{(func_get_status_tag(tag1[i[6:0]]) - 2'h1), func_get_address_tag(tag1[i[6:0]])};
						end
						//TAG2
						if(func_get_status_tag(tag2[i[6:0]]) != 2'h0 && func_get_status_tag(tag2[i[6:0]]) != 2'h1)begin
							tag2[i[6:0]]		<=	{(func_get_status_tag(tag2[i[6:0]]) - 2'h1), func_get_address_tag(tag2[i[6:0]])};
						end
						//TAG3
						if(func_get_status_tag(tag3[i[6:0]]) != 2'h0 && func_get_status_tag(tag3[i[6:0]]) != 2'h1)begin
							tag3[i[6:0]]		<=	{(func_get_status_tag(tag3[i[6:0]]) - 2'h1), func_get_address_tag(tag3[i[6:0]])};
						end
					end
				end
			end //End !Lock
		end
	end //always
	

	/********************************************
	Output Buffer
	********************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_rd_hit		<=		1'h0;
			b_rd_way		<=		2'h0;
		end
		else begin
			if(!this_read_lock)begin
				b_rd_hit		<=		read_hit;
				b_rd_way		<=		read_way;
			end
		end
	end
	
	/*****************************************************
	Output Assign
	*****************************************************/
	assign			oRD_BUSY		=	iRD_BUSY || (iRD_REQ && iWR_REQ && iRD_ADDR == iWR_ADDR);	
	assign			oRD_VALID		=	b_load_req_valid && !this_read_lock;
	assign			oRD_HIT			=	b_load_req_valid && !this_read_lock && b_rd_hit;
	assign			oRD_DATA		=	(b_load_req_valid && !this_read_lock && b_rd_hit)? (
											(b_rd_way == 2'h0)? memory_way0_out_data : (
												(b_rd_way == 2'h1)? memory_way1_out_data : (
													(b_rd_way == 2'h2)? memory_way2_out_data : memory_way3_out_data
												)
											)
										) : 64'h0;									
	assign			oRD_MMU_FLAGS	=	(b_load_req_valid && !this_read_lock && b_rd_hit)? (
											(b_rd_way == 2'h0)? memory_mmuflag_way0_out_data : (
												(b_rd_way == 2'h1)? memory_mmuflag_way1_out_data : (
													(b_rd_way == 2'h2)? memory_mmuflag_way2_out_data : memory_mmuflag_way3_out_data
												)
											)
										) : 12'h0;
	assign			oWR_BUSY		=	this_write_lock;
	
	
	
endmodule


`default_nettype wire


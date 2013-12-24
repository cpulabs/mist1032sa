
/*
	Line Size		:	64byte	
	Way				:	4Way Set Assicatiev
	Tag				:	/2bit LRU Bit(VALID)/20bit Address
	Purging			:	Write Through Algorithm
	
*/

//`include "processor.h"
`default_nettype none

module l1_cache_64entry_4way_line64b_bus_8b_damy(
		/********************************
		System
		********************************/
		input wire iCLOCK,
		input wire inRESET,
		//Remove
		input wire iREMOVE,
		/********************************
		Search
		********************************/
		//Search Request 
		input wire iRD_REQ,
		output wire oRD_BUSY,		
		input wire [31:0] iRD_ADDR,		//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
		//Search Output Result
		output wire oRD_VALID,
		output wire oRD_HIT,
		input wire iRD_BUSY,		
		output wire [63:0] oRD_DATA,
		output wire [27:0] oRD_MMU_FLAGS,	
		/********************************
		Upload
		********************************/
		input wire iUP_REQ,
		output wire oUP_BUSY,
		input wire [1:0] iUP_ORDER,
		input wire [31:0] iUP_ADDR,				
		input wire [31:0] iUP_DATA,
		//input	[5:0] iUP_MMU_FLAGS,
		/********************************
		Write Request
		********************************/
		input wire iWR_REQ,
		output wire oWR_BUSY,
		input wire [31:0] iWR_ADDR,	//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
		input wire [511:0] iWR_DATA,
		input wire [255:0] iWR_MMU_FLAGS
	);
			
	assign oRD_BUSY = 1'b0;
	
	reg b_req_valid;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_req_valid <= 1'b0;
		end
		else if(iREMOVE)begin
			b_req_valid <= 1'b0;
		end
		else begin
			b_req_valid <= iRD_REQ;
		end
	end

	assign oRD_VALID = b_req_valid;
	assign oRD_HIT = 1'b0;
	assign oRD_DATA = 64'h0;
	assign oRD_MMU_FLAGS = 28'h0;
	assign oUP_BUSY = 1'b0;
	assign oWR_BUSY = 1'b0;
	
endmodule



module l1_cache_64entry_4way_line64b_bus_8b(
		/********************************
		System
		********************************/
		input wire iCLOCK,
		input wire inRESET,
		//Remove
		input wire iREMOVE,
		/********************************
		Search
		********************************/
		//Search Request 
		input wire iRD_REQ,
		output wire oRD_BUSY,		
		input wire [31:0] iRD_ADDR,		//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
		//Search Output Result
		output wire oRD_VALID,
		output wire oRD_HIT,
		input wire iRD_BUSY,		
		output wire [63:0] oRD_DATA,
		output wire [27:0] oRD_MMU_FLAGS,	
		/********************************
		Upload
		********************************/
		input wire iUP_REQ,
		output wire oUP_BUSY,
		input wire [1:0] iUP_ORDER,
		input wire [31:0] iUP_ADDR,				
		input wire [31:0] iUP_DATA,
		/********************************
		Write Request
		********************************/
		input wire iWR_REQ,
		output wire oWR_BUSY,
		input wire [31:0] iWR_ADDR,	//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
		input wire [511:0] iWR_DATA,
		input wire [255:0] iWR_MMU_FLAGS
	);
			
	

			
	/**********************************************
	Wire and Register
	**********************************************/
	//Lock Condition
	wire this_read_lock;
	wire this_write_lock;
	//Output Buffer
	reg b_rd_hit;
	reg [6:0] b_rd_way;
	reg [31:0] b_rd_addr;
	//Cache Control
	wire upload_need;		
	wire [1:0] upload_way;
	wire [3:0] upload_pointer;
	wire [3:0] read_pointer;
	wire read_hit;
	wire [1:0] read_way;
	wire [3:0] write_pointer;
	wire [1:0] write_way;	
	//Memory Block
	wire [511:0] memory_way0_out_data;
	wire [511:0] memory_way1_out_data;
	wire [511:0] memory_way2_out_data;
	wire [511:0] memory_way3_out_data;
	wire memory_write_way0_condition;
	wire memory_write_way1_condition;
	wire memory_write_way2_condition;
	wire memory_write_way3_condition;
	
	wire [63:0] memory_write_byte_enable;
	
	wire [511:0] memory_write_data;
	wire [255:0] memory_mmuflag_way0_out_data;
	wire [255:0] memory_mmuflag_way1_out_data;
	wire [255:0] memory_mmuflag_way2_out_data;
	wire [255:0] memory_mmuflag_way3_out_data;
	wire [255:0] memory_mmuflag_write_data;	
	wire [31:0] memory_mmuflag_write_byte_enable;
	//Generate
	integer i;
	//Tag:22bit | Index:4bit(4Way*16Entry) | LineSize:6bit(64B)
	reg [23:0] tag0[0:15];	//LRU_Status:2bit | AddressTag:22bit
	reg [23:0] tag1[0:15];	//LRU_Status:2bit | AddressTag:22bit
	reg [23:0] tag2[0:15];	//LRU_Status:2bit | AddressTag:22bit
	reg [23:0] tag3[0:15];	//LRU_Status:2bit | AddressTag:22bit
	reg b_load_req_valid;
	
	/**********************************************
	Lock
	**********************************************/
	assign this_read_lock = iRD_BUSY;
	assign this_write_lock = iUP_REQ;
		
	/********************************************
	LRU Control - Timer
	********************************************/
	wire lru_valid;
	reg [15:0] b_lru_timer;
	assign lru_valid = (b_lru_timer == 16'hFFFF)? 1'b1 : 1'b0;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_lru_timer <= 16'h0;
		end
		else if(iREMOVE)begin
			b_lru_timer <= 16'h0;
		end
		else begin
			if(!this_read_lock)begin
				b_lru_timer <= b_lru_timer + 16'h1;
			end
		end
	end



	/********************************************
	Control
	********************************************/
	assign {upload_need, upload_way} = func_upload_check(iUP_ADDR[31:10], tag0[upload_pointer], tag1[upload_pointer], tag2[upload_pointer], tag3[upload_pointer]);
	assign upload_pointer = iUP_ADDR[9:6];
	assign read_pointer = iRD_ADDR[9:6];
	assign {read_hit, read_way} = func_hit_check(iRD_ADDR[31:10], tag0[read_pointer], tag1[read_pointer], tag2[read_pointer], tag3[read_pointer]);
	assign write_pointer = iWR_ADDR[9:6];
	assign write_way = func_write_way_search(
		iWR_ADDR[31:10],
		func_get_address_tag(tag0[write_pointer]),
		func_get_address_tag(tag1[write_pointer]),
		func_get_address_tag(tag2[write_pointer]),
		func_get_address_tag(tag3[write_pointer]),
		func_get_status_tag(tag0[write_pointer]), 
		func_get_status_tag(tag1[write_pointer]), 
		func_get_status_tag(tag2[write_pointer]), 
		func_get_status_tag(tag3[write_pointer])
	);
	
	/********************************************
	Data Memory Block
	********************************************/	
	assign memory_write_way0_condition = (!this_write_lock && iWR_REQ && write_way == 2'h0) || (iUP_REQ && upload_need && upload_way == 2'h0);
	assign memory_write_way1_condition = (!this_write_lock && iWR_REQ && write_way == 2'h1) || (iUP_REQ && upload_need && upload_way == 2'h1);
	assign memory_write_way2_condition = (!this_write_lock && iWR_REQ && write_way == 2'h2) || (iUP_REQ && upload_need && upload_way == 2'h2);
	assign memory_write_way3_condition = (!this_write_lock && iWR_REQ && write_way == 2'h3) || (iUP_REQ && upload_need && upload_way == 2'h3);
	assign memory_write_byte_enable = (iUP_REQ)? func_upload_enable_byte_gen(iUP_ADDR[3:0], iUP_ORDER) : {64{1'b1}};
	
	assign memory_write_data = (iUP_REQ)? {8{iUP_DATA}} : iWR_DATA;
	
	wire memory_mmuflag_write_way0_condition;
	wire memory_mmuflag_write_way1_condition;
	wire memory_mmuflag_write_way2_condition;
	wire memory_mmuflag_write_way3_condition;
	assign memory_mmuflag_write_way0_condition = (!this_write_lock && iWR_REQ && write_way == 2'h0) || (iUP_REQ && upload_need && upload_way == 2'h0);
	assign memory_mmuflag_write_way1_condition = (!this_write_lock && iWR_REQ && write_way == 2'h1) || (iUP_REQ && upload_need && upload_way == 2'h1);
	assign memory_mmuflag_write_way2_condition = (!this_write_lock && iWR_REQ && write_way == 2'h2) || (iUP_REQ && upload_need && upload_way == 2'h2);
	assign memory_mmuflag_write_way3_condition = (!this_write_lock && iWR_REQ && write_way == 2'h3) || (iUP_REQ && upload_need && upload_way == 2'h3);
	assign memory_mmuflag_write_byte_enable = (iUP_REQ)? {32{1'b0}} : {32{1'b1}};
	assign memory_mmuflag_write_data = iWR_MMU_FLAGS;
	
	
	/*--------------------------------------- 
	Altera Quartus II MegaWizard
	
	Name			: Data RAM
	Type			: RAM
	Port			: Dual Port(1Read+1Write)
	ReadPort		: None Latch
	Entry			: 16
	Data Bit		: 512bit
	Byte Enable		: YES(64bit)
	Read==Write		: Dont care
	---------------------------------------*/
	/*`ifdef MIST1032ISA_SIMULATION
		damy_memory_16entry_512bit MEMORY_DAMY_BLOCK0(
			.iCLOCK(iCLOCK),
			.iBYTE_ENA(memory_write_byte_enable),
			//Write
			.iWR_ENA(memory_write_way0_condition),
			.iWR_ADDR(write_pointer),
			.iWR_DATA(memory_write_data),
			//Read
			.iRD_ADDR(read_pointer),
			.oRD_DATA(memory_way0_out_data)
		);
		damy_memory_16entry_512bit MEMORY_DAMY_BLOCK1(
			.iCLOCK(iCLOCK),
			.iBYTE_ENA(memory_write_byte_enable),
			//Write
			.iWR_ENA(memory_write_way1_condition),
			.iWR_ADDR(write_pointer),
			.iWR_DATA(memory_write_data),
			//Read
			.iRD_ADDR(read_pointer),
			.oRD_DATA(memory_way1_out_data)
		);
		damy_memory_16entry_512bit MEMORY_DAMY_BLOCK2(
			.iCLOCK(iCLOCK),
			.iBYTE_ENA(memory_write_byte_enable),
			//Write
			.iWR_ENA(memory_write_way2_condition),
			.iWR_ADDR(write_pointer),
			.iWR_DATA(memory_write_data),
			//Read
			.iRD_ADDR(read_pointer),
			.oRD_DATA(memory_way2_out_data)
		);
		damy_memory_16entry_512bit MEMORY_DAMY_BLOCK3(
			.iCLOCK(iCLOCK),
			.iBYTE_ENA(memory_write_byte_enable),
			//Write
			.iWR_ENA(memory_write_way3_condition),
			.iWR_ADDR(write_pointer),
			.iWR_DATA(memory_write_data),
			//Read
			.iRD_ADDR(read_pointer),
			.oRD_DATA(memory_way3_out_data)
		);
	`else*/
		cache_ram_16entry_512bit MEMORY_BLOCK0(
			.clock(iCLOCK),
			.data(memory_write_data),				//512bit
			.rdaddress(read_pointer),				//4bit
			.wraddress(write_pointer),				//4bit
			.byteena_a(memory_write_byte_enable),	//64bit
			.wren(memory_write_way0_condition),
			.q(memory_way0_out_data)				//512bit
		);
		
		cache_ram_16entry_512bit MEMORY_BLOCK1(
			.clock(iCLOCK),
			.data(memory_write_data),				//512bit
			.rdaddress(read_pointer),				//4bit
			.wraddress(write_pointer),				//4bit
			.byteena_a(memory_write_byte_enable),	//64bit
			.wren(memory_write_way1_condition),
			.q(memory_way1_out_data)				//512bit
		);
		
		cache_ram_16entry_512bit MEMORY_BLOCK2(
			.clock(iCLOCK),
			.data(memory_write_data),				//512bit
			.rdaddress(read_pointer),				//4bit
			.wraddress(write_pointer),				//4bit
			.byteena_a(memory_write_byte_enable),	//64bit
			.wren(memory_write_way2_condition),
			.q(memory_way2_out_data)				//512bit
		);
		
		cache_ram_16entry_512bit MEMORY_BLOCK3(
			.clock(iCLOCK),
			.data(memory_write_data),				//512bit
			.rdaddress(read_pointer),				//4bit
			.wraddress(write_pointer),				//4bit
			.byteena_a(memory_write_byte_enable),	//64bit
			.wren(memory_write_way3_condition),
			.q(memory_way3_out_data)				//512bit
		);
	//`endif
	
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
	/*`ifdef MIST1032ISA_SIMULATION
		damy_memory_16entry_256bit MEMORY_MMUFLAG_DAMY_BLOCK0(
			.iCLOCK(iCLOCK),
			.iBYTE_ENA(memory_mmuflag_write_byte_enable),
			//Write
			.iWR_ENA(memory_mmuflag_write_way0_condition),
			.iWR_ADDR(write_pointer),
			.iWR_DATA(memory_mmuflag_write_data),
			//Read
			.iRD_ADDR(read_pointer),
			.oRD_DATA(memory_mmuflag_way0_out_data)
		);
		damy_memory_16entry_256bit MEMORY_MMUFLAG_DAMY_BLOCK1(
			.iCLOCK(iCLOCK),
			.iBYTE_ENA(memory_mmuflag_write_byte_enable),
			//Write
			.iWR_ENA(memory_mmuflag_write_way1_condition),
			.iWR_ADDR(write_pointer),
			.iWR_DATA(memory_mmuflag_write_data),
			//Read
			.iRD_ADDR(read_pointer),
			.oRD_DATA(memory_mmuflag_way1_out_data)
		);
		damy_memory_16entry_256bit MEMORY_MMUFLAG_DAMY_BLOCK2(
			.iCLOCK(iCLOCK),
			.iBYTE_ENA(memory_mmuflag_write_byte_enable),
			//Write
			.iWR_ENA(memory_mmuflag_write_way2_condition),
			.iWR_ADDR(write_pointer),
			.iWR_DATA(memory_mmuflag_write_data),
			//Read
			.iRD_ADDR(read_pointer),
			.oRD_DATA(memory_mmuflag_way2_out_data)
		);
		damy_memory_16entry_256bit MEMORY_MMUFLAG_DAMY_BLOCK3(
			.iCLOCK(iCLOCK),
			.iBYTE_ENA(memory_mmuflag_write_byte_enable),
			//Write
			.iWR_ENA(memory_mmuflag_write_way3_condition),
			.iWR_ADDR(write_pointer),
			.iWR_DATA(memory_mmuflag_write_data),
			//Read
			.iRD_ADDR(read_pointer),
			.oRD_DATA(memory_mmuflag_way3_out_data)
		);
		
	`else*/
		cache_ram_16entry_256bit MEMORY_MMUFLAG_BLOCK0(
			.clock(iCLOCK),
			.byteena_a(memory_mmuflag_write_byte_enable),
			.data(memory_mmuflag_write_data),		//256bit
			.rdaddress(read_pointer),				//4bit
			.wraddress(write_pointer),				//4bit
			.wren(memory_mmuflag_write_way0_condition),
			.q(memory_mmuflag_way0_out_data)		//256bit
		);
		
		cache_ram_16entry_256bit MEMORY_MMUFLAG_BLOCK1(
			.clock(iCLOCK),
			.byteena_a(memory_mmuflag_write_byte_enable),
			.data(memory_mmuflag_write_data),		//256bit
			.rdaddress(read_pointer),				//4bit
			.wraddress(write_pointer),				//4bit
			.wren(memory_mmuflag_write_way1_condition),
			.q(memory_mmuflag_way1_out_data)		//256bit
		);
		
		cache_ram_16entry_256bit MEMORY_MMUFLAG_BLOCK2(
			.clock(iCLOCK),
			.byteena_a(memory_mmuflag_write_byte_enable),
			.data(memory_mmuflag_write_data),		//256bit
			.rdaddress(read_pointer),				//4bit
			.wraddress(write_pointer),				//4bit
			.wren(memory_mmuflag_write_way2_condition),
			.q(memory_mmuflag_way2_out_data)		//256bit
		);
		
		cache_ram_16entry_256bit MEMORY_MMUFLAG_BLOCK3(
			.clock(iCLOCK),
			.byteena_a(memory_mmuflag_write_byte_enable),
			.data(memory_mmuflag_write_data),		//256bit
			.rdaddress(read_pointer),				//4bit
			.wraddress(write_pointer),				//4bit
			.wren(memory_mmuflag_write_way3_condition),
			.q(memory_mmuflag_way3_out_data)		//256bit
		);
	//`endif
	
	/********************************************
	Function
	********************************************/
	//Upload Check
	function [2:0] func_upload_check;	//[2]:Upload Need Flag  |  [1:0] Upload Way
		input	[21:0] func_request_addr;
		input	[23:0] func_way0;
		input	[23:0] func_way1;
		input	[23:0] func_way2;
		input	[23:0] func_way3;
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
	function [63:0] func_upload_enable_byte_gen;
		input	[3:0] func_addr;
		input	[1:0] func_order;
		reg [63:0] func_local_data;
		begin
			case(func_order == 2'h0)
				2'h0 : func_local_data = 64'h0000000000000001 << func_addr;
				2'h1 : func_local_data = 64'h0000000000000003 << func_addr;
				2'h2 : func_local_data = 64'h000000000000000F << func_addr;
				default : func_local_data = 64'h0000000000000000;
			endcase
		end
	endfunction
	
	
	//Low Pryority Line Search
	function [1:0] func_write_way_search;
		input	[21:0]	write_addr;
		input	[21:0]	way0_adder_tag;
		input	[21:0]	way1_adder_tag;
		input	[21:0]	way2_adder_tag;
		input	[21:0]	way3_adder_tag;
		input	[1:0]	way0_status;
		input	[1:0]	way1_status;
		input	[1:0]	way2_status;
		input	[1:0]	way3_status;
		begin
			//LINE Update
			if(write_addr == way0_adder_tag)begin
				func_write_way_search	=	2'h0;
			end
			else if(write_addr == way1_adder_tag)begin
				func_write_way_search	=	2'h1;
			end
			else if(write_addr == way2_adder_tag)begin
				func_write_way_search	=	2'h2;
			end
			else if(write_addr == way3_adder_tag)begin
				func_write_way_search	=	2'h3;
			end
			//New Write
			else if(way0_status == 2'h0)
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
			else if(func_request_addr == func_way1[21:0] && func_way1[23:22] != 2'h0)begin
				func_hit_check	=	{1'b1, 2'h1};
			end
			else if(func_request_addr == func_way2[21:0] && func_way2[23:22] != 2'h0)begin
				func_hit_check	=	{1'b1, 2'h2};
			end
			else if(func_request_addr == func_way3[21:0] && func_way3[23:22] != 2'h0)begin
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
		input	[23:0] func_tag;
		begin
			func_get_status_tag		=	func_tag[23:22];
		end
	endfunction
	
	//Get Tag Address
	function [21:0] func_get_address_tag;
		input	[23:0] func_tag;
		begin
			func_get_address_tag	=	func_tag[21:0];
		end
	endfunction
	
	function [63:0] func_data_selector;
		input [2:0] func_select;
		input [511:0] func_data;
		begin
			case(func_select)
				3'h0 : func_data_selector = func_data[63:0];
				3'h1 : func_data_selector = func_data[127:64];
				3'h2 : func_data_selector = func_data[191:128];
				3'h3 : func_data_selector = func_data[255:192];
				3'h4 : func_data_selector = func_data[319:256];
				3'h5 : func_data_selector = func_data[383:320];
				3'h6 : func_data_selector = func_data[447:384];
				3'h7 : func_data_selector = func_data[511:448];
			endcase
		end
	endfunction
	
	function [27:0] func_mmu_flags_selector;
		input [2:0] func_select;
		input [255:0] func_data;
		begin
			case(func_select)
				3'h0 : func_mmu_flags_selector = {func_data[29:16], func_data[13:0]};
				3'h1 : func_mmu_flags_selector = {func_data[61:48], func_data[45:32]};
				3'h2 : func_mmu_flags_selector = {func_data[93:80], func_data[77:64]};
				3'h3 : func_mmu_flags_selector = {func_data[125:112], func_data[109:96]};
				3'h4 : func_mmu_flags_selector = {func_data[157:144], func_data[141:128]};
				3'h5 : func_mmu_flags_selector = {func_data[189:176], func_data[173:160]};
				3'h6 : func_mmu_flags_selector = {func_data[221:208], func_data[205:192]};
				3'h7 : func_mmu_flags_selector = {func_data[253:240], func_data[237:224]};
			endcase
		end
	endfunction
	
 
	/********************************************
	Tag Pryority & Tag Control
	********************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 16; i = i + 1)begin
				/*
				if(`PROCESSOR_DATA_RESET_EN)begin
					tag0[i] 			<=	tag0[i] & 24'h000000;		//Clear LRU_Status bit
					tag1[i] 			<=	tag1[i] & 24'h000000;		//Clear LRU_Status bit
					tag2[i] 			<=	tag2[i] & 24'h000000;		//Clear LRU_Status bit
					tag3[i] 			<=	tag3[i] & 24'h000000;		//Clear LRU_Status bit
				end
				else begin
					tag0[i] 			<=	tag0[i] & 24'h3FFFFF;		//Clear LRU_Status bit
					tag1[i] 			<=	tag1[i] & 24'h3FFFFF;		//Clear LRU_Status bit
					tag2[i] 			<=	tag2[i] & 24'h3FFFFF;		//Clear LRU_Status bit
					tag3[i] 			<=	tag3[i] & 24'h3FFFFF;		//Clear LRU_Status bit
				end
				*/
				tag0[i] <=	tag0[i] & 24'h000000;		//Clear LRU_Status bit
				tag1[i] <=	tag1[i] & 24'h000000;		//Clear LRU_Status bit
				tag2[i] <=	tag2[i] & 24'h000000;		//Clear LRU_Status bit
				tag3[i] <=	tag3[i] & 24'h000000;		//Clear LRU_Status bit
			end
			b_load_req_valid			<=	1'b0;
		end
		else if(iREMOVE)begin
			for(i = 0; i < 16; i = i + 1)begin
				/*
				if(`PROCESSOR_DATA_RESET_EN)begin
					tag0[i] 			<=	tag0[i] & 24'h000000;		//Clear LRU_Status bit
					tag1[i] 			<=	tag1[i] & 24'h000000;		//Clear LRU_Status bit
					tag2[i] 			<=	tag2[i] & 24'h000000;		//Clear LRU_Status bit
					tag3[i] 			<=	tag3[i] & 24'h000000;		//Clear LRU_Status bit
				end
				else begin
					tag0[i] 			<=	tag0[i] & 24'h3FFFFF;		//Clear LRU_Status bit
					tag1[i] 			<=	tag1[i] & 24'h3FFFFF;		//Clear LRU_Status bit
					tag2[i] 			<=	tag2[i] & 24'h3FFFFF;		//Clear LRU_Status bit
					tag3[i] 			<=	tag3[i] & 24'h3FFFFF;		//Clear LRU_Status bit
				end
				*/
				tag0[i] <=	tag0[i] & 24'h000000;		//Clear LRU_Status bit
				tag1[i] <=	tag1[i] & 24'h000000;		//Clear LRU_Status bit
				tag2[i] <=	tag2[i] & 24'h000000;		//Clear LRU_Status bit
				tag3[i] <=	tag3[i] & 24'h000000;		//Clear LRU_Status bit
			end
			b_load_req_valid			<=	1'b0;
		end
		else begin
			//Request Valid
			if(!this_read_lock)begin
				b_load_req_valid			<=	iRD_REQ;
			end
			
			//Upload
			if(iUP_REQ)begin
				if(upload_need)begin
					case(upload_way)
						2'h0:	tag0[write_pointer] <=	{((func_get_status_tag(tag0[upload_pointer]) != 2'b11)? func_get_status_tag(tag0[upload_pointer]) + 2'h1 : func_get_status_tag(tag0[upload_pointer])), func_get_address_tag(tag0[upload_pointer])};
						2'h1:	tag1[write_pointer] <=	{((func_get_status_tag(tag1[upload_pointer]) != 2'b11)? func_get_status_tag(tag1[upload_pointer]) + 2'h1 : func_get_status_tag(tag1[upload_pointer])), func_get_address_tag(tag1[upload_pointer])};
						2'h2:	tag2[write_pointer] <=	{((func_get_status_tag(tag2[upload_pointer]) != 2'b11)? func_get_status_tag(tag2[upload_pointer]) + 2'h1 : func_get_status_tag(tag2[upload_pointer])), func_get_address_tag(tag2[upload_pointer])};
						2'h3:	tag3[write_pointer] <=	{((func_get_status_tag(tag3[upload_pointer]) != 2'b11)? func_get_status_tag(tag3[upload_pointer]) + 2'h1 : func_get_status_tag(tag3[upload_pointer])), func_get_address_tag(tag3[upload_pointer])};
					endcase
				end
			end
			//Write
			else if(iWR_REQ)begin
				case(write_way)		
					2'h0:	tag0[write_pointer] <=	{2'b11, iWR_ADDR[31:10]};
					2'h1:	tag1[write_pointer] <=	{2'b11, iWR_ADDR[31:10]};
					2'h2:	tag2[write_pointer] <=	{2'b11, iWR_ADDR[31:10]};
					2'h3:	tag3[write_pointer] <=	{2'b11, iWR_ADDR[31:10]};
				endcase
			end
			else begin
				//Read & LRU Controal
				if(!this_read_lock)begin
					if(iRD_REQ && read_hit && lru_valid)begin
						for(i = 0; i < 16; i = i + 1)begin
							//TAG0
							if(read_pointer == i[3:0] && read_way == 2'h0)begin
								tag0[read_pointer] <= {2'b11, func_get_address_tag(tag0[read_pointer])};
							end
							else begin
								if(func_get_status_tag(tag0[i[3:0]]) != 2'h0 && func_get_status_tag(tag0[i[3:0]]) != 2'h1)begin
									tag0[i[3:0]] <= {(func_get_status_tag(tag0[i[3:0]]) - 2'h1), func_get_address_tag(tag0[i[3:0]])};
								end
							end
							//TAG1
							if(read_pointer == i[3:0] && read_way == 2'h1)begin
								tag1[read_pointer] <= {2'b11, func_get_address_tag(tag1[read_pointer])};
							end
							else begin
								if(func_get_status_tag(tag1[i[3:0]]) != 2'h0 && func_get_status_tag(tag1[i[3:0]]) != 2'h1)begin
									tag1[i[3:0]] <= {(func_get_status_tag(tag1[i[3:0]]) - 2'h1), func_get_address_tag(tag1[i[3:0]])};
								end
							end
							//TAG2
							if(read_pointer == i[3:0] && read_way == 2'h2)begin
								tag2[read_pointer] <= {2'b11, func_get_address_tag(tag2[read_pointer])};
							end
							else begin
								if(func_get_status_tag(tag2[i[3:0]]) != 2'h0 && func_get_status_tag(tag2[i[3:0]]) != 2'h1)begin
									tag2[i[3:0]] <= {(func_get_status_tag(tag2[i[3:0]]) - 2'h1), func_get_address_tag(tag2[i[3:0]])};
								end
							end
							//TAG3
							if(read_pointer == i[3:0] && read_way == 2'h3)begin
								tag3[read_pointer] <= {2'b11, func_get_address_tag(tag3[read_pointer])};
							end
							else begin
								if(func_get_status_tag(tag3[i[3:0]]) != 2'h0 && func_get_status_tag(tag3[i[3:0]]) != 2'h1)begin
									tag3[i[3:0]] <= {(func_get_status_tag(tag3[i[3:0]]) - 2'h1), func_get_address_tag(tag3[i[3:0]])};
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
										tag0[read_pointer] <= {2'b11/*(func_get_status_tag(tag0[read_pointer]) + 2'h1)*/, func_get_address_tag(tag0[read_pointer])};
									end
								end
							2'h1	:
								begin
									if(func_get_status_tag(tag1[read_pointer]) != 2'b11)begin
										tag1[read_pointer] <= {2'b11, func_get_address_tag(tag1[read_pointer])};
									end
								end
							2'h2	:
								begin
									if(func_get_status_tag(tag2[read_pointer]) != 2'b11)begin
										tag2[read_pointer] <= {2'b11, func_get_address_tag(tag2[read_pointer])};
									end
								end
							2'h3	:
								begin
									if(func_get_status_tag(tag3[read_pointer]) != 2'b11)begin
										tag3[read_pointer] <= {2'b11, func_get_address_tag(tag3[read_pointer])};
									end
								end
						endcase
					end
					//LRU Controal
					else if(lru_valid)begin
						for(i = 0; i < 16; i = i + 1)begin
							//TAG0
							if(func_get_status_tag(tag0[i[3:0]]) != 2'h0 && func_get_status_tag(tag0[i[3:0]]) != 2'h1)begin
								tag0[i[3:0]] <=	{(func_get_status_tag(tag0[i[3:0]]) - 2'h1), func_get_address_tag(tag0[i[3:0]])};
							end
							//TAG1
							if(func_get_status_tag(tag1[i[3:0]]) != 2'h0 && func_get_status_tag(tag1[i[3:0]]) != 2'h1)begin
								tag1[i[3:0]] <=	{(func_get_status_tag(tag1[i[3:0]]) - 2'h1), func_get_address_tag(tag1[i[3:0]])};
							end
							//TAG2
							if(func_get_status_tag(tag2[i[3:0]]) != 2'h0 && func_get_status_tag(tag2[i[3:0]]) != 2'h1)begin
								tag2[i[3:0]] <=	{(func_get_status_tag(tag2[i[3:0]]) - 2'h1), func_get_address_tag(tag2[i[3:0]])};
							end
							//TAG3
							if(func_get_status_tag(tag3[i[3:0]]) != 2'h0 && func_get_status_tag(tag3[i[3:0]]) != 2'h1)begin
								tag3[i[3:0]] <=	{(func_get_status_tag(tag3[i[3:0]]) - 2'h1), func_get_address_tag(tag3[i[3:0]])};
							end
						end
					end
				end //End !Lock
			end
		end
	end //always
	
	
	/********************************************
	Output Buffer
	********************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_rd_hit <= 1'h0;
			b_rd_way <= 2'h0;
			b_rd_addr <= 32'h0;
		end
		else begin
			if(!this_read_lock)begin
				b_rd_hit <= read_hit;
				b_rd_way <= read_way;
				b_rd_addr <= iRD_ADDR;
			end
		end
	end
	
	/*****************************************************
	Output Assign
	*****************************************************/
	assign oRD_BUSY = iRD_BUSY || (iRD_REQ && iWR_REQ && iRD_ADDR == iWR_ADDR);	
	assign oRD_VALID = b_load_req_valid && !this_read_lock;
	assign oRD_HIT = b_load_req_valid && !this_read_lock && b_rd_hit;
	assign oRD_DATA = (b_load_req_valid && !this_read_lock && b_rd_hit)? (
								(b_rd_way == 2'h0)? func_data_selector(b_rd_addr[5:3], memory_way0_out_data) : (
									(b_rd_way == 2'h1)? func_data_selector(b_rd_addr[5:3], memory_way1_out_data) : (
										(b_rd_way == 2'h2)? func_data_selector(b_rd_addr[5:3], memory_way2_out_data) : func_data_selector(b_rd_addr[5:3], memory_way3_out_data)
									)
								)
							) : 64'h0;									
	assign oRD_MMU_FLAGS = (b_load_req_valid && !this_read_lock && b_rd_hit)? (
								(b_rd_way == 2'h0)? func_mmu_flags_selector(b_rd_addr[5:3], memory_mmuflag_way0_out_data) : (
									(b_rd_way == 2'h1)? func_mmu_flags_selector(b_rd_addr[5:3], memory_mmuflag_way1_out_data) : (
										(b_rd_way == 2'h2)? func_mmu_flags_selector(b_rd_addr[5:3], memory_mmuflag_way2_out_data) : func_mmu_flags_selector(b_rd_addr[5:3], memory_mmuflag_way3_out_data)
									)
								)
							) : 12'h0;
	assign oWR_BUSY = this_write_lock;
	
	assign oUP_BUSY = iWR_REQ;
	
				
	
endmodule


`default_nettype wire


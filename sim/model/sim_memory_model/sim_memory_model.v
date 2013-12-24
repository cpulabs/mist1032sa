/****************************************************
SIM Memory Model
	with byte & half_word access controller
	
	
Memory Model
	Little Endian
	Ex :
		data = 0x01234567
		
		-Load
		load_word[0] = 0x01234567
		load_hf_word[0] = 0x0123
		load_byte[0] = 0x01
	
		-Store
		store_word[0], 0x89abcdef = 0x89abcdef
		store_hf_word[0], 0x89ab = 0x89ab4567
		store_byte[0], 0x89 = 0x89234567
****************************************************/

`default_nettype none

module sim_memory_model(
		input wire iCLOCK,
		input wire inRESET,
		//Req
		input wire iMEMORY_REQ,
		output wire oMEMORY_LOCK,
		input wire [1:0] iMEMORY_ORDER,				//00=Byte Order 01=2Byte Order 10= Word Order 11= None
		input wire [3:0] iMEMORY_MASK,
		input wire iMEMORY_RW,						//1:Write | 0:Read
		input wire [25:0] iMEMORY_ADDR,
		//This -> Data RAM
		input wire [31:0] iMEMORY_DATA,
		//Data RAM -> This
		output wire oMEMORY_VALID,
		input wire iMEMORY_LOCK,
		output wire [63:0] oMEMORY_DATA
	);
	
	parameter P_MEM_INIT_LOAD = 1;		//0=not load | 1=load
	parameter P_MEM_INIT_LOAD_FIEL = "binary_file.bin";
	parameter P_MEM_SIZE = 134217728/8;
	
	wire fifo_write_full;
	wire fifo_read_empty;
	wire [63:0] fifo_read_data;
	
	reg [63:0] b_mem_data[0:P_MEM_SIZE-1];
	
	integer i;

	wire system_busy = fifo_write_full;
	wire system_read_condition = iMEMORY_REQ && !iMEMORY_RW && !system_busy;
	wire system_write_condition = iMEMORY_REQ && iMEMORY_RW && !system_busy;
						
	
	function [63:0] func_data_mask;
		input func_word_select; //0
		input [3:0] func_byte_enable;	//1111
		input [31:0] func_new_data;
		input [63:0] func_current_data;
		reg [63:0] func_private_data;
		begin
			if(!func_word_select)begin
				func_private_data[7:0] = (func_byte_enable[0])? func_new_data[7:0] : func_current_data[7:0];
				func_private_data[15:8] = (func_byte_enable[1])? func_new_data[15:8] : func_current_data[15:8];
				func_private_data[23:16] = (func_byte_enable[2])? func_new_data[23:16] : func_current_data[23:16];
				func_private_data[31:24] = (func_byte_enable[3])? func_new_data[31:24] : func_current_data[31:24];
				func_private_data[63:32] = func_current_data[63:32];
			end
			else begin
				func_private_data[39:32] = (func_byte_enable[0])? func_new_data[7:0] : func_current_data[39:32];
				func_private_data[47:40] = (func_byte_enable[1])? func_new_data[15:8] : func_current_data[47:40];
				func_private_data[55:48] = (func_byte_enable[2])? func_new_data[23:16] : func_current_data[55:48];
				func_private_data[63:56] = (func_byte_enable[3])? func_new_data[31:24] : func_current_data[63:56];
				func_private_data[31:0] = func_current_data[31:0];
			end
			func_data_mask = func_private_data;
		end
	endfunction
	
	//Memory Write Block
	always@(posedge iCLOCK )begin
		if(system_write_condition)begin
			b_mem_data[iMEMORY_ADDR[25:3]] <= 
				func_data_mask(
					iMEMORY_ADDR[2],
					iMEMORY_MASK, 
					iMEMORY_DATA, 
					b_mem_data[iMEMORY_ADDR[25:3]]
				);
		end
	end
	
	
	//Memory

	initial begin
		#0 begin
			if(P_MEM_INIT_LOAD)begin
				//Load File
				//$readmemh("inst_level_test_tmp.hex", b_mem_data);
				$readmemh(P_MEM_INIT_LOAD_FIEL, b_mem_data);
				//Endian Convert
				$display("[INF][sim_memory_model.v]Please wait. Endian converting for test file.");
				for(i = 0; i < P_MEM_SIZE; i = i + 1)begin
					b_mem_data[i] = func_endian_convert(b_mem_data[i]);		//[]
				end
				$display("test!!!!!");
				$display("[INF][sim_memory_model.v]Mem[0]->%x", b_mem_data[0]);
			end
		end
	end
	
	function [63:0] func_endian_convert;
		input [63:0] func_data;
		reg [31:0] func_tmp;
		begin
			func_tmp = func_data[63:32];
			func_endian_convert = {
				func_tmp[7:0], func_tmp[15:8], func_tmp[23:16], func_tmp[31:24],
				func_data[7:0], func_data[15:8], func_data[23:16], func_data[31:24]
			};
		end
	endfunction

	
	mist1032isa_sync_fifo #(64, 8, 3) OUT_FIFO(
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.oCOUNT(),
		.iWR_EN((system_read_condition) && !fifo_write_full),
		.iWR_DATA(b_mem_data[iMEMORY_ADDR[25:3]]),
		.oWR_FULL(fifo_write_full),
		.iRD_EN(!iMEMORY_LOCK  && !fifo_read_empty),
		.oRD_DATA(fifo_read_data),
		.oRD_EMPTY(fifo_read_empty)
	);
	
	assign oMEMORY_VALID = !iMEMORY_LOCK  && !fifo_read_empty;
	assign oMEMORY_DATA = fifo_read_data;
	assign oMEMORY_LOCK = fifo_write_full;
	
endmodule


`default_nettype wire




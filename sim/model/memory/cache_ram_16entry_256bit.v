
`default_nettype wire

module cache_ram_16entry_256bit(
		input clock,
		input [31:0] byteena_a,
		//Write
		input wren,
		input [3:0] wraddress,
		input [255:0] data,
		//Read
		input [3:0] rdaddress,
		output [255:0] q
	);

	
	reg [255:0] b_mem[0:15];
	always@(posedge clock)begin
		if(wren)begin
			b_mem[wraddress] <= func_byteena_o(byteena_a, b_mem[wraddress], data);
		end
	end
	
	function [255:0] func_byteena_o;
		input [31:0] func_byteena;
		input [255:0] func_current_data;
		input [255:0] func_new_data;
		 reg [255:0] func_local_data;
		begin
			func_local_data[7:0] = (func_byteena[0])? func_new_data[7:0] : func_current_data[7:0];
			func_local_data[15:8] = (func_byteena[1])? func_new_data[15:8] : func_current_data[15:8];
			func_local_data[23:16] = (func_byteena[2])? func_new_data[23:16] : func_current_data[23:16];
			func_local_data[31:24] = (func_byteena[3])? func_new_data[31:24] : func_current_data[31:24];
			func_local_data[39:32] = (func_byteena[4])? func_new_data[39:32] : func_current_data[39:32];
			func_local_data[47:40] = (func_byteena[5])? func_new_data[47:40] : func_current_data[47:40];
			func_local_data[55:48] = (func_byteena[6])? func_new_data[55:48] : func_current_data[55:48];
			func_local_data[63:56] = (func_byteena[7])? func_new_data[63:56] : func_current_data[63:56];
			func_local_data[71:64] = (func_byteena[8])? func_new_data[71:64] : func_current_data[71:64];
			func_local_data[79:72] = (func_byteena[9])? func_new_data[79:72] : func_current_data[79:72];
			func_local_data[87:80] = (func_byteena[10])? func_new_data[87:80] : func_current_data[87:80];
			func_local_data[95:88] = (func_byteena[11])? func_new_data[95:88] : func_current_data[95:88];
			func_local_data[103:96] = (func_byteena[12])? func_new_data[103:96] : func_current_data[103:96];
			func_local_data[111:104] = (func_byteena[13])? func_new_data[111:104] : func_current_data[111:104];
			func_local_data[119:112] = (func_byteena[14])? func_new_data[119:112] : func_current_data[119:112];
			func_local_data[127:120] = (func_byteena[15])? func_new_data[127:120] : func_current_data[127:120];
			func_local_data[135:128] = (func_byteena[16])? func_new_data[135:128] : func_current_data[135:128];
			func_local_data[143:136] = (func_byteena[17])? func_new_data[143:136] : func_current_data[143:136];
			func_local_data[151:144] = (func_byteena[18])? func_new_data[151:144] : func_current_data[151:144];
			func_local_data[159:152] = (func_byteena[19])? func_new_data[159:152] : func_current_data[159:152];
			func_local_data[167:160] = (func_byteena[20])? func_new_data[167:160] : func_current_data[167:160];
			func_local_data[175:168] = (func_byteena[21])? func_new_data[175:168] : func_current_data[175:168];
			func_local_data[183:176] = (func_byteena[22])? func_new_data[183:176] : func_current_data[183:176];
			func_local_data[191:184] = (func_byteena[23])? func_new_data[191:184] : func_current_data[191:184];
			func_local_data[199:192] = (func_byteena[24])? func_new_data[199:192] : func_current_data[199:192];
			func_local_data[207:200] = (func_byteena[25])? func_new_data[207:200] : func_current_data[207:200];
			func_local_data[215:208] = (func_byteena[26])? func_new_data[215:208] : func_current_data[215:208];
			func_local_data[223:216] = (func_byteena[27])? func_new_data[223:216] : func_current_data[223:216];
			func_local_data[231:224] = (func_byteena[28])? func_new_data[231:224] : func_current_data[231:224];
			func_local_data[239:232] = (func_byteena[29])? func_new_data[239:232] : func_current_data[239:232];
			func_local_data[247:240] = (func_byteena[30])? func_new_data[247:240] : func_current_data[247:240];
			func_local_data[255:248] = (func_byteena[31])? func_new_data[255:248] : func_current_data[255:248];
			func_byteena_o = func_local_data;
		end
	endfunction
	
	
	
	reg [255:0] b_data_buff;
	always@(posedge clock)begin
		b_data_buff <= b_mem[rdaddress];
	end
	
	assign q = b_data_buff;//b_mem[rdaddress];


endmodule

`default_nettype none

`default_nettype wire



module cache_ram_16entry_512bit(
		input clock,
		input [63:0] byteena_a,
		//Write
		input wren,
		input [3:0] wraddress,
		input [511:0] data,
		//Read
		input [3:0] rdaddress,
		output [511:0] q
	);

	
	reg [511:0] b_mem[0:15];
	always@(posedge clock)begin
		if(wren)begin
			b_mem[wraddress] <= func_byteena_o(byteena_a, b_mem[wraddress], data);
		end
	end
	
	function [511:0] func_byteena_o;
		input [63:0] func_byteena;
		input [511:0] func_current_data;
		input [511:0] func_new_data;
		 reg [511:0] func_local_data;
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
			func_local_data[263:256] = (func_byteena[32])? func_new_data[263:256] : func_current_data[263:256];
			func_local_data[271:264] = (func_byteena[33])? func_new_data[271:264] : func_current_data[271:264];
			func_local_data[279:272] = (func_byteena[34])? func_new_data[279:272] : func_current_data[279:272];
			func_local_data[287:280] = (func_byteena[35])? func_new_data[287:280] : func_current_data[287:280];
			func_local_data[295:288] = (func_byteena[36])? func_new_data[295:288] : func_current_data[295:288];
			func_local_data[303:296] = (func_byteena[37])? func_new_data[303:296] : func_current_data[303:296];
			func_local_data[311:304] = (func_byteena[38])? func_new_data[311:304] : func_current_data[311:304];
			func_local_data[319:312] = (func_byteena[39])? func_new_data[319:312] : func_current_data[319:312];
			func_local_data[327:320] = (func_byteena[40])? func_new_data[327:320] : func_current_data[327:320];
			func_local_data[335:328] = (func_byteena[41])? func_new_data[335:328] : func_current_data[335:328];
			func_local_data[343:336] = (func_byteena[42])? func_new_data[343:336] : func_current_data[343:336];
			func_local_data[351:344] = (func_byteena[43])? func_new_data[351:344] : func_current_data[351:344];
			func_local_data[359:352] = (func_byteena[44])? func_new_data[359:352] : func_current_data[359:352];
			func_local_data[367:360] = (func_byteena[45])? func_new_data[367:360] : func_current_data[367:360];
			func_local_data[375:368] = (func_byteena[46])? func_new_data[375:368] : func_current_data[375:368];
			func_local_data[383:376] = (func_byteena[47])? func_new_data[383:376] : func_current_data[383:376];
			func_local_data[391:384] = (func_byteena[48])? func_new_data[391:384] : func_current_data[391:384];
			func_local_data[399:392] = (func_byteena[49])? func_new_data[399:392] : func_current_data[399:392];
			func_local_data[407:400] = (func_byteena[50])? func_new_data[407:400] : func_current_data[407:400];
			func_local_data[415:408] = (func_byteena[51])? func_new_data[415:408] : func_current_data[415:408];
			func_local_data[423:416] = (func_byteena[52])? func_new_data[423:416] : func_current_data[423:416];
			func_local_data[431:424] = (func_byteena[53])? func_new_data[431:424] : func_current_data[431:424];
			func_local_data[439:432] = (func_byteena[54])? func_new_data[439:432] : func_current_data[439:432];
			func_local_data[447:440] = (func_byteena[55])? func_new_data[447:440] : func_current_data[447:440];
			func_local_data[455:448] = (func_byteena[56])? func_new_data[455:448] : func_current_data[455:448];
			func_local_data[463:456] = (func_byteena[57])? func_new_data[463:456] : func_current_data[463:456];
			func_local_data[471:464] = (func_byteena[58])? func_new_data[471:464] : func_current_data[471:464];
			func_local_data[479:472] = (func_byteena[59])? func_new_data[479:472] : func_current_data[479:472];
			func_local_data[487:480] = (func_byteena[60])? func_new_data[487:480] : func_current_data[487:480];
			func_local_data[495:488] = (func_byteena[61])? func_new_data[495:488] : func_current_data[495:488];
			func_local_data[503:496] = (func_byteena[62])? func_new_data[503:496] : func_current_data[503:496];
			func_local_data[511:504] = (func_byteena[63])? func_new_data[511:504] : func_current_data[511:504];
			func_byteena_o = func_local_data;
		end
	endfunction
	
	reg [511:0] b_data_buff;
	always@(posedge clock)begin
		b_data_buff <= b_mem[rdaddress];
	end
	
	assign q = b_data_buff;//b_mem[rdaddress];


endmodule

`default_nettype none
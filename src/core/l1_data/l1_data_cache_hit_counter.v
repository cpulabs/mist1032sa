`default_nettype none 

module l1_data_cache_counter(
		input wire iCLOCK,
		input wire inRESET,
		//Hit Infomation
		input wire iCACHE_VALID,
		input wire iCACHE_HIT,
		//Infomation
		output wire [6:0] oINFO_COUNT
	);

	reg [99:0] b_counter;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_counter <= 100'h0;
		end
		else begin
			if(iCACHE_VALID)begin
				b_counter <= {b_counter[98:0], iCACHE_HIT};
			end
		end
	end
	
	reg [3:0] b_buffer0[0:9];	//10*10
	reg [5:0] b_buffer1[0:1];	//50*2
	reg [6:0] b_buffer2;		//100*1
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_buffer0[0] <= 4'h0;
			b_buffer0[1] <= 4'h0;
			b_buffer0[2] <= 4'h0;
			b_buffer0[3] <= 4'h0;
			b_buffer0[4] <= 4'h0;
			b_buffer0[5] <= 4'h0;
			b_buffer0[6] <= 4'h0;
			b_buffer0[7] <= 4'h0;
			b_buffer0[8] <= 4'h0;
			b_buffer0[9] <= 4'h0;
			b_buffer1[0] <= 6'h0;
			b_buffer1[1] <= 6'h1;
			b_buffer2 <= 7'h0;
		end
		else begin
			//Buffer0
			b_buffer0[0] <= 4'h0
							+ b_counter[0] + b_counter[1] + b_counter[2] + b_counter[3] + b_counter[4]
							+ b_counter[5] + b_counter[6] + b_counter[7] + b_counter[8] + b_counter[9];
			b_buffer0[1] <= 4'h0
							+ b_counter[10] + b_counter[11] + b_counter[12] + b_counter[13] + b_counter[14]
							+ b_counter[15] + b_counter[16] + b_counter[17] + b_counter[18] + b_counter[19];
			b_buffer0[2] <= 4'h0
							+ b_counter[20] + b_counter[21] + b_counter[22] + b_counter[23] + b_counter[24]
							+ b_counter[25] + b_counter[26] + b_counter[27] + b_counter[28] + b_counter[29];
			b_buffer0[3] <= 4'h0
							+ b_counter[30] + b_counter[31] + b_counter[32] + b_counter[33] + b_counter[34]
							+ b_counter[35] + b_counter[36] + b_counter[37] + b_counter[38] + b_counter[39];
			b_buffer0[4] <= 4'h0
							+ b_counter[40] + b_counter[41] + b_counter[42] + b_counter[43] + b_counter[44]
							+ b_counter[45] + b_counter[46] + b_counter[47] + b_counter[48] + b_counter[49];
			b_buffer0[5] <= 4'h0
							+ b_counter[50] + b_counter[51] + b_counter[52] + b_counter[53] + b_counter[54]
							+ b_counter[55] + b_counter[56] + b_counter[57] + b_counter[58] + b_counter[59];
			b_buffer0[6] <= 4'h0
							+ b_counter[60] + b_counter[61] + b_counter[62] + b_counter[63] + b_counter[64]
							+ b_counter[65] + b_counter[66] + b_counter[67] + b_counter[68] + b_counter[69];
			b_buffer0[7] <= 4'h0
							+ b_counter[70] + b_counter[71] + b_counter[72] + b_counter[73] + b_counter[74]
							+ b_counter[75] + b_counter[76] + b_counter[77] + b_counter[78] + b_counter[79];
			b_buffer0[8] <= 4'h0
							+ b_counter[80] + b_counter[81] + b_counter[82] + b_counter[83] + b_counter[84]
							+ b_counter[85] + b_counter[86] + b_counter[87] + b_counter[88] + b_counter[89];
			b_buffer0[9] <= 4'h0
							+ b_counter[90] + b_counter[91] + b_counter[92] + b_counter[93] + b_counter[94]
							+ b_counter[95] + b_counter[96] + b_counter[97] + b_counter[98] + b_counter[99];
			b_buffer1[0] <= 6'h0 + b_buffer0[0] + b_buffer0[1] + b_buffer0[2] + b_buffer0[3] + b_buffer0[4];
			b_buffer1[1] <= 6'h0 + b_buffer0[5] + b_buffer0[6] + b_buffer0[7] + b_buffer0[8] + b_buffer0[9]; 
			b_buffer2 <= b_buffer1[0] + b_buffer1[1];
		end
	end 
	
	assign oINFO_COUNT = b_buffer2;
	
endmodule

`default_nettype wire 

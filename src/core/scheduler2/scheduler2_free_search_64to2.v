
`default_nettype none

module scheduler2_free_search_64to2(
		input wire iENTRY0_VALID,
		input wire iENTRY1_VALID,
		input wire iENTRY2_VALID,
		input wire iENTRY3_VALID,
		input wire iENTRY4_VALID,
		input wire iENTRY5_VALID,
		input wire iENTRY6_VALID,
		input wire iENTRY7_VALID,
		input wire iENTRY8_VALID,
		input wire iENTRY9_VALID,
		input wire iENTRY10_VALID,
		input wire iENTRY11_VALID,
		input wire iENTRY12_VALID,
		input wire iENTRY13_VALID,
		input wire iENTRY14_VALID,
		input wire iENTRY15_VALID,
		input wire iENTRY16_VALID,
		input wire iENTRY17_VALID,
		input wire iENTRY18_VALID,
		input wire iENTRY19_VALID,
		input wire iENTRY20_VALID,
		input wire iENTRY21_VALID,
		input wire iENTRY22_VALID,
		input wire iENTRY23_VALID,
		input wire iENTRY24_VALID,
		input wire iENTRY25_VALID,
		input wire iENTRY26_VALID,
		input wire iENTRY27_VALID,
		input wire iENTRY28_VALID,
		input wire iENTRY29_VALID,
		input wire iENTRY30_VALID,
		input wire iENTRY31_VALID,
		input wire iENTRY32_VALID,
		input wire iENTRY33_VALID,
		input wire iENTRY34_VALID,
		input wire iENTRY35_VALID,
		input wire iENTRY36_VALID,
		input wire iENTRY37_VALID,
		input wire iENTRY38_VALID,
		input wire iENTRY39_VALID,
		input wire iENTRY40_VALID,
		input wire iENTRY41_VALID,
		input wire iENTRY42_VALID,
		input wire iENTRY43_VALID,
		input wire iENTRY44_VALID,
		input wire iENTRY45_VALID,
		input wire iENTRY46_VALID,
		input wire iENTRY47_VALID,
		input wire iENTRY48_VALID,
		input wire iENTRY49_VALID,
		input wire iENTRY50_VALID,
		input wire iENTRY51_VALID,
		input wire iENTRY52_VALID,
		input wire iENTRY53_VALID,
		input wire iENTRY54_VALID,
		input wire iENTRY55_VALID,
		input wire iENTRY56_VALID,
		input wire iENTRY57_VALID,
		input wire iENTRY58_VALID,
		input wire iENTRY59_VALID,
		input wire iENTRY60_VALID,
		input wire iENTRY61_VALID,
		input wire iENTRY62_VALID,
		input wire iENTRY63_VALID,
		//Output
		output wire oSELECT0_VALID,
		output wire [5:0] oSELECT0_ENTRY,
		output wire oSELECT1_VALID,
		output wire [5:0] oSELECT1_ENTRY
	);

	assign {
		oSELECT1_VALID, oSELECT1_ENTRY, 
		oSELECT0_VALID, oSELECT0_ENTRY
	} = func_free_entry_search64to2(
				iENTRY0_VALID,
		iENTRY1_VALID,
		iENTRY2_VALID,
		iENTRY3_VALID,
		iENTRY4_VALID,
		iENTRY5_VALID,
		iENTRY6_VALID,
		iENTRY7_VALID,
		iENTRY8_VALID,
		iENTRY9_VALID,
		iENTRY10_VALID,
		iENTRY11_VALID,
		iENTRY12_VALID,
		iENTRY13_VALID,
		iENTRY14_VALID,
		iENTRY15_VALID,
		iENTRY16_VALID,
		iENTRY17_VALID,
		iENTRY18_VALID,
		iENTRY19_VALID,
		iENTRY20_VALID,
		iENTRY21_VALID,
		iENTRY22_VALID,
		iENTRY23_VALID,
		iENTRY24_VALID,
		iENTRY25_VALID,
		iENTRY26_VALID,
		iENTRY27_VALID,
		iENTRY28_VALID,
		iENTRY29_VALID,
		iENTRY30_VALID,
		iENTRY31_VALID,
		iENTRY32_VALID,
		iENTRY33_VALID,
		iENTRY34_VALID,
		iENTRY35_VALID,
		iENTRY36_VALID,
		iENTRY37_VALID,
		iENTRY38_VALID,
		iENTRY39_VALID,
		iENTRY40_VALID,
		iENTRY41_VALID,
		iENTRY42_VALID,
		iENTRY43_VALID,
		iENTRY44_VALID,
		iENTRY45_VALID,
		iENTRY46_VALID,
		iENTRY47_VALID,
		iENTRY48_VALID,
		iENTRY49_VALID,
		iENTRY50_VALID,
		iENTRY51_VALID,
		iENTRY52_VALID,
		iENTRY53_VALID,
		iENTRY54_VALID,
		iENTRY55_VALID,
		iENTRY56_VALID,
		iENTRY57_VALID,
		iENTRY58_VALID,
		iENTRY59_VALID,
		iENTRY60_VALID,
		iENTRY61_VALID,
		iENTRY62_VALID,
		iENTRY63_VALID
	);
	
	//Reservation station or General Register Free Entry Search
	function [13:0] func_free_entry_search64to2;
		/* Output Signal
		[13] :	Entry 1 Valid
		[12:7] :	Entry 1 Table Numver
		[6] : Entry 0	Valid
		[5:0] :	Entry 0 Table Number
		*/
		input func_free_entry_search64to2_entry_valid0;
		input func_free_entry_search64to2_entry_valid1;
		input func_free_entry_search64to2_entry_valid2;
		input func_free_entry_search64to2_entry_valid3;
		input func_free_entry_search64to2_entry_valid4;
		input func_free_entry_search64to2_entry_valid5;
		input func_free_entry_search64to2_entry_valid6;
		input func_free_entry_search64to2_entry_valid7;
		input func_free_entry_search64to2_entry_valid8;
		input func_free_entry_search64to2_entry_valid9;
		input func_free_entry_search64to2_entry_valid10;
		input func_free_entry_search64to2_entry_valid11;
		input func_free_entry_search64to2_entry_valid12;
		input func_free_entry_search64to2_entry_valid13;
		input func_free_entry_search64to2_entry_valid14;
		input func_free_entry_search64to2_entry_valid15;
		input func_free_entry_search64to2_entry_valid16;
		input func_free_entry_search64to2_entry_valid17;
		input func_free_entry_search64to2_entry_valid18;
		input func_free_entry_search64to2_entry_valid19;
		input func_free_entry_search64to2_entry_valid20;
		input func_free_entry_search64to2_entry_valid21;
		input func_free_entry_search64to2_entry_valid22;
		input func_free_entry_search64to2_entry_valid23;
		input func_free_entry_search64to2_entry_valid24;
		input func_free_entry_search64to2_entry_valid25;
		input func_free_entry_search64to2_entry_valid26;
		input func_free_entry_search64to2_entry_valid27;
		input func_free_entry_search64to2_entry_valid28;
		input func_free_entry_search64to2_entry_valid29;
		input func_free_entry_search64to2_entry_valid30;
		input func_free_entry_search64to2_entry_valid31;
		input func_free_entry_search64to2_entry_valid32;
		input func_free_entry_search64to2_entry_valid33;
		input func_free_entry_search64to2_entry_valid34;
		input func_free_entry_search64to2_entry_valid35;
		input func_free_entry_search64to2_entry_valid36;
		input func_free_entry_search64to2_entry_valid37;
		input func_free_entry_search64to2_entry_valid38;
		input func_free_entry_search64to2_entry_valid39;
		input func_free_entry_search64to2_entry_valid40;
		input func_free_entry_search64to2_entry_valid41;
		input func_free_entry_search64to2_entry_valid42;
		input func_free_entry_search64to2_entry_valid43;
		input func_free_entry_search64to2_entry_valid44;
		input func_free_entry_search64to2_entry_valid45;
		input func_free_entry_search64to2_entry_valid46;
		input func_free_entry_search64to2_entry_valid47;
		input func_free_entry_search64to2_entry_valid48;
		input func_free_entry_search64to2_entry_valid49;
		input func_free_entry_search64to2_entry_valid50;
		input func_free_entry_search64to2_entry_valid51;
		input func_free_entry_search64to2_entry_valid52;
		input func_free_entry_search64to2_entry_valid53;
		input func_free_entry_search64to2_entry_valid54;
		input func_free_entry_search64to2_entry_valid55;
		input func_free_entry_search64to2_entry_valid56;
		input func_free_entry_search64to2_entry_valid57;
		input func_free_entry_search64to2_entry_valid58;
		input func_free_entry_search64to2_entry_valid59;
		input func_free_entry_search64to2_entry_valid60;
		input func_free_entry_search64to2_entry_valid61;
		input func_free_entry_search64to2_entry_valid62;
		input func_free_entry_search64to2_entry_valid63;
		
		
		reg func_free_entry_search64to2_tournament_data0_valid0;
		reg [5:0] func_free_entry_search64to2_tournament_data0_num0;
		reg func_free_entry_search64to2_tournament_data0_valid1;
		reg [5:0] func_free_entry_search64to2_tournament_data0_num1;
		
		reg func_free_entry_search64to2_tournament_data1_valid0[0:1];
		reg [5:0] func_free_entry_search64to2_tournament_data1_num0[0:1];
		reg func_free_entry_search64to2_tournament_data1_valid1[0:1];
		reg [5:0] func_free_entry_search64to2_tournament_data1_num1[0:1];
		
		reg func_free_entry_search64to2_tournament_data2_valid0[0:3];
		reg [5:0] func_free_entry_search64to2_tournament_data2_num0[0:3];
		reg func_free_entry_search64to2_tournament_data2_valid1[0:3];
		reg [5:0] func_free_entry_search64to2_tournament_data2_num1[0:3];
		
		reg func_free_entry_search64to2_tournament_data3_valid0[0:7];
		reg [5:0] func_free_entry_search64to2_tournament_data3_num0[0:7];
		reg func_free_entry_search64to2_tournament_data3_valid1[0:7];
		reg [5:0] func_free_entry_search64to2_tournament_data3_num1[0:7];
		
		reg func_free_entry_search64to2_tournament_data4_valid0[0:15];
		reg [5:0] func_free_entry_search64to2_tournament_data4_num0[0:15];
		reg func_free_entry_search64to2_tournament_data4_valid1[0:15];
		reg [5:0] func_free_entry_search64to2_tournament_data4_num1[0:15];
		
		/*
		reg func_free_entry_search64to2_tournament_data5_valid0[0:31];
		reg [5:0] func_free_entry_search64to2_tournament_data5_num0[0:31];
		reg func_free_entry_search64to2_tournament_data5_valid1[0:31];
		reg [5:0] func_free_entry_search64to2_tournament_data5_num1[0:31];
		*/
		begin
			//5
			
			
			//4
			func_free_entry_search64to2_tournament_data4_valid0[0] = func_free_entry_search64to2_entry_valid0 | func_free_entry_search64to2_entry_valid1;
			func_free_entry_search64to2_tournament_data4_num0[0] = (func_free_entry_search64to2_entry_valid0)? 6'h00 : 6'h01;
			func_free_entry_search64to2_tournament_data4_valid1[0] = func_free_entry_search64to2_entry_valid2 | func_free_entry_search64to2_entry_valid3;
			func_free_entry_search64to2_tournament_data4_num1[0] = (func_free_entry_search64to2_entry_valid2)? 6'h02 : 6'h03;
			func_free_entry_search64to2_tournament_data4_valid0[1] = func_free_entry_search64to2_entry_valid4 | func_free_entry_search64to2_entry_valid5;
			func_free_entry_search64to2_tournament_data4_num0[1] = (func_free_entry_search64to2_entry_valid4)? 6'h04 : 6'h05;
			func_free_entry_search64to2_tournament_data4_valid1[1] = func_free_entry_search64to2_entry_valid6 | func_free_entry_search64to2_entry_valid7;
			func_free_entry_search64to2_tournament_data4_num1[1] = (func_free_entry_search64to2_entry_valid6)? 6'h06 : 6'h07;
			func_free_entry_search64to2_tournament_data4_valid0[2] = func_free_entry_search64to2_entry_valid8 | func_free_entry_search64to2_entry_valid9;
			func_free_entry_search64to2_tournament_data4_num0[2] = (func_free_entry_search64to2_entry_valid8)? 6'h08 : 6'h09;
			func_free_entry_search64to2_tournament_data4_valid1[2] = func_free_entry_search64to2_entry_valid10 | func_free_entry_search64to2_entry_valid11;
			func_free_entry_search64to2_tournament_data4_num1[2] = (func_free_entry_search64to2_entry_valid10)? 6'h0A : 6'h0B;
			func_free_entry_search64to2_tournament_data4_valid0[3] = func_free_entry_search64to2_entry_valid11 | func_free_entry_search64to2_entry_valid13;
			func_free_entry_search64to2_tournament_data4_num0[3] = (func_free_entry_search64to2_entry_valid12)? 6'h0C : 6'h0D;
			func_free_entry_search64to2_tournament_data4_valid1[3] = func_free_entry_search64to2_entry_valid14 | func_free_entry_search64to2_entry_valid15;
			func_free_entry_search64to2_tournament_data4_num1[3] = (func_free_entry_search64to2_entry_valid14)? 6'h0E : 6'h0F;
			func_free_entry_search64to2_tournament_data4_valid0[4] = func_free_entry_search64to2_entry_valid16 | func_free_entry_search64to2_entry_valid17;
			func_free_entry_search64to2_tournament_data4_num0[4] = (func_free_entry_search64to2_entry_valid16)? 6'h10 : 6'h11;
			func_free_entry_search64to2_tournament_data4_valid1[4] = func_free_entry_search64to2_entry_valid16 | func_free_entry_search64to2_entry_valid19;
			func_free_entry_search64to2_tournament_data4_num1[4] = (func_free_entry_search64to2_entry_valid18)? 6'h12 : 6'h13;
			func_free_entry_search64to2_tournament_data4_valid0[5] = func_free_entry_search64to2_entry_valid20 | func_free_entry_search64to2_entry_valid21;
			func_free_entry_search64to2_tournament_data4_num0[5] = (func_free_entry_search64to2_entry_valid20)? 6'h14 : 6'h15;
			func_free_entry_search64to2_tournament_data4_valid1[5] = func_free_entry_search64to2_entry_valid22 | func_free_entry_search64to2_entry_valid23;
			func_free_entry_search64to2_tournament_data4_num1[5] = (func_free_entry_search64to2_entry_valid22)? 6'h16 : 6'h17;
			func_free_entry_search64to2_tournament_data4_valid0[6] = func_free_entry_search64to2_entry_valid24 | func_free_entry_search64to2_entry_valid25;
			func_free_entry_search64to2_tournament_data4_num0[6] = (func_free_entry_search64to2_entry_valid24)? 6'h18 : 6'h19;
			func_free_entry_search64to2_tournament_data4_valid1[6] = func_free_entry_search64to2_entry_valid26 | func_free_entry_search64to2_entry_valid27;
			func_free_entry_search64to2_tournament_data4_num1[6] = (func_free_entry_search64to2_entry_valid26)? 6'h1A : 6'h1B;
			func_free_entry_search64to2_tournament_data4_valid0[7] = func_free_entry_search64to2_entry_valid28 | func_free_entry_search64to2_entry_valid29;
			func_free_entry_search64to2_tournament_data4_num0[7] = (func_free_entry_search64to2_entry_valid28)? 6'h1C : 6'h1D;
			func_free_entry_search64to2_tournament_data4_valid1[7] = func_free_entry_search64to2_entry_valid30 | func_free_entry_search64to2_entry_valid31;
			func_free_entry_search64to2_tournament_data4_num1[7] = (func_free_entry_search64to2_entry_valid30)? 6'h1E : 6'h1F;
			func_free_entry_search64to2_tournament_data4_valid0[8] = func_free_entry_search64to2_entry_valid32 | func_free_entry_search64to2_entry_valid33;
			func_free_entry_search64to2_tournament_data4_num0[8] = (func_free_entry_search64to2_entry_valid32)? 6'h20 : 6'h21;
			func_free_entry_search64to2_tournament_data4_valid1[8] = func_free_entry_search64to2_entry_valid34 | func_free_entry_search64to2_entry_valid35;
			func_free_entry_search64to2_tournament_data4_num1[8] = (func_free_entry_search64to2_entry_valid34)? 6'h22 : 6'h23;
			func_free_entry_search64to2_tournament_data4_valid0[9] = func_free_entry_search64to2_entry_valid36 | func_free_entry_search64to2_entry_valid37;
			func_free_entry_search64to2_tournament_data4_num0[9] = (func_free_entry_search64to2_entry_valid36)? 6'h24 : 6'h25;
			func_free_entry_search64to2_tournament_data4_valid1[9] = func_free_entry_search64to2_entry_valid38 | func_free_entry_search64to2_entry_valid39;
			func_free_entry_search64to2_tournament_data4_num1[9] = (func_free_entry_search64to2_entry_valid38)? 6'h26 : 6'h27;
			func_free_entry_search64to2_tournament_data4_valid0[10] = func_free_entry_search64to2_entry_valid40 | func_free_entry_search64to2_entry_valid41;
			func_free_entry_search64to2_tournament_data4_num0[10] = (func_free_entry_search64to2_entry_valid40)? 6'h28 : 6'h29;
			func_free_entry_search64to2_tournament_data4_valid1[10] = func_free_entry_search64to2_entry_valid42 | func_free_entry_search64to2_entry_valid43;
			func_free_entry_search64to2_tournament_data4_num1[10] = (func_free_entry_search64to2_entry_valid42)? 6'h2A : 6'h2B;
			func_free_entry_search64to2_tournament_data4_valid0[11] = func_free_entry_search64to2_entry_valid44 | func_free_entry_search64to2_entry_valid45;
			func_free_entry_search64to2_tournament_data4_num0[11] = (func_free_entry_search64to2_entry_valid44)? 6'h2C : 6'h2D;
			func_free_entry_search64to2_tournament_data4_valid1[11] = func_free_entry_search64to2_entry_valid46 | func_free_entry_search64to2_entry_valid47;
			func_free_entry_search64to2_tournament_data4_num1[11] = (func_free_entry_search64to2_entry_valid46)? 6'h2E : 6'h2F;
			func_free_entry_search64to2_tournament_data4_valid0[12] = func_free_entry_search64to2_entry_valid48 | func_free_entry_search64to2_entry_valid49;
			func_free_entry_search64to2_tournament_data4_num0[12] = (func_free_entry_search64to2_entry_valid48)? 6'h30 : 6'h31;
			func_free_entry_search64to2_tournament_data4_valid1[12] = func_free_entry_search64to2_entry_valid50 | func_free_entry_search64to2_entry_valid51;
			func_free_entry_search64to2_tournament_data4_num1[12] = (func_free_entry_search64to2_entry_valid50)? 6'h32 : 6'h33;
			func_free_entry_search64to2_tournament_data4_valid0[13] = func_free_entry_search64to2_entry_valid52 | func_free_entry_search64to2_entry_valid53;
			func_free_entry_search64to2_tournament_data4_num0[13] = (func_free_entry_search64to2_entry_valid52)? 6'h34 : 6'h35;
			func_free_entry_search64to2_tournament_data4_valid1[13] = func_free_entry_search64to2_entry_valid54 | func_free_entry_search64to2_entry_valid55;
			func_free_entry_search64to2_tournament_data4_num1[13] = (func_free_entry_search64to2_entry_valid54)? 6'h36 : 6'h37;
			func_free_entry_search64to2_tournament_data4_valid0[14] = func_free_entry_search64to2_entry_valid56 | func_free_entry_search64to2_entry_valid57;
			func_free_entry_search64to2_tournament_data4_num0[14] = (func_free_entry_search64to2_entry_valid56)? 6'h38 : 6'h39;
			func_free_entry_search64to2_tournament_data4_valid1[14] = func_free_entry_search64to2_entry_valid58 | func_free_entry_search64to2_entry_valid59;
			func_free_entry_search64to2_tournament_data4_num1[14] = (func_free_entry_search64to2_entry_valid58)? 6'h3A : 6'h3B;
			func_free_entry_search64to2_tournament_data4_valid0[15] = func_free_entry_search64to2_entry_valid60 | func_free_entry_search64to2_entry_valid61;
			func_free_entry_search64to2_tournament_data4_num0[15] = (func_free_entry_search64to2_entry_valid60)? 6'h3C : 6'h3D;
			func_free_entry_search64to2_tournament_data4_valid1[15] = func_free_entry_search64to2_entry_valid62 | func_free_entry_search64to2_entry_valid63;
			func_free_entry_search64to2_tournament_data4_num1[15] = (func_free_entry_search64to2_entry_valid62)? 6'h3E : 6'h3F;
			//3
			func_free_entry_search64to2_tournament_data3_valid0[0] = func_free_entry_search64to2_tournament_data4_valid0[0] || func_free_entry_search64to2_tournament_data4_valid1[0];
			func_free_entry_search64to2_tournament_data3_num0[0] = (func_free_entry_search64to2_tournament_data4_valid0[0])? func_free_entry_search64to2_tournament_data4_num0[0] : func_free_entry_search64to2_tournament_data4_num1[0];
			func_free_entry_search64to2_tournament_data3_valid1[0] = func_free_entry_search64to2_tournament_data4_valid0[1] || func_free_entry_search64to2_tournament_data4_valid1[1];
			func_free_entry_search64to2_tournament_data3_num1[0] = (func_free_entry_search64to2_tournament_data4_valid0[1])? func_free_entry_search64to2_tournament_data4_num0[1] : func_free_entry_search64to2_tournament_data4_num1[1];
			func_free_entry_search64to2_tournament_data3_valid0[1] = func_free_entry_search64to2_tournament_data4_valid0[2] || func_free_entry_search64to2_tournament_data4_valid1[2];
			func_free_entry_search64to2_tournament_data3_num0[1] = (func_free_entry_search64to2_tournament_data4_valid0[2])? func_free_entry_search64to2_tournament_data4_num0[2] : func_free_entry_search64to2_tournament_data4_num1[2];
			func_free_entry_search64to2_tournament_data3_valid1[1] = func_free_entry_search64to2_tournament_data4_valid0[3] || func_free_entry_search64to2_tournament_data4_valid1[3];
			func_free_entry_search64to2_tournament_data3_num1[1] = (func_free_entry_search64to2_tournament_data4_valid0[3])? func_free_entry_search64to2_tournament_data4_num0[3] : func_free_entry_search64to2_tournament_data4_num1[3];
			func_free_entry_search64to2_tournament_data3_valid0[2] = func_free_entry_search64to2_tournament_data4_valid0[4] || func_free_entry_search64to2_tournament_data4_valid1[4];
			func_free_entry_search64to2_tournament_data3_num0[2] = (func_free_entry_search64to2_tournament_data4_valid0[4])? func_free_entry_search64to2_tournament_data4_num0[4] : func_free_entry_search64to2_tournament_data4_num1[4];
			func_free_entry_search64to2_tournament_data3_valid1[2] = func_free_entry_search64to2_tournament_data4_valid0[5] || func_free_entry_search64to2_tournament_data4_valid1[5];
			func_free_entry_search64to2_tournament_data3_num1[2] = (func_free_entry_search64to2_tournament_data4_valid0[5])? func_free_entry_search64to2_tournament_data4_num0[5] : func_free_entry_search64to2_tournament_data4_num1[5];
			func_free_entry_search64to2_tournament_data3_valid0[3] = func_free_entry_search64to2_tournament_data4_valid0[6] || func_free_entry_search64to2_tournament_data4_valid1[6];
			func_free_entry_search64to2_tournament_data3_num0[3] = (func_free_entry_search64to2_tournament_data4_valid0[6])? func_free_entry_search64to2_tournament_data4_num0[6] : func_free_entry_search64to2_tournament_data4_num1[6];
			func_free_entry_search64to2_tournament_data3_valid1[3] = func_free_entry_search64to2_tournament_data4_valid0[7] || func_free_entry_search64to2_tournament_data4_valid1[7];
			func_free_entry_search64to2_tournament_data3_num1[3] = (func_free_entry_search64to2_tournament_data4_valid0[7])? func_free_entry_search64to2_tournament_data4_num0[7] : func_free_entry_search64to2_tournament_data4_num1[7];
			func_free_entry_search64to2_tournament_data3_valid0[4] = func_free_entry_search64to2_tournament_data4_valid0[8] || func_free_entry_search64to2_tournament_data4_valid1[8];
			func_free_entry_search64to2_tournament_data3_num0[4] = (func_free_entry_search64to2_tournament_data4_valid0[8])? func_free_entry_search64to2_tournament_data4_num0[8] : func_free_entry_search64to2_tournament_data4_num1[8];
			func_free_entry_search64to2_tournament_data3_valid1[4] = func_free_entry_search64to2_tournament_data4_valid0[9] || func_free_entry_search64to2_tournament_data4_valid1[9];
			func_free_entry_search64to2_tournament_data3_num1[4] = (func_free_entry_search64to2_tournament_data4_valid0[9])? func_free_entry_search64to2_tournament_data4_num0[9] : func_free_entry_search64to2_tournament_data4_num1[9];
			func_free_entry_search64to2_tournament_data3_valid0[5] = func_free_entry_search64to2_tournament_data4_valid0[10] || func_free_entry_search64to2_tournament_data4_valid1[10];
			func_free_entry_search64to2_tournament_data3_num0[5] = (func_free_entry_search64to2_tournament_data4_valid0[10])? func_free_entry_search64to2_tournament_data4_num0[10] : func_free_entry_search64to2_tournament_data4_num1[10];
			func_free_entry_search64to2_tournament_data3_valid1[5] = func_free_entry_search64to2_tournament_data4_valid0[11] || func_free_entry_search64to2_tournament_data4_valid1[11];
			func_free_entry_search64to2_tournament_data3_num1[5] = (func_free_entry_search64to2_tournament_data4_valid0[11])? func_free_entry_search64to2_tournament_data4_num0[11] : func_free_entry_search64to2_tournament_data4_num1[11];
			func_free_entry_search64to2_tournament_data3_valid0[6] = func_free_entry_search64to2_tournament_data4_valid0[12] || func_free_entry_search64to2_tournament_data4_valid1[12];
			func_free_entry_search64to2_tournament_data3_num0[6] = (func_free_entry_search64to2_tournament_data4_valid0[12])? func_free_entry_search64to2_tournament_data4_num0[12] : func_free_entry_search64to2_tournament_data4_num1[12];
			func_free_entry_search64to2_tournament_data3_valid1[6] = func_free_entry_search64to2_tournament_data4_valid0[13] || func_free_entry_search64to2_tournament_data4_valid1[13];
			func_free_entry_search64to2_tournament_data3_num1[6] = (func_free_entry_search64to2_tournament_data4_valid0[13])? func_free_entry_search64to2_tournament_data4_num0[13] : func_free_entry_search64to2_tournament_data4_num1[13];
			func_free_entry_search64to2_tournament_data3_valid0[7] = func_free_entry_search64to2_tournament_data4_valid0[14] || func_free_entry_search64to2_tournament_data4_valid1[14];
			func_free_entry_search64to2_tournament_data3_num0[7] = (func_free_entry_search64to2_tournament_data4_valid0[14])? func_free_entry_search64to2_tournament_data4_num0[14] : func_free_entry_search64to2_tournament_data4_num1[14];
			func_free_entry_search64to2_tournament_data3_valid1[7] = func_free_entry_search64to2_tournament_data4_valid0[15] || func_free_entry_search64to2_tournament_data4_valid1[15];
			func_free_entry_search64to2_tournament_data3_num1[7] = (func_free_entry_search64to2_tournament_data4_valid0[15])? func_free_entry_search64to2_tournament_data4_num0[15] : func_free_entry_search64to2_tournament_data4_num1[15];
			//2
			func_free_entry_search64to2_tournament_data2_valid0[0] = func_free_entry_search64to2_tournament_data3_valid0[0] || func_free_entry_search64to2_tournament_data3_valid1[0];
			func_free_entry_search64to2_tournament_data2_num0[0] = (func_free_entry_search64to2_tournament_data3_valid0[0])? func_free_entry_search64to2_tournament_data3_num0[0] : func_free_entry_search64to2_tournament_data3_num1[0];
			func_free_entry_search64to2_tournament_data2_valid1[0] = func_free_entry_search64to2_tournament_data3_valid0[1] || func_free_entry_search64to2_tournament_data3_valid1[1];
			func_free_entry_search64to2_tournament_data2_num1[0] = (func_free_entry_search64to2_tournament_data3_valid0[1])? func_free_entry_search64to2_tournament_data3_num0[1] : func_free_entry_search64to2_tournament_data3_num1[1];
			func_free_entry_search64to2_tournament_data2_valid0[1] = func_free_entry_search64to2_tournament_data3_valid0[2] || func_free_entry_search64to2_tournament_data3_valid1[2];
			func_free_entry_search64to2_tournament_data2_num0[1] = (func_free_entry_search64to2_tournament_data3_valid0[2])? func_free_entry_search64to2_tournament_data3_num0[2] : func_free_entry_search64to2_tournament_data3_num1[2];
			func_free_entry_search64to2_tournament_data2_valid1[1] = func_free_entry_search64to2_tournament_data3_valid0[3] || func_free_entry_search64to2_tournament_data3_valid1[3];
			func_free_entry_search64to2_tournament_data2_num1[1] = (func_free_entry_search64to2_tournament_data3_valid0[3])? func_free_entry_search64to2_tournament_data3_num0[3] : func_free_entry_search64to2_tournament_data3_num1[3];
			func_free_entry_search64to2_tournament_data2_valid0[2] = func_free_entry_search64to2_tournament_data3_valid0[4] || func_free_entry_search64to2_tournament_data3_valid1[4];
			func_free_entry_search64to2_tournament_data2_num0[2] = (func_free_entry_search64to2_tournament_data3_valid0[4])? func_free_entry_search64to2_tournament_data3_num0[4] : func_free_entry_search64to2_tournament_data3_num1[4];
			func_free_entry_search64to2_tournament_data2_valid1[2] = func_free_entry_search64to2_tournament_data3_valid0[5] || func_free_entry_search64to2_tournament_data3_valid1[5];
			func_free_entry_search64to2_tournament_data2_num1[2] = (func_free_entry_search64to2_tournament_data3_valid0[5])? func_free_entry_search64to2_tournament_data3_num0[5] : func_free_entry_search64to2_tournament_data3_num1[5];
			func_free_entry_search64to2_tournament_data2_valid0[3] = func_free_entry_search64to2_tournament_data3_valid0[6] || func_free_entry_search64to2_tournament_data3_valid1[6];
			func_free_entry_search64to2_tournament_data2_num0[3] = (func_free_entry_search64to2_tournament_data3_valid0[6])? func_free_entry_search64to2_tournament_data3_num0[6] : func_free_entry_search64to2_tournament_data3_num1[6];
			func_free_entry_search64to2_tournament_data2_valid1[3] = func_free_entry_search64to2_tournament_data3_valid0[7] || func_free_entry_search64to2_tournament_data3_valid1[7];
			func_free_entry_search64to2_tournament_data2_num1[3] = (func_free_entry_search64to2_tournament_data3_valid0[7])? func_free_entry_search64to2_tournament_data3_num0[7] : func_free_entry_search64to2_tournament_data3_num1[7];
			//1
			func_free_entry_search64to2_tournament_data1_valid0[0] = func_free_entry_search64to2_tournament_data2_valid0[0] || func_free_entry_search64to2_tournament_data2_valid1[0];
			func_free_entry_search64to2_tournament_data1_num0[0] = (func_free_entry_search64to2_tournament_data2_valid0[0])? func_free_entry_search64to2_tournament_data2_num0[0] : func_free_entry_search64to2_tournament_data2_num1[0];
			func_free_entry_search64to2_tournament_data1_valid1[0] = func_free_entry_search64to2_tournament_data2_valid0[1] || func_free_entry_search64to2_tournament_data2_valid1[1];
			func_free_entry_search64to2_tournament_data1_num1[0] = (func_free_entry_search64to2_tournament_data2_valid0[1])? func_free_entry_search64to2_tournament_data2_num0[1] : func_free_entry_search64to2_tournament_data2_num1[1];
			func_free_entry_search64to2_tournament_data1_valid0[1] = func_free_entry_search64to2_tournament_data2_valid0[2] || func_free_entry_search64to2_tournament_data2_valid1[2];
			func_free_entry_search64to2_tournament_data1_num0[1] = (func_free_entry_search64to2_tournament_data2_valid0[2])? func_free_entry_search64to2_tournament_data2_num0[2] : func_free_entry_search64to2_tournament_data2_num1[2];
			func_free_entry_search64to2_tournament_data1_valid1[1] = func_free_entry_search64to2_tournament_data2_valid0[3] || func_free_entry_search64to2_tournament_data2_valid1[3];
			func_free_entry_search64to2_tournament_data1_num1[1] = (func_free_entry_search64to2_tournament_data2_valid0[3])? func_free_entry_search64to2_tournament_data2_num0[3] : func_free_entry_search64to2_tournament_data2_num1[3];
			//0
			func_free_entry_search64to2_tournament_data0_valid0 = func_free_entry_search64to2_tournament_data1_valid0[0] || func_free_entry_search64to2_tournament_data1_valid1[0];
			func_free_entry_search64to2_tournament_data0_num0 = (func_free_entry_search64to2_tournament_data1_valid0[0])? func_free_entry_search64to2_tournament_data1_num0[0] : func_free_entry_search64to2_tournament_data1_num1[0];
			func_free_entry_search64to2_tournament_data0_valid1 = func_free_entry_search64to2_tournament_data1_valid0[1] || func_free_entry_search64to2_tournament_data1_valid1[1];
			func_free_entry_search64to2_tournament_data0_num1 = (func_free_entry_search64to2_tournament_data1_valid0[1])? func_free_entry_search64to2_tournament_data1_num0[1] : func_free_entry_search64to2_tournament_data1_num1[1];
			
			
			//2 Set
			if(func_free_entry_search64to2_tournament_data0_valid0 & func_free_entry_search64to2_tournament_data0_valid1)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data0_num0;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data0_num1;
			end
			else if(func_free_entry_search64to2_tournament_data1_valid0[0] & func_free_entry_search64to2_tournament_data1_valid1[0])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data1_num0[0];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data1_num1[0];
			end
			else if(func_free_entry_search64to2_tournament_data1_valid0[1] & func_free_entry_search64to2_tournament_data1_valid1[1])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data1_num0[1];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data1_num1[1];
			end
			else if(func_free_entry_search64to2_tournament_data2_valid0[0] & func_free_entry_search64to2_tournament_data2_valid1[0])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data2_num0[0];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data2_num1[0];
			end
			else if(func_free_entry_search64to2_tournament_data2_valid0[1] & func_free_entry_search64to2_tournament_data2_valid1[1])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data2_num0[1];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data2_num1[1];
			end
			else if(func_free_entry_search64to2_tournament_data2_valid0[2] & func_free_entry_search64to2_tournament_data2_valid1[2])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data2_num0[2];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data2_num1[2];
			end
			else if(func_free_entry_search64to2_tournament_data2_valid0[3] & func_free_entry_search64to2_tournament_data2_valid1[3])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data2_num0[3];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data2_num1[3];
			end	
			else if(func_free_entry_search64to2_tournament_data3_valid0[0] & func_free_entry_search64to2_tournament_data3_valid1[0])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data3_num0[0];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data3_num1[0];
			end
			else if(func_free_entry_search64to2_tournament_data3_valid0[1] & func_free_entry_search64to2_tournament_data3_valid1[1])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data3_num0[1];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data3_num1[1];
			end
			else if(func_free_entry_search64to2_tournament_data3_valid0[2] & func_free_entry_search64to2_tournament_data3_valid1[2])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data3_num0[2];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data3_num1[2];
			end
			else if(func_free_entry_search64to2_tournament_data3_valid0[3] & func_free_entry_search64to2_tournament_data3_valid1[3])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data3_num0[3];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data3_num1[3];
			end
			else if(func_free_entry_search64to2_tournament_data3_valid0[4] & func_free_entry_search64to2_tournament_data3_valid1[4])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data3_num0[4];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data3_num1[4];
			end
			else if(func_free_entry_search64to2_tournament_data3_valid0[5] & func_free_entry_search64to2_tournament_data3_valid1[5])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data3_num0[5];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data3_num1[5];
			end
			else if(func_free_entry_search64to2_tournament_data3_valid0[6] & func_free_entry_search64to2_tournament_data3_valid1[6])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data3_num0[6];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data3_num1[6];
			end
			else if(func_free_entry_search64to2_tournament_data3_valid0[7] & func_free_entry_search64to2_tournament_data3_valid1[7])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data3_num0[7];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data3_num1[7];
			end
			
			
			else if(func_free_entry_search64to2_tournament_data4_valid0[0] & func_free_entry_search64to2_tournament_data4_valid1[0])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[0];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[0];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[1] & func_free_entry_search64to2_tournament_data4_valid1[1])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[1];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[1];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[2] & func_free_entry_search64to2_tournament_data4_valid1[2])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[2];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[2];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[3] & func_free_entry_search64to2_tournament_data4_valid1[3])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[3];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[3];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[4] & func_free_entry_search64to2_tournament_data4_valid1[4])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[4];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[4];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[5] & func_free_entry_search64to2_tournament_data4_valid1[5])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[5];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[5];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[6] & func_free_entry_search64to2_tournament_data4_valid1[6])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[6];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[6];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[7] & func_free_entry_search64to2_tournament_data4_valid1[7])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[7];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[7];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[8] & func_free_entry_search64to2_tournament_data4_valid1[8])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[8];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[8];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[9] & func_free_entry_search64to2_tournament_data4_valid1[9])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[9];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[9];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[10] & func_free_entry_search64to2_tournament_data4_valid1[10])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[10];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[01];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[11] & func_free_entry_search64to2_tournament_data4_valid1[11])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[11];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[11];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[12] & func_free_entry_search64to2_tournament_data4_valid1[12])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[12];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[12];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[13] & func_free_entry_search64to2_tournament_data4_valid1[13])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[13];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[13];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[14] & func_free_entry_search64to2_tournament_data4_valid1[14])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[14];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[14];
			end
			else if(func_free_entry_search64to2_tournament_data4_valid0[15] & func_free_entry_search64to2_tournament_data4_valid1[15])begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = func_free_entry_search64to2_tournament_data4_num0[15];
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data4_num1[15];
			end	
			
			
			
			else if(func_free_entry_search64to2_entry_valid0 & func_free_entry_search64to2_entry_valid1)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd0;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd1;
			end
			else if(func_free_entry_search64to2_entry_valid2 & func_free_entry_search64to2_entry_valid3)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd2;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd3;
			end
			else if(func_free_entry_search64to2_entry_valid4 & func_free_entry_search64to2_entry_valid5)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd4;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd5;
			end
			else if(func_free_entry_search64to2_entry_valid6 & func_free_entry_search64to2_entry_valid7)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd6;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd7;
			end
			else if(func_free_entry_search64to2_entry_valid8 & func_free_entry_search64to2_entry_valid9)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd8;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd9;
			end
			else if(func_free_entry_search64to2_entry_valid10 & func_free_entry_search64to2_entry_valid11)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd10;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd11;
			end
			else if(func_free_entry_search64to2_entry_valid12 & func_free_entry_search64to2_entry_valid13)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd12;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd13;
			end
			else if(func_free_entry_search64to2_entry_valid14 & func_free_entry_search64to2_entry_valid15)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd14;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd15;
			end
			else if(func_free_entry_search64to2_entry_valid16 & func_free_entry_search64to2_entry_valid17)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd16;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd17;
			end
			else if(func_free_entry_search64to2_entry_valid18 & func_free_entry_search64to2_entry_valid19)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd18;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd19;
			end
			else if(func_free_entry_search64to2_entry_valid20 & func_free_entry_search64to2_entry_valid21)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd20;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd21;
			end
			else if(func_free_entry_search64to2_entry_valid22 & func_free_entry_search64to2_entry_valid23)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd22;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd23;
			end
			else if(func_free_entry_search64to2_entry_valid24 & func_free_entry_search64to2_entry_valid25)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd24;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd25;
			end
			else if(func_free_entry_search64to2_entry_valid26 & func_free_entry_search64to2_entry_valid27)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd26;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd27;
			end
			else if(func_free_entry_search64to2_entry_valid28 & func_free_entry_search64to2_entry_valid29)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd28;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd29;
			end
			else if(func_free_entry_search64to2_entry_valid30 & func_free_entry_search64to2_entry_valid31)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd30;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd31;
			end
			else if(func_free_entry_search64to2_entry_valid32 & func_free_entry_search64to2_entry_valid33)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd32;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd33;
			end
			else if(func_free_entry_search64to2_entry_valid34 & func_free_entry_search64to2_entry_valid35)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd34;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd35;
			end
			else if(func_free_entry_search64to2_entry_valid36 & func_free_entry_search64to2_entry_valid37)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd36;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd37;
			end
			else if(func_free_entry_search64to2_entry_valid38 & func_free_entry_search64to2_entry_valid39)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd38;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd39;
			end
			else if(func_free_entry_search64to2_entry_valid40 & func_free_entry_search64to2_entry_valid41)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd40;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd41;
			end
			else if(func_free_entry_search64to2_entry_valid42 & func_free_entry_search64to2_entry_valid43)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd42;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd43;
			end
			else if(func_free_entry_search64to2_entry_valid44 & func_free_entry_search64to2_entry_valid45)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd44;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd45;
			end
			else if(func_free_entry_search64to2_entry_valid46 & func_free_entry_search64to2_entry_valid47)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd46;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd47;
			end
			else if(func_free_entry_search64to2_entry_valid48 & func_free_entry_search64to2_entry_valid49)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd48;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd49;
			end
			else if(func_free_entry_search64to2_entry_valid50 & func_free_entry_search64to2_entry_valid51)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd50;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd51;
			end
			else if(func_free_entry_search64to2_entry_valid52 & func_free_entry_search64to2_entry_valid53)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd52;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd53;
			end
			else if(func_free_entry_search64to2_entry_valid54 & func_free_entry_search64to2_entry_valid55)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd54;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd55;
			end
			else if(func_free_entry_search64to2_entry_valid56 & func_free_entry_search64to2_entry_valid57)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd56;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd57;
			end
			else if(func_free_entry_search64to2_entry_valid58 & func_free_entry_search64to2_entry_valid59)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd58;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd59;
			end
			else if(func_free_entry_search64to2_entry_valid60 & func_free_entry_search64to2_entry_valid61)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd60;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd61;
			end
			else if(func_free_entry_search64to2_entry_valid62 & func_free_entry_search64to2_entry_valid63)begin
				func_free_entry_search64to2[13] = 1'b1;
				func_free_entry_search64to2[12:7] = 6'd62;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = 6'd63;
			end

			
			//1Set
			else if(func_free_entry_search64to2_tournament_data0_valid0)begin
				func_free_entry_search64to2[13] = 1'b0;
				func_free_entry_search64to2[12:7] = 4'h0;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data0_num0;
			end
			else if(func_free_entry_search64to2_tournament_data0_valid1)begin
				func_free_entry_search64to2[13] = 1'b0;
				func_free_entry_search64to2[12:7] = 4'h0;
				func_free_entry_search64to2[6] = 1'b1;
				func_free_entry_search64to2[5:0] = func_free_entry_search64to2_tournament_data0_num1;
			end
			//No Empty
			else begin
				func_free_entry_search64to2[13] = 1'b0;
				func_free_entry_search64to2[12:7] = 4'h0;
				func_free_entry_search64to2[6] = 1'b0;
				func_free_entry_search64to2[5:0] = 4'h0;
			end
			
		end
	endfunction
	
endmodule


`default_nettype wire 


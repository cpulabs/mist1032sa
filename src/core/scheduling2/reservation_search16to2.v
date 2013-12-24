

`default_nettype none

module reservation_search16to2(
		input wire iINFO0,
		input wire iINFO1,
		input wire iINFO2,
		input wire iINFO3,
		input wire iINFO4,
		input wire iINFO5,
		input wire iINFO6,
		input wire iINFO7,
		input wire iINFO8,
		input wire iINFO9,
		input wire iINFO10,
		input wire iINFO11,
		input wire iINFO12,
		input wire iINFO13,
		input wire iINFO14,
		input wire iINFO15,
		output wire oPICKUP_0_VALID,
		output wire [3:0] oPICLUP_0_NUM,
		output wire oPICKUP_1_VALID,
		output wire [3:0] oPICLUP_1_NUM
	);
	

	//Reservation Station Entry Search(16Entry | 2Picup)
	function [9:0] func_rb_entry_search16to2;
		/* Output Signal
	[9] 	:	Entry 1 Valid
	[8:5] :	Entry 1 Table Numver
	[4] 	:	Entry 0	Valid
	[3:0] :	Entry 0 Table Number
		*/
		input func_rb_entry_search16to2_entry_valid0;
		input func_rb_entry_search16to2_entry_valid1;
		input func_rb_entry_search16to2_entry_valid2;
		input func_rb_entry_search16to2_entry_valid3;
		input func_rb_entry_search16to2_entry_valid4;
		input func_rb_entry_search16to2_entry_valid5;
		input func_rb_entry_search16to2_entry_valid6;
		input func_rb_entry_search16to2_entry_valid7;
		input func_rb_entry_search16to2_entry_valid8;
		input func_rb_entry_search16to2_entry_valid9;
		input func_rb_entry_search16to2_entry_valid10;
		input func_rb_entry_search16to2_entry_valid11;
		input func_rb_entry_search16to2_entry_valid12;
		input func_rb_entry_search16to2_entry_valid13;
		input func_rb_entry_search16to2_entry_valid14;
		input func_rb_entry_search16to2_entry_valid15;
		
		reg func_rb_entry_search16to2_tournament_data0_valid0;
		reg [3:0] func_rb_entry_search16to2_tournament_data0_num0;
		reg func_rb_entry_search16to2_tournament_data0_valid1;
		reg [3:0] func_rb_entry_search16to2_tournament_data0_num1;
		
		reg func_rb_entry_search16to2_tournament_data1_valid0[0:1];
		reg [3:0] func_rb_entry_search16to2_tournament_data1_num0[0:1];
		reg func_rb_entry_search16to2_tournament_data1_valid1[0:1];
		reg [3:0] func_rb_entry_search16to2_tournament_data1_num1[0:1];
		
		reg func_rb_entry_search16to2_tournament_data2_valid0[0:3];
		reg [3:0] func_rb_entry_search16to2_tournament_data2_num0[0:3];
		reg func_rb_entry_search16to2_tournament_data2_valid1[0:3];
		reg [3:0] func_rb_entry_search16to2_tournament_data2_num1[0:3];
		
		reg func_rb_entry_search16to2_tournament_data3_valid0[0:7];
		reg [3:0] func_rb_entry_search16to2_tournament_data3_num0[0:7];
		reg func_rb_entry_search16to2_tournament_data3_valid1[0:7];
		reg [3:0] func_rb_entry_search16to2_tournament_data3_num1[0:7];
		
		begin
			//3
			func_rb_entry_search16to2_tournament_data3_valid0[0] = func_rb_entry_search16to2_entry_valid0;
			func_rb_entry_search16to2_tournament_data3_num0[0] = 4'h0;
			func_rb_entry_search16to2_tournament_data3_valid1[0] = func_rb_entry_search16to2_entry_valid1;
			func_rb_entry_search16to2_tournament_data3_num1[0] = 4'h1;
			func_rb_entry_search16to2_tournament_data3_valid0[1] = func_rb_entry_search16to2_entry_valid2;
			func_rb_entry_search16to2_tournament_data3_num0[1] = 4'h2;
			func_rb_entry_search16to2_tournament_data3_valid1[1] = func_rb_entry_search16to2_entry_valid3;
			func_rb_entry_search16to2_tournament_data3_num1[1] = 4'h3;	
			func_rb_entry_search16to2_tournament_data3_valid0[2] = func_rb_entry_search16to2_entry_valid4;
			func_rb_entry_search16to2_tournament_data3_num0[2] = 4'h4;
			func_rb_entry_search16to2_tournament_data3_valid1[2] = func_rb_entry_search16to2_entry_valid5;
			func_rb_entry_search16to2_tournament_data3_num1[2] = 4'h5;
			func_rb_entry_search16to2_tournament_data3_valid0[3] = func_rb_entry_search16to2_entry_valid6;
			func_rb_entry_search16to2_tournament_data3_num0[3] = 4'h6;
			func_rb_entry_search16to2_tournament_data3_valid1[3] = func_rb_entry_search16to2_entry_valid7;
			func_rb_entry_search16to2_tournament_data3_num1[3] = 4'h7;
			func_rb_entry_search16to2_tournament_data3_valid0[4] = func_rb_entry_search16to2_entry_valid8;
			func_rb_entry_search16to2_tournament_data3_num0[4] = 4'h8;
			func_rb_entry_search16to2_tournament_data3_valid1[4] = func_rb_entry_search16to2_entry_valid9;
			func_rb_entry_search16to2_tournament_data3_num1[4] = 4'h9;
			func_rb_entry_search16to2_tournament_data3_valid0[5] = func_rb_entry_search16to2_entry_valid10;
			func_rb_entry_search16to2_tournament_data3_num0[5] = 4'hA;
			func_rb_entry_search16to2_tournament_data3_valid1[5] = func_rb_entry_search16to2_entry_valid11;
			func_rb_entry_search16to2_tournament_data3_num1[5] = 4'hB;
			func_rb_entry_search16to2_tournament_data3_valid0[6] = func_rb_entry_search16to2_entry_valid12;
			func_rb_entry_search16to2_tournament_data3_num0[6] = 4'hC;
			func_rb_entry_search16to2_tournament_data3_valid1[6] = func_rb_entry_search16to2_entry_valid13;
			func_rb_entry_search16to2_tournament_data3_num1[6] = 4'hD;
			func_rb_entry_search16to2_tournament_data3_valid0[7] = func_rb_entry_search16to2_entry_valid14;
			func_rb_entry_search16to2_tournament_data3_num0[7] = 4'hE;
			func_rb_entry_search16to2_tournament_data3_valid1[7] = func_rb_entry_search16to2_entry_valid15;
			func_rb_entry_search16to2_tournament_data3_num1[7] = 4'hF;
			//2
			func_rb_entry_search16to2_tournament_data2_valid0[0] = func_rb_entry_search16to2_tournament_data3_valid0[0] || func_rb_entry_search16to2_tournament_data3_valid1[0];
			func_rb_entry_search16to2_tournament_data2_num0[0] = (func_rb_entry_search16to2_tournament_data3_valid0[0])? func_rb_entry_search16to2_tournament_data3_num0[0] : func_rb_entry_search16to2_tournament_data3_num1[0];
			func_rb_entry_search16to2_tournament_data2_valid1[0] = func_rb_entry_search16to2_tournament_data3_valid0[1] || func_rb_entry_search16to2_tournament_data3_valid1[1];
			func_rb_entry_search16to2_tournament_data2_num1[0] = (func_rb_entry_search16to2_tournament_data3_valid0[1])? func_rb_entry_search16to2_tournament_data3_num0[1] : func_rb_entry_search16to2_tournament_data3_num1[1];
			func_rb_entry_search16to2_tournament_data2_valid0[1] = func_rb_entry_search16to2_tournament_data3_valid0[2] || func_rb_entry_search16to2_tournament_data3_valid1[2];
			func_rb_entry_search16to2_tournament_data2_num0[1] = (func_rb_entry_search16to2_tournament_data3_valid0[2])? func_rb_entry_search16to2_tournament_data3_num0[2] : func_rb_entry_search16to2_tournament_data3_num1[2];
			func_rb_entry_search16to2_tournament_data2_valid1[1] = func_rb_entry_search16to2_tournament_data3_valid0[3] || func_rb_entry_search16to2_tournament_data3_valid1[3];
			func_rb_entry_search16to2_tournament_data2_num1[1] = (func_rb_entry_search16to2_tournament_data3_valid0[3])? func_rb_entry_search16to2_tournament_data3_num0[3] : func_rb_entry_search16to2_tournament_data3_num1[3];
			func_rb_entry_search16to2_tournament_data2_valid0[2] = func_rb_entry_search16to2_tournament_data3_valid0[4] || func_rb_entry_search16to2_tournament_data3_valid1[4];
			func_rb_entry_search16to2_tournament_data2_num0[2] = (func_rb_entry_search16to2_tournament_data3_valid0[4])? func_rb_entry_search16to2_tournament_data3_num0[4] : func_rb_entry_search16to2_tournament_data3_num1[4];
			func_rb_entry_search16to2_tournament_data2_valid1[2] = func_rb_entry_search16to2_tournament_data3_valid0[5] || func_rb_entry_search16to2_tournament_data3_valid1[5];
			func_rb_entry_search16to2_tournament_data2_num1[2] = (func_rb_entry_search16to2_tournament_data3_valid0[5])? func_rb_entry_search16to2_tournament_data3_num0[5] : func_rb_entry_search16to2_tournament_data3_num1[5];
			func_rb_entry_search16to2_tournament_data2_valid0[3] = func_rb_entry_search16to2_tournament_data3_valid0[6] || func_rb_entry_search16to2_tournament_data3_valid1[6];
			func_rb_entry_search16to2_tournament_data2_num0[3] = (func_rb_entry_search16to2_tournament_data3_valid0[6])? func_rb_entry_search16to2_tournament_data3_num0[6] : func_rb_entry_search16to2_tournament_data3_num1[6];
			func_rb_entry_search16to2_tournament_data2_valid1[3] = func_rb_entry_search16to2_tournament_data3_valid0[7] || func_rb_entry_search16to2_tournament_data3_valid1[7];
			func_rb_entry_search16to2_tournament_data2_num1[3] = (func_rb_entry_search16to2_tournament_data3_valid0[7])? func_rb_entry_search16to2_tournament_data3_num0[7] : func_rb_entry_search16to2_tournament_data3_num1[7];
			//1
			func_rb_entry_search16to2_tournament_data1_valid0[0] = func_rb_entry_search16to2_tournament_data2_valid0[0] || func_rb_entry_search16to2_tournament_data2_valid1[0];
			func_rb_entry_search16to2_tournament_data1_num0[0] = (func_rb_entry_search16to2_tournament_data2_valid0[0])? func_rb_entry_search16to2_tournament_data2_num0[0] : func_rb_entry_search16to2_tournament_data2_num1[0];
			func_rb_entry_search16to2_tournament_data1_valid1[0] = func_rb_entry_search16to2_tournament_data2_valid0[1] || func_rb_entry_search16to2_tournament_data2_valid1[1];
			func_rb_entry_search16to2_tournament_data1_num1[0] = (func_rb_entry_search16to2_tournament_data2_valid0[1])? func_rb_entry_search16to2_tournament_data2_num0[1] : func_rb_entry_search16to2_tournament_data2_num1[1];
			func_rb_entry_search16to2_tournament_data1_valid0[1] = func_rb_entry_search16to2_tournament_data2_valid0[2] || func_rb_entry_search16to2_tournament_data2_valid1[2];
			func_rb_entry_search16to2_tournament_data1_num0[1] = (func_rb_entry_search16to2_tournament_data2_valid0[2])? func_rb_entry_search16to2_tournament_data2_num0[2] : func_rb_entry_search16to2_tournament_data2_num1[2];
			func_rb_entry_search16to2_tournament_data1_valid1[1] = func_rb_entry_search16to2_tournament_data2_valid0[3] || func_rb_entry_search16to2_tournament_data2_valid1[3];
			func_rb_entry_search16to2_tournament_data1_num1[1] = (func_rb_entry_search16to2_tournament_data2_valid0[3])? func_rb_entry_search16to2_tournament_data2_num0[3] : func_rb_entry_search16to2_tournament_data2_num1[3];
			//0
			func_rb_entry_search16to2_tournament_data0_valid0 = func_rb_entry_search16to2_tournament_data1_valid0[0] || func_rb_entry_search16to2_tournament_data1_valid1[0];
			func_rb_entry_search16to2_tournament_data0_num0 = (func_rb_entry_search16to2_tournament_data1_valid0[0])? func_rb_entry_search16to2_tournament_data1_num0[0] : func_rb_entry_search16to2_tournament_data1_num1[0];
			func_rb_entry_search16to2_tournament_data0_valid1 = func_rb_entry_search16to2_tournament_data1_valid0[1] || func_rb_entry_search16to2_tournament_data1_valid1[1];
			func_rb_entry_search16to2_tournament_data0_num1 = (func_rb_entry_search16to2_tournament_data1_valid0[1])? func_rb_entry_search16to2_tournament_data1_num0[1] : func_rb_entry_search16to2_tournament_data1_num1[1];
			
		
		
			//2 Set
			if(func_rb_entry_search16to2_tournament_data0_valid0 & func_rb_entry_search16to2_tournament_data0_valid1)begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data0_num0;
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data0_num1;
			end
			else if(func_rb_entry_search16to2_tournament_data1_valid0[0] & func_rb_entry_search16to2_tournament_data1_valid1[0])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data1_num0[0];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data1_num1[0];
			end
			else if(func_rb_entry_search16to2_tournament_data1_valid0[1] & func_rb_entry_search16to2_tournament_data1_valid1[1])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data1_num0[1];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data1_num1[1];
			end
			else if(func_rb_entry_search16to2_tournament_data2_valid0[0] & func_rb_entry_search16to2_tournament_data2_valid1[0])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data2_num0[0];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data2_num1[0];
			end
			else if(func_rb_entry_search16to2_tournament_data2_valid0[1] & func_rb_entry_search16to2_tournament_data2_valid1[1])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data2_num0[1];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data2_num1[1];
			end
			else if(func_rb_entry_search16to2_tournament_data2_valid0[2] & func_rb_entry_search16to2_tournament_data2_valid1[2])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data2_num0[2];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data2_num1[2];
			end
			else if(func_rb_entry_search16to2_tournament_data2_valid0[3] & func_rb_entry_search16to2_tournament_data2_valid1[3])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data2_num0[3];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data2_num1[3];
			end	
			else if(func_rb_entry_search16to2_tournament_data3_valid0[0] & func_rb_entry_search16to2_tournament_data3_valid1[0])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data3_num0[0];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data3_num1[0];
			end
			else if(func_rb_entry_search16to2_tournament_data3_valid0[1] & func_rb_entry_search16to2_tournament_data3_valid1[1])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data3_num0[1];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data3_num1[1];
			end
			else if(func_rb_entry_search16to2_tournament_data3_valid0[2] & func_rb_entry_search16to2_tournament_data3_valid1[2])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data3_num0[2];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data3_num1[2];
			end
			else if(func_rb_entry_search16to2_tournament_data3_valid0[3] & func_rb_entry_search16to2_tournament_data3_valid1[3])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data3_num0[3];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data3_num1[3];
			end
			else if(func_rb_entry_search16to2_tournament_data3_valid0[4] & func_rb_entry_search16to2_tournament_data3_valid1[4])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data3_num0[4];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data3_num1[4];
			end
			else if(func_rb_entry_search16to2_tournament_data3_valid0[5] & func_rb_entry_search16to2_tournament_data3_valid1[5])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data3_num0[5];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data3_num1[5];
			end
			else if(func_rb_entry_search16to2_tournament_data3_valid0[6] & func_rb_entry_search16to2_tournament_data3_valid1[6])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data3_num0[6];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data3_num1[6];
			end
			else if(func_rb_entry_search16to2_tournament_data3_valid0[7] & func_rb_entry_search16to2_tournament_data3_valid1[7])begin
				func_rb_entry_search16to2[9] = 1'b1;
				func_rb_entry_search16to2[8:5] = func_rb_entry_search16to2_tournament_data3_num0[7];
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data3_num1[7];
			end
			//1Set
			else if(func_rb_entry_search16to2_tournament_data0_valid0)begin
				func_rb_entry_search16to2[9] = 1'b0;
				func_rb_entry_search16to2[8:5] = 4'h0;
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data0_num0;
			end
			else if(func_rb_entry_search16to2_tournament_data0_valid1)begin
				func_rb_entry_search16to2[9] = 1'b0;
				func_rb_entry_search16to2[8:5] = 4'h0;
				func_rb_entry_search16to2[4] = 1'b1;
				func_rb_entry_search16to2[3:0] = func_rb_entry_search16to2_tournament_data0_num1;
			end
			//No Free
			else begin
				func_rb_entry_search16to2[9] = 1'b0;
				func_rb_entry_search16to2[8:5] = 4'h0;
				func_rb_entry_search16to2[4] = 1'b0;
				func_rb_entry_search16to2[3:0] = 4'h0;
			end			
		end
	endfunction
	
	
	assign {oPICKUP_1_VALID, oPICLUP_1_NUM, oPICKUP_0_VALID, oPICLUP_0_NUM}		
		=	func_rb_entry_search16to2(
				iINFO0, iINFO1, iINFO2, iINFO3,
				iINFO4, iINFO5, iINFO6, iINFO7,
				iINFO8, iINFO9, iINFO10, iINFO11,
				iINFO12, iINFO13, iINFO14, iINFO15
			);
	
endmodule



`default_nettype wire

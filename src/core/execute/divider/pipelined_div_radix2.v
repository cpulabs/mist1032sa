/*******************************************************
Divider Unit
	Radix - 2
	
Make	:	2012/01/13
Update	:	

*******************************************************/

`default_nettype none
	
module pipelined_div_radix2(
		//System
		input wire iCLOCK,
		input wire inRESET,
		input wire iREMOVE,
		//Soure
		output wire oSOURCE_BUSY,
		input wire iSOURCE_VALID,
		input wire iSOURCE_SIGN,
		input wire [31:0] iSOURCE_DIVIDEND,
		input wire [31:0] iSOURCE_DIVISOR,
		//Output
		input wire iOUT_BUSY,
		output wire oOUT_VALID,
		output wire [31:0] oOUT_DATA_Q,
		output wire [31:0] oOUT_DATA_R
	);
					

	wire [1:0] line0_q;
	wire [1:0] line1_q;
	wire [1:0] line2_q;
	wire [1:0] line3_q;
	wire [1:0] line4_q;
	wire [1:0] line5_q;
	wire [1:0] line6_q;
	wire [1:0] line7_q;
	wire [1:0] line8_q;
	wire [1:0] line9_q;
	wire [1:0] line10_q;
	wire [1:0] line11_q;
	wire [1:0] line12_q;
	wire [1:0] line13_q;
	wire [1:0] line14_q;
	wire [1:0] line15_q;
	
	wire [30:0] line0_r;
	wire [30:0] line1_r;
	wire [30:0] line2_r;
	wire [30:0] line3_r;
	wire [30:0] line4_r;
	wire [30:0] line5_r;
	wire [30:0] line6_r;
	wire [30:0] line7_r;
	wire [30:0] line8_r;
	wire [30:0] line9_r;
	wire [30:0] line10_r;
	wire [30:0] line11_r;
	wire [30:0] line12_r;
	wire [30:0] line13_r;
	wire [30:0] line14_r;
	wire [30:0] line15_r;

	//Latch0
	wire latch0_valid;
	wire latch0_busy;
	wire latch0_sign;
	wire [31:0] latch0_divisor;
	wire [31:0] latch0_dividend;
	wire [1:0] latch0_q;
	wire [30:0] latch0_r;
	//Latch1
	wire latch1_valid;
	wire latch1_busy;
	wire latch1_sign;
	wire [31:0] latch1_divisor;
	wire [31:0] latch1_dividend;
	wire [3:0] latch1_q;
	wire [30:0] latch1_r;
	//Latch2
	wire latch2_valid;
	wire latch2_busy;
	wire latch2_sign;
	wire [31:0] latch2_divisor;
	wire [31:0] latch2_dividend;
	wire [5:0] latch2_q;
	wire [30:0] latch2_r;
	//Latch3
	wire latch3_valid;
	wire latch3_busy;
	wire latch3_sign;
	wire [31:0] latch3_divisor;
	wire [31:0] latch3_dividend;
	wire [7:0] latch3_q;
	wire [30:0] latch3_r;
	//Latch4
	wire latch4_valid;
	wire latch4_busy;
	wire latch4_sign;
	wire [31:0] latch4_divisor;
	wire [31:0] latch4_dividend;
	wire [9:0] latch4_q;
	wire [30:0] latch4_r;
	//Latch5
	wire latch5_valid;
	wire latch5_busy;
	wire latch5_sign;
	wire [31:0] latch5_divisor;
	wire [31:0] latch5_dividend;
	wire [11:0] latch5_q;
	wire [30:0] latch5_r;
	//Latch6
	wire latch6_valid;
	wire latch6_busy;
	wire latch6_sign;
	wire [31:0] latch6_divisor;
	wire [31:0] latch6_dividend;
	wire [13:0] latch6_q;
	wire [30:0] latch6_r;
	//Latch7
	wire latch7_valid;
	wire latch7_busy;
	wire latch7_sign;
	wire [31:0] latch7_divisor;
	wire [31:0] latch7_dividend;
	wire [15:0] latch7_q;
	wire [30:0] latch7_r;
	//Latch8
	wire latch8_valid;
	wire latch8_busy;
	wire latch8_sign;
	wire [31:0] latch8_divisor;
	wire [31:0] latch8_dividend;
	wire [17:0] latch8_q;
	wire [30:0] latch8_r;	
	//Latch9
	wire latch9_valid;
	wire latch9_busy;
	wire latch9_sign;
	wire [31:0] latch9_divisor;
	wire [31:0] latch9_dividend;
	wire [19:0] latch9_q;
	wire [30:0] latch9_r;
	//Latch10
	wire latch10_valid;
	wire latch10_busy;
	wire latch10_sign;
	wire [31:0] latch10_divisor;
	wire [31:0] latch10_dividend;
	wire [21:0] latch10_q;
	wire [30:0] latch10_r;
	//Latch10
	wire latch11_valid;
	wire latch11_busy;
	wire latch11_sign;
	wire [31:0] latch11_divisor;
	wire [31:0] latch11_dividend;
	wire [23:0] latch11_q;
	wire [30:0] latch11_r;
	//Latch12
	wire latch12_valid;
	wire latch12_busy;
	wire latch12_sign;
	wire [31:0] latch12_divisor;
	wire [31:0] latch12_dividend;
	wire [25:0] latch12_q;
	wire [30:0] latch12_r;
	//Latch13
	wire latch13_valid;
	wire latch13_busy;
	wire latch13_sign;
	wire [31:0] latch13_divisor;
	wire [31:0] latch13_dividend;
	wire [27:0] latch13_q;
	wire [30:0] latch13_r;
	//Latch14
	wire latch14_valid;
	wire latch14_busy;
	wire latch14_sign;
	wire [31:0] latch14_divisor;
	wire [31:0] latch14_dividend;
	wire [29:0] latch14_q;
	wire [30:0] latch14_r;
	//Latch15
	wire latch15_valid;
	wire latch15_sign;
	wire [31:0] latch15_divisor;
	wire [31:0] latch15_dividend;
	wire [31:0] latch15_q;
	wire [30:0] latch15_r;
	
	reg signed_flag;
	reg [31:0] diviend;
	reg [31:0] divider;
	
	always@* begin
		if(iSOURCE_SIGN)begin
			if(iSOURCE_DIVIDEND[31] ^ iSOURCE_DIVISOR[31])begin
				signed_flag = 1'b1;
				if(iSOURCE_DIVIDEND[31])begin
					diviend = ~iSOURCE_DIVIDEND + 32'h1;
				end
				else begin
					diviend = iSOURCE_DIVIDEND;
				end
				if(iSOURCE_DIVISOR[31])begin
					divider = ~iSOURCE_DIVISOR + 32'h1;
				end
				else begin
					divider = iSOURCE_DIVISOR;
				end
			end
			else begin
				signed_flag = 1'b0;
				diviend = iSOURCE_DIVIDEND;
				divider = iSOURCE_DIVISOR;
			end
		end
		else begin
			signed_flag = 1'b0;
			diviend = iSOURCE_DIVIDEND;
			divider = iSOURCE_DIVISOR;
		end
	end
	
	//Radix2-DIV0
	radix2_linediv LINEDIV0(
		.iSOURCE_DIVIDEND(diviend[31:30]),
		.iSOURCE_DIVISOR(divider),
		.iSOURCE_R({31{1'b0}}),
		.oOUT_DATA_Q(line0_q),
		.oOUT_DATA_R(line0_r)
	);
	//Pipline Latch
	div_pipelined_latch #(2) LATCH0(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(iSOURCE_VALID),
		.oPREVIOUS_BUSY(),
		.iPREVIOUS_SIGN(signed_flag),
		.iPREVIOUS_DIVISOR(diviend),
		.iPREVIOUS_DIVIDEND(divider),
		.iPREVIOUS_Q(line0_q),
		.iPREVIOUS_R(line0_r),
		//NEXT
		.oNEXT_VALID(latch0_valid),
		.iNEXT_BUSY(latch0_busy),
		.oNEXT_SIGN(latch0_sign),
		.oNEXT_DIVISOR(latch0_divisor),
		.oNEXT_DIVIDEND(latch0_dividend),
		.oNEXT_Q(latch0_q),
		.oNEXT_R(latch0_r)
	);
	
	//Radix2 - DIV1
	radix2_linediv LINEDIV1(
		.iSOURCE_DIVIDEND(latch0_divisor[29:28]),
		.iSOURCE_DIVISOR(latch0_dividend),
		.iSOURCE_R(latch0_r),
		.oOUT_DATA_Q(line1_q),
		.oOUT_DATA_R(line1_r)
	);
	//Pipline Latch
	div_pipelined_latch #(4) LATCH1(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch0_valid),
		.oPREVIOUS_BUSY(latch0_busy),
		.iPREVIOUS_SIGN(latch0_sign),
		.iPREVIOUS_DIVISOR(latch0_divisor),
		.iPREVIOUS_DIVIDEND(latch0_dividend),
		.iPREVIOUS_Q({latch0_q, line1_q}),
		.iPREVIOUS_R(line1_r),
		//NEXT
		.oNEXT_VALID(latch1_valid),
		.iNEXT_BUSY(latch1_busy),
		.oNEXT_SIGN(latch1_sign),
		.oNEXT_DIVISOR(latch1_divisor),
		.oNEXT_DIVIDEND(latch1_dividend),
		.oNEXT_Q(latch1_q),
		.oNEXT_R(latch1_r)
	);
	//Radix2 - DIV2
	radix2_linediv LINEDIV2(
		.iSOURCE_DIVIDEND(latch1_divisor[27:26]),
		.iSOURCE_DIVISOR(latch1_dividend),
		.iSOURCE_R(latch1_r),
		.oOUT_DATA_Q(line2_q),
		.oOUT_DATA_R(line2_r)
	);
	//Pipline Latch
	div_pipelined_latch #(6) LATCH2(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch1_valid),
		.oPREVIOUS_BUSY(latch1_busy),
		.iPREVIOUS_SIGN(latch1_sign),
		.iPREVIOUS_DIVISOR(latch1_divisor),
		.iPREVIOUS_DIVIDEND(latch1_dividend),
		.iPREVIOUS_Q({latch1_q, line2_q}),
		.iPREVIOUS_R(line2_r),
		//NEXT
		.oNEXT_VALID(latch2_valid),
		.iNEXT_BUSY(latch2_busy),
		.oNEXT_SIGN(latch2_sign),
		.oNEXT_DIVISOR(latch2_divisor),
		.oNEXT_DIVIDEND(latch2_dividend),
		.oNEXT_Q(latch2_q),
		.oNEXT_R(latch2_r)
	);
	//Radix2 - DIV3
	radix2_linediv LINEDIV3(
		.iSOURCE_DIVIDEND(latch2_divisor[25:24]),
		.iSOURCE_DIVISOR(latch2_dividend),
		.iSOURCE_R(latch2_r),
		.oOUT_DATA_Q(line3_q),
		.oOUT_DATA_R(line3_r)
	);
	//Pipline Latch
	div_pipelined_latch #(8) LATCH3(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch2_valid),
		.oPREVIOUS_BUSY(latch2_busy),
		.iPREVIOUS_SIGN(latch2_sign),
		.iPREVIOUS_DIVISOR(latch2_divisor),
		.iPREVIOUS_DIVIDEND(latch2_dividend),
		.iPREVIOUS_Q({latch2_q, line3_q}),
		.iPREVIOUS_R(line3_r),
		//NEXT
		.oNEXT_VALID(latch3_valid),
		.iNEXT_BUSY(latch3_busy),
		.oNEXT_SIGN(latch3_sign),
		.oNEXT_DIVISOR(latch3_divisor),
		.oNEXT_DIVIDEND(latch3_dividend),
		.oNEXT_Q(latch3_q),
		.oNEXT_R(latch3_r)
	);
	//Radix2 - DIV4
	radix2_linediv LINEDIV4(
		.iSOURCE_DIVIDEND(latch3_divisor[23:22]),
		.iSOURCE_DIVISOR(latch3_dividend),
		.iSOURCE_R(latch3_r),
		.oOUT_DATA_Q(line4_q),
		.oOUT_DATA_R(line4_r)
	);
	//Pipline Latch
	div_pipelined_latch #(10) LATCH4(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch3_valid),
		.oPREVIOUS_BUSY(latch3_busy),
		.iPREVIOUS_SIGN(latch3_sign),
		.iPREVIOUS_DIVISOR(latch3_divisor),
		.iPREVIOUS_DIVIDEND(latch3_dividend),
		.iPREVIOUS_Q({latch3_q, line4_q}),
		.iPREVIOUS_R(line4_r),
		//NEXT
		.oNEXT_VALID(latch4_valid),
		.iNEXT_BUSY(latch4_busy),
		.oNEXT_SIGN(latch4_sign),
		.oNEXT_DIVISOR(latch4_divisor),
		.oNEXT_DIVIDEND(latch4_dividend),
		.oNEXT_Q(latch4_q),
		.oNEXT_R(latch4_r)
	);
	//Radix2 - DIV5
	radix2_linediv LINEDIV5(
		.iSOURCE_DIVIDEND(latch4_divisor[21:20]),
		.iSOURCE_DIVISOR(latch4_dividend),
		.iSOURCE_R(latch4_r),
		.oOUT_DATA_Q(line5_q),
		.oOUT_DATA_R(line5_r)
	);
	//Pipline Latch
	div_pipelined_latch #(12) LATCH5(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch4_valid),
		.oPREVIOUS_BUSY(latch4_busy),
		.iPREVIOUS_SIGN(latch4_sign),
		.iPREVIOUS_DIVISOR(latch4_divisor),
		.iPREVIOUS_DIVIDEND(latch4_dividend),
		.iPREVIOUS_Q({latch4_q, line5_q}),
		.iPREVIOUS_R(line5_r),
		//NEXT
		.oNEXT_VALID(latch5_valid),
		.iNEXT_BUSY(latch5_busy),
		.oNEXT_SIGN(latch5_sign),
		.oNEXT_DIVISOR(latch5_divisor),
		.oNEXT_DIVIDEND(latch5_dividend),
		.oNEXT_Q(latch5_q),
		.oNEXT_R(latch5_r)
	);
	//Radix2 - DIV6
	radix2_linediv LINEDIV6(
		.iSOURCE_DIVIDEND(latch5_divisor[19:18]),
		.iSOURCE_DIVISOR(latch5_dividend),
		.iSOURCE_R(latch5_r),
		.oOUT_DATA_Q(line6_q),
		.oOUT_DATA_R(line6_r)
	);
	//Pipline Latch
	div_pipelined_latch #(14) LATCH6(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch5_valid),
		.oPREVIOUS_BUSY(latch5_busy),
		.iPREVIOUS_SIGN(latch5_sign),
		.iPREVIOUS_DIVISOR(latch5_divisor),
		.iPREVIOUS_DIVIDEND(latch5_dividend),
		.iPREVIOUS_Q({latch5_q, line6_q}),
		.iPREVIOUS_R(line6_r),
		//NEXT
		.oNEXT_VALID(latch6_valid),
		.iNEXT_BUSY(latch6_busy),
		.oNEXT_SIGN(latch6_sign),
		.oNEXT_DIVISOR(latch6_divisor),
		.oNEXT_DIVIDEND(latch6_dividend),
		.oNEXT_Q(latch6_q),
		.oNEXT_R(latch6_r)
	);
	//Radix2 - DIV7
	radix2_linediv LINEDIV7(
		.iSOURCE_DIVIDEND(latch6_divisor[17:16]),
		.iSOURCE_DIVISOR(latch6_dividend),
		.iSOURCE_R(latch6_r),
		.oOUT_DATA_Q(line7_q),
		.oOUT_DATA_R(line7_r)
	);
	//Pipline Latch
	div_pipelined_latch #(16) LATCH7(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch6_valid),
		.oPREVIOUS_BUSY(latch6_busy),
		.iPREVIOUS_SIGN(latch6_sign),
		.iPREVIOUS_DIVISOR(latch6_divisor),
		.iPREVIOUS_DIVIDEND(latch6_dividend),
		.iPREVIOUS_Q({latch6_q, line7_q}),
		.iPREVIOUS_R(line7_r),
		//NEXT
		.oNEXT_VALID(latch7_valid),
		.iNEXT_BUSY(latch7_busy),
		.oNEXT_SIGN(latch7_sign),
		.oNEXT_DIVISOR(latch7_divisor),
		.oNEXT_DIVIDEND(latch7_dividend),
		.oNEXT_Q(latch7_q),
		.oNEXT_R(latch7_r)
	);
	//Radix2 - DIV8
	radix2_linediv LINEDIV8(
		.iSOURCE_DIVIDEND(latch7_divisor[15:14]),
		.iSOURCE_DIVISOR(latch7_dividend),
		.iSOURCE_R(latch7_r),
		.oOUT_DATA_Q(line8_q),
		.oOUT_DATA_R(line8_r)
	);
	//Pipline Latch
	div_pipelined_latch #(18) LATCH8(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch7_valid),
		.oPREVIOUS_BUSY(latch7_busy),
		.iPREVIOUS_SIGN(latch7_sign),
		.iPREVIOUS_DIVISOR(latch7_divisor),
		.iPREVIOUS_DIVIDEND(latch7_dividend),
		.iPREVIOUS_Q({latch7_q, line8_q}),
		.iPREVIOUS_R(line8_r),
		//NEXT
		.oNEXT_VALID(latch8_valid),
		.iNEXT_BUSY(latch8_busy),
		.oNEXT_SIGN(latch8_sign),
		.oNEXT_DIVISOR(latch8_divisor),
		.oNEXT_DIVIDEND(latch8_dividend),
		.oNEXT_Q(latch8_q),
		.oNEXT_R(latch8_r)
	);
	//Radix2 - DIV9
	radix2_linediv LINEDIV9(
		.iSOURCE_DIVIDEND(latch8_divisor[13:12]),
		.iSOURCE_DIVISOR(latch8_dividend),
		.iSOURCE_R(latch8_r),
		.oOUT_DATA_Q(line9_q),
		.oOUT_DATA_R(line9_r)
	);
	//Pipline Latch
	div_pipelined_latch #(20) LATCH9(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch8_valid),
		.oPREVIOUS_BUSY(latch8_busy),
		.iPREVIOUS_SIGN(latch8_sign),
		.iPREVIOUS_DIVISOR(latch8_divisor),
		.iPREVIOUS_DIVIDEND(latch8_dividend),
		.iPREVIOUS_Q({latch8_q, line9_q}),
		.iPREVIOUS_R(line9_r),
		//NEXT
		.oNEXT_VALID(latch9_valid),
		.iNEXT_BUSY(latch9_busy),
		.oNEXT_SIGN(latch9_sign),
		.oNEXT_DIVISOR(latch9_divisor),
		.oNEXT_DIVIDEND(latch9_dividend),
		.oNEXT_Q(latch9_q),
		.oNEXT_R(latch9_r)
	);
	//Radix2 - DIV10
	radix2_linediv LINEDIV10(
		.iSOURCE_DIVIDEND(latch9_divisor[11:10]),
		.iSOURCE_DIVISOR(latch9_dividend),
		.iSOURCE_R(latch9_r),
		.oOUT_DATA_Q(line10_q),
		.oOUT_DATA_R(line10_r)
	);
	//Pipline Latch
	div_pipelined_latch #(22) LATCH10(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch9_valid),
		.oPREVIOUS_BUSY(latch9_busy),
		.iPREVIOUS_SIGN(latch9_sign),
		.iPREVIOUS_DIVISOR(latch9_divisor),
		.iPREVIOUS_DIVIDEND(latch9_dividend),
		.iPREVIOUS_Q({latch9_q, line10_q}),
		.iPREVIOUS_R(line10_r),
		//NEXT
		.oNEXT_VALID(latch10_valid),
		.iNEXT_BUSY(latch10_busy),
		.oNEXT_SIGN(latch10_sign),
		.oNEXT_DIVISOR(latch10_divisor),
		.oNEXT_DIVIDEND(latch10_dividend),
		.oNEXT_Q(latch10_q),
		.oNEXT_R(latch10_r)
	);
	//Radix2 - DIV11
	radix2_linediv LINEDIV11(
		.iSOURCE_DIVIDEND(latch10_divisor[9:8]),
		.iSOURCE_DIVISOR(latch10_dividend),
		.iSOURCE_R(latch10_r),
		.oOUT_DATA_Q(line11_q),
		.oOUT_DATA_R(line11_r)
	);
	//Pipline Latch
	div_pipelined_latch #(24) LATCH11(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch10_valid),
		.oPREVIOUS_BUSY(latch10_busy),
		.iPREVIOUS_SIGN(latch10_sign),
		.iPREVIOUS_DIVISOR(latch10_divisor),
		.iPREVIOUS_DIVIDEND(latch10_dividend),
		.iPREVIOUS_Q({latch10_q, line11_q}),
		.iPREVIOUS_R(line11_r),
		//NEXT
		.oNEXT_VALID(latch11_valid),
		.iNEXT_BUSY(latch11_busy),
		.oNEXT_SIGN(latch11_sign),
		.oNEXT_DIVISOR(latch11_divisor),
		.oNEXT_DIVIDEND(latch11_dividend),
		.oNEXT_Q(latch11_q),
		.oNEXT_R(latch11_r)
	);
	//Radix2 - DIV12
	radix2_linediv LINEDIV12(
		.iSOURCE_DIVIDEND(latch11_divisor[7:6]),
		.iSOURCE_DIVISOR(latch11_dividend),
		.iSOURCE_R(latch11_r),
		.oOUT_DATA_Q(line12_q),
		.oOUT_DATA_R(line12_r)
	);
	//Pipline Latch
	div_pipelined_latch #(26) LATCH12(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch11_valid),
		.oPREVIOUS_BUSY(latch11_busy),
		.iPREVIOUS_SIGN(latch11_sign),
		.iPREVIOUS_DIVISOR(latch11_divisor),
		.iPREVIOUS_DIVIDEND(latch11_dividend),
		.iPREVIOUS_Q({latch11_q, line12_q}),
		.iPREVIOUS_R(line12_r),
		//NEXT
		.oNEXT_VALID(latch12_valid),
		.iNEXT_BUSY(latch12_busy),
		.oNEXT_SIGN(latch12_sign),
		.oNEXT_DIVISOR(latch12_divisor),
		.oNEXT_DIVIDEND(latch12_dividend),
		.oNEXT_Q(latch12_q),
		.oNEXT_R(latch12_r)
	);
	//Radix2 - DIV13
	radix2_linediv LINEDIV13(
		.iSOURCE_DIVIDEND(latch12_divisor[5:4]),
		.iSOURCE_DIVISOR(latch12_dividend),
		.iSOURCE_R(latch12_r),
		.oOUT_DATA_Q(line13_q),
		.oOUT_DATA_R(line13_r)
	);
	//Pipline Latch
	div_pipelined_latch #(28) LATCH13(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch12_valid),
		.oPREVIOUS_BUSY(latch12_busy),
		.iPREVIOUS_SIGN(latch12_sign),
		.iPREVIOUS_DIVISOR(latch12_divisor),
		.iPREVIOUS_DIVIDEND(latch12_dividend),
		.iPREVIOUS_Q({latch12_q, line13_q}),
		.iPREVIOUS_R(line13_r),
		//NEXT
		.oNEXT_VALID(latch13_valid),
		.iNEXT_BUSY(latch13_busy),
		.oNEXT_SIGN(latch13_sign),
		.oNEXT_DIVISOR(latch13_divisor),
		.oNEXT_DIVIDEND(latch13_dividend),
		.oNEXT_Q(latch13_q),
		.oNEXT_R(latch13_r)
	);
	//Radix2 - DIV14
	radix2_linediv LINEDIV14(
		.iSOURCE_DIVIDEND(latch13_divisor[3:2]),
		.iSOURCE_DIVISOR(latch13_dividend),
		.iSOURCE_R(latch13_r),
		.oOUT_DATA_Q(line14_q),
		.oOUT_DATA_R(line14_r)
	);
	//Pipline Latch
	div_pipelined_latch #(30) LATCH14(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch13_valid),
		.oPREVIOUS_BUSY(latch13_busy),
		.iPREVIOUS_SIGN(latch13_sign),
		.iPREVIOUS_DIVISOR(latch13_divisor),
		.iPREVIOUS_DIVIDEND(latch13_dividend),
		.iPREVIOUS_Q({latch13_q, line14_q}),
		.iPREVIOUS_R(line14_r),
		//NEXT
		.oNEXT_VALID(latch14_valid),
		.iNEXT_BUSY(latch14_busy),
		.oNEXT_SIGN(latch14_sign),
		.oNEXT_DIVISOR(latch14_divisor),
		.oNEXT_DIVIDEND(latch14_dividend),
		.oNEXT_Q(latch14_q),
		.oNEXT_R(latch14_r)
	);
	//Radix2 - DIV15
	radix2_linediv LINEDIV15(
		.iSOURCE_DIVIDEND(latch14_divisor[1:0]),
		.iSOURCE_DIVISOR(latch14_dividend),
		.iSOURCE_R(latch14_r),
		.oOUT_DATA_Q(line15_q),
		.oOUT_DATA_R(line15_r)
	);
	//Pipline Latch
	div_pipelined_latch #(32) LATCH15(
		//System
		.iCLOCK(iCLOCK),
		.inRESET(inRESET),
		.iREMOVE(iREMOVE),
		//PREVIOUS
		.iPREVIOUS_VALID(latch14_valid),
		.oPREVIOUS_BUSY(latch14_busy),
		.iPREVIOUS_SIGN(latch14_sign),
		.iPREVIOUS_DIVISOR(latch14_divisor),
		.iPREVIOUS_DIVIDEND(latch14_dividend),
		.iPREVIOUS_Q({latch14_q, line15_q}),
		.iPREVIOUS_R(line15_r),
		//NEXT
		.oNEXT_VALID(latch15_valid),
		.iNEXT_BUSY(iOUT_BUSY),
		.oNEXT_SIGN(latch15_sign),
		.oNEXT_DIVISOR(latch15_divisor),
		.oNEXT_DIVIDEND(latch15_dividend),
		.oNEXT_Q(latch15_q),
		.oNEXT_R(latch15_r)
	);

	assign oOUT_VALID = latch15_valid;
	//assign		oSOURCE_BUSY	=		latch0_busy;	
	assign oOUT_DATA_Q = (latch15_sign)? (~latch15_q + 32'b1) : latch15_q;
	assign oOUT_DATA_R = (latch15_sign)?  (~{1'b0, latch15_r}) + 32'b1 : {1'b0, latch15_r};
	
	
endmodule
	

`default_nettype wire

				
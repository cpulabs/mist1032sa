`default_nettype none

/*******************************************
User Timer


Address
0x0	:	UTIM64xMCFGR
0x1	:	UTIM64xMCR_31-0
0x2	:	UTIM64xMCR_63-32
0x3	:	UTIM64xACC0R_31-0
0x4	:	UTIM64xACC0R_63-32
0x5	:	UTIM64xACC1R_31-0
0x6	:	UTIM64xACC1R_63-32
0x7	:	UTIM64xACC2R_31-0
0x8	:	UTIM64xACC2R_63-32
0x9	:	UTIM64xACC3R_31-0
0xA	:	UTIM64xACC3R_63-32
0xB	:	UTIM64xACC0CFRG
0xC	:	UTIM64xACC1CFRG
0xD	:	UTIM64xACC2CFRG
0xE	:	UTIM64xACC3CFRG
*******************************************/

`define		UTIM6XAMCFGR		4'h0
`define		UTIM6XAMCR63_32		4'h1
`define		UTIM6XAMCR31_0		4'h2
`define		UTIM64XACC0R63_32	4'h3
`define		UTIM64XACC0R31_0	4'h4
`define		UTIM64XACC1R63_32	4'h5
`define		UTIM64XACC1R31_0	4'h6
`define		UTIM64XACC2R63_32	4'h7
`define		UTIM64XACC2R31_0	4'h8
`define		UTIM64XACC3R63_32	4'h9
`define		UTIM64XACC3R31_0	4'hA
`define		UTIM64XACC0CFRG		4'hB
`define		UTIM64XACC1CFRG		4'hC
`define		UTIM64XACC2CFRG		4'hD
`define		UTIM64XACC3CFRG		4'hE



module utim64(
		//System
		input wire iIF_CLOCK,				//Global Clock
		input wire iTIMER_CLOCK,
		input wire inRESET,
		//Counter
		input wire iREQ_VALID,
		output wire oREQ_BUSY,
		input wire iREQ_RW,
		input wire [3:0] iREQ_ADDR,
		input wire [31:0] iREQ_DATA,
		output wire oREQ_VALID,
		output wire [31:0] oREQ_DATA,
		//Interrupt
		output wire [3:0] oIRQ_IRQ
	);
	
	wire req_fifo_full;
	wire req_fifo_empty;
	wire req_fifo_rw;
	wire [31:0] req_fifo_data;
	wire [3:0] req_fifo_addr;
	wire req_fifo_read_condition;

	mist1032isa_async_fifo #(37, 4, 2) FIFO_REQ(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iIF_CLOCK),
		.iWR_EN(iREQ_VALID),
		.iWR_DATA({iREQ_RW, iREQ_ADDR, iREQ_DATA}),
		.oWR_FULL(req_fifo_full),
		//RD
		.iRD_CLOCK(iTIMER_CLOCK),
		.iRD_EN(req_fifo_read_condition),
		.oRD_DATA({req_fifo_rw, req_fifo_addr, req_fifo_data}),
		.oRD_EMPTY(req_fifo_empty)
	);
	
	wire write_condition = req_fifo_read_condition && req_fifo_rw;
	wire read_condition = req_fifo_read_condition && !req_fifo_rw;

	//Configlation Table
	integer i;
	reg [31:0] b_config_register_list[0:14];
	always@(posedge iTIMER_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			for(i = 0; i < 15; i = i + 1)begin
				b_config_register_list [i] <= 32'h0;
			end
		end
		else begin
			if(write_condition)begin
				b_config_register_list [req_fifo_addr] <= req_fifo_data;
			end
		end
	end
	
	//Main Counter
	wire main_config_write_cc = (req_fifo_addr == `UTIM6XAMCFGR)? write_condition : 1'b0;
	wire main_counter_low_write_cc = (req_fifo_addr == `UTIM6XAMCR31_0)? write_condition : 1'b0;
	wire main_counter_high_write_cc = (req_fifo_addr == `UTIM6XAMCR63_32)? write_condition : 1'b0;
	wire [63:0] main_counter_write_data = (main_counter_high_write_cc)? {req_fifo_data, 32'h0} : {32'h0, req_fifo_data};
	wire main_counter_working;
	wire [63:0] main_counter;
	main_counter MAIN_COUNTER(		
		.iCLOCK(iTIMER_CLOCK),
		.inRESET(inRESET),
		.iCONF_WRITE(main_config_write_cc),
		.iCONF_ENA(req_fifo_data[0]),	
		.iCOUNT_WRITE(main_counter_high_write_cc || main_counter_low_write_cc),
		.inCOUNT_DQM({!main_counter_high_write_cc, !main_counter_low_write_cc}),
		.iCOUNT_COUNTER(main_counter_write_data),
		.oWORKING(main_counter_working),
		.oCOUNTER(main_counter)
	);
	
	//Comparator0
	wire compare0_config_write_cc = (req_fifo_addr == `UTIM64XACC0CFRG)? write_condition : 1'b0;
	wire compare0_counter_low_write_cc = (req_fifo_addr == `UTIM64XACC0R31_0)? write_condition : 1'b0;
	wire compare0_counter_high_write_cc = (req_fifo_addr == `UTIM64XACC0R63_32)? write_condition : 1'b0;
	wire [63:0] compare0_counter_write_data = (compare0_counter_high_write_cc)? {req_fifo_data, 32'h0} : {32'h0, req_fifo_data};//64'h00000000_000071af;
	wire compare0_irq;
	comparator_counter COMPARATOR0(
		.iCLOCK(iTIMER_CLOCK),
		.inRESET(inRESET),
		.iMTIMER_WORKING(main_counter_working),
		.iMTIMER_COUNT(main_counter),
		.iCONF_WRITE(compare0_config_write_cc),
		.iCONF_ENA(req_fifo_data[0]),
		.iCONF_IRQENA(req_fifo_data[1]),
		.iCONF_64MODE(req_fifo_data[2]),
		.iCONF_PERIODIC(req_fifo_data[3]),
		.iCOUNT_WRITE(compare0_counter_high_write_cc || compare0_counter_low_write_cc),
		.inCOUNT_DQM({!compare0_counter_high_write_cc, !compare0_counter_low_write_cc}),
		.iCOUNT_COUNTER(compare0_counter_write_data),
		.oIRQ(compare0_irq)
	);
	

	//Comparator1
	wire compare1_config_write_cc = (req_fifo_addr == `UTIM64XACC1CFRG)? write_condition : 1'b0;
	wire compare1_counter_low_write_cc = (req_fifo_addr == `UTIM64XACC1R31_0)? write_condition : 1'b0;
	wire compare1_counter_high_write_cc = (req_fifo_addr == `UTIM64XACC1R63_32)? write_condition : 1'b0;
	wire [63:0] compare1_counter_write_data = (compare1_counter_high_write_cc)? {req_fifo_data, 32'h0} : {32'h0, req_fifo_data};
	wire compare1_irq;
	comparator_counter COMPARATOR1(
		.iCLOCK(iTIMER_CLOCK),
		.inRESET(inRESET),
		.iMTIMER_WORKING(main_counter_working),
		.iMTIMER_COUNT(main_counter),
		.iCONF_WRITE(compare1_config_write_cc),
		.iCONF_ENA(req_fifo_data[0]),
		.iCONF_IRQENA(req_fifo_data[1]),
		.iCONF_64MODE(req_fifo_data[2]),
		.iCONF_PERIODIC(req_fifo_data[3]),
		.iCOUNT_WRITE(compare1_counter_high_write_cc || compare1_counter_low_write_cc),
		.inCOUNT_DQM({!compare1_counter_high_write_cc, !compare1_counter_low_write_cc}),
		.iCOUNT_COUNTER(compare1_counter_write_data),
		.oIRQ(compare1_irq)
	);
	

	//Comparator2
	wire compare2_config_write_cc = (req_fifo_addr == `UTIM64XACC2CFRG)? write_condition : 1'b0;
	wire compare2_counter_low_write_cc = (req_fifo_addr == `UTIM64XACC2R31_0)? write_condition : 1'b0;
	wire compare2_counter_high_write_cc = (req_fifo_addr == `UTIM64XACC2R63_32)? write_condition : 1'b0;
	wire [63:0] compare2_counter_write_data = (compare2_counter_high_write_cc)? {req_fifo_data, 32'h0} : {32'h0, req_fifo_data};
	wire			compare2_irq;
	comparator_counter COMPARATOR2(
		.iCLOCK(iTIMER_CLOCK),
		.inRESET(inRESET),
		.iMTIMER_WORKING(main_counter_working),
		.iMTIMER_COUNT(main_counter),
		.iCONF_WRITE(compare2_config_write_cc),
		.iCONF_ENA(req_fifo_data[0]),
		.iCONF_IRQENA(req_fifo_data[1]),
		.iCONF_64MODE(req_fifo_data[2]),
		.iCONF_PERIODIC(req_fifo_data[3]),
		.iCOUNT_WRITE(compare2_counter_high_write_cc || compare2_counter_low_write_cc),
		.inCOUNT_DQM({!compare2_counter_high_write_cc, !compare2_counter_low_write_cc}),
		.iCOUNT_COUNTER(compare2_counter_write_data),
		.oIRQ(compare2_irq)
	);
	
	//Comparator3
	wire compare3_config_write_cc = (req_fifo_addr == `UTIM64XACC3CFRG)? write_condition : 1'b0;
	wire compare3_counter_low_write_cc = (req_fifo_addr == `UTIM64XACC3R31_0)? write_condition : 1'b0;
	wire compare3_counter_high_write_cc = (req_fifo_addr == `UTIM64XACC3R63_32)? write_condition : 1'b0;
	wire [63:0] compare3_counter_write_data = (compare3_counter_high_write_cc)? {req_fifo_data, 32'h0} : {32'h0, req_fifo_data};
	wire compare3_irq;
	comparator_counter COMPARATOR3(
		.iCLOCK(iTIMER_CLOCK),
		.inRESET(inRESET),
		.iMTIMER_WORKING(main_counter_working),
		.iMTIMER_COUNT(main_counter),
		.iCONF_WRITE(compare3_config_write_cc),
		.iCONF_ENA(req_fifo_data[0]),
		.iCONF_IRQENA(req_fifo_data[1]),
		.iCONF_64MODE(req_fifo_data[2]),
		.iCONF_PERIODIC(req_fifo_data[3]),
		.iCOUNT_WRITE(compare3_counter_high_write_cc || compare3_counter_low_write_cc),
		.inCOUNT_DQM({!compare3_counter_high_write_cc, !compare3_counter_low_write_cc}),
		.iCOUNT_COUNTER(compare3_counter_write_data),
		.oIRQ(compare3_irq)
	);
	
	//Output Buffer
	wire out_fifo_full;
	wire out_fifo_empty;
	wire [31:0] out_fifo_data;
	wire out_fifo_read_condition;
	assign out_fifo_read_condition = !out_fifo_empty;
	mist1032isa_async_fifo #(32, 4, 2) FIFO_OUT(
		//System
		.inRESET(inRESET),
		//Remove
		.iREMOVE(1'b0),
		//WR
		.iWR_CLOCK(iTIMER_CLOCK),
		.iWR_EN(req_fifo_read_condition),
		.iWR_DATA(b_config_register_list[req_fifo_addr]),
		.oWR_FULL(out_fifo_full),
		//RD
		.iRD_CLOCK(iIF_CLOCK),
		.iRD_EN(out_fifo_read_condition),
		.oRD_DATA(out_fifo_data),
		.oRD_EMPTY(out_fifo_empty)
	);

	
	assign req_fifo_read_condition = !req_fifo_empty && (req_fifo_rw || (!req_fifo_rw && !out_fifo_full));
	
	assign oREQ_VALID = out_fifo_read_condition;
	assign oREQ_DATA = out_fifo_data;
	
	assign oREQ_BUSY = req_fifo_full;	
	assign oIRQ_IRQ = {compare3_irq, compare2_irq, compare1_irq, compare0_irq};
	
endmodule

`default_nettype wire

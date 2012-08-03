`default_nettype none
`define	CYCLE  20
`include "sim_global.h"
module test_mist32_bs0;
	//System
	reg						CLOCK_50;		
	//UART
	reg						UART_RXD;
	wire					UART_TXD;
	//SDRAM
	wire					DRAM_CKE;
	wire					DRAM_CLK;
	wire					DRAM_WE_N;
	wire					DRAM_CAS_N;
	wire					DRAM_RAS_N;
	wire					DRAM_CS_N;
	wire					DRAM_DQM0;
	wire					DRAM_DQM1;
	wire					DRAM_DQM2;
	wire					DRAM_DQM3;
	wire	[1:0]			DRAM_BA;
	wire	[12:0]			DRAM_ADDR;
	wire	[31:0]			DRAM_DQ;
	pullup(DRAM_DQ);
	//SRAM IF
	wire					SRAM_CE_N;
	wire					SRAM_OE_N;
	wire					SRAM_WE_N;
	wire					SRAM_LB_N;
	wire					SRAM_UB_N;
	wire	[19:0]			SRAM_ADDR;
	wire	[15:0]			SRAM_DQ;
	reg		[15:0]			SRAM_DQ_reg;
	pullup(SRAM_DQ);
	assign		SRAM_DQ		=	SRAM_DQ_reg;	
	//VGA
	wire					VGA_HS;
	wire					VGA_VS;
	wire	[7:0]			VGA_R;
	wire	[7:0]			VGA_G;
	wire	[7:0]			VGA_B;
	wire					VGA_CLK;
	wire					VGA_BLANK_N;
	wire					VGA_SYNC_N;
	//PS2
	reg						PS2_CLK;
	reg						PS2_DAT;
	//SW
	reg		[3:0]			KEY;					//Tact SW
	reg		[17:0]			SW;						//Slide SW
	//LED
	wire	[17:0]			LEDR;					//Red LED
	wire	[7:0]			LEDG;					//Green LED
	//Flash
	wire	[22:0]			FL_ADDR;
	wire	[7:0]			FL_DQ;
	//reg		[7:0]			FL_DQ_reg;
	//pullup(FL_DQ);
	//assign		FL_DQ		=	FL_DQ_reg;
	wire					FL_WE_N;
	wire					FL_RST_N;
	wire					FL_WP_N;
	reg						FL_RY;
	wire					FL_CE_N;
	wire					FL_OE_N;

	
	
	/*******************************************************************************
	Target
	*******************************************************************************/
	top_de2_115 TARGET(
		//System
		.CLOCK_50(CLOCK_50),				//Clock 50MHz
		//UART
		.UART_RXD(UART_RXD),
		.UART_TXD(UART_TXD),
		//SDRAM IF
		.DRAM_CKE(DRAM_CKE),
		.DRAM_CLK(DRAM_CLK),
		.DRAM_WE_N(DRAM_WE_N),
		.DRAM_CAS_N(DRAM_CAS_N),
		.DRAM_RAS_N(DRAM_RAS_N),
		.DRAM_CS_N(DRAM_CS_N),
		.DRAM_DQM0(DRAM_DQM0),
		.DRAM_DQM1(DRAM_DQM1),
		.DRAM_DQM2(DRAM_DQM2),
		.DRAM_DQM3(DRAM_DQM3),
		.DRAM_BA(DRAM_BA),
		.DRAM_ADDR(DRAM_ADDR),
		.DRAM_DQ(DRAM_DQ),				
		//SRAM IF
		.SRAM_CE_N(SRAM_CE_N),
		.SRAM_OE_N(SRAM_OE_N),
		.SRAM_WE_N(SRAM_WE_N),
		.SRAM_LB_N(SRAM_LB_N),
		.SRAM_UB_N(SRAM_UB_N),
		.SRAM_ADDR(SRAM_ADDR),
		.SRAM_DQ(SRAM_DQ),
		//VGA
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_CLK(VGA_CLK),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		//PS2
		.PS2_CLK(PS2_CLK),
		.PS2_DAT(PS2_DAT),
		//SW
		.KEY(KEY),					//Tact SW
		.SW(SW),						//Slide SW
		//LED
		.LEDR(LEDR),					//Red LED
		.LEDG(LEDG),					//Green LED
		//Flash
		.FL_ADDR(FL_ADDR),
		.FL_DQ(FL_DQ),
		.FL_WE_N(FL_WE_N),
		.FL_RST_N(FL_RST_N),
		.FL_WP_N(FL_WP_N),
		.FL_RY(FL_RY),
		.FL_CE_N(FL_CE_N),
		.FL_OE_N(FL_OE_N)
	);
	
	
	/*******************************************************************************
	Flash ROM
	*******************************************************************************/
	assign		FL_DQ		=		func_f_rom(FL_ADDR);
	function [7:0] func_f_rom;
		input		[22:0]		func_addr;
		begin
			case(func_addr)
				23'h0:	func_f_rom		=	8'h20;
				23'h1:	func_f_rom		=	8'h00;
				23'h2:	func_f_rom		=	8'hc0;
				23'h3:	func_f_rom		=	8'h0d;
				23'h4:	func_f_rom		=	8'h60;
				23'h5:	func_f_rom		=	8'h00;
				23'h6:	func_f_rom		=	8'hc0;
				23'h7:	func_f_rom		=	8'h0d;
				default:	func_f_rom		=	8'h00;
			endcase
		end
	endfunction
	
	
	/*******************************************************************************
	SDRAM Symbol
	*******************************************************************************/
	
	mt48lc32m16a2 SDRAM15_0(
		.Dq(DRAM_DQ[15:0]), 
		.Addr(DRAM_ADDR), 
		.Ba(DRAM_BA), 
		.Clk(DRAM_CLK), 
		.Cke(DRAM_CKE), 
		.Cs_n(DRAM_CS_N), 
		.Ras_n(DRAM_RAS_N), 
		.Cas_n(DRAM_CAS_N), 
		.We_n(DRAM_WE_N), 
		.Dqm({DRAM_DQM1, DRAM_DQM0})
	);
	
	
	mt48lc32m16a2 SDRAM31_16(
		.Dq(DRAM_DQ[31:16]), 
		.Addr(DRAM_ADDR), 
		.Ba(DRAM_BA), 
		.Clk(DRAM_CLK), 
		.Cke(DRAM_CKE), 
		.Cs_n(DRAM_CS_N), 
		.Ras_n(DRAM_RAS_N), 
		.Cas_n(DRAM_CAS_N), 
		.We_n(DRAM_WE_N), 
		.Dqm({DRAM_DQM3, DRAM_DQM2})
	);


	/*******************************************************************************
	Simlation Stae
	*******************************************************************************/
	initial begin
		#0
			begin
				/*
				$dumpfile("dump.vcd");
				$dumpvars(0, test_mist32_bs0); 
				*/
				UART_RXD			=		1'b1;
				CLOCK_50			=		1'b0;
				SRAM_DQ_reg			=		{16{1'b0}};
				PS2_CLK				=		1'b1;
				PS2_DAT				=		1'b1;
				KEY					=		{4{1'b0}};
				SW					=		18'h00FF0;
				//FL_DQ_reg			=		8'h0;
				FL_RY				=		1'b0;
			end
		#1
			begin
				KEY					=		{4{1'b1}};
			end
/*			
		#10000000
			begin
				KEY[3]				=		1'b0;
			end
		#100000
			begin
				KEY[3]				=		1'b1;
				
			end*/
			
	end //initial 

	initial begin
		#80000000
			begin
				$finish;
			end
	end
	
	
	
	
	/*******************************************************************************
	Clock
	*******************************************************************************/
	always#(`CYCLE/2)
	begin
			CLOCK_50		=		!CLOCK_50;
	end

	
	
	/*******************************************************************************
	Damy Keyboard
	*******************************************************************************/
	/*
	task damy_ps2_keyboard
		input	[7:0]		scancode;
		integer i;
		for(i = 0; i < 8;)
	endtask
	*/
	
	//always#(`CYCLE*128000)
	always#(650000/*430000*/)
	begin
			PS2_SigGen(8'h46);
			
	end
	
	
	
	task PS2_SigGen;
        input [7:0] input_code;
        integer i;
        begin
            PS2_CLK <= 1'b1;
            PS2_DAT <= 1'b0; // Stop bit
            
            #40000;
            PS2_CLK <= 1'b0; // 立ち下がりエッジ
            #40000;
            
            for(i=0; i<=7; i=i+1) begin
                PS2_CLK <= 1'b1; // 立ち上がりエッジ
                PS2_DAT <= input_code[i]; // シリアルデータ出力
                
                #40000;
                PS2_CLK <= 1'b0; // 立下りエッジ
                #40000;
            end
        
            PS2_CLK <= 1'b1;
            PS2_DAT <= !(^input_code);
        
            #40000;
            PS2_CLK <= 1'b0; // 立ち下がりエッジ
            #40000;
        
            PS2_CLK <= 1'b1;
            PS2_DAT <= 1'b1; // Stop bit
        
            #40000;
            PS2_CLK <= 1'b0; // 立ち下がりエッジ
            #40000;
            PS2_CLK <= 1'b1; // 1に戻す
        end
    endtask
	
	/*******************************************************************************
	Display Out
	*******************************************************************************/
	integer cycle_count = 0;
	integer	i = 0;

	
	//initial #(10000000)begin
	always#(`CYCLE) begin : Display_Out
		//Cycle Count
		cycle_count = cycle_count + 1;
		/**********Display Out**********/
		if(`DISP_TIME_DUMP)begin
			$display("=====================================================================================================================================================");
			$display("CYCLE : %X, Time : %d", cycle_count, $time);
		end
		//Core State
		if(`DISP_CORESTATE_DUMP)begin
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.EXCEPTION_MANAGER.b_main_state == 3'h00)begin
				$display("Core State : Normal");
			end
			else begin
				$display("Core State : Exception(Branch)");
			end
		end
		if(`DISP_COMMIT_DUMP)begin
			$display("Commit Counter : %X", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE5_SCHEDULER1.b_commit_pointer[5:0]);
			$display("Commit Program Counter : %X", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE5_SCHEDULER1.entry_info_pc[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE5_SCHEDULER1.b_commit_pointer[5:0]]);
		end
		//Scheduler2 Set Instruction
		if(`DISP_SCHEDULER_DUMP)begin
			$display("-----Scheduler2 Set Instruction-----");
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.iPREVIOUS_0_VALID)begin
				$display("Line 0 Request State : [PC:%x, COMMIT_TAG:%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.iPREVIOUS_PC, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.iPREVIOUS_0_COMMIT_TAG);
			end
			else begin
				$display("Line 0 Request State : [none]");
			end
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.iPREVIOUS_1_VALID)begin
				$display("Line 1 Request State : [PC:%x, COMMIT_TAG:%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.iPREVIOUS_PC + 32'h1, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.iPREVIOUS_1_COMMIT_TAG);
			end
			else begin
				$display("Line 1 Request State : [none]");
			end
			//RS0
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs0_0_regist_valid)begin
				$display("RS0_0 : [%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.w_rs_alu0_reg_pointer);
			end
			else begin
				$display("RS0_0 : [none]");
			end
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs0_1_regist_valid)begin
				$display("RS0_1 : [%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.w_rs_alu0_reg_pointer + ((TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.w_rs_alu0_reg_offset == 2'h2)? 3'h1 : 3'h0));
			end
			else begin
				$display("RS0_1 : [none]");
			end
			//RS1
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs1_0_regist_valid)begin
				$display("RS1_0 : [%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs_alu1_regist_0_num);
			end
			else begin
				$display("RS1_0 : [none]");
			end
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs1_1_regist_valid)begin
				$display("RS1_1 : [%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs_alu1_regist_1_num);
			end
			else begin
				$display("RS1_1 : [none]");
			end
			//RS2
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs2_0_regist_valid)begin
				$display("RS2_0 : [%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs_alu2_regist_0_num);
			end
			else begin
				$display("RS2_0 : [none]");
			end
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs2_1_regist_valid)begin
				$display("RS2_1 : [%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs_alu2_regist_1_num);
			end
			else begin
				$display("RS2_1 : [none]");
			end
			//RS3
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs3_0_regist_valid)begin
				$display("RS3_0 : [%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.w_rs_alu3_reg_pointer);
			end
			else begin
				$display("RS3_0 : [none]");
			end
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.rs3_1_regist_valid)begin
				$display("RS3_1 : [%x]", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.w_rs_alu3_reg_pointer + ((TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.w_rs_alu3_reg_offset == 2'h2)? 3'h1 : 3'h0));
			end
			else begin
				$display("RS3_1 : [none]");
			end
		end
		//Register List
		if(`DISP_REG_DUMP)begin
			$display("-----Logic Resister List[Name:Pointer(Data)]");
			$display("%x:%X(%X), %x:%X(%X), %x:%X(%X), %x:%X(%X)", 
				0, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[0], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[0]],
				1, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[1], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[1]],
				2, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[2], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[2]],
				3, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[3], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[3]]);
			$display("%x:%X(%X), %x:%X(%X), %x:%X(%X), %x:%X(%X)", 	
				4, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[4], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[4]],
				5, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[5], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[5]],
				6, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[6], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[6]],
				7, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[7], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[7]]);
			$display("%x:%X(%X), %x:%X(%X), %x:%X(%X), %x:%X(%X)", 	
				8, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[8], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[8]],
				9, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[9], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[9]],
				10, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[10], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[10]],
				11, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[11], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[11]]);
			$display("%x:%X(%X), %x:%X(%X), %x:%X(%X), %x:%X(%X)", 	
				12, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[12], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[12]],
				13, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[13], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[13]],
				14, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[14], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[14]],
				15, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[15], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[15]]);
			$display("%x:%X(%X), %x:%X(%X), %x:%X(%X), %x:%X(%X)", 	
				16, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[16], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[16]],
				17, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[17], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[17]],
				18, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[18], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[18]],
				19, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[19], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[19]]);
			$display("%x:%X(%X), %x:%X(%X), %x:%X(%X), %x:%X(%X)", 	
				20, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[20], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[20]],
				21, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[21], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[21]],
				22, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[22], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[22]],
				23, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[23], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[23]]);
			$display("%x:%X(%X), %x:%X(%X), %x:%X(%X), %x:%X(%X)", 	
				24, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[24], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[24]],
				25, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[25], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[25]],
				26, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[26], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[26]],
				27, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[27], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[27]]);
			$display("%x:%X(%X), %x:%X(%X), %x:%X(%X), %x:%X(%X)", 	
				28, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[28], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[28]],
				29, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[29], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[29]],
				31, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[30], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[30]],
				32, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[31], TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE6_SCHEDULER2.gr_info_data[TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE4_RENAMING.renaming_info_old_regname[31]]);
		end
		
		if(`DISP_ST)begin
			if(TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE7_ALU3.oDATAIO_REQ && !TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE7_ALU3.iDATAIO_BUSY && TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE7_ALU3.oDATAIO_RW)begin
				$display("[PC:%x]Store[ORDER:%x]|[ADDR] : %x  |  [Data] : %x", TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE7_ALU3.b_pc, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE7_ALU3.oDATAIO_ORDER, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE7_ALU3.oDATAIO_ADDR, TARGET.MIST32_BS0.PROCESSOR.CORE_IF.CORE.CORE_PIPELINE.SATGE7_ALU3.oDATAIO_DATA);
			end
		end
			

	end
	
	
	
	
endmodule














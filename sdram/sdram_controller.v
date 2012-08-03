/****************************************
	SDRAM Controller

	
	
	Make	:	2010/12/25
	Update	:	
****************************************/
`default_nettype	none		
`include			"sdramc_50mhz.h"


module sdram_controller(
				//System
				input									iCLOCK,			
				input									inRESET,
				//User-REQ
				input									iUSER_REQ_VALID,
				input	[`DQM_BIT-1:0]					inUSER_REQ_DQM,			//Write only support
				input									iUSER_REQ_RW,			//0:Read 1:Write
				input	[2+`ROW_BIT+`COLUMN_BIT-1:0]	iUSER_REQ_ADDR,
				input	[`IO_BIT-1:0]					iUSER_REQ_DATA,
				output									oUSER_REQ_LOCK,
				//User-OUT
				input									iUSER_OUT_VALID,
				output	[`IO_BIT-1:0]					oUSER_OUT_DATA,
				output									oUSER_OUT_EMPTY,
				//SDRASM
				output	[`ROW_BIT-1:0]					oSDRAM_ADDR,
				output	[1:0]							oSDRAM_BA,
				inout	[`IO_BIT-1:0]					ioSDRAM_DATA,
				output									onSDRAM_CS,
				output									onSDRAM_RAS,
				output									onSDRAM_CAS,
				output									onSDRAM_WE,
				output	[`DQM_BIT-1:0]					onSDRAM_DQM,
				output									oSDRAM_CKE,
				output									oSDRAM_CLK);
				
	
	function [`ROW_BIT-1:0] func_addr_set;
		input						func_addr_set_enable;
		input	[3:0]				func_addr_set_sub_state;
		input	[2:0]				func_addr_set_cas_latency;
		input	[`ROW_BIT-1:0]		func_addr_set_row;
		input	[`COLUMN_BIT-1:0]	func_addr_set_column;
		begin
			if(!func_addr_set_enable)begin
				func_addr_set	=	{`ROW_BIT{1'b0}};
			end
			else begin
				case(func_addr_set_sub_state)
					`SUBSTT_CKACTIVE	:	func_addr_set		=		{`ROW_BIT{1'b0}};
					`SUBSTT_WAIT200US	:	func_addr_set		=		{`ROW_BIT{1'b0}};
					`SUBSTT_PALL		:	func_addr_set		=		{{`ROW_BIT-11{1'b0}}, 1'b1, {10{1'b0}}};
					`SUBSTT_REF			:	func_addr_set		=		{`ROW_BIT{1'b0}};
					`SUBSTT_MRS			:	func_addr_set		=		{{`ROW_BIT-7{1'b0}}, func_addr_set_cas_latency, 4'h0};
					`SUBSTT_NOP			:	func_addr_set		=		{`ROW_BIT{1'b0}};
					`SUBSTT_ACT			:	func_addr_set		=		func_addr_set_row;
					`SUBSTT_READ		:	func_addr_set		=		{{`ROW_BIT-11{1'b0}},1'b0, func_addr_set_column[9:0]};
					`SUBSTT_WRITE		:	func_addr_set		=		{{`ROW_BIT-11{1'b0}},1'b0, func_addr_set_column[9:0]};
					`SUBSTT_PRE			:	func_addr_set		=		{`ROW_BIT{1'b0}};
					default				:	
						begin
							func_addr_set		=		{`ROW_BIT{1'b0}};
							if(func_addr_set_sub_state != 3'bXXX)begin
								$display("ERROR : func_addr_set\t", $stime);
							end
						end
				endcase
			end
		end
	endfunction
	
	function [1:0] func_bank_set;
		input						func_bank_set_enable;
		input	[3:0]				func_bank_set_sub_state;
		input	[1:0]				func_bank_set_bank;
		begin
			if(!func_bank_set_enable)begin
				func_bank_set	=	2'h0;
			end
			else begin
				case(func_bank_set_sub_state)
					`SUBSTT_CKACTIVE	:	func_bank_set		=		2'h0;
					`SUBSTT_WAIT200US	:	func_bank_set		=		2'h0;
					`SUBSTT_PALL		:	func_bank_set		=		2'h0;
					`SUBSTT_REF			:	func_bank_set		=		2'h0;
					`SUBSTT_MRS			:	func_bank_set		=		2'h0;
					`SUBSTT_NOP			:	func_bank_set		=		2'h0;
					`SUBSTT_ACT			:	func_bank_set		=		func_bank_set_bank;
					`SUBSTT_READ		:	func_bank_set		=		func_bank_set_bank;
					`SUBSTT_WRITE		:	func_bank_set		=		func_bank_set_bank;
					`SUBSTT_PRE			:	func_bank_set		=		func_bank_set_bank;
					default				:	
						begin
							func_bank_set		=		2'h0;
							if(func_bank_set_sub_state != 3'bXXX)begin
								$display("ERROR : func_bank_set\t", $stime);
							end
						end
				endcase
			end
		end
	endfunction


	function func_ras_set;
		input			func_ras_set_enable;
		input	[3:0]	func_ras_set_cmd;
		begin
			if(func_ras_set_enable)begin
				case(func_ras_set_cmd)
					`SUBSTT_PALL	:	func_ras_set		=		1'b0;
					`SUBSTT_REF		:	func_ras_set		=		1'b0;
					`SUBSTT_MRS		:	func_ras_set		=		1'b0;
					`SUBSTT_NOP		:	func_ras_set		=		1'b1;
					`SUBSTT_ACT		:	func_ras_set		=		1'b0;
					`SUBSTT_READ	:	func_ras_set		=		1'b1;
					`SUBSTT_WRITE	:	func_ras_set		=		1'b1;
					`SUBSTT_PRE		:	func_ras_set		=		1'b0;
					default			:	func_ras_set		=		1'b1;	
				endcase
			end
			else begin
				func_ras_set		=		1'b1;
			end
		end
	endfunction
	
	function func_cas_set;
		input			func_cas_set_enable;
		input	[3:0]	func_cas_set_cmd;
		begin
			if(func_cas_set_enable)begin
				case(func_cas_set_cmd)
					`SUBSTT_PALL	:	func_cas_set		=		1'b1;
					`SUBSTT_REF		:	func_cas_set		=		1'b0;
					`SUBSTT_MRS		:	func_cas_set		=		1'b0;
					`SUBSTT_NOP		:	func_cas_set		=		1'b1;				
					`SUBSTT_ACT		:	func_cas_set		=		1'b1;
					`SUBSTT_READ	:	func_cas_set		=		1'b0;
					`SUBSTT_WRITE	:	func_cas_set		=		1'b0;
					`SUBSTT_PRE		:	func_cas_set		=		1'b1;				
					default			:	func_cas_set		=		1'b1;
				endcase
			end
			else begin
				func_cas_set		=		1'b1;
			end
		end
	endfunction
	
	function func_we_set;
		input			func_we_set_enable;
		input	[3:0]	func_we_set_cmd;
		begin
			if(func_we_set_enable)begin
				case(func_we_set_cmd)
					`SUBSTT_PALL	:	func_we_set		=		1'b0;
					`SUBSTT_REF		:	func_we_set		=		1'b1;
					`SUBSTT_MRS		:	func_we_set		=		1'b0;
					`SUBSTT_NOP		:	func_we_set		=		1'b1;
					`SUBSTT_ACT		:	func_we_set		=		1'b1;
					`SUBSTT_READ	:	func_we_set		=		1'b1;
					`SUBSTT_WRITE	:	func_we_set		=		1'b0;
					`SUBSTT_PRE		:	func_we_set		=		1'b0;
					default			:	func_we_set		=		1'b1;
				endcase
			end
			else begin
				func_we_set		=		1'b1;
			end
		end
	endfunction
	
	/*************************************
	Register & Wire
	*************************************/	
	//Input FIFO
	wire	[3:0]							w_req_fifo_count;
	wire									w_req_en;
	wire	[`IO_BIT-1:0]					w_req_data;
	wire	[1:0]							w_req_bank;
	wire	[`ROW_BIT-1:0]					w_req_row;
	wire	[`COLUMN_BIT-1:0]				w_req_column;
	wire									w_req_rw;			//0:Read 1:Write
	wire	[`DQM_BIT-1:0]					w_req_dqm;
	wire									w_req_empty;
	//Rd CMD & Wr CMD
	wire									read_cmd_fifo_rd;
	wire									write_cmd_fifo_rd;
	//Request BUffer
	reg		[`IO_BIT-1:0]					b_req_data;
	reg		[1:0]							b_req_bank;
	reg		[`ROW_BIT-1:0]					b_req_row;
	reg		[`COLUMN_BIT-1:0]				b_req_column;
	reg										b_req_rw;			//0:Read 1:Write
	reg		[`DQM_BIT-1:0]					b_req_dqm;
	reg										b_req_empty;
	//Output Buffer
	reg		[`CAS_LATENCY-1:0]				rd_en;
	//Output Fifo
	wire	[3:0]							w_out_fifo_count;
	wire	[`IO_BIT-1:0]					w_out_data;
	wire									w_out_full;
	//Main State
	reg		[2:0]							top_state;			
	reg		[3:0]							sub_state;
	reg		[2:0]							wait_state;
	reg		[3:0]							loop;
	reg										wait_active;
	reg		[14:0]							wait_count;
	reg		[11:0]							refresh_counter;
	reg		[1:0]							active_bank;
	reg		[`ROW_BIT-1:0]					active_row;
	reg		[3:0]							tras_count;
	reg		[3:0]							trc_count;

	
	
	/*************************************
	* Input FIFO
	*************************************/	
	sync_fifo #(`DQM_BIT + 3+`ROW_BIT+`COLUMN_BIT+`IO_BIT, 16, 4) IN_FIFO(
		.iCLOCK(iCLOCK), .inRESET(inRESET), .iREMOVE(1'b0),
		.oCOUNT(w_req_fifo_count), 
		.iWR_EN(iUSER_REQ_VALID), 
		.iWR_DATA({inUSER_REQ_DQM , iUSER_REQ_RW, iUSER_REQ_ADDR, iUSER_REQ_DATA}), 
		.oWR_FULL(oUSER_REQ_LOCK),
		.iRD_EN(w_req_en & !w_req_empty), 
		.oRD_DATA({w_req_dqm , w_req_rw, w_req_bank, w_req_row, w_req_column, w_req_data}), 
		.oRD_EMPTY(w_req_empty)
	);
												
	assign	w_req_en				=		((read_cmd_fifo_rd || write_cmd_fifo_rd || (top_state == `TOPSTT_ACTIVE && sub_state ==  `SUBSTT_ACT)) & ~wait_active)? 1'b1 & !w_req_empty : 1'b0;
	assign	read_cmd_fifo_rd		=		(refresh_counter < `REFLESH_TIMING)? top_state == `TOPSTT_READ && sub_state == `SUBSTT_READ && (active_bank == w_req_bank && active_row == w_req_row) && ~wait_active : 1'b0;
	assign	write_cmd_fifo_rd		=		(refresh_counter < `REFLESH_TIMING)? top_state == `TOPSTT_WRITE && sub_state == `SUBSTT_WRITE && (active_bank == w_req_bank && active_row == w_req_row) && ~wait_active : 1'b0;
	
	//Request Buffer
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_req_data		<=		{`IO_BIT{1'b0}};
			b_req_bank		<=		2'b00;
			b_req_row		<=		{`ROW_BIT{1'b0}};
			b_req_column	<=		{`COLUMN_BIT{1'b0}};
			b_req_rw		<=		1'b0;
			b_req_dqm		<=		{`DQM_BIT{1'b0}};
			b_req_empty		<=		1'b0;
		end
		else begin
			if(w_req_en)begin
				b_req_data		<=		w_req_data;
				b_req_bank		<=		w_req_bank;
				b_req_row		<=		w_req_row;
				b_req_column	<=		w_req_column;
				b_req_rw		<=		w_req_rw;
				b_req_dqm		<=		w_req_dqm;
				b_req_empty		<=		w_req_empty;
			end
		end
	end
													
	/*************************************
	* Output FIFO
	*************************************/
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			rd_en		<=		{`CAS_LATENCY{1'b0}};
		end
		else begin
			rd_en		<=		{rd_en, (top_state == `TOPSTT_READ && sub_state == `SUBSTT_READ && !wait_active)? 1'b1 : 1'b0};
		end
	end
	
	
	sync_fifo #(`IO_BIT, 16, 4) OUT_FIFO(
		.iCLOCK(iCLOCK), 
		.inRESET(inRESET), 
		.iREMOVE(1'b0),
		.oCOUNT(w_out_fifo_count), 
		.iWR_EN(rd_en[`CAS_LATENCY-1]), 
		.iWR_DATA(ioSDRAM_DATA), 
		.oWR_FULL(w_out_full),
		.iRD_EN(iUSER_OUT_VALID), 
		.oRD_DATA(oUSER_OUT_DATA), 
		.oRD_EMPTY(oUSER_OUT_EMPTY)
	);
				
	

	/*************************************
	* State
	*************************************/	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			top_state		<=		3'h0;
			sub_state		<=		4'h0;
			wait_state		<=		3'h0;
			loop			<=		4'h0;
			wait_active		<=		1'b0;
			wait_count		<=		{15{1'b0}};
			refresh_counter	<=		{12{1'b0}};
			active_bank		<=		2'h0;
			active_row		<=		{`ROW_BIT{1'b0}};
			tras_count		<=		4'h0;
			trc_count		<=		4'h0;
		end
		else begin
			//Timing Counter
			refresh_counter	<=		(top_state == `TOPSTT_INIT)? refresh_counter : refresh_counter + 12'h001;
			if(top_state == `TOPSTT_IDLE & !wait_active)begin
				tras_count		<=		`WAITCOUNT_RAS;
				trc_count		<=		`WAITCOUNT_RC;
			end
			else begin
				tras_count		<=		(tras_count == 4'h0)? tras_count : tras_count - 4'h1;	//tRAS Count
				trc_count		<=		(trc_count == 4'h0)? trc_count : trc_count - 4'h1;		//tRC Count
			end
			//Wait Count(NOP)
			if(wait_active)begin
				if(wait_count == {15{1'b0}})begin
					wait_active		<=		1'b0;
					if(wait_state != `WAITSTT_SUBSTT)begin
						sub_state		<=		wait_state;
					end
				end
				else begin
					wait_count		<=		wait_count - {{14{1'b0}}, 1'b1};
				end
			end
			//Main State
			else begin
				case(top_state)//synthesis parallel_case full_case
					`TOPSTT_INIT :		//Initial State
						begin
							case(sub_state)//synthesis parallel_case full_case
								`SUBSTT_CKACTIVE :
									begin		//1uS Wait
										sub_state		<=		`SUBSTT_CKACTIVE;
										wait_state		<=		`SUBSTT_WAIT200US;
										wait_active		<=		1'b1;
										wait_count		<=		`WAITCOUNT_INIT1US - 15'h0002;
									end
								`SUBSTT_WAIT200US :
									begin		//200uS Wait
										sub_state		<=		`SUBSTT_PALL;
										wait_state		<=		`WAITSTT_SUBSTT;
										wait_active		<=		1'b1;
										wait_count		<=		`WAITCOUNT_INIT200US - 15'h0002;
									end
								`SUBSTT_PALL :
									begin
										sub_state		<=		`SUBSTT_REF;
										wait_state		<=		`WAITSTT_SUBSTT;
										wait_active		<=		1'b1;
										wait_count		<=		`WAITCOUNT_RP - 15'h0002;
									end
								`SUBSTT_REF :
									begin									
										if(loop < 4'h8)begin
											sub_state		<=		`SUBSTT_REF;
											wait_state		<=		`WAITSTT_SUBSTT;
											loop			<=		loop + 4'h1;
											wait_active		<=		1'b1;
											wait_count		<=		`WAITCOUNT_RC - 15'h0002;
										end
										else begin
											//NEXT
											sub_state		<=		`SUBSTT_MRS;//`SUBSTT_REF;
											wait_state		<=		`WAITSTT_SUBSTT;//`SUBSTT_MRS;
											loop			<=		4'h0;
											wait_active		<=		1'b1;
											wait_count		<=		`WAITCOUNT_RC - 15'h0002;
										end
									end
								`SUBSTT_MRS :
									begin
										top_state		<=		`TOPSTT_IDLE;
										sub_state		<=		`SUBSTT_NOP;//`SUBSTT_MRS;
										wait_state		<=		`SUBSTT_NOP;
										wait_active		<=		(`WAITCOUNT_MRD - 15'h0002 <= 0)? 1'b0 : 1'b1;
										wait_count		<=		`WAITCOUNT_MRD - 15'h0002;
									end
							endcase
						end
					`TOPSTT_IDLE : 		//Idle
						begin
							if(refresh_counter > `REFLESH_TIMING)begin
								//Reflesh
								top_state		<=		`TOPSTT_REFRESH;
								sub_state		<=		`SUBSTT_REF;
								wait_state		<=		`WAITSTT_SUBSTT;
								loop			<=		4'h0;
								wait_active		<=		1'b0;
								wait_count		<=		4'h0;
							end
							else begin
								if(!w_req_empty)begin
									top_state		<=		`TOPSTT_ACTIVE;
									sub_state		<=		`SUBSTT_ACT;
									wait_state		<=		`WAITSTT_SUBSTT;
									wait_active		<=		1'b0;
									wait_count		<=		15'h0002;
									active_bank		<=		w_req_bank;
									active_row		<=		w_req_row;
								end
								else begin
									//Idle
									sub_state		<=		`SUBSTT_NOP;
									wait_state		<=		`WAITSTT_SUBSTT;
									wait_active		<=		1'b0;
									wait_count		<=		15'h0000;
								end
							end
						end
					`TOPSTT_ACTIVE :	//Active
						begin
							top_state		<=		(w_req_rw)? `TOPSTT_WRITE : `TOPSTT_READ;
							sub_state		<=		(w_req_rw)? `SUBSTT_WRITE : `SUBSTT_READ;
							wait_state		<=		`WAITSTT_SUBSTT;
							wait_active		<=		1'b1;
							wait_count		<=		`WAITCOUNT_RCD - 15'h0002;
						end
					`TOPSTT_READ : 		//Read
						begin
							if(w_out_fifo_count < 4'd14 && refresh_counter < `REFLESH_TIMING && !w_req_empty && active_bank == w_req_bank && active_row == w_req_row & !w_req_rw)begin
								//Read
								top_state		<=		`TOPSTT_READ;
								sub_state		<=		`SUBSTT_READ;
								wait_state		<=		`WAITSTT_SUBSTT;
								wait_active		<=		1'b0;
								wait_count		<=		15'h0000;
							end
							else if(refresh_counter < `REFLESH_TIMING && !w_req_empty && active_bank == w_req_bank && active_row == w_req_row & w_req_rw)begin
								//Write
								top_state		<=		`TOPSTT_WRITE;
								sub_state		<=		`SUBSTT_WRITE;
								wait_state		<=		`WAITSTT_SUBSTT;
								wait_active		<=		1'b1;
								wait_count		<=		((`CAS_LATENCY + 3'h1) - 3'h2 <= 0)? 15'h0000 : {{12{1'b0}}, (`CAS_LATENCY + 3'h1) - 3'h2};
							end
							else begin
								top_state		<=		`TOPSTT_PRECHARGE;
								sub_state		<=		`SUBSTT_PRE;
								wait_state		<=		`WAITSTT_SUBSTT;
								wait_active		<=		(tras_count >= 2)? 1'b1 : 1'b0; 
								wait_count		<=		(tras_count > 2)? tras_count-2 : 15'h0000;
							end
						end
					`TOPSTT_WRITE : 	//Write
						begin
							if(w_out_fifo_count < 4'd14 && refresh_counter < `REFLESH_TIMING && !w_req_empty && active_bank == w_req_bank && active_row == w_req_row & w_req_rw)begin
								//Read
								top_state		<=		`TOPSTT_WRITE;
								sub_state		<=		`SUBSTT_WRITE;
								wait_state		<=		`WAITSTT_SUBSTT;
								wait_active		<=		1'b0;
								wait_count		<=		15'h0000;
							end
							else if(refresh_counter < `REFLESH_TIMING && !w_req_empty && active_bank == w_req_bank && active_row == w_req_row & !w_req_rw)begin
								//Write
								top_state		<=		`TOPSTT_READ;
								sub_state		<=		`SUBSTT_READ;
								wait_state		<=		`WAITSTT_SUBSTT;
								wait_active		<=		1'b0;
								wait_count		<=		15'h0000;
							end
							else begin
								top_state		<=		`TOPSTT_PRECHARGE;
								sub_state		<=		`SUBSTT_PRE;
								wait_state		<=		`WAITSTT_SUBSTT;
								wait_active		<=		(tras_count >= 2 || `WAITCOUNT_DPL >= 2)? 1'b1 : 1'b0; 
								wait_count		<=		(tras_count >= `WAITCOUNT_DPL)? ((tras_count > 2)? tras_count-2 : 15'h0000) : (`WAITCOUNT_DPL > 2)? `WAITCOUNT_DPL-2 : 15'h0000;
							end
						end
					`TOPSTT_PRECHARGE :
						begin
							top_state		<=		`TOPSTT_IDLE;
							sub_state		<=		`SUBSTT_NOP;
							wait_state		<=		`WAITSTT_SUBSTT;
							loop			<=		4'h0;
							wait_active		<=		(trc_count >= 3 || `WAITCOUNT_RP >= 3)? 1'b1 : 1'b0; 		//Idle-1
							wait_count		<=		(trc_count >= `WAITCOUNT_RP)? ((trc_count > 3)? trc_count-3 : 15'h0000) : (`WAITCOUNT_RP > 3)? `WAITCOUNT_RP-3 : 15'h0000;	//Idle-1
							
						end
					`TOPSTT_REFRESH :	
						begin		
							top_state		<=		`TOPSTT_IDLE;
							sub_state		<=		`SUBSTT_NOP;
							wait_state		<=		`WAITSTT_SUBSTT;
							loop			<=		4'h0;
							wait_active		<=		1'b1;
							wait_count		<=		`WAITCOUNT_RC - 15'h0002;
							refresh_counter	<=		{12{1'b0}};
						end
				endcase
			end
		end
	end //always
	
	
	/***************************************************************
	Assign
	***************************************************************/
	//SDRAM
	assign		oSDRAM_ADDR			=		func_addr_set(~wait_active, sub_state, `CAS_LATENCY, active_row, b_req_column);//(top_state == `TOPSTT_ACTIVE & ~wait_active)? w_req_row : (sub_state == `SUBSTT_MRS & ~wait_active)? {{`ROW_BIT-7{1'b0}}, `CAS_LATENCY, 4'h0} : w_req_column;
	assign		oSDRAM_BA			=		func_bank_set(~wait_active, sub_state, active_bank); //(top_state == `TOPSTT_INIT && sub_state == `SUBSTT_MRS)? 2'h3: w_req_bank;
	assign		ioSDRAM_DATA		=		(b_req_rw && !wait_active)? b_req_data : 32'bz;
	assign		onSDRAM_CS			=		1'b0;
	assign		onSDRAM_RAS			=		func_ras_set(~wait_active, sub_state);
	assign		onSDRAM_CAS			=		func_cas_set(~wait_active,sub_state);
	assign		onSDRAM_WE			=		func_we_set(~wait_active, sub_state);
	assign		onSDRAM_DQM			=		 (b_req_rw && !wait_active)? b_req_dqm : {`DQM_BIT{1'b0}};
	assign		oSDRAM_CKE			=		(top_state == `TOPSTT_INIT && sub_state == `SUBSTT_CKACTIVE)? 1'b0 : 1'b1;
	assign		oSDRAM_CLK			=		iCLOCK;


endmodule


`default_nettype wire















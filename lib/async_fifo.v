/*******************************************************
FIFO Unit : Async Version
	
	
Make	:	2011/12/28

*******************************************************/

`default_nettype none

module async_fifo
	#(
		parameter N = 16,
		parameter DEPTH = 4,
		parameter D_N = 2
	)
	(
		//System
		input					inRESET,
		//Remove
		input					iREMOVE,
		//WR
		input					iWR_CLOCK,
		input					iWR_EN,
		input	[N-1:0]			iWR_DATA,
		output					oWR_FULL,
		//RD
		input					iRD_CLOCK,
		input					iRD_EN,
		output	[N-1:0]			oRD_DATA,
		output					oRD_EMPTY
	);
				

	//Full
	wire	[D_N:0]			full_count;
	wire					full;
	wire	[D_N:0]			empty_count;
	wire					empty;
	//Memory
	reg		[N-1:0]			b_memory[0:DEPTH-1];
	//Counter
	reg		[D_N:0]			b_wr_counter/* synthesis preserve = 1 */;		//Altera QuartusII Option
	reg		[D_N:0]			b_rd_counter/* synthesis preserve = 1 */;		//Altera QuartusII Option
	wire	[D_N:0]			gray_d_fifo_rd_counter;
	wire	[D_N:0]			binary_d_fifo_rd_counter;
	wire	[D_N:0]			gray_d_fifo_wr_counter;
	wire	[D_N:0]			binary_d_fifo_wr_counter;
	
	
	//Assign
	assign				full_count			=		b_wr_counter - binary_d_fifo_rd_counter;
	assign				full				=		full_count[D_N] || (full_count[D_N-1:0] == {D_N{1'b1}})? 1'b1 : 1'b0;
	//Empty
	assign				empty_count			=		binary_d_fifo_wr_counter - (b_rd_counter/* + {{D_N{1'b0}}, 1'b1}*/);	
	assign				empty				=		(empty_count == {D_N+1{1'b0}})? 1'b1 : 1'b0;
	/***************************************************
	Memory
	***************************************************/	
	//Write
	always@(posedge iWR_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_wr_counter						<=		{D_N+1{1'b0}};
		end
		else if(iREMOVE)begin
			b_wr_counter						<=		{D_N+1{1'b0}};
		end
		else begin
			if(iWR_EN && !full)begin
				b_memory[b_wr_counter[D_N-1:0]]		<=		iWR_DATA;
				b_wr_counter						<=		b_wr_counter + {{D_N-1{1'b0}}, 1'b1};
			end
		end
	end
	
	//Read Pointer
	always@(posedge iRD_CLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_rd_counter						<=		{D_N+1{1'b0}};
		end
		else if(iREMOVE)begin
			b_rd_counter						<=		{D_N+1{1'b0}};
		end
		else begin
			if(iRD_EN && !empty)begin
				b_rd_counter						<=		b_rd_counter + {{D_N-1{1'b0}}, 1'b1};
			end
		end
	end
	
	
	/***************************************************
	Counter Buffer
	***************************************************/	
	double_fifo #(D_N+1) D_FIFO_READ(
		.iCLOCK(iWR_CLOCK),
		.inRESET(inRESET),
		.iREQ_DATA(bin2gray(b_rd_counter)),
		.oOUT_DATA(gray_d_fifo_rd_counter)
	);
	assign					binary_d_fifo_rd_counter	=	gray2bin(gray_d_fifo_rd_counter);
	
	
	double_fifo #(D_N+1) D_FIFO_WRITE(
		.iCLOCK(iRD_CLOCK),
		.inRESET(inRESET),
		.iREQ_DATA(bin2gray(b_wr_counter)),
		.oOUT_DATA(gray_d_fifo_wr_counter)
	);
	assign					binary_d_fifo_wr_counter	=	gray2bin(gray_d_fifo_wr_counter);
	
	/***************************************************
	Function
	***************************************************/
	function [D_N:0] bin2gray;
		input		[D_N:0]		binary;
		begin
			bin2gray		=	binary ^ (binary >> 1'b1);
		end
	endfunction
	

	function[D_N:0] gray2bin(input[D_N:0] gray);
		integer i;
		for(i=D_N; i>=0; i=i-1)begin
			if(i==D_N)begin
				gray2bin[i] = gray[i];
			end
			else begin
				gray2bin[i] = gray[i] ^ gray2bin[i+1];
			end
		end
	endfunction
	
	
	/***************************************************
	Output Assign
	***************************************************/	
	assign				oWR_FULL			=		full;
	assign				oRD_EMPTY			=		empty;
	assign				oRD_DATA			=		b_memory[b_rd_counter[D_N-1:0]];
	
	
				
endmodule



module double_fifo
	#(
		parameter		N		=	1
	)(
		input				iCLOCK,
		input				inRESET,
		//Input
		input	[N-1:0]		iREQ_DATA,
		//Output
		output	[N-1:0]		oOUT_DATA
	);
	
	
	reg		[N-1:0]		b_data0/* synthesis preserve = 1 */;		//Altera QuartusII Option
	reg		[N-1:0]		b_data1/* synthesis preserve = 1 */;		//Altera QuartusII Option
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_data0		<=		{N{1'b0}};
			b_data1		<=		{N{1'b0}};
		end
		else begin
			b_data0		<=		iREQ_DATA;
			b_data1		<=		b_data0;
		end
	end
	
	assign				oOUT_DATA		=		b_data1;
	
	
endmodule



`default_nettype wire

	


















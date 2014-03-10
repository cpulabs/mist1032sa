
`default_nettype none


module mist1032sa_arbiter_matching_queue #(
		//Queue Deap
		parameter D = 8,
		//Queue Deap_N
		parameter DN = 3,
		//Queue Flag_N
		parameter FN = 1	
	)(
		input wire iCLOCK,
		input wire inRESET,
		//Flash
		input wire iFLASH,
		//Write
		input wire iWR_REQ,
		input wire [FN-1:0] iWR_FLAG,
		output wire oWR_FULL,
		//Read
		input wire iRD_REQ,
		output wire oRD_VALID,
		output wire [FN-1:0] oRD_FLAG,
		output wire oRD_EMPTY
	);
	
	
	/***********************************************************
	Control
	***********************************************************/
	wire full_flag;
	wire empty_flag;
	wire [DN:0] count;
	
	reg [DN:0] wr_counter;
	reg [DN:0] rd_counter;
	reg queue_valid[0:D-1];
	reg [FN-1:0] queue_type[0:D-1];
	
	integer i;
	
	
	assign full_flag = count[DN];
	assign empty_flag = (wr_counter == rd_counter)? 1'b1 : 1'b0;
	assign count = wr_counter - rd_counter;
	
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			wr_counter <= {DN+1{1'b0}};
			rd_counter <= {DN+1{1'b0}};
			//Flag Clear
			for(i = 0; i < D; i = i + 1)begin
				queue_valid[i] <= 1'b0;
			end
		end
		else begin
			if(iFLASH)begin
				//Flag Clear
				for(i = 0; i < D; i = i + 1)begin
					queue_valid[i] <= 1'b0;
				end
			end
			//Prev -> Next
			if(!full_flag && iWR_REQ)begin
				wr_counter <= wr_counter + {{DN{1'b0}}, 1'b1};
				queue_valid[wr_counter[DN-1:0]] <= 1'b1;
				queue_type[wr_counter[DN-1:0]] <= iWR_FLAG;
			end
			//Next -> Data
			if(!empty_flag && iRD_REQ)begin
				rd_counter <= rd_counter + {{DN{1'b0}}, 1'b1};
				queue_valid[rd_counter[DN-1:0]] <= 1'b0;
			end
		end
	end
	
	/***********************************************************
	Output Assign
	***********************************************************/
	assign oWR_FULL = full_flag;
	assign oRD_VALID = queue_valid[rd_counter[DN-1:0]] && !iFLASH;
	assign oRD_FLAG = queue_type[rd_counter[DN-1:0]];
	assign oRD_EMPTY = empty_flag;
	
	
endmodule


`default_nettype wire



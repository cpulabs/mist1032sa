

`default_nettype none

module scheduler2_gr
	#(
		parameter ENTRY_ID = 6'h00
	)(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Remove
		input wire iFREE_RESTART,
		//Commit_Vector
		input wire [63:0] iCOMMIT_VECTOR,				
		//Regist
		input wire iREGIST_0_VALID,
		input wire [5:0] iREGIST_0_DESTINATION_REGNAME,
		input wire [4:0] iREGIST_0_LOGIC_DESTINATION,
		input wire [5:0] iREGIST_0_COMMIT_TAG,		
		input wire iREGIST_1_VALID,
		input wire [5:0] iREGIST_1_DESTINATION_REGNAME,
		input wire [4:0] iREGIST_1_LOGIC_DESTINATION,
		input wire [5:0] iREGIST_1_COMMIT_TAG,		
		//EXEEND
		input wire iEXEND_ADDER_VALID,
		input wire [5:0] iEXEND_ADDER_COMMIT_TAG,
		input wire [5:0] iEXEND_ADDER_REGNAME,
		input wire [31:0] iEXEND_ADDER_DATA,
		input wire iEXEND_MULDIV_VALID,
		input wire [5:0] iEXEND_MULDIV_COMMIT_TAG,
		input wire [5:0] iEXEND_MULDIV_REGNAME,
		input wire [31:0] iEXEND_MULDIV_DATA,
		input wire iEXEND_LDST_VALID,
		input wire [5:0] iEXEND_LDST_COMMIT_TAG,
		input wire [5:0] iEXEND_LDST_REGNAME,
		input wire [31:0] iEXEND_LDST_DATA,
		//Free List Valid
		input wire iFREELIST_REGIST_VALID,
		//INFO
		output wire oINFO_FREELIST_REQ,
		output wire oINFO_DATA_VALID,
		output wire [31:0] oINFO_DATA
	);
	
	localparam PL_MAIN_STT_RESET = 2'h0;
	localparam PL_MAIN_STT_INIT = 2'h1;
	localparam PL_MAIN_STT_FREELIST = 2'h2;
	localparam PL_MAIN_STT_RESERVE = 2'h3;
	
	reg [1:0] b_main_state;
		
	//Cuurent Entry
	reg b_entry_valid;
	reg [5:0] b_entry_commit_tag;
	reg [4:0] b_entry_logic_dest;
	reg b_entry_exe_end;
	reg [31:0] b_entry_exe_data;
	reg b_entry_exe_commit;
	//Next Entry
	reg b_next_entry_valid;
	reg [5:0] b_next_entry_commit_tag;
	reg b_next_entry_exe_end;
	reg b_next_exe_commit;
	
	wire init_physical_register = ENTRY_ID < 32;

	wire pipe0_cuur_entry_register_condition = iREGIST_0_VALID && (iREGIST_0_DESTINATION_REGNAME == ENTRY_ID);// && (b_main_state == PL_MAIN_STT_RESERVE);
	wire pipe1_cuur_entry_register_condition = iREGIST_1_VALID && (iREGIST_1_DESTINATION_REGNAME == ENTRY_ID);// && (b_main_state == PL_MAIN_STT_RESERVE);
	wire pipe0_next_entry_register_condition = iREGIST_0_VALID && b_entry_valid && (iREGIST_0_LOGIC_DESTINATION == b_entry_logic_dest);
	wire pipe1_next_entry_register_condition = (iREGIST_1_VALID && b_entry_valid && (iREGIST_1_LOGIC_DESTINATION == b_entry_logic_dest)) || 
		(pipe0_cuur_entry_register_condition && iREGIST_1_VALID && (iREGIST_0_LOGIC_DESTINATION == iREGIST_1_LOGIC_DESTINATION));
	
	wire freelist_req_condition = (b_main_state == PL_MAIN_STT_FREELIST);
	
	wire cuur_commit_reset = freelist_req_condition;
	wire cuur_entry_reset = freelist_req_condition || (iFREE_RESTART && (b_main_state == PL_MAIN_STT_RESERVE) && !b_entry_exe_commit);
	wire cuur_exe_end_reset = freelist_req_condition || (iFREE_RESTART && (b_main_state == PL_MAIN_STT_RESERVE) && !b_entry_exe_commit);
	wire next_commit_reset = freelist_req_condition;
	wire next_entry_reset = freelist_req_condition || (iFREE_RESTART && (b_main_state == PL_MAIN_STT_RESERVE || b_main_state == PL_MAIN_STT_INIT) && !b_next_exe_commit);
	wire next_exe_end_reset = freelist_req_condition || (iFREE_RESTART && (b_main_state == PL_MAIN_STT_RESERVE || b_main_state == PL_MAIN_STT_INIT) && !b_next_exe_commit);
	
	//init_physical_register && (b_main_state == PL_MAIN_STT_INIT);
	
	/*****************************************************
	Main State
	*****************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_main_state <= PL_MAIN_STT_RESET;
		end
		else begin
			case(b_main_state)
				PL_MAIN_STT_RESET:
					begin
						if(init_physical_register)begin
							b_main_state <= PL_MAIN_STT_INIT;
						end
						else begin
							b_main_state <= PL_MAIN_STT_FREELIST;
						end
					end
				PL_MAIN_STT_INIT:
					begin
						if(b_next_entry_exe_end && b_next_exe_commit)begin
							b_main_state <= PL_MAIN_STT_FREELIST;
						end
					end
				PL_MAIN_STT_FREELIST:
					begin
						if(iFREELIST_REGIST_VALID && !iFREE_RESTART)begin
							b_main_state <= PL_MAIN_STT_RESERVE;
						end
					end
				PL_MAIN_STT_RESERVE:
					begin
						if((/*b_entry_valid && b_entry_exe_end && b_entry_exe_data && b_next_entry_valid && b_next_entry_exe_end && b_next_exe_commit*/b_entry_exe_commit && b_next_exe_commit) || 
							(iFREE_RESTART && !b_entry_exe_commit))
						begin
							b_main_state <= PL_MAIN_STT_FREELIST;
						end
					end
			endcase
		end
	end
	
	/*****************************************************
	Current Entry
	*****************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_entry_valid <= 1'b0;
			b_entry_commit_tag <= 6'h0;
			b_entry_logic_dest <= 5'h0;
		end
		else if(cuur_entry_reset)begin
			b_entry_valid <= 1'b0;
			b_entry_commit_tag <= 6'h0;
			b_entry_logic_dest <= 5'h0;
		end
		else begin
			if(init_physical_register && b_main_state == PL_MAIN_STT_INIT)begin
				b_entry_valid <= 1'b1;
				b_entry_commit_tag <= 6'h0;
				b_entry_logic_dest <= ENTRY_ID;
			end
			else if(pipe0_cuur_entry_register_condition)begin
				b_entry_valid <= 1'b1;
				b_entry_commit_tag <= iREGIST_0_COMMIT_TAG;
				b_entry_logic_dest <= iREGIST_0_LOGIC_DESTINATION;
			end
			else if(pipe1_cuur_entry_register_condition)begin
				b_entry_valid <= 1'b1;
				b_entry_commit_tag <= iREGIST_1_COMMIT_TAG;
				b_entry_logic_dest <= iREGIST_1_LOGIC_DESTINATION;
			end
		end
	end
	
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_entry_exe_end <= 1'b0;
			b_entry_exe_data <= 32'h0;
		end
		else if(cuur_exe_end_reset)begin
			b_entry_exe_end <= 1'b0;
			b_entry_exe_data <= 32'h0;
		end
		else begin
			if(!b_entry_exe_end && b_entry_valid)begin
				if(init_physical_register && b_main_state == PL_MAIN_STT_INIT)begin
					b_entry_exe_end <= 1'b1;
					b_entry_exe_data <= 32'h0;
				end
				else if(iEXEND_ADDER_VALID && b_entry_commit_tag == iEXEND_ADDER_COMMIT_TAG)begin
					b_entry_exe_end <= 1'b1;
					b_entry_exe_data <= iEXEND_ADDER_DATA;
				end
				else if(iEXEND_MULDIV_VALID && b_entry_commit_tag == iEXEND_MULDIV_COMMIT_TAG)begin
					b_entry_exe_end <= 1'b1;
					b_entry_exe_data <= iEXEND_MULDIV_DATA;
				end
				else if(iEXEND_LDST_VALID && b_entry_commit_tag == iEXEND_LDST_COMMIT_TAG)begin
					b_entry_exe_end <= 1'b1;
					b_entry_exe_data <= iEXEND_LDST_DATA;
				end
			end
		end
	end
	
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_entry_exe_commit <= 1'b0;
		end
		else if(cuur_commit_reset)begin
			b_entry_exe_commit <= 1'b0;
		end
		else begin	
			if(b_entry_valid && b_entry_exe_end && !b_entry_exe_commit)begin
				b_entry_exe_commit <= iCOMMIT_VECTOR[b_entry_commit_tag];
			end
		end
	end
	
	
	
	/*****************************************************
	Next Entry
	*****************************************************/
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_next_entry_valid <= 1'b0;
			b_next_entry_commit_tag <= 6'h0;
		end
		else if(next_entry_reset)begin
			b_next_entry_valid <= 1'b0;
			b_next_entry_commit_tag <= 6'h0;
		end
		else begin
			if(pipe0_next_entry_register_condition)begin
				b_next_entry_valid <= 1'b1;
				b_next_entry_commit_tag <= iREGIST_0_COMMIT_TAG;
			end
			else if(pipe1_next_entry_register_condition)begin
				b_next_entry_valid <= 1'b1;
				b_next_entry_commit_tag <= iREGIST_1_COMMIT_TAG;
			end
		end
	end
	
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_next_entry_exe_end <= 1'b0;
		end
		else if(next_exe_end_reset)begin
			b_next_entry_exe_end <= 1'b0;
		end
		else begin
			if(b_next_entry_valid && iEXEND_ADDER_VALID && b_next_entry_commit_tag == iEXEND_ADDER_COMMIT_TAG)begin
				b_next_entry_exe_end <= 1'b1;
			end
			else if(b_next_entry_valid && iEXEND_MULDIV_VALID && b_next_entry_commit_tag == iEXEND_MULDIV_COMMIT_TAG)begin
				b_next_entry_exe_end <= 1'b1;
			end
			else if(b_next_entry_valid && iEXEND_LDST_VALID && b_next_entry_commit_tag == iEXEND_LDST_COMMIT_TAG)begin
				b_next_entry_exe_end <= 1'b1;
			end
		end
	end
	
	always@(posedge iCLOCK or negedge inRESET)begin	
		if(!inRESET)begin
			b_next_exe_commit <= 1'b0;
		end
		else if(next_commit_reset)begin
			b_next_exe_commit <= 1'b0;
		end
		else begin	
			if(b_next_entry_valid && b_next_entry_exe_end && !b_next_exe_commit)begin
				b_next_exe_commit <= iCOMMIT_VECTOR[b_next_entry_commit_tag];
			end
		end
	end
	
	
	//Module Output
	assign oINFO_FREELIST_REQ = (b_main_state == PL_MAIN_STT_FREELIST) && !iFREE_RESTART;
	assign oINFO_DATA_VALID = b_entry_exe_end && !b_next_entry_exe_end;
	assign oINFO_DATA = b_entry_exe_data;
	
	
endmodule
		

`default_nettype wire


		



`default_nettype none

module general_register_entry
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
	
	
	reg [2:0] b_state;
	reg b_freelist_req;	
	reg [4:0] b_logic_destination;
	reg b_data_valid;
	reg [31:0] b_data;	
	reg [5:0] b_commit_tag;
	reg b_commit_valid;
	reg b_after_commit_tag_valid;	
	reg [5:0] b_after_commit_tag;			
	reg b_after_commit_valid;			

	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state <= 3'h0;		
			b_freelist_req <= 1'b0;
			b_logic_destination <= {5{1'b0}};
			b_data_valid <= 1'b0;
			b_data <= {32{1'b0}};
			b_commit_tag <= {6{1'b0}};
			b_commit_valid <= 1'b0;
			b_after_commit_tag_valid <= 1'b0;
			b_after_commit_tag <= {6{1'b0}};
			b_after_commit_valid <= 1'b0;
		end
		//Rall Back
		else if(iFREE_RESTART)begin
			if(b_state == 3'h0)begin
				b_state <= 3'h0;		
				b_freelist_req <= 1'b0;
				b_logic_destination <= {5{1'b0}};
				b_data_valid <= 1'b0;
				b_data <= {32{1'b0}};
				b_commit_tag <= {6{1'b0}};
				b_commit_valid <= 1'b0;
				b_after_commit_tag_valid <= 1'b0;
				b_after_commit_tag <= {6{1'b0}};
				b_after_commit_valid <= 1'b0;
			end
			else if(b_state == 3'h1 || b_state == 3'h2 || b_state == 3'h3)begin
				b_state <= 3'h2;		
				b_freelist_req <= 1'b1;
				b_logic_destination <= {5{1'b0}};
				b_data_valid <= 1'b0;
				b_data <= {32{1'b0}};
				b_commit_tag <= {6{1'b0}};
				b_commit_valid <= 1'b0;
				b_after_commit_tag_valid <= 1'b0;
				b_after_commit_tag <= {6{1'b0}};
				b_after_commit_valid <= 1'b0;
			end
			else if(b_state == 3'h4)begin
				if(!b_commit_valid)begin	
					b_state <= 3'h2;		
					b_freelist_req <= 1'b1;
					b_logic_destination <= {5{1'b0}};
					b_data_valid <= 1'b0;
					b_data <= {32{1'b0}};
					b_commit_tag <= {6{1'b0}};
					b_commit_valid <= 1'b0;
					b_after_commit_tag_valid <= 1'b0;
					b_after_commit_tag <= {6{1'b0}};
					b_after_commit_valid <= 1'b0;
				end
				else if(!b_after_commit_valid)begin
					b_after_commit_tag_valid <= 1'b0;
					b_after_commit_tag <= {6{1'b0}};
					b_after_commit_valid <= 1'b0;
				end
			end
		end
		//Normal
		else begin
			case(b_state)
				3'h0 :		//(Reset)Free List Regist Wait
					begin	
						if(ENTRY_ID < 6'd32)begin
							if(iREGIST_0_VALID && ENTRY_ID[4:0] == iREGIST_0_LOGIC_DESTINATION || iREGIST_1_VALID && ENTRY_ID[4:0] == iREGIST_1_LOGIC_DESTINATION)begin
								b_state <= 3'h1;
								b_freelist_req <= 1'b1;
								b_data_valid <= 1'b0;
							end
							else begin
								b_freelist_req <= 1'b0;
								b_data_valid <= 1'b1;
							end
						end
						else begin
							b_state <= 3'h1;
							b_freelist_req <= 1'b1;
							b_data_valid <= 1'b0;
						end
					end
				3'h1 :		//(Reset)Register Regist Wait
					begin
						if(iFREELIST_REGIST_VALID)begin
							b_state <= 3'h3;
							b_freelist_req <= 1'b0;
						end
						else begin
							b_freelist_req <= 1'b1;
							b_data_valid <= 1'b0;
						end
					end
				3'h2 :		//Free List Regist Wait
					begin	
						if(iFREELIST_REGIST_VALID)begin
							b_state <= 3'h3;
							b_freelist_req <= 1'b0;
							b_data_valid <= 1'b0;	
						end
						else begin
							b_freelist_req <= 1'b1;
							b_data_valid <= 1'b0;	
						end
					end
				3'h3 :		//Register Regist Wait
					begin
						if(iREGIST_0_VALID & iREGIST_0_DESTINATION_REGNAME == ENTRY_ID)begin
							b_state <= 3'h4;
							b_logic_destination <= iREGIST_0_LOGIC_DESTINATION;
							b_data_valid <= 1'b0;	
							if(iREGIST_0_LOGIC_DESTINATION == iREGIST_1_LOGIC_DESTINATION & iREGIST_0_VALID & iREGIST_1_VALID)begin
								b_after_commit_tag_valid <= 1'b1;
								b_after_commit_tag <= iREGIST_1_COMMIT_TAG;
							end
							else begin
								b_after_commit_tag_valid <= 1'b0;
								b_after_commit_tag <= {6{1'b0}};
							end
							b_commit_valid <= 1'b0;
							b_commit_tag <= iREGIST_0_COMMIT_TAG;
							b_after_commit_valid <= 1'b0;
							//Backup
							//b_regist_logic_destination <= iREGIST_0_LOGIC_DESTINATION;
						end
						else if(iREGIST_1_VALID & iREGIST_1_DESTINATION_REGNAME == ENTRY_ID)begin
							b_state <= 3'h4;
							b_logic_destination <= iREGIST_1_LOGIC_DESTINATION;
							b_data_valid <= 1'b0;	
							b_commit_valid <= 1'b0;
							b_commit_tag <= iREGIST_1_COMMIT_TAG;
							b_after_commit_tag_valid <= 1'b0;
							b_after_commit_tag <= {6{1'b0}};
							b_after_commit_valid <= 1'b0;
							//Backup
							//b_regist_logic_destination <= iREGIST_1_LOGIC_DESTINATION;
						end
						else begin
							b_data_valid <= 1'b0;	
						end
					end
				default : 
					begin	
						if(!(b_after_commit_tag_valid && b_after_commit_valid && b_data_valid && b_commit_valid))begin		//Register Remove Condition Check

							
							//Check After Execution Logic Destination Matching Regist(Re Order Register File Contrall - Phase1)
							if(!b_after_commit_tag_valid)begin
								if(iREGIST_0_VALID && (iREGIST_0_LOGIC_DESTINATION == b_logic_destination))begin
									b_after_commit_tag_valid <= 1'b1;
									b_after_commit_tag <= iREGIST_0_COMMIT_TAG;
								end
								else if(iREGIST_1_VALID && (iREGIST_1_LOGIC_DESTINATION == b_logic_destination))begin
									b_after_commit_tag_valid <= 1'b1;
									b_after_commit_tag <= iREGIST_1_COMMIT_TAG;
								end
							end
							//Check After Execution Commit Tag Matching(Re Order Register File Contrall - Phase2)
							if(b_after_commit_tag_valid && iCOMMIT_VECTOR[b_after_commit_tag])begin
								b_after_commit_valid <= 1'b1;
							end
							
							//Check Execution Writeback
							if(!b_data_valid)begin
								if(iEXEND_ADDER_VALID && (b_commit_tag == iEXEND_ADDER_COMMIT_TAG))begin
									b_data <= iEXEND_ADDER_DATA;
									b_data_valid <= 1'b1;
								end
								else if(iEXEND_MULDIV_VALID && (b_commit_tag == iEXEND_MULDIV_COMMIT_TAG))begin
									b_data <= iEXEND_MULDIV_DATA;
									b_data_valid <= 1'b1;
								end
								else if(iEXEND_LDST_VALID && (b_commit_tag == iEXEND_LDST_COMMIT_TAG))begin
									b_data <= iEXEND_LDST_DATA;
									b_data_valid <= 1'b1;
								end
							end
							
							//Check Commit
							if(iCOMMIT_VECTOR[b_commit_tag] == 1'b1)begin
								b_commit_valid <= 1'b1;
							end
						end
						else begin		//Register Remove(Freelist Request)
							b_state <= 3'h2;
							b_freelist_req <= 1'b1;
						end
					end
			endcase
		end
	end //always
	
	//Module Output
	assign oINFO_FREELIST_REQ = b_freelist_req && !iFREE_RESTART;
	assign oINFO_DATA_VALID = b_data_valid && !b_after_commit_valid;
	assign oINFO_DATA = b_data;
	
	
endmodule
		

`default_nettype wire


		


`default_nettype none

module register_renaming_table　#(
		parameter	ENTRY_ID		=		5'h00
	)(
		//System
		input wire iCLOCK,
		input wire inRESET,
		//Restart
		input wire iRESTART_VALID,	
		//Rolback Point
		input wire iROLLBACK_UPDATE_CANDIDATE0_VALID,			//new						2012/01/24
		input wire [4:0] iROLLBACK_UPDATE_CANDIDATE0_LREGNAME,		//new						2012/01/24
		input wire [5:0] iROLLBACK_UPDATE_CANDIDATE0_PREGNAME,		//new						2012/01/24
		input wire iROLLBACK_UPDATE_CANDIDATE1_VALID,			//new						2012/01/24
		input wire [4:0] iROLLBACK_UPDATE_CANDIDATE1_LREGNAME,		//new						2012/01/24
		input wire [5:0] iROLLBACK_UPDATE_CANDIDATE1_PREGNAME,		//new						2012/01/24
		input wire iROLLBACK_UPDATE_CANDIDATE2_VALID,			//new						2012/01/24
		input wire [4:0] iROLLBACK_UPDATE_CANDIDATE2_LREGNAME,		//new						2012/01/24
		input wire [5:0] iROLLBACK_UPDATE_CANDIDATE2_PREGNAME,		//new						2012/01/24
		input wire iROLLBACK_UPDATE_CANDIDATE3_VALID,			//new						2012/01/24
		input wire [4:0] iROLLBACK_UPDATE_CANDIDATE3_LREGNAME,		//new						2012/01/24
		input wire [5:0] iROLLBACK_UPDATE_CANDIDATE3_PREGNAME,		//new						2012/01/24
		//input wire [5:0] iRESTART_REGNAME,			2012/01/24
		//Lock
		input wire iLOCK,
		//Regist
		input wire iREGIST_0_VALID,
		input wire [4:0] iREGIST_0_LOGIC_DESTINATION,
		input wire [5:0] iREGIST_0_REGNAME,
		input wire iREGIST_1_VALID,
		input wire [4:0] iREGIST_1_LOGIC_DESTINATION,
		input wire [5:0] iREGIST_1_REGNAME,
		//Info
		output wire oINFO_VALID,
		output wire [5:0] oINFO_REGNAME,
		output wire [5:0] oINFO_OLD_REGNAME
	);

	reg b_state;
	reg b_valid;				
	reg [5:0] b_regname;
	reg [5:0] bb_regname;
	reg [5:0] b_rollback_point;
	


	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state <= 1'b0;
			b_valid <= 1'b0;
			b_regname <= {6{1'b0}};
			bb_regname <= {6{1'b0}};
			b_rollback_point <= {6{1'b0}};
		end			
		else begin
			case(b_state)
				1'b0 :	
					begin
						b_state <= 1'b1;
						b_regname <= {1'b0, ENTRY_ID[4:0]};
						bb_regname <= {1'b0, ENTRY_ID[4:0]};
						b_rollback_point <= {1'b0, ENTRY_ID[4:0]};
					end
				default :
					begin
						//Rollback!
						if(iRESTART_VALID)begin			
							if(iROLLBACK_UPDATE_CANDIDATE3_VALID && iROLLBACK_UPDATE_CANDIDATE3_LREGNAME == ENTRY_ID[4:0])begin	
								b_regname <= iROLLBACK_UPDATE_CANDIDATE3_PREGNAME;
								bb_regname <= iROLLBACK_UPDATE_CANDIDATE3_PREGNAME;
							end
							else if(iROLLBACK_UPDATE_CANDIDATE2_VALID && iROLLBACK_UPDATE_CANDIDATE2_LREGNAME == ENTRY_ID[4:0])begin	
								b_regname <= iROLLBACK_UPDATE_CANDIDATE2_PREGNAME;
								bb_regname <= iROLLBACK_UPDATE_CANDIDATE2_PREGNAME;
							end
							else if(iROLLBACK_UPDATE_CANDIDATE1_VALID && iROLLBACK_UPDATE_CANDIDATE1_LREGNAME == ENTRY_ID[4:0])begin	
								b_regname <= iROLLBACK_UPDATE_CANDIDATE1_PREGNAME;
								bb_regname <= iROLLBACK_UPDATE_CANDIDATE1_PREGNAME;
							end
							else if(iROLLBACK_UPDATE_CANDIDATE0_VALID && iROLLBACK_UPDATE_CANDIDATE0_LREGNAME == ENTRY_ID[4:0])begin	
								b_regname <= iROLLBACK_UPDATE_CANDIDATE0_PREGNAME;
								bb_regname <= iROLLBACK_UPDATE_CANDIDATE0_PREGNAME;
							end
							else begin
								b_regname <= b_rollback_point;
								bb_regname <= b_rollback_point;
							end
						end
						//Rollback Regname Update - 2012/01/24
						if(iROLLBACK_UPDATE_CANDIDATE3_VALID && iROLLBACK_UPDATE_CANDIDATE3_LREGNAME == ENTRY_ID[4:0])begin	
							b_rollback_point <= iROLLBACK_UPDATE_CANDIDATE3_PREGNAME;
						end
						else if(iROLLBACK_UPDATE_CANDIDATE2_VALID && iROLLBACK_UPDATE_CANDIDATE2_LREGNAME == ENTRY_ID[4:0])begin	
							b_rollback_point <= iROLLBACK_UPDATE_CANDIDATE2_PREGNAME;
						end
						else if(iROLLBACK_UPDATE_CANDIDATE1_VALID && iROLLBACK_UPDATE_CANDIDATE1_LREGNAME == ENTRY_ID[4:0])begin	
							b_rollback_point <= iROLLBACK_UPDATE_CANDIDATE1_PREGNAME;
						end
						else if(iROLLBACK_UPDATE_CANDIDATE0_VALID && iROLLBACK_UPDATE_CANDIDATE0_LREGNAME == ENTRY_ID[4:0])begin	
							b_rollback_point <= iROLLBACK_UPDATE_CANDIDATE0_PREGNAME;
						end
						//Now Register Pointer Update
						/*if(iRESTART_VALID)begin
							b_regname	 <= iRESTART_REGNAME;
							bb_regname	 <= iRESTART_REGNAME;
						end
						else */
						//Normal State - Rename Table Update
						if(!iLOCK)begin
							bb_regname <= b_regname;
							if(iREGIST_1_VALID && ENTRY_ID[4:0] == iREGIST_1_LOGIC_DESTINATION)begin
								b_valid <= 1'b1;
								b_regname <= iREGIST_1_REGNAME;
							end
							else if(iREGIST_0_VALID && ENTRY_ID[4:0] == iREGIST_0_LOGIC_DESTINATION)begin
								b_valid <= 1'b1;
								b_regname <= iREGIST_0_REGNAME;
							end
						end
					end
			endcase
		end
	end //always
	
	
	//Assign
	assign oINFO_VALID = b_valid;
	assign oINFO_REGNAME = b_regname;
	assign oINFO_OLD_REGNAME = bb_regname;
	
endmodule

`default_nettype wire


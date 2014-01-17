`default_nettype none

module comparator_counter(
		input wire iCLOCK,
		input wire inRESET,
		//Main Counter
		input wire iMTIMER_WORKING,
		input wire [63:0] iMTIMER_COUNT,
		//Timmer Settings
		input wire iCONF_WRITE,
		input wire iCONF_ENA,
		input wire iCONF_IRQENA,
		input wire iCONF_64MODE,
		input wire iCONF_PERIODIC,			//Non Periodic mode = 0 | Periodic mode = 1
		//Counter
		input wire iCOUNT_WRITE,
		input wire [1:0] inCOUNT_DQM,
		input wire [63:0] iCOUNT_COUNTER,
		//Interrupt
		output wire oIRQ
	);
		
	reg enable;
	reg irqena;
	reg [63:0] ini_counter;
	reg [63:0] counter;
	reg bitmode;
	reg periodic;
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			enable <= 1'b0;
			irqena <= 1'b0;
			ini_counter <= 64'h0;
			counter <= 64'h0;
			bitmode <= 1'b0;
			periodic <= 1'b0;
		end
		else begin
			///Counter Setting
			if(iCONF_WRITE)begin
				enable <= iCONF_ENA;
				irqena <= iCONF_IRQENA;
				bitmode <= iCONF_64MODE;
				periodic <= iCONF_PERIODIC;
				//Counter Write
				if(iCOUNT_WRITE)begin
					ini_counter[31:0] <= (!inCOUNT_DQM[0])? iCOUNT_COUNTER[31:0] : ini_counter[31:0];
					ini_counter[63:32] <= (!inCOUNT_DQM[1])? iCOUNT_COUNTER[63:32] : ini_counter[63:32];
					counter[31:0] <= (!inCOUNT_DQM[0])? iCOUNT_COUNTER[31:0] : ini_counter[31:0];
					counter[63:32] <= (!inCOUNT_DQM[1])? iCOUNT_COUNTER[63:32] : ini_counter[63:32];
				end
			end
			else begin
				//Counter Write
				if(iCOUNT_WRITE)begin
					ini_counter[31:0] <= (!inCOUNT_DQM[0])? iCOUNT_COUNTER[31:0] : ini_counter[31:0];
					ini_counter[63:32] <= (!inCOUNT_DQM[1])? iCOUNT_COUNTER[63:32] : ini_counter[63:32];
					counter[31:0] <= (!inCOUNT_DQM[0])? iCOUNT_COUNTER[31:0] : ini_counter[31:0];
					counter[63:32] <= (!inCOUNT_DQM[1])? iCOUNT_COUNTER[63:32] : ini_counter[63:32];
				end
				else if(enable)begin
					if(periodic)begin
						if(bitmode)begin
							//64bit Mode
							if(counter == iMTIMER_COUNT)begin
								counter <= counter + ini_counter;
							end
						end
						else begin
							//32bit Mode
							if(counter[31:0] == iMTIMER_COUNT[31:0])begin
								counter <= counter + ini_counter;
							end
						end
					end
				end
			end
		end
	end
	
	assign oIRQ = irqena && iMTIMER_WORKING && (bitmode)? (counter == iMTIMER_COUNT && ini_counter != 64'h0) : (counter[31:0] == iMTIMER_COUNT[31:0] && ini_counter[31:0] != 32'h0);
	
endmodule

`default_nettype wire


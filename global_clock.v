
`include "sim_global.h"
`default_nettype none



module global_lock(
		input			iCLOCK_50,			//50MHz
		output			oCORE_CLOCK,		//55MHz
		output			oDPS_CLOCK,			//49.1520MHz
		output			oBUS_CLOCK,			//50MHz
		output			oDISP_CLOCK			//25.2MHz
	);
	
	generate
		if(`CLK_DEBUGMODE)begin		
			reg		core_clock, dps_clock, bus_clock, disp_clock;
			
			initial begin
				#0 begin
					core_clock	=	1'b0;
					dps_clock	=	1'b0;
					bus_clock	=	1'b0;
					disp_clock	=	1'b0;
				end
			end
			
			always#(33/2)begin
				core_clock	=	!core_clock;
			end
			
			always#(21/2)begin
				dps_clock	=	!dps_clock;
			end
			
			always#(20/2)begin
				bus_clock	=	!bus_clock;
			end
			
			always#(39/2)begin
				disp_clock	=	!disp_clock;
			end
			assign		oCORE_CLOCK		=		core_clock;
			assign		oDPS_CLOCK		=		dps_clock;
			assign		oBUS_CLOCK		=		bus_clock;
			assign		oDISP_CLOCK		=		disp_clock;	
			
		end
		else begin
			//Core CLock
			pll_core CLOCK_55MHZ(
				.areset(1'b0),
				.inclk0(iCLOCK_50),
				.c0(oCORE_CLOCK),
				.locked()
			);
			
			
			pll_dps CLOCK_49_152MHZ(
				.areset(1'b0),
				.inclk0(iCLOCK_50),
				.c0(oDPS_CLOCK),
				.locked()
			);
		
			//Display CLock
			pll_display CLOCK_25_2MHZ (
				.areset(1'b0),
				.inclk0(iCLOCK_50),
				.c0(oDISP_CLOCK)
			);
			
			assign		oBUS_CLOCK		=		iCLOCK_50;
		end
	endgenerate
	
	

	
endmodule


`default_nettype wire

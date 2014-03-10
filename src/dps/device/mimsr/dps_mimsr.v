


`default_nettype none

`define MIMSR_MEMORY_SIZE 32'h04000000


module dps_mimsr(
		input wire iCLOCK,
		//Reset
		input wire inRESET,
		//CPU Interface
		input wire iREQ_VALID,
		//input wire [31:0] iREQ_DATA,
		output wire oREQ_VALID,
		output wire [31:0] oREQ_DATA
	);
	
	reg b_ack_buffer_ack;
	reg [31:0] b_ack_buffer_data;
	
	
	//Request Ack
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ack_buffer_ack <= 1'b0;
		end
		else begin
			b_ack_buffer_ack <= iREQ_VALID;
		end
	end
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_ack_buffer_data <= 32'h0;
		end
		else begin
			b_ack_buffer_data <= `MIMSR_MEMORY_SIZE;
		end
	end
	
	assign oREQ_VALID = b_ack_buffer_ack;
	assign oREQ_DATA = b_ack_buffer_data;
	
	
endmodule


`default_nettype wire 

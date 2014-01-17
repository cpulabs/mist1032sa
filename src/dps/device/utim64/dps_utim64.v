


`default_nettype none

module dps_utim64(
		//System
		input wire iCLOCK,				//Global Clock
		input wire inRESET,
		//Timer Clock
		input wire iTIMER_CLOCK,
		//Counter
		input wire iREQ_VALID,
		output wire oREQ_BUSY,
		input wire iREQ_RW,
		input wire [4:0] iREQ_ADDR,
		input wire [31:0] iREQ_DATA,
		output wire oREQ_VALID,
		output wire [31:0] oREQ_DATA,
		//Interrupt
		output wire oIRQ_VALID,
		input wire iIRQ_ACK
	);

	wire [3:0] utim64a_irq;
	wire [3:0] utim64b_irq;
	reg [1:0] b_irq_state;
	reg [7:0] b_irq_flags;
	reg b_flag_buffer_valid;
	reg [7:0] b_flag_buffer_flags;
	
	
	wire utim64a_busy;
	wire utim64b_busy;
	wire utim64a_req_cc;
	wire utim64b_req_cc;
	wire utim64_flags_cc;
	assign utim64a_req_cc = !utim64a_busy && !utim64b_busy && iREQ_VALID && (iREQ_ADDR >= 5'h0 && iREQ_ADDR <= 5'he);
	assign utim64b_req_cc = !utim64a_busy && !utim64b_busy && iREQ_VALID && (iREQ_ADDR >= 5'h10 && iREQ_ADDR <= 5'h1e);
	assign utim64_flags_cc = !utim64a_busy && !utim64b_busy && iREQ_VALID && !iREQ_RW && (iREQ_ADDR == 5'h1f);
	
	wire utim64a_out_valid;
	wire utim64b_out_valid;
	wire [31:0] utim64a_out_data;
	wire [31:0] utim64b_out_data;
	
	
	
	/************************************
	Module Select State
	************************************/
	parameter L_PARAM_MAIN_STT_IDLE = 1'h0;
	parameter L_PARAM_MAIN_STT_RD_WAIT = 1'h1;

	reg [1:0] b_modsel;	//0:UTIM64A | 1:UTIM64B | 2:FLAGS
	reg b_state;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_state <= L_PARAM_MAIN_STT_IDLE;
			b_modsel <= 2'b00;
		end
		else begin
			case(b_state)
				L_PARAM_MAIN_STT_IDLE:
					begin
						if(!iREQ_RW)begin
							if(utim64a_req_cc)begin
								b_state <= L_PARAM_MAIN_STT_RD_WAIT;
								b_modsel <= 2'b00;
							end
							else if(utim64b_req_cc)begin
								b_state <= L_PARAM_MAIN_STT_RD_WAIT;
								b_modsel <= 2'b01;
							end
							else if(utim64_flags_cc)begin
								b_state <= L_PARAM_MAIN_STT_RD_WAIT;
								b_modsel <= 2'b10;
							end
						end
					end
				L_PARAM_MAIN_STT_RD_WAIT:
					begin
						if(utim64a_out_valid || utim64b_out_valid || b_flag_buffer_valid)begin
							b_state <= L_PARAM_MAIN_STT_IDLE;
						end
					end
			endcase
		end
	end
	
	
	/************************************
	Timer Module
	************************************/
	utim64 UTIM64A(
		//System
		.iIF_CLOCK(iCLOCK),
		.iTIMER_CLOCK(iTIMER_CLOCK),
		.inRESET(inRESET),
		//Counter
		.iREQ_VALID(utim64a_req_cc),
		.oREQ_BUSY(utim64a_busy),
		.iREQ_RW(iREQ_RW),
		.iREQ_ADDR(iREQ_ADDR[3:0]),
		.iREQ_DATA(iREQ_DATA),
		.oREQ_VALID(utim64a_out_valid),
		.oREQ_DATA(utim64a_out_data),
		//Interrupt
		.oIRQ_IRQ(utim64a_irq)
	);
	
	
	utim64 UTIM64B(
		//System
		.iIF_CLOCK(iCLOCK),
		.iTIMER_CLOCK(iTIMER_CLOCK),
		.inRESET(inRESET),
		//Counter
		.iREQ_VALID(utim64b_req_cc),
		.oREQ_BUSY(utim64b_busy),
		.iREQ_RW(iREQ_RW),
		.iREQ_ADDR({1'b0, iREQ_ADDR[2:0]}),
		.iREQ_DATA(iREQ_DATA),
		.oREQ_VALID(utim64b_out_valid),
		.oREQ_DATA(utim64b_out_data),
		//Interrupt
		.oIRQ_IRQ(utim64b_irq)
	);
	
	
	/************************************
	IRQ Flags
	************************************/
	parameter L_PARAM_IRQ_STT_IDLE = 2'h0;
	parameter L_PARAM_IRQ_STT_IRQ = 2'h1;
	parameter L_PARAM_IRQ_STT_FLAG = 2'h2;
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_irq_state <= L_PARAM_IRQ_STT_IDLE;
			b_irq_flags <= 8'h0;
		end
		else begin
			case(b_irq_state)
				L_PARAM_IRQ_STT_IDLE:
					begin
						if(|{utim64a_irq, utim64b_irq})begin
							b_irq_state <= L_PARAM_IRQ_STT_IRQ;
							b_irq_flags <= b_irq_flags | {utim64b_irq, utim64a_irq};
						end
						begin
							b_irq_flags <= b_irq_flags | {utim64b_irq, utim64a_irq};
						end
						
						
						/*
						if(|{utim64a_irq, utim64b_irq})begin
							b_irq_state <= L_PARAM_IRQ_STT_IRQ;
							if(utim64_flags_cc)begin
								b_irq_flags <= {utim64a_irq, utim64b_irq};
							end
							else begin
								b_irq_flags <= b_irq_flags | {utim64a_irq, utim64b_irq};
							end
						end
						else begin
							if(utim64_flags_cc)begin
								b_irq_flags <= 8'h00;
							end
							else begin
								b_irq_flags <= b_irq_flags;
							end
						end
						*/
					end
				L_PARAM_IRQ_STT_IRQ:
					begin
						if(iIRQ_ACK)begin
							b_irq_state <= L_PARAM_IRQ_STT_FLAG;
						end
						b_irq_flags <= b_irq_flags | {utim64b_irq, utim64a_irq};
						
						/*
						if(iIRQ_ACK)begin
							if(utim64_flags_cc)begin
								//Flag Load Condition
								b_irq_state <= (utim64a_irq || utim64b_irq)? L_PARAM_IRQ_STT_IRQ : L_PARAM_IRQ_STT_IDLE;
								b_irq_flags <= (utim64a_irq || utim64b_irq)? {utim64a_irq, utim64b_irq} : 8'h00;
							end
							else begin
								//Not Flag Load Condition
								b_irq_state <= (utim64a_irq || utim64b_irq)? L_PARAM_IRQ_STT_IRQ : L_PARAM_IRQ_STT_IDLE;
								b_irq_flags <= (utim64a_irq || utim64b_irq)? (b_irq_flags | {utim64a_irq, utim64b_irq}) : b_irq_flags;
							end
						end
						else begin
							if(utim64_flags_cc)begin
								//Flag Load Condition
								b_irq_state <= L_PARAM_IRQ_STT_IRQ;
								b_irq_flags <= (utim64a_irq || utim64b_irq)? {utim64a_irq, utim64b_irq} : 8'h00;
							end
							else begin
								//Not Flag Load Condition
								b_irq_state <= L_PARAM_IRQ_STT_IRQ;
								b_irq_flags <= (utim64a_irq || utim64b_irq)? (b_irq_flags | {utim64a_irq, utim64b_irq}) : b_irq_flags;
							end
						end
						*/
					end
					
					
				L_PARAM_IRQ_STT_FLAG:
					begin
						if(utim64_flags_cc)begin
							//Flag Load Condition
							b_irq_state <= L_PARAM_IRQ_STT_IDLE;
							b_irq_flags <= {utim64b_irq, utim64a_irq};
						end
						else begin
							//Not Flag Load Condition
							b_irq_flags <= b_irq_flags | {utim64b_irq, utim64a_irq};
						end
					end
				default:
					begin
						b_irq_state <= L_PARAM_IRQ_STT_IDLE;
					end
			endcase
		end
	end
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_flag_buffer_valid <= 1'b0;
			b_flag_buffer_flags <= 8'h0;
		end
		else begin
			b_flag_buffer_valid <= utim64_flags_cc;//utim64_flags_cc && (b_irq_state == L_PARAM_IRQ_STT_IRQ);
			b_flag_buffer_flags <= b_irq_flags;
		end
	end
	
	/************************************
	Assign
	************************************/
	assign oIRQ_VALID = (b_irq_state == L_PARAM_IRQ_STT_IRQ)? 1'b1 : 1'b0;
	
	assign oREQ_BUSY = (b_state != L_PARAM_MAIN_STT_IDLE) || utim64a_busy || utim64b_busy;
	assign oREQ_VALID = utim64a_out_valid || utim64b_out_valid || b_flag_buffer_valid;
	assign oREQ_DATA = (b_modsel == 2'h0)? utim64a_out_data : (
							(b_modsel == 2'h1)? utim64b_out_data : b_flag_buffer_flags
						);
	
endmodule
	
`default_nettype wire

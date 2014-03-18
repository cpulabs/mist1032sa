

`default_nettype none

module scheduler2_allocate_rsv_station #(
		parameter P_ALU2_PRIORITY_LEVEL = 4'h0
	)(
		//Register
		input wire iORDER_LOCK,
		input wire iORDER_0_VALID,
		input wire iORDER_0_EX_SYS_REG,	
		input wire iORDER_0_EX_SYS_LDST,		
		input wire iORDER_0_EX_LOGIC,
		input wire iORDER_0_EX_SHIFT,
		input wire iORDER_0_EX_ADDER,
		input wire iORDER_0_EX_MUL,
		input wire iORDER_0_EX_SDIV,
		input wire iORDER_0_EX_UDIV,
		input wire iORDER_0_EX_LDST,
		input wire iORDER_0_EX_BRANCH,
		input wire iORDER_1_VALID,
		input wire iORDER_1_EX_SYS_REG,	
		input wire iORDER_1_EX_SYS_LDST,		
		input wire iORDER_1_EX_LOGIC,
		input wire iORDER_1_EX_SHIFT,
		input wire iORDER_1_EX_ADDER,
		input wire iORDER_1_EX_MUL,
		input wire iORDER_1_EX_SDIV,
		input wire iORDER_1_EX_UDIV,
		input wire iORDER_1_EX_LDST,
		input wire iORDER_1_EX_BRANCH,
		//RS-INFO
		input wire [3:0] iRS1_COUNT,
		input wire [3:0] iRS2_COUNT,
		//Output
		output wire oRS0_0_VALID,
		output wire oRS1_0_VALID,
		output wire oRS2_0_VALID,
		output wire oRS3_0_VALID,
		output wire oRS0_1_VALID,
		output wire oRS1_1_VALID,
		output wire oRS2_1_VALID,
		output wire oRS3_1_VALID
	);
	
	//ALU1, 2
	wire rs1_0_select;
	wire rs1_1_select;
	wire rs2_0_select;
	wire rs2_1_select;
	
	/*
	reg b_alu_last;
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin	
			b_alu_last <= 1'b0;
		end
		else if(iRESET_SYNC)begin
			b_alu_last <= 1'b0;
		end
		else begin	
			if(rs1_0_select)begin
				b_alu_last <= 1'b0;
			end
			else if(rs2_0_select)begin
				b_alu_last <= 1'b1;
			end
			else begin
				b_alu_last <= b_alu_last;
			end
		end
	end
	*/
	
	localparam PL_ALU_SEL_ALU1 = 1'h0;
	localparam PL_ALU_SEL_ALU2 = 1'h1;
	
	
	
	//[1]Valid bit, [0]0=Rs1/1=Rs2
	function [1:0] func_alu_select;
		//input func_alu_last;
		input [3:0] func_alu1_cnt;
		input [3:0] func_alu2_cnt;
		input func_valid;
		input func_ex_mul;		//only ALU1
		input func_ex_sdiv;		//only ALU1
		input func_ex_udiv;		//only ALU1
		input func_ex_logic;
		input func_ex_shift;
		input func_ex_adder;
		input func_ex_sys_reg;
		begin	
			if(!func_valid)begin	
				func_alu_select = 2'h0;
			end
			else begin
				if(func_ex_mul || func_ex_sdiv || func_ex_udiv)begin
					func_alu_select = {1'b1, PL_ALU_SEL_ALU1};
				end
				else if(func_ex_logic || func_ex_shift || func_ex_adder || func_ex_sys_reg)begin
					if(func_alu1_cnt < (func_alu2_cnt-P_ALU2_PRIORITY_LEVEL))begin	
						func_alu_select = {1'b1, PL_ALU_SEL_ALU1};
					end
					else begin
						func_alu_select = {1'b1, PL_ALU_SEL_ALU2};
					end
				end
				else begin
					func_alu_select = 2'h0;
				end
			end
		end
	endfunction
	
	wire pipe0_alu_valid;
	wire pipe0_alu_valid_number;
	assign {pipe0_alu_valid, pipe0_alu_valid_number} = func_alu_select(
		iRS1_COUNT,
		iRS2_COUNT,
		(!iORDER_LOCK && iORDER_0_VALID),
		iORDER_0_EX_MUL,
		iORDER_0_EX_SDIV,
		iORDER_0_EX_UDIV,
		iORDER_0_EX_LOGIC,
		iORDER_0_EX_SHIFT,
		iORDER_0_EX_ADDER,
		iORDER_0_EX_SYS_REG
	);
	
	wire pipe1_alu_valid;
	wire pipe1_alu_valid_number;
	assign {pipe1_alu_valid, pipe1_alu_valid_number} = func_alu_select(
		iRS1_COUNT,
		iRS2_COUNT,
		(!iORDER_LOCK && iORDER_1_VALID),
		iORDER_1_EX_MUL,
		iORDER_1_EX_SDIV,
		iORDER_1_EX_UDIV,
		iORDER_1_EX_LOGIC,
		iORDER_1_EX_SHIFT,
		iORDER_1_EX_ADDER,
		iORDER_1_EX_SYS_REG
	);
	
	//RS0
	assign oRS0_0_VALID = !iORDER_LOCK && iORDER_0_VALID && iORDER_0_EX_BRANCH;
	assign oRS0_1_VALID = !iORDER_LOCK && iORDER_1_VALID && iORDER_1_EX_BRANCH;	
	
	/*
	//RS1		
	assign oRS1_0_VALID = !iORDER_LOCK && iORDER_0_VALID && (iORDER_0_EX_MUL || iORDER_0_EX_SDIV || iORDER_0_EX_UDIV || ((iRS1_COUNT < iRS2_COUNT)? iORDER_0_EX_LOGIC || iORDER_0_EX_SHIFT || iORDER_0_EX_ADDER || iORDER_0_EX_SYS_REG : 1'b0));
	assign oRS1_1_VALID = !iORDER_LOCK && iORDER_1_VALID && (iORDER_1_EX_MUL || iORDER_1_EX_SDIV || iORDER_1_EX_UDIV || ((iRS1_COUNT < iRS2_COUNT)? iORDER_1_EX_LOGIC || iORDER_1_EX_SHIFT || iORDER_1_EX_ADDER || iORDER_1_EX_SYS_REG : 1'b0));								
	//RS2									
	assign oRS2_0_VALID = !iORDER_LOCK && iORDER_0_VALID && ((iRS1_COUNT < iRS2_COUNT)? 1'b0 : iORDER_0_EX_LOGIC || iORDER_0_EX_SHIFT || iORDER_0_EX_ADDER || iORDER_0_EX_SYS_REG);
	assign oRS2_1_VALID = !iORDER_LOCK && iORDER_1_VALID && ((iRS1_COUNT < iRS2_COUNT)? 1'b0 : iORDER_1_EX_LOGIC || iORDER_1_EX_SHIFT || iORDER_1_EX_ADDER || iORDER_1_EX_SYS_REG);							
	*/
		
	
	//RS1	
	assign oRS1_0_VALID = pipe0_alu_valid && (pipe0_alu_valid_number == PL_ALU_SEL_ALU1); //rs1_0_select;
	assign oRS1_1_VALID = pipe1_alu_valid && (pipe1_alu_valid_number == PL_ALU_SEL_ALU1); //rs1_1_select;								
	//RS2					
	assign oRS2_0_VALID = pipe0_alu_valid && (pipe0_alu_valid_number == PL_ALU_SEL_ALU2); //rs2_0_select;
	assign oRS2_1_VALID = pipe1_alu_valid && (pipe1_alu_valid_number == PL_ALU_SEL_ALU2); //rs2_1_select;								
	
	
	
	
	//RS3
	assign oRS3_0_VALID = !iORDER_LOCK && iORDER_0_VALID && (iORDER_0_EX_LDST || iORDER_0_EX_SYS_LDST);
	assign oRS3_1_VALID = !iORDER_LOCK && iORDER_1_VALID && (iORDER_1_EX_LDST || iORDER_1_EX_SYS_LDST);
	
endmodule

`default_nettype wire


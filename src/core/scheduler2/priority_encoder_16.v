

`default_nettype none


module priority_encoder_16(
		//System
		input wire iCLOCK,
		input wire inRESET,
		input wire iRESTART,
		//Source
		input wire iSOURCE_VALID0,
		input wire iSOURCE_VALID1,
		input wire iSOURCE_VALID2,
		input wire iSOURCE_VALID3,
		input wire iSOURCE_VALID4,
		input wire iSOURCE_VALID5,
		input wire iSOURCE_VALID6,
		input wire iSOURCE_VALID7,
		input wire iSOURCE_VALID8,
		input wire iSOURCE_VALID9,
		input wire iSOURCE_VALID10,
		input wire iSOURCE_VALID11,
		input wire iSOURCE_VALID12,
		input wire iSOURCE_VALID13,
		input wire iSOURCE_VALID14,
		input wire iSOURCE_VALID15,
		//Select
		output wire oSELECT_VALID,
		output wire [3:0] oSELECT_NUM
	);
	
	//Module Output
	wire sel_valid;
	wire [3:0] sel_num;
	
	reg b_last_valid;
	reg [3:0] b_last_num;
	
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			b_last_num <= {4{1'b0}};
			b_last_valid <= 1'b0;
		end
		else if(iRESTART)begin
			b_last_num <= {4{1'b0}};
		end
		else begin
			b_last_valid <= sel_valid;
			if(sel_valid)begin
				b_last_num <= sel_num;
			end
		end
	end //always
													
													
	function [4:0] func_priority_16;
		input [3:0] func_priority_16_start;
		input func_priority_16_0;
		input func_priority_16_1;
		input func_priority_16_2;
		input func_priority_16_3;
		input func_priority_16_4;
		input func_priority_16_5;
		input func_priority_16_6;
		input func_priority_16_7;
		input func_priority_16_8;
		input func_priority_16_9;
		input func_priority_16_10;
		input func_priority_16_11;
		input func_priority_16_12;
		input func_priority_16_13;
		input func_priority_16_14;
		input func_priority_16_15;
		begin
			case(func_priority_16_start)
				4'h0:
					begin
						if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end 
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h1:
					begin
						if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end 
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h2:
					begin
						if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h3:
					begin
						if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h4:
					begin
						if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h5:
					begin
						if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h6:
					begin
						if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h7:
					begin
						if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h8:
					begin
						if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'h9:
					begin
						if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'hA:
					begin
						if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'hB:
					begin
						if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'hC:
					begin
						if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'hD:
					begin
						if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'hE:
					begin
						if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
				4'hF:
					begin
						if(func_priority_16_15)begin
							func_priority_16 = {1'b1, 4'hF};
						end 
						else if(func_priority_16_0)begin
							func_priority_16 = {1'b1, 4'h0};
						end 
						else if(func_priority_16_1)begin
							func_priority_16 = {1'b1, 4'h1};
						end
						else if(func_priority_16_2)begin
							func_priority_16 = {1'b1, 4'h2};
						end 
						else if(func_priority_16_3)begin
							func_priority_16 = {1'b1, 4'h3};
						end 
						else if(func_priority_16_4)begin
							func_priority_16 = {1'b1, 4'h4};
						end 
						else if(func_priority_16_5)begin
							func_priority_16 = {1'b1, 4'h5};
						end 
						else if(func_priority_16_6)begin
							func_priority_16 = {1'b1, 4'h6};
						end 
						else if(func_priority_16_7)begin
							func_priority_16 = {1'b1, 4'h7};
						end 
						else if(func_priority_16_8)begin
							func_priority_16 = {1'b1, 4'h8};
						end 
						else if(func_priority_16_9)begin
							func_priority_16 = {1'b1, 4'h9};
						end 
						else if(func_priority_16_10)begin
							func_priority_16 = {1'b1, 4'hA};
						end 
						else if(func_priority_16_11)begin
							func_priority_16 = {1'b1, 4'hB};
						end 
						else if(func_priority_16_12)begin
							func_priority_16 = {1'b1, 4'hC};
						end 
						else if(func_priority_16_13)begin
							func_priority_16 = {1'b1, 4'hD};
						end 
						else if(func_priority_16_14)begin
							func_priority_16 = {1'b1, 4'hE};
						end 
						else begin
							func_priority_16 = {1'b0, 4'h0};
						end
					end
			endcase
		end
	endfunction
	
	assign {sel_valid, sel_num} = func_priority_16
													(b_last_num,
													iSOURCE_VALID0, iSOURCE_VALID1, iSOURCE_VALID2, iSOURCE_VALID3,
													iSOURCE_VALID4, iSOURCE_VALID5, iSOURCE_VALID6, iSOURCE_VALID7,
													iSOURCE_VALID8, iSOURCE_VALID9, iSOURCE_VALID10, iSOURCE_VALID11,
													iSOURCE_VALID12, iSOURCE_VALID13, iSOURCE_VALID14, iSOURCE_VALID15);
													
	assign {oSELECT_VALID, oSELECT_NUM} = {b_last_valid, b_last_num};
		
endmodule
	
	
`default_nettype wire	


	

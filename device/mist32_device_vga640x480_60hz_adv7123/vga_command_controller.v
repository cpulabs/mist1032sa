
`default_nettype none


/****************************************************************************
Command (Address)
	0x0 ~ 0xFF					: Not Use
	0x100 ~ 0x2100				: Charactor Set (Use Data : ANSI Charactor = 7bit)
	0x3000						: Display Clear (Use Data : Collor 12bit = 4R4G4B)
****************************************************************************/


`define			STT_IDLE			2'h0
`define			STT_CHARACTOR		2'h1
`define			STT_CLEAR			2'h2
`define			STT_BITMAP			2'h3


module vga_command_controller(
					input				iCLOCK,
					input				inRESET,
					//BUS
					input				iBUSMOD_REQ,
					input	[31:0]		iBUSMOD_ADDR,
					input	[31:0]		iBUSMOD_DATA,
					output				oBUSMOD_WAIT,
					//VRAM
					input				iVRAM_WAIT,
					output				oVRAM_WRITE_REQ,
					output	[18:0]		oVRAM_WRITE_ADDR,
					output	[15:0]		oVRAM_WRITE_DATA);


	
	//Lock Controll
	wire	state_lock;
	assign	state_lock			=		iVRAM_WAIT;
					
					
	//State Controller				
	reg		[1:0]		main_state;
	reg		[6:0]		sub_state;
	reg		[13:0]		req_addr;
	reg		[15:0]		req_data;
	reg		[15:0]		req_color;
	reg		[15:0]		req_back_color;
	reg		[18:0]		vram_addr;
	//Font ROM
	wire	[111:0]		font_rom_data;
	
	//State
	always@(posedge iCLOCK or negedge inRESET)begin
		if(!inRESET)begin
			main_state		<=		`STT_IDLE;
			sub_state		<=		{7{1'b0}};
			req_addr		<=		{14{1'b0}};
			req_data		<=		{16{1'b0}};
			req_color		<=		{16{1'b0}};
			req_back_color	<=		{16{1'b0}};
			vram_addr		<=		{19{1'b0}};
		end
		else begin
			if(!state_lock)begin
				case(main_state)
					`STT_IDLE : //Idle
						begin
							if(iBUSMOD_REQ)begin
								if(iBUSMOD_ADDR == 32'h00003000)begin
									main_state		<=		`STT_CLEAR;
									req_data		<=		iBUSMOD_DATA[15:0];//iBUSMOD_DATA[11:0];
									vram_addr		<=		{19{1'b0}};
								end
								else if(iBUSMOD_ADDR >= 32'h00000100 && iBUSMOD_ADDR <= 32'h00002200)begin
									main_state		<=		`STT_CHARACTOR;
									req_addr		<=		iBUSMOD_ADDR[13:0] - 13'h0100;
									req_data		<=		{9'h00, iBUSMOD_DATA[6:0]};	
									req_color		<=		{/*G*/iBUSMOD_DATA[19:16], iBUSMOD_DATA[16], /*G*/iBUSMOD_DATA[15:12], iBUSMOD_DATA[12], iBUSMOD_DATA[12], /*B*/iBUSMOD_DATA[11:8], iBUSMOD_DATA[8]};//iBUSMOD_DATA[19:8];
									req_back_color	<=		{/*G*/iBUSMOD_DATA[31:28], iBUSMOD_DATA[28], /*G*/iBUSMOD_DATA[27:24], iBUSMOD_DATA[24], iBUSMOD_DATA[24], /*B*/iBUSMOD_DATA[23:20], iBUSMOD_DATA[20]};//iBUSMOD_DATA[31:20];
									vram_addr		<=		req_addr[13:8] * (640 * 14) + (sub_state/8)*640 + req_addr[7:0]*8 + sub_state[2:0];
								end
								else if(iBUSMOD_ADDR >= 32'h00003100 && iBUSMOD_ADDR <= 32'h0004E199)begin
									main_state		<=		`STT_BITMAP;
									req_data		<=		iBUSMOD_DATA[15:0];
									vram_addr		<=		iBUSMOD_ADDR - 32'h00003100;
								end
							end
							sub_state		<=		{7{1'b0}};
							//vram_addr		<=		{19{1'b0}};
						end
					`STT_CHARACTOR : //CharactorOut
						begin
							if(sub_state < 7'd112)begin
								sub_state		<=		sub_state + 7'h01;
								vram_addr		<=		req_addr[13:8] * (640 * 14) + (sub_state/8)*640 + req_addr[7:0]*8 + sub_state[2:0];
							end
							else begin
								main_state		<=		`STT_IDLE;
							end
						end
					`STT_CLEAR : //DisplayClear
						begin
							if(vram_addr < 19'h4B000)begin
								vram_addr		<=		vram_addr + 19'h00001;
							end 
							else begin
								main_state		<=		`STT_IDLE;
							end
						end
					`STT_BITMAP : //Bitmap
						begin
							main_state		<=		`STT_IDLE;
						end
				endcase	
			end
		end
	end //always
	
	//Font ROM
	font_rom FONT(
		.iADDR(req_data[6:0]),
		.oDATA(font_rom_data)
	);
	
	//Assignment Module Output
	assign	oBUSMOD_WAIT		=	state_lock || (main_state != 2'h0);
	assign	oVRAM_WRITE_REQ		=	!state_lock && (main_state != 2'h0);
	assign	oVRAM_WRITE_ADDR	=	vram_addr;
	assign	oVRAM_WRITE_DATA	=	(main_state == `STT_CLEAR || main_state == `STT_BITMAP)? req_data : ((font_rom_data[7'd111 - sub_state + 7'h01])? req_color : req_back_color);


	
	
endmodule


`default_nettype wire

					
				
				
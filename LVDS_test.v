`timescale 1ns / 1ps

module LVDS_test(
	input clk,
	input [15:0] R1,
	input [15:0] R2,
	input [15:0] R3,
	input [15:0] R4,
	input [15:0] R5,
	input [15:0] R6,
	input [15:0] R7,
	input [15:0] R8,
	output channel1_p,
	output channel1_n,
	output channel2_p,
	output channel2_n,
	output channel3_p,
	output channel3_n,
	output clock_p,
	output clock_n,
	output reg led
    );

	reg [30:0]  Contador=0;
	parameter ScreenX = 1366;
	parameter ScreenY = 768;
	parameter BlankingVertical = 12;
	parameter BlankingHorizontal = 50;
	wire clo,clk6x,clk_lckd, clkdcm;
	reg [7:0] Red   = 8'h0;
	reg [7:0] Blue  = 8'h0;
	reg [7:0] Green = 8'h0;
	reg [10:0] ContadorX = ScreenX+BlankingHorizontal-5; // Column Counter
	reg [10:0] ContadorY = ScreenY+BlankingVertical; // Line Counter
/*
input [15:0] R1 = 16'hffff;
input [15:0] R2 = 16'h0;
input [15:0] R3 = 16'h0;
input [15:0] R4 = 16'h0;
input [15:0] R5 = 16'h0;
input [15:0] R6 = 16'h0;
input [15:0] R7 = 16'h0;
input [15:0] R8 = 16'h0;*/
assign clkprueba =clk6x;

wire HSync =((ContadorX>ScreenX) & (ContadorX<(ScreenX+(BlankingHorizontal/2))))?0:1;
wire VSync =((ContadorY>ScreenY) & (ContadorY<(ScreenY+(BlankingVertical/2))))?0:1;
wire DataEnable = ((ContadorX<ScreenX) & (ContadorY<ScreenY));

always @(posedge clk6x) 
	begin
		ContadorX <= (ContadorX==(ScreenX+BlankingHorizontal)) ? 0 : ContadorX+1;
			if(ContadorX==(ScreenX+BlankingHorizontal)) ContadorY <= (ContadorY==(ScreenY+BlankingVertical)) ? 0 : ContadorY+1;
	end

DCM_SP #(
	.CLKIN_PERIOD	(10),  // from 12MHz Input
	.CLKFX_MULTIPLY	(3),   // 72 MHz Clock
	.CLKFX_DIVIDE 	(4)
	)
dcm_main (
	.CLKIN   	(clk),
	.CLKFB   	(clo),
	.RST     	(1'b0),
	.CLK0    	(clkdcm),
	.CLKFX   	(clk6x),
	.LOCKED  	(clk_lckd)
);


BUFG 	clk_bufg	(.I(clkdcm), 	.O(clo) ) ;


video_lvds videoencoder (
    .DotClock(clk6x), 
    .HSync(HSync), 
    .VSync(VSync), 
    .DataEnable(DataEnable), 
    .Red(Red), 
    .Green(Green), 
    .Blue(Blue), 
    .channel1_p(channel1_p), 
    .channel1_n(channel1_n), 
    .channel2_p(channel2_p), 
    .channel2_n(channel2_n), 
    .channel3_p(channel3_p), 
    .channel3_n(channel3_n), 
    .clock_p(clock_p), 
    .clock_n(clock_n)
    );

/* Video Generator */

always @(posedge clk6x)
	begin
		case (ContadorX[9:7]) 
			3'h0: begin Blue[7:3] <= R1[15:11]; Red [7:3] <= R1[10:6]; Green[7:3] <=R1 [5:1]; end 
			3'h1: begin Blue[7:3] <= R2[15:11]; Red [7:3] <= R2[10:6]; Green[7:3] <=R2 [5:1]; end 
			3'h2: begin Blue[7:3] <= R3[15:11]; Red [7:3] <= R3[10:6]; Green[7:3] <=R3 [5:1]; end 
			3'h3: begin Blue[7:3] <= R4[15:11]; Red [7:3] <= R4[10:6]; Green[7:3] <=R4 [5:1]; end 
			3'h4: begin Blue[7:3] <= R5[15:11]; Red [7:3] <= R5[10:6]; Green[7:3] <=R5 [5:1]; end 
			3'h5: begin Blue[7:3] <= R6[15:11]; Red [7:3] <= R6[10:6]; Green[7:3] <=R6 [5:1]; end 
			3'h6: begin Blue[7:3] <= R7[15:11]; Red [7:3] <= R7[10:6]; Green[7:3] <=R7 [5:1]; end 
			3'h7: begin Blue[7:3] <= R8[15:11]; Red [7:3] <= R8[10:6]; Green[7:3] <=R8 [5:1]; end 
		endcase
	end

/* Test LED */

always @(posedge clk6x)
	begin
		Contador <= Contador + 1;
       		if (Contador==36000000)
		begin
			led <= ~led;
			Contador <= 0;
//			Green<= ~Green;
        end
	end

endmodule
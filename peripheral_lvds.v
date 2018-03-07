module peripheral_lvds(
	input clk,
	input rst,
	input [15:0] d_in,
	input cs ,
	input [2:0] addr,
	input wr,
	output channel1_p,
	output channel1_n,
	output channel2_p,
	output channel2_n,
	output channel3_p,   
	output channel3_n,
	output clock_p,
	output clock_n
);



reg [15:0] R1=0;
reg [15:0] R2=0;
reg [15:0] R3=0;
reg [15:0] R4=0;
reg [15:0] R5=0;
reg [15:0] R6=0;
reg [15:0] R7=0;
reg [15:0] R8=0;

// Address Decoder

always @(*) begin

case (addr)
3'h0 : begin R1= (cs && wr) ? d_in: R1; end // Line 1
3'h3 : begin R2= (cs && wr) ? d_in: R2; end // Line 2
3'h4 : begin R3= (cs && wr) ? d_in: R3; end // Line 3
3'h6 : begin R4= (cs && wr) ? d_in: R4; end // Line 4
3'h8 : begin R5= (cs && wr) ? d_in: R5; end // Line 5
3'hA : begin R6= (cs && wr) ? d_in: R6; end // Line 6
3'hC : begin R7= (cs && wr) ? d_in: R7; end // Line 7
3'hE : begin R8= (cs && wr) ? d_in: R8; end // Line 8
endcase
end 
/*
always @(negedge clk) begin 
	if(rst) 
	R1<=0;
	R2<=0;
	R3<=0;
	R4<=0;
	R5<=0;
	R6<=0;
	R7<=0;
	R8<=0;
	
end
*/
// LVDS Test

LVDS_test LVDS(
	.clk(clk),
	.channel1_p(channel1_p),
	.channel1_n(channel1_n),
	.channel2_p(channel2_p),
	.channel2_n(channel2_n),
	.channel3_p(channel3_p),
	.channel3_n(channel3_n),
	.clock_p(clock_p),
	.clock_n(clock_n),
	.R1(R1),
	.R2(R2),
	.R3(R3),
	.R4(R4),
	.R5(R5),
	.R6(R6),
	.R7(R7),
	.R8(R8)
);
endmodule

//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
// 
// Create Date: 03/15/2016 05:03:55 PM
// Design Name: bram_thres
// Module Name: bram_thres
// Project Name: Xike
// Target Devices: KC705
// Tool Versions: Vivado 2015.4
// Description: 
// This is a Block RAM that receive threshold value of each channel, 32 channels are supported
// It is used in SpkDet_A to compare the streaming data to threshold. Comparison is channel number aware.
//
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// 
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module bram_thres (clk, din, we, re, addr, dout, 
				   ch_comb, thr_out_comb, ch_hash_out_comb, off_set_out_comb, 
				   ch_in, ch_gp_out1, ch_gp_out2);

parameter BITWIDTH = 32 ;
parameter CH_WIDTH = 32 ;
parameter BANK_NUM =  5 ;  
parameter DEPTH    = 256;  // Number of channel

input        clk ;
input        we  ;
input        re  ;
input [15:0] addr;
input [BITWIDTH-1:0] din ;
reg [BITWIDTH-1:0] dout_buf;
output [BITWIDTH-1:0] dout;

input      [11:0] ch_in;
output reg [BITWIDTH-1:0]  ch_gp_out1;
output reg [BITWIDTH-1:0]  ch_gp_out2;

input  [59:0] ch_comb;
output [BITWIDTH*BANK_NUM-1:0] thr_out_comb;
output [BITWIDTH*BANK_NUM-1:0] ch_hash_out_comb;
output [BITWIDTH*BANK_NUM-1:0] off_set_out_comb;

// These are 5 channels at this moment given by ch_comb
(* mark_debug = "true" *) wire [11:0] ch_0 = ch_comb[11:0 ];
(* mark_debug = "true" *) wire [11:0] ch_1 = ch_comb[23:12];
(* mark_debug = "true" *) wire [11:0] ch_2 = ch_comb[35:24];
(* mark_debug = "true" *) wire [11:0] ch_3 = ch_comb[47:36];
(* mark_debug = "true" *) wire [11:0] ch_4 = ch_comb[59:48];

// threshold, channel hash, and offset according to 5 channel No
reg [BITWIDTH*BANK_NUM-1:0] thr_out_buf;
reg [BITWIDTH*BANK_NUM-1:0] ch_hash_buf;
reg [BITWIDTH*BANK_NUM-1:0] off_set_buf;

// Internal block memory
(* ram_style = "block" *) 
reg signed [BITWIDTH-1:0] thr_mem[0:DEPTH-1];                      // base address 0,    to 255
(* ram_style = "block" *) 
reg signed [BITWIDTH-1:0] ch_hash[0:DEPTH-1];                     // base address 256,  to 511
(* ram_style = "block" *) 
reg signed [BITWIDTH-1:0] off_set[0:DEPTH-1];                     // base address 512,  to 767
(* ram_style = "block" *) 
reg signed [BITWIDTH-1:0] ch_gpNo[0:DEPTH-1];                     // base address 768,  to 1023

// read and write thr and ch_hash to internal BRAM
always @(posedge clk) begin
	if (addr<DEPTH) begin
	    if (we) thr_mem[addr] <= din;
	    if (re) dout_buf <= thr_mem[addr];
	end
	else if (addr>=DEPTH && addr<2*DEPTH) begin
	    if (we) ch_hash[addr-DEPTH] <= din;
    	if (re) dout_buf <= ch_hash[addr-DEPTH];
	end
	else if (addr>=2*DEPTH && addr<3*DEPTH) begin
        if (we) off_set[addr-2*DEPTH] <= din;
        if (re) dout_buf <= off_set[addr-2*DEPTH];
    end	
	else if (addr>=3*DEPTH && addr<4*DEPTH) begin
        if (we) ch_gpNo[addr-3*DEPTH] <= din;
        if (re) dout_buf <= ch_gpNo[addr-3*DEPTH];
    end    
end


// streaming thr_comb and ch_hash_comb and off_set_comb according to mua_comb_ch
always @(posedge clk) begin
    thr_out_buf <= {thr_mem[ch_4], thr_mem[ch_3], thr_mem[ch_2], thr_mem[ch_1], thr_mem[ch_0]};
end

always @(posedge clk) begin
	ch_hash_buf <= {ch_hash[ch_4], ch_hash[ch_3], ch_hash[ch_2], ch_hash[ch_1], ch_hash[ch_0]};
end

always @(posedge clk) begin
	off_set_buf <= {off_set[ch_4], off_set[ch_3], off_set[ch_2], off_set[ch_1], off_set[ch_0]};
end

// ch_in => ch_gp_out: map ch number to space number  <=> in spiketag: tetrodes.belong_group(75) => 0
always @(posedge clk) begin
    ch_gp_out1 <= ch_gpNo[ch_in];
    ch_gp_out2 <= ch_gpNo[ch_in];
end

// output ports 
assign dout = dout_buf;
assign thr_out_comb     = thr_out_buf;
assign ch_hash_out_comb = ch_hash_buf;
assign off_set_out_comb = off_set_buf;

endmodule

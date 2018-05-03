`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
// 
// Create Date: 09/21/2017 AM
// Design Name: 
// Module Name: sync2bcs
// Project Name: Xike
// Target Devices: 
// Tool Versions: 
// Description:
// Generate sync sequence to behaviour box
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sync2bcs (
  input         clk       ,
  input         rst       ,  // !SPI_running
  input  [31:0] frame_No  ,  // FIFO_TIME_TO_XIKE 
  output [11:0] sec       ,
  output        sync_pulse
);

parameter fs = 25000;
parameter pulse_width = 100; //100ms
//parameter [7:0] INTERVAL [7:0] = {1, 3, 14, 15, 92, 65, 35, 89, 79};

// get frame_pulse
reg frameNo_lastbit;
reg frameNo_lastbit_previous;
always @(posedge clk) begin
  frameNo_lastbit <= frame_No[0];
  frameNo_lastbit_previous <= frameNo_lastbit;
end

(* mark_debug = "true" *) reg frame_pulse;
always @(posedge clk) begin
  frame_pulse <= frameNo_lastbit ^ frameNo_lastbit_previous;
end

// sample cnt and seconds timer
(* mark_debug = "true" *) reg [15:0] cnt = {16{1'b0}};   // number of frame
(* mark_debug = "true" *) reg [11:0] sec = {12{1'b0}};   // time in seconds
(* mark_debug = "true" *) reg sec_vld = 0;               // time in seconds (vld signal)


always @(posedge clk or posedge rst) begin
  if (rst) begin
    cnt <= 0;
    sec <= 0;
    sec_vld <= 0;
  end
  else begin
      if (frame_pulse)  cnt <= cnt + 1'b1;
      if (cnt==fs)  begin
        cnt <= 0;
        sec_vld <= 1;
        sec <= sec + 1'b1;
      end
      else begin
        sec_vld <= 0;
      end
  end
end


// Trigger by SPI_running 0->1: generate pulse at SPI_running
always @(posedge clk or negedge rst) begin
    if(~rst) begin
        sec_vld <= 1;
        sec <= 0;
    end
end


// 
(* mark_debug = "true" *) wire sync_pulse;

syncGen_0 syncGen (
  .ap_clk(clk),                                          // input wire ap_clk
  .ap_rst_n(!rst),                                        // input wire ap_rst_n
  .time_stream_V_sec_V_TVALID(sec_vld),  // input wire time_stream_V_sec_V_TVALID
  .time_stream_V_sec_V_TREADY(time_stream_V_sec_V_TREADY),  // output wire time_stream_V_sec_V_TREADY
  .time_stream_V_sec_V_TDATA(sec),    // input wire [15 : 0] time_stream_V_sec_V_TDATA
  .sync_pulse_V(sync_pulse)                              // output wire [0 : 0] sync_pulse_V
);


endmodule

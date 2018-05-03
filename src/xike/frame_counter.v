`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
// 
// Create Date: 03/17/2016 03:33:55 PM
// Design Name: 
// Module Name: frame_counter
// Project Name: Xike
// Target Devices: 
// Tool Versions: 
// Description: 
// Count the number of frame from start of the recording
// Each counting is dependent on the input clk(end_of_frame) 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module frame_counter (
  input         clk     ,
  input         rst     ,
  input  [ 7:0] muap_ch ,
  output [31:0] frame_No
);

parameter NUM_CH=160;

reg [31:0] cnt = {32{1'b0}};
assign frame_No = cnt;

(* mark_debug = "true" *) wire reset = rst;   
(* mark_debug = "true" *) reg  [7:0] ch;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    cnt <= 0;
    ch  <= 0;
  end
  else begin
    ch <= muap_ch;
    if(ch==NUM_CH-1) begin
      cnt <= cnt + 1'b1;
    end
  end
end

endmodule

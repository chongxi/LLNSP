`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
// 
// Create Date: 03/17/2016 03:33:55 PM
// Design Name: 
// Module Name: channel_counter
// Project Name: Xike
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module channel_counter(
    input rst,
    input clk,
    input en,
    output tlast,
    output [3:0] channel_No
    );

parameter WIDTH = 4;

reg [WIDTH-1:0] cnt = {WIDTH{1'b0}};
reg tlast_out;
assign tlast = tlast_out;
assign channel_No = cnt;

always @(*) begin
    if (cnt == 4'b1111) begin
        tlast_out = 1;
    end else begin
        tlast_out = 0;
    end
end

always @(posedge clk) begin
   if (rst) begin
      cnt <= 0;
   end
   if (en) begin
      cnt <= cnt + 1'b1;
   end
end



endmodule



						
						
//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
// 
// Create Date: 03/15/2016 05:03:55 PM
// Design Name: mem_reg_16
// Module Name: mem_reg_16
// Project Name: Xike
// Target Devices: KC705
// Tool Versions: Vivado 2015.4
// Description: 
// This is a distributed RAM that transimit commands between host and FPGA
// There are three types of command:
// 1. Feedback command to intervene experiment (Host to FPGA)
// 2. Control the behaviour of data processing (Host to FPGA)
// 3. Report the counter of number of samples, spikes detect etc. (FPGA to Host)
//
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// 
// 
// 
// 
// 
//////////////////////////////////////////////////////////////////////////////////
// mem_reg mem_reg_16 (
//   .clk   (bus_clk                    ),
//   .din   (user_w_control_regs_16_data),
//   .we    (user_w_control_regs_16_wren),
//   .re    (user_r_control_regs_16_rden),
//   .addr  (user_control_regs_16_addr  ), 
//   .dout  (user_r_control_regs_16_data),
//   .thr_en(thr_en                     ),
//   .eof   (eof                        )
// );
//////////////////////////////////////////////////////////////////////////////////

module mem_reg_16 (
    input             clk     ,
    input      [15:0] din     ,
    input             we      ,
    input             re      ,
    input      [ 4:0] addr    ,
    output reg [15:0] dout    ,
    
    input             SPI_on  ,
    input             mua_open,
    input             mua_eof ,
    input             sync_in ,

    output reg [15:0] target_unit_id 
);

(* ram_style = "distributed" *)
reg [15:0] mem_reg_16[0:31];
reg sync_buf;
reg SPI_buf;

always @(posedge clk) begin
    if (we) 
        begin
            case (addr)
                5'h02: mem_reg_16[addr] <= din;
                5'h03: mem_reg_16[addr] <= din;
                5'h04: mem_reg_16[addr] <= din;
                5'h05: mem_reg_16[addr] <= din;
                5'h06: mem_reg_16[addr] <= din;
                5'h07: mem_reg_16[addr] <= din;
                5'h08: mem_reg_16[addr] <= din;
                5'h08: mem_reg_16[addr] <= din;
                5'h0a: mem_reg_16[addr] <= din;
                5'h0b: mem_reg_16[addr] <= din;
                5'h0c: mem_reg_16[addr] <= din;
                5'h0d: mem_reg_16[addr] <= din;
                5'h0e: mem_reg_16[addr] <= din;
                5'h0f: mem_reg_16[addr] <= din;
                5'h10: mem_reg_16[addr] <= din;
                5'h11: mem_reg_16[addr] <= din;
                5'h12: mem_reg_16[addr] <= din;
                5'h13: mem_reg_16[addr] <= din;
                5'h14: mem_reg_16[addr] <= din;
                5'h15: mem_reg_16[addr] <= din;
                5'h16: mem_reg_16[addr] <= din;
                5'h17: mem_reg_16[addr] <= din;
                5'h18: mem_reg_16[addr] <= din;
                5'h19: mem_reg_16[addr] <= din;
                5'h1a: mem_reg_16[addr] <= din;
                5'h1b: mem_reg_16[addr] <= din;
                5'h1c: mem_reg_16[addr] <= din;
                5'h1d: mem_reg_16[addr] <= din;
                5'h1e: mem_reg_16[addr] <= din;
                5'h1f: mem_reg_16[addr] <= din;
            endcase
        end
        
    if (re)
        dout <= mem_reg_16[addr];

    SPI_buf <= SPI_on;
    sync_buf <= sync_in;
    mem_reg_16[0][0] <= SPI_buf;
    mem_reg_16[0][1] <= sync_buf;
    target_unit_id <= mem_reg_16[8];
end

endmodule // mem_cmd
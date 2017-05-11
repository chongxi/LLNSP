//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
//
// Create Date: 05/10/2017 03:52:22 PM
// Design Name: mua_2_muap
// Module Name: mua_2_muap
// Project Name: Xike
// Target Devices: KC705
// Tool Versions: Vivado 2016.1
// Description:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////


module mua_2_muap (
  input          bus_clk          , // Clock
  input          xike_reset       , // Reset
  input          frame_count_rst  ,

  input          muap_comb_valid  ,
  input  [ 59:0] muap_comb_ch     ,
  input  [159:0] muap_comb_data   ,
  input  [159:0] muap_comb_ch_hash,
  input          fifo_mua_full    ,
  
  output         muap_valid       ,
  output [ 11:0] muap_ch          ,
  output [ 31:0] muap_data        ,
  output [ 31:0] muap_ch_hash     ,
  output [ 31:0] muap_frame_No
);

  axis_dwidth_converter mua_comb_2_mua_data_ch (
    .aclk(bus_clk),                    // input wire aclk
    .aresetn(!xike_reset),              // input wire aresetn
    .s_axis_tvalid(muap_comb_valid),  // input wire s_axis_tvalid
    .s_axis_tready(s_axis_tready),  // output wire s_axis_tready
    .s_axis_tdata(muap_comb_data),    // input wire [159 : 0] s_axis_tdata
    .s_axis_tuser(muap_comb_ch),    // input wire [59 : 0] s_axis_tuser
    .m_axis_tvalid(muap_valid),  // output wire m_axis_tvalid
    .m_axis_tready(!fifo_mua_full),  // input wire m_axis_tready
    .m_axis_tdata(muap_data),    // output wire [31 : 0] m_axis_tdata
    .m_axis_tuser(muap_ch)    // output wire [11 : 0] m_axis_tuser
  );

  axis_dwidth_converter mua_ch_hash (
    .aclk(bus_clk),                    // input wire aclk
    .aresetn(!xike_reset),              // input wire aresetn
    .s_axis_tvalid(muap_comb_valid),  // input wire s_axis_tvalid
    .s_axis_tready(s_axis_tready_1),  // output wire s_axis_tready
    .s_axis_tdata(muap_comb_ch_hash),    // input wire [159 : 0] s_axis_tdata
    .s_axis_tuser(muap_comb_ch),    // input wire [59 : 0] s_axis_tuser
    .m_axis_tvalid(muap_ch_hash_valid),  // output wire m_axis_tvalid
    .m_axis_tready(!fifo_mua_full),  // input wire m_axis_tready
    .m_axis_tdata(muap_ch_hash),    // output wire [31 : 0] m_axis_tdata
    .m_axis_tuser(muap_ch_1)    // output wire [11 : 0] m_axis_tuser
  );
  

  frame_counter #(.NUM_CH(160)) spk_frame_counter (
    .clk               (bus_clk           ),
    .rst               (frame_count_rst   ),
    .muap_ch           (muap_ch           ),
    .frame_No          (muap_frame_No     )
  );


endmodule
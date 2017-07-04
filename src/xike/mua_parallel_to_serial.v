module mua_parallel_to_serial (
  input          bus_clk          , // Clock
  input          xike_reset       , // Reset
  input          frame_count_rst  ,

  input          mua_comb_valid   ,
  input  [ 59:0] mua_comb_ch      ,
  input  [159:0] mua_comb_data    ,
  input  [159:0] mua_comb_ch_hash ,
  input  [159:0] threshold_comb   ,
  input  [159:0] off_set_comb     ,
  input          fifo_mua_full    ,
  
  output         mua_valid       ,
  output [ 11:0] mua_ch          ,
  output [ 31:0] mua_data        ,
  output [ 31:0] thr_data        ,
  output [ 31:0] mua_ch_hash     ,
  output [ 31:0] mua_frame_No
);

  reg           mua_comb_valid_buf;
  reg  [ 59:0]  mua_comb_ch_buf;
  reg  [159:0]  mua_comb_data_buf;
  
  always @(posedge bus_clk) begin
       mua_comb_valid_buf  <= mua_comb_valid;
       mua_comb_ch_buf     <= mua_comb_ch;
       mua_comb_data_buf   <= mua_comb_data;
  end

// 5 banks offset
  wire [159:0] mua_comb_data_in;
  assign mua_comb_data_in[ 31:0  ]  = mua_comb_data_buf[ 31:0  ] - off_set_comb[ 31:0  ];
  assign mua_comb_data_in[ 63:32 ]  = mua_comb_data_buf[ 63:32 ] - off_set_comb[ 63:32 ];
  assign mua_comb_data_in[ 95:64 ]  = mua_comb_data_buf[ 95:64 ] - off_set_comb[ 95:64 ];
  assign mua_comb_data_in[127:96 ]  = mua_comb_data_buf[127:96 ] - off_set_comb[127:96 ];
  assign mua_comb_data_in[159:128]  = mua_comb_data_buf[159:128] - off_set_comb[159:128];   
  
  assign mua_comb_data_in[0  ] = 0;
  assign mua_comb_data_in[32 ] = 0;
  assign mua_comb_data_in[64 ] = 0;
  assign mua_comb_data_in[96 ] = 0;
  assign mua_comb_data_in[128] = 0;

  axis_dwidth_converter mua_comb_2_mua_data_ch (
    .aclk         (bus_clk           ), // input wire aclk
    .aresetn      (!xike_reset       ), // input wire aresetn
    .s_axis_tvalid(mua_comb_valid_buf), // input wire s_axis_tvalid
    .s_axis_tready(s_axis_tready     ), // output wire s_axis_tready
    .s_axis_tdata (mua_comb_data_in  ), // input wire [159 : 0] s_axis_tdata
    .s_axis_tuser (mua_comb_ch_buf   ), // input wire [59 : 0] s_axis_tuser
    .m_axis_tvalid(mua_valid         ), // output wire m_axis_tvalid
    .m_axis_tready(!fifo_mua_full    ), // input wire m_axis_tready
    .m_axis_tdata (mua_data          ), // output wire [31 : 0] m_axis_tdata
    .m_axis_tuser (mua_ch            )  // output wire [11 : 0] m_axis_tuser
  );

  axis_dwidth_converter ch_hash_comb_2_ch_hash (
    .aclk         (bus_clk           ), // input wire aclk
    .aresetn      (!xike_reset       ), // input wire aresetn
    .s_axis_tvalid(mua_comb_valid_buf), // input wire s_axis_tvalid
    .s_axis_tready(s_axis_tready_1   ), // output wire s_axis_tready
    .s_axis_tdata (mua_comb_ch_hash  ), // input wire [159 : 0] s_axis_tdata
    .s_axis_tuser (mua_comb_ch_buf   ), // input wire [59 : 0] s_axis_tuser
    .m_axis_tvalid(muap_ch_hash_valid), // output wire m_axis_tvalid
    .m_axis_tready(!fifo_mua_full    ), // input wire m_axis_tready
    .m_axis_tdata (mua_ch_hash       ), // output wire [31 : 0] m_axis_tdata
    .m_axis_tuser (xxxxxxxx0         )  // output wire [11 : 0] m_axis_tuser
  );

  axis_dwidth_converter thr_comb_2_thr (
    .aclk         (bus_clk           ), // input wire aclk
    .aresetn      (!xike_reset       ), // input wire aresetn
    .s_axis_tvalid(mua_comb_valid_buf), // input wire s_axis_tvalid
    .s_axis_tready(s_axis_tready_2   ), // output wire s_axis_tready
    .s_axis_tdata (threshold_comb    ), // input wire [159 : 0] s_axis_tdata
    .s_axis_tuser (mua_comb_ch_buf   ), // input wire [59 : 0] s_axis_tuser
    .m_axis_tvalid(thr_valid         ), // output wire m_axis_tvalid
    .m_axis_tready(!fifo_mua_full    ), // input wire m_axis_tready
    .m_axis_tdata (thr_data          ), // output wire [31 : 0] m_axis_tdata
    .m_axis_tuser (xxxxxxx1          )  // output wire [11 : 0] m_axis_tuser
  );

  frame_counter #(.NUM_CH(160)) spk_frame_counter (
    .clk     (bus_clk        ),
    .rst     (frame_count_rst),
    .muap_ch (mua_ch         ),
    .frame_No(mua_frame_No   )
  );

endmodule
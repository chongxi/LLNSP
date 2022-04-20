module ref_substract (
    input         clk          , // Clock
    input         rst          , // Asynchronous reset active low
    // input
    input         mua_valid    ,
    input  [31:0] frameNo_in   ,
    input  [11:0] ch_ref_in    ,
    input  [11:0] chNo_in      ,
    input  [31:0] mua_data     ,
    input  [31:0] ch_hash_in   ,
    input  [31:0] thr_data     ,

    // output
    output reg       muar_valid   ,
    output reg [31:0] muar_frame_No,  // t
    output reg [11:0] muar_ch      ,  // ch
    output reg [31:0] muar_data    ,  // muar
    output reg [31:0] muar_ch_hash ,  // ch_hash
    output reg [31:0] muar_thr        // thr
);

  reg _mua_stream_valid;
  reg [31:0] _frameNo_in_buf;
  reg [11:0] _chNo_in_buf   ; // ch_ref_in, chNo_in are both 12bits, 2*12+8=32 bits, so there is a 8'b0
  reg [31:0] _mua_data_buf  ;
  reg [31:0] _ch_hash_in_buf;
  reg [31:0] _thr_data_buf  ;

  reg mua_stream_valid;
  reg [31:0] frameNo_in_buf;
  reg [11:0] chNo_in_buf   ; // ch_ref_in, chNo_in are both 12bits, 2*12+8=32 bits, so there is a 8'b0
  reg [11:0] ch_ref_in_buf ;
  reg [31:0] mua_data_buf  ;
  reg [31:0] ch_hash_in_buf;
  reg [31:0] thr_data_buf  ;

  always @(posedge clk)
    begin : pipeline_for_mua_stream_1    // ch_ref_in_buf finish here
      _mua_stream_valid <= mua_valid;
      _frameNo_in_buf   <= frameNo_in;
      _chNo_in_buf      <= chNo_in;
      _mua_data_buf     <= mua_data  ;
      _ch_hash_in_buf   <= ch_hash_in;
      _thr_data_buf     <= thr_data  ;
      ch_ref_in_buf     <= ch_ref_in ;
    end

  always @(posedge clk)
    begin : pipeline_for_mua_stream_2
      mua_stream_valid <= _mua_stream_valid;
      frameNo_in_buf   <= _frameNo_in_buf  ;
      chNo_in_buf      <= _chNo_in_buf     ;
      mua_data_buf     <= _mua_data_buf    ;
      ch_hash_in_buf   <= _ch_hash_in_buf  ;
      thr_data_buf     <= _thr_data_buf    ;
    end

  wire         mua_stream_V_valid   = mua_stream_valid;
  wire [159:0] mua_stream_V_data_V_din = {frameNo_in_buf, 8'b0, ch_ref_in_buf, chNo_in_buf ,ch_hash_in_buf, thr_data_buf, mua_data_buf};
  wire [159:0] mua_stream_V_data_V_dout;

  (* mark_debug = "true" *) wire         mua_stream_V_data_V_read;
  (* mark_debug = "true" *) wire [31:0]  mua_stream_V_mua     = mua_stream_V_data_V_dout[31:0];
  (* mark_debug = "true" *) wire [31:0]  mua_stream_V_thr     = mua_stream_V_data_V_dout[63:32];
  (* mark_debug = "true" *) wire [31:0]  mua_stream_V_ch_hash = mua_stream_V_data_V_dout[95:64];
  (* mark_debug = "true" *) wire [11:0]  mua_stream_V_ch      = mua_stream_V_data_V_dout[107:96];
  (* mark_debug = "true" *) wire [11:0]  mua_stream_V_ch_ref  = mua_stream_V_data_V_dout[119:108];
  (* mark_debug = "true" *) wire [31:0]  mua_stream_V_t       = mua_stream_V_data_V_dout[159:128];

  fifo_160_to_160 fifo_to_ref_sub (
    .clk  (clk                      ), // input wire clk
    .srst (rst                      ), // input wire srst
    .din  (mua_stream_V_data_V_din  ), // input wire [159 : 0] din
    .wr_en(mua_stream_V_valid       ), // input wire wr_en
    .rd_en(mua_stream_V_data_V_read ), // input wire rd_en
    .dout (mua_stream_V_data_V_dout ), // output wire [159 : 0] dout
    .full (mua_stream_V_data_V_full ), // output wire full
    .empty(mua_stream_V_data_V_empty)  // output wire empty
  );

  ref_sub_0 ref_sub (
    .ap_clk                     (clk                        ), // input wire ap_clk
    .ap_rst_n                   (!rst                       ), // input wire ap_rst_n
    .mua_stream_V_data_V_dout   (mua_stream_V_data_V_dout   ), // input wire [159 : 0] mua_stream_V_data_V_dout
    .mua_stream_V_data_V_empty_n(!mua_stream_V_data_V_empty ), // input wire mua_stream_V_data_V_empty_n
    .mua_stream_V_data_V_read   (mua_stream_V_data_V_read   ), // output wire mua_stream_V_data_V_read
    .muar_stream_V_data_V_TVALID(muar_stream_V_data_V_TVALID), // output wire muar_stream_V_data_V_TVALID
    .muar_stream_V_data_V_TREADY(muar_stream_V_data_V_TREADY), // input wire muar_stream_V_data_V_TREADY
    .muar_stream_V_data_V_TDATA (muar_stream_V_data_V_TDATA )  // output wire [159 : 0] muar_stream_V_data_V_TDATA
  );

  wire muar_stream_V_data_V_TREADY = 1;
  wire         muar_stream_V_data_V_TVALID;
  wire [159:0] muar_stream_V_data_V_TDATA;


  always @(posedge clk) begin
      muar_valid <= muar_stream_V_data_V_TVALID;
      muar_frame_No <= muar_stream_V_data_V_TDATA[159:128];
      muar_ch <= muar_stream_V_data_V_TDATA[107:96];
      muar_ch_hash <= muar_stream_V_data_V_TDATA[95:64];
      muar_thr <= muar_stream_V_data_V_TDATA[63:32];
      muar_data <= muar_stream_V_data_V_TDATA[31:0];
  end

endmodule
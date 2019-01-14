module spkDect (
  input         clk          , // Clock
  input         rst          , // Asynchronous reset active low
  // input
  input         mua_valid    ,
  input  [31:0] frameNo_in   ,
  input  [11:0] ch_ref_in    ,
  input  [11:0] chNo_in      ,
  input  [31:0] ch_hash_in   ,
  input  [31:0] thr_data     ,
  input  [31:0] mua_data     ,
  // output
  output        muap_valid   ,
  output [31:0] muap_frame_No, // t
  output [11:0] muap_ch      , // ch
  output [31:0] muap_ch_hash , // ch_hash
  output [31:0] muap_data      // muap
);

wire [159:0] mua_stream_V_data_V_din;     // => fifo
reg _mua_stream_valid;
reg [31:0] _frameNo_in_buf;
reg [11:0] _chNo_in_buf   ; // ch_ref_in, chNo_in are both 12bits, 2*12+8=32 bits, so there is a 8'b0
reg [31:0] _ch_hash_in_buf;
reg [31:0] _thr_data_buf  ;
reg [31:0] _mua_data_buf  ;

reg mua_stream_valid;
reg [31:0] frameNo_in_buf;
reg [11:0] chNo_in_buf   ; // ch_ref_in, chNo_in are both 12bits, 2*12+8=32 bits, so there is a 8'b0
reg [11:0] ch_ref_in_buf ;
reg [31:0] ch_hash_in_buf;
reg [31:0] thr_data_buf  ;
reg [31:0] mua_data_buf  ;

always @(posedge clk)
  begin : pipeline_for_mua_stream_1    // ch_ref_in_buf finish here
    _mua_stream_valid <= mua_valid;
    _frameNo_in_buf   <= frameNo_in;
    _chNo_in_buf      <= chNo_in;
    _ch_hash_in_buf   <= ch_hash_in;
    _thr_data_buf     <= thr_data  ;
    _mua_data_buf     <= mua_data  ;
    ch_ref_in_buf     <= ch_ref_in ;
  end

always @(posedge clk)
  begin : pipeline_for_mua_stream_2
    mua_stream_valid <= _mua_stream_valid;
    frameNo_in_buf   <= _frameNo_in_buf  ;
    chNo_in_buf      <= _chNo_in_buf     ;
    ch_hash_in_buf   <= _ch_hash_in_buf  ;
    thr_data_buf     <= _thr_data_buf    ;
    mua_data_buf     <= _mua_data_buf    ;
  end

assign mua_stream_V_data_V_din = {frameNo_in_buf, 8'b0, ch_ref_in_buf, chNo_in_buf ,ch_hash_in_buf, thr_data_buf, mua_data_buf};

wire [159:0] mua_stream_V_data_V_dout   ; // fifo => spk_dect 

//(* mark_debug = "true" *) 
// 8bits [127:120] are reserved for future use
(* mark_debug = "true" *) wire         mua_stream_V_valid   = mua_stream_valid;
(* mark_debug = "true" *) wire [31:0]  mua_stream_V_mua     = mua_stream_V_data_V_dout[31:0];
(* mark_debug = "true" *) wire [31:0]  mua_stream_V_thr     = mua_stream_V_data_V_dout[63:32];
(* mark_debug = "true" *) wire [31:0]  mua_stream_V_ch_hash = mua_stream_V_data_V_dout[95:64];
(* mark_debug = "true" *) wire [11:0]  mua_stream_V_ch      = mua_stream_V_data_V_dout[107:96];
(* mark_debug = "true" *) wire [11:0]  mua_stream_V_ch_ref  = mua_stream_V_data_V_dout[119:108];
(* mark_debug = "true" *) wire [31:0]  mua_stream_V_t       = mua_stream_V_data_V_dout[159:128];
(* mark_debug = "true" *) wire         mua_stream_V_data_V_empty  ; // spk_dect => fifo
(* mark_debug = "true" *) wire         mua_stream_V_data_V_read   ; // spk_dect => fifo

fifo_160_to_160 fifo_to_spk_dect (
  .clk(clk),      // input wire clk
  .srst(rst),     // input wire srst
  .din(mua_stream_V_data_V_din),      // input wire [159 : 0] din
  .wr_en(mua_stream_V_valid),  // input wire wr_en
  .rd_en(mua_stream_V_data_V_read),  // input wire rd_en
  .dout(mua_stream_V_data_V_dout),    // output wire [159 : 0] dout
  .full(mua_stream_V_data_V_full),    // output wire full
  .empty(mua_stream_V_data_V_empty)  // output wire empty
);

wire        muap_stream_TREADY = 1; // to   spk_dect
wire        muap_stream_TVALID; // from spk_dect
wire [31:0] muap_stream_TUSER ; // t
wire [7 :0] muap_stream_TID   ; // ch
wire [31:0] muap_stream_TDEST ; // (ch_nn3, ch_nn2, ch_nn1, ch_nn0)
wire [31:0] muap_stream_TDATA ; // muap

wire ap_start;
(* mark_debug = "true" *) wire ap_rst_n; // to   spk_dect
(* mark_debug = "true" *) wire ap_done, ap_idle, ap_ready; // from spk_dect
assign ap_rst_n = !rst;   // Under Test
assign ap_start = 1;

spk_dect_0 spk_dect (
  .ap_clk(clk),                                            // input wire ap_clk
  .ap_rst_n(ap_rst_n),                                        // input wire ap_rst_n
  .ap_start(ap_start),                                        // input wire ap_start
  .ap_done(ap_done),                                          // output wire ap_done
  .ap_idle(ap_idle),                                          // output wire ap_idle
  .ap_ready(ap_ready),                                        // output wire ap_ready
  .mua_stream_V_data_V_dout(mua_stream_V_data_V_dout),        // input wire [159 : 0] mua_stream_V_data_V_dout
  .mua_stream_V_data_V_empty_n(!mua_stream_V_data_V_empty),   // input wire mua_stream_V_data_V_empty_n
  .mua_stream_V_data_V_read(mua_stream_V_data_V_read),        // output wire mua_stream_V_data_V_read
  .muap_stream_TVALID(muap_stream_TVALID),                    // output wire muap_stream_TVALID
  .muap_stream_TREADY(muap_stream_TREADY),                    // input wire muap_stream_TREADY
  .muap_stream_TUSER(muap_stream_TUSER),                      // output wire [31 : 0] muap_stream_TUSER
  .muap_stream_TDEST(muap_stream_TDEST),                      // output wire [31 : 0] muap_stream_TDEST
  .muap_stream_TID(muap_stream_TID),                          // output wire [7 : 0] muap_stream_TID
  .muap_stream_TDATA(muap_stream_TDATA)                      // output wire [31 : 0] muap_stream_TDATA
);

assign muap_valid = muap_stream_TVALID;
assign muap_frame_No    = muap_stream_TUSER ;
assign muap_ch       = muap_stream_TID   ;
assign muap_ch_hash    = muap_stream_TDEST ;
assign muap_data  = muap_stream_TDATA ;

endmodule
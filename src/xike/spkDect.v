module spkDect (
  input         clk          , // Clock
  input         rst          , // Asynchronous reset active low
  // input
  input         mua_valid    ,
  input  [31:0] frameNo_in   ,
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

wire [31:0 ] chNo_32bit = chNo_in;
wire [159:0] mua_stream_V_data_V_din;     // => fifo

assign mua_stream_V_data_V_din = {frameNo_in, chNo_32bit ,ch_hash_in, thr_data, mua_data};

wire [159:0] mua_stream_V_data_V_dout   ; // fifo => spk_dect 

//(* mark_debug = "true" *) 
wire [31:0]  mua_stream_V_mua = mua_stream_V_data_V_dout[31:0];
wire [31:0]  mua_stream_V_thr = mua_stream_V_data_V_dout[63:32];
wire [31:0]  mua_stream_V_ch_hash = mua_stream_V_data_V_dout[95:64];
wire [31:0]  mua_stream_V_ch = mua_stream_V_data_V_dout[127:96];
wire [31:0]  mua_stream_V_t  = mua_stream_V_data_V_dout[159:128];
wire         mua_stream_V_data_V_empty  ; // spk_dect => fifo
wire         mua_stream_V_data_V_read   ; // spk_dect => fifo

fifo_160_to_160 fifo_to_spk_dect (
  .clk(clk),      // input wire clk
  .srst(rst),     // input wire srst
  .din(mua_stream_V_data_V_din),      // input wire [159 : 0] din
  .wr_en(mua_valid),  // input wire wr_en
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

wire ap_clk, ap_rst_n, ap_start; // to   spk_dect
wire ap_done, ap_idle, ap_ready; // from spk_dect
assign ap_clk   = clk;
assign ap_rst_n = !rst;
assign ap_start = 1;

spk_dect_0 spk_dect (
  .ap_clk(ap_clk),                                            // input wire ap_clk
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
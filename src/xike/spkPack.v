//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
// 
// Create Date: 05/03/2017 01:12:55 PM
// Design Name: spkPack
// Module Name: spkPack
// Project Name: Xike
// Target Devices: KC705
// Tool Versions: Vivado 2016.1
// Description: 
// Extract spikes from muap stream by caching the data, binding channels and designed tx rx protocol
// Dependencies:
// Two hls modules:
// 1. spk_packet_tx (tx protocol)
// 2. spk_packet_rx (rx protocol)
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module spkPack (
  input                 clk              ,
  input                 rst              ,
  input         [ 31:0] frame_No_in      ,
  input         [ 11:0] ch_in            ,
  input         [ 31:0] ch_unigroup_in   ,
  input         [  7:0] ch_gpno_in       ,
  input                 valid_in         ,
  input  signed [ 31:0] v_in             ,

  // spk waveform
  output                spk_stream_TVALID,
  output signed [127:0] spk_stream_TDATA ,
  output                spk_stream_pulse
);

parameter NUM_CH    = 160;
parameter WIDTH_CH  = 8;
// parameter WIDTH_CH = $clog2(NUM_CH);
parameter SPK_LENTH = 19;   //19:25kHz; 23:30kHz



////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------PART 1-------------------------------------------------
// Set Buffers using postfix
// Level0: _in
// Level1: _buf
// Level2: _bufo or _o
// --------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////////

reg [        31:0] frame_No_buf   ;
reg                valid_buf      ;
reg [        31:0] v_buf          ;
reg [WIDTH_CH-1:0] ch_buf         ;
reg [        31:0] ch_unigroup_buf;
reg [         7:0] ch_gpno_buf    ;

reg [        31:0] _frame_No_in   ;
reg                _valid_in      ;
reg [        31:0] _v_in          ;
reg [WIDTH_CH-1:0] _ch_in         ;
reg [        31:0] _ch_unigroup_in;
reg [         7:0] _ch_gpno_in;

always @(posedge clk)
  begin : pipeline_0 // 0 buf
    _frame_No_in    <= frame_No_in;
    _valid_in       <= valid_in;
    _v_in           <= v_in;
    _ch_in          <= ch_in;
    _ch_unigroup_in <= ch_unigroup_in;
    _ch_gpno_in     <= ch_gpno_in;
  end
  
always @(posedge clk)
  begin : pipeline_1 // 1 buf
    frame_No_buf    <= _frame_No_in;
    valid_buf       <= _valid_in;
    v_buf           <= _v_in;
    ch_buf          <= _ch_in;
    ch_unigroup_buf <= _ch_unigroup_in;
    ch_gpno_buf     <= _ch_gpno_in;
  end

(* mark_debug = "true" *) reg [        31:0] frame_No_bufo   ;
(* mark_debug = "true" *) reg                valid_bufo       ;
(* mark_debug = "true" *) reg [WIDTH_CH-1:0] ch_bufo          ;
(* mark_debug = "true" *) reg [WIDTH_CH-1:0] ch_last_bufo     ;
reg [        31:0] ch_unigroup_bufo;
reg [        31:0] v_bufo          ;

always @(posedge clk)
  begin : pipeline_2 // 2 buf
    frame_No_bufo    <= frame_No_buf          ;
    valid_bufo       <= valid_buf             ;
    v_bufo           <= v_buf                 ;
    ch_bufo          <= ch_buf                ;
    ch_last_bufo     <= ch_unigroup_buf[31:24];
    ch_unigroup_bufo <= ch_unigroup_buf       ;
  end


////////////////////////////////////////////////////////////////
// level to pulse
// detect frameNo change
(* mark_debug = "true" *) wire frame_pulse;
assign frame_pulse = frame_No_bufo[0] ^ frame_No_buf[0];


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------PART 2-------------------------------------------------
// Group channel based on ch_unigroup_in (channal hash)
// Write and Read buf_2d to cache 2 time points
// Group muap values from (channels, previous time points)
// --------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////
/////////////////// channel binding ////////////////////////////

wire [7:0] ch_nn0;
wire [7:0] ch_nn1;
wire [7:0] ch_nn2;
wire [7:0] ch_nn3;

assign ch_nn0 = ch_unigroup_buf[ 7:0 ];
assign ch_nn1 = ch_unigroup_buf[15:8 ];
assign ch_nn2 = ch_unigroup_buf[23:16];
assign ch_nn3 = ch_unigroup_buf[31:24];

reg signed [31:0] buf_2d[0:1][0:NUM_CH-1]; // two frame of buffer
reg [5:0] i;
//(* mark_debug = "true" *) wire j = frame_No_buf[0]; 
//(* mark_debug = "true" *) wire j = frame_No_in[0]; 
(* mark_debug = "true" *) wire j = _frame_No_in[0]; 

///////////////////////////////////////// /////////////////
//  Process 1: write muap of current time point
//  buf_2d <= multi_channel_muao  
///////////////////////////////////////////////////////////
reg v_buf_cache_ready;
reg signed [31:0] v_buf_cache;
always @(posedge clk) begin : proc_buf_2d
  begin
    if(valid_buf) begin
        v_buf_cache       <= v_buf;
        v_buf_cache_ready <= 1;
    end
    if(v_buf_cache_ready) begin
        buf_2d[j][ch_bufo] <= v_buf_cache;         // write j buf
        v_buf_cache_ready <= 0;
    end
  end
end

///////////////////////////////////////// /////////////////
//  Process 2: read grouped muap from previous time point
//  buf_2d => multi_channel_muao  
///////////////////////////////////////////////////////////

wire [127:0] multi_channel_muao;
(* mark_debug = "true" *) reg  [31:0] ch_nn0_value;   
(* mark_debug = "true" *) reg  [31:0] ch_nn1_value;   
(* mark_debug = "true" *) reg  [31:0] ch_nn2_value;   
(* mark_debug = "true" *) reg  [31:0] ch_nn3_value;

// 1 channel
always @(posedge clk) begin : channel_nn0 
  if( ch_nn0<0 || ch_nn0>=NUM_CH )
    ch_nn0_value <= 0;
  else
    ch_nn0_value <= buf_2d[~j][ch_nn0];              // read ~j buf
end

// 2 channel
always @(posedge clk) begin : channel_nn1
  if( ch_nn1<0 || ch_nn1>=NUM_CH )
    ch_nn1_value <= 0;
  else
    ch_nn1_value <= buf_2d[~j][ch_nn1];              // read ~j buf
end

// 3 channel
always @(posedge clk) begin : channel_nn2
  if( ch_nn2<0 || ch_nn2>=NUM_CH )
    ch_nn2_value <= 0;
  else
    ch_nn2_value <= buf_2d[~j][ch_nn2];              // read ~j buf
end

// 4 channel
always @(posedge clk) begin : channel_nn3
  if( ch_nn3<0 || ch_nn3>=NUM_CH )
    ch_nn3_value <= 0;
  else
    ch_nn3_value <= buf_2d[~j][ch_nn3];              // read ~j buf
end

assign multi_channel_muao = {ch_nn0_value, ch_nn1_value, ch_nn2_value, ch_nn3_value};

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ----------------------------------------------PART 3-------------------------------------------------
// Below are HLS USER IP for spike extraction protocol
// Spk packet protocol tx and rx (spike extractor from grouped muap data)
// The output is spike stream feeding the queue to the classifier 
// --------------------------------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////
// TX:
/////////////////////////////

wire ap_start;   // rx
wire ap_ready;   // rx
wire ap_done;    // rx
wire ap_idle;    // rx
wire ap_rst_n;   // tx && rx

assign ap_rst_n = !rst;
assign ap_start = ap_rst_n;

wire [127:0] out_pre_TDATA; 
wire [7 :0]  out_pre_TUSER;
wire [15:0]  out_pre_TID;
wire [0:0 ]  out_pre_TVALID;
wire [0:0 ]  out_pre_TLAST;
wire [0:0 ]  out_pre_TDEST;

wire [127:0] out_post_TDATA;
(* mark_debug = "true" *) wire [7 :0] out_post_TUSER;
(* mark_debug = "true" *) wire [15:0] out_post_TID;
(* mark_debug = "true" *) wire [0:0 ] out_post_TVALID;
(* mark_debug = "true" *) wire [0:0 ] out_post_TLAST;
(* mark_debug = "true" *) wire [0:0 ] out_post_TDEST;

// time output
wire [31:0] time_stamp_TDATA;
wire time_stamp_TVALID;

// busy output
wire [NUM_CH-1:0] busy_A;
wire [0:0 ] busy_A_vld;

(* mark_debug = "true" *)  reg         spk_tx_wen;
reg  [191:0] spk_tx_din;
wire [191:0] spk_tx_dout;

always @(posedge clk) begin : proc_bundle_input
    spk_tx_wen   <= valid_bufo;
    spk_tx_din   <= {8'b0, ch_gpno_buf, ch_last_bufo, ch_bufo, frame_No_bufo, multi_channel_muao};
end

(* mark_debug = "true" *) wire spk_packet_tx_read;
(* mark_debug = "true" *) wire fifo_2_spk_tx_empty;

// output of the fifo spk_tx_dout to spk_packet_tx
fifo_192_to_192 fifo_2_spk_tx (
  .clk(clk),      // input wire clk
  .srst(rst),     // input wire srst

  .wr_en(spk_tx_wen),    // input wire wr_en
  .din  (spk_tx_din),      // input wire [191 : 0] din

  .rd_en (spk_packet_tx_read ),  // input wire rd_en
  .dout  (spk_tx_dout        ),    // output wire [191 : 0] dout
  .full  (fifo_2_spk_tx_full ),    // output wire full
  .empty (fifo_2_spk_tx_empty)  // output wire empty
);


// check these in spk_packet_tx.cpp in the hls module//////////////////////////
//wire [127:0] tetrode_data = spk_tx_dout[127:0];
(* mark_debug = "true" *) wire [31:0] t_in         = spk_tx_dout[159:128];
(* mark_debug = "true" *) wire [7:0 ] channel      = spk_tx_dout[167:160];
(* mark_debug = "true" *) wire [7:0 ] last_channel = spk_tx_dout[175:168];
(* mark_debug = "true" *) wire [7:0 ] group_No     = spk_tx_dout[183:176];
///////////////////////////////////////////////////////////////////////////////

spk_packet_tx_0 spk_packet_tx (
  .ap_clk             (clk                ), // input wire ap_clk
  .ap_rst_n           (ap_rst_n           ), // input wire ap_rst_n
  
  .mua_stream_V_data_V_dout    (spk_tx_dout             ),        // input wire [191 : 0] mua_stream_V_data_V_dout
  .mua_stream_V_data_V_empty_n (!fifo_2_spk_tx_empty    ),        // input wire mua_stream_V_data_V_empty_n
  .mua_stream_V_data_V_read    (spk_packet_tx_read      ),        // output wire mua_stream_V_data_V_read
  
  .out_pre_TVALID     (out_pre_TVALID     ), // output wire out_pre_TVALID
  .out_pre_TREADY     (pre_in_TREADY      ), // *** input wire out_pre_TREADY ***
  .out_pre_TUSER      (out_pre_TUSER      ), // output wire [7 : 0] out_pre_TUSER
  .out_pre_TDATA      (out_pre_TDATA      ), // output wire [127 : 0] out_pre_TDATA
  .out_pre_TID        (out_pre_TID        ), // output wire [15 : 0] out_pre_TID
  .out_pre_TDEST      (out_pre_TDEST      ), // output wire [0 : 0] out_pre_TDEST
  .out_pre_TLAST      (out_pre_TLAST      ), // output wire [0 : 0] out_pre_TLAST

  .out_post_TVALID    (out_post_TVALID    ), // output wire out_post_TVALID
  .out_post_TREADY    (post_in_TREADY     ), // *** input wire out_post_TREADY ***
  .out_post_TUSER     (out_post_TUSER     ), // output wire [7 : 0] out_post_TUSER
  .out_post_TDATA     (out_post_TDATA     ), // output wire [127 : 0] out_post_TDATA
  .out_post_TID       (out_post_TID       ), // output wire [15 : 0] out_post_TID
  .out_post_TDEST     (out_post_TDEST     ), // output wire [0 : 0] out_post_TDEST
  .out_post_TLAST     (out_post_TLAST     ), // output wire [0 : 0] out_post_TLAST
  
  .time_stamp_V_TVALID(time_stamp_TVALID  ), // output wire time_stamp_V_TVALID
  .time_stamp_V_TREADY(time_in_TREADY     ), // *** input wire time_stamp_V_TREADY ***
  .time_stamp_V_TDATA (time_stamp_TDATA   ) // output wire [31 : 0] time_stamp_V_TDATA
  
);

/////////////////////////////////////////////////
// RX: 
/////////////////////////////////////////////////

// Three ready singal give back pressure to TX module
wire pre_in_TREADY;
wire post_in_TREADY;
wire time_in_TREADY;

// spk_stream: final output (spike waveforms with (ch,t) side info)
(* mark_debug = "true" *) wire spk_stream_TVALID  ;
wire [127:0] spk_stream_TDATA   ;

spk_packet_rx_0 spk_packet_rx (
  .ap_clk               (clk                   ), // input wire ap_clk
  .ap_rst_n             (ap_rst_n              ), // input wire ap_rst_n
  .ap_start             (ap_start              ), // input wire ap_start
  .ap_done              (ap_done               ), // output wire ap_done
  .ap_idle              (ap_idle               ), // output wire ap_idle
  .ap_ready             (ap_ready              ), // output wire ap_ready

  .pre_in_TVALID        (out_pre_TVALID        ), // input wire pre_in_TVALID
  .pre_in_TREADY        (pre_in_TREADY         ), // output wire pre_in_TREADY
  .pre_in_TUSER         (out_pre_TUSER         ), // input wire [4 : 0] pre_in_TUSER
  .pre_in_TDATA         (out_pre_TDATA         ), // input wire [127 : 0] pre_in_TDATA
  .pre_in_TLAST         (out_pre_TLAST         ), // input wire [0 : 0] pre_in_TLAST
  .pre_in_TID           (out_pre_TID           ), // input wire [15 : 0] pre_in_TID
  .pre_in_TDEST         (out_pre_TDEST         ), // input wire [0 : 0] pre_in_TDEST

  .post_in_TVALID       (out_post_TVALID       ), // input wire post_in_TVALID
  .post_in_TREADY       (post_in_TREADY        ), // output wire post_in_TREADY
  .post_in_TUSER        (out_post_TUSER        ), // input wire [4 : 0] post_in_TUSER
  .post_in_TDATA        (out_post_TDATA        ), // input wire [127 : 0] post_in_TDATA
  .post_in_TLAST        (out_post_TLAST        ), // input wire [0 : 0] post_in_TLAST
  .post_in_TID          (out_post_TID          ), // input wire [15 : 0] post_in_TID
  .post_in_TDEST        (out_post_TDEST        ), // input wire [0 : 0] post_in_TDEST

  .time_stamp_V_TVALID  (time_stamp_TVALID     ), // input wire time_stamp_V_TVALID
  .time_stamp_V_TREADY  (time_in_TREADY        ), // output wire time_stamp_V_TREADY
  .time_stamp_V_TDATA   (time_stamp_TDATA      ), // input wire [31 : 0] time_stamp_V_TDATA

  .spk_out_stream_V_data_V_TVALID (spk_stream_TVALID     ), // output wire spk_out_stream_TVALID             | valid
  .spk_out_stream_V_data_V_TREADY (1                     ), // input wire spk_out_stream_TREADY              | ***** always ready!
  .spk_out_stream_V_data_V_TDATA  (spk_stream_TDATA      )  // output wire [127 : 0] spk_out_stream_TDATA    | spk waveform
);

// (* mark_debug = "true" *) 
(* mark_debug = "true" *) wire signed [31:0] spk_stream_ch_nn0;
(* mark_debug = "true" *) wire signed [31:0] spk_stream_ch_nn1;
(* mark_debug = "true" *) wire signed [31:0] spk_stream_ch_nn2;
(* mark_debug = "true" *) wire signed [31:0] spk_stream_ch_nn3;
assign spk_stream_ch_nn0 = spk_stream_TDATA[127:96] & {32{spk_stream_TVALID}};
assign spk_stream_ch_nn1 = spk_stream_TDATA[ 95:64] & {32{spk_stream_TVALID}};
assign spk_stream_ch_nn2 = spk_stream_TDATA[ 63:32] & {32{spk_stream_TVALID}};
assign spk_stream_ch_nn3 = spk_stream_TDATA[ 31:0 ] & {32{spk_stream_TVALID}};

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// spk_stream_TVALID level to pulse
// detect a start of one single spike stream
// spk_stream: final output (spike waveforms with (ch,t) side info)
(* mark_debug = "true" *) wire spk_stream_pulse;
reg spk_stream_TVALID_delay;
assign spk_stream_pulse = (spk_stream_TVALID_delay ^ spk_stream_TVALID) & spk_stream_TVALID;

always @(posedge clk) begin
    if(rst) spk_stream_TVALID_delay <= 0;
    else    spk_stream_TVALID_delay <= spk_stream_TVALID;
end
///////////////////////////////////////////////////////////////////////////////////////////////////////////



endmodule

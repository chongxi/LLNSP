//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
// 
// Create Date: 04/03/2016 05:03:55 PM
// Design Name: spkDet
// Module Name: spkDet
// Project Name: Xike
// Target Devices: KC705
// Tool Versions: Vivado 2016.1
// Description: 
// Find peak! 
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// 
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module spkPack (
  input                 clk              ,
  input                 rst              ,
  input         [ 31:0] frame_No_in      ,
  input         [ 11:0] ch_in            ,
  input         [ 31:0] ch_unigroup_in   ,
  input                 valid_in         ,
  input  signed [ 31:0] v_in             ,
  input                 is_peak_in       ,
//  // mua
//  output                valid_mua_out    ,
//  output signed [ 31:0] v_mua_out        ,
//  output                valid_spk_out    ,
//  // spk (t,ch)
//  output signed [ 31:0] v_spk_t_out      ,
//  output signed [ 31:0] v_spk_ch_out     ,
  // spk waveform
  output                spk_stream_TVALID,
  output        [ 11:0] spk_stream_CH    ,
  output        [ 31:0] spk_stream_TIME  ,
  output        [ 15:0] spk_stream_TDEST ,
  output signed [127:0] spk_stream_TDATA ,
  output                spk_stream_pulse
);

parameter NUM_CH    = 160;
parameter WIDTH_CH  = 12;
// parameter WIDTH_CH = $clog2(NUM_CH);
parameter SPK_LENTH = 19;   //19:25kHz; 23:30kHz

////////////////////////////////////////////////////////////////
// input pad

reg [        31:0] frame_No_buf   ;
reg                valid_buf      ;
reg [        31:0] v_buf          ;
reg [WIDTH_CH-1:0] ch_buf         ;
reg [        31:0] ch_unigroup_buf;
reg                peak_buf       ;

always @(posedge clk)
  begin : pipeline_mua_internal // 1 buf
    frame_No_buf    <= frame_No_in;
    valid_buf       <= valid_in;
    v_buf           <= v_in;
    ch_buf          <= ch_in;
    ch_unigroup_buf <= ch_unigroup_in;
    peak_buf        <= is_peak_in;
  end

(* mark_debug = "true" *) reg [        31:0] frame_No_bufo   ;
(* mark_debug = "true" *) reg                valid_bufo       ;
(* mark_debug = "true" *) reg [WIDTH_CH-1:0] ch_bufo          ;
(* mark_debug = "true" *) reg [WIDTH_CH-1:0] ch_last_bufo     ;
reg [        31:0] ch_unigroup_bufo;
reg                peak_bufo       ;
reg [        31:0] v_bufo          ;

always @(posedge clk)
  begin : pipeline_mua_output // 2 buf
    frame_No_bufo    <= frame_No_buf          ;
    valid_bufo       <= valid_buf             ;
    v_bufo           <= v_buf                 ;
    ch_bufo          <= ch_buf                ;
    ch_last_bufo     <= ch_unigroup_buf[31:24];
    ch_unigroup_bufo <= ch_unigroup_buf       ;
    peak_bufo        <= peak_buf              ;
  end

/////////////////////////////////////////////////////////////////
// spk_ch output
//reg               valid_spk_buf;
//reg signed [31:0] v_spk_t_buf     ;   
//reg signed [31:0] v_spk_ch_buf    ;

//always @(posedge clk) begin : proc_spk_output
//    if(peak_bufo) begin
//        valid_spk_buf   <= peak_bufo;
//        v_spk_t_buf     <= frame_No_bufo;
//        v_spk_ch_buf    <= ch_bufo;
//    end
//    else begin
//        valid_spk_buf   <= 0;
//        v_spk_t_buf     <= 0;
//        v_spk_ch_buf    <= 0;
//    end
//end

//assign valid_spk_out    = valid_spk_buf;
//assign v_spk_t_out      = v_spk_t_buf;
//assign v_spk_ch_out     = v_spk_ch_buf;

//// mua output
//assign valid_mua_out    = valid_bufo;
//assign v_mua_out        = v_bufo;



////////////////////////////////////////////////////////////////
// level to pulse
// detect frameNo change
wire frame_pulse;
assign frame_pulse = frame_No_bufo[0] ^ frame_No_buf[0];

////////////////////////////////////////////////////////////////
/////////////////// channel binding ////////////////////////////
// (* mark_debug = "true" *)

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
// (* mark_debug = "true" *) 
reg j; 
reg j_buf;


always @(posedge clk) begin : proc_buf_2d
//  if(rst) 
//  begin
//    for(i=0; i<NUM_CH-1; i=i+1) buf_2d[0][i] <= 0;
//    for(i=0; i<NUM_CH-1; i=i+1) buf_2d[1][i] <= 0;
//  end 
//  else 
  begin
    if(valid_bufo) buf_2d[j][ch_bufo] <= v_bufo;        // write j buf
  end
end

always @(posedge clk) begin : proc_j
  if(rst) begin
    j_buf <= 0;
  end else begin
    if(frame_pulse) j_buf <= ~j_buf;
  end
end

always @(posedge clk) begin
    j <= j_buf;
end

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


// --------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------
// Below are HLS USER IP for spike extraction protocol
// The output is spike stream feeding the queue to the classifier 
// --------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------
// Spk packet protocol tx and rx (point extractor)

// rst
// ap
// (* mark_debug = "true" *) 
wire ap_start;   // rx
wire ap_ready;   // rx
wire ap_done;    // rx
wire ap_idle;    // rx
wire ap_rst_n;   // tx && rx

assign ap_rst_n = !rst;
assign ap_start = ap_rst_n;

// TX:
// pre output
wire [127:0] out_pre_TDATA; 
// (* mark_debug = "true" *) 
wire [7 :0] out_pre_TUSER;
wire [11:0] out_pre_TID;
wire [0:0 ] out_pre_TVALID;
wire [0:0 ] out_pre_TLAST;
wire [0:0 ] out_pre_TDEST;

// post output
wire [127:0] out_post_TDATA;
// (* mark_debug = "true" *) 
(* mark_debug = "true" *) wire [7 :0] out_post_TUSER;
(* mark_debug = "true" *) wire [11:0] out_post_TID;
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
reg  [127:0] tetrode_bufo;

always @(posedge clk) begin : proc_bundle_input
    spk_tx_wen   <= valid_bufo;
    tetrode_bufo <= multi_channel_muao;
    spk_tx_din   <= {{4'b0, ch_last_bufo}, {4'b0, ch_bufo}, frame_No_bufo, multi_channel_muao};
end

(* mark_debug = "true" *) wire spk_packet_tx_read;
(* mark_debug = "true" *) wire fifo_2_spk_tx_empty;

fifo_192_to_192 fifo_2_spk_tx (
  .clk(clk),      // input wire clk
  .rst(rst),     // input wire srst

  .wr_en(spk_tx_wen),    // input wire wr_en
  .din  (spk_tx_din),      // input wire [191 : 0] din

  .rd_en (spk_packet_tx_read ),  // input wire rd_en
  .dout  (spk_tx_dout        ),    // output wire [191 : 0] dout
  .full  (fifo_2_spk_tx_full ),    // output wire full
  .empty (fifo_2_spk_tx_empty)  // output wire empty
);

wire [127:0] tetrode_data = spk_tx_dout[127:0];
(* mark_debug = "true" *) wire [31:0 ] t_in         = spk_tx_dout[159:128];
(* mark_debug = "true" *) wire [15:0 ] channel      = spk_tx_dout[175:160];
(* mark_debug = "true" *) wire [15:0 ] last_channel = spk_tx_dout[191:176];

spk_packet_tx_0 spk_packet_tx (
  .ap_clk             (clk                ), // input wire ap_clk
  .ap_rst_n           (ap_rst_n           ), // input wire ap_rst_n
  
  .mua_stream_V_data_V_dout    (spk_tx_dout             ),        // input wire [191 : 0] mua_stream_V_data_V_dout
  .mua_stream_V_data_V_empty_n (!fifo_2_spk_tx_empty    ),        // input wire mua_stream_V_data_V_empty_n
  .mua_stream_V_data_V_read    (spk_packet_tx_read      ),        // output wire mua_stream_V_data_V_read
  
//  .mua_stream_TVALID  (spk_packet_tx_valid), // input wire mua_stream_TVALID
//  .mua_stream_TREADY  (spk_packet_tx_ready), // output wire mua_stream_TREADY
//  .mua_stream_TUSER   (t_in               ), // input wire [31 : 0] mua_stream_TUSER       // t_in
//  .mua_stream_TDATA   (tetrode_data       ), // input wire [127 : 0] mua_stream_TDATA      // tetrode data
//  .mua_stream_TID     (channel            ), // input wire [11 : 0] mua_stream_TID         // channel
//  .mua_stream_TDEST   (last_channel       ), // input wire [11 : 0] mua_stream_TDEST       // last channel in ch_group

  .out_pre_TVALID     (out_pre_TVALID     ), // output wire out_pre_TVALID
  .out_pre_TREADY     (pre_in_TREADY      ), // *** input wire out_pre_TREADY ***
  .out_pre_TUSER      (out_pre_TUSER      ), // output wire [7 : 0] out_pre_TUSER
  .out_pre_TDATA      (out_pre_TDATA      ), // output wire [127 : 0] out_pre_TDATA
  .out_pre_TID        (out_pre_TID        ), // output wire [11 : 0] out_pre_TID
  .out_pre_TDEST      (out_pre_TDEST      ), // output wire [0 : 0] out_pre_TDEST
  .out_pre_TLAST      (out_pre_TLAST      ), // output wire [0 : 0] out_pre_TLAST

  .out_post_TVALID    (out_post_TVALID    ), // output wire out_post_TVALID
  .out_post_TREADY    (post_in_TREADY     ), // *** input wire out_post_TREADY ***
  .out_post_TUSER     (out_post_TUSER     ), // output wire [7 : 0] out_post_TUSER
  .out_post_TDATA     (out_post_TDATA     ), // output wire [127 : 0] out_post_TDATA
  .out_post_TID       (out_post_TID       ), // output wire [11 : 0] out_post_TID
  .out_post_TDEST     (out_post_TDEST     ), // output wire [0 : 0] out_post_TDEST
  .out_post_TLAST     (out_post_TLAST     ), // output wire [0 : 0] out_post_TLAST
  
  .time_stamp_V_TVALID(time_stamp_TVALID  ), // output wire time_stamp_V_TVALID
  .time_stamp_V_TREADY(time_in_TREADY     ), // *** input wire time_stamp_V_TREADY ***
  .time_stamp_V_TDATA (time_stamp_TDATA   ) // output wire [31 : 0] time_stamp_V_TDATA
  
//  .busy_V             (busy_A             ), // output wire [31 : 0] busy_V
//  .busy_V_ap_vld      (busy_A_vld         )
);

// RX: 
// Three ready singal back pressure to TX module
// (* mark_debug = "true" *) 
wire pre_in_TREADY;
wire post_in_TREADY;
wire time_in_TREADY;

// spk_stream: final output (spike waveforms with (ch,t) side info)
(* mark_debug = "true" *) wire         spk_stream_TVALID  ;
(* mark_debug = "true" *) wire [ 11:0] spk_stream_CH      ;
(* mark_debug = "true" *) wire [ 31:0] spk_stream_TIME    ;
wire [ 31:0] spk_stream_TIME_TMP;
(* mark_debug = "true" *) wire [ 15:0] spk_stream_TDEST   ;
wire [127:0] spk_stream_TDATA   ;
assign spk_stream_TIME = spk_stream_TIME_TMP - 1;

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
  .pre_in_TID           (out_pre_TID           ), // input wire [11 : 0] pre_in_TID
  .pre_in_TDEST         (out_pre_TDEST         ), // input wire [0 : 0] pre_in_TDEST

  .post_in_TVALID       (out_post_TVALID       ), // input wire post_in_TVALID
  .post_in_TREADY       (post_in_TREADY        ), // output wire post_in_TREADY
  .post_in_TUSER        (out_post_TUSER        ), // input wire [4 : 0] post_in_TUSER
  .post_in_TDATA        (out_post_TDATA        ), // input wire [127 : 0] post_in_TDATA
  .post_in_TLAST        (out_post_TLAST        ), // input wire [0 : 0] post_in_TLAST
  .post_in_TID          (out_post_TID          ), // input wire [11 : 0] post_in_TID
  .post_in_TDEST        (out_post_TDEST        ), // input wire [0 : 0] post_in_TDEST

  .time_stamp_V_TVALID  (time_stamp_TVALID     ), // input wire time_stamp_V_TVALID
  .time_stamp_V_TREADY  (time_in_TREADY        ), // output wire time_stamp_V_TREADY
  .time_stamp_V_TDATA   (time_stamp_TDATA      ), // input wire [31 : 0] time_stamp_V_TDATA

  .spk_out_stream_TVALID(spk_stream_TVALID     ), // output wire spk_out_stream_TVALID             | valid
  .spk_out_stream_TREADY(1                     ), // input wire spk_out_stream_TREADY              | ***** always ready!
  .spk_out_stream_TID   (spk_stream_CH         ), // output wire [11 : 0] spk_out_stream_TID       | channel
  .spk_out_stream_TUSER (spk_stream_TIME_TMP   ), // output wire [31 : 0] spk_out_stream_TUSER     | time stamp
  .spk_out_stream_TDEST (spk_stream_TDEST      ), // output wire [15 : 0] spk_out_stream_TDEST     | 0-spklen
  .spk_out_stream_TDATA (spk_stream_TDATA      )  // output wire [127 : 0] spk_out_stream_TDATA    | spk waveform
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

//////////////////////////////////////////////////////
// spk_stream_TVALID level to pulse
// detect a start of one single spike stream
wire spk_stream_pulse;
reg spk_stream_TVALID_delay;
assign spk_stream_pulse = (spk_stream_TVALID_delay ^ spk_stream_TVALID) & spk_stream_TVALID;

always @(posedge clk) begin
    if(rst) spk_stream_TVALID_delay <= 0;
    else    spk_stream_TVALID_delay <= spk_stream_TVALID;
end

///////////////////////////////////////////////////////////////////////////////////////////////////////////


endmodule

//////////////////////////////////////////////////////////////////////////////////
// Company:  HHMI Janelia
// Engineer: Chongxi Lai
//
// Create Date: 04/12/2017 10:01:22 PM
// Design Name: raw_comb
// Module Name: raw_comb
// Project Name: Xike
// Target Devices: KC705
// Tool Versions: Vivado 2015.6
// Description:
//
// select the first 5 streams from the SPI 16 stream output
// Each stream iterate from ch0 -> ch32 (That is a RHD2132 Intan chip which multiplex 32 channel as 1 data stream)
//
// ChNo:      0   32    64    96    128   |   1   33  65    97    129   |   2   34     ...
// StreamNo:  0   1     2     3     4     |   0   1   2     3     4     |   0   1      ...
//
// StreamNo is in onehot manner
// 00001: stream0 => FIFO0
// 00010: stream1 => FIFO1
// 00100: stream2 => FIFO2
// 01000: stream3 => FIFO3
// 10000: stream4 => FIFO4
//
// AXI4-Stream Combiner synchronize 5 stream 16bits input and output 80bits single stream
//          ------------
// FIFO0 => |          |
// FIFO1 => |          |
// FIFO2 => | AXI-COMB | => 80bits (16bits * 5)
// FIFO3 => |          |
// FIFO4 => |          |
//          ------------
//
// Dependencies:
// 1. FWFT
// 2. AXI4-Stream Combiner
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module raw_comb_5_streams (
  input         spi_clk              ,
  input         bus_clk              ,
  input         xike_reset           ,
  input  [ 4:0] FIFO_STREAMNO_TO_XIKE, // 16 streams but we only use 5 now
  input  [31:0] SPI_TO_XIKE_BUNDLE   ,
  input         raw_comb_ready       , // From downstream module (pcie-fifo our FIR)
  output        raw_comb_valid       , // To downstream module
  output [79:0] raw_comb_data        , // To downstream module
  output [59:0] raw_comb_ch
);

  wire [31:0] fifo0_dout;
  wire [31:0] fifo1_dout;
  wire [31:0] fifo2_dout;
  wire [31:0] fifo3_dout;
  wire [31:0] fifo4_dout;

  wire [4 :0] fifo_empty              ;
  wire [4 :0] raw_ready               ;
  wire [4 :0] raw_valid  = ~fifo_empty;
  wire [79:0] raw_data                ;
  wire [59:0] raw_ch                  ;

  fwft_fifo fifo_spi_to_fir_0 (
    .rst   (xike_reset                    ), // input wire rst
    .wr_clk(spi_clk                       ), // input wire wr_clk
    .rd_clk(bus_clk                       ), // input wire rd_clk
    .wr_en (FIFO_STREAMNO_TO_XIKE[0]      ), // input wire wr_en
    .din   (SPI_TO_XIKE_BUNDLE            ), // input wire [31 : 0] din
    .rd_en (raw_ready[0] && !fifo_empty[0]), // input wire rd_en
    .dout  (fifo0_dout                    ), // output wire [31 : 0] dout
    .full  (fifo0_full                    ), // output wire full
    .empty (fifo_empty[0]                 )  // output wire empty
  );

  fwft_fifo fifo_spi_to_fir_1 (
    .rst   (xike_reset                    ), // input wire rst
    .wr_clk(spi_clk                       ), // input wire wr_clk
    .rd_clk(bus_clk                       ), // input wire rd_clk
    .wr_en (FIFO_STREAMNO_TO_XIKE[1]      ), // input wire wr_en
    .din   (SPI_TO_XIKE_BUNDLE            ), // input wire [31 : 0] din
    .rd_en (raw_ready[1] && !fifo_empty[1]), // input wire rd_en
    .dout  (fifo1_dout                    ), // output wire [31 : 0] dout
    .full  (fifo1_full                    ), // output wire full
    .empty (fifo_empty[1]                 )  // output wire empty
  );

  fwft_fifo fifo_spi_to_fir_2 (
    .rst   (xike_reset                    ), // input wire rst
    .wr_clk(spi_clk                       ), // input wire wr_clk
    .rd_clk(bus_clk                       ), // input wire rd_clk
    .wr_en (FIFO_STREAMNO_TO_XIKE[2]      ), // input wire wr_en
    .din   (SPI_TO_XIKE_BUNDLE            ), // input wire [31 : 0] din
    .rd_en (raw_ready[2] && !fifo_empty[2]), // input wire rd_en
    .dout  (fifo2_dout                    ), // output wire [31 : 0] dout
    .full  (fifo2_full                    ), // output wire full
    .empty (fifo_empty[2]                 )  // output wire empty
  );

  fwft_fifo fifo_spi_to_fir_3 (
    .rst   (xike_reset                    ), // input wire rst
    .wr_clk(spi_clk                       ), // input wire wr_clk
    .rd_clk(bus_clk                       ), // input wire rd_clk
    .wr_en (FIFO_STREAMNO_TO_XIKE[3]      ), // input wire wr_en
    .din   (SPI_TO_XIKE_BUNDLE            ), // input wire [31 : 0] din
    .rd_en (raw_ready[3] && !fifo_empty[3]), // input wire rd_en
    .dout  (fifo3_dout                    ), // output wire [31 : 0] dout
    .full  (fifo3_full                    ), // output wire full
    .empty (fifo_empty[3]                 )  // output wire empty
  );

  fwft_fifo fifo_spi_to_fir_4 (
    .rst   (xike_reset                    ), // input wire rst
    .wr_clk(spi_clk                       ), // input wire wr_clk
    .rd_clk(bus_clk                       ), // input wire rd_clk
    .wr_en (FIFO_STREAMNO_TO_XIKE[4]      ), // input wire wr_en
    .din   (SPI_TO_XIKE_BUNDLE            ), // input wire [31 : 0] din
    .rd_en (raw_ready[4] && !fifo_empty[4]), // input wire rd_en
    .dout  (fifo4_dout                    ), // output wire [31 : 0] dout
    .full  (fifo4_full                    ), // output wire full
    .empty (fifo_empty[4]                 )  // output wire empty
  );

  wire [15:0] raw_data_0 = fifo0_dout[15: 0];
  wire [15:0] raw_data_1 = fifo1_dout[15: 0];
  wire [15:0] raw_data_2 = fifo2_dout[15: 0];
  wire [15:0] raw_data_3 = fifo3_dout[15: 0];
  wire [15:0] raw_data_4 = fifo4_dout[15: 0];
 
  wire [11:0] raw_ch_0   = fifo0_dout[28:17];
  wire [11:0] raw_ch_1   = fifo1_dout[28:17];
  wire [11:0] raw_ch_2   = fifo2_dout[28:17];
  wire [11:0] raw_ch_3   = fifo3_dout[28:17];
  wire [11:0] raw_ch_4   = fifo4_dout[28:17];  

  assign raw_data = {raw_data_4, raw_data_3, raw_data_2, raw_data_1, raw_data_0};
  assign raw_ch   = {raw_ch_4,   raw_ch_3,   raw_ch_2,   raw_ch_1,   raw_ch_0};

  axis_combiner axi_stream_combiner (
    .aclk         (bus_clk       ),   // input wire aclk
    .aresetn      (!xike_reset   ),   // input wire aresetn
    .s_axis_tready(raw_ready     ),   // output wire [4 : 0] s_axis_tready
    .s_axis_tvalid(raw_valid     ),   // input wire  [4 : 0] s_axis_tvalid
    .s_axis_tdata (raw_data      ),   // input wire  [79 : 0] s_axis_tdata
    .s_axis_tuser (raw_ch        ),   // input wire  [59 : 0] s_axis_tuser
    .m_axis_tready(raw_comb_ready),   // input wire m_axis_tready
    .m_axis_tvalid(raw_comb_valid),   // output wire m_axis_tvalid
    .m_axis_tdata (raw_comb_data ),   // output wire [79 : 0] m_axis_tdata
    .m_axis_tuser (raw_comb_ch   )    // output wire [59 : 0] m_axis_tuser
  );

endmodule
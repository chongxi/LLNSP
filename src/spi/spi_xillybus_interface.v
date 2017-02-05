module spi_xillybus_interface (
	input         bus_clk                    , //
	input         dataclk                    , //
	input         reset                      , //

	input  [15:0] FIFO_DATA_STREAM           ,
	input         FIFO_DATA_STREAM_WEN       ,

	input		  user_r_neural_data_32_open ,
	input         user_r_neural_data_32_empty,
	input         user_r_neural_data_32_rden ,
	output        user_r_neural_data_32_eof  ,
	output [31:0] user_r_neural_data_32_data ,
);

  wire [31:0] data_reverse ;
  wire        fifo_full    ;
  wire        fifo_reset   ;
  wire        fifo_wen     ;
  reg         fifo_overflow;

  assign fifo_reset = reset | ~user_r_neural_data_32_open;  //reset the fifo when the pipe closes even if the interface is opened
  assign fifo_wen   = FIFO_DATA_STREAM_WEN & ~fifo_overflow; //If the fifo overflows, stop writing to it

  fifo_w16_4096_r32_2048 data_fifo (
    .rst       (fifo_reset                 ),
    .wr_clk    (dataclk                    ),
    .rd_clk    (bus_clk                    ),
    .din       (FIFO_DATA_STREAM           ),
    .wr_en     (fifo_wen                   ),
    .rd_en     (user_r_neural_data_32_rden ),
    .dout      (data_reverse               ),
    .full      (fifo_full                  ),
    .empty     (user_r_neural_data_32_empty)
  );

  assign user_r_neural_data_32_eof  = fifo_overflow & user_r_neural_data_32_empty; //Generate EOF after overflow (this helps signal overflow to the host)
  assign user_r_neural_data_32_data = {data_reverse[15:0], data_reverse[31:16]}; //To keep a "16-bit endianess"-like format, to avoid rewriting the existing Rhythm API, which used 16bit words for transmission

  //fifo_overflow goes to 1 when there the fifo is full and only resets on fifo reset (file close or global reset)
  always @(posedge dataclk or posedge fifo_reset)
    begin
      if (fifo_reset)
        fifo_overflow <= 1'b0;
      else
        begin
          if (fifo_full & fifo_wen) fifo_overflow <= 1'b1;
        end
    end

endmodule
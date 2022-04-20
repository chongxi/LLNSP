module mua_reorder_ti (
    input         clk           , // Clock
    input         rst           , // Asynchronous reset active low
    // input
    input         muar_valid    ,
    input  [31:0] muar_data     ,
    // output
    output        muao_valid    ,
    output [31:0] muao_data       // muap
);

 (* mark_debug = "true" *)    wire ap_rst_n = !rst;
 (* mark_debug = "true" *)    wire [31:0] muar_stream_V_data_V_dout;
 (* mark_debug = "true" *)    wire muar_stream_V_data_V_read;
 (* mark_debug = "true" *)    wire fifo_muar_input_empty;
 (* mark_debug = "true" *)    wire fifo_muar_input_full;

    fwft_fifo_32 mua_input_fifo_to_reorder (
        .clk  (clk                                ),
        .srst (rst                                ),
        .wr_en(muar_valid && !fifo_muar_input_full), // AXI4 valid and ready
        .din  (muar_data                          ), // mua_data
        .rd_en(muar_stream_V_data_V_read          ),
        .dout (muar_stream_V_data_V_dout          ),
        .full (fifo_muar_input_full               ),
        .empty(fifo_muar_input_empty              )
    );

    mua_reorder_1 i_mua_reorder_1 (
        .ap_clk                      (clk                      ),
        .ap_rst_n                    (ap_rst_n                 ),
        .muar_stream_V_data_V_dout   (muar_stream_V_data_V_dout),
        .muar_stream_V_data_V_empty_n(!fifo_muar_input_empty   ),
        .muar_stream_V_data_V_read   (muar_stream_V_data_V_read),   // hls FIFO interface only read FWFT fifo
        .muao_stream_V_data_V_TREADY (1                        ),   // always ready to output axi-stream
        .muao_stream_V_data_V_TVALID (muao_valid               ),
        .muao_stream_V_data_V_TDATA  (muao_data                )
    );

endmodule
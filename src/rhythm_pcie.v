module rhythm_pcie (
  input        SYSCLK_P        ,
  input        SYSCLK_N        ,
  input        PCIE_PERST_B_LS ,
  input        PCIE_REFCLK_N   ,
  input        PCIE_REFCLK_P   ,
  input  [7:0] PCIE_RX_N       ,
  input  [7:0] PCIE_RX_P       ,
  output [3:0] GPIO_LED        ,
  output [7:0] PCIE_TX_N       ,
  output [7:0] PCIE_TX_P       ,
  output       RESET_LED       ,
  output       SPI_LED         ,
  output       OVERFLOW_LED    ,
  input        MISO_C1_PORT    ,
  input        MISO_C2_PORT    ,
  output       MOSI_C_PORT     ,
  output       SCLK_C_PORT     ,
  output       CS_C_PORT
);

// ------- XILLYBUS -------------------------------------------------------------------------------------------

  xillybus xillybus_ins (
    // Ports related to /dev/xillybus_auxcmd1_membank_16
    // CPU to FPGA signals:
    .user_w_auxcmd1_membank_16_wren     (user_w_auxcmd1_membank_16_wren     ),
    .user_w_auxcmd1_membank_16_full     (user_w_auxcmd1_membank_16_full     ),
    .user_w_auxcmd1_membank_16_data     (user_w_auxcmd1_membank_16_data     ),
    .user_w_auxcmd1_membank_16_open     (user_w_auxcmd1_membank_16_open     ),
    
    // Address signals:
    .user_auxcmd1_membank_16_addr       (user_auxcmd1_membank_16_addr       ),
    .user_auxcmd1_membank_16_addr_update(user_auxcmd1_membank_16_addr_update),
    
    
    // Ports related to /dev/xillybus_auxcmd2_membank_16
    // CPU to FPGA signals:
    .user_w_auxcmd2_membank_16_wren     (user_w_auxcmd2_membank_16_wren     ),
    .user_w_auxcmd2_membank_16_full     (user_w_auxcmd2_membank_16_full     ),
    .user_w_auxcmd2_membank_16_data     (user_w_auxcmd2_membank_16_data     ),
    .user_w_auxcmd2_membank_16_open     (user_w_auxcmd2_membank_16_open     ),
    
    // Address signals:
    .user_auxcmd2_membank_16_addr       (user_auxcmd2_membank_16_addr       ),
    .user_auxcmd2_membank_16_addr_update(user_auxcmd2_membank_16_addr_update),
    
    
    // Ports related to /dev/xillybus_auxcmd3_membank_16
    // CPU to FPGA signals:
    .user_w_auxcmd3_membank_16_wren     (user_w_auxcmd3_membank_16_wren     ),
    .user_w_auxcmd3_membank_16_full     (user_w_auxcmd3_membank_16_full     ),
    .user_w_auxcmd3_membank_16_data     (user_w_auxcmd3_membank_16_data     ),
    .user_w_auxcmd3_membank_16_open     (user_w_auxcmd3_membank_16_open     ),
    
    // Address signals:
    .user_auxcmd3_membank_16_addr       (user_auxcmd3_membank_16_addr       ),
    .user_auxcmd3_membank_16_addr_update(user_auxcmd3_membank_16_addr_update),
    
    
    // Ports related to /dev/xillybus_control_regs_16
    // FPGA to CPU signals:
    .user_r_control_regs_16_rden        (user_r_control_regs_16_rden        ),
    .user_r_control_regs_16_empty       (user_r_control_regs_16_empty       ),
    .user_r_control_regs_16_data        (user_r_control_regs_16_data        ),
    .user_r_control_regs_16_eof         (user_r_control_regs_16_eof         ),
    .user_r_control_regs_16_open        (user_r_control_regs_16_open        ),
    
    // CPU to FPGA signals:
    .user_w_control_regs_16_wren        (user_w_control_regs_16_wren        ),
    .user_w_control_regs_16_full        (user_w_control_regs_16_full        ),
    .user_w_control_regs_16_data        (user_w_control_regs_16_data        ),
    .user_w_control_regs_16_open        (user_w_control_regs_16_open        ),
    
    // Address signals:
    .user_control_regs_16_addr          (user_control_regs_16_addr          ),
    .user_control_regs_16_addr_update   (user_control_regs_16_addr_update   ),
    
    
    // Ports related to /dev/xillybus_neural_data_32
    // FPGA to CPU signals:
    .user_r_neural_data_32_rden         (user_r_neural_data_32_rden         ),
    .user_r_neural_data_32_empty        (user_r_neural_data_32_empty        ),
    .user_r_neural_data_32_data         (user_r_neural_data_32_data         ),
    .user_r_neural_data_32_eof          (user_r_neural_data_32_eof          ),
    .user_r_neural_data_32_open         (user_r_neural_data_32_open         ),
    
    
    // Ports related to /dev/xillybus_status_regs_16
    // FPGA to CPU signals:
    .user_r_status_regs_16_rden         (user_r_status_regs_16_rden         ),
    .user_r_status_regs_16_empty        (user_r_status_regs_16_empty        ),
    .user_r_status_regs_16_data         (user_r_status_regs_16_data         ),
    .user_r_status_regs_16_eof          (user_r_status_regs_16_eof          ),
    .user_r_status_regs_16_open         (user_r_status_regs_16_open         ),
    
    // Address signals:
    .user_status_regs_16_addr           (user_status_regs_16_addr           ),
    .user_status_regs_16_addr_update    (user_status_regs_16_addr_update    ),
    
    
    // General signals
    .PCIE_PERST_B_LS                    (PCIE_PERST_B_LS                    ),
    .PCIE_REFCLK_N                      (PCIE_REFCLK_N                      ),
    .PCIE_REFCLK_P                      (PCIE_REFCLK_P                      ),
    .PCIE_RX_N                          (PCIE_RX_N                          ),
    .PCIE_RX_P                          (PCIE_RX_P                          ),
    .GPIO_LED                           (GPIO_LED                           ),
    .PCIE_TX_N                          (PCIE_TX_N                          ),
    .PCIE_TX_P                          (PCIE_TX_P                          ),
    .bus_clk                            (bus_clk                            ),
    .quiesce                            (quiesce                            )
  );

  // Wires related to /dev/xillybus_auxcmd1_membank_16
  wire        user_w_auxcmd1_membank_16_wren     ;
  wire        user_w_auxcmd1_membank_16_full     ;
  wire [15:0] user_w_auxcmd1_membank_16_data     ;
  wire        user_w_auxcmd1_membank_16_open     ;
  wire [15:0] user_auxcmd1_membank_16_addr       ;
  wire        user_auxcmd1_membank_16_addr_update;

  // Wires related to /dev/xillybus_auxcmd2_membank_16
  wire        user_w_auxcmd2_membank_16_wren     ;
  wire        user_w_auxcmd2_membank_16_full     ;
  wire [15:0] user_w_auxcmd2_membank_16_data     ;
  wire        user_w_auxcmd2_membank_16_open     ;
  wire [15:0] user_auxcmd2_membank_16_addr       ;
  wire        user_auxcmd2_membank_16_addr_update;

  // Wires related to /dev/xillybus_auxcmd3_membank_16
  wire        user_w_auxcmd3_membank_16_wren     ;
  wire        user_w_auxcmd3_membank_16_full     ;
  wire [15:0] user_w_auxcmd3_membank_16_data     ;
  wire        user_w_auxcmd3_membank_16_open     ;
  wire [15:0] user_auxcmd3_membank_16_addr       ;
  wire        user_auxcmd3_membank_16_addr_update;

  // Wires related to /dev/xillybus_control_regs_16
  wire        user_r_control_regs_16_rden     ;
  wire        user_r_control_regs_16_empty    ;
  wire [15:0] user_r_control_regs_16_data     ;
  wire        user_r_control_regs_16_eof      ;
  wire        user_r_control_regs_16_open     ;
  wire        user_w_control_regs_16_wren     ;
  wire        user_w_control_regs_16_full     ;
  wire [15:0] user_w_control_regs_16_data     ;
  wire        user_w_control_regs_16_open     ;
  wire [ 4:0] user_control_regs_16_addr       ;
  wire        user_control_regs_16_addr_update;

  // Wires related to /dev/xillybus_status_regs_16
  wire        user_r_status_regs_16_rden     ;
  wire        user_r_status_regs_16_empty    ;
  wire [15:0] user_r_status_regs_16_data     ;
  wire        user_r_status_regs_16_eof      ;
  wire        user_r_status_regs_16_open     ;
  wire [ 4:0] user_status_regs_16_addr       ;
  wire        user_status_regs_16_addr_update;

  // Wires related to /dev/xillybus_neural_data_32
  wire        user_r_neural_data_32_rden ;
  wire        user_r_neural_data_32_empty;
  wire [31:0] user_r_neural_data_32_data ;
  wire        user_r_neural_data_32_eof  ;
  wire        user_r_neural_data_32_open ;


// ------- CLOCK -------------------------------------------------------------------------------------------

(* mark_debug = "true" *)   wire bus_clk;   // 250MHz PCIe clock
(* mark_debug = "true" *)   wire sys_clk;   // on-board 200 MHz clock
(* mark_debug = "true" *)   wire spi_clk;   // programmable frequency clock (f = 2800 * per-channel amplifier sampling rate) for SPI
(* mark_debug = "true" *)   wire reset = ~user_w_control_regs_16_open;

  // fout = fin * M / (D*O)
(* mark_debug = "true" *)  wire [7:0] dataclk_O;
(* mark_debug = "true" *)  wire [3:0] dataclk_D;
(* mark_debug = "true" *)  wire [6:0] dataclk_M;
  
  wire [3:0] dataclk_O2 = dataclk_O >> 1;
  wire [6:0] dataclk_D2 = dataclk_D >> 1;
  
  IBUFDS clkbuf (
      .I(SYSCLK_P),
      .IB(SYSCLK_N),
      .O(sys_clk)
  );

  wire debug_clk;

//  clk_500MHz clk_200
//   (
//   // Clock in ports
//    .clk_in1(sys_clk),      // input clk_in1
//    // Clock out ports
//    .clk_out1(dbg_clk)      // output clk_out1
//   );    
    
//    BUFG clkout_buf (
//        .O(clk200),
//        .I(dbg_clk)
//    );
    
  clock_generator clkgen (
    .config_clk_in(bus_clk         ),    // input
    .clk_in       (sys_clk         ),    // input
    .rst          (reset           ),    // input
    .O            (dataclk_O       ),    // input
    .D            (dataclk_D       ),    // input
    .M            (dataclk_M       ),    // input
    .start_sig    (PLL_prog_trigger),    // input 
    .ready        (PLL_prog_done   ),    // output
    .locked       (dataclk_locked  ),    // output
    .clk_out      (spi_clk         )     // output
  );  
  
  clock_generator clkgen_4x (
    .config_clk_in(bus_clk         ),    // input
    .clk_in       (sys_clk         ),    // input
    .rst          (reset           ),    // input
    .O            (dataclk_O2      ),    // input
    .D            (dataclk_D2      ),    // input
    .M            (dataclk_M       ),    // input
    .start_sig    (PLL_prog_trigger),    // input 
    .ready        (PLL_prog_done_4x),    // output
    .locked       (debug_clk_locked),    // output
    .clk_out      (debug_clk       )     // output
  );  

// SPI protocol signals ----------------------------------------------------------------------------------------

  //IO signals
(* mark_debug = "true" *)   wire SCLK;
(* mark_debug = "true" *)   wire CS;
(* mark_debug = "true" *)   wire MOSI_C;  
  wire MISO_A1, MISO_A2;
  wire MISO_B1, MISO_B2;
(* mark_debug = "true" *)   wire MISO_C1;
(* mark_debug = "true" *)   wire MISO_C2;
  wire MISO_D1, MISO_D2;

  //IO assigments
  assign MISO_A1 = 1'b0;
  assign MISO_A2 = 1'b0;
  assign MISO_B1 = 1'b0;
  assign MISO_B2 = 1'b0;
  assign MISO_C1 = MISO_C1_PORT;
  assign MISO_C2 = MISO_C2_PORT;
  assign MISO_D1 = 1'b0;
  assign MISO_D2 = 1'b0;

  assign SCLK_C_PORT = SCLK;
  assign MOSI_C_PORT = MOSI_C;
  assign CS_C_PORT   = CS;

  assign user_w_auxcmd1_membank_16_full = 1'b0;
  assign user_w_auxcmd2_membank_16_full = 1'b0;
  assign user_w_auxcmd3_membank_16_full = 1'b0;

  assign user_r_control_regs_16_empty = 1'b0;
  assign user_r_control_regs_16_eof = 1'b0;
  assign user_w_control_regs_16_full = 1'b0;
  
  assign user_r_status_regs_16_empty = 1'b0;
  assign user_r_status_regs_16_eof = 1'b0;

// SPI ------------------------------------------------------------------------------------------------------

  wire        PLL_prog_done        ;
  wire        dataclk_locked       ;
  wire        SPI_running          ;
  wire        MOSI_A               ;
  wire        MOSI_B               ;
  wire        MOSI_C               ;
  wire        MOSI_D               ;
  wire [15:0] FIFO_DATA_STREAM     ;
  wire        FIFO_DATA_STREAM_WEN ;
  wire [15:0] FIFO_DATA_TO_XIKE    ;
  wire        FIFO_DATA_TO_XIKE_WEN;

  SPI_4x spi_4x (
    .bus_clk                       (bus_clk                       ),
    .dataclk                       (spi_clk                       ),
    .reset                         (reset                         ),
    .PLL_prog_done                 (PLL_prog_done                 ),
    .dataclk_locked                (dataclk_locked                ),
    
    .user_w_auxcmd1_membank_16_wren(user_w_auxcmd1_membank_16_wren),
    .user_w_auxcmd1_membank_16_data(user_w_auxcmd1_membank_16_data),
    .user_auxcmd1_membank_16_addr  (user_auxcmd1_membank_16_addr  ),
    .user_w_auxcmd2_membank_16_wren(user_w_auxcmd2_membank_16_wren),
    .user_w_auxcmd2_membank_16_data(user_w_auxcmd2_membank_16_data),
    .user_auxcmd2_membank_16_addr  (user_auxcmd2_membank_16_addr  ),
    .user_w_auxcmd3_membank_16_wren(user_w_auxcmd3_membank_16_wren),
    .user_w_auxcmd3_membank_16_data(user_w_auxcmd3_membank_16_data),
    .user_auxcmd3_membank_16_addr  (user_auxcmd3_membank_16_addr  ),
    .user_r_control_regs_16_rden   (user_r_control_regs_16_rden   ),
    .user_r_control_regs_16_data   (user_r_control_regs_16_data   ),
    .user_w_control_regs_16_wren   (user_w_control_regs_16_wren   ),
    .user_w_control_regs_16_data   (user_w_control_regs_16_data   ),
    .user_control_regs_16_addr     (user_control_regs_16_addr     ),
    .user_r_status_regs_16_rden    (user_r_status_regs_16_rden    ),
    .user_r_status_regs_16_data    (user_r_status_regs_16_data    ),
    .user_status_regs_16_addr      (user_status_regs_16_addr      ),
    
    .PLL_prog_trigger              (PLL_prog_trigger              ),
    .dataclk_O                     (dataclk_O                     ),
    .dataclk_D                     (dataclk_D                     ),
    .dataclk_M                     (dataclk_M                     ),
    
    .MISO_A1                       (MISO_A1                       ),
    .MISO_A2                       (MISO_A2                       ),
    .MISO_B1                       (MISO_B1                       ),
    .MISO_B2                       (MISO_B2                       ),
    .MISO_C1                       (MISO_C1                       ),
    .MISO_C2                       (MISO_C2                       ),
    .MISO_D1                       (MISO_D1                       ),
    .MISO_D2                       (MISO_D2                       ),
    .SPI_running                   (SPI_running                   ),
    .SCLK                          (SCLK                          ),
    .CS                            (CS                            ),
    .MOSI_A                        (MOSI_A                        ),
    .MOSI_B                        (MOSI_B                        ),
    .MOSI_C                        (MOSI_C                        ),
    .MOSI_D                        (MOSI_D                        ),
    
    .FIFO_DATA_STREAM              (FIFO_DATA_STREAM              ),
    .FIFO_DATA_STREAM_WEN          (FIFO_DATA_STREAM_WEN          ),
    
    .FIFO_DATA_TO_XIKE             (FIFO_DATA_TO_XIKE             ),
    .FIFO_DATA_TO_XIKE_WEN         (FIFO_DATA_TO_XIKE_WEN         )
  );

// spi_xillybus_interface ------------------------------------------------------------------------------------------------------

spi_xillybus_interface spi_xillybus_interface_4x (
  .bus_clk                         (bus_clk                       ),
  .dataclk                         (spi_clk                       ),
  .reset                           (reset                         ),   

  .FIFO_DATA_STREAM                (FIFO_DATA_STREAM              ),   // intan => spi    (16 bits data)
  .FIFO_DATA_STREAM_WEN            (FIFO_DATA_STREAM_WEN          ),   // intan => spi

  .user_r_neural_data_32_open      (user_r_neural_data_32_open    ),   // xillybus => spi 
  .user_r_neural_data_32_rden      (user_r_neural_data_32_rden    ),   // xillybus => spi 
  .user_r_neural_data_32_eof       (user_r_neural_data_32_eof     ),   // spi => xillybus
  .user_r_neural_data_32_empty     (user_r_neural_data_32_empty   ),   // spi => xillybus
  .user_r_neural_data_32_data      (user_r_neural_data_32_data    ),   // spi => xillybus (32 bits data)

  .fifo_overflow                   (fifo_overflow                 )
);

// SPI related LED 
  assign RESET_LED = reset;
  assign SPI_LED   = SPI_running;
  assign OVERFLOW_LED = fifo_overflow;

endmodule

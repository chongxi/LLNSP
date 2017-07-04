module spi_xike_pcie (
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
  output       SPI_CLK         ,
  output       OVERFLOW_LED    ,
    
  input        MISO_A1_PORT    ,
  input        MISO_A2_PORT    ,
  output       MOSI_A_PORT     ,
  output       SCLK_A_PORT     ,
  output       CS_A_PORT       ,
 
  input        MISO_B1_PORT    ,
  input        MISO_B2_PORT    ,
  output       MOSI_B_PORT     ,
  output       SCLK_B_PORT     ,
  output       CS_B_PORT       ,

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
    
    
    // Ports related to /dev/xillybus_mem_16
    // FPGA to CPU signals:
    .user_r_mem_16_rden                 (user_r_mem_16_rden                 ),
    .user_r_mem_16_empty                (user_r_mem_16_empty                ),
    .user_r_mem_16_data                 (user_r_mem_16_data                 ),
    .user_r_mem_16_eof                  (user_r_mem_16_eof                  ),
    .user_r_mem_16_open                 (user_r_mem_16_open                 ),
    
    // CPU to FPGA signals:
    .user_w_mem_16_wren                 (user_w_mem_16_wren                 ),
    .user_w_mem_16_full                 (user_w_mem_16_full                 ),
    .user_w_mem_16_data                 (user_w_mem_16_data                 ),
    .user_w_mem_16_open                 (user_w_mem_16_open                 ),
    
    // Address signals:
    .user_mem_16_addr                   (user_mem_16_addr                   ),
    .user_mem_16_addr_update            (user_mem_16_addr_update            ),
    
    
    // Ports related to /dev/xillybus_mua_32
    // FPGA to CPU signals:
    .user_r_mua_32_rden                 (user_r_mua_32_rden                 ),
    .user_r_mua_32_empty                (user_r_mua_32_empty                ),
    .user_r_mua_32_data                 (user_r_mua_32_data                 ),
    .user_r_mua_32_eof                  (user_r_mua_32_eof                  ),
    .user_r_mua_32_open                 (user_r_mua_32_open                 ),
    
    
    // Ports related to /dev/xillybus_neural_data_32
    // FPGA to CPU signals:
    .user_r_neural_data_32_rden         (user_r_neural_data_32_rden         ),
    .user_r_neural_data_32_empty        (user_r_neural_data_32_empty        ),
    .user_r_neural_data_32_data         (user_r_neural_data_32_data         ),
    .user_r_neural_data_32_eof          (user_r_neural_data_32_eof          ),
    .user_r_neural_data_32_open         (user_r_neural_data_32_open         ),
    
    
    // Ports related to /dev/xillybus_spk_realtime_32
    // FPGA to CPU signals:
    .user_r_spk_realtime_32_rden        (user_r_spk_realtime_32_rden        ),
    .user_r_spk_realtime_32_empty       (user_r_spk_realtime_32_empty       ),
    .user_r_spk_realtime_32_data        (user_r_spk_realtime_32_data        ),
    .user_r_spk_realtime_32_eof         (user_r_spk_realtime_32_eof         ),
    .user_r_spk_realtime_32_open        (user_r_spk_realtime_32_open        ),
    
    
    // Ports related to /dev/xillybus_spk_sort_32
    // FPGA to CPU signals:
    .user_r_spk_sort_32_rden            (user_r_spk_sort_32_rden            ),
    .user_r_spk_sort_32_empty           (user_r_spk_sort_32_empty           ),
    .user_r_spk_sort_32_data            (user_r_spk_sort_32_data            ),
    .user_r_spk_sort_32_eof             (user_r_spk_sort_32_eof             ),
    .user_r_spk_sort_32_open            (user_r_spk_sort_32_open            ),
    
    
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
    
    
    // Ports related to /dev/xillybus_template_32
    // FPGA to CPU signals:
    .user_r_template_32_rden            (user_r_template_32_rden            ),
    .user_r_template_32_empty           (user_r_template_32_empty           ),
    .user_r_template_32_data            (user_r_template_32_data            ),
    .user_r_template_32_eof             (user_r_template_32_eof             ),
    .user_r_template_32_open            (user_r_template_32_open            ),
    
    // CPU to FPGA signals:
    .user_w_template_32_wren            (user_w_template_32_wren            ),
    .user_w_template_32_full            (user_w_template_32_full            ),
    .user_w_template_32_data            (user_w_template_32_data            ),
    .user_w_template_32_open            (user_w_template_32_open            ),
    
    // Address signals:
    .user_template_32_addr              (user_template_32_addr              ),
    .user_template_32_addr_update       (user_template_32_addr_update       ),
    
    
    // Ports related to /dev/xillybus_thr_32
    // FPGA to CPU signals:
    .user_r_thr_32_rden                 (user_r_thr_32_rden                 ),
    .user_r_thr_32_empty                (user_r_thr_32_empty                ),
    .user_r_thr_32_data                 (user_r_thr_32_data                 ),
    .user_r_thr_32_eof                  (user_r_thr_32_eof                  ),
    .user_r_thr_32_open                 (user_r_thr_32_open                 ),
    
    // CPU to FPGA signals:
    .user_w_thr_32_wren                 (user_w_thr_32_wren                 ),
    .user_w_thr_32_full                 (user_w_thr_32_full                 ),
    .user_w_thr_32_data                 (user_w_thr_32_data                 ),
    .user_w_thr_32_open                 (user_w_thr_32_open                 ),
    
    // Address signals:
    .user_thr_32_addr                   (user_thr_32_addr                   ),
    .user_thr_32_addr_update            (user_thr_32_addr_update            ),
    
    
    // Ports related to /dev/xillybus_write_32
    // CPU to FPGA signals:
    .user_w_write_32_wren               (user_w_write_32_wren               ),
    .user_w_write_32_full               (user_w_write_32_full               ),
    .user_w_write_32_data               (user_w_write_32_data               ),
    .user_w_write_32_open               (user_w_write_32_open               ),
    
    
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

  // Wires related to /dev/xillybus_mem_16
  wire        user_r_mem_16_rden     ;
  wire        user_r_mem_16_empty    ;
  wire [15:0] user_r_mem_16_data     ;
  wire        user_r_mem_16_eof      ;
  wire        user_r_mem_16_open     ;
  wire        user_w_mem_16_wren     ;
  wire        user_w_mem_16_full     ;
  wire [15:0] user_w_mem_16_data     ;
  wire        user_w_mem_16_open     ;
  wire [ 4:0] user_mem_16_addr       ;
  wire        user_mem_16_addr_update;

  // Wires related to /dev/xillybus_mua_32
  wire        user_r_mua_32_rden ;
  wire        user_r_mua_32_empty;
  wire [31:0] user_r_mua_32_data ;
  wire        user_r_mua_32_eof  ;
  wire        user_r_mua_32_open ;

  // Wires related to /dev/xillybus_spk_realtime_32
  wire        user_r_spk_realtime_32_rden ;
  wire        user_r_spk_realtime_32_empty;
  wire [31:0] user_r_spk_realtime_32_data ;
  wire        user_r_spk_realtime_32_eof  ;
  wire        user_r_spk_realtime_32_open ;

  // Wires related to /dev/xillybus_spk_sort_32
  wire        user_r_spk_sort_32_rden ;
  wire        user_r_spk_sort_32_empty;
  wire [31:0] user_r_spk_sort_32_data ;
  wire        user_r_spk_sort_32_eof  ;
  wire        user_r_spk_sort_32_open ;

  // Wires related to /dev/xillybus_template_32
  wire        user_r_template_32_rden     ;
  wire        user_r_template_32_empty    ;
  wire [31:0] user_r_template_32_data     ;
  wire        user_r_template_32_eof      ;
  wire        user_r_template_32_open     ;
  wire        user_w_template_32_wren     ;
  wire        user_w_template_32_full     ;
  wire [31:0] user_w_template_32_data     ;
  wire        user_w_template_32_open     ;
  wire [15:0] user_template_32_addr       ;
  wire        user_template_32_addr_update;

  // Wires related to /dev/xillybus_thr_32
  wire        user_r_thr_32_rden     ;
  wire        user_r_thr_32_empty    ;
  wire [31:0] user_r_thr_32_data     ;
  wire        user_r_thr_32_eof      ;
  wire        user_r_thr_32_open     ;
  wire        user_w_thr_32_wren     ;
  wire        user_w_thr_32_full     ;
  wire [31:0] user_w_thr_32_data     ;
  wire        user_w_thr_32_open     ;
  wire [15:0] user_thr_32_addr       ;
  wire        user_thr_32_addr_update;

  // Wires related to /dev/xillybus_write_32
  wire        user_w_write_32_wren;
  wire        user_w_write_32_full;
  wire [31:0] user_w_write_32_data;
  wire        user_w_write_32_open;


// ------- CLOCK -------------------------------------------------------------------------------------------

  wire bus_clk;   // 250MHz PCIe clock
  wire sys_clk;   // on-board 200 MHz clock
  wire spi_clk;   // programmable frequency clock (f = 2800 * per-channel amplifier sampling rate) for SPI
  wire reset = ~user_w_control_regs_16_open;   // once open-ephys GUI load pcieRhythm module, the reset would goes to 0

  IBUFDS clkbuf (
      .I(SYSCLK_P),
      .IB(SYSCLK_N),
      .O(sys_clk)
  );

// SPI protocol signals ----------------------------------------------------------------------------------------
  // SPI protocol:
  // SCLK and CS are output clock signal
  // MOSI are command sent from SPI to INTAN
  // MISO are data sent from INTAN to SPI
  // SPI_running means data acq process is on

  //IO signals
  wire SCLK;
  wire CS;

  (* mark_debug = "true" *)   wire SPI_running;
  wire MOSI_A;
  wire MOSI_B;
  wire MOSI_C;
  wire MOSI_D;

  wire MISO_A1, MISO_A2;
  wire MISO_B1, MISO_B2;
  wire MISO_C1, MISO_C2;
  wire MISO_D1, MISO_D2;

  //IO signals assignment
  assign MISO_A1 = 1'b0;
  assign MISO_A2 = 1'b0;
  assign MISO_B1 = MISO_A1_PORT;
  assign MISO_B2 = MISO_A2_PORT;
  assign MISO_C1 = MISO_B1_PORT;
  assign MISO_C2 = MISO_B2_PORT;
  assign MISO_D1 = MISO_C1_PORT;
  assign MISO_D2 = MISO_C2_PORT;

  assign SCLK_A_PORT = SCLK;
  assign MOSI_A_PORT = MOSI_B;
  assign CS_A_PORT   = CS;

  assign SCLK_B_PORT = SCLK;
  assign MOSI_B_PORT = MOSI_C;
  assign CS_B_PORT   = CS;

  assign SCLK_C_PORT = SCLK;
  assign MOSI_C_PORT = MOSI_D;
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

  wire [15:0] FIFO_DATA_STREAM     ;
  wire        FIFO_DATA_STREAM_WEN ;
  
  (* mark_debug = "true" *) wire [31:0] FIFO_TIME_TO_XIKE    ;
  (* mark_debug = "true" *) wire [15:0] FIFO_DATA_TO_XIKE    ;
  (* mark_debug = "true" *) wire [15:0] FIFO_STREAMNO_TO_XIKE;
  (* mark_debug = "true" *) wire [11:0] FIFO_CHNO_TO_XIKE    ;

  spi_intan_interface_4_bank INTAN_2_SPI (
    .bus_clk                       (bus_clk                       ),
    .sys_clk                       (sys_clk                       ),
    .spi_clk                       (spi_clk                       ),
    .reset                         (reset                         ),
    
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
    
    .SPI_running                   (SPI_running                   ),
    .MISO_A1                       (MISO_A1                       ),
    .MISO_A2                       (MISO_A2                       ),
    .MISO_B1                       (MISO_B1                       ),
    .MISO_B2                       (MISO_B2                       ),
    .MISO_C1                       (MISO_C1                       ),
    .MISO_C2                       (MISO_C2                       ),
    .MISO_D1                       (MISO_D1                       ),
    .MISO_D2                       (MISO_D2                       ),
    .SCLK                          (SCLK                          ),
    .CS                            (CS                            ),
    .MOSI_A                        (MOSI_A                        ),
    .MOSI_B                        (MOSI_B                        ),
    .MOSI_C                        (MOSI_C                        ),
    .MOSI_D                        (MOSI_D                        ),
    
    .FIFO_DATA_STREAM              (FIFO_DATA_STREAM              ),
    .FIFO_DATA_STREAM_WEN          (FIFO_DATA_STREAM_WEN          ),
    
    .XIKE_ENABLE                   (XIKE_ENABLE                   ),
    .TIME_TO_XIKE                  (FIFO_TIME_TO_XIKE             ),
    .FIFO_DATA_TO_XIKE             (FIFO_DATA_TO_XIKE             ),
    .FIFO_DATA_TO_XIKE_WEN         (FIFO_DATA_TO_XIKE_WEN         ),
    .STREAM_TO_XIKE                (FIFO_STREAMNO_TO_XIKE         ),
    .CHANNEL_TO_XIKE               (FIFO_CHNO_TO_XIKE             )
  );

// spi_xillybus_interface ------------------------------------------------------------------------------------------------------

  spi_xillybus_interface SPI_2_XILLYBUS (
    .bus_clk                    (bus_clk                    ),
    .spi_clk                    (spi_clk                    ),
    .reset                      (reset                      ),
    
    .FIFO_DATA_STREAM           (FIFO_DATA_STREAM           ), // intan => spi    (16 bits data)
    .FIFO_DATA_STREAM_WEN       (FIFO_DATA_STREAM_WEN       ), // intan => spi
    
    .user_r_neural_data_32_open (user_r_neural_data_32_open ), // xillybus => spi
    .user_r_neural_data_32_rden (user_r_neural_data_32_rden ), // xillybus => spi
    .user_r_neural_data_32_eof  (user_r_neural_data_32_eof  ), // spi => xillybus
    .user_r_neural_data_32_empty(user_r_neural_data_32_empty), // spi => xillybus
    .user_r_neural_data_32_data (user_r_neural_data_32_data ), // spi => xillybus (32 bits data)
    
    .fifo_overflow              (fifo_overflow              )
  );

// SPI related LED 
  assign SPI_CLK      = spi_clk;
  assign RESET_LED    = reset;
  assign SPI_LED      = SPI_running;
  assign OVERFLOW_LED = fifo_overflow;

// Xike
  wire xike_reset = reset;
  wire spkDet_en;
  wire spkClf_en;
  assign user_r_mua_32_eof          = XIKE_ENABLE;   // flag to stop RAM FIFO
  assign user_r_spk_sort_32_eof     = XIKE_ENABLE;
  assign user_r_spk_realtime_32_eof = XIKE_ENABLE;

  mem_reg_16 mem_reg_16 (
    .clk   (bus_clk           ),
    .din   (user_w_mem_16_data),
    .we    (user_w_mem_16_wren),
    .re    (user_r_mem_16_rden),
    .addr  (user_mem_16_addr  ),
    .dout  (user_r_mem_16_data),
    .spkDet_en(spkDet_en      ),
    .spkClf_en(spkClf_en      )
  );

  wire [31:0] SPI_TO_XIKE_BUNDLE = {FIFO_CHNO_TO_XIKE, 1'b0, FIFO_DATA_TO_XIKE}; // 1'b for signed int17 data

  // fwft_fifo fifo_spi_to_fir (
  //   .rst   (xike_reset               ), // input wire rst
  //   .wr_clk(spi_clk                  ), // input wire wr_clk
  //   .rd_clk(bus_clk                  ), // input wire rd_clk
  //   .wr_en (SPI_TO_XIKE_BUNDLE_EN    ), // input wire wr_en
  //   .din   (SPI_TO_XIKE_BUNDLE       ), // input wire [31 : 0] din
  //   .rd_en (raw_ready && !fifo0_empty), // input wire rd_en
  //   .dout  (fifo0_dout               ), // output wire [31 : 0] dout
  //   .full  (fifo0_full               ), // output wire full
  //   .empty (fifo0_empty              )  // output wire empty
  // );
  
  // (* mark_debug = "true" *) wire [31:0] frame      = FIFO_TIME_TO_XIKE;
//  (* mark_debug = "true" *) wire [3 :0] raw_stream = fifo0_dout[31:27];
//   (* mark_debug = "true" *) wire [9 :0] raw_ch     = fifo0_dout[26:17];
//   (* mark_debug = "true" *) wire [15:0] raw_data   = fifo0_dout[15: 0];  // 17 bits with MSB=0, so this is a signed int17 now


// //  (* mark_debug = "true" *) wire [3 :0] mua_stream;

  wire        raw_comb_ready;
  wire        raw_comb_valid;
  wire [79:0] raw_comb_data ;
  wire [59:0] raw_comb_ch;

  raw_comb_5_streams i_raw_comb_5_streams (
    .spi_clk              (spi_clk                   ),
    .bus_clk              (bus_clk                   ),
    .xike_reset           (xike_reset                ),
    .FIFO_STREAMNO_TO_XIKE(FIFO_STREAMNO_TO_XIKE[4:0]),  // 5 streams
    .SPI_TO_XIKE_BUNDLE   (SPI_TO_XIKE_BUNDLE        ),  // {chNo,1'b0,data}
    .raw_comb_ready       (raw_comb_ready            ),
    .raw_comb_valid       (raw_comb_valid            ),
    .raw_comb_data        (raw_comb_data             ),
    .raw_comb_ch          (raw_comb_ch               )
  );


  wire         mua_comb_valid;
  wire [159:0] mua_comb_data;
  wire [59 :0] mua_comb_ch;

  fir_compiler_0 fir_band_pass (
    .aresetn           (!xike_reset ), // input wire aresetn
    .aclk              (bus_clk     ), // input wire aclk
    .s_axis_data_tvalid(raw_comb_valid), // input wire s_axis_data_tvalid
    .s_axis_data_tready(raw_comb_ready), // output wire s_axis_data_tready
    .s_axis_data_tdata (raw_comb_data ), // input wire [79 : 0] s_axis_data_tdata
    .s_axis_data_tuser (raw_comb_ch   ),    // input wire [59 : 0] s_axis_data_tuser
    .m_axis_data_tvalid(mua_comb_valid   ), // output wire m_axis_data_tvalid
    .m_axis_data_tdata (mua_comb_data    ),  // output wire [159 : 0] m_axis_data_tdata
    .m_axis_data_tuser (mua_comb_ch)    // output wire [59 : 0] m_axis_data_tdata
    );

// Threshold generator based on ...
// Block-RAM that contains the threshold of each channel
// Send thershold out according to chNo_to_spkDet (out of FIR module)
  
  wire [159:0] threshold_comb  ;
  wire [159:0] ch_unigroup_comb;
  wire [159:0] off_set_comb    ;
  
  bram_thres bram_thres (
    .clk             (bus_clk           ),
    .we              (user_w_thr_32_wren),
    .re              (user_r_thr_32_rden),
    .addr            (user_thr_32_addr  ),
    .din             (user_w_thr_32_data),
    .dout            (user_r_thr_32_data),
    // for detection threshold and channal mapping
    .ch_comb         (mua_comb_ch       ), // FROM FIR
    .thr_out_comb    (threshold_comb    ),
    .ch_hash_out_comb(ch_unigroup_comb  ),
    .off_set_out_comb(off_set_comb      )
  );
  
  wire frame_count_rst = !SPI_running;
  
  (* mark_debug = "true" *) wire        mua_valid;
  (* mark_debug = "true" *) wire [11:0] mua_ch;
  (* mark_debug = "true" *) wire [31:0] mua_data;
  (* mark_debug = "true" *) wire [31:0] thr_data;  
  (* mark_debug = "true" *) wire [31:0] mua_ch_hash;
  (* mark_debug = "true" *) wire [31:0] mua_frame_No;

  mua_parallel_to_serial mua_comb_to_mua(
    .bus_clk          (bus_clk          ), // Clock
    .xike_reset       (xike_reset       ), // Reset
    .frame_count_rst  (frame_count_rst  ),
  
    .mua_comb_valid   (mua_comb_valid   ),
    .mua_comb_ch      (mua_comb_ch      ),
    .mua_comb_data    (mua_comb_data    ),
    .mua_comb_ch_hash (ch_unigroup_comb ),
    .threshold_comb   (threshold_comb   ),
    .off_set_comb     (off_set_comb     ),
    .fifo_mua_full    (fifo_mua_full    ),
    
    .mua_valid        (mua_valid       ),
    .mua_ch           (mua_ch          ),
    .mua_data         (mua_data        ),
    .thr_data         (thr_data        ),
    .mua_ch_hash      (mua_ch_hash     ),
    .mua_frame_No     (mua_frame_No    )
  );

  (* mark_debug = "true" *) wire        muap_valid;
  (* mark_debug = "true" *) wire [11:0] muap_ch;
  (* mark_debug = "true" *) wire [31:0] muap_data;
  (* mark_debug = "true" *) wire [31:0] muap_ch_hash;
  (* mark_debug = "true" *) wire [31:0] muap_frame_No;
  
  spkDect i_spkDect (
    .clk          (bus_clk        ),
    .rst          (frame_count_rst),
    // input
    .mua_valid    (mua_valid      ),
    .frameNo_in   (mua_frame_No   ),
    .chNo_in      (mua_ch         ),
    .ch_hash_in   (mua_ch_hash    ),
    .thr_data     (thr_data       ),
    .mua_data     (mua_data       ),
    // output
    .muap_valid   (muap_valid     ),
    .muap_frame_No(muap_frame_No  ),
    .muap_ch      (muap_ch        ),
    .muap_ch_hash (muap_ch_hash   ),
    .muap_data    (muap_data      )
  );

  // spk_packet 
  wire spk_stream_TVALID;
  wire [ 11:0] spk_stream_CH;
  wire [ 31:0] spk_stream_TIME;
  wire [ 15:0] spk_stream_TDEST;
  wire [127:0] spk_stream_TDATA;
  wire spk_stream_pulse;

  spkPack i_spkPack (
    // input 
    .clk              (bus_clk          ),
    .rst              (frame_count_rst  ),
    .frame_No_in      (muap_frame_No    ),
    .ch_in            (muap_ch          ),
    .ch_unigroup_in   (muap_ch_hash     ),
    .valid_in         (muap_valid       ),
    .v_in             (muap_data        ),
    .is_peak_in       (muap_data[0]     ),
    
    // spike info and waveform output
    .spk_stream_TVALID(spk_stream_TVALID),
    .spk_stream_CH    (spk_stream_CH    ),
    .spk_stream_TIME  (spk_stream_TIME  ),
    .spk_stream_TDEST (spk_stream_TDEST ),
    .spk_stream_TDATA (spk_stream_TDATA ),
    .spk_stream_pulse (spk_stream_pulse )
  );


  fifo_32x512 muap_to_host (
    .clk  (bus_clk                     ),
    .srst (!user_r_mua_32_open         ),
    .wr_en(muap_valid && !fifo_mua_full), // AXI4 valid and ready
    .din  (muap_data                   ), // mua_data
    .rd_en(user_r_mua_32_rden          ),
    .dout (user_r_mua_32_data          ),
    .full (fifo_mua_full               ),
    .empty(user_r_mua_32_empty         )
  );

  wire spk_info_valid = muap_valid && muap_data[0] && !fifo_spk_sort_full;
  wire [63:0] spk_info_data  = {muap_ch, muap_frame_No};

  fifo_64_to_32 spk_info_to_host (
    .clk(bus_clk),      // input wire clk
    .srst(!user_r_spk_sort_32_open),    // input wire srst
    .din(spk_info_data),      // input wire [63 : 0] din
    .wr_en(spk_info_valid ),  // input wire wr_en
    .rd_en(user_r_spk_sort_32_rden),  // input wire rd_en
    .dout(user_r_spk_sort_32_data),    // output wire [31 : 0] dout
    .full(fifo_spk_sort_full),    // output wire full
    .empty(user_r_spk_sort_32_empty)  // output wire empty
  );
  
  fifo_generator_spk spk_wav_to_host (
    .clk(bus_clk),      // input wire clk
    .srst(!user_r_spk_realtime_32_open),    // input wire srst
    .din(spk_stream_TDATA),      // input wire [127 : 0] din
    .wr_en(spk_stream_TVALID && !fifo_spk_realtime_full),  // input wire wr_en
    .rd_en(user_r_spk_realtime_32_rden),  // input wire rd_en
    .dout(user_r_spk_realtime_32_data),    // output wire [31 : 0] dout
    .full(fifo_spk_realtime_full),    // output wire full
    .empty(user_r_spk_realtime_32_empty)  // output wire empty
  );
  
//  user_r_spk_realtime_32_data

endmodule

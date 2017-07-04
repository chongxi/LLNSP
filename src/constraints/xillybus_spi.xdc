create_clock -period 10.000 -name sys_clk [get_pins -match_style ucf */pcieclk_ibuf/O]
create_clock -period 5.000 -name board_clk [get_ports SYSCLK_P]
#create_clock -period 5.000 -name clk200 [get_nets clk200]
#create_generated_clock -name dataclk -source [get_ports SYSCLK_P] -divide_by 100 -multiply_by 42 [get_nets dataclk]

set_clock_groups -name async_pcie_data -asynchronous -group {board_clk dataclk clkfbout clk_buf_out spi_clk} -group {sys_clk userclk1}

#set_false_path -from [get_pins clkgen/start_cd/toggleA*/*] -to [get_pins clkgen/start_cd/syncA*/*]
##set_false_path -from [get_pins xillybus_ins/xillybus_core_ins/unitr_2_ins/user_w_control_regs_16_open/C] -to [get_pins -match_style ucf clkgen/*]

#set_multicycle_path -hold -end -from [get_pins dataclk_O*/*] -to [get_pins clkgen/pll_O*/*] 1
#set_multicycle_path -hold -end -from [get_pins dataclk_M*/*] -to [get_pins clkgen/pll_M*/*] 1
#set_multicycle_path -hold -end -from [get_pins dataclk_D*/*] -to [get_pins clkgen/pll_D*/*] 1

set_false_path -to [get_pins -match_style ucf */pipe_clock/pclk_i1_bufgctrl.pclk_i1/S0]
set_false_path -to [get_pins -match_style ucf */pipe_clock/pclk_i1_bufgctrl.pclk_i1/S1]
set_case_analysis 1 [get_pins -match_style ucf */pipe_clock/pclk_i1_bufgctrl.pclk_i1/S0]
set_case_analysis 0 [get_pins -match_style ucf */pipe_clock/pclk_i1_bufgctrl.pclk_i1/S1]

set_property DONT_TOUCH true [get_cells -of [get_nets -of [get_pins -match_style ucf */pipe_clock/pclk_i1_bufgctrl.pclk_i1/S0]]]
set_property DONT_TOUCH true [get_cells -hier -filter name=~*/pipe_clock/pclk_sel*]

set_false_path -from [get_ports PCIE_PERST_B_LS]

set_property LOC IBUFDS_GTE2_X0Y1 [get_cells -match_style ucf */pcieclk_ibuf]

set_property PACKAGE_PIN G25 [get_ports PCIE_PERST_B_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PCIE_PERST_B_LS]
set_property PULLUP true [get_ports PCIE_PERST_B_LS]

set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS15} [get_ports {GPIO_LED[0]}]
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS15} [get_ports {GPIO_LED[1]}]
set_property -dict {PACKAGE_PIN AC9 IOSTANDARD LVCMOS15} [get_ports {GPIO_LED[2]}]
set_property -dict {PACKAGE_PIN AB9 IOSTANDARD LVCMOS15} [get_ports {GPIO_LED[3]}]

set_property PACKAGE_PIN H24 [get_ports SPI_CLK]
set_property IOSTANDARD LVCMOS25 [get_ports SPI_CLK]

set_property PACKAGE_PIN F16 [get_ports RESET_LED]
set_property IOSTANDARD LVCMOS25 [get_ports RESET_LED]

set_property PACKAGE_PIN E18 [get_ports SPI_LED]
set_property IOSTANDARD LVCMOS25 [get_ports SPI_LED]

set_property PACKAGE_PIN G19 [get_ports OVERFLOW_LED]
set_property IOSTANDARD LVCMOS25 [get_ports OVERFLOW_LED]

set_property IOSTANDARD LVDS [get_ports SYSCLK_P]
set_property PACKAGE_PIN AD12 [get_ports SYSCLK_P]
set_property PACKAGE_PIN AD11 [get_ports SYSCLK_N]
set_property IOSTANDARD LVDS [get_ports SYSCLK_N]

# isolated output from FPGA
# set_property PACKAGE_PIN AK26 [get_ports sma_out_isol_H23]
# set_property IOSTANDARD LVCMOS33 [get_ports sma_out_isol_H23]

# isolated inputs to FPGA


# direct SMAs (G24, 25, 27)
# set_property PACKAGE_PIN AJ27 [get_ports sma_direct_G24]
# set_property IOSTANDARD LVCMOS33 [get_ports sma_direct_G24]

# set_property PACKAGE_PIN AK28 [get_ports sma_direct_G25]
# set_property IOSTANDARD LVCMOS33 [get_ports sma_direct_G25]

# set_property PACKAGE_PIN AC26 [get_ports sma_direct_G27]
# set_property IOSTANDARD LVCMOS33 [get_ports sma_direct_G27]


###############   PORT A #################################
set_property PACKAGE_PIN AF20 [get_ports MISO_A1_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MISO_A1_PORT]

set_property PACKAGE_PIN AF21 [get_ports MISO_A2_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MISO_A2_PORT]

set_property PACKAGE_PIN AH21 [get_ports MOSI_A_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MOSI_A_PORT]

set_property PACKAGE_PIN AJ21 [get_ports SCLK_A_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports SCLK_A_PORT]

set_property PACKAGE_PIN AG25 [get_ports CS_A_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports CS_A_PORT]


###############   PORT B #################################
set_property PACKAGE_PIN AE25 [get_ports MISO_B1_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MISO_B1_PORT]

set_property PACKAGE_PIN AF25 [get_ports MISO_B2_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MISO_B2_PORT]

set_property PACKAGE_PIN AC24 [get_ports MOSI_B_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MOSI_B_PORT]

set_property PACKAGE_PIN AD24 [get_ports SCLK_B_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports SCLK_B_PORT]

set_property PACKAGE_PIN AJ26 [get_ports CS_B_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports CS_B_PORT]



###############   PORT C #################################
set_property PACKAGE_PIN AG27 [get_ports MISO_C1_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MISO_C1_PORT]

set_property PACKAGE_PIN AG28 [get_ports MISO_C2_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MISO_C2_PORT]

set_property PACKAGE_PIN AG30 [get_ports MOSI_C_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MOSI_C_PORT]

set_property PACKAGE_PIN AH30 [get_ports SCLK_C_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports SCLK_C_PORT]

set_property PACKAGE_PIN AK26 [get_ports CS_C_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports CS_C_PORT]















# C spi port (isolated, simple cmos33 logic, gets translated to lvds after isolator)
# set_property PACKAGE_PIN AF25 [get_ports MISO_C1_PORT]
# set_property IOSTANDARD LVCMOS33 [get_ports MISO_C1_PORT]

# set_property PACKAGE_PIN AE25 [get_ports MISO_C2_PORT]
# set_property IOSTANDARD LVCMOS33 [get_ports MISO_C2_PORT]

# set_property PACKAGE_PIN AC24 [get_ports MOSI_C_PORT]
# set_property IOSTANDARD LVCMOS33 [get_ports MOSI_C_PORT]

# set_property PACKAGE_PIN AD24 [get_ports SCLK_C_PORT]
# set_property IOSTANDARD LVCMOS33 [get_ports SCLK_C_PORT]

# set_property PACKAGE_PIN AJ26 [get_ports CS_C_PORT]
# set_property IOSTANDARD LVCMOS33 [get_ports CS_C_PORT]

# TODO: If we want to acctually use the isolated SPI busses, we need to make sure they use
# the same VCCO as the singled ended ports on the same bank. If they need to use a different
# VCCO, then their DIFF_TERM property should be set to false. Ideally, we should not have any
# non isolated pins anyway, so this is probably all mute.

## B spi port (non-isolated, goes straight to FMC pins)
#set_property PACKAGE_PIN AG30 [get_ports MISO_B1_p]
#set_property PACKAGE_PIN AH30 [get_ports MISO_B1_n]
#set_property IOSTANDARD LVDS_25 [get_ports {MISO_B1_p MISO_B1_n}]

#set_property PACKAGE_PIN AG27 [get_ports MISO_B2_p]
#set_property PACKAGE_PIN AG28 [get_ports MISO_B2_n]
#set_property IOSTANDARD LVDS_25 [get_ports {MISO_B2_p MISO_B2_n}]

#set_property PACKAGE_PIN AE30 [get_ports MOSI_B_p]
#set_property PACKAGE_PIN AF30 [get_ports MOSI_B_n]
#set_property IOSTANDARD LVDS_25 [get_ports {MOSI_B_p MOSI_B_n}]

#set_property PACKAGE_PIN AB29 [get_ports SCLK_B_p]
#set_property PACKAGE_PIN AB30 [get_ports SCLK_B_n]
#set_property IOSTANDARD LVDS_25 [get_ports {SCLK_B_p SCLK_B_n}]

#set_property PACKAGE_PIN Y30 [get_ports CS_B_p]
#set_property PACKAGE_PIN AA30 [get_ports CS_B_n]
#set_property IOSTANDARD LVDS_25 [get_ports {CS_B_p CS_B_n}]


set_property CONFIG_MODE BPI16 [current_design]

# ------------------------------------------------------------------------------------------------







create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list xillybus_ins/pipe_clock/pipe_clock/pipe_userclk1_in]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {i_spkPack/channel[0]} {i_spkPack/channel[1]} {i_spkPack/channel[2]} {i_spkPack/channel[3]} {i_spkPack/channel[4]} {i_spkPack/channel[5]} {i_spkPack/channel[6]} {i_spkPack/channel[7]} {i_spkPack/channel[8]} {i_spkPack/channel[9]} {i_spkPack/channel[10]} {i_spkPack/channel[11]} {i_spkPack/channel[12]} {i_spkPack/channel[13]} {i_spkPack/channel[14]} {i_spkPack/channel[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {i_spkPack/ch_nn3_value[0]} {i_spkPack/ch_nn3_value[1]} {i_spkPack/ch_nn3_value[2]} {i_spkPack/ch_nn3_value[3]} {i_spkPack/ch_nn3_value[4]} {i_spkPack/ch_nn3_value[5]} {i_spkPack/ch_nn3_value[6]} {i_spkPack/ch_nn3_value[7]} {i_spkPack/ch_nn3_value[8]} {i_spkPack/ch_nn3_value[9]} {i_spkPack/ch_nn3_value[10]} {i_spkPack/ch_nn3_value[11]} {i_spkPack/ch_nn3_value[12]} {i_spkPack/ch_nn3_value[13]} {i_spkPack/ch_nn3_value[14]} {i_spkPack/ch_nn3_value[15]} {i_spkPack/ch_nn3_value[16]} {i_spkPack/ch_nn3_value[17]} {i_spkPack/ch_nn3_value[18]} {i_spkPack/ch_nn3_value[19]} {i_spkPack/ch_nn3_value[20]} {i_spkPack/ch_nn3_value[21]} {i_spkPack/ch_nn3_value[22]} {i_spkPack/ch_nn3_value[23]} {i_spkPack/ch_nn3_value[24]} {i_spkPack/ch_nn3_value[25]} {i_spkPack/ch_nn3_value[26]} {i_spkPack/ch_nn3_value[27]} {i_spkPack/ch_nn3_value[28]} {i_spkPack/ch_nn3_value[29]} {i_spkPack/ch_nn3_value[30]} {i_spkPack/ch_nn3_value[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {i_spkPack/ch_nn2_value[0]} {i_spkPack/ch_nn2_value[1]} {i_spkPack/ch_nn2_value[2]} {i_spkPack/ch_nn2_value[3]} {i_spkPack/ch_nn2_value[4]} {i_spkPack/ch_nn2_value[5]} {i_spkPack/ch_nn2_value[6]} {i_spkPack/ch_nn2_value[7]} {i_spkPack/ch_nn2_value[8]} {i_spkPack/ch_nn2_value[9]} {i_spkPack/ch_nn2_value[10]} {i_spkPack/ch_nn2_value[11]} {i_spkPack/ch_nn2_value[12]} {i_spkPack/ch_nn2_value[13]} {i_spkPack/ch_nn2_value[14]} {i_spkPack/ch_nn2_value[15]} {i_spkPack/ch_nn2_value[16]} {i_spkPack/ch_nn2_value[17]} {i_spkPack/ch_nn2_value[18]} {i_spkPack/ch_nn2_value[19]} {i_spkPack/ch_nn2_value[20]} {i_spkPack/ch_nn2_value[21]} {i_spkPack/ch_nn2_value[22]} {i_spkPack/ch_nn2_value[23]} {i_spkPack/ch_nn2_value[24]} {i_spkPack/ch_nn2_value[25]} {i_spkPack/ch_nn2_value[26]} {i_spkPack/ch_nn2_value[27]} {i_spkPack/ch_nn2_value[28]} {i_spkPack/ch_nn2_value[29]} {i_spkPack/ch_nn2_value[30]} {i_spkPack/ch_nn2_value[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {i_spkPack/ch_nn1_value[0]} {i_spkPack/ch_nn1_value[1]} {i_spkPack/ch_nn1_value[2]} {i_spkPack/ch_nn1_value[3]} {i_spkPack/ch_nn1_value[4]} {i_spkPack/ch_nn1_value[5]} {i_spkPack/ch_nn1_value[6]} {i_spkPack/ch_nn1_value[7]} {i_spkPack/ch_nn1_value[8]} {i_spkPack/ch_nn1_value[9]} {i_spkPack/ch_nn1_value[10]} {i_spkPack/ch_nn1_value[11]} {i_spkPack/ch_nn1_value[12]} {i_spkPack/ch_nn1_value[13]} {i_spkPack/ch_nn1_value[14]} {i_spkPack/ch_nn1_value[15]} {i_spkPack/ch_nn1_value[16]} {i_spkPack/ch_nn1_value[17]} {i_spkPack/ch_nn1_value[18]} {i_spkPack/ch_nn1_value[19]} {i_spkPack/ch_nn1_value[20]} {i_spkPack/ch_nn1_value[21]} {i_spkPack/ch_nn1_value[22]} {i_spkPack/ch_nn1_value[23]} {i_spkPack/ch_nn1_value[24]} {i_spkPack/ch_nn1_value[25]} {i_spkPack/ch_nn1_value[26]} {i_spkPack/ch_nn1_value[27]} {i_spkPack/ch_nn1_value[28]} {i_spkPack/ch_nn1_value[29]} {i_spkPack/ch_nn1_value[30]} {i_spkPack/ch_nn1_value[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {i_spkPack/ch_nn0_value[0]} {i_spkPack/ch_nn0_value[1]} {i_spkPack/ch_nn0_value[2]} {i_spkPack/ch_nn0_value[3]} {i_spkPack/ch_nn0_value[4]} {i_spkPack/ch_nn0_value[5]} {i_spkPack/ch_nn0_value[6]} {i_spkPack/ch_nn0_value[7]} {i_spkPack/ch_nn0_value[8]} {i_spkPack/ch_nn0_value[9]} {i_spkPack/ch_nn0_value[10]} {i_spkPack/ch_nn0_value[11]} {i_spkPack/ch_nn0_value[12]} {i_spkPack/ch_nn0_value[13]} {i_spkPack/ch_nn0_value[14]} {i_spkPack/ch_nn0_value[15]} {i_spkPack/ch_nn0_value[16]} {i_spkPack/ch_nn0_value[17]} {i_spkPack/ch_nn0_value[18]} {i_spkPack/ch_nn0_value[19]} {i_spkPack/ch_nn0_value[20]} {i_spkPack/ch_nn0_value[21]} {i_spkPack/ch_nn0_value[22]} {i_spkPack/ch_nn0_value[23]} {i_spkPack/ch_nn0_value[24]} {i_spkPack/ch_nn0_value[25]} {i_spkPack/ch_nn0_value[26]} {i_spkPack/ch_nn0_value[27]} {i_spkPack/ch_nn0_value[28]} {i_spkPack/ch_nn0_value[29]} {i_spkPack/ch_nn0_value[30]} {i_spkPack/ch_nn0_value[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 12 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {i_spkPack/ch_last_bufo[0]} {i_spkPack/ch_last_bufo[1]} {i_spkPack/ch_last_bufo[2]} {i_spkPack/ch_last_bufo[3]} {i_spkPack/ch_last_bufo[4]} {i_spkPack/ch_last_bufo[5]} {i_spkPack/ch_last_bufo[6]} {i_spkPack/ch_last_bufo[7]} {i_spkPack/ch_last_bufo[8]} {i_spkPack/ch_last_bufo[9]} {i_spkPack/ch_last_bufo[10]} {i_spkPack/ch_last_bufo[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 12 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {i_spkPack/ch_bufo[0]} {i_spkPack/ch_bufo[1]} {i_spkPack/ch_bufo[2]} {i_spkPack/ch_bufo[3]} {i_spkPack/ch_bufo[4]} {i_spkPack/ch_bufo[5]} {i_spkPack/ch_bufo[6]} {i_spkPack/ch_bufo[7]} {i_spkPack/ch_bufo[8]} {i_spkPack/ch_bufo[9]} {i_spkPack/ch_bufo[10]} {i_spkPack/ch_bufo[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {i_spkPack/t_in[0]} {i_spkPack/t_in[1]} {i_spkPack/t_in[2]} {i_spkPack/t_in[3]} {i_spkPack/t_in[4]} {i_spkPack/t_in[5]} {i_spkPack/t_in[6]} {i_spkPack/t_in[7]} {i_spkPack/t_in[8]} {i_spkPack/t_in[9]} {i_spkPack/t_in[10]} {i_spkPack/t_in[11]} {i_spkPack/t_in[12]} {i_spkPack/t_in[13]} {i_spkPack/t_in[14]} {i_spkPack/t_in[15]} {i_spkPack/t_in[16]} {i_spkPack/t_in[17]} {i_spkPack/t_in[18]} {i_spkPack/t_in[19]} {i_spkPack/t_in[20]} {i_spkPack/t_in[21]} {i_spkPack/t_in[22]} {i_spkPack/t_in[23]} {i_spkPack/t_in[24]} {i_spkPack/t_in[25]} {i_spkPack/t_in[26]} {i_spkPack/t_in[27]} {i_spkPack/t_in[28]} {i_spkPack/t_in[29]} {i_spkPack/t_in[30]} {i_spkPack/t_in[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 16 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {i_spkPack/last_channel[0]} {i_spkPack/last_channel[1]} {i_spkPack/last_channel[2]} {i_spkPack/last_channel[3]} {i_spkPack/last_channel[4]} {i_spkPack/last_channel[5]} {i_spkPack/last_channel[6]} {i_spkPack/last_channel[7]} {i_spkPack/last_channel[8]} {i_spkPack/last_channel[9]} {i_spkPack/last_channel[10]} {i_spkPack/last_channel[11]} {i_spkPack/last_channel[12]} {i_spkPack/last_channel[13]} {i_spkPack/last_channel[14]} {i_spkPack/last_channel[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {i_spkPack/frame_No_bufo[0]} {i_spkPack/frame_No_bufo[1]} {i_spkPack/frame_No_bufo[2]} {i_spkPack/frame_No_bufo[3]} {i_spkPack/frame_No_bufo[4]} {i_spkPack/frame_No_bufo[5]} {i_spkPack/frame_No_bufo[6]} {i_spkPack/frame_No_bufo[7]} {i_spkPack/frame_No_bufo[8]} {i_spkPack/frame_No_bufo[9]} {i_spkPack/frame_No_bufo[10]} {i_spkPack/frame_No_bufo[11]} {i_spkPack/frame_No_bufo[12]} {i_spkPack/frame_No_bufo[13]} {i_spkPack/frame_No_bufo[14]} {i_spkPack/frame_No_bufo[15]} {i_spkPack/frame_No_bufo[16]} {i_spkPack/frame_No_bufo[17]} {i_spkPack/frame_No_bufo[18]} {i_spkPack/frame_No_bufo[19]} {i_spkPack/frame_No_bufo[20]} {i_spkPack/frame_No_bufo[21]} {i_spkPack/frame_No_bufo[22]} {i_spkPack/frame_No_bufo[23]} {i_spkPack/frame_No_bufo[24]} {i_spkPack/frame_No_bufo[25]} {i_spkPack/frame_No_bufo[26]} {i_spkPack/frame_No_bufo[27]} {i_spkPack/frame_No_bufo[28]} {i_spkPack/frame_No_bufo[29]} {i_spkPack/frame_No_bufo[30]} {i_spkPack/frame_No_bufo[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {thr_data[0]} {thr_data[1]} {thr_data[2]} {thr_data[3]} {thr_data[4]} {thr_data[5]} {thr_data[6]} {thr_data[7]} {thr_data[8]} {thr_data[9]} {thr_data[10]} {thr_data[11]} {thr_data[12]} {thr_data[13]} {thr_data[14]} {thr_data[15]} {thr_data[16]} {thr_data[17]} {thr_data[18]} {thr_data[19]} {thr_data[20]} {thr_data[21]} {thr_data[22]} {thr_data[23]} {thr_data[24]} {thr_data[25]} {thr_data[26]} {thr_data[27]} {thr_data[28]} {thr_data[29]} {thr_data[30]} {thr_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {muap_frame_No[0]} {muap_frame_No[1]} {muap_frame_No[2]} {muap_frame_No[3]} {muap_frame_No[4]} {muap_frame_No[5]} {muap_frame_No[6]} {muap_frame_No[7]} {muap_frame_No[8]} {muap_frame_No[9]} {muap_frame_No[10]} {muap_frame_No[11]} {muap_frame_No[12]} {muap_frame_No[13]} {muap_frame_No[14]} {muap_frame_No[15]} {muap_frame_No[16]} {muap_frame_No[17]} {muap_frame_No[18]} {muap_frame_No[19]} {muap_frame_No[20]} {muap_frame_No[21]} {muap_frame_No[22]} {muap_frame_No[23]} {muap_frame_No[24]} {muap_frame_No[25]} {muap_frame_No[26]} {muap_frame_No[27]} {muap_frame_No[28]} {muap_frame_No[29]} {muap_frame_No[30]} {muap_frame_No[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 32 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {muap_data[0]} {muap_data[1]} {muap_data[2]} {muap_data[3]} {muap_data[4]} {muap_data[5]} {muap_data[6]} {muap_data[7]} {muap_data[8]} {muap_data[9]} {muap_data[10]} {muap_data[11]} {muap_data[12]} {muap_data[13]} {muap_data[14]} {muap_data[15]} {muap_data[16]} {muap_data[17]} {muap_data[18]} {muap_data[19]} {muap_data[20]} {muap_data[21]} {muap_data[22]} {muap_data[23]} {muap_data[24]} {muap_data[25]} {muap_data[26]} {muap_data[27]} {muap_data[28]} {muap_data[29]} {muap_data[30]} {muap_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 32 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {muap_ch_hash[0]} {muap_ch_hash[1]} {muap_ch_hash[2]} {muap_ch_hash[3]} {muap_ch_hash[4]} {muap_ch_hash[5]} {muap_ch_hash[6]} {muap_ch_hash[7]} {muap_ch_hash[8]} {muap_ch_hash[9]} {muap_ch_hash[10]} {muap_ch_hash[11]} {muap_ch_hash[12]} {muap_ch_hash[13]} {muap_ch_hash[14]} {muap_ch_hash[15]} {muap_ch_hash[16]} {muap_ch_hash[17]} {muap_ch_hash[18]} {muap_ch_hash[19]} {muap_ch_hash[20]} {muap_ch_hash[21]} {muap_ch_hash[22]} {muap_ch_hash[23]} {muap_ch_hash[24]} {muap_ch_hash[25]} {muap_ch_hash[26]} {muap_ch_hash[27]} {muap_ch_hash[28]} {muap_ch_hash[29]} {muap_ch_hash[30]} {muap_ch_hash[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 12 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {muap_ch[0]} {muap_ch[1]} {muap_ch[2]} {muap_ch[3]} {muap_ch[4]} {muap_ch[5]} {muap_ch[6]} {muap_ch[7]} {muap_ch[8]} {muap_ch[9]} {muap_ch[10]} {muap_ch[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {mua_frame_No[0]} {mua_frame_No[1]} {mua_frame_No[2]} {mua_frame_No[3]} {mua_frame_No[4]} {mua_frame_No[5]} {mua_frame_No[6]} {mua_frame_No[7]} {mua_frame_No[8]} {mua_frame_No[9]} {mua_frame_No[10]} {mua_frame_No[11]} {mua_frame_No[12]} {mua_frame_No[13]} {mua_frame_No[14]} {mua_frame_No[15]} {mua_frame_No[16]} {mua_frame_No[17]} {mua_frame_No[18]} {mua_frame_No[19]} {mua_frame_No[20]} {mua_frame_No[21]} {mua_frame_No[22]} {mua_frame_No[23]} {mua_frame_No[24]} {mua_frame_No[25]} {mua_frame_No[26]} {mua_frame_No[27]} {mua_frame_No[28]} {mua_frame_No[29]} {mua_frame_No[30]} {mua_frame_No[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 32 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {mua_data[0]} {mua_data[1]} {mua_data[2]} {mua_data[3]} {mua_data[4]} {mua_data[5]} {mua_data[6]} {mua_data[7]} {mua_data[8]} {mua_data[9]} {mua_data[10]} {mua_data[11]} {mua_data[12]} {mua_data[13]} {mua_data[14]} {mua_data[15]} {mua_data[16]} {mua_data[17]} {mua_data[18]} {mua_data[19]} {mua_data[20]} {mua_data[21]} {mua_data[22]} {mua_data[23]} {mua_data[24]} {mua_data[25]} {mua_data[26]} {mua_data[27]} {mua_data[28]} {mua_data[29]} {mua_data[30]} {mua_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 32 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {mua_ch_hash[0]} {mua_ch_hash[1]} {mua_ch_hash[2]} {mua_ch_hash[3]} {mua_ch_hash[4]} {mua_ch_hash[5]} {mua_ch_hash[6]} {mua_ch_hash[7]} {mua_ch_hash[8]} {mua_ch_hash[9]} {mua_ch_hash[10]} {mua_ch_hash[11]} {mua_ch_hash[12]} {mua_ch_hash[13]} {mua_ch_hash[14]} {mua_ch_hash[15]} {mua_ch_hash[16]} {mua_ch_hash[17]} {mua_ch_hash[18]} {mua_ch_hash[19]} {mua_ch_hash[20]} {mua_ch_hash[21]} {mua_ch_hash[22]} {mua_ch_hash[23]} {mua_ch_hash[24]} {mua_ch_hash[25]} {mua_ch_hash[26]} {mua_ch_hash[27]} {mua_ch_hash[28]} {mua_ch_hash[29]} {mua_ch_hash[30]} {mua_ch_hash[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 12 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {mua_ch[0]} {mua_ch[1]} {mua_ch[2]} {mua_ch[3]} {mua_ch[4]} {mua_ch[5]} {mua_ch[6]} {mua_ch[7]} {mua_ch[8]} {mua_ch[9]} {mua_ch[10]} {mua_ch[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list i_spkPack/fifo_2_spk_tx_empty]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list i_spkPack/frame_pulse]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list i_spkPack/j]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list mua_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list muap_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list mua_comb_to_mua/spk_frame_counter/reset]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list SPI_running]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list i_spkPack/spk_packet_tx_read]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list i_spkPack/spk_stream_TVALID]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list i_spkPack/spk_tx_wen]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list i_spkPack/valid_bufo]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_pipe_userclk1_in]

create_clock -period 10.000 -name sys_clk [get_pins -match_style ucf */pcieclk_ibuf/O]
create_clock -period 5.000 -name board_clk [get_ports SYSCLK_P]
#create_clock -period 5.000 -name clk200 [get_nets clk200]
#create_generated_clock -name dataclk -source [get_ports SYSCLK_P] -divide_by 100 -multiply_by 42 [get_nets dataclk]

set_clock_groups -name async_pcie_data -asynchronous -group {board_clk dataclk clkfbout clk_buf_out spi_clk} -group {sys_clk userclk1 clk200}

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


# C spi port (isolated, simple cmos33 logic, gets translated to lvds after isolator)
set_property PACKAGE_PIN AE25 [get_ports MISO_C1_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MISO_C1_PORT]

set_property PACKAGE_PIN AF25 [get_ports MISO_C2_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MISO_C2_PORT]

set_property PACKAGE_PIN AC24 [get_ports MOSI_C_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports MOSI_C_PORT]

set_property PACKAGE_PIN AD24 [get_ports SCLK_C_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports SCLK_C_PORT]

set_property PACKAGE_PIN AJ26 [get_ports CS_C_PORT]
set_property IOSTANDARD LVCMOS33 [get_ports CS_C_PORT]

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
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list xillybus_ins/pipe_clock/pipe_clock/pipe_userclk1_in]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 7 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {dataclk_M[0]} {dataclk_M[1]} {dataclk_M[2]} {dataclk_M[3]} {dataclk_M[4]} {dataclk_M[5]} {dataclk_M[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {dataclk_O[0]} {dataclk_O[1]} {dataclk_O[2]} {dataclk_O[3]} {dataclk_O[4]} {dataclk_O[5]} {dataclk_O[6]} {dataclk_O[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {dataclk_D[0]} {dataclk_D[1]} {dataclk_D[2]} {dataclk_D[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list CS]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list MISO_C1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list MISO_C2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list MOSI_C]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list reset]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list SCLK]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list spi_clk]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_pipe_userclk1_in]

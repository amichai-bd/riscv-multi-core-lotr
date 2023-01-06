#**************************************************************
# Clocks
#**************************************************************
create_clock  -name CLK_50   -period 20  [get_ports {CLK_50}]
#create_clock  -name CLK_25   -period 40

#create_generated_clock  -source CLK_50 	\
#                        -divide_by 1   	\
#                        -multiply_by 1 	\
#                        -duty_cycle 50.00 \
#                        -name QCLK_GEN    \
#                        {clk_i|QCLK|clk*|i_soc|sys_pll|sd1|pll7|clk[0]}


derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

set_clock_groups -asynchronous -group {CLK_50}
#set_clock_groups -asynchronous -group {QCLK_GEN}

#**************************************************************
# False Path
#**************************************************************
set_false_path -to   [get_ports {HEX*}]
set_false_path -to   [get_ports {LED*}]
set_false_path -to   [get_ports {INTERRUPT}]
set_false_path -to   [get_ports {UART_TXD}]
set_false_path -from [get_ports {UART_RXD}]
set_false_path -from [get_ports {SW*}]
set_false_path -from [get_ports {BUTTON*}]
set_false_path -to   [get_ports {GREEN*}]
set_false_path -to   [get_ports {BLUE*}]
set_false_path -to   [get_ports {RED*}]


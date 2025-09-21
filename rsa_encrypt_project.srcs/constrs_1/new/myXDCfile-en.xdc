## 7-seg outputs (a_to_g[6:0])
set_property PACKAGE_PIN T10 [get_ports {a_to_g[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_to_g[6]}]

set_property PACKAGE_PIN R10 [get_ports {a_to_g[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_to_g[5]}]

set_property PACKAGE_PIN K16 [get_ports {a_to_g[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_to_g[4]}]

set_property PACKAGE_PIN K13 [get_ports {a_to_g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_to_g[3]}]

set_property PACKAGE_PIN P15 [get_ports {a_to_g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_to_g[2]}]

set_property PACKAGE_PIN T11 [get_ports {a_to_g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_to_g[1]}]

set_property PACKAGE_PIN L18 [get_ports {a_to_g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {a_to_g[0]}]

## anodes an[0..7]
set_property PACKAGE_PIN J17 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]

set_property PACKAGE_PIN J18 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]

set_property PACKAGE_PIN T9  [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]

set_property PACKAGE_PIN J14 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

set_property PACKAGE_PIN P14 [get_ports {an[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[4]}]

set_property PACKAGE_PIN T14 [get_ports {an[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[5]}]

set_property PACKAGE_PIN K2  [get_ports {an[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[6]}]

set_property PACKAGE_PIN U13 [get_ports {an[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[7]}]

## decimal point and clock and pushbutton
set_property PACKAGE_PIN H15 [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN U18 [get_ports btnC]
set_property IOSTANDARD LVCMOS33 [get_ports btnC]

create_clock -period 10.000 -name sys_clk -waveform {0 5} [get_ports clk]
## Up pushbutton (BTNU)
set_property PACKAGE_PIN M18 [get_ports {btnU}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnU}]


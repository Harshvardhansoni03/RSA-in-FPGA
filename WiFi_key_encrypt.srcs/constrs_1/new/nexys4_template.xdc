## ================================================================
## Nexys-4 Template XDC (Cleaned for RSA WiFi Project)
## Only includes pins actually used in top.v
## ================================================================

## Clock (100 MHz onboard oscillator)
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## Reset (mapped to BTND - Down Button)
set_property PACKAGE_PIN P18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Buttons
# BTNL (Left)  -> show plaintext (m)
set_property PACKAGE_PIN P17 [get_ports {btnl}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnl}]

# BTNC (Center)-> show ciphertext (c)
set_property PACKAGE_PIN N17 [get_ports {btnc}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnc}]

# BTNR (Right) -> show decrypted (m_dec)
set_property PACKAGE_PIN M17 [get_ports {btnr}]
set_property IOSTANDARD LVCMOS33 [get_ports {btnr}]

## Switches
# SW0 -> toggle high/low half of 64-bit value
set_property PACKAGE_PIN J15 [get_ports {sw0}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw0}]

## Seven-Segment Display: Anodes
set_property PACKAGE_PIN J17 [get_ports {an[0]}]
set_property PACKAGE_PIN J18 [get_ports {an[1]}]
set_property PACKAGE_PIN T9  [get_ports {an[2]}]
set_property PACKAGE_PIN J14 [get_ports {an[3]}]
set_property PACKAGE_PIN P14 [get_ports {an[4]}]
set_property PACKAGE_PIN T14 [get_ports {an[5]}]
set_property PACKAGE_PIN K2  [get_ports {an[6]}]
set_property PACKAGE_PIN U13 [get_ports {an[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

## Seven-Segment Display: Segments (A-G)
set_property PACKAGE_PIN T10 [get_ports {seg[6]}] ;# Segment A
set_property PACKAGE_PIN R10 [get_ports {seg[5]}] ;# Segment B
set_property PACKAGE_PIN K16 [get_ports {seg[4]}] ;# Segment C
set_property PACKAGE_PIN K13 [get_ports {seg[3]}] ;# Segment D
set_property PACKAGE_PIN P15 [get_ports {seg[2]}] ;# Segment E
set_property PACKAGE_PIN T11 [get_ports {seg[1]}] ;# Segment F
set_property PACKAGE_PIN L18 [get_ports {seg[0]}] ;# Segment G
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

## ================================================================
## End of constraints
## ================================================================

###############################################################################
# GX-BIDT FPGA platform
# Chapter 2: 800x480 RGB888 LCD basic test
# FPGA: XC7A200TFBG484-2
#
# Pin sources:
#   - 2026 GX-BIDT full-board schematic, sheets 9, 11 and 14
#   - XC7A75T/100T/200T Bank 13/14/15 and Bank 16/34/35 schematics
###############################################################################

# 50 MHz FPGA_GCLK. The core-board net is B14_L12_P, package pin W19.
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports sys_clk]
create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]

# Active-low FPGA reset pushbutton. Bank 34 is powered from 1.5 V.
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS15} [get_ports sys_rst_n]

# Pattern mode switches. These are physical SW5, SW6 and SW7, routed through
# bus-switch group A with nOEA=0, S1A=0, S0A=0.
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {mode_sw[0]}]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {mode_sw[1]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports {mode_sw[2]}]

# LCD red channel: connector pins 3 through 10.
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {lcd_r[0]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {lcd_r[1]}]
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {lcd_r[2]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {lcd_r[3]}]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {lcd_r[4]}]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {lcd_r[5]}]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports {lcd_r[6]}]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {lcd_r[7]}]

# LCD green channel: connector pins 12 through 19.
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33} [get_ports {lcd_g[0]}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports {lcd_g[1]}]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {lcd_g[2]}]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {lcd_g[3]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {lcd_g[4]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {lcd_g[5]}]
set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVCMOS33} [get_ports {lcd_g[6]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports {lcd_g[7]}]

# LCD blue channel: connector pins 21 through 28.
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports {lcd_b[0]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33} [get_ports {lcd_b[1]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {lcd_b[2]}]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33} [get_ports {lcd_b[3]}]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {lcd_b[4]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {lcd_b[5]}]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {lcd_b[6]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {lcd_b[7]}]

# LCD control signals: connector pins 30 through 34 and pin 40.
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports lcd_pclk]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports lcd_hsync]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports lcd_vsync]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports lcd_de]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports lcd_bl]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports lcd_rst_n]

# Keep the 33 MHz single-ended LCD bus edges moderate.
set_property DRIVE 8 [get_ports {{lcd_r[*]} {lcd_g[*]} {lcd_b[*]} lcd_pclk lcd_hsync lcd_vsync lcd_de lcd_bl lcd_rst_n}]
set_property SLEW SLOW [get_ports {{lcd_r[*]} {lcd_g[*]} {lcd_b[*]} lcd_pclk lcd_hsync lcd_vsync lcd_de lcd_bl lcd_rst_n}]


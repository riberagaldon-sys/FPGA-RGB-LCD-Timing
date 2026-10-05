`timescale 1ns / 1ps

// XC7A200T: 100 MHz -> 33.333333 MHz pixel clock.
// VCO = 100 MHz * 10 = 1000 MHz; CLKOUT0 = 1000 / 30.
module lcd_clock_gen (
    input  wire clk_100m,
    input  wire reset,
    output wire pix_clk,
    output wire locked
);

    wire clk_fb;
    wire clk_fb_buf;
    wire pix_clk_mmcm;

    MMCME2_BASE #(
        .BANDWIDTH          ("OPTIMIZED"),
        .CLKIN1_PERIOD      (10.000),
        .DIVCLK_DIVIDE      (1),
        .CLKFBOUT_MULT_F    (10.000),
        .CLKOUT0_DIVIDE_F   (30.000),
        .CLKOUT0_DUTY_CYCLE (0.500),
        .CLKOUT0_PHASE      (0.000),
        .STARTUP_WAIT       ("FALSE")
    ) u_mmcm (
        .CLKIN1   (clk_100m),
        .RST      (reset),
        .PWRDWN   (1'b0),
        .CLKFBIN  (clk_fb_buf),
        .CLKFBOUT (clk_fb),
        .CLKOUT0  (pix_clk_mmcm),
        .LOCKED   (locked),
        .CLKOUT0B (),
        .CLKOUT1  (),
        .CLKOUT1B (),
        .CLKOUT2  (),
        .CLKOUT2B (),
        .CLKOUT3  (),
        .CLKOUT3B (),
        .CLKOUT4  (),
        .CLKOUT5  (),
        .CLKOUT6  ()
    );

    BUFG u_bufg_fb  (.I(clk_fb),       .O(clk_fb_buf));
    BUFG u_bufg_pix (.I(pix_clk_mmcm), .O(pix_clk));

endmodule

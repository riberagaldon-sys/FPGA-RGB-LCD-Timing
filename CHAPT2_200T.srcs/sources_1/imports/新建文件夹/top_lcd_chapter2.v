`timescale 1ns / 1ps

module top_lcd_chapter2 (
    input  wire       clk_100m,
    input  wire       key_reset,

    output wire       LCD_CLK,
    output wire       LCD_HSYNC,
    output wire       LCD_VSYNC,
    output wire       LCD_DE,
    output wire       LCD_BL,
    output wire       LCD_nRST,
    output wire [7:0] LCD_R,
    output wire [7:0] LCD_G,
    output wire [7:0] LCD_B
);

    wire        pix_clk;
    wire        mmcm_locked;
    wire        pix_rst_n;
    wire [10:0] pixel_x;
    wire [10:0] pixel_y;
    wire [23:0] pixel_rgb;

    lcd_clk_25m u_lcd_clk_25m (
        .clk_100m (clk_100m),
        .reset    (key_reset),
        .pix_clk  (pix_clk),
        .locked   (mmcm_locked)
    );

    reset_sync u_reset_sync (
        .clk    (pix_clk),
        .arst_n (mmcm_locked & ~key_reset),
        .srst_n (pix_rst_n)
    );

    lcd_timing_800x480_sample #(
        .DE_ONLY (1)
    ) u_timing (
        .pix_clk     (pix_clk),
        .rst_n       (pix_rst_n),
        .lcd_hsync   (LCD_HSYNC),
        .lcd_vsync   (LCD_VSYNC),
        .lcd_de      (LCD_DE),
        .pixel_x     (pixel_x),
        .pixel_y     (pixel_y),
        .frame_start ()
    );

    lcd_chapter2_pattern #(
        .PATTERN_MODE (3)
    ) u_pattern (
        .pixel_x   (pixel_x),
        .pixel_y   (pixel_y),
        .lcd_de    (LCD_DE),
        .pixel_rgb (pixel_rgb)
    );

    // The supplied sample keeps panel reset released and backlight enabled.
    // Keeping these independent of MMCM lock makes power/backlight diagnosis clear.
    assign LCD_BL   = 1'b1;
    assign LCD_nRST = ~key_reset;

    assign LCD_CLK = pix_clk;
    assign LCD_R   = LCD_DE ? pixel_rgb[23:16] : 8'h00;
    assign LCD_G   = LCD_DE ? pixel_rgb[15:8]  : 8'h00;
    assign LCD_B   = LCD_DE ? pixel_rgb[7:0]   : 8'h00;

endmodule

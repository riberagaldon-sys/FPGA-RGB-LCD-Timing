`timescale 1ns / 1ps

// Chapter 2 diagnostic image generator.
// RGB packing is {R[7:0], G[7:0], B[7:0]}.
module lcd_test_pattern #(
    parameter integer H_ACTIVE = 1024,
    parameter integer V_ACTIVE = 600
) (
    input  wire [2:0]  mode,
    input  wire [10:0] pixel_x,
    input  wire [10:0] pixel_y,
    input  wire        lcd_de,
    output reg  [23:0] pixel_rgb
);

    localparam [23:0] BLACK   = 24'h000000;
    localparam [23:0] WHITE   = 24'hFFFFFF;
    localparam [23:0] RED     = 24'hFF0000;
    localparam [23:0] GREEN   = 24'h00FF00;
    localparam [23:0] BLUE    = 24'h0000FF;
    localparam [23:0] YELLOW  = 24'hFFFF00;
    localparam [23:0] CYAN    = 24'h00FFFF;
    localparam [23:0] MAGENTA = 24'hFF00FF;
    localparam [23:0] DARK    = 24'h101820;

    always @(*) begin
        pixel_rgb = BLACK;

        if (lcd_de) begin
            case (mode)
                3'd0: pixel_rgb = RED;
                3'd1: pixel_rgb = GREEN;
                3'd2: pixel_rgb = BLUE;

                3'd3: begin
                    if (pixel_x < (H_ACTIVE * 1) / 8)
                        pixel_rgb = WHITE;
                    else if (pixel_x < (H_ACTIVE * 2) / 8)
                        pixel_rgb = YELLOW;
                    else if (pixel_x < (H_ACTIVE * 3) / 8)
                        pixel_rgb = CYAN;
                    else if (pixel_x < (H_ACTIVE * 4) / 8)
                        pixel_rgb = GREEN;
                    else if (pixel_x < (H_ACTIVE * 5) / 8)
                        pixel_rgb = MAGENTA;
                    else if (pixel_x < (H_ACTIVE * 6) / 8)
                        pixel_rgb = RED;
                    else if (pixel_x < (H_ACTIVE * 7) / 8)
                        pixel_rgb = BLUE;
                    else
                        pixel_rgb = BLACK;
                end

                3'd4: begin
                    if ((pixel_x < 4) ||
                        (pixel_x >= H_ACTIVE - 4) ||
                        (pixel_y < 4) ||
                        (pixel_y >= V_ACTIVE - 4))
                        pixel_rgb = WHITE;
                    else
                        pixel_rgb = DARK;
                end

                3'd5: begin
                    if ((pixel_x[4:0] == 5'd0) ||
                        (pixel_y[4:0] == 5'd0))
                        pixel_rgb = WHITE;
                    else
                        pixel_rgb = DARK;
                end

                3'd6: pixel_rgb = {
                    pixel_x[7:0],
                    pixel_y[7:0],
                    8'h80
                };

                default: pixel_rgb = BLACK;
            endcase
        end
    end

endmodule

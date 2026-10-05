`timescale 1ns / 1ps

module lcd_chapter2_pattern #(
    // 0 red, 1 green, 2 blue, 3 five color bars,
    // 4 border, 5 grid, 6 gradient.
    parameter integer PATTERN_MODE = 3
) (
    input  wire [10:0] pixel_x,
    input  wire [10:0] pixel_y,
    input  wire        lcd_de,
    output reg  [23:0] pixel_rgb
);

    wire border;
    wire grid;

    assign border =
        (pixel_x < 4)   || (pixel_x >= 796) ||
        (pixel_y < 4)   || (pixel_y >= 476);

    assign grid =
        (pixel_x[4:0] == 5'd0) ||
        (pixel_y[4:0] == 5'd0);

    always @(*) begin
        pixel_rgb = 24'h000000;

        if (lcd_de) begin
            case (PATTERN_MODE)
                0: pixel_rgb = 24'hFF0000;
                1: pixel_rgb = 24'h00FF00;
                2: pixel_rgb = 24'h0000FF;

                // Same five vertical bars as the supplied sample project.
                3: begin
                    if      (pixel_x < 160) pixel_rgb = 24'hFFFFFF;
                    else if (pixel_x < 320) pixel_rgb = 24'h000000;
                    else if (pixel_x < 480) pixel_rgb = 24'hFF0000;
                    else if (pixel_x < 640) pixel_rgb = 24'h00FF00;
                    else                    pixel_rgb = 24'h0000FF;
                end

                4: pixel_rgb =
                    border ? 24'hFFFFFF : 24'h102030;

                5: pixel_rgb =
                    grid ? 24'h506070 : 24'h101820;

                6: pixel_rgb =
                    {pixel_x[7:0], pixel_y[7:0], 8'h80};

                default: pixel_rgb = 24'hFF0000;
            endcase
        end
    end

endmodule

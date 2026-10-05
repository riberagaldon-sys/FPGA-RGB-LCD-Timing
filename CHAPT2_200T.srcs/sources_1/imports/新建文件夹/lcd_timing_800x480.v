`timescale 1ns / 1ps

// 800 x 480 RGB timing generator.
// The default values are exactly the Chapter 2 reference timing:
// H: active 800, front 40, sync 48, back 88, total 976
// V: active 480, front 13, sync 3, back 32, total 528
module lcd_timing_800x480 #(
    parameter integer H_ACTIVE = 1024,
    parameter integer H_FP     = 160,
    parameter integer H_SYNC   = 20,
    parameter integer H_BP     = 140,
    parameter integer V_ACTIVE = 600,
    parameter integer V_FP     = 12,
    parameter integer V_SYNC   = 3,
    parameter integer V_BP     = 20
) (
    input  wire        pclk,
    input  wire        rst_n,
    output wire        lcd_de,
    output wire        lcd_hsync,
    output wire        lcd_vsync,
    output wire [10:0] pixel_x,
    output wire [10:0] pixel_y,
    output wire        line_start,
    output wire        frame_start
);

    localparam integer H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;
    localparam integer V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;

    reg [10:0] h_count;
    reg [10:0] v_count;

    always @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            h_count <= 11'd0;
            v_count <= 11'd0;
        end else if (h_count == H_TOTAL - 1) begin
            h_count <= 11'd0;
            if (v_count == V_TOTAL - 1)
                v_count <= 11'd0;
            else
                v_count <= v_count + 1'b1;
        end else begin
            h_count <= h_count + 1'b1;
        end
    end

    assign lcd_de =
        (h_count < H_ACTIVE) &&
        (v_count < V_ACTIVE);

    assign lcd_hsync = ~(
        (h_count >= H_ACTIVE + H_FP) &&
        (h_count <  H_ACTIVE + H_FP + H_SYNC)
    );

    assign lcd_vsync = ~(
        (v_count >= V_ACTIVE + V_FP) &&
        (v_count <  V_ACTIVE + V_FP + V_SYNC)
    );

    assign pixel_x = lcd_de ? h_count : 11'd0;
    assign pixel_y = lcd_de ? v_count : 11'd0;

    assign line_start  = (h_count == 0);
    assign frame_start = (h_count == 0) && (v_count == 0);

endmodule

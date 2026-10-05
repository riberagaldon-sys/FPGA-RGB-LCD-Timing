`timescale 1ns / 1ps

// Timing profile taken from the supplied working 7-inch 800x480 sample:
// H: 128 sync + 88 back porch + 800 active + 40 front porch = 1056
// V:   2 sync + 33 back porch + 480 active + 10 front porch = 525
module lcd_timing_800x480_sample #(
    parameter integer H_SYNC   = 128,
    parameter integer H_BP     = 88,
    parameter integer H_ACTIVE = 800,
    parameter integer H_FP     = 40,
    parameter integer V_SYNC   = 2,
    parameter integer V_BP     = 33,
    parameter integer V_ACTIVE = 480,
    parameter integer V_FP     = 10,
    // The supplied sample uses DE mode and keeps HS/VS high.
    parameter integer DE_ONLY  = 1
) (
    input  wire        pix_clk,
    input  wire        rst_n,
    output wire        lcd_hsync,
    output wire        lcd_vsync,
    output wire        lcd_de,
    output wire [10:0] pixel_x,
    output wire [10:0] pixel_y,
    output wire        frame_start
);

    localparam integer H_TOTAL = H_SYNC + H_BP + H_ACTIVE + H_FP;
    localparam integer V_TOTAL = V_SYNC + V_BP + V_ACTIVE + V_FP;
    localparam integer H_START = H_SYNC + H_BP;
    localparam integer V_START = V_SYNC + V_BP;

    reg [10:0] h_cnt;
    reg [10:0] v_cnt;

    wire h_active;
    wire v_active;

    assign h_active = (h_cnt >= H_START) &&
                      (h_cnt <  H_START + H_ACTIVE);
    assign v_active = (v_cnt >= V_START) &&
                      (v_cnt <  V_START + V_ACTIVE);

    assign lcd_de = h_active && v_active;

    // Reference sample: DE-only mode, HS/VS are held inactive-high.
    // Set DE_ONLY=0 only if the actual panel requires low-active sync pulses.
    assign lcd_hsync = DE_ONLY ? 1'b1 : ~(h_cnt < H_SYNC);
    assign lcd_vsync = DE_ONLY ? 1'b1 : ~(v_cnt < V_SYNC);

    assign pixel_x = h_active ? h_cnt - H_START : 11'd0;
    assign pixel_y = v_active ? v_cnt - V_START : 11'd0;
    assign frame_start = (h_cnt == 0) && (v_cnt == 0);

    always @(posedge pix_clk or negedge rst_n) begin
        if (!rst_n) begin
            h_cnt <= 11'd0;
            v_cnt <= 11'd0;
        end else if (h_cnt == H_TOTAL - 1) begin
            h_cnt <= 11'd0;
            if (v_cnt == V_TOTAL - 1)
                v_cnt <= 11'd0;
            else
                v_cnt <= v_cnt + 1'b1;
        end else begin
            h_cnt <= h_cnt + 1'b1;
        end
    end

endmodule

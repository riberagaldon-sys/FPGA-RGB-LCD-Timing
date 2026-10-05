`timescale 1ns / 1ps

// LCD power-on sequence used by Chapter 2:
//   1. Hold the panel in reset.
//   2. Release LCD reset after RESET_DELAY_MS.
//   3. Enable the backlight after BL_DELAY_MS.
module lcd_power_seq #(
    parameter integer CLK_HZ         = 33_333_000,
    parameter integer RESET_DELAY_MS = 10,
    parameter integer BL_DELAY_MS    = 50
) (
    input  wire clk,
    input  wire rst_n,
    output reg  lcd_rst_n,
    output reg  lcd_bl
);

    localparam integer RESET_DELAY_CYCLES =
        (CLK_HZ / 1000) * RESET_DELAY_MS;
    localparam integer BL_DELAY_CYCLES =
        (CLK_HZ / 1000) * BL_DELAY_MS;
    localparam integer COUNTER_MAX =
        (BL_DELAY_CYCLES > RESET_DELAY_CYCLES) ?
        BL_DELAY_CYCLES : RESET_DELAY_CYCLES;
    localparam integer COUNTER_W =
        (COUNTER_MAX <= 1) ? 1 : $clog2(COUNTER_MAX + 1);

    reg [COUNTER_W-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= {COUNTER_W{1'b0}};
            lcd_rst_n <= 1'b0;
            lcd_bl    <= 1'b0;
        end else begin
            if (count < COUNTER_MAX)
                count <= count + 1'b1;

            if ((RESET_DELAY_CYCLES <= 1) ||
                (count >= RESET_DELAY_CYCLES - 1))
                lcd_rst_n <= 1'b1;

            if ((BL_DELAY_CYCLES <= 1) ||
                (count >= BL_DELAY_CYCLES - 1))
                lcd_bl <= 1'b1;
        end
    end

endmodule

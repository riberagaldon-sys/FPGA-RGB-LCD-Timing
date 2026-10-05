`timescale 1ns / 1ps

// Generic one-clock-wide periodic tick generator.
// Included because Chapter 2 introduces this reusable building block.
module tick_gen #(
    parameter integer CLK_HZ  = 33_333_000,
    parameter integer TICK_HZ = 1_000
) (
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);

    localparam integer DIVISOR = CLK_HZ / TICK_HZ;
    localparam integer CNT_W   = (DIVISOR <= 1) ? 1 : $clog2(DIVISOR);

    reg [CNT_W-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= {CNT_W{1'b0}};
            tick  <= 1'b0;
        end else if (DIVISOR <= 1) begin
            count <= {CNT_W{1'b0}};
            tick  <= 1'b1;
        end else if (count == DIVISOR - 1) begin
            count <= {CNT_W{1'b0}};
            tick  <= 1'b1;
        end else begin
            count <= count + 1'b1;
            tick  <= 1'b0;
        end
    end

endmodule

`timescale 1ns / 1ps

// Chapter 3 uses the CHAPT2_200T minimal LCD design.
// Simulation top: tb_chapter3_lcd. Synthesis top: top_lcd_test.
// The real clk_wiz_lcd IP is instantiated inside the DUT.
// No clock, locked signal, counter, or DUT parameter is forced here.
module tb_chapter3_lcd;

    reg        sys_clk   = 1'b0;
    reg        sys_rst_n = 1'b0;
    reg [2:0]  mode_sw   = 3'b000;

    wire       lcd_pclk;
    wire       lcd_hsync;
    wire       lcd_vsync;
    wire       lcd_de;
    wire       lcd_bl;
    wire       lcd_rst_n;
    wire [7:0] lcd_r;
    wire [7:0] lcd_g;
    wire [7:0] lcd_b;

    // Read-only aliases: all screenshot signals are visible at TB scope.
    wire        pix_clk;
    wire        clk_locked;
    wire        pix_rst_n;
    wire [2:0]  mode;
    wire [10:0] h_count;
    wire [10:0] v_count;
    wire [10:0] pixel_x;
    wire [10:0] pixel_y;
    wire        de_int;
    wire [23:0] pixel_rgb;

    // Captured event times, in ps, for the Tcl screenshot helpers.
    reg [63:0] lock_time_ps          = 64'd0;
    reg [63:0] reset_release_time_ps = 64'd0;
    reg [63:0] active_exit_time_ps   = 64'd0;
    reg [63:0] next_active_time_ps   = 64'd0;
    reg [63:0] pixel_period_ps       = 64'd0;
    reg        monitor_done         = 1'b0;
    realtime   previous_pixel_edge_ns;

    top_lcd_test dut (
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),
        .mode_sw   (mode_sw),
        .lcd_pclk  (lcd_pclk),
        .lcd_hsync (lcd_hsync),
        .lcd_vsync (lcd_vsync),
        .lcd_de    (lcd_de),
        .lcd_bl    (lcd_bl),
        .lcd_rst_n (lcd_rst_n),
        .lcd_r     (lcd_r),
        .lcd_g     (lcd_g),
        .lcd_b     (lcd_b)
    );

    assign pix_clk    = dut.pix_clk;
    assign clk_locked = dut.clk_locked;
    assign pix_rst_n  = dut.pix_rst_n;
    assign mode       = dut.mode;
    assign h_count    = dut.u_lcd_timing.h_count;
    assign v_count    = dut.u_lcd_timing.v_count;
    assign pixel_x    = dut.pixel_x;
    assign pixel_y    = dut.pixel_y;
    assign de_int     = dut.de_int;
    assign pixel_rgb  = dut.pixel_rgb;

    // 50 MHz input, as specified by the real IP and the 20 ns XDC clock.
    always #10 sys_clk = ~sys_clk;

    initial begin
        #200;
        sys_rst_n = 1'b1;
    end

    initial begin
        wait (clk_locked === 1'b1);
        lock_time_ps = $realtime * 1000.0;
        $display("CH3: clk_locked rises at %0.3f us", $realtime / 1000.0);

        wait (pix_rst_n === 1'b1);
        reset_release_time_ps = $realtime * 1000.0;
        $display("CH3: pix_rst_n rises at %0.3f us", $realtime / 1000.0);

        @(posedge pix_clk);
        previous_pixel_edge_ns = $realtime;
        @(posedge pix_clk);
        pixel_period_ps = ($realtime - previous_pixel_edge_ns) * 1000.0;

        @(negedge de_int);
        active_exit_time_ps = $realtime * 1000.0;
        $display("CH3: first active row exits at %0.3f us", $realtime / 1000.0);

        @(posedge de_int);
        next_active_time_ps = $realtime * 1000.0;
        monitor_done = 1'b1;
        $display("CH3: next active row enters at %0.3f us", $realtime / 1000.0);
        $display("CH3: event times captured; use the figure Tcl scripts.");
    end

    // Intentionally no $finish or $stop. Vivado's configured runtime pauses
    // this run at 200 us. The figure scripts only change the waveform view.
endmodule

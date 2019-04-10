`timescale 1ns/1ns
module vga_tb;
  reg clk25, reset;
  wire [11:0] rgb_out;
  wire hsync;
  wire vsync;

  vga display_controller(clk25, reset, rgb_out, hsync, vsync);

  initial begin
    $dumpfile("vga_tb.vcd");
    $dumpvars(0, vga_tb);

    clk25 = 1'b0;
    reset = 1'b1;
    #10 reset = 1'b0;
    #200;
    reset = 1'b1;
    #10 reset = 1'b0;
    #200;
    reset = 1'b1;
    #25000000;
    $finish;
  end

  // 25MHz Pixelclock -> Timescale 1ns/1ns
  always #20 clk25 = ~clk25;

endmodule

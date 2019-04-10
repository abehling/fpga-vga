module top_vga(clk, rgb_out, hsync, vsync);

  input clk;
  reg reset = 1'b1;  // Dirty Hack: There is no reset (spoon)! ;)

  output wire [11:0] rgb_out;
  output wire hsync;
  output wire vsync;

  wire clk25;
  wire locked;

  // This pll only generates 25 MHz clock, generated with icepll -i 100 -o 25 -m -f pll.v
  pll pll25(clk, clk25, locked);
  vga display_controller(clk25, reset, rgb_out, hsync, vsync);

endmodule

module top_vga(clk, rgb_out, hsync, vsync);

  input clk;
  reg reset = 1'b1;  // Dirty Hack: There is no reset (spoon)! ;)

  output wire [11:0] rgb_out;
  output wire hsync;
  output wire vsync;

  reg [1:0] clkcounter = 2'b00;
  wire clk25;
  assign clk25 = clkcounter[1];

  vga display_controller(clk25, reset, rgb_out, hsync, vsync);

  // counter, until I understand PLL
  always @(posedge clk)
  begin
    clkcounter <= clkcounter + 1;
  end
endmodule

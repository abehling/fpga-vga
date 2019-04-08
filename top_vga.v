module top_vga(clk, rgb_out, hsync, vsync);

  input clk;
  reg reset = 1'b1;  // Dirty Hack: There is no reset (spoon)! ;)

  output wire [11:0] rgb_out;
  output wire hsync;
  output wire vsync;

  reg [1:0] clkcounter = 2'b00;
  wire clk25;
  assign clk25 = clkcounter[1];
//  wire clk50;
//  assign clk50 = clkcounter[0];

  vga display_controller(clk25, reset, rgb_out, hsync, vsync);

//  vga #(.V_POL(1'b0),
//        .H_POL(1'b0),
//        .SCREEN_WIDTH(800),
//        .SCREEN_HEIGHT(600),
//        .H_FP(56),
//        .H_SYNC(120),
//        .H_BP(64),
//        .V_FP(37),
//        .V_SYNC(6),
//        .V_BP(23)) display_controller(clk50, reset, rgb_out, hsync, vsync);

  // counter, until I understand PLL
  always @(posedge clk)
  begin
    clkcounter <= clkcounter + 1;
  end
endmodule

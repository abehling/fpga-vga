`timescale 1ns/1ns
module vga_tb;
  reg clk, reset;
  wire [11:0] out;
  wire hsync;
  wire vsync;

  top_vga display (clk, out, hsync, vsync);

  initial begin
    $dumpfile("vga_tb.vcd");
    $dumpvars(0, vga_tb);

    clk = 1'b0;
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

  // 100MHz Clock -> Timescale 1ns/1ns
  always #5 clk = ~clk;

endmodule

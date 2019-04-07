module vga (clk, reset, out, hsync, vsync);

  parameter SCREEN_WIDTH = 640;
  parameter SCREEN_HEIGHT = 480;
  parameter V_POL = 1'b1;
  parameter H_POL = 1'b1;
  // Timing for horizontal front porch, pulse time and back porch
  parameter H_FP = 16;
  parameter H_SYNC = 96;
  parameter H_BP = 48;
  parameter H_MAX = H_FP + H_SYNC + H_BP + SCREEN_WIDTH;

  // Timing for vertical front porch, pulse time and back porch
  parameter V_FP = 10;
  parameter V_SYNC = 2;
  parameter V_BP = 33;
  parameter V_MAX = V_FP + V_SYNC + V_BP + SCREEN_HEIGHT;

  input clk, reset;
  
  // The PMOD VGA connector has 4 Bit for each color
  output reg [11:0] out = 12'b000000000000;

  // for 640x480 both are active low
  output reg hsync = H_POL;
  output reg vsync = V_POL;
  
  reg [9:0] counterH = 0;
  reg [9:0] counterV = 0;


  always @(posedge clk)
    begin
      if (~reset)
        begin
          counterH <= 0;
          counterV <= 0;
          out <= 12'b000000000000;
        end
      else 
        begin
          if (counterH > H_FP+H_SYNC+H_BP && counterH < H_FP+H_SYNC+H_BP+SCREEN_WIDTH)
            begin
              // Now we are in the visible area
              // Pixel Format is RGB444
              // Draw something
              if (counterH % 8 < 4 && counterV % 8 < 4)
                out <= 12'b000011110000;
              else if (counterH % 8 > 4 && counterV % 8 > 4) 
                out <= 12'b111100000000;
              else
                out <= 12'b111111111111;
            end
          else if (counterH == H_FP)
            // hsync pulse starts
            hsync <= ~H_POL;
          else if (counterH == H_FP+H_SYNC)
            begin
              // hsync pulse ends
              hsync <= H_POL;
            end
          else if (counterH == H_MAX)
            begin
              counterH <= 0;
              counterV <= counterV + 1;
            end

          if (counterV == SCREEN_HEIGHT+V_FP)
            // vsync pulse starts
            vsync <= ~V_POL;
          if (counterV == SCREEN_HEIGHT+V_FP+V_SYNC)
            // vsync pulse ends
            vsync <= V_POL;
          if (counterV == V_MAX)
            counterV <= 0;
          counterH <= counterH + 1;
        end
    end
endmodule

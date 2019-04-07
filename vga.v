module vga (clk, reset, out, hsync, vsync);

  input clk, reset;
  
  // The PMOD VGA connector has 4 Bit for each color
  output reg [11:0] out = 12'b000000000000;

  // for 640x480 both are active low
  output reg hsync = 1'b1;
  output reg vsync = 1'b1;
  
  reg [9:0] counterH = 0;
  reg [9:0] counterV = 0;

  // Timing for horizontal front porch, pulse time and back porch
  localparam H_FP = 16;
  localparam H_SYNC = 96;
  localparam H_BP = 48;
  localparam H_MAX = H_FP + H_SYNC + H_BP + 640;

  // Timing for vertical front porch, pulse time and back porch
  localparam V_FP = 10;
  localparam V_SYNC = 2;
  localparam V_BP = 33;
  localparam V_MAX = V_FP + V_SYNC + V_BP + 480;

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
          if (counterH > H_FP+H_SYNC+H_BP && counterH < H_FP+H_SYNC+H_BP+640)
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
            hsync <= ~hsync;
          else if (counterH == H_FP+H_SYNC)
            begin
              // hsync pulse ends and line max is reached
              hsync <= ~hsync;
            end
          else if (counterH == H_MAX)
            begin
              counterH <= 0;
              counterV <= counterV + 1;
            end

          if (counterV == 480+V_FP)
            // vsync pulse starts
            vsync <= 1'b0;
          if (counterV == 480+V_FP+V_SYNC)
            begin
              // vsync pulse ends and frame max is reached
              vsync <= 1'b1;
            end
          if (counterV == V_MAX)
            counterV <= 0;
          counterH <= counterH + 1;
        end
    end
endmodule

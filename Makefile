bin:
	yosys -p 'synth_ice40 -json vga.json -top top_vga' vga.v top_vga.v
	nextpnr-ice40 --hx8k --asc vga.asc --pcf vga.pcf --json vga.json
	icepack vga.asc vga.bin

test:
	iverilog -o vga_tb vga_tb.v vga.v top_vga.v
	./vga_tb
	gtkwave vga_tb.vcd

clean:
	rm -f vga_tb vga_tb.vcd vga.json vga.asc vga.bin

SYN = yosys
PNR = arachne-pnr
GEN = icepack
PROG = iceprog

TOP = uart_demo.v
PCF = icestick.pcf
DEVICE = 1k

OUTPUT = $(addsuffix .bin, $(basename $(TOP)))

all: $(OUTPUT)

%.bin: %.txt
	$(GEN) $< $@

%.txt: %.blif
	$(PNR) -d $(DEVICE) -p $(PCF) -o $@ $<

%.blif: %.v
	$(SYN) -p "read_verilog $<; synth_ice40 -flatten -blif $@"

clean:
	rm -f *.bin *.blif *.txt

flash: $(OUTPUT)
	$(PROG) $<

.PHONY: all clean flash
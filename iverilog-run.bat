iverilog -o testbench cdp1802.v ram.v t_testbench.v
vvp testbench
gtkwave t_testbench.vcd
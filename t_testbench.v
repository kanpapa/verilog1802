`timescale 1ns / 1ps

module t_testbench;
  // Inputs
  reg clock;
  reg resetq;
  
  // Outputs
  wire [7:0] cc;
  wire unsupported;
  wire [7:0] io_din;
  wire io_inp;
  wire io_out;
  wire [7:0] io_dout;
  wire [2:0] io_n;

  reg [7:0] count;
  always @(posedge clock)
    count <= count + 1;
  
  assign cc = count;

  wire ram_rd, ram_wr;       // RAM write enable
  wire [7:0] ram_q, ram_d;   // RAM read data,RAM write data
  wire [15:0] ram_a;         // RAM address

  ram _ram (
    .clk(clock),
    .re(ram_rd),
    .we(ram_wr),
    .d(ram_d),
    .a(ram_a),
    .q(ram_q)
  );

  wire Q;
  cdp1802 cdp1802 (
    .clock(clock),
    .resetq(resetq),
    .Q(Q),
    .EF(4'b0000),

    .io_n(io_n),
    .io_inp(io_inp),
    .io_out(io_out),

    .ram_rd(ram_rd),
    .ram_wr(ram_wr),
    .ram_q(ram_q),
    .ram_d(ram_d),
    .ram_a(ram_a),

    .io_din(io_din),
    .io_dout(io_dout),

    .unsupported(unsupported)
  );
  
  integer i;
 
  initial begin
    $dumpfile("t_testbench.vcd");
    $dumpvars(0, t_testbench);
    clock = 0;

    // Setup RAM Area
    _ram.store[0]=8'h7b;    // 0000 7B    START SEQ
    _ram.store[1]=8'h7a;    // 0001 7A          REQ
    _ram.store[2]=8'h30;    // 0002 30 00       BR START
    _ram.store[3]=8'h00;

    #100
    
    resetq = 0;

    #20

    resetq = 1;

    for(i=0; i<255; i=i+1)
      #10 clock = ~clock;
  end    
endmodule
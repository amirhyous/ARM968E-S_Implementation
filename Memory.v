module Memory (
    clk,
    MEM_R_EN,
    MEM_W_EN,
    address,
    d_in,
    d_out
);
  input clk, MEM_R_EN, MEM_W_EN;
  input [31:0] address;
  input [31:0] d_in;
  output [31:0] d_out;

  reg  [31:0] mem [0:64];
  wire [31:0] adr;

  always @(posedge clk) if (MEM_W_EN) {mem[(address-32'd1024)>>2]} <= d_in;

  assign d_out = (MEM_R_EN) ? mem[(address-32'd1024)>>2] : 32'd0;
endmodule

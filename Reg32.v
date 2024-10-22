module Reg32 (
    clk,
    rst,
    load,
    data_in,
    data_out
);
  input clk;
  input rst;
  input load;
  input [31:0] data_in;
  output reg [31:0] data_out;
  always @(posedge clk) begin
    if (rst) data_out = 32'd0;
    else if (load) data_out = data_in;
  end
endmodule

module Mux3to1_32b (
    input  [31:0] a,
    b,
    c,
    input  [ 1:0] sel,
    output [31:0] out
);
  assign out = (sel == 2'd0) ? a : (sel == 2'd1) ? b : (sel == 2'd2) ? c : 32'dZ;
endmodule

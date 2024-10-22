// `timescale 1ns / 1ns
// module Condition_Check (
//     input [3:0] condition,
//     status,
//     output reg out
// );
//   parameter EQ = 0, NE = 1, CS = 2, CC = 3, MI = 4, PL = 5, VS = 6, VC = 7
// 		, HI = 8, LS = 9, GE = 10, LT = 11, GT = 12, LE = 13, AL = 14;
//   wire n, z, c, v;

//   assign n = status[3];
//   assign z = status[2];
//   assign c = status[1];
//   assign v = status[0];
//   always @(condition,n,c,z,v) begin
//     case (condition)
//       EQ: out = z;
//       NE: out = ~z;
//       CS: out = c;
//       CC: out = ~c;
//       MI: out = n;
//       PL: out = ~n;
//       VS: out = v;
//       VC: out = ~v;
//       HI: out = c & (~z);
//       LS: out = (~c) | z;
//       GE: out = (n == v);
//       LT: out = (n != v);
//       GT: out = (~z) & (n == v);
//       LE: out = z | (n != v);
//       AL: out = 1'b1;
//       default: out = 1'b1;
//     endcase
//   end
// endmodule

// module Condition_Check_TB ();

//   reg [3:0] condition, status;
//   wire out;

//   Condition_Check UUT (
//       condition,
//       status,
//       out
//   );
//   initial begin


//     #13 condition = 4'b0000;
//     #10 status = 4'b0000;

//     #13 condition = 4'b1010;

//     #20 $stop;
//   end

// endmodule

module Condition_Check (
    cond,
    status,
    cond_Check_Out
);

  input [3:0] cond;
  input [3:0] status;
  output cond_Check_Out;
  reg out;
  assign N = status[3];
  assign Z = status[2];
  assign C = status[1];
  assign V = status[0];
  assign cond_Check_Out = out;
  always @(cond, Z, C, N, V) begin
    out = 1'b0;
    case (cond)
      4'b0000: out = Z;
      4'b0001: out = ~Z;
      4'b0010: out = C;
      4'b0011: out = ~C;
      4'b0100: out = N;
      4'b0101: out = ~N;
      4'b0110: out = V;
      4'b0111: out = ~V;
      4'b1000: out = C & ~Z;
      4'b1001: out = ~C & Z;
      4'b1010: out = N ~^ V;
      4'b1011: out = N ^ V;
      4'b1100: out = ~Z & (N ~^ V);
      4'b1101: out = Z & (N ^ V);
      4'b1110: out = 1'b1;

    endcase
  end
endmodule

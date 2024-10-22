`timescale 1ns/1ns
module Fetch_Tb();
  reg clk, rst, hazard, branch_taken_mux_sel;
  reg [31:0] branch_address;
  wire [31:0] PC, instruction;
  fetch UUT (clk,rst,hazard,branch_taken_mux_sel,branch_address,PC,instruction);
  initial begin
    clk = 1'b0;
    repeat (1000) #5 clk = ~clk;
end
initial begin
  branch_taken_mux_sel = 1'b0;
  rst = 1'b1;
  #20 rst = 1'b0;
  #100;
  hazard = 1'b0;
  #100;
end
endmodule
  

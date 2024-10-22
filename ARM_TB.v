`timescale 1ns / 1ns
module ARM_TB ();
  reg clk, rst, fw_en;
  wire [15:0] SRAM_DQ;
  wire [17:0] SRAM_ADDR;
  wire SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
  myARM UUT (
      clk,
      rst,
      fw_en,
      SRAM_DQ,
      SRAM_ADDR,
      SRAM_UB_N,
      SRAM_LB_N,
      SRAM_WE_N,
      SRAM_CE_N,
      SRAM_OE_N
  );
  initial begin
    clk = 1'b1;
    repeat (800) #5 clk = ~clk;
  end
  initial begin
    fw_en = 1'b1;
    rst   = 1'b1;
    #20 rst = 1'b0;
    #4000;
    $stop;
  end
endmodule

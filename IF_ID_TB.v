`timescale 1ns/1ns
module Fetch_ID_TB();
  reg clk;
  reg rst;
  reg freeze;
  reg branch_taken_mux_sel;
  wire [31:0] PC_out_IF, inst_out_IF, PC_out_IF_Reg, inst_out_IF_Reg, PC_out_ID;
  wire [31:0] Result_WB, Val_Rn, Val_Rm;
  wire writeBackEn, imm;
  reg hazard, flush;
  wire Two_src;
  wire [3:0] Dest_wb, SR, Dest,src1, src2;
  wire [8:0] Control_Signals_Out;
  wire [11:0] Shift_Operand;
  wire [23:0] Signed_imm_24;

  fetch fetch (.clk(clk),.rst(rst),.freeze(freeze),.branch_taken_mux_sel(branch_taken_mux_sel),.branch_address(32'd10),.PC(PC_out_IF),.instruction(inst_out_IF));

  IF_Stage_Reg IF_Reg ( .clk(clk), .rst(rst), .freeze(freeze), .flush(flush),.PC_in(PC_out_IF), .Instruction_in(inst_out_IF), .PC(PC_out_IF_Reg), .Instruction(inst_out_IF_Reg));

  ID_Stage ID(.pc_in(PC_out_IF_Reg),.clk(clk),.rst(rst),.Instruction(inst_out_IF_Reg),.Result_WB(Result_WB),.writeBackEn(writeBackEn),.Dest_wb(Dest_wb),.hazard(hazard),.SR(SR)
  ,.pc_out(PC_out_ID), .Control_Signals_Out(Control_Signals_Out),.Val_Rn(Val_Rn),.Val_Rm(Val_Rm),.imm(imm), .Shift_Operand(Shift_Operand),.Signed_imm_24(Signed_imm_24),
  .Dest(Dest),.src1(src1),.src2(src2),.Two_src(Two_src));
  initial begin
    clk = 1'b0;
    repeat (1000) #5 clk=~clk;
  end
  initial begin
    hazard = 1'b0;
    rst = 1'b1;
    freeze = 1'b0;
    branch_taken_mux_sel=1'b0;
    #20 rst = 1'b0;
    #2000;
    end
endmodule

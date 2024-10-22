`timescale 1ns/1ns
module ID_TB();

reg clk, rst, writeBackEn, hazard;
reg [3:0] Dest_wb, SR;
reg [31:0] pc_in, Instruction, Result_WB;

wire imm, Two_src;
wire [3:0] Dest, src1, src2;
wire [8:0] Control_Signals_Out;
wire [11:0] Shift_Operand;
wire [23:0] Signed_imm_24;
wire [31:0] Val_Rn, Val_Rm, pc_out;

ID_Stage UUT(.pc_in(pc_in),
.clk(clk),
.rst(rst),
.Instruction(Instruction),
.Result_WB(Result_WB),
.writeBackEn(writeBackEn),
.Dest_wb(Dest_wb),
.hazard(hazard),
.SR(SR),
.pc_out(pc_out),
.Control_Signals_Out(Control_Signals_Out),
.Val_Rn(Val_Rn),
.Val_Rm(Val_Rm),
.imm(imm),
.Shift_Operand(Shift_Operand),
.Signed_imm_24(Signed_imm_24),
.Dest(Dest),
.src1(src1),
.src2(src2),
.Two_src(Two_src));

initial begin
  clk = 1'b0;
  repeat (1000) #5 clk = ~clk;
end
 initial begin
 hazard = 1'b0;
 #20 Instruction =32'b11100011101000000000000000010100;
 #100;
 #20 Instruction = 32'b11100000010001000101000100000100; 
 #100;
 end
 
endmodule

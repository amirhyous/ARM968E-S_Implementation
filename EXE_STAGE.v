module EXE_Stage (
    input clk,
    input [3:0] EXE_CMD,
    input MEM_R_EN,
    MEM_W_EN,
    input [31:0] PC,
    input [31:0] Val_Rn,
    Val_Rm_in,
    input imm,
    input [11:0] Shift_operand,
    input [23:0] Signed_imm_24,
    input [3:0] SR,

    output [31:0] ALU_result,
    Br_addr,
    output [ 3:0] status,
    input  [31:0] ALU_fw,
    input  [ 1:0] sel_src1,
    sel_src2,
    output [31:0] Val_Rm_out,
    input  [31:0] WB_value
);
  wire mem_op;
  wire [31:0] Val2, ALU_op1;
  assign mem_op = MEM_R_EN | MEM_W_EN;
  ALU alu1 (
      .Val1(ALU_op1),
      .Val2(Val2),
      .EXE_CMD(EXE_CMD),
      .status_bits(SR),
      .out(ALU_result),
      .status_bits_out(status)
  );
  Val2_Generate Val2gen (
      .Val_Rm(Val_Rm_out),
      .MEM_OP(mem_op),
      .imm(imm),
      .shift_operand(Shift_operand),
      .out(Val2)
  );
  Adder PC_EXE_ADDER (
      .a  (PC),
      .b  ({{{8{Signed_imm_24[23]}}, Signed_imm_24}} << 2),
      .out(Br_addr)
  );
  Mux3to1_32b Mux_1 (
      Val_Rn,
      ALU_fw,
      WB_value,
      sel_src1,
      ALU_op1
  );
  Mux3to1_32b Mux_2 (
      Val_Rm_in,
      ALU_fw,
      WB_value,
      sel_src2,
      Val_Rm_out
  );

endmodule


module ID_Stage (
    input clk,
    input rst,
    input [31:0] Instruction,
    input [31:0] Result_WB,
    input writeBackEn,
    input [3:0] Dest_wb,
    input hazard,
    input [3:0] SR,
    output [8:0] Control_Signals_Out,
    output [31:0] Val_Rn,
    Val_Rm,
    output imm,
    output [11:0] Shift_Operand,
    output [23:0] Signed_imm_24,
    output [3:0] Dest,
    output [3:0] src1,
    src2,
    output Two_src
);
  wire [3:0] Cond;
  wire Cond_out;
  wire [1:0] mode;
  wire [3:0] opcode;
  wire S_in;
  wire WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, B_in, S_mux;
  wire [3:0] EXE_CMD_in;
  wire [3:0] src1_in, src2_in, Rd_in;
  wire Cond_Mux_Sel;
  wire [8:0] Control_Signals;
  wire [8:0] Control_Mux_Out;
  assign mode = Instruction[27:26];
  assign S_in = Instruction[20];
  assign opcode = Instruction[24:21];
  assign Cond = Instruction[31:28];
  assign src1_in = Instruction[19:16];
  assign src2_in = Instruction[3:0];
  assign Rd_in = (Control_Signals_Out[6]) ? Instruction[15:12] : src2_in;
  assign Cond_Mux_Sel = (~Cond_out) | hazard;
  assign Control_Signals = {WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, EXE_CMD_in, B_in, S_mux};
  assign Control_Mux_Out = (Cond_Mux_Sel) ? 9'd0 : Control_Signals;
  assign Control_Signals_Out = Control_Mux_Out;
  assign src1 = src1_in;
  assign src2 = Rd_in;
  assign Shift_Operand = Instruction[11:0];
  assign Signed_imm_24 = Instruction[23:0];
  assign Dest = Instruction[15:12];
  assign imm = Instruction[25];
  assign Two_src = (~Instruction[25]) | (Control_Signals[6]);  //completed but still??
  Condition_Check cond_check (
      Cond,
      SR,
      Cond_out
  );
  Control_Unit control_unit (
      mode,
      opcode,
      S_in,
      EXE_CMD_in,
      MEM_R_EN_in,
      MEM_W_EN_in,
      WB_EN_in,
      B_in,
      S_mux
  );
  Register_File RF (
      clk,
      rst,
      src1_in,
      Rd_in,
      Dest_wb,
      Result_WB,
      writeBackEn,
      Val_Rn,
      Val_Rm
  );
endmodule

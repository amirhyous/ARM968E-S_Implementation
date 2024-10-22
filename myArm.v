module myARM (
    input clk,
    rst,
    fw_en,
    inout [15:0] SRAM_DQ,
    output [17:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OE_N
);
  //Internal Wires
  wire freeze,Branch_taken,flush,WB_WB_EN,hazard,imm_ID_S,Two_src,WB_EN_ID_R, MEM_R_EN_ID_R, MEM_W_EN_ID_R,B_ID_R,S_ID_R,imm_ID_R;
  wire [31:0] BranchAddr, PC_IF_S, instruction_IF_S, PC_ID_R;
  wire [31:0] PC_IF_R, instruction_IF_R;
  wire [31:0] WB_value;
  wire [ 3:0] WB_Dest;
  wire [ 3:0] SR;
  wire [ 8:0] Control_Signals_Out_ID_S;
  wire [31:0] Val_Rn_ID_S, Val_Rm_ID_S;
  wire [11:0] Shift_Operand_ID_S, Shift_Operand_ID_R;
  wire [23:0] Signed_imm_24_ID_S, Signed_imm_24_ID_R;
  wire [3:0] Dest_ID_S, src1_ID_S, src2_ID_S, Dest_ID_R, Dest_EXE_R, Dest_MEM_R;
  wire [3:0] EXE_CMD_ID_R;
  wire [31:0] Val_Rn_ID_R, Val_Rm_ID_R, Val_Rm_EXE_R, Val_Rm_EXE_S;
  wire [31:0] ALU_result_EXE_S, Br_addr_EXE_S, ALU_result_EXE_R, ALU_result_MEM_R;
  wire [3:0] status_EXE_S;
  wire WB_en_EXE_R, MEM_R_EN_EXE_R, MEM_W_EN_EXE_R, MEM_R_EN_MEM_R;
  wire [31:0] MEM_result, MEM_result_MEM_R;
  wire [3:0] SR_out, SR_ID_R;
  wire [1:0] sel_src1, sel_src2;
  wire [3:0] src1_ID_R, src2_ID_R;
  wire SRAM_Freeze, SRAM_READY;
  //Stages and REGs
  IF_Stage IF_S (
      clk,
      rst,
      (freeze | SRAM_Freeze),
      B_ID_R,
      BranchAddr,
      PC_IF_S,
      instruction_IF_S
  );


  IF_Stage_Reg IF_R (
      clk,
      rst,
      (freeze | SRAM_Freeze),
      B_ID_R,
      PC_IF_S,
      instruction_IF_S,
      PC_IF_R,
      instruction_IF_R
  );


  ID_Stage ID_S (
      clk,
      rst,
      instruction_IF_R,
      WB_value,
      WB_WB_EN,
      Dest_MEM_R,
      hazard,
      SR_out,
      Control_Signals_Out_ID_S,
      Val_Rn_ID_S,
      Val_Rm_ID_S,
      imm_ID_S,
      Shift_Operand_ID_S,
      Signed_imm_24_ID_S,
      Dest_ID_S,
      src1_ID_S,
      src2_ID_S,
      Two_src
  );


  ID_Stage_Reg ID_R (
      clk,
      rst,
      B_ID_R,
      Control_Signals_Out_ID_S[8],
      Control_Signals_Out_ID_S[7],
      Control_Signals_Out_ID_S[6],
      Control_Signals_Out_ID_S[1],
      Control_Signals_Out_ID_S[0],
      Control_Signals_Out_ID_S[5:2],
      PC_IF_R,
      Val_Rn_ID_S,
      Val_Rm_ID_S,
      imm_ID_S,
      Shift_Operand_ID_S,
      Signed_imm_24_ID_S,
      Dest_ID_S,
      SR_out,
      WB_EN_ID_R,
      MEM_R_EN_ID_R,
      MEM_W_EN_ID_R,
      B_ID_R,
      S_ID_R,
      EXE_CMD_ID_R,
      PC_ID_R,
      Val_Rn_ID_R,
      Val_Rm_ID_R,
      imm_ID_R,
      Shift_Operand_ID_R,
      Signed_imm_24_ID_R,
      Dest_ID_R,
      SR_ID_R,
      src1_ID_S,
      src2_ID_S,
      src1_ID_R,
      src2_ID_R,
      SRAM_Freeze
  );



  EXE_Stage EXE_S (
      clk,
      EXE_CMD_ID_R,
      MEM_R_EN_ID_R,
      MEM_W_EN_ID_R,
      PC_ID_R,
      Val_Rn_ID_R,
      Val_Rm_ID_R,
      imm_ID_R,
      Shift_Operand_ID_R,
      Signed_imm_24_ID_R,
      SR_ID_R,
      ALU_result_EXE_S,
      Br_addr_EXE_S,
      status_EXE_S,
      ALU_result_EXE_R,
      sel_src1,
      sel_src2,
      Val_Rm_EXE_S,
      WB_value
  );


  EXE_Stage_Reg EXE_R (
      clk,
      rst,
      WB_EN_ID_R,
      MEM_R_EN_ID_R,
      MEM_W_EN_ID_R,
      ALU_result_EXE_S,
      Val_Rm_EXE_S,
      Dest_ID_R,
      WB_en_EXE_R,
      MEM_R_EN_EXE_R,
      MEM_W_EN_EXE_R,
      ALU_result_EXE_R,
      Val_Rm_EXE_R,
      Dest_EXE_R,
      SRAM_Freeze
  );

  //   Memory MEM_S (
  //       clk,
  //       MEM_R_EN_EXE_R,
  //       MEM_W_EN_EXE_R,
  //       ALU_result_EXE_R,
  //       Val_Rm_EXE_R,
  //       MEM_result
  //   );

  MEM_Stage_Reg MEM_R (
      clk,
      rst,
      WB_en_EXE_R,
      MEM_R_EN_EXE_R,
      ALU_result_EXE_R,
      MEM_result,
      Dest_EXE_R,
      WB_WB_EN,
      MEM_R_EN_MEM_R,
      ALU_result_MEM_R,
      MEM_result_MEM_R,
      Dest_MEM_R,
      SRAM_Freeze
  );

  WB_STAGE WB_S (
      ALU_result_MEM_R,
      MEM_result_MEM_R,
      MEM_R_EN_MEM_R,
      WB_value
  );


  hazard_Detection_Unit HDU (
      .src1(src1_ID_S),
      .src2(src2_ID_S),
      .Exe_Dest(Dest_ID_R),
      .Exe_WB_EN(WB_EN_ID_R),
      .Mem_Dest(Dest_EXE_R),
      .Mem_WB_EN(WB_en_EXE_R),
      .Two_src(Two_src),
      .hazard_Detected(hazard),
      .fw_en(fw_en),
      .EXE_MEM_R_EN(MEM_R_EN_ID_R)
  );
  status_register SR_REG (
      .clk(clk),
      .rst(rst),
      .s  (S_ID_R),
      .in (status_EXE_S),
      .out(SR_out)
  );
  assign freeze = hazard;
  assign BranchAddr = Br_addr_EXE_S;
  Forwarding_Unit FW_UNIT (
      fw_en,
      src1_ID_R,
      src2_ID_R,
      WB_en_EXE_R,
      WB_WB_EN,
      Dest_EXE_R,
      Dest_MEM_R,
      sel_src1,
      sel_src2
  );
  Sram_Controller SR_CU (
      clk,
      rst,
      MEM_W_EN_EXE_R,
      MEM_R_EN_EXE_R,
      ALU_result_EXE_R,
      Val_Rm_EXE_R,
      MEM_result,
      SRAM_READY,
      SRAM_DQ,
      SRAM_ADDR,
      SRAM_UB_N,
      SRAM_LB_N,
      SRAM_WE_N,
      SRAM_CE_N,
      SRAM_OE_N
  );
  assign SRAM_Freeze = ~SRAM_READY;

endmodule

// module hazard_Detection_Unit(
//     input [3:0] src1, src2, Exe_Dest,
//     input Exe_WB_EN,
//     input [3:0] Mem_Dest,
//     input Mem_WB_EN,
//     input Two_src,
//     output reg hazard_Detected
// );
// always@(src1, src2, Exe_Dest, Exe_WB_EN, Mem_Dest) begin
// hazard_Detected = 1'b0;
// if(Exe_WB_EN) if (src1 == Exe_Dest) hazard_Detected = 1'b1;
// if(Mem_WB_EN) if (src1 == Mem_Dest) hazard_Detected = 1'b1;
// if(Exe_WB_EN && Two_src) if (src2 == Exe_Dest) hazard_Detected = 1'b1;
// if(Mem_WB_EN && Two_src) if (src2 == Mem_Dest) hazard_Detected = 1'b1;
// end

// endmodule
module hazard_Detection_Unit (
    src1,
    src2,
    Exe_Dest,
    Exe_WB_EN,
    Mem_Dest,
    Mem_WB_EN,
    Two_src,
    hazard_Detected,
    fw_en,
    EXE_MEM_R_EN
);

  input Two_src, Exe_WB_EN, Mem_WB_EN;
  input [3:0] src1, src2, Exe_Dest, Mem_Dest;
  output hazard_Detected;
  input fw_en;
  input EXE_MEM_R_EN;
  wire hazard_wof;
  wire hazard_f;


  assign hazard_wof = ((src1 == Exe_Dest) && (Exe_WB_EN == 1'b1)) ||
      ((src1 == Mem_Dest) && (Mem_WB_EN == 1'b1)) ||
      ((src2 == Exe_Dest) && (Exe_WB_EN == 1'b1) && (Two_src == 1'b1)) ||
      ((src2 == Mem_Dest) && (Mem_WB_EN == 1'b1) && (Two_src == 1'b1));

  assign hazard_f = ((EXE_MEM_R_EN) && ((src1 == Exe_Dest) || (src2 == Exe_Dest)));
  assign hazard_Detected = (fw_en) ? hazard_f : hazard_wof;

endmodule

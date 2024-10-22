module Forwarding_Unit (
    input forwarding_en,
    input [3:0] src1,
    input [3:0] src2,
    input WB_EN_Mem,
    WB_EN_WB,
    input [3:0] Dest_Mem,
    Dest_WB,
    output reg [1:0] sel_src1,
    output reg [1:0] sel_src2
);
  always @(src1, src2, WB_EN_Mem, WB_EN_WB, Dest_Mem, Dest_WB, forwarding_en) begin
    if (src1 == Dest_Mem && WB_EN_Mem == 1'b1 && forwarding_en == 1'b1) sel_src1 = 2'b01;
    else if (src1 == Dest_WB && WB_EN_WB == 1'b1 && forwarding_en == 1'b1) sel_src1 = 2'b10;
    else sel_src1 = 2'b00;

    if (src2 == Dest_Mem && WB_EN_Mem == 1'b1 && forwarding_en == 1'b1) sel_src2 = 2'b01;
    else if (src2 == Dest_WB && WB_EN_WB == 1'b1 && forwarding_en == 1'b1) sel_src2 = 2'b10;
    else sel_src2 = 2'b00;

  end
endmodule

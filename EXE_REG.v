module EXE_Stage_Reg (
    input clk,
    rst,
    WB_en_in,
    MEM_R_EN_in,
    MEM_W_EN_in,
    input [31:0] ALU_result_in,
    ST_val_in,
    input [3:0] Dest_in,
    output reg WB_en,
    MEM_R_EN,
    MEM_W_EN,
    output reg [31:0] ALU_result,
    ST_val,
    output reg [3:0] Dest,
    input freeze
);

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      WB_en = 1'd0;
      MEM_R_EN = 1'd0;
      MEM_W_EN = 1'd0;
      ALU_result = 32'd0;
      ST_val = 32'd0;
      Dest = 4'd0;
    end
    else if (~freeze) begin
      WB_en = WB_en_in;
      MEM_R_EN = MEM_R_EN_in;
      MEM_W_EN = MEM_W_EN_in;
      ALU_result = ALU_result_in;
      ST_val = ST_val_in;
      Dest = Dest_in;
    end
  end

endmodule


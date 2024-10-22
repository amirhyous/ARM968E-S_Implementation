module Sram_Controller (
    input clk,
    input rst,

    input wr_en,
    input rd_en,
    input [31:0] address,
    input [31:0] writeData,

    output reg [31:0] readData,

    output ready,

    inout [15:0] SRAM_DQ,
    output reg [17:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output reg SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OE_N
);
  reg [3:0] ns, ps;
  assign SRAM_UB_N = 1'b0;
  assign SRAM_LB_N = 1'b0;
  assign SRAM_CE_N = 1'b0;
  assign SRAM_OE_N = 1'b0;
  localparam [3:0] idle = 0, W1 = 1, W2 = 2, W3 = 3, W4 = 4, W5 = 5,
                  R1 = 6, R2 = 7, R3 = 8, R4 = 9, R5 = 10,R6=11;
  always @(ps, wr_en, rd_en) begin
    ns = idle;
    case (ps)
      idle: begin
        if (wr_en == 1'b1) ns = W1;
        else if (rd_en == 1'b1) ns = R1;
        else ns = idle;
      end

      W1: ns = W2;
      W2: ns = W3;
      W3: ns = W4;
      W4: ns = W5;
      W5: ns = idle;

      R1: ns = R2;
      R2: ns = R3;
      R3: ns = R4;
      R4: ns = R5;
      R5: ns = R6;
      R6: ns = idle;

    endcase

  end

  always @(ps) begin
    SRAM_WE_N = 1'b1;

    case (ps)

      W1: begin
        SRAM_ADDR = {address[18:2], 1'b0};
        SRAM_WE_N = 1'b0;
      end
      W2: begin
        SRAM_ADDR = {address[18:2], 1'b1};
        SRAM_WE_N = 1'b0;
      end
      W3: begin
        SRAM_WE_N = 1'b1;
      end
      R1: begin
        SRAM_ADDR = {address[18:2], 1'b0};
      end
      R2: begin
        SRAM_ADDR = {address[18:2], 1'b0};
        readData[15:0] = SRAM_DQ;
      end
      R3: begin
        SRAM_ADDR = {address[18:2], 1'b1};
      end
      R5: begin
        SRAM_ADDR = {address[18:2], 1'b1};
        readData[31:16] = SRAM_DQ;
      end
      default: begin
        SRAM_WE_N = 1'b1;
      end
    endcase
  end

  always @(posedge clk, posedge rst) begin
    if (rst) ps <= idle;
    else ps <= ns;
  end
  assign SRAM_DQ = (ps == W1) ? writeData[15:0] : (ps == W2) ? writeData[31:16] : 16'bz;
  assign ready   = (ns == idle) ? 1'b1 : 1'b0;
  //assign ready = (((ps == idle) && (~wr_en) && (~rd_en)) || (ps == R5) || (ps == W5)) ? 1'b1 : 1'b0;
endmodule

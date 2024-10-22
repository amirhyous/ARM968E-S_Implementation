`timescale 1ns/1ns
module imm_creator_TB();
  reg [3:0] rotate_imm;
  reg [7:0] imm_in;
  wire [31:0] imm_out;
  imm_creator UUT(rotate_imm,imm_in,imm_out);
  initial begin
    #10 rotate_imm = 4'd2;
    imm_in = 8'd255;
    #20 rotate_imm = 4'd5;
    imm_in = 8'd37;
    #20;
  end
endmodule

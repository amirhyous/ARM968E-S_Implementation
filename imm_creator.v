module imm_creator (input [3:0] rotate_imm, input [7:0] imm_input, output reg [31:0] out);
  integer i;
  integer k=0;
  wire[3:0] new_rotate;
  assign new_rotate = rotate_imm<<1;
  always @(rotate_imm,imm_input) begin
    out = 32'd0;
    for (i=0; i<8; i=i+1) begin
      k = i-new_rotate;
      if (k<0)
        k=k+31;
      out[k] = imm_input[i];
    end
  end
endmodule
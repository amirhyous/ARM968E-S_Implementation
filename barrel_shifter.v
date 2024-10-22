module barrel_shifter (input [31:0] in, input [4:0] shift, output reg [31:0] out);
  integer i;
  integer k=0;
  always @(in,shift) begin
    out = 32'd0;
    for (i=0; i<32; i=i+1) begin
      k = i-shift;
      if (k<0)
        k=k+32;
      out[k] = in[i];
    end
  end
endmodule


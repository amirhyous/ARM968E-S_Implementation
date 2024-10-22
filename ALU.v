module ALU (
    input [31:0] Val1,
    Val2,
    input [3:0] EXE_CMD,
    input [3:0] status_bits,
    output reg [31:0] out,
    output [3:0] status_bits_out
);
  parameter[3:0] MOV = 4'b0001, MVN = 4'b1001, ADD = 4'b0010, ADC = 4'b0011, SUB = 4'b0100, SBC = 4'b0101, AND = 4'b0110
		, ORR = 4'b0111, EOR = 4'b1000, CMP = 4'b0100, TST = 4'b0110, LDR = 4'b0010, STR = 4'b0010;
  wire n, z, c, v;
  assign n = status_bits[3];
  assign z = status_bits[2];
  assign c = status_bits[1];
  assign v = status_bits[0];
  wire n_out, z_out, v_out;
  reg c_out;
  always @(EXE_CMD, Val1, Val2, status_bits) begin
    c_out = c;
    case (EXE_CMD)
      MOV: out = Val2;
      MVN: out = ~Val2;
      ADD: begin
        {c_out, out} = Val1 + Val2;
      end
      ADC: begin
        {c_out, out} = Val1 + Val2 + c;
      end
      SUB: begin
        {c_out, out} = Val1 - Val2;
      end
      SBC: begin
        {c_out, out} = Val1 - Val2 - !c;
      end
      AND: out = Val1 & Val2;
      ORR: out = Val1 | Val2;
      EOR: out = Val1 ^ Val2;
      CMP: begin
        {c_out, out} = Val1 - Val2;
      end
      TST: out = Val1 & Val2;
      LDR: begin
        {c_out, out} = Val1 + Val2;
      end
      STR: begin
        {c_out, out} = Val1 + Val2;
      end
      default: out = 32'd0;
    endcase
  end
  assign n_out = out[31];
  assign z_out = ~(|out);

  assign v_out = ((EXE_CMD == 4'b0010) | (EXE_CMD == 4'b0011))? 
   (out[31] & ~Val1[31] & ~Val2[31]) | (~out[31] & Val1[31] & Val2[31])
    :((EXE_CMD == 4'b0100) | (EXE_CMD == 4'b0101))? 
   (out[31] & ~Val1[31] & Val2[31]) | (~out[31] & Val1[31] & ~Val2[31])
    : 1'b0;
  // assign z_out = (out == 32'd0) ? 1'b1 : 1'b0;
  // assign n_out = (out[31] == 1'b1) ? 1'b1 : 1'b0;

  assign status_bits_out = {n_out, z_out, c_out, v_out};

endmodule

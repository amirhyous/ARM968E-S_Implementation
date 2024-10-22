module Val2_Generate(input [31:0] Val_Rm,input MEM_OP,imm,input [11:0] shift_operand, output [31:0] out );
wire [31:0] imm_out;
wire [31:0] imm_shift,imm_rotate;
wire [40:0] imm_long;
assign imm_long = {shift_operand[7:0],24'd0,shift_operand[7:0]}>>{shift_operand[11:8],1'b0};
assign imm_out = imm_long[31:0];
//imm_creator imm_gen (shift_operand[11:8],shift_operand[7:0],imm_out);
barrel_shifter rotate_right (Val_Rm,shift_operand[11:7],imm_rotate);
assign out = MEM_OP?{20'd0,shift_operand}:
             imm?imm_out:
             ((imm==1'b0)&&(~shift_operand[4]))?imm_shift:Val_Rm;
assign imm_shift = (shift_operand[6:5]==2'b00)?Val_Rm<<shift_operand[11:7]:
                   (shift_operand[6:5]==2'b01)?Val_Rm>>shift_operand[11:7]:
                   (shift_operand[6:5]==2'b10)?Val_Rm>>>shift_operand[11:7]:
                   (shift_operand[6:5]==2'b11)?imm_rotate:32'd0;
endmodule


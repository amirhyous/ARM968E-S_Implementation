module IF_Stage_Reg(input clk, rst, freeze, flush,
input[31:0] PC_in, Instruction_in,
output reg [31:0] PC, Instruction);

always @(posedge clk) begin
    if (rst) begin PC = 32'd0; Instruction = 32'b0; end
    else if (~freeze && ~flush) begin PC = PC_in; Instruction = Instruction_in; end
    else if (flush) begin PC = 32'd0; Instruction = 32'b0; end
end

endmodule

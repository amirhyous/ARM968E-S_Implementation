module IF_Stage(input clk, rst, freeze, Branch_taken, input [31:0] BranchAddr, output [31:0] PC, instruction);
    wire [31:0] PC_in, PC_in_reg;
    Mux2to1 PC_Mux(.a(PC), .b(BranchAddr), .sel(Branch_taken), .out(PC_in));
    Reg32 PC_Reg (.clk(clk), .rst(rst), .load(~freeze), .data_in(PC_in), .data_out(PC_in_reg));
    Adder PC_Adder(.a(32'd4), .b(PC_in_reg), .out(PC));
    Instruction_Memory Inst_Mem(.address(PC_in_reg), .out(instruction));
endmodule

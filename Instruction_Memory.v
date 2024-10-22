module Instruction_Memory (
    address,
    out
);
  input [31:0] address;
  output[31:0] out;
  reg [7:0] mem[187:0];
  initial begin
	$readmemb("Inst.txt",mem);
	end
  assign out = {mem[address], mem[address+1], mem[address+2], mem[address+3]};
endmodule

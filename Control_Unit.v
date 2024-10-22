// module Control_Unit (
//     mode,
//     opcode,
//     S,
//     i,
//     execute_command,
//     mem_read,
//     mem_write,
//     WB_enable,
//     B,
//     S_out
// );
//   input i;
//   input [1:0] mode;
//   input [3:0] opcode;
//   input S;
//   output reg [3:0] execute_command;
//   output reg mem_read;
//   output reg mem_write;
//   output reg WB_enable;
//   output B;
//   output S_out;
//   parameter [3:0] NOP = 0,MOVE = 13,MOVE_NOT=15,ADD_OR_MEM=4,ADC=5,SUB=2,SBC=6,AND=0,ORR=12,EOR=1,CMP=10,TST=8;
//   parameter [3:0] EX_MOV=1,EX_MVN=9,EX_ADD=2,EX_ADC=3,EX_SUB=4,EX_SBC=5,EX_AND=6,EX_ORR=7,EX_EOR=8,EX_CMP=4,EX_TST=6,EX_LDR=2,EX_STR=2;
//   always @(opcode, mode, S) begin
//     execute_command = 4'd0;
//     mem_read = 1'b0;
//     mem_write = 1'b0;
//     WB_enable = 1'b0;
//     case (opcode)
//       NOP: begin
//         execute_command = EX_AND;
//         WB_enable = 1'b1;
//       end
//       MOVE: begin
//         execute_command = EX_MOV;
//         WB_enable = 1'b1;
//       end
//       MOVE_NOT: begin
//         execute_command = EX_MVN;
//         WB_enable = 1'b1;
//       end
//       ADD_OR_MEM: begin
//         if (mode == 2'b00) begin
//           execute_command = EX_ADD;
//           WB_enable = 1'b1;
//         end else if (mode == 2'b01) begin
//           if (S == 1'b1) begin
//             execute_command = EX_LDR;
//             mem_read = 1'b1;
//             WB_enable = 1'b1;
//           end else begin
//             execute_command = EX_STR;
//             mem_write = 1'b1;
//           end
//         end
//       end
//       ADC: begin
//         execute_command = EX_ADC;
//         WB_enable = 1'b1;
//       end
//       SUB: begin
//         execute_command = EX_SUB;
//         WB_enable = 1'b1;
//       end
//       SBC: begin
//         execute_command = EX_SBC;
//         WB_enable = 1'b1;
//       end
//       AND: begin
//         execute_command = EX_AND;
//         WB_enable = 1'b1;
//       end
//       ORR: begin
//         execute_command = EX_ORR;
//         WB_enable = 1'b1;
//       end
//       EOR: begin
//         execute_command = EX_EOR;
//         WB_enable = 1'b1;
//       end
//       CMP: begin
//         execute_command = EX_CMP;
//         WB_enable = 1'b0;
//       end
//       TST: execute_command = EX_TST;
//       default: execute_command = 4'bXXXX;
//     endcase
//   end
//   assign S_out = S;
//   assign B = ((mode == 2'b10) && i) ? 1'b1 : 1'b0;
// endmodule

module Control_Unit (
    input [1:0] mode,
    input [3:0] Op_code,
    input s,
    output reg [3:0] ExecuteCommand,
    output reg mem_read,
    mem_write,
    WB_Enable,
    output reg B,
    status
);

  always @(s, Op_code, mode) begin  // check
    {WB_Enable, mem_read, mem_write, ExecuteCommand, B, status} = {8'b0, s};
    case (mode)
      2'b00: begin
        case (Op_code)
          4'b1101: {WB_Enable, ExecuteCommand} = 5'b10001;
          4'b1111: {WB_Enable, ExecuteCommand} = 5'b11001;
          4'b0100: {WB_Enable, ExecuteCommand} = 5'b10010;
          4'b0101: {WB_Enable, ExecuteCommand} = 5'b10011;
          4'b0010: {WB_Enable, ExecuteCommand} = 5'b10100;
          4'b0110: {WB_Enable, ExecuteCommand} = 5'b10101;
          4'b0000: {WB_Enable, ExecuteCommand} = 5'b10110;
          4'b1100: {WB_Enable, ExecuteCommand} = 5'b10111;
          4'b0001: {WB_Enable, ExecuteCommand} = 5'b11000;
          4'b1010: {ExecuteCommand} = 4'b0100;
          4'b1000: {ExecuteCommand} = 4'b0110;
        endcase
      end
      2'b01: begin
        ExecuteCommand = 4'b0010;
        case (s)
          1'b1: {WB_Enable, mem_read, status} = {3'b110};
          1'b0: {mem_write, status} = {2'b10};
        endcase
      end
      2'b10: begin
        {B, status} = 2'b10;
      end
    endcase
  end

endmodule

module status_register(input clk, rst, s, input [3:0] in, output reg[3:0] out);

    always@(negedge clk,posedge rst) begin
        if(rst)
            out = 4'd0;
        else begin
            if(s)   out = in;
        end
    
    end

endmodule

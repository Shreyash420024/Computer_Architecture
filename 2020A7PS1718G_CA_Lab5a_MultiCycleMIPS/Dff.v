
module Dff_register(input clk, input reset, input regWrite, input d, output reg q);
    always@(posedge clk) 
    begin
        if(reset == 1'b1)
        begin
            q <= 0;
        end
        else if(regWrite == 1'b1)
        begin
            q <= d;
        end
    end
endmodule


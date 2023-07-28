


//The Dff_Reg will be used for making the pipeline registers

module Dff_Reg(input clk, input reset, input regWrite, input d, output reg q);
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    always @(posedge clk) begin
        if (reset == 1'b0) begin
            if (regWrite == 1'b1)
                q <= d;
        end
    end

    always @(reset) begin
        if (reset == 1'b1)
            q <= 0;
    end

endmodule

	 

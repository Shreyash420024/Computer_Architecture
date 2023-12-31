

// Intermediate or pipelined Registers start
//The Dff_Reg will be used for making the pipeline registers

module Dff_Reg(input clk, input reset, input regWrite, input d, output reg q);
    
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    /*always @(posedge clk)
        if (reset == 1'b0)
            if (regWrite == 1'b1)
                q <= d;

    always @(reset)
        if (reset == 1'b1)
            q <= 0;*/
            
    always @ (posedge clk)
    begin   
        if (reset)
            q<=0;
        else if (regWrite == 1'b1)
            q<=d;
    end
endmodule

	 

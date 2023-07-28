
//The Dff_Reg will be used for making the pipeline registers

module register5bit(input clk, input reset, input regWrite, input [4:0] inR, output [4:0] outR);
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) 
            Dff_Reg d(clk,reset,regWrite,inR[i],outR[i]);
    endgenerate

endmodule
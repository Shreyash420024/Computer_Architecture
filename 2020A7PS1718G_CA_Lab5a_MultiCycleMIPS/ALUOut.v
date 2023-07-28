


module ALUOut_Reg(input clk, input reset, input regWrite, input [31:0] inR, output [31:0] outR);
    genvar i;
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
     generate
        for ( i=0; i < 32; i=i+1 )
            Dff_register ALU(clk, reset, regWrite, inR[i],  outR[i]);
    endgenerate
endmodule
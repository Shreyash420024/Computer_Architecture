
`include "topModule.v"
module testbench();
    reg clk;
    reg reset;
    wire [31:0] result;
    MIPS_multiCycle MC(clk, reset, result);

    always
    #5 clk=~clk;
    
    initial
    begin
        $dumpfile("2020A7PS1718G_multicycle.vcd");//WRITE YOUR CAMPUS ID HERE
        $dumpvars(0,MC);

        clk=1; reset=1;;
        #10  reset=0;

       
        #1400 $finish;
    end
endmodule
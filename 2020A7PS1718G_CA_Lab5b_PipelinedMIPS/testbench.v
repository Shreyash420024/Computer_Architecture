`include "topModule.v"

module testbench();
	reg clk;
	reg reset;
	
	pipelinedDatapath pipeDataPath(clk, reset);

	always
	#5 clk=~clk;
	
	initial
	begin

        $dumpfile("2020A7PS1718G_PipelinedMIPS.vcd"); //Write your campus id here.
        $dumpvars(0,testbench);
		clk=0; reset=1;
		#10  reset=0;	

		#860 $finish;
	end
endmodule

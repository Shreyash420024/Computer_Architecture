

`include "topModule.v"

module pipeline_hdu_testbench();
	reg clk;
	reg reset;
	
	pipelinedDatapath pipeDataPathHDU(clk, reset);

	always
	#5 clk=~clk;
	
	initial
	begin

        $dumpfile("2020A7PS1718G_PipelinedMIPS_HDU.vcd"); //Write your campus id here.
        $dumpvars(0, pipeline_hdu_testbench);
		//clk=0; reset=1;
		clk=1; reset=1;
		#10  reset=0;	

		#600 $finish;
	end
endmodule

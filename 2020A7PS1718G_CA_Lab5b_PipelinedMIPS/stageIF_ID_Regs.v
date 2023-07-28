



module IF_ID(input clk, input reset, input regWr, input [31:0] ir, input [31:0] pc, output [31:0] ir_IF_ID, output [31:0] pc_IF_ID);
	//WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
	register32bit z0(clk,reset,regWr,ir,ir_IF_ID);
	register32bit y0(clk,reset,regWr,pc,pc_IF_ID);

endmodule

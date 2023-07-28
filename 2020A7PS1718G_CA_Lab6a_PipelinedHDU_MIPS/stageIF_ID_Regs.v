


module IF_ID(input clk, input reset, input regWr, input [31:0] ir, input [31:0] pc, input prediction, output [31:0] ir_IF_ID, output [31:0] pc_IF_ID, output prediction_IF_ID);
	
	register32bit ir0 (clk, reset, regWr, ir, ir_IF_ID);
    register32bit pc0 (clk, reset, regWr, pc, pc_IF_ID);
    register1bit prediction0 (clk, reset, regWr, prediction, prediction_IF_ID);

endmodule


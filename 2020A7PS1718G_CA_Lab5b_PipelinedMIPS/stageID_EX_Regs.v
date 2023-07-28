


module ID_EX(input clk, input reset, input regWr, input [31:0] regRs, input [31:0] regRt, 
				 input regDest, input aluSrcB, input [1:0] aluOp, input memRead, input memWrite, input memToReg, 
				 input regWrite, input branch, input [31:0] sext16to32, input [4:0] rt, input [4:0] rd, input [31:0]pc, 
                 output [31:0] regRs_ID_EX, 
				 output [31:0] regRt_ID_EX, output regDest_ID_EX, output aluSrcB_ID_EX, output [1:0] aluOp_ID_EX, 
				 output memRead_ID_EX, output memWrite_ID_EX, output memToReg_ID_EX, output regWrite_ID_EX, output branch_ID_EX,
				 output [31:0] signext16to32_ID_EX, output [4:0] rt_ID_EX, output [4:0] rd_ID_EX, output [31:0] pc_ID_EX);
	
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    register1bit d0(clk,reset,regWr,regDest,regDest_ID_EX);
	register1bit d1(clk,reset,regWr,aluSrcB,aluSrcB_ID_EX);
	register1bit d2(clk,reset,regWr,memRead,memRead_ID_EX);
	register1bit d3(clk,reset,regWr,memWrite,memWrite_ID_EX);
	register1bit d4(clk,reset,regWr,memToReg,memToReg_ID_EX);
	register1bit d5(clk,reset,regWr,regWrite,regWrite_ID_EX);
	register1bit d6(clk,reset,regWr,branch,branch_ID_EX);
	register2bit d7(clk,reset,regWr,aluOp,aluOp_ID_EX);
	register5bit a0(clk,reset,regWr,rt,rt_ID_EX);
	register5bit b0(clk,reset,regWr,rd,rd_ID_EX);
	register32bit c0(clk,reset,regWr,regRs,regRs_ID_EX);
	register32bit w0(clk,reset,regWr,regRt,regRt_ID_EX);
	register32bit v0(clk,reset,regWr,sext16to32,signext16to32_ID_EX);
	register32bit u0(clk,reset,regWr,pc,pc_ID_EX);

endmodule

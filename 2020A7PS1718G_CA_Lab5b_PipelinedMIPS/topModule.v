
`include "Dff.v"
`include "1bitReg.v"
`include "2bitsReg.v"
`include "5bitsReg.v"
`include "32bitsReg.v"
`include "pc.v"
`include "regFile.v"
`include "signExtn.v"
`include "adder.v"
`include "ALU.v"
`include "memInstr.v"
`include "memData.v"
`include "mux2_1_32bits.v"
`include "muxRegAddr.v"
`include "stageIF_ID_Regs.v"
`include "stageID_EX_Regs.v"
`include "stageEX_MEM_Regs.v"
`include "stageMEM_WB_Regs.v"
`include "controller.v"


module pipelinedDatapath(input clk, input reset);
//Write your code here

	wire [31:0] pcIn;
    wire [31:0] pc;
	wire [31:0] pcOut;
    wire [31:0] pc_IF_ID;
	wire [31:0] ir;
	wire [31:0] ir_IF_ID;
	wire [31:0] regRs;
	wire [31:0] regRt;
	wire [31:0] signExtOut;
	wire [31:0] signExtOut_ID_EX;
	wire [31:0] regRs_ID_EX;
	wire [31:0] regRt_ID_EX;
    wire [31:0] pc_ID_EX;
    wire [31:0] aluIn2;
	wire [31:0] aluOut;
	wire [31:0] memData_EX_MEM; //goes into writeData of DM
	wire [31:0] aluOut_EX_MEM;
    wire [31:0] branchAddress_EX_MEM;
    wire [31:0] branchAddress;
	wire [31:0] memOut; //Output of DM
	wire [31:0] result;
	wire [31:0] memData_MEM_WB;
	wire [31:0] aluOut_MEM_WB;
	wire [4:0] destReg_MEM_WB;
	wire [4:0] rt_ID_EX;
	wire [4:0] rd_ID_EX;
	wire [4:0] rt_rd_ex_mem_in;
	wire [4:0] destReg_EX_MEM;
	wire regWrite_MEM_WB;
	wire regDest;
	wire aluSrcB;
	wire [1:0] aluOp;
    wire [3:0] aluCtrl;
    
	wire memRead;
	wire memWrite;
	wire memToReg;
	wire regWrite;
    wire branch;
    wire zero;
    wire zero_EX_MEM;
	wire regDest_ID_EX;
	wire aluSrcB_ID_EX;
	wire [1:0] aluOp_ID_EX;
    wire branch_ID_EX;
	wire memRead_ID_EX;
	wire memWrite_ID_EX;
	wire memToReg_ID_EX;
	wire regWrite_ID_EX;
	wire regWrite_EX_MEM;
	wire memToReg_EX_MEM;
	wire memWrite_EX_MEM;
	wire memRead_EX_MEM;
    wire branch_EX_MEM;
	wire memToReg_MEM_WB;

	//WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
	pc PC(clk, reset, 1'b1, pcIn, pcOut);
	registerFile regf(clk, reset, regWrite_MEM_WB, ir_IF_ID[25:21], ir_IF_ID[20:16], destReg_MEM_WB, result, regRs, regRt);
	signExt16to32 sign(ir_IF_ID[15:0], signExtOut);
	controlCircuit c(ir_IF_ID[31:26], aluOp, aluSrcB, branch, memWrite, memRead, memToReg, regDest, regWrite);
	mux2to1_32bits mux0(pc, branchAddress_EX_MEM, (branch_EX_MEM & ~zero_EX_MEM), pcIn);
	mux2to1_32bits mux1(regRt_ID_EX, signExtOut_ID_EX, aluSrcB_ID_EX, aluIn2);
	mux2to1_5bits mux2(rt_ID_EX, rd_ID_EX, regDest_ID_EX, rt_rd_ex_mem_in);
	mux2to1_32bits mux3(aluOut_MEM_WB, memData_MEM_WB, memToReg_MEM_WB, result);
	adder a1(32'd4, pcOut, pc);
	adder a2(pc_ID_EX, signExtOut_ID_EX<<2, branchAddress);
	EX_MEM exmem(clk, reset, 1'b1, memRead_ID_EX, memWrite_ID_EX, memToReg_ID_EX, regWrite_ID_EX, branch_ID_EX, rt_rd_ex_mem_in, regRt_ID_EX, aluOut, branchAddress, zero, memRead_EX_MEM, memWrite_EX_MEM, memToReg_EX_MEM, regWrite_EX_MEM, branch_EX_MEM, destReg_EX_MEM, memData_EX_MEM, aluOut_EX_MEM, branchAddress_EX_MEM, zero_EX_MEM);
	DM dmem(clk, reset, memRead_EX_MEM, memWrite_EX_MEM, aluOut_EX_MEM[6:2], memData_EX_MEM, memOut);
	ID_EX idex(clk, reset, 1'b1, regRs, regRt, regDest, aluSrcB, aluOp, memRead, memWrite, memToReg, regWrite, branch, signExtOut, ir_IF_ID[20:16], ir_IF_ID[15:11], pc_IF_ID, regRs_ID_EX, regRt_ID_EX, regDest_ID_EX, aluSrcB_ID_EX, aluOp_ID_EX,memRead_ID_EX, memWrite_ID_EX, memToReg_ID_EX, regWrite_ID_EX, branch_ID_EX, signExtOut_ID_EX, rt_ID_EX, rd_ID_EX, pc_ID_EX);
	alu ALU(regRs_ID_EX, aluIn2, aluCtrl, aluOut, zero);
	aluCtrl aluc(aluOp_ID_EX, signExtOut_ID_EX[5:0], aluCtrl);
	MEM_WB memwb(clk, reset, 1'b1, memToReg_EX_MEM, regWrite_EX_MEM, destReg_EX_MEM, memOut, aluOut_EX_MEM, memToReg_MEM_WB, regWrite_MEM_WB, destReg_MEM_WB, memData_MEM_WB, aluOut_MEM_WB);
    IM im(clk, reset, pcOut[6:2], 1'b1, ir);
	IF_ID ifid(clk, reset, 1'b1, ir, pc, ir_IF_ID, pc_IF_ID);
	
endmodule
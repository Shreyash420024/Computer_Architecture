

`include "Dff.v"
`include "PC.v"
`include "memory.v"
`include "IR.v"
`include "MDR.v"
`include "regFile.v"
`include "A.v"
`include "B.v"
`include "ALUOut.v"
`include "mux2_1_Data.v"
`include "mux4_1_Data.v"
`include "muxRegAddr.v"
`include "signExtn.v"
`include "ALU.v"
`include "controller.v"

module MIPS_multiCycle(input clk, input reset, output [31:0] result);
	wire aluSrcA;
    wire [1:0] aluSrcB;

	wire zero;
	wire memRead;
    wire memWr;
	wire irWr;
    wire iorD;
	wire regWr;
    
    wire memToReg;
	wire [1:0] regData;
	wire regDest;
    wire pcWr;
    wire bne;
	wire pcSrc;
	
	wire [4:0] rd;
    wire [4:0] memAddr;
    wire [31:0] irOut;
    wire [31:0] memOut;
    wire [31:0] mdrOut;
	wire [31:0] writeData;
	wire [31:0] regRs; //input to A
	wire [31:0] regRt; //input to B
	wire [31:0] Aout;
	wire [31:0] Bout;
	wire [31:0] signExtOut;
	wire [31:0] pcIn;
	wire [31:0] pcOut;
	wire [31:0] aluIn1;
	wire [31:0] aluIn2;
	wire [31:0] aluOut;
    
    wire [1:0] aluOp;
    wire [5:0] funct;
    wire [3:0] ALUContrl; 
    
	//WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
	mux2to1_5bits mux1(pcOut[6:2],result[6:2],iorD,memAddr);
    mux2to1_5bits mux2(irOut[20:16],irOut[15:11],regDest,rd);
	mux2to1_32bits mux3(result,mdrOut,memToReg,writeData);
	mux2to1_32bits mux4(pcOut,Aout,aluSrcA,aluIn1);
	mux4to1_32bits mux5(Bout,32'd4,signExtOut,signExtOut<<2,aluSrcB,aluIn2);
	mux2to1_32bits mux6(aluOut,result,pcSrc,pcIn);
    PC_Reg pc(clk,reset,(pcWr|(bne&(~zero))),pcIn,pcOut);
	Memory mem(clk,reset,memAddr,memRead,memWr,Bout,memOut);
	IR_Reg IR(clk,reset,irWr,memOut,irOut);
	MDR_Reg MDR(clk,reset,1'b1,memOut,mdrOut);
	registerFile regf(clk,reset,regWr,irOut[25:21], irOut[20:16],rd,writeData,regRs,regRt);
	A_Reg A(clk,reset,1'b1,regRs,Aout);
	B_Reg B(clk,reset,1'b1,regRt,Bout);
	aluCtrl aluC(aluOp,irOut[5:0], ALUContrl);
    alu ALU(aluIn1,aluIn2,ALUContrl,aluOut,zero);
	signExt16to32 sign(irOut[15:0],signExtOut);
	controlCircuit c(clk,reset,irOut[31:26],irOut[5:0],pcWr,pcSrc,bne,irWr,memRead,regWr,regDest,memToReg,aluSrcA,aluSrcB,aluOp,zero,memWr,iorD);
	ALUOut_Reg alur(clk,reset,1'b1,aluOut,result);
	
endmodule


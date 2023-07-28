
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
`include "mux4_1_32bits.v"
`include "muxRegAddr.v"
`include "stageIF_ID_Regs.v"
`include "stageID_EX_Regs.v"
`include "stageEX_MEM_Regs.v"
`include "stageMEM_WB_Regs.v"
`include "controller.v"
`include "BTB.v"
`include "HDU.v"
`include "DataFwdUnit.v"
`include "comparator.v"


module pipelinedDatapath(input clk, input reset);
//Write your code here

	wire [31:0] pcIn;
    wire [31:0] pc;
	wire [31:0] pcOut;
    wire [31:0] pc_IF_ID;
	wire [31:0] ir;
	wire [31:0] ir_IF_ID;
    wire predict_IF_ID;
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
    wire [31:0] branchAddress_id;
	wire [31:0] memOut; //Output of DM
	wire [31:0] memData_MEM_WB;
	wire [31:0] aluOut_MEM_WB;
	wire [31:0] result;
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

    wire match;
    wire predict;
    wire stall;
    wire equal_id;
    //wire rs_sel;
    //wire rt_sel;
    wire forward_ad;
    wire forward_bd;
	wire forward_c;
    wire [1:0] new_state;
    wire [1:0] forward_a;
    wire [1:0] forward_b;
    
    wire [4:0] rs_ID_EX;
    //wire [31:0] regRs_wb;
    //wire [31:0] regRt_wb;
    wire [31:0] regRs_final;
    wire [31:0] regRt_final;
    wire [31:0] regRs_forward_ex;
    wire [31:0] regRt_forward_ex;
    wire [31:0] storeData;
    wire [31:0] pc_correct_branch;
    wire [31:0] ta0;
    wire [31:0] pc_next_if;
    
	////WRITE YOUR CODE HERE
	pc p(clk, reset, ~stall, pcIn, pcOut);

	registerFile rf(clk, reset, regWrite_MEM_WB, ir_IF_ID[25:21], ir_IF_ID[20:16], destReg_MEM_WB, result, regRs, regRt);

	signExt16to32 se(ir_IF_ID[15:0], signExtOut);

	alu al(regRs_forward_ex, aluIn2, aluCtrl, aluOut, zero);

	aluCtrl alct(aluOp, signExtOut_ID_EX[5:0], aluCtrl);
    
	IM im(clk, reset, pcOut[6:2], 1'b1, ir);

	DM dm(clk, reset, memRead_EX_MEM, memWrite_EX_MEM, aluOut_EX_MEM[6:2], storeData, memOut);

	EX_MEM exmem(clk, reset, 1'b1, memRead_ID_EX, memWrite_ID_EX, memToReg_ID_EX, 
				 regWrite_ID_EX, rt_rd_ex_mem_in, regRt_ID_EX, aluOut, zero,
                  memRead_EX_MEM,  memWrite_EX_MEM, memToReg_EX_MEM, regWrite_EX_MEM, destReg_EX_MEM, 
				 memData_EX_MEM, aluOut_EX_MEM,zero_EX_MEM);

	ID_EX idex(clk, reset | stall, 1'b1, regRs, regRt, 
				 regDest, aluSrcB, aluOp, memRead, memWrite, memToReg, 
				 regWrite, signExtOut, ir_IF_ID[25:21], ir_IF_ID[20:16], ir_IF_ID[15:11], pc_IF_ID, 
                 regRs_ID_EX, 
				 regRt_ID_EX, regDest_ID_EX, aluSrcB_ID_EX, aluOp_ID_EX, 
				 memRead_ID_EX, memWrite_ID_EX, memToReg_ID_EX, regWrite_ID_EX, branch_ID_EX,
				 signExtOut_ID_EX, rs_ID_EX, rt_ID_EX, rd_ID_EX, pc_ID_EX);

	IF_ID ifid(clk, reset | (~stall & (branch & ((branch & ~equal_id) ^ predict_IF_ID))), ~stall, ir, pc, (predict & match), ir_IF_ID, pc_IF_ID, predict_IF_ID);

	MEM_WB memwb(clk, reset, 1'b1, memToReg_EX_MEM, regWrite_EX_MEM, destReg_EX_MEM, 
				  memOut, aluOut_EX_MEM, memToReg_MEM_WB, regWrite_MEM_WB, 
				  destReg_MEM_WB, memData_MEM_WB, aluOut_MEM_WB);

	controlCircuit cc(ir_IF_ID[31:26], aluOp, aluSrcB, branch, memWrite, memRead, memToReg, regDest, regWrite);

	comparator comp(regRs_final, regRt_final, equal_id);

    adder ad0(pcOut, 32'd4, pc);
	adder branch_addr0(pc_IF_ID, {signExtOut[29:0],2'b0}, branchAddress_id);

	mux2to1_32bits mux_result0(aluOut_MEM_WB, memData_MEM_WB, memToReg_MEM_WB, result);
	mux2to1_32bits mux_aluin2_0(regRt_forward_ex, signExtOut_ID_EX, aluSrcB_ID_EX, aluIn2);
	mux2to1_32bits mux_dataforward0(memData_EX_MEM, result, forward_c, storeData);

	mux4to1_32bits mux_aluin1_0(regRs_ID_EX, result, aluOut_EX_MEM, 32'b0, forward_a, regRs_forward_ex);
	mux4to1_32bits mux_regrt_forward0(regRt_ID_EX, result, aluOut_EX_MEM, 32'b0, forward_b, regRt_forward_ex);

	mux2to1_5bits mux_rd0(rt_ID_EX, rd_ID_EX, regDest_ID_EX, rt_rd_ex_mem_in);
	mux2to1_32bits mux_branch_forward_rs0(regRs, aluOut_EX_MEM, forward_ad, regRs_final);
	mux2to1_32bits mux_branch_forward_rt0(regRt, aluOut_EX_MEM, forward_bd, regRt_final);
    
	branchTB btb(clk, reset, pc_IF_ID, branchAddress_id, (branch & (~equal_id)),
                branch, pc, predict, match, ta0);
	hazardDetectionUnit hu(memToReg_EX_MEM, branch, regWrite_ID_EX, memRead_ID_EX, rt_rd_ex_mem_in, 
                            destReg_EX_MEM, ir_IF_ID[25:21], ir_IF_ID[20:16], stall);
	forwardingUnit fu(ir_IF_ID[25:21], ir_IF_ID[20:16], rs_ID_EX, rt_ID_EX, destReg_EX_MEM, 
                        destReg_MEM_WB, regWrite_EX_MEM, regWrite_MEM_WB, 
                        forward_a, forward_b, forward_c, forward_ad, forward_bd);


	mux2to1_32bits mux_pc_branch0(pc, branchAddress_id, (branch & (~equal_id)), pc_correct_branch);
	mux2to1_32bits mux_pc_next0(pc_next_if, pc_correct_branch, branch & ((branch & ~equal_id) ^ predict_IF_ID), pcIn);
	mux2to1_32bits mux_pc_next_if0(pc, ta0, (match & predict), pc_next_if); 

	
endmodule

//MIPS's instruction's Opcode

`define ADDI    6'd8
`define LW      6'd35
`define SW      6'd43
`define BNE     6'd5
`define ADD     6'd0

module controlCircuit(input clk, input reset, input [5:0] opcode, input [5:0] funct, output reg pcWr, output reg pcSrc,
                        output reg bne, output reg irWr, output reg memRead, output reg regWr, output reg regDest, 
                        output reg memToReg, output reg aluSrcA, output reg [1:0] aluSrcB, output reg [1:0] aluOp, 
                        output reg zero, output reg memWr, output reg iorD);
	// Write your code here
	reg [3:0] state;
	reg [3:0] nextstate;
    parameter T0 = 0, T1 = 1, T2 = 2, T3 = 3, T4 = 4, T5 = 5, T6 = 6, T7 = 7, T8 = 8, T9 = 9;
	
	//WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
	always @(posedge clk,reset) begin
         if(reset==1'b1)
         begin
            state=T0;
         end
         else
         state=nextstate;
    end
    always @(state,opcode) 
    begin
        pcWr=1'b0;
        pcSrc=1'b1;
        bne=1'b0;
        irWr=1'b0;
        memRead=1'b0;
        regWr=1'b0;
        regDest=1'b0;
        memToReg=1'b0;
        aluSrcA=1'b0;
        aluSrcB=2'b00;
        aluOp=2'b00;
        zero=1'b0;
        memWr=1'b0;
        iorD=1'b0;
        case(state)
        T0:
        begin
            iorD=1'b0;
            pcWr=1'b1;
            pcSrc=1'b0;
            memRead=1'b1;
            aluSrcA=1'b0;
            aluSrcB=2'b01;
            irWr=1'b1;
            aluOp=2'b00;
            nextstate=T1;
        end
        T1:
        begin
            aluOp=2'b00;
            aluSrcA=1'b0;
            aluSrcB=2'b11;
            pcSrc=1'b1;
            case(opcode)
            `LW:nextstate=T3;
            `SW:nextstate=T3;
            `ADDI:nextstate=T3;
            `ADD:nextstate=T2;
            `BNE:nextstate=T4;
            endcase
        end
        T2:
        begin
            aluSrcA=1'b1;
            aluSrcB=2'b00;
            aluOp=2'b00;
            nextstate=T5;
        end
        T3:
        begin
            aluSrcA=1'b1;
            aluSrcB=2'b10;
            aluOp=2'b00;
            case(opcode)
            `LW:nextstate=T6;
            `SW:nextstate=T7;
            `ADDI:nextstate=T8;
            endcase
        end
        T4:
        begin
            bne=1'b1;
            aluSrcA=1'b1;
            aluSrcB=2'b00;
            aluOp=2'b01;
            nextstate=T0;
        end
        T5:
        begin
            regWr=1'b1;
            memToReg=1'b0;
            regDest=1'b1;
            nextstate=T0;
        end
        T6:
        begin
            iorD=1'b1;
            memRead=1'b1;
            nextstate=T9;
        end
        T7:
        begin
            memWr=1'b1;
            iorD=1'b1;
            nextstate=T0;
        end
        T8:
        begin
            regWr=1'b1;
            memToReg=1'b0;
            regDest=1'b0;
            nextstate=T0;
        end
        T9:
        begin
            memToReg=1'b1;
            regDest=1'b0;
            regWr=1'b1;
            nextstate=T0;
        end
    endcase
    end
endmodule

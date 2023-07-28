

module controlCircuit(input [5:0] opcode, output reg [1:0] aluOp, output reg aluSrc, output reg branch, output reg memWrite, output reg memRead, output reg memtoReg, output reg regDest, output reg regWrite );
  //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
  always@(opcode)
begin
      case(opcode)
      6'd0:
      begin
           aluOp=2'b10;
           regDest=1;
           aluSrc=0;
           branch=0;
           memWrite=0;
           memRead=0;
           memtoReg=0;
           regWrite=1;
      end
      6'd8: 
      begin
           aluOp=2'b00;
           regDest=0;
           aluSrc=1;
           branch=0;
           memWrite=0;
           memRead=0;
           memtoReg=0;
           regWrite=1;
      end
      6'd35:
      begin
           aluOp=2'b00;
           regDest=0;
           aluSrc=1;
           branch=0;
           memWrite=0;
           memRead=1;
           memtoReg=1;
           regWrite=1;
      end
      6'd43:
      begin
           aluOp=2'b00;
           regDest=0;
           aluSrc=1;
           branch=0;
           memWrite=1;
           memRead=0;
           memtoReg=0;
           regWrite=0;
      end      
      6'd5:
      begin
           aluOp=2'b01;
           regDest=0;
           aluSrc=1;
           branch=1;
           memWrite=0;
           memRead=0;
           memtoReg=0;
           regWrite=0;
      end
   endcase
end
    
endmodule


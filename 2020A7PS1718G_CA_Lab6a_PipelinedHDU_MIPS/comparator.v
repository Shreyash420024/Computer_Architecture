

module comparator (input [31:0] in1, input [31:0] in2, output reg equal);
    
    //WRITE YOUR CODE HERE
   always @(in1,in2) begin
    if(in1 == in2) equal = 1;
    else equal = 0; 
   end
endmodule

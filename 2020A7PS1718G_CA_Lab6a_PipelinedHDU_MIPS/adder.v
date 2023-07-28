

module adder(input [31:0] in1, input [31:0] in2, output reg [31:0] adderOut);
    always@(in1, in2)
    begin
        adderOut = in1 + in2;
    end
endmodule

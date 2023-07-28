


//This module implements the FSM part of the predictor. If the address of a branch does not match the 
//branch address of the value stored in the table, the state is initialised with 3, and the old branch
//address value is replaced.
module branchFSM(input clk, input reset,  input enable, input actual_outcome, input [4:0] branch_address, output reg [1:0] state);
    reg [1:0] new_state;
    reg [4:0] stored_BA;
    reg [4:0] new_stored_BA;
    
    //WRITE YOUR CODE HERE
    always @(posedge clk) begin
        if(reset==1) begin new_state = 2'b11; new_stored_BA=0; end
        else if (enable == 1'b1) begin
            if(branch_address != stored_BA) begin new_state = 2'b11; new_stored_BA = branch_address; end
            else begin
                if(actual_outcome==1) begin
                    case(state)
                        2'b00: new_state = 2'b01; 
                        2'b01: new_state = 2'b11;
                        2'b10: new_state = 2'b11;
                        2'b11: new_state = 2'b11;
                       
                    endcase
                end
                else begin
                    case(state)
                        2'b00: new_state = 2'b00;
                        2'b01: new_state = 2'b00;
                        2'b10: new_state = 2'b00;
                        2'b11: new_state = 2'b10;
                        
                    endcase
                end
            end
        end
        stored_BA = new_stored_BA;
        state = new_state;
    end
    
    

endmodule

//This corresponds to a single entry in the table: the branch address, the target address and the state.
module branchTB_reg (input clk, input reset, input enable, input [31:0] in_branch_addr, input [31:0] in_target_addr, input actual_outcome,  
                    output [31:0] out_branch_addr, output [31:0] out_target_addr, output [1:0] out_state);
    
    register32bit entry_BA (clk, reset, enable, in_branch_addr, out_branch_addr);
    register32bit entry_TA (clk, reset, enable, in_target_addr, out_target_addr);
    branchFSM entry0_FSM (clk, reset, enable, actual_outcome, in_branch_addr[6:2], out_state);

endmodule            

//This module implements the branch predictor. This predictor has only one entry.
module branchTB(input clk, input reset, input [31:0] branch_addr, input [31:0] target_addr, input actual_outcome,
                input enable, input [31:0] search_entry, output predict, output match,  output [31:0] ta0);

    wire [31:0] ba0;
    wire [1:0] state0;
    
    branchTB_reg entry0 (clk, reset, enable, branch_addr, target_addr, actual_outcome, ba0, ta0, state0);
    buf(predict, state0[1]);
    comparator branchTB_match (search_entry, ba0, match);
    
endmodule





module hazardDetectionUnit(input memtoreg_mem, input branch_id, input regwrite_ex, input memread_ex, input [4:0] rd_ex, 
                            input [4:0] rd_mem, input [4:0] rs_id, input [4:0] rt_id, output reg stall);
    
    //WRITE YOUR CODE HERE
    always @(*) begin
        stall = 0;

        if((rs_id==rd_ex || rt_id==rd_ex) && memread_ex) stall=1'b1;

        if ( (branch_id && regwrite_ex && (rd_ex == rs_id || rd_ex == rt_id)) || (branch_id && memtoreg_mem && (rd_mem == rs_id || rd_mem == rt_id)) ) stall=1'b1;
    end

endmodule


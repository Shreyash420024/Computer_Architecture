


module forwardingUnit(input [4:0] rs_id, input [4:0] rt_id, input [4:0] rs_ex, input [4:0] rt_ex, input [4:0] rd_mem, 
                        input [4:0] rd_wb, input regwrite_mem, input regwrite_wb, 
                        output reg [1:0] forward_a, output reg [1:0] forward_b, output reg forward_c, output reg forward_ad, output reg forward_bd);
    
    //WRITE YOUR CODE HERE
    always @(*) begin
        forward_a = 0;
        forward_b = 0;
        forward_c = 0;
        forward_ad = 0;
        forward_bd = 0;

        if ( regwrite_mem && (rd_mem != 0) && (rd_mem == rt_ex) ) forward_b = 2'b10;

        if ( regwrite_wb && (rd_wb != 0) && (rd_wb == rd_mem) ) forward_c = 1'b1;

        if ( (rs_id != 0) && (rs_id == rd_mem) && regwrite_mem ) forward_ad = 1'b1;

        if ( (rt_id != 0) && (rt_id == rd_mem) && regwrite_mem ) forward_bd = 1'b1;

        if ( regwrite_wb && (rd_wb != 0) && (rd_wb == rs_ex) ) forward_a = 2'b01;

        if ( regwrite_wb && (rd_wb != 0) && (rd_wb == rt_ex) ) forward_b = 2'b01;

        if ( regwrite_mem && (rd_mem != 0) && (rd_mem == rs_ex) ) forward_a = 2'b10;

        
    end

endmodule


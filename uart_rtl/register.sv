module register
        #(parameter ADDR_WIDTH = 8, DATA_WIDTH = 8, DEPTH = (1 << ADDR_WIDTH))
        (
            input  logic  clk,
            input  logic  w_en,
            input  logic  [ADDR_WIDTH-1:0] r_addr,
            input  logic  [ADDR_WIDTH-1:0] w_addr,
            input  logic  [DATA_WIDTH-1:0] w_data,
            
            output logic  [DATA_WIDTH-1:0] r_data
        );
        
        logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];
        
        
        // write syncronous
        always_ff @(posedge clk)
        begin
            if(w_en)
                memory[w_addr] <= w_data;
        end
        
        // read asynchronous
        assign r_data = memory[r_addr];
        
endmodule
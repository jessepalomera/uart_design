module fifo #(parameter ADDR_WIDTH = 8, DATA_WIDTH = 8) (
        // Inputs
        input  logic clk,
        input  logic reset_n,
        input  logic wr_uart, rd_uart,
        input  logic [DATA_WIDTH-1:0] wr_data,
        // Outputs
        output logic [DATA_WIDTH-1:0] rd_data,
        output logic full, empty
        );
        
        logic [ADDR_WIDTH-1:0] w_addr, r_addr;
        
        register #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) reg_file (
            .clk    (clk),
            .r_data (rd_data),
            .w_data (wr_data),
            .w_addr (w_addr),
            .r_addr (r_addr),
            .w_en   (wr_uart)       
        );    
        
        fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH)) ctrl_file (
            .clk     (clk),
            .reset_n (reset_n),
            .wr      (wr_uart),
            .rd      (rd_uart),
            .full    (full),
            .empty   (empty),
            .w_addr  (w_addr),
            .r_addr  (r_addr)
        );

endmodule  
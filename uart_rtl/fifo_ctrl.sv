module fifo_ctrl
        #(parameter ADDR_WIDTH = 8)
        (
            input logic clk,
            input logic reset_n,
            input logic wr,
            input logic rd,
            
            output logic full,
            output logic empty,
            output logic [ADDR_WIDTH-1:0] w_addr,
            output logic [ADDR_WIDTH-1:0] r_addr
        );
        
        logic [ADDR_WIDTH-1:0] wr_pos, wr_pos_next;
        logic [ADDR_WIDTH-1:0] rd_pos, rd_pos_next;
        logic full_next;
        logic empty_next;
        
        
        always_ff @(posedge clk, negedge reset_n) 
        begin
            if (!reset_n)
            begin
                wr_pos <= 0;
                rd_pos <= 0;
                full <= 1'b0;
                empty <= 1'b1;
            end
            else
            begin
                wr_pos <= wr_pos_next;
                rd_pos <= rd_pos_next;
                full <= full_next;
                empty <= empty_next;
            end
        end       
        
        
        always_comb
        begin
            // Default Statements
            wr_pos_next = wr_pos;
            rd_pos_next = rd_pos;
            full_next = full;
            empty_next = empty;
            
            case({wr,rd})
                2'b01: //READ
                begin
                    if (!empty)
                    begin
                        rd_pos_next = rd_pos + 1;
                        full_next   = 1'b0;
                        if (rd_pos_next == wr_pos)
                            empty_next = 1'b1;
                    end
                end
                2'b10: //Write
                begin
                    if (!full)
                    begin
                        wr_pos_next = wr_pos + 1;
                        empty_next = 1'b0;
                        if (wr_pos_next == rd_pos)
                            full_next = 1'b1;
                    end
                end
                2'b11: //READ & WRITE
                begin
                    if (!empty)
                    begin
                        wr_pos_next = wr_pos + 1;
                        rd_pos_next = rd_pos + 1;
                    end
                end
                
                default: 
                begin
                    wr_pos_next = wr_pos;
                    rd_pos_next = rd_pos;
                    full_next = full;
                    empty_next = empty;
                end
                
            endcase
         
         // Outputs
         assign w_addr = wr_pos;
         assign r_addr = rd_pos; 
            
        end       
        
 endmodule
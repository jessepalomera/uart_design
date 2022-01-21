module transmitter #(parameter DATA_LENGTH = 8)(
    // Inputs
    input clk, reset_n,
    input tx_valid, baud_timer,
    input [DATA_LENGTH-1:0] tx_data,
    // Outputs
    output reg tx_data_transmit,
    output tx
);

    localparam idle = 2'h0, start = 2'h1, transmit = 2'h2, done = 2'h3;
    
    reg [1:0] current_state, next_state;
    reg [3:0] baud_count, next_baud_count; 
    reg [$clog2(DATA_LENGTH)-1:0] current_bit, next_bit;
    reg [DATA_LENGTH-1:0] current_byte, next_byte;
    reg current_tx, next_tx;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (!reset_n)
        begin
            current_state <= idle;
            baud_count <= 0;
            current_bit <= 0;
            current_byte <= 0;
            current_tx  <= 1;
        end
        else
        begin
            current_state <= next_state;
            baud_count    <= next_baud_count;
            current_bit   <= next_bit;
            current_byte  <= next_byte;
            current_tx    <= next_tx;
        end
    end
    
    // SM
    always @(*)
    begin
        next_state            = current_state;
        next_baud_count       = baud_count;
        next_bit              = current_bit;
        next_byte             = current_byte;
        next_tx               = current_tx;
        tx_data_transmit      = 0;
        case (current_state)
            idle:
            begin
                next_tx = 1'h1;
                if (tx_valid)
                begin
                    next_byte = tx_data;   
                    next_baud_count  = 0;
                    next_state = start;
                end
            end
            start:
            begin
                next_tx = 1'h0;        
                if (baud_timer)
                    if (baud_count == 15)
                    begin
                        next_baud_count = 0;
                        next_bit  = 0;
                        next_state = transmit;
                    end
                    else
                        next_baud_count = baud_count + 1;
            end
            transmit:
            begin
                next_tx = current_byte[0];
                if (baud_timer)
                    if (baud_count == 15)
                    begin
                        next_baud_count = 0;
                        next_byte = {1'h1, current_byte[DATA_LENGTH-1:1]}; // Shift data out
                        if (current_bit == (DATA_LENGTH-1))
                            next_state = done;
                        else
                            next_bit = current_bit + 1;    
                    end
                    else
                        next_baud_count = baud_count + 1;               
            end
            done:
            begin        
                next_tx = 1'h1;
                if (baud_timer)
                    if (baud_count == 15)
                    begin
                        next_state = idle;
                        if(!tx_valid)
                            tx_data_transmit = 0;
                        else
                            tx_data_transmit = 1;
                            
                    end
                    else
                        next_baud_count = baud_count + 1;
            end
            default:
                next_state = idle;
        endcase
    end
    
    // Output
    assign tx = current_tx;
    


endmodule

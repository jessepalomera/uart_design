module receiver #(parameter DATA_LENGTH = 8)(
    // Inputs
    input clk, reset_n,
    input rx, baud_timer, 
    // Outputs
    output reg rx_data_received,
    output [DATA_LENGTH-1:0] rx_data
);
    localparam idle = 2'h0, start = 2'h1, receive = 2'h2, done = 2'h3;
    
    reg [1:0] current_state, next_state;
    reg [3:0] baud_count, next_baud_count; 
    reg [$clog2(DATA_LENGTH)-1:0] current_bit, next_bit;
    reg [DATA_LENGTH-1:0] current_byte, next_byte;
    
    
    always @(posedge clk, negedge reset_n)
    begin
        if(!reset_n)
        begin
            current_state <= idle;
            baud_count    <= 0;
            current_bit   <= 0;
            current_byte  <= 0;
        end
        else
        begin
            current_state <= next_state;
            baud_count    <= next_baud_count;
            current_bit   <= next_bit;
            current_byte  <= next_byte;
        end
    end
    
    // FSM
    always @(*)
    begin
        next_state       = current_state;
        next_baud_count  = baud_count;
        next_bit         = current_bit;
        next_byte        = current_byte;
        rx_data_received = 0;
        case (current_state)
            idle:   
                if(!rx)
                begin
                    next_baud_count = 0;
                    next_state      = start;
                end
            start: 
                if(baud_timer)
                    if(baud_count == 7)
                    begin
                        if(rx)
                            next_state = idle;
                        else
                            next_baud_count = 0;
                            next_bit        = 0;
                            next_state      = receive;
                    end
                    else
                        next_baud_count = baud_count + 1;
            receive:
                if(baud_timer)
                    if(baud_count == 15)
                    begin
                        next_baud_count = 0;
                        next_byte       = {rx, current_byte[DATA_LENGTH-1:1]}; // Shift the received bit 
                        if(current_bit == (DATA_LENGTH-1))
                            next_state = done;
                        else
                            next_bit = current_bit + 1;
                    end
                    else
                        next_baud_count = baud_count + 1;
            done:
                if(baud_timer)
                   if(baud_count == 15)
                   begin
                        rx_data_received = 1;
                        next_state = idle;
                   end 
                   else
                        next_baud_count = baud_count + 1;
            default: next_state = idle;
        endcase
    end
    
    assign rx_data = current_byte;
    
endmodule
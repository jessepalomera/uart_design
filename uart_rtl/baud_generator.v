module baud_generator #(parameter BITS = 16)(
    // Inputs
    input clk, reset_n,
    input enable,
    input [BITS-1:0] dvsr,
    
    // Output
    output baud_timer
);

    reg [BITS-1:0] count, next_count;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (!reset_n)
            count <= 'h0;
        else if (enable)
            count <= next_count; 
        else
            count <= count;
    end
    
    assign baud_timer = count == dvsr;
    
    always @(*)
    begin
        next_count = baud_timer? 'b0:count+1;    
    end    
        
endmodule
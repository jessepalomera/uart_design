interface uart_interface(input clk);
    
    // Reset
    logic  reset_n;
    
    // TX Related Signals
    logic  [7:0] transmit_data;
    logic  wr_uart;
    logic  tx_full;
    logic  tx;
    
    // RX Related Signals
    logic  rx;
    logic  rd_uart;
    logic  rx_empty;
    logic  [7:0] receive_data;

    // Baud Generator
    logic  [15:0] dvsr;
    logic  enable;

    default clocking cb @(posedge clk);
        input  #0 receive_data;
        input  #0 rx_empty;
        input  #0 tx_full;
        input  #0 tx;
        output #1step rd_uart;
        output #1step transmit_data;
        output #1step wr_uart;
        output #1step rx;
        output #1step dvsr;
        output #1step enable;
        output #1step reset_n;
    endclocking

    task loopback_connection();
        assign rx = tx;
    endtask
    
    task init_signals();
        wr_uart = 1'b0;
        rd_uart = 1'b0;
        transmit_data = 8'b0;
        receive_data  = 8'b0;
    endtask
    
    task reset();
        begin
            wait_ns(5);
            cb.reset_n <= 1'b0;
            @(cb);
            cb.reset_n <= 1'b1;
        end    
    endtask
    
    task wait_ns();
        input [31:0] delay;
        begin
            #(delay);
        end
    endtask

    modport uart_port (
        // Outputs
        output receive_data,
        output rx_empty,
        output tx_full,
        output tx,
        // Inputs
        input rd_uart,
        input transmit_data,
        input wr_uart,
        input rx,
        input dvsr,
        input enable,
        input clk,
        input reset_n
    );
    
    modport test_port (
        input clk,
        clocking cb
    );
    
endinterface

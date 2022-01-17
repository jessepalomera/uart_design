module UART #(parameter DATA_LENGTH = 8)(
    
    input clk, reset_n,
    
    // RX Signals
    input rx,
    input rd_uart,
    output rx_empty,
    output rx_full,
    output [DATA_LENGTH-1:0] receive_data,
    
    // TX Signals
    input [DATA_LENGTH-1:0] transmit_data,
    input wr_uart,
    output tx_full,
    output tx,
    
    // Baud Generator
    input [15:0] dvsr,
    input enable

);
   
    // RX
    wire baud_timer;
    wire rx_data_received;
    wire [DATA_LENGTH-1:0] rx_data;
    receiver #(.DATA_LENGTH(DATA_LENGTH)) RX (
        .clk              (clk              ),
        .reset_n          (reset_n          ),
        .rx               (rx               ),
        .baud_timer       (baud_timer       ),
        .rx_data_received (rx_data_received ),
        .rx_data          (rx_data          )
    );
    
//    synch_fifo rx_fifo (
//        .wr_clk(clk),
//        .rd_clk(clk),
//        .wr_en(rx_data_received),
//        .rd_en(rd_uart),
//        .reset_n(reset_n),
//        .wr_data(rx_data),
//        .full(),
//        .empty(rx_empty),
//        .rd_data(receive_data)        
//    );
    
    
    fifo rx_fifo (
        .clk     (clk),
        .reset_n (reset_n),
        .wr_uart (rx_data_received),
        .rd_uart (rd_uart),
        .wr_data (rx_data),
        .rd_data (receive_data),
        .empty   (rx_empty),
        .full    (rx_full)
        
    );
   
    // Baud Rate Generator
    baud_generator #(.BITS(16)) BRG (
        .clk        (clk        ),
        .reset_n    (reset_n    ),
        .enable     (enable     ),
        .dvsr       (dvsr       ),
        .baud_timer (baud_timer )
    );

    // TX
    wire tx_fifo_empty, tx_data_transmit;
    wire [DATA_LENGTH-1:0] tx_data;
    transmitter #(.DATA_LENGTH(DATA_LENGTH)) TX (
        .clk                 (clk                 ),
        .reset_n             (reset_n             ),
        .tx_valid            (!tx_fifo_empty      ),
        .baud_timer          (baud_timer          ),
        .tx_data             (tx_data             ),
        .tx_data_transmit    (tx_data_transmit    ),
        .tx                  (tx                  )
    );
    
//    synch_fifo tx_fifo (
//        .wr_clk  (clk),
//        .rd_clk  (clk),
//        .wr_en   (wr_uart),
//        .rd_en   (tx_data_transmit),
//        .reset_n (reset_n),
//        .wr_data (transmit_data),
//        .full    (tx_full),
//        .empty   (tx_fifo_empty),
//        .rd_data (tx_data)        
//    );    

    fifo tx_fifo (
        .clk     (clk),
        .reset_n (reset_n),
        .wr_uart (wr_uart),
        .rd_uart (tx_data_transmit),
        .wr_data (transmit_data),
        .rd_data (tx_data),
        .empty   (tx_fifo_empty),
        .full    (tx_full )      
    );



endmodule
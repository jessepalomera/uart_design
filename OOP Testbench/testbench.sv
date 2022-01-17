`timescale 1ns/1ns

module tb;

    // 100 Mhz Clock
    bit clk;
    initial begin
        clk = 1'b0;
        forever begin
            #5;
            clk = ~clk;
        end
    end

    uart_interface uif (clk);
    
    UART dut      (
        // Inputs
        .clk           (uif.clk               ),
        .reset_n       (uif.reset_n           ),
        .rx            (uif.rx                ),
        .rd_uart       (uif.rd_uart           ),
        .transmit_data (uif.transmit_data[7:0]),
        .wr_uart       (uif.wr_uart           ),
        .dvsr          (uif.dvsr[15:0]        ),
        .enable        (uif.enable            ),
        
        // Outputs
        .rx_empty      (uif.rx_empty         ),
        .receive_data  (uif.receive_data[7:0]),
        .tx_full       (uif.tx_full          ),
        .tx            (uif.tx               )
    );
    
    testcase test ( 
        uif.test_port, // Driver
        uif.test_port, // Monitor
        uif  
    );
                    
endmodule
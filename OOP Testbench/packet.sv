class packet;
    // Transmit
    rand bit [7:0 ] data[];
    rand bit        wr_uart;
    // Select Baud Rate
    rand bit [15:0] dvsr;
    rand bit        enable;
   
    static bit [63:0] data_length; 
    static bit [15:0] pktid;
    
    constraint legal_write{
        wr_uart == 1;
    }
        
    constraint legal_en   {
        enable  == 1;
    }
    
    constraint legal_baud {
        dvsr inside {650, 324, 107, 53}; // Common Baud Rates: 9600, 19200, 57600, 115200.
    }
    
    constraint data_size  {
        data.size() inside {[10:25]}; 
    }
    
    function new();
    
    endfunction

    function void print();
        $display("data = %p\n", data);
    endfunction



endclass
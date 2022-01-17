class monitor;

    bit [7:0] queue[$];
    mailbox mon2sb;
    virtual uart_interface mi;
    
    function new(input virtual uart_interface mif,
                 input mailbox mon2sb             );
        this.mi     = mif;
        this.mon2sb = mon2sb;
    endfunction
    
    task collect_packet();
        packet rcvpacket;
        rcvpacket = new();
        // Figure out how to receive 
        forever begin
            @(mi.cb)
            if(!mi.cb.rx_empty)
            begin
                mi.cb.rd_uart <= 1'b1;
                queue.push_back(mi.cb.receive_data);
                @(mi.cb)
                mi.cb.rd_uart <= 1'b0;              
            end
            @(mi.cb)
            if(queue.size() == rcvpacket.data_length)
            begin
                rcvpacket.data = queue;
                $display("---- time = %0t ps: Received Packet #%0d with Size: %0d ----", $time, rcvpacket.pktid, rcvpacket.data_length); 
                mon2sb.put(rcvpacket);
                rcvpacket.print();
                queue.delete();
                break;
            end
        end
    
    endtask    


endclass
class driver;

    mailbox drv2sb;
    mailbox pktgen2drv;
    packet pkt;
    virtual uart_interface vi;
    
    function new (input virtual uart_interface vif,
                  input mailbox pktgen2drv,
                  input mailbox drv2sb              );
        this.vi         = vif;
        this.pktgen2drv = pktgen2drv;
        this.drv2sb     = drv2sb;
        pkt             = new();
        
    endfunction
    
    task send_packet();
        // Drive into DUT
        int data_size;
        pktgen2drv.get(pkt);
        pkt.pktid++;
        data_size = pkt.data.size();
        pkt.data_length = data_size;
            for(int i = 0; i < data_size; i++) begin
                vi.cb.dvsr <= pkt.dvsr;;
                @(vi.cb)
                if(!vi.cb.tx_full) begin
                    vi.cb.enable        <= pkt.enable;
                    vi.cb.transmit_data <= pkt.data[i];
                    vi.cb.wr_uart       <= pkt.wr_uart;
                    
                end 
            vi.wait_ns(5);
            vi.cb.wr_uart       <= 1'b0;            
            end
            $display("---- time = %0t ps: Sending a Packet #%0d with Size: %0d ----", $time, pkt.pktid, data_size);
            pkt.print();
            drv2sb.put(pkt);
    endtask



endclass
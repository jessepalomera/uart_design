class packetgenerator;

    mailbox pktgen2drv;
    packet uart;
    
    function new(input mailbox pktgen2drv);
        this.pktgen2drv = pktgen2drv;
        uart = new();
    endfunction
    
    task generate_packet();
        
        packet pkt;
        pkt = new uart;
        assert(pkt.randomize());
        pktgen2drv.put(pkt);
        
    endtask


endclass
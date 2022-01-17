class env;
    
    scoreboard sb;
    mailbox drv2sb;
    mailbox mon2sb;
    mailbox pktgen2drv;
    
    packetgenerator pktgen;
    driver drv;
    monitor mon;
    
    virtual uart_interface vi;
    virtual uart_interface mi;
    
    function new(input virtual uart_interface vif, input virtual uart_interface mif);   
        this.vi    = vif;
        this.mi    = mif;
        pktgen2drv = new();
        drv2sb     = new();
        mon2sb     = new();
        pktgen     = new(pktgen2drv);
        drv        = new(vif, pktgen2drv, drv2sb);
        mon        = new(mif, mon2sb);
        sb         = new(drv2sb, mon2sb);
    endfunction
    
    task run(int num_packet = 2);
        for(int i = 0; i < num_packet; i++)
        begin
        fork
            pktgen.generate_packet();
            drv.send_packet();
        join
            mon.collect_packet();
            sb.compare(drv2sb,mon2sb);
        end
    
    endtask
    
endclass
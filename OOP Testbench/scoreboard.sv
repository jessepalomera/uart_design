class scoreboard;

    mailbox rcv_from_drv;
    mailbox rcv_from_mon;
    
    function new(input mailbox drv2sb, input mailbox mon2sb);
        this.rcv_from_drv = drv2sb;
        this.rcv_from_mon = mon2sb;
    endfunction
    
    task compare(input mailbox rcv_from_drv, input mailbox rcv_from_mon);
        bit error;
        packet pkt_from_drv;
        packet pkt_from_mon;
        
        rcv_from_drv.get(pkt_from_drv);
        rcv_from_mon.get(pkt_from_mon);
        
        begin
            if(pkt_from_drv.data != pkt_from_mon.data) begin
                $display("---- time = %0t ps: ERROR Packet Mismatches! ----\n", $time);
                error++;
            end
            
            if(error == 0) $display("---- time = %0t ps: PASS: Packet Matches! ----\n", $time);
            
        end
       
    
    endtask

endclass
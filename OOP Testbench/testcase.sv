`include "packet.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "packetgenerator.sv"
`include "env.sv"

program testcase(interface tcif_drv, interface tcif_mon, interface muif);

    
    class testcase_packet extends packet;
        constraint legal_baud {dvsr == 53;}
    endclass

     env env0;
     testcase_packet baud_115200;
     
     initial begin
        muif.reset();
        muif.loopback_connection();
        muif.init_signals();
        
        env0 = new(tcif_drv, tcif_mon);
        
        baud_115200 = new();
        env0.pktgen.uart = baud_115200;
        env0.run();
        
        #100 $finish;
     
     end

endprogram
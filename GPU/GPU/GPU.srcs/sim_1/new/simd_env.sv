
`ifndef SIMD_ENV_SV
`define SIMD_ENV_SV

`include "simd_if.sv"
class environment;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;
    
    mailbox #(transaction) cutie_drv, cutie_mon;

    virtual simd_if vif;

    function new(virtual simd_if vif); 
    
        cutie_drv = new();
        cutie_mon = new();
        
        drv = new(vif, cutie_drv);
        mon = new(vif, cutie_mon);
        gen = new(cutie_drv);
        scb = new(cutie_mon);
        
    endfunction
    
    
    task run();
    
        fork
            drv.run();
            mon.run();
            scb.run();
            
        join_none //din cauza blocurilor forever
    
    endtask
    
    task wait_for_end();
    
        wait(gen.generated_pkg == scb.monitored_pkg);
        $display("[ENVIRONMENT] Toate cele %0d instructiuni au fost procesate si verificate.", gen.generated_pkg);
        $display("[ENVIRONMENT] Simularea se poate incheia in siguranta.");
        #20;
    endtask
endclass

`endif
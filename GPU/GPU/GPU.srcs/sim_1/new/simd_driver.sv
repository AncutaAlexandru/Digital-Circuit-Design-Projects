

`ifndef SIMD_DRIVER_SV
`define SIMD_DRIVER_SV
`include "simd_if.sv"
class driver;

    virtual simd_if virt_intf; //conexiunea la interfata
    mailbox #(transaction) cutie;
    int generated_pkg = 0;
    function new(virtual simd_if vif, mailbox #(transaction) c);
    
         cutie = c;
         virt_intf = vif;
        
    endfunction

    task run();
    
        transaction trn;
        virt_intf.driver_block.Instr_data <= 0;
        virt_intf.driver_block.Data_in_mem <= 0;
        wait(virt_intf.reset == 0);
        $display("[DRIVER] Reset eliberat. Driver-ul este gata.");
        forever  begin
        
            cutie.get(trn);
            @(virt_intf.driver_block);
            virt_intf.driver_block.Instr_data <= trn.Instr_data;
            virt_intf.driver_block.Data_in_mem <= trn.Data_in_mem;
            generated_pkg++;
        end
    endtask

endclass


`endif
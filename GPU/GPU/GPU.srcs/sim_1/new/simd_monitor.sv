

`ifndef SIMD_MONITOR_SV
`define SIMD_MONITOR_SV

`include "simd_if.sv"
class monitor;

    virtual simd_if virt_intf; //conexiunea la interfata
    mailbox #(transaction) cutie;
    int monitored_pkg = 0;
    function new(virtual simd_if vif, mailbox #(transaction) c);
    
        cutie = c;
        virt_intf = vif;
    
    endfunction

    task run();
        transaction trn;
        wait(virt_intf.reset == 0); 
        $display("[MONITOR] Reset eliberat. Începem monitorizarea.");
        forever  begin
            @(virt_intf.monitor_block);
            trn = new();
            trn.Instr_data = virt_intf.monitor_block.Instr_data;
            trn.Data_in_mem = virt_intf.monitor_block.Data_in_mem;
            trn.Data_out_mem = virt_intf.monitor_block.Data_out_mem;
            if (trn.Instr_data != 0) begin
                cutie.put(trn);
                monitored_pkg++;
            end
            
        end
    endtask

endclass

`endif
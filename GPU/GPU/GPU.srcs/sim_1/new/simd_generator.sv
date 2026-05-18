


`ifndef SIMD_GENERATOR_SV
`define SIMD_GENERATOR_SV
class generator;

    mailbox #(transaction) cutie;
    int generated_pkg = 0;
    
    function new(mailbox #(transaction) c);
        cutie = c;
        
    endfunction
    
    task gen_input(int num_transactions,string error_type = "Valid");
    
        $display("[GENERATOR] Incep generarea a %0d pachete de tip: %s", num_transactions, error_type);
        for (int i = num_transactions; i > 0; i--) begin
        
            transaction trn;
            trn = new(); 
            
            case (error_type)
                "Prefix": begin
                    trn.con_prefix.constraint_mode(0);
                end
                
                "Opcode": begin
                    trn.con_opcode.constraint_mode(0);
                end
                
                "Instr": begin
                    trn.con_instr.constraint_mode(0);
                end
                
            endcase
            
            if (!trn.randomize()) begin
                $error("[GENERATOR] Eroare fatala la randomizare in pasul %0d!", i);
            end
            
            cutie.put(trn);
            generated_pkg++;
            $display("[GENERATOR] Am  generat  %0d pachete de tip: %s", generated_pkg, error_type);
        end
    endtask
endclass


`endif
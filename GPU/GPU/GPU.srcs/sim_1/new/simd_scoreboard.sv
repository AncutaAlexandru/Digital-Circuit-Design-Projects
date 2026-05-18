

`ifndef SIMD_SCOREBOARD_SV
`define SIMD_SCOREBOARD_SV
`include "Defines.vh"
class scoreboard;

    mailbox #(transaction) cutie;
    logic [127:0] soft_regfile [7:0]; //emulare regfile
    int monitored_pkg = 0;
    function new(mailbox #(transaction) c);
    
        cutie = c;
        //Initializare memorie
        foreach(soft_regfile[i]) begin
            soft_regfile[i] = 128'd0;
        end
    endfunction


    task run();
    
        transaction trn; 
        //emulare semnale hardware
        logic [2:0] addr_src, addr_dest;
        logic [31:0] val_src, val_dest;
        logic [63:0] mul_res; 
        forever begin
        
            cutie.get(trn);
            //extragere adrese
            addr_src  = trn.Instr_data[18:16];
            addr_dest = trn.Instr_data[21:19];
            
            if (trn.Instr_data[7:0] == `PREFIX_SSE) begin
            
                case(trn.Instr_data[15:8]) 
                
                    `OP_ADDPS: begin
                    
                        for(int i = 0; i < 4; i++) begin
                            // impartire in 4 lanuri de 32 de biti
                            val_src  = soft_regfile[addr_src][i*32 +: 32];
                            val_dest = soft_regfile[addr_dest][i*32 +: 32];
                            
                            soft_regfile[addr_dest][i*32 +: 32] = val_dest + val_src;
                        end
                        $display("[SCOREBOARD] Executat ADDPS software: R%0d + R%0d", addr_dest, addr_src);
                    end
                    `OP_SUBPS: begin
                        
                        for(int i = 0; i < 4; i++) begin
                            val_src  = soft_regfile[addr_src][i*32 +: 32];
                            val_dest = soft_regfile[addr_dest][i*32 +: 32];
                            
                            soft_regfile[addr_dest][i*32 +: 32] = val_dest - val_src;
                        end
                        $display("[SCOREBOARD] Executat SUBPS software: R%0d - R%0d", addr_dest, addr_src);
                    end
                    `OP_MULPS: begin
                    
                       for(int i = 0; i < 4; i++) begin
                            val_src  = soft_regfile[addr_src][i*32 +: 32];
                            val_dest = soft_regfile[addr_dest][i*32 +: 32];
                            
                            mul_res = val_src * val_dest;
                            // Extragere rezultat
                            soft_regfile[addr_dest][i*32 +: 32] = mul_res[47:16]; 
                        end
                        $display("[SCOREBOARD] Executat MULPS software: R%0d * R%0d", addr_dest, addr_src);
                    
                    end
                    `OP_MOVAPS_LOAD: begin
                    
                        // Încărcăm datele de intrare în modelul software
                        soft_regfile[addr_dest] = trn.Data_in_mem;
                        $display("[SCOREBOARD] LOAD in R%0d valoarea %h", addr_dest, trn.Data_in_mem);
                    
                    end
                    `OP_MOVAPS_STORE: begin
                    
                        if (soft_regfile[addr_src] == trn.Data_out_mem) begin
                            $display("\n---> [PASS] STORE Corect! R%0d Hardware: %h == Software: %h\n", 
                                     addr_src, trn.Data_out_mem, soft_regfile[addr_src]);
                        end else begin
                            $display("\n---> [FAIL] Eroare STORE! R%0d Hardware: %h != Software: %h\n", 
                                     addr_src, trn.Data_out_mem, soft_regfile[addr_src]);
                        end
                        
                    end
                    
                    default: begin
                        $display("[SCOREBOARD] WARNING: Opcode invalid (%h) detectat și ignorat.", trn.Instr_data[15:8]);
                    end
                endcase  
                
            end 
            else begin
                $display("[SCOREBOARD] WARNING: Prefix invalid (%h) detectat si ignorat. Asteptat: %h", 
                         trn.Instr_data[7:0], `PREFIX_SSE);
            end 
            monitored_pkg++; 
        end
    endtask
endclass

`endif
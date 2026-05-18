`timescale 1ns / 1ps
`include "Defines.vh"

module tb_SIMD_TOP();

    // --- 1. Declararea Semnalelor ---
    reg [`INSTR_RANGE]  Instr_data;
    reg [`DATA_RANGE]   Data_in_mem;
    reg                 clk;
    reg                 reset;
    
    wire [`DATA_RANGE]  Data_out_mem;
    wire                load_use_hazard;

    // --- 2. Instanțierea (DUT) ---
    SIMD_TOP DUT (
        .Instr_data(Instr_data),
        .Data_in_mem(Data_in_mem),
        .clk(clk),
        .reset(reset),
        .load_use_hazard(load_use_hazard),
        .Data_out_mem(Data_out_mem)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task load_reg;
        input [2:0] dest_reg;
        input [127:0] data_val;
        begin
            //MOVAPS
            Instr_data = {8'h00, 2'b00, dest_reg, 3'b000, 8'h28, 8'h0F};
            Data_in_mem = 128'dx; 
            @(posedge clk);
            
            // NOP
            Instr_data = 32'h0000FFFF; 
            @(posedge clk);
            
            //Inserare date
            Instr_data = 32'h0000FFFF; 
            Data_in_mem = data_val;
            @(posedge clk);
            
            // Ciclul 4: Așteptăm scrierea
            Data_in_mem = 128'dx; 
            @(posedge clk);
        end
    endtask

    initial begin

        reset = 1'b1;
        Instr_data = 32'd0;
        Data_in_mem = 128'd0;
        
        #20;
        @(posedge clk);
        reset = 1'b0;
        
        $display("---Incarcare registre---");
        // 10
        load_reg(3'b001, 128'h000000000000000000000000_000A0000);
        // 20
        load_reg(3'b010, 128'h000000000000000000000000_00140000);
        //30
        load_reg(3'b011, 128'h000000000000000000000000_001E0000);
        //40
        load_reg(3'b100, 128'h000000000000000000000000_00280000);
        //50
        load_reg(3'b101, 128'h000000000000000000000000_00320000);
        //60 
        load_reg(3'b110, 128'h000000000000000000000000_003C0000);

        $display("--- Executie operatii ---");
        
        // ADD R2 cu R1
        Instr_data = 32'h00CA580F; 
        @(posedge clk);
        
        // SUB R4 cu R3
        Instr_data = 32'h00DC5C0F; 
        @(posedge clk);
        
        // MULR6 cu R5
        Instr_data = 32'h00EE590F; 
        @(posedge clk);
        
        // golire pipeline
        Instr_data = 32'h0000FFFF; @(posedge clk);
        Instr_data = 32'h0000FFFF; @(posedge clk);

        $display("--- Executie Store ---");
        
        // STORE
        Instr_data = 32'h0005290F; 
        @(posedge clk);
        
        //golire pipeline
        Instr_data = 32'h0000FFFF; @(posedge clk);
        Instr_data = 32'h0000FFFF; @(posedge clk);
        @(posedge clk);
        
        $display("----- Final-------");
        $finish;
    end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 03:50:10 PM
// Design Name: 
// Module Name: tb_SIMD_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_SIMD_TOP;

    reg clk, reset;
    reg [31:0] Instr_data;
    reg [127:0] Data_in_mem;
    wire [127:0] Data_out_mem;
    
    SIMD_TOP Dut (
        .clk(clk),
        .reset(reset),
        .Instr_data(Instr_data),
        .Data_in_mem(Data_in_mem),
        .Data_out_mem(Data_out_mem)
    );
    
    always #5 clk = ~clk;
    
    initial begin
    
        clk = 0;
        reset = 1;
        Instr_data = 0;
        Data_in_mem = 0;
        
        #20;
        reset = 0;
        #10;
        
        // Scenariu Instructiune MovAps Load
        
        Data_in_mem = 128'h00050000_00050000_00050000_00050000;
        Instr_data  = 32'h0000280F;
        #10;
        
        Data_in_mem = 128'h00020000_00020000_00020000_00020000;
        Instr_data  = 32'h0008280F;
        #10;
        
        // Scenariu Addps
        Instr_data = 32'h00C1580F; 
        #10;
        
        
        Instr_data = 32'h00C15C0F;
        #10;
        
        Instr_data = 32'h00C1590F;
        #10;
        
        #10;
        Data_in_mem = {4{32'hFFFF0000}};
        Instr_data  = 32'h0008280F; 

        // --- Pasul 9: MULPS XMM0, XMM1 (10.0 * -1.0 = -10.0) ---
        #10;
        Instr_data = 32'h00C1590F; 

        #20;
        $display("Test finalizat. Verifică formele de undă!");
        $finish;
        
    end
endmodule

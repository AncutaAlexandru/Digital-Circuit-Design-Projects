`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 09:49:00 PM
// Design Name: 
// Module Name: RegFile
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
`include "Defines.vh"

module RegFile(

input clk, reset, w_en, r_en,
input [`DATA_RANGE] data_in,
input [`ADDR_RANGE] addr_rs, addr_rd, addr_wr,
output reg [`DATA_RANGE] dout_rs, dout_rd

    );
    
    reg [`REG_WIDTH_RANGE] regfile_mem [`REG_RANGE];
    integer i;
    
    always @(posedge clk) begin
        if(reset) begin
            for(i = 0;i<= 7;i = i+1)begin
                regfile_mem[i][`REG_WIDTH_RANGE] <= 128'd0;
            end
        end 
        else if(w_en) begin
            regfile_mem[addr_wr][`REG_WIDTH_RANGE] <= data_in;
            
            
        end
        else begin
            regfile_mem[addr_wr][`REG_WIDTH_RANGE] <= regfile_mem[addr_wr][`REG_WIDTH_RANGE];
        end
            
        
    
    
    end
    
    always @(*) begin 
            dout_rs[`DATA_RANGE] = regfile_mem[addr_rs][`REG_WIDTH_RANGE] & {128{r_en}};
            dout_rd[`DATA_RANGE] = regfile_mem[addr_rd][`REG_WIDTH_RANGE] & {128{r_en}};
            
    end
    
    
endmodule

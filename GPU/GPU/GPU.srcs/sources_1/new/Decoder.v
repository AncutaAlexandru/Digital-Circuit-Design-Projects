`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2026 10:55:53 AM
// Design Name: 
// Module Name: Decoder
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
/*
Instrucțiunea 
31          24 23        16 15         8 7        0
+-------------+------------+------------+---------+
|  reserved   |   ModRM    |   opcode   |  0x0F   |
+-------------+------------+------------+---------+

ModRM
7     6 5     3 2     0
+------+-------+-------+
| mod  | dest  | src   |
+------+-------+-------+
*/

`include "Defines.vh"

module Decoder (
    input [`INSTR_RANGE] Instr_data,
    output reg [`ADDR_RANGE] addr_src, addr_dest,
    output reg [`ALU_OP_RANGE] ALU_op,
    output reg mod_reg, mod_mem,
    output reg w_en, r_en
);
    wire [7:0] opcode; 
    wire [7:0]prefix;
    wire [1:0] mod;
    
    assign prefix = Instr_data[7:0];
    assign mod = Instr_data[23:22];
    assign opcode = Instr_data[15:8];
    always @(*) begin
        if(prefix == `PREFIX_SSE) begin
            addr_src = Instr_data[18:16];
            addr_dest = Instr_data[21:19];
        end
        else begin
            addr_src = 3'd0;
            addr_dest = 3'd0;
        end
    end
   
    always @(*) begin
        if(prefix == `PREFIX_SSE) begin
            case(opcode)
            `OP_ADDPS :         ALU_op = `ALU_ADD;
            `OP_SUBPS :         ALU_op = `ALU_SUB;
            `OP_MULPS :         ALU_op = `ALU_MUL;
            `OP_MOVAPS_LOAD :   ALU_op = `ALU_NOP;
            `OP_MOVAPS_STORE :  ALU_op = `ALU_NOP;
            default:            ALU_op = `ALU_NOP;
            endcase
        end
        else begin 
            ALU_op = `ALU_NOP;
        end
    end
   
   always @(*) begin
        if(mod == `MOD_REG && prefix == `PREFIX_SSE) begin
            mod_reg = 1'b1;
            mod_mem = 1'b0;
        end
        else if (mod == `MOD_MEM && prefix == `PREFIX_SSE) begin
            mod_mem = 1'b1;
            mod_reg = 1'b0;
        end
        else begin
            mod_mem = 1'b0;
            mod_reg = 1'b0;
        end
    end
   
   always @(*) begin
        w_en = 1'b0;
        r_en = 1'b0;

        if(prefix == `PREFIX_SSE) begin
            case(opcode)
                `OP_ADDPS, `OP_SUBPS, `OP_MULPS: begin
                    w_en = 1'b1;
                    r_en = 1'b1;
                end
                
                `OP_MOVAPS_LOAD: begin
                    w_en = 1'b1;
                    r_en = 1'b0;
                end
                
                `OP_MOVAPS_STORE: begin
                    w_en = 1'b0;
                    r_en = 1'b1;
                end
                
                default: begin
                    w_en = 1'b0;
                    r_en = 1'b0;
                end
            endcase
        end
    end
endmodule

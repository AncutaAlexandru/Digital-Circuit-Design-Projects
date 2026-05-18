`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2026 12:05:34 PM
// Design Name: 
// Module Name: LANE_ALU
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
63       48 47       16 15       0
+----------+----------+-----------+
| overflow |  result  | precision |
+----------+----------+-----------+
*/
`include "Defines.vh"

module LANE_ALU(
    input [`LANE_RANGE]    data_rs, data_rd,
    input [`ALU_OP_RANGE]      ALU_op,
    output reg [`LANE_RANGE]   data_out     
    );
    
    wire [63:0] result_mult;
    
    assign result_mult = data_rs * data_rd;
    
    always @(*) begin
        if(ALU_op == `ALU_ADD) begin
            data_out = data_rs + data_rd;
        end
        else if(ALU_op == `ALU_SUB) begin
            data_out = data_rd - data_rs;
        end
        else if(ALU_op == `ALU_MUL) begin
            data_out    = result_mult[47:16];
        end
        else begin
            data_out = 32'd0;
        end
    end
    
    
endmodule

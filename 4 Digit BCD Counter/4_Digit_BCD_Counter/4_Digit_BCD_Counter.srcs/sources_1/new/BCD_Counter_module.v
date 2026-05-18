`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2026 04:51:25 PM
// Design Name: 
// Module Name: BCD_Counter_module
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

module BCD_Counter_module (
    input clk,
    input reset,
    input enable,
    output reg [3:0] q);

    always @(posedge clk) begin
        if(reset || (enable && q == 4'd9)) begin
            q <= 4'd0;
        end
        else if(enable) begin
            q <= q+4'd1;
        end
    end

endmodule
module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);

    bcd_mod bcd0 ( clk, reset, 1'd1, q[3:0]);  
    bcd_mod bcd1 ( clk, reset, ena[1], q[7:4]);  
    bcd_mod bcd2 ( clk, reset, ena[2], q[11:8]);  
    bcd_mod bcd3 ( clk, reset, ena[3], q[15:12]);
    
    assign ena[1] = (q[3:0] == 4'd9);
    assign ena[2] = (q[3:0] == 4'd9 && q[7:4] == 4'd9);
    assign ena[3] = (q[3:0] == 4'd9 && q[7:4] == 4'd9 && q[11:8] == 4'd9);
    
endmodule

module bcd_mod (
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

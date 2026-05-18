module BCD_4Digit_Counter (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);

    BCD_Counter_module bcd0 ( clk, reset, 1'd1, q[3:0]);  
    BCD_Counter_module bcd1 ( clk, reset, ena[1], q[7:4]);  
    BCD_Counter_module bcd2 ( clk, reset, ena[2], q[11:8]);  
    BCD_Counter_module bcd3 ( clk, reset, ena[3], q[15:12]);
    
    assign ena[1] = (q[3:0] == 4'd9);
    assign ena[2] = (q[3:0] == 4'd9 && q[7:4] == 4'd9);
    assign ena[3] = (q[3:0] == 4'd9 && q[7:4] == 4'd9 && q[11:8] == 4'd9);
    
endmodule

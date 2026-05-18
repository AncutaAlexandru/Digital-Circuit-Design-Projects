`timescale 1ns / 1ps

module TB_4Digit_BCD_Counter();
    // Use logic for simplicity (SystemVerilog feature)
    logic clk;
    logic reset;
    logic [3:1] ena; // This matches your top_module outputs
    logic [15:0] q;

    // Instantiate your Top Module
    BCD_4Digit_Counter dut (
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .q(q)
    );

    // Generate a 100MHz clock
    initial clk = 0;
    always #5 clk = ~clk;
    
    task perform_reset();
        begin
            @(negedge clk); // Drive signals on the negative edge to avoid race conditions
            reset = 1;
            repeat(2) @(negedge clk); // Wait for 2 clock pulses
            reset = 0;
            if (q !== 16'h0000) $error("Reset Failed! q is %h", q);
            else $display("Reset Successful at %t", $time);
        end
    endtask
    
    task check_pause(input int cycles);
        logic [15:0] captured_value;
        begin
            $display("--- Testing Pause Logic for %0d cycles ---", cycles);
            ena = 1;
            repeat(2) @(negedge clk); // Let it count slightly first
            
            // Capture the value and Disable
            captured_value = q;
            ena = 0; 
            $display("Paused at: %h. Waiting...", captured_value);
            
            // Use the input variable to determine wait length
            repeat(cycles) @(negedge clk);
            
            // Verification
            if (q !== captured_value)
                $error("PAUSE FAILED: Counter moved from %h to %h during %0d cycle pause!", captured_value, q, cycles);
            else
                $display("PAUSE SUCCESS: Counter held %h for %0d cycles", q, cycles);
                
            ena = 1; // Resume counting
            @(negedge clk);
        end
    endtask
    
    task test_rollover(input [15:0] start_val, input [15:0] expected_val);
        begin
            force dut.q = start_val; // Manually set the counter to a boundary
            @(negedge clk);
            release dut.q;           // Let the hardware take over
            @(negedge clk);          // Wait for one increment
            if (q == expected_val) 
                $display("Rollover %h -> %h Passed", start_val, expected_val);
            else 
                $error("Rollover Failed! Expected %h, Got %h", expected_val, q);
        end
    endtask
    
    task check_illegal_recovery();
        begin
            $display("--- Testing Illegal Value Recovery ---");
            // Force the first digit to an illegal 'A' (10)
            force dut.q[3:0] = 4'hA; 
            @(negedge clk);
            release dut.q[3:0];
            
            @(posedge clk); // Hardware processes the 'A'
            #1; // Small offset to read the result
            
            // A good BCD counter should wrap 9->0, so it should treat A as "past 9"
            if (q[3:0] > 9)
                $error("RECOVERY FAILED: Counter stayed at illegal value %h", q[3:0]);
            else
                $display("RECOVERY SUCCESS: Counter returned to valid state %h", q[3:0]);
        end
    endtask
    // Stimulus block
    initial begin
        // Initialize signals
        reset = 0;
        ena = 0;

        // Case 1: Power-on Reset
        perform_reset();

        // Case 2: Standard Counting
        ena = 1;
        #100; // Let it count a few times
//        test_rollover(16'h0009, 16'h0010);
        
//        test_rollover(16'h0099, 16'h0100);
        
//        perform_reset();
//        // Case 3: Edge Case - Triple Rollover (0999 -> 1000)
//        test_rollover(16'h0999, 16'h1000);
        perform_reset();
        wait(q == 16'h1234);
//        check_pause(3);
        
//        wait(q == 16'h1313);
//        check_pause(50);
        
        wait(q == 16'h9999);
//        check_illegal_recovery();
//        // Case 4: Edge Case - Maximum Wrap (9999 -> 0000)
//        test_rollover(16'h9999, 16'h0000);
        // Case 5: Pause Logic
        ena = 0;
//        #50;
//        if (q != q) $error("Counter moved while disabled!"); // Note: check logic here

//        $display("All test cases completed!");
        $finish;
    end
endmodule


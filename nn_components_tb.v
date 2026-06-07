`timescale 1ns/1ps

module nn_components_tb;

    // -------------------------------------------------------
    // Shared signals
    // -------------------------------------------------------
    reg  signed [7:0]  a, b;
    wire signed [7:0]  sat_sum;
    wire signed [15:0] product;
    wire        [7:0]  relu_out;

    // -------------------------------------------------------
    // Instantiate the three modules under test
    // -------------------------------------------------------
    saturated_adder_8bit DUT_ADD (
        .a(a), .b(b), .sum_out(sat_sum)
    );

    multiplier_8bit DUT_MUL (
        .a(a), .b(b), .prod_out(product)
    );

    relu_8bit DUT_RELU (
        .data_in(a), .data_out(relu_out)
    );

    // -------------------------------------------------------
    // Helper task: print one row of results
    // -------------------------------------------------------
    task show;
        input signed [7:0] in_a;
        input signed [7:0] in_b;
        begin
            a = in_a;
            b = in_b;
            #1; // let combinational logic settle
            $display("  a=%4d  b=%4d  |  sat_add=%4d  mul=%6d  relu(a)=%4d",
                      $signed(a), $signed(b),
                      $signed(sat_sum),
                      $signed(product),
                      relu_out);
        end
    endtask

    // -------------------------------------------------------
    // Test vectors
    // -------------------------------------------------------
    initial begin
        $display("=== Saturated Adder / Multiplier / ReLU Testbench ===\n");

        // --- Saturation: positive overflow ---
        $display("-- Positive saturation (result > +127 should clamp to 127) --");
        show(127,   1);   // 127+1  → should be  127
        show(100,  50);   // 100+50 → should be  127
        show( 64,  64);   //  64+64 → should be  127

        // --- Saturation: negative overflow ---
        $display("\n-- Negative saturation (result < -128 should clamp to -128) --");
        show(-128,  -1);  // -128-1 → should be -128
        show(-100, -50);  // -150   → should be -128
        show( -64, -65);  // -129   → should be -128

        // --- No overflow ---
        $display("\n-- Normal addition (no saturation) --");
        show(  10,  20);  //  30
        show( -10,  10);  //   0
        show(  50, -20);  //  30

        // --- Multiplier: basic cases ---
        $display("\n-- Multiplier edge cases --");
        show(  10,  10);  //  100
        show( -10,  10);  // -100
        show( -10, -10);  //  100
        show( 127, 127);  //  16129
        show(-128,-128);  //  16384

        // --- ReLU: positive, zero, negative ---
        $display("\n-- ReLU (only depends on a) --");
        show(   5,  0);   // positive → 5
        show(   0,  0);   // zero     → 0
        show(  -1,  0);   // negative → 0
        show(-128,  0);   // min negative → 0
        show( 127,  0);   // max positive → 127

        $display("\n=== Done ===");
        $finish;
    end

endmodule
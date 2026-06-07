// 8-bit Signed Saturated Adder
module saturated_adder_8bit (
    input  signed [7:0] a,
    input  signed [7:0] b,
    output reg signed [7:0] sum_out
);
    // Use 9 bits to catch overflow before clamping
    wire signed [8:0] full_sum = a + b;

    always @(*) begin
        if (full_sum > 9'sd127)  sum_out = 8'sd127;   // Positive overflow → clamp to +127
        else if (full_sum < -9'sd128) sum_out = -8'sd128;  // Negative overflow → clamp to -128
        else sum_out = full_sum[7:0]; // No overflow → pass through
    end
endmodule

// 8-bit Signed Multiplier
module multiplier_8bit (
    input  signed [7:0]  a,
    input  signed [7:0]  b,
    output reg signed [15:0] prod_out
);
    always @(*) prod_out = a * b;
endmodule

// Rectified Linear Unit (ReLU)
module relu_8bit (
    input  signed [7:0] data_in,
    output        [7:0] data_out
);
    assign data_out = (data_in[7] == 1'b1) ? 8'b0 : data_in;
endmodule
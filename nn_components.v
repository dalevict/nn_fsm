// ============================================================
// nn_components.v
// Mushroom classifier — fully combinational (no clock)
// Weights in Q3.5 format (real_value = stored_int / 32)
// ============================================================


// ------------------------------------------------------------
// Primitive: 8-bit Signed Saturated Adder
// ------------------------------------------------------------
module saturated_adder_8bit (
    input  signed [7:0] a,
    input  signed [7:0] b,
    output reg signed [7:0] sum_out
);
    wire signed [8:0] full_sum = a + b;
    always @(*) begin
        if (full_sum > 9'sd127) sum_out = 8'sd127;
        else if (full_sum < -9'sd128) sum_out = -8'sd128;
        else sum_out = full_sum[7:0];
    end
endmodule


// ------------------------------------------------------------
// Primitive: 8-bit Signed Multiplier -> 16-bit result
// ------------------------------------------------------------
module multiplier_8bit (
    input  signed [7:0] a,
    input  signed [7:0] b,
    output reg signed [15:0] prod_out
);
    always @(*) prod_out = a * b;
endmodule


// ------------------------------------------------------------
// Primitive: ReLU  (pass-through if >= 0, else 0)
// ------------------------------------------------------------
module relu_8bit (
    input  signed [7:0] data_in,
    output [7:0] data_out
);
    assign data_out = (data_in[7] == 1'b1) ? 8'b0 : data_in;
endmodule


// ------------------------------------------------------------
// Neuron  (parameterized -- weights baked in at instantiation)
//
// Parameters
//   N_INPUTS   : number of input connections
//   USE_RELU   : 1 = apply ReLU after bias add, 0 = raw sum
//        aka   : 1 = hidden neuron, 0 = output neuron
//
// Datapath (all combinational):
//   1. Multiply each input by its weight  -> 16-bit products
//   2. Accumulate all products + bias      -> 32-bit accumulator
//   3. Arithmetic-right-shift by 5 (div32) -> undo Q3.5 scaling
//   4. Saturate to 8 bits
//   5. Optionally apply ReLU
//
// Why 32-bit accumulator?
//   Worst case: 117 inputs x (+-127) x (+-127) ~= +-1.9 million
//   fits in 22 bits signed, so 32 bits gives plenty of headroom.
// ------------------------------------------------------------
module neuron #(
    parameter integer N_INPUTS = 117,
    parameter integer USE_RELU = 1
)(
    input signed [7:0] inputs [0:N_INPUTS-1],
    input signed [7:0] weights[0:N_INPUTS-1],
    input signed [7:0] bias,
    output signed [7:0] activation
);
    integer i;
    reg signed [31:0] accumulator;
    always @(*) begin
        accumulator = 32'(signed'(bias)); // Treat the bias as signed 2's complement number, extend to 32 bits keeping sign
        for (i = 0; i < N_INPUTS; i = i + 1)
            accumulator = accumulator + (32'(signed'(inputs[i])) * 32'(signed'(weights[i])));
    end

    wire signed [31:0] acc_scaled = accumulator >>> 5; // Divide by 32

    
    wire signed [7:0] saturated;
    assign saturated = (acc_scaled >  32'sd127) ?  8'sd127 : // Saturate 32-bit to 8-bit
                       (acc_scaled < -32'sd128) ? -8'sd128 :
                        acc_scaled[7:0];

    // ReLU only for hidden neurons
    generate
        if (USE_RELU)
            assign activation = (saturated[7] == 1'b1) ? 8'b0 : saturated;
        else
            assign activation = saturated;
    endgenerate

endmodule
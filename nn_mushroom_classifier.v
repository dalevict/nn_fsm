
// ------------------------------------------------------------
// Mushroom Classifier  (top-level combinational network)
//
// Architecture:
//   117 inputs -> [4 hidden neurons w/ ReLU] -> [1 output neuron]
//   Output: 1 = poisonous, 0 = edible
//   Decision: output neuron pre-activation > 0 (sigmoid > 0.5)
// ------------------------------------------------------------
module mushroom_classifier (
    input  [116:0] features,
    output poisonous
);
    wire signed [7:0] inp [0:116];
    genvar k;
    generate
        for (k = 0; k < 117; k = k + 1)
            assign inp[k] = features[k] ? 8'sd1 : 8'sd0; // Unpack 1-bit features into signed 8-bit (0 or 1)
    endgenerate

    // ----------------------------------------------------------
    // Layer 1 weights (Q3.5)
    // ----------------------------------------------------------

    wire signed [7:0] w0 [0:116];
    assign w0[0]=8'sd7;    assign w0[1]=8'sd51;   assign w0[2]=8'sd10;   assign w0[3]=8'sd8;
    assign w0[4]=-8'sd33;  assign w0[5]=8'sd6;    assign w0[6]=-8'sd11;  assign w0[7]=8'sd52;
    assign w0[8]=8'sd19;   assign w0[9]=8'sd10;   assign w0[10]=8'sd33;  assign w0[11]=-8'sd38;
    assign w0[12]=8'sd13;  assign w0[13]=8'sd4;   assign w0[14]=8'sd3;   assign w0[15]=8'sd10;
    assign w0[16]=-8'sd36; assign w0[17]=-8'sd38; assign w0[18]=8'sd10;  assign w0[19]=-8'sd2;
    assign w0[20]=8'sd7;   assign w0[21]=8'sd3;   assign w0[22]=-8'sd20; assign w0[23]=8'sd46;
    assign w0[24]=8'sd26;  assign w0[25]=-8'sd20; assign w0[26]=8'sd28;  assign w0[27]=-8'sd21;
    assign w0[28]=8'sd35;  assign w0[29]=8'sd20;  assign w0[30]=8'sd17;  assign w0[31]=-8'sd6;
    assign w0[32]=8'sd5;   assign w0[33]=8'sd20;  assign w0[34]=-8'sd15; assign w0[35]=-8'sd8;
    assign w0[36]=8'sd22;  assign w0[37]=8'sd16;  assign w0[38]=-8'sd17; assign w0[39]=-8'sd22;
    assign w0[40]=8'sd8;   assign w0[41]=-8'sd10; assign w0[42]=-8'sd4;  assign w0[43]=-8'sd24;
    assign w0[44]=-8'sd7;  assign w0[45]=8'sd33;  assign w0[46]=-8'sd2;  assign w0[47]=-8'sd5;
    assign w0[48]=8'sd20;  assign w0[49]=8'sd4;   assign w0[50]=8'sd9;   assign w0[51]=8'sd9;
    assign w0[52]=8'sd17;  assign w0[53]=-8'sd14; assign w0[54]=-8'sd13; assign w0[55]=-8'sd12;
    assign w0[56]=-8'sd9;  assign w0[57]=8'sd16;  assign w0[58]=-8'sd4;  assign w0[59]=-8'sd3;
    assign w0[60]=-8'sd21; assign w0[61]=8'sd15;  assign w0[62]=8'sd4;   assign w0[63]=8'sd25;
    assign w0[64]=8'sd19;  assign w0[65]=8'sd30;  assign w0[66]=-8'sd19; assign w0[67]=-8'sd12;
    assign w0[68]=8'sd16;  assign w0[69]=-8'sd29; assign w0[70]=8'sd17;  assign w0[71]=8'sd7;
    assign w0[72]=8'sd51;  assign w0[73]=8'sd21;  assign w0[74]=8'sd27;  assign w0[75]=-8'sd18;
    assign w0[76]=-8'sd9;  assign w0[77]=-8'sd6;  assign w0[78]=-8'sd26; assign w0[79]=8'sd16;
    assign w0[80]=8'sd12;  assign w0[81]=8'sd49;  assign w0[82]=8'sd7;   assign w0[83]=-8'sd26;
    assign w0[84]=-8'sd27; assign w0[85]=8'sd9;   assign w0[86]=8'sd51;  assign w0[87]=8'sd29;
    assign w0[88]=8'sd13;  assign w0[89]=-8'sd22; assign w0[90]=8'sd14;  assign w0[91]=-8'sd50;
    assign w0[92]=8'sd23;  assign w0[93]=8'sd29;  assign w0[94]=-8'sd2;  assign w0[95]=-8'sd25;
    assign w0[96]=8'sd21;  assign w0[97]=-8'sd9;  assign w0[98]=-8'sd9;  assign w0[99]=-8'sd22;
    assign w0[100]=8'sd51; assign w0[101]=-8'sd29;assign w0[102]=8'sd12; assign w0[103]=-8'sd24;
    assign w0[104]=-8'sd10;assign w0[105]=8'sd23; assign w0[106]=-8'sd16;assign w0[107]=8'sd9;
    assign w0[108]=8'sd16; assign w0[109]=-8'sd15;assign w0[110]=8'sd4;  assign w0[111]=8'sd0;
    assign w0[112]=8'sd10; assign w0[113]=8'sd7;  assign w0[114]=8'sd9;  assign w0[115]=8'sd5;
    assign w0[116]=-8'sd19;

    wire signed [7:0] w1 [0:116];
    assign w1[0]=8'sd15;   assign w1[1]=8'sd50;   assign w1[2]=8'sd11;   assign w1[3]=8'sd1;
    assign w1[4]=-8'sd42;  assign w1[5]=8'sd6;    assign w1[6]=-8'sd11;  assign w1[7]=8'sd52;
    assign w1[8]=8'sd11;   assign w1[9]=8'sd12;   assign w1[10]=8'sd42;  assign w1[11]=-8'sd42;
    assign w1[12]=8'sd3;   assign w1[13]=8'sd9;   assign w1[14]=-8'sd7;  assign w1[15]=8'sd18;
    assign w1[16]=-8'sd38; assign w1[17]=-8'sd41; assign w1[18]=8'sd25;  assign w1[19]=8'sd12;
    assign w1[20]=8'sd3;   assign w1[21]=8'sd8;   assign w1[22]=-8'sd47; assign w1[23]=8'sd54;
    assign w1[24]=8'sd27;  assign w1[25]=-8'sd46; assign w1[26]=8'sd31;  assign w1[27]=-8'sd36;
    assign w1[28]=8'sd43;  assign w1[29]=8'sd22;  assign w1[30]=8'sd22;  assign w1[31]=-8'sd21;
    assign w1[32]=8'sd10;  assign w1[33]=8'sd18;  assign w1[34]=-8'sd31; assign w1[35]=-8'sd19;
    assign w1[36]=8'sd28;  assign w1[37]=8'sd23;  assign w1[38]=-8'sd26; assign w1[39]=-8'sd6;
    assign w1[40]=8'sd4;   assign w1[41]=-8'sd14; assign w1[42]=-8'sd7;  assign w1[43]=-8'sd23;
    assign w1[44]=8'sd1;   assign w1[45]=8'sd40;  assign w1[46]=-8'sd3;  assign w1[47]=-8'sd4;
    assign w1[48]=-8'sd4;  assign w1[49]=8'sd17;  assign w1[50]=-8'sd3;  assign w1[51]=8'sd0;
    assign w1[52]=8'sd27;  assign w1[53]=-8'sd32; assign w1[54]=8'sd1;   assign w1[55]=-8'sd29;
    assign w1[56]=-8'sd20; assign w1[57]=8'sd21;  assign w1[58]=-8'sd8;  assign w1[59]=-8'sd3;
    assign w1[60]=-8'sd38; assign w1[61]=8'sd15;  assign w1[62]=8'sd1;   assign w1[63]=8'sd25;
    assign w1[64]=8'sd21;  assign w1[65]=8'sd30;  assign w1[66]=-8'sd25; assign w1[67]=-8'sd21;
    assign w1[68]=8'sd19;  assign w1[69]=-8'sd23; assign w1[70]=8'sd6;   assign w1[71]=8'sd12;
    assign w1[72]=8'sd51;  assign w1[73]=8'sd22;  assign w1[74]=8'sd32;  assign w1[75]=-8'sd28;
    assign w1[76]=-8'sd22; assign w1[77]=8'sd0;   assign w1[78]=-8'sd26; assign w1[79]=8'sd6;
    assign w1[80]=8'sd15;  assign w1[81]=8'sd50;  assign w1[82]=8'sd6;   assign w1[83]=-8'sd21;
    assign w1[84]=-8'sd21; assign w1[85]=8'sd9;   assign w1[86]=8'sd48;  assign w1[87]=8'sd29;
    assign w1[88]=8'sd18;  assign w1[89]=-8'sd40; assign w1[90]=8'sd4;   assign w1[91]=-8'sd54;
    assign w1[92]=8'sd23;  assign w1[93]=8'sd29;  assign w1[94]=8'sd3;   assign w1[95]=-8'sd23;
    assign w1[96]=8'sd23;  assign w1[97]=-8'sd22; assign w1[98]=-8'sd23; assign w1[99]=-8'sd25;
    assign w1[100]=8'sd51; assign w1[101]=-8'sd54;assign w1[102]=8'sd2;  assign w1[103]=-8'sd22;
    assign w1[104]=-8'sd25;assign w1[105]=8'sd27; assign w1[106]=-8'sd29;assign w1[107]=8'sd27;
    assign w1[108]=8'sd11; assign w1[109]=-8'sd21;assign w1[110]=8'sd3;  assign w1[111]=8'sd30;
    assign w1[112]=8'sd9;  assign w1[113]=8'sd15; assign w1[114]=8'sd5;  assign w1[115]=8'sd10;
    assign w1[116]=-8'sd29;

    wire signed [7:0] w2 [0:116];
    assign w2[0]=8'sd3;    assign w2[1]=8'sd55;   assign w2[2]=8'sd9;    assign w2[3]=8'sd3;
    assign w2[4]=-8'sd45;  assign w2[5]=8'sd7;    assign w2[6]=-8'sd13;  assign w2[7]=8'sd61;
    assign w2[8]=8'sd19;   assign w2[9]=8'sd14;   assign w2[10]=8'sd39;  assign w2[11]=-8'sd41;
    assign w2[12]=8'sd4;   assign w2[13]=8'sd8;   assign w2[14]=-8'sd13; assign w2[15]=8'sd23;
    assign w2[16]=-8'sd45; assign w2[17]=-8'sd42; assign w2[18]=8'sd17;  assign w2[19]=8'sd10;
    assign w2[20]=8'sd8;   assign w2[21]=8'sd1;   assign w2[22]=-8'sd32; assign w2[23]=8'sd46;
    assign w2[24]=8'sd25;  assign w2[25]=-8'sd33; assign w2[26]=8'sd32;  assign w2[27]=-8'sd32;
    assign w2[28]=8'sd38;  assign w2[29]=8'sd18;  assign w2[30]=8'sd18;  assign w2[31]=-8'sd22;
    assign w2[32]=8'sd14;  assign w2[33]=8'sd23;  assign w2[34]=-8'sd22; assign w2[35]=-8'sd25;
    assign w2[36]=8'sd24;  assign w2[37]=8'sd16;  assign w2[38]=-8'sd28; assign w2[39]=8'sd4;
    assign w2[40]=8'sd12;  assign w2[41]=-8'sd13; assign w2[42]=-8'sd14; assign w2[43]=-8'sd21;
    assign w2[44]=-8'sd4;  assign w2[45]=8'sd43;  assign w2[46]=-8'sd9;  assign w2[47]=-8'sd12;
    assign w2[48]=-8'sd6;  assign w2[49]=8'sd22;  assign w2[50]=-8'sd5;  assign w2[51]=8'sd1;
    assign w2[52]=8'sd29;  assign w2[53]=-8'sd27; assign w2[54]=-8'sd12; assign w2[55]=-8'sd27;
    assign w2[56]=-8'sd14; assign w2[57]=8'sd19;  assign w2[58]=-8'sd15; assign w2[59]=-8'sd6;
    assign w2[60]=-8'sd29; assign w2[61]=8'sd15;  assign w2[62]=-8'sd7;  assign w2[63]=8'sd13;
    assign w2[64]=8'sd19;  assign w2[65]=8'sd27;  assign w2[66]=-8'sd28; assign w2[67]=-8'sd19;
    assign w2[68]=8'sd16;  assign w2[69]=-8'sd20; assign w2[70]=8'sd13;  assign w2[71]=8'sd4;
    assign w2[72]=8'sd50;  assign w2[73]=8'sd18;  assign w2[74]=8'sd28;  assign w2[75]=-8'sd25;
    assign w2[76]=-8'sd24; assign w2[77]=8'sd1;   assign w2[78]=-8'sd25; assign w2[79]=8'sd10;
    assign w2[80]=8'sd8;   assign w2[81]=8'sd50;  assign w2[82]=8'sd14;  assign w2[83]=-8'sd23;
    assign w2[84]=-8'sd25; assign w2[85]=8'sd11;  assign w2[86]=8'sd52;  assign w2[87]=8'sd27;
    assign w2[88]=8'sd20;  assign w2[89]=-8'sd33; assign w2[90]=8'sd8;   assign w2[91]=-8'sd55;
    assign w2[92]=8'sd21;  assign w2[93]=8'sd28;  assign w2[94]=-8'sd5;  assign w2[95]=-8'sd22;
    assign w2[96]=8'sd21;  assign w2[97]=-8'sd21; assign w2[98]=-8'sd22; assign w2[99]=-8'sd22;
    assign w2[100]=8'sd54; assign w2[101]=-8'sd42;assign w2[102]=8'sd3;  assign w2[103]=-8'sd23;
    assign w2[104]=-8'sd22;assign w2[105]=8'sd7;  assign w2[106]=-8'sd25;assign w2[107]=8'sd13;
    assign w2[108]=8'sd15; assign w2[109]=-8'sd22;assign w2[110]=8'sd0;  assign w2[111]=8'sd7;
    assign w2[112]=8'sd10; assign w2[113]=8'sd6;  assign w2[114]=8'sd7;  assign w2[115]=8'sd13;
    assign w2[116]=-8'sd25;

    wire signed [7:0] w3 [0:116];
    assign w3[0]=8'sd3;    assign w3[1]=-8'sd54;  assign w3[2]=8'sd27;   assign w3[3]=8'sd20;
    assign w3[4]=8'sd45;   assign w3[5]=8'sd24;   assign w3[6]=8'sd21;   assign w3[7]=-8'sd59;
    assign w3[8]=-8'sd8;   assign w3[9]=8'sd12;   assign w3[10]=-8'sd36; assign w3[11]=8'sd41;
    assign w3[12]=8'sd24;  assign w3[13]=8'sd16;  assign w3[14]=8'sd32;  assign w3[15]=-8'sd15;
    assign w3[16]=8'sd46;  assign w3[17]=8'sd46;  assign w3[18]=-8'sd11; assign w3[19]=8'sd16;
    assign w3[20]=8'sd12;  assign w3[21]=8'sd8;   assign w3[22]=8'sd35;  assign w3[23]=-8'sd51;
    assign w3[24]=-8'sd26; assign w3[25]=8'sd37;  assign w3[26]=-8'sd29; assign w3[27]=8'sd33;
    assign w3[28]=-8'sd39; assign w3[29]=-8'sd19; assign w3[30]=-8'sd21; assign w3[31]=8'sd25;
    assign w3[32]=8'sd26;  assign w3[33]=-8'sd10; assign w3[34]=8'sd30;  assign w3[35]=8'sd27;
    assign w3[36]=-8'sd27; assign w3[37]=-8'sd20; assign w3[38]=8'sd30;  assign w3[39]=8'sd13;
    assign w3[40]=8'sd4;   assign w3[41]=8'sd17;  assign w3[42]=8'sd16;  assign w3[43]=8'sd26;
    assign w3[44]=8'sd28;  assign w3[45]=-8'sd40; assign w3[46]=8'sd16;  assign w3[47]=8'sd14;
    assign w3[48]=8'sd14;  assign w3[49]=-8'sd10; assign w3[50]=8'sd28;  assign w3[51]=8'sd21;
    assign w3[52]=-8'sd33; assign w3[53]=8'sd33;  assign w3[54]=8'sd20;  assign w3[55]=8'sd27;
    assign w3[56]=8'sd22;  assign w3[57]=-8'sd16; assign w3[58]=8'sd19;  assign w3[59]=8'sd13;
    assign w3[60]=8'sd36;  assign w3[61]=-8'sd11; assign w3[62]=8'sd19;  assign w3[63]=-8'sd15;
    assign w3[64]=-8'sd16; assign w3[65]=-8'sd31; assign w3[66]=8'sd28;  assign w3[67]=8'sd26;
    assign w3[68]=-8'sd14; assign w3[69]=8'sd24;  assign w3[70]=8'sd13;  assign w3[71]=8'sd16;
    assign w3[72]=-8'sd52; assign w3[73]=-8'sd17; assign w3[74]=-8'sd31; assign w3[75]=8'sd26;
    assign w3[76]=8'sd23;  assign w3[77]=8'sd8;   assign w3[78]=8'sd27;  assign w3[79]=8'sd5;
    assign w3[80]=8'sd6;   assign w3[81]=-8'sd49; assign w3[82]=8'sd25;  assign w3[83]=8'sd27;
    assign w3[84]=8'sd25;  assign w3[85]=8'sd28;  assign w3[86]=-8'sd53; assign w3[87]=-8'sd32;
    assign w3[88]=8'sd18;  assign w3[89]=8'sd34;  assign w3[90]=8'sd20;  assign w3[91]=8'sd53;
    assign w3[92]=-8'sd16; assign w3[93]=-8'sd34; assign w3[94]=8'sd13;  assign w3[95]=8'sd25;
    assign w3[96]=-8'sd22; assign w3[97]=8'sd22;  assign w3[98]=8'sd22;  assign w3[99]=8'sd28;
    assign w3[100]=-8'sd53;assign w3[101]=8'sd44; assign w3[102]=8'sd12; assign w3[103]=8'sd24;
    assign w3[104]=8'sd25; assign w3[105]=-8'sd2; assign w3[106]=8'sd32; assign w3[107]=-8'sd11;
    assign w3[108]=-8'sd10;assign w3[109]=8'sd34; assign w3[110]=8'sd18; assign w3[111]=8'sd4;
    assign w3[112]=8'sd5;  assign w3[113]=-8'sd2; assign w3[114]=8'sd4;  assign w3[115]=-8'sd15;
    assign w3[116]=8'sd26;

    // Layer 1 biases
    wire signed [7:0] b_h0 = 8'sd9;
    wire signed [7:0] b_h1 = 8'sd7;
    wire signed [7:0] b_h2 = 8'sd12;
    wire signed [7:0] b_h3 = 8'sd27;

    // ----------------------------------------------------------
    // Layer 1: 4 hidden neurons with ReLU
    // ----------------------------------------------------------
    wire signed [7:0] h [0:3];

    neuron #(.N_INPUTS(117), .USE_RELU(1)) hidden0 (
        .inputs(inp), .weights(w0), .bias(b_h0), .activation(h[0])
    );
    neuron #(.N_INPUTS(117), .USE_RELU(1)) hidden1 (
        .inputs(inp), .weights(w1), .bias(b_h1), .activation(h[1])
    );
    neuron #(.N_INPUTS(117), .USE_RELU(1)) hidden2 (
        .inputs(inp), .weights(w2), .bias(b_h2), .activation(h[2])
    );
    neuron #(.N_INPUTS(117), .USE_RELU(1)) hidden3 (
        .inputs(inp), .weights(w3), .bias(b_h3), .activation(h[3])
    );

    // ----------------------------------------------------------
    // Layer 2 weights and bias
    // ----------------------------------------------------------
    wire signed [7:0] w_out [0:3];
    assign w_out[0] =  8'sd28;
    assign w_out[1] =  8'sd32;
    assign w_out[2] =  8'sd35;
    assign w_out[3] = -8'sd44;

    wire signed [7:0] b_out = -8'sd2;

    // ----------------------------------------------------------
    // Layer 2: single output neuron (no ReLU)
    // ----------------------------------------------------------
    wire signed [7:0] out_act;

    neuron #(.N_INPUTS(4), .USE_RELU(0)) output_neuron (
        .inputs(h), .weights(w_out), .bias(b_out), .activation(out_act)
    );

    // ----------------------------------------------------------
    // Decision: sigmoid(x) > 0.5  iff  x > 0
    // poisonous=1 when output is positive (sign bit=0, non-zero)
    // ----------------------------------------------------------
    assign poisonous = ~out_act[7] && (out_act != 8'b0);

endmodule
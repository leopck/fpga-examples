module rps_nn_ai (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [1:0]  your_last,
    output logic [1:0]  ai_move
);

    logic [1:0] ai_prev;

    // Input layer (1-hot encoding for you and AI's last moves)
    real i0, i1, i2, i3;
    // Hidden layer neurons
    real h0, h1, h2;
    // Output layer neurons
    real o0, o1, o2;
    real max_val;
    int  max_idx;

    // Weights and biases for input → hidden
    real W1_0_0, W1_0_1, W1_0_2, W1_0_3, B1_0;
    real W1_1_0, W1_1_1, W1_1_2, W1_1_3, B1_1;
    real W1_2_0, W1_2_1, W1_2_2, W1_2_3, B1_2;

    // Weights and biases for hidden → output
    real W2_0_0, W2_0_1, W2_0_2, B2_0;
    real W2_1_0, W2_1_1, W2_1_2, B2_1;
    real W2_2_0, W2_2_1, W2_2_2, B2_2;

    initial begin
        // Input → Hidden weights
        W1_0_0 = 1.0; W1_0_1 = -1.0; W1_0_2 = 0.5; W1_0_3 = 0.2; B1_0 = 0.2;
        W1_1_0 = -0.5; W1_1_1 = 1.5; W1_1_2 = -1.0; W1_1_3 = 0.3; B1_1 = 0.1;
        W1_2_0 = 0.8; W1_2_1 = 0.8; W1_2_2 = 0.8; W1_2_3 = 0.1; B1_2 = -0.3;

        // Hidden → Output weights
        W2_0_0 = 1.2; W2_0_1 = -1.0; W2_0_2 = 0.5; B2_0 = 0.1;
        W2_1_0 = -0.4; W2_1_1 = 1.0; W2_1_2 = -0.7; B2_1 = -0.2;
        W2_2_0 = 0.3; W2_2_1 = 0.2; W2_2_2 = 1.5; B2_2 = 0.0;
    end

    // Neural net logic
    always_comb begin
        // One-hot encode inputs
        i0 = (your_last == 0) ? 1.0 : 0.0;
        i1 = (your_last == 1) ? 1.0 : 0.0;
        i2 = (ai_prev   == 0) ? 1.0 : 0.0;
        i3 = (ai_prev   == 1) ? 1.0 : 0.0;

        // Hidden layer
        h0 = W1_0_0 * i0 + W1_0_1 * i1 + W1_0_2 * i2 + W1_0_3 * i3 + B1_0;
        h1 = W1_1_0 * i0 + W1_1_1 * i1 + W1_1_2 * i2 + W1_1_3 * i3 + B1_1;
        h2 = W1_2_0 * i0 + W1_2_1 * i1 + W1_2_2 * i2 + W1_2_3 * i3 + B1_2;

        // ReLU activation
        if (h0 < 0) h0 = 0;
        if (h1 < 0) h1 = 0;
        if (h2 < 0) h2 = 0;

        // Output layer
        o0 = W2_0_0 * h0 + W2_0_1 * h1 + W2_0_2 * h2 + B2_0;
        o1 = W2_1_0 * h0 + W2_1_1 * h1 + W2_1_2 * h2 + B2_1;
        o2 = W2_2_0 * h0 + W2_2_1 * h1 + W2_2_2 * h2 + B2_2;

        // Argmax to get AI move
        max_val = o0;
        max_idx = 0;
        if (o1 > max_val) begin max_val = o1; max_idx = 1; end
        if (o2 > max_val) begin max_val = o2; max_idx = 2; end

        ai_move = max_idx[1:0];
    end

    // Store AI move for next round
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ai_prev <= 0;
        else
            ai_prev <= ai_move;
    end

endmodule

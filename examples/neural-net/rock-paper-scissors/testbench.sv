module tb_rps_nn_ai;

    logic clk = 0;
    logic rst_n = 0;
    logic [1:0] your_last;
    logic [1:0] ai_move;

    rps_nn_ai dut (
        .clk(clk),
        .rst_n(rst_n),
        .your_last(your_last),
        .ai_move(ai_move)
    );

    // Clock generation
    always #1 clk = ~clk;

    // Pretty print move
    task print_move(input [1:0] val);
        case (val)
            0: $write("Rock");
            1: $write("Paper");
            2: $write("Scissors");
            default: $write("???");
        endcase
    endtask

    // Play one round
    task play_round(input [1:0] your_m);
        begin
            your_last = your_m;
            @(posedge clk);
            #0.1;
            $write("You: "); print_move(your_last);
            $write(" | AI: "); print_move(ai_move);
            if (ai_move == (your_last + 1) % 3)
                $display(" → AI Wins");
            else if (ai_move == your_last)
                $display(" → Draw");
            else
                $display(" → You Win");
        end
    endtask

    initial begin
        $display("🤖 Rock–Paper–Scissors Neural Net AI");

        // Reset
        rst_n = 0; @(posedge clk);
        rst_n = 1; @(posedge clk);

        // Play a few rounds (just your input!)
        play_round(0); // Rock
        play_round(1); // Paper
        play_round(1); // Paper
        play_round(2); // Scissors
        play_round(0); // Rock
        play_round(2); // Scissors
        play_round(2); // Scissors
        play_round(1); // Paper

        $finish;
    end
endmodule

module traffic_light_or (
    input  logic clk,
    input  logic reset_n,
    input  logic [3:0] car_count_NS,
    input  logic [3:0] car_count_EW,
    input  logic timer_done,
    output logic green_NS,
    output logic green_EW
);

    typedef enum logic [1:0] {
        IDLE,
        GREEN_NS,
        GREEN_EW
    } state_t;

    state_t state, next_state;
    logic [3:0] wait_age_NS, wait_age_EW;

    // Minimum green time counter
    logic [3:0] green_timer;

    // FSM state register
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            green_timer <= 0;
            wait_age_NS <= 0;
            wait_age_EW <= 0;
        end else begin
            state <= next_state;

            // Only age directions not getting green
            if (state == GREEN_NS) begin
                green_timer <= (timer_done) ? 0 : green_timer + 1;
                wait_age_NS <= 0;
                wait_age_EW <= wait_age_EW + 1;
            end else if (state == GREEN_EW) begin
                green_timer <= (timer_done) ? 0 : green_timer + 1;
                wait_age_NS <= wait_age_NS + 1;
                wait_age_EW <= 0;
            end else begin
                wait_age_NS <= wait_age_NS + 1;
                wait_age_EW <= wait_age_EW + 1;
                green_timer <= 0;
            end
        end
    end

    // Output logic
    assign green_NS = (state == GREEN_NS);
    assign green_EW = (state == GREEN_EW);

    // Score calculation
    logic [4:0] score_NS, score_EW;
    assign score_NS = car_count_NS + wait_age_NS;
    assign score_EW = car_count_EW + wait_age_EW;

    // FSM transition logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (score_NS > score_EW)
                    next_state = GREEN_NS;
                else if (score_EW > score_NS)
                    next_state = GREEN_EW;
                else
                    next_state = GREEN_NS; // fair bias
            end
            GREEN_NS: begin
                if (timer_done)
                    next_state = IDLE;
            end
            GREEN_EW: begin
                if (timer_done)
                    next_state = IDLE;
            end
        endcase
    end

endmodule

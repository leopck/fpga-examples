module tb_traffic_light_or;

    logic clk = 0;
    logic reset_n = 0;
    logic [3:0] car_count_NS = 0;
    logic [3:0] car_count_EW = 0;
    logic timer_done = 0;
    logic green_NS, green_EW;

    // Instantiate DUT
    traffic_light_or dut (
        .clk(clk),
        .reset_n(reset_n),
        .car_count_NS(car_count_NS),
        .car_count_EW(car_count_EW),
        .timer_done(timer_done),
        .green_NS(green_NS),
        .green_EW(green_EW)
    );

    // Clock
    always #10 clk = ~clk; // 50MHz clock

    // Simulated timer
    always begin
        #100 timer_done = 1;  // green cycle lasts 100ns
        #20  timer_done = 0;
    end

    // Car arrival + departure simulation
    always @(posedge clk) begin
        // Simulate car arrivals randomly
        if ($urandom_range(0, 3) == 0 && car_count_NS < 15)
            car_count_NS <= car_count_NS + 1;
        if ($urandom_range(0, 3) == 0 && car_count_EW < 15)
            car_count_EW <= car_count_EW + 1;

        // Simulate cars passing while green
        if (green_NS && car_count_NS > 0)
            car_count_NS <= car_count_NS - 1;
        if (green_EW && car_count_EW > 0)
            car_count_EW <= car_count_EW - 1;
    end

    // Print output state every clock
    always @(posedge clk) begin
        $display("[%0t ns] NS=%0d EW=%0d | Green_NS=%b Green_EW=%b | Score_NS=%0d Score_EW=%0d",
                 $time, car_count_NS, car_count_EW, green_NS, green_EW,
                 car_count_NS + dut.wait_age_NS, car_count_EW + dut.wait_age_EW);
    end

    initial begin
        reset_n = 0;
        #25 reset_n = 1;

        // Simulate for 2000ns
        #2000 $finish;
    end

endmodule

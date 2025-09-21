module single_random_number(
    input wire clk,
    input wire generate_btn,
    output reg [7:0] random_num
);

    reg [31:0] counter = 0;
    reg generate_btn_d;

    always @(posedge clk) begin
        counter <= counter + 1;
        generate_btn_d <= generate_btn;

        // rising-edge detection
        if (generate_btn & ~generate_btn_d) begin
            // Random number from 1 to 99
            random_num <= (counter % 99) + 1;
        end
    end
endmodule

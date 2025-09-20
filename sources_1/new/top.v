// top.v
module top(
    input  wire clk100,      // 100 MHz clock
    input  wire ps2_clk,     // keyboard PS/2 clock
    input  wire ps2_data,    // keyboard PS/2 data
    output wire [6:0] a_to_g,// seven segment segments a-g
    output wire [7:0] an,    // anodes
    output wire dp           // decimal point
);
    wire [7:0] scan_code;
    wire new_code;
    reg [3:0] digit, prev_digit;

    // PS/2 receiver
    ps2_rx ps2 (
        .clk(clk100),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .scan_code(scan_code),
        .new_code(new_code)
    );

    // Translate scan codes for 1-9
    always @(posedge clk100) begin
        if (new_code) begin
            case (scan_code)
                8'h16: digit <= 4'd1; // '1'
                8'h1E: digit <= 4'd2; // '2'
                8'h26: digit <= 4'd3; // '3'
                8'h25: digit <= 4'd4; // '4'
                8'h2E: digit <= 4'd5; // '5'
                8'h36: digit <= 4'd6; // '6'
                8'h3D: digit <= 4'd7; // '7'
                8'h3E: digit <= 4'd8; // '8'
                8'h46: digit <= 4'd9; // '9'
                default: digit <= prev_digit; // ignore others
            endcase
            prev_digit <= digit;
        end
    end

    // Display on both an0 and an1
    sevenseg_driver disp (
        .clk(clk100),
        .digit(digit),
        .a_to_g(a_to_g),
        .an(an),
        .dp(dp)
    );
endmodule

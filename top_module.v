`timescale 1ns / 1ps

module top_module(
    input  wire clk,             // 100 MHz clock from board
    output wire [6:0] a_to_g,    // 7-seg segment pins
    output reg  [7:0] an,        // 7-seg digit enable pins
    output wire dp               // decimal point
);
    wire [7:0] plain, cipher;

    // Instantiate RSA encryption (still hardcoded "H"=72)
    rsa_encrypt RSA1(
        .clk(clk),
        .plain(plain),
        .cipher(cipher)
    );

    // Clock divider for multiplexing
    reg [16:0] div;
    always @(posedge clk) div <= div + 1;
    wire sel = div[16]; // toggles ~763 Hz (fast enough to appear constant)

    // Choose which nibble to display
    wire [3:0] nib = sel ? cipher[7:4] : cipher[3:0];

    // Decode nibble to 7-seg
    hex7seg DISP(
        .x(nib),
        .a_to_g(a_to_g)
    );

    // Control which digit is ON
    always @(*) begin
        an = 8'b11111111;     // all OFF by default (active low)
        if (sel == 0)
            an[0] = 1'b0;     // enable rightmost digit → lower nibble
        else
            an[1] = 1'b0;     // enable next digit → upper nibble
    end

    assign dp = 1'b1;          // decimal point always off
endmodule

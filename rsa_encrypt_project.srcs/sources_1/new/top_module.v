`timescale 1ns/1ps
module top_module(
    input  wire clk,
    input  wire btnC,             // Center button for "Generate"
    output wire [6:0] a_to_g,
    output reg  [7:0] an,
    output wire dp
);

    wire [7:0] rand_num;
    wire [7:0] cipher;

    // Instantiate Random Number Generator
    single_random_number RNG(
        .clk(clk),
        .generate_btn(btnC),
        .random_num(rand_num)
    );

    // RSA encryption with fixed n=33, e=3
    rsa_encrypt RSA1(
        .clk(clk),
        .plain(rand_num),
        .cipher(cipher)
    );

    // refresh divider for multiplexing 7-seg
    reg [19:0] div;
    always @(posedge clk) div <= div + 1;

    // 4 display states (0..3)
    wire [1:0] sel = div[19:18];

    // choose nibble to display depending on which digit is active
    reg [3:0] nib;
    always @(*) begin
        case (sel)
            2'd0: nib = cipher[3:0];   // an[0] = cipher LSB
            2'd1: nib = cipher[7:4];   // an[1] = cipher MSB
            2'd2: nib = rand_num[3:0]; // an[2] = random LSB
            2'd3: nib = rand_num[7:4]; // an[3] = random MSB
            default: nib = 4'h0;
        endcase
    end

    // hex to 7-seg
    hex7seg DISP(.x(nib), .a_to_g(a_to_g));

    // drive active-low anodes
    always @(*) begin
        an = 8'b1111_1111; // all off
        case (sel)
            2'd0: an[0] = 1'b0; // cipher LSB
            2'd1: an[1] = 1'b0; // cipher MSB
            2'd2: an[2] = 1'b0; // random LSB
            2'd3: an[3] = 1'b0; // random MSB
        endcase
    end

    assign dp = 1'b1; // dot off
endmodule

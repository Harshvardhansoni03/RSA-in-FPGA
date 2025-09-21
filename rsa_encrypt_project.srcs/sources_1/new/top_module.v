`timescale 1ns/1ps
module top_module(
    input  wire clk,
    input  wire btnC,        // Generate random + encrypt
    input  wire btnU,        // Decrypt
    output wire [6:0] a_to_g,
    output reg  [7:0] an,
    output wire dp
);

    wire [7:0] rand_num;
    wire [7:0] cipher;
    wire [7:0] decrypted;
    wire enc_busy, dec_busy;
    reg  start_enc, start_dec;

    wire [3:0] rand_tens, rand_ones;
    wire [3:0] dec_tens, dec_ones;

    // Random number generator
    single_random_number RNG(
        .clk(clk),
        .generate_btn(btnC),
        .random_num(rand_num)
    );

    // Convert random number to decimal digits
    bin2bcd BCD_RAND(
        .binary(rand_num),
        .tens(rand_tens),
        .ones(rand_ones)
    );

    // RSA encryption (sequential FSM)
    rsa_encrypt RSA1(
        .clk(clk),
        .start(start_enc),
        .plain(rand_num),
        .cipher(cipher),
        .busy(enc_busy)
    );

    // RSA decryption (sequential FSM, triggered by BTNU)
    rsa_decrypt RSA_DEC(
        .clk(clk),
        .start(start_dec),
        .cipher_in(cipher),
        .plain(decrypted),
        .busy(dec_busy)
    );

    // Convert decrypted number to decimal digits
    bin2bcd BCD_DEC(
        .binary(decrypted),
        .tens(dec_tens),
        .ones(dec_ones)
    );

    // Generate 1-cycle start pulses for FSMs
    always @(posedge clk) begin
        start_enc <= btnC;
        start_dec <= btnU;
    end

    // Refresh divider for multiplexing 7-seg displays
    reg [19:0] div;
    always @(posedge clk) div <= div + 1;
    wire [2:0] sel = div[19:17];

    // Select nibble to display
    reg [3:0] nib;
    always @(*) begin
        case (sel)
            3'd0: nib = cipher[3:0];       // AN0 cipher LSB (hex)
            3'd1: nib = cipher[7:4];       // AN1 cipher MSB (hex)
            3'd2: nib = rand_ones;         // AN2 random ones digit (decimal)
            3'd3: nib = rand_tens;         // AN3 random tens digit (decimal)
            3'd4: nib = dec_ones;          // AN4 decrypted ones digit (decimal)
            3'd5: nib = dec_tens;          // AN5 decrypted tens digit (decimal)
            default: nib = 4'h0;
        endcase
    end

    // 7-seg decoder
    hex7seg DISP(.x(nib), .a_to_g(a_to_g));

    // Drive active-low anodes
    always @(*) begin
        an = 8'b1111_1111;
        case (sel)
            3'd0: an[0] = 1'b0;   // cipher LSB
            3'd1: an[1] = 1'b0;   // cipher MSB
            3'd2: an[2] = 1'b0;   // random ones
            3'd3: an[3] = 1'b0;   // random tens
            3'd4: if (!dec_busy) an[4] = 1'b0;  // decrypted ones
            3'd5: if (!dec_busy) an[5] = 1'b0;  // decrypted tens
            default: an = 8'b1111_1111;
        endcase
    end

    assign dp = 1'b1; // dot off
endmodule

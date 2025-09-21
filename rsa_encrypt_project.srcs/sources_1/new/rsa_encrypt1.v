`timescale 1ns/1ps
// RSA Encryption (toy example) - computes C = M^e mod n
module rsa_encrypt(
    input  wire clk,           // system clock
    input  wire [7:0] plain,   // input number (from RNG, 1-99)
    output reg  [7:0] cipher   // encrypted result
);
    // RSA parameters (fixed for demo)
    parameter integer n = 33;
    parameter integer e = 3;

    // internal regs
    integer i;
    reg [31:0] base;
    reg [31:0] result;

    always @(posedge clk) begin
        // Compute modular exponentiation: C = (plain^e) mod n
        base   = plain % n;
        result = 1;

        for (i = 0; i < e; i = i + 1) begin
            result = (result * base) % n;
        end

        cipher <= result[7:0];
    end
endmodule

`timescale 1ns / 1ps
// RSA Encryption (toy example with hardcoded input)

module rsa_encrypt(
    input wire clk,            // system clock
    output reg [7:0] plain,    // original ASCII value
    output reg [7:0] cipher    // encrypted result
);
    // RSA parameters
    parameter n = 33;
    parameter e = 3;

    // Hardcoded input message "H" = 72
    reg [7:0] message = 72;

    // Internal registers
    reg [31:0] temp;
    reg [1:0] state = 0;

    always @(posedge clk) begin
        case(state)
            0: begin
                plain <= message; 
                temp <= message * message * message; // M^3
                state <= 1;
            end
            1: begin
                cipher <= temp % n; // (M^e mod n)
                state <= 2;
            end
            default: state <= 2; // hold result
        endcase
    end
endmodule

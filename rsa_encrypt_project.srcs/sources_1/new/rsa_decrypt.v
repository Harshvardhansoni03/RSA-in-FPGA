`timescale 1ns/1ps
module rsa_decrypt(
    input  wire clk,
    input  wire start,
    input  wire [7:0] cipher_in,
    output reg  [7:0] plain,
    output reg  busy
);
    parameter integer n = 143;
    parameter integer d = 103;

    reg [7:0] exp;
    reg [31:0] base, result;
    reg [1:0] state;

    // FSM state encoding
    localparam IDLE = 2'd0;
    localparam CALC = 2'd1;
    localparam DONE = 2'd2;

    always @(posedge clk) begin
        case(state)
            IDLE: begin
                plain <= 0;
                busy  <= 0;
                if (start) begin
                    base   <= cipher_in % n;
                    exp    <= d;
                    result <= 1;
                    busy   <= 1;
                    state  <= CALC;
                end
            end

            CALC: begin
                if (exp != 0) begin
                    if (exp[0])
                        result <= (result * base) % n;
                    base <= (base * base) % n;
                    exp  <= exp >> 1;
                end else begin
                    plain  <= result[7:0];
                    busy   <= 0;
                    state  <= DONE;
                end
            end

            DONE: begin
                if (!start)
                    state <= IDLE;
            end
        endcase
    end
endmodule

`timescale 1ns/1ps
module rsa_decrypt(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [63:0] cipher_in,
    output reg  [63:0] plain,
    output reg  busy
);
    // Example small RSA key for testing (replace with actual n/d)
    parameter [63:0] n = 64'h0000000000000023;
    parameter [31:0] d = 32'd13;

    reg [63:0] base, result;
    reg [31:0] exp;
    reg [1:0] state;

    localparam IDLE = 2'd0;
    localparam CALC = 2'd1;
    localparam DONE = 2'd2;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state  <= IDLE;
            plain  <= 0;
            busy   <= 0;
            base   <= 0;
            result <= 0;
            exp    <= 0;
        end else begin
            case(state)
                IDLE: begin
                    busy <= 0;
                    if(start) begin
                        base   <= cipher_in % n;
                        exp    <= d;
                        result <= 1;
                        busy   <= 1;
                        state  <= CALC;
                    end
                end
                CALC: begin
                    if(exp != 0) begin
                        if(exp[0]) result <= (result * base) % n;
                        base <= (base * base) % n;
                        exp  <= exp >> 1;
                    end else begin
                        plain <= result;
                        busy  <= 0;
                        state <= DONE;
                    end
                end
                DONE: begin
                    if(!start) state <= IDLE;
                end
            endcase
        end
    end
endmodule

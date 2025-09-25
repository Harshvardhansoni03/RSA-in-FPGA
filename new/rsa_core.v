// rsa_core.v
`timescale 1ns/1ps
module rsa_core #(
    parameter WIDTH = 16
)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [WIDTH-1:0] m_in,
    input  wire [WIDTH-1:0] e_in,
    input  wire [WIDTH-1:0] n_in,
    output reg  [WIDTH-1:0] out,
    output reg busy,
    output reg done
);

reg [WIDTH-1:0] base;
reg [WIDTH-1:0] exp;
reg [2*WIDTH-1:0] prod;
reg [WIDTH-1:0] result;
reg [1:0] state;
localparam IDLE=0, RUN=1, FIN=2;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        busy <= 0;
        done <= 0;
        out <= 0;
    end else begin
        case(state)
            IDLE: begin
                done <= 0;
                busy <= 0;
                if (start) begin
                    base <= m_in % n_in;
                    exp <= e_in;
                    result <= 1 % n_in;
                    busy <= 1;
                    state <= RUN;
                end
            end
            RUN: begin
                if (exp == 0) begin
                    out <= result;
                    busy <= 0;
                    done <= 1;
                    state <= FIN;
                end else begin
                    if (exp[0])
                        result <= (result * base) % n_in;
                    base <= (base * base) % n_in;
                    exp <= exp >> 1;
                end
            end
            FIN: begin
                if (!start)
                    state <= IDLE;
            end
        endcase
    end
end

endmodule

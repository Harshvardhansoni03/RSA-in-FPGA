// rsa_core.v
// Simple modular exponentiation: c = m^e mod n
// Note: This is iterative and uses builtin multiply - resource usage depends on WIDTH.
`timescale 1ns/1ps
module rsa_core #(
    parameter WIDTH = 32
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 start,    // start operation
    input  wire [WIDTH-1:0]     m_in,     // message/plaintext
    input  wire [WIDTH-1:0]     e_in,     // exponent
    input  wire [WIDTH-1:0]     n_in,     // modulus
    output reg  [WIDTH-1:0]     out,      // result
    output reg                  busy,
    output reg                  done
);

reg [WIDTH-1:0] base;
reg [WIDTH-1:0] exp;
reg [2*WIDTH-1:0] prod; // temporary for multiplication
reg [WIDTH-1:0] result;

reg [7:0] state; // small FSM
localparam IDLE = 0, RUN = 1, FIN = 2;

integer i;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        busy <= 0;
        done <= 0;
        out <= 0;
    end else begin
        case (state)
            IDLE: begin
                done <= 0;
                busy <= 0;
                if (start) begin
                    // initialize
                    base <= m_in % n_in;
                    exp <= e_in;
                    result <= 1 % n_in;
                    busy <= 1;
                    state <= RUN;
                end
            end

            RUN: begin
                // iterative square-and-multiply
                if (exp == 0) begin
                    out <= result;
                    busy <= 0;
                    done <= 1;
                    state <= FIN;
                end else begin
                    if (exp[0]) begin
                        // result = (result * base) % n
                        prod = result * base;
                        result = prod % n_in;
                    end
                    // base = (base * base) % n
                    prod = base * base;
                    base = prod % n_in;
                    exp = exp >> 1;
                end
            end

            FIN: begin
                // wait for start to be low
                if (!start) begin
                    done <= 0;
                    state <= IDLE;
                end
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule

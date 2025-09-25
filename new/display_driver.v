// display_driver.v
`timescale 1ns/1ps
module display_driver(
    input wire clk,
    input wire rst,
    input wire [31:0] nibbles, // 8 x 4-bit nibbles
    output reg [7:0] an,
    output wire [6:0] seg
);

reg [2:0] digit_idx;
reg [15:0] refresh_cnt;
reg [3:0] nibble;

always @(posedge clk) begin
    if (rst) begin
        refresh_cnt <= 0;
        digit_idx <= 0;
    end else begin
        refresh_cnt <= refresh_cnt + 1;
        if (refresh_cnt == 16'hFFFF)
            digit_idx <= digit_idx + 1;
    end
end

always @(*) begin
    case(digit_idx)
        3'd0: nibble = nibbles[3:0];
        3'd1: nibble = nibbles[7:4];
        3'd2: nibble = nibbles[11:8];
        3'd3: nibble = nibbles[15:12];
        3'd4: nibble = nibbles[19:16];
        3'd5: nibble = nibbles[23:20];
        3'd6: nibble = nibbles[27:24];
        3'd7: nibble = nibbles[31:28];
        default: nibble = 4'h0;
    endcase
end

// drive anodes (active low)
always @(*) begin
    an = 8'b1111_1111;
    case(digit_idx)
        3'd0: an = 8'b1111_1110;
        3'd1: an = 8'b1111_1101;
        3'd2: an = 8'b1111_1011;
        3'd3: an = 8'b1111_0111;
        3'd4: an = 8'b1110_1111;
        3'd5: an = 8'b1101_1111;
        3'd6: an = 8'b1011_1111;
        3'd7: an = 8'b0111_1111;
    endcase
end

hex_to_7seg u_hex2seg(.hex(nibble), .seg(seg));

endmodule

// display_driver.v
`timescale 1ns/1ps
module display_driver (
    input  wire        clk,        // 100 MHz clock (or board clock)
    input  wire        rst,        // active high reset
    input  wire [63:0] value_in,   // 64-bit value to display
    input  wire        half_sel,   // 0 -> lower 32 bits, 1 -> upper 32 bits
    output reg  [7:0]  an,         // digit enables (active low or high depending on board)
    output wire [6:0]  seg         // segments {g,f,e,d,c,b,a} (active HIGH in this file)
);

reg [2:0] digit_idx;
reg [15:0] refresh_cnt; // control refresh speed
reg [31:0] half32;
reg [3:0] nibble;
wire [6:0] seg_wire;

always @(posedge clk) begin
    if (rst) begin
        refresh_cnt <= 0;
        digit_idx <= 0;
    end else begin
        refresh_cnt <= refresh_cnt + 1;
        // choose a refresh rate: use top bits of refresh_cnt
        if (refresh_cnt == 16'hFFFF) begin
            digit_idx <= digit_idx + 1;
        end
    end
end

// Select upper or lower 32 bits (we display 8 hex digits at a time)
always @(*) begin
    if (half_sel)
        half32 = value_in[63:32];
    else
        half32 = value_in[31:0];
end

// Which nibble to show on this digit (digit_idx 0..7)
always @(*) begin
    case (digit_idx)
        3'd0: nibble = half32[3:0];
        3'd1: nibble = half32[7:4];
        3'd2: nibble = half32[11:8];
        3'd3: nibble = half32[15:12];
        3'd4: nibble = half32[19:16];
        3'd5: nibble = half32[23:20];
        3'd6: nibble = half32[27:24];
        3'd7: nibble = half32[31:28];
        default: nibble = 4'h0;
    endcase
end

// drive anodes (adjust polarity as needed - many Nexys boards use active LOW anodes)
always @(*) begin
    // set all high by default
    an = 8'b1111_1111;
    // active digit select (assume active LOW)
    case (digit_idx)
        3'd0: an = 8'b1111_1110;
        3'd1: an = 8'b1111_1101;
        3'd2: an = 8'b1111_1011;
        3'd3: an = 8'b1111_0111;
        3'd4: an = 8'b1110_1111;
        3'd5: an = 8'b1101_1111;
        3'd6: an = 8'b1011_1111;
        3'd7: an = 8'b0111_1111;
        default: an = 8'b1111_1111;
    endcase
end

hex_to_7seg u_hex2seg(.hex(nibble), .seg(seg_wire));

// If your board requires active-low segments, invert here:
assign seg = seg_wire; // change to ~seg_wire if active LOW segments

endmodule

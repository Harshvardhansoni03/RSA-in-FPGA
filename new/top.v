// top.v
`timescale 1ns/1ps
module top (
    input  wire clk,
    input  wire rst,
    input  wire sw0, // J15 -> encrypt enable
    input  wire sw1, // L16 -> decrypt enable
    output wire [7:0] an,
    output wire [6:0] seg
);

wire [63:0] m_full;
wire [15:0] m_last4;
wire [15:0] c;
wire [15:0] m_dec;

// instantiate ROM (unchanged)
wifi_key_rom rom_inst(
    .m_out(m_full)
);

// last 4 hex digits
assign m_last4 = m_full[15:0];

// --- RSA core instances ---
wire enc_busy, enc_done;
wire dec_busy, dec_done;

// encryption core
rsa_core #(.WIDTH(16)) rsa_enc (
    .clk(clk),
    .rst(rst),
    .start(1'b1),
    .m_in(m_last4),          // no modulus here
    .e_in(16'd7),            // public exponent
    .n_in(16'd17947),        // modulus > 0x3135
    .out(c),
    .busy(enc_busy),
    .done(enc_done)
);

// decryption core
rsa_core #(.WIDTH(16)) rsa_dec (
    .clk(clk),
    .rst(rst),
    .start(enc_done),
    .m_in(c),
    .e_in(16'd10103),        // private exponent
    .n_in(16'd17947),        // same modulus
    .out(m_dec),
    .busy(dec_busy),
    .done(dec_done)
);


// Build 8 nibbles for display
wire [3:0] n0 = m_last4[3:0];       // plaintext LSB
wire [3:0] n1 = m_last4[7:4];
wire [3:0] n2 = m_last4[11:8];
wire [3:0] n3 = m_last4[15:12];     // plaintext MSB

wire [3:0] n4 = sw0 ? c[3:0]  : 4'h0;  // ciphertext LSB
wire [3:0] n5 = sw0 ? c[7:4]  : 4'h0;  // ciphertext MSB

wire [3:0] n6 = sw1 ? m_dec[3:0] : 4'h0; // decrypted LSB
wire [3:0] n7 = sw1 ? m_dec[7:4] : 4'h0; // decrypted MSB

wire [31:0] display_val = {n3,n2,n1,n0,n5,n4,n7,n6}; // packed for display

// instantiate display driver
display_driver disp (
    .clk(clk),
    .rst(rst),
    .nibbles(display_val),
    .an(an),
    .seg(seg)
);

endmodule

// sevenseg_driver.v
module sevenseg_driver(
    input  wire clk,
    input  wire [3:0] digit,
    output reg  [6:0] a_to_g,
    output reg  [7:0] an,
    output wire dp
);
    reg [15:0] refresh;
    reg sel;

    always @(posedge clk)
        refresh <= refresh + 1;

    always @(posedge clk)
        sel <= refresh[15]; // toggle an0/an1

    always @(*) begin
        // hex-to-7seg active-low encoding (Nexys4 DDR)
        case (digit)
            4'd0: a_to_g = 7'b0000001;
            4'd1: a_to_g = 7'b1001111;
            4'd2: a_to_g = 7'b0010010;
            4'd3: a_to_g = 7'b0000110;
            4'd4: a_to_g = 7'b1001100;
            4'd5: a_to_g = 7'b0100100;
            4'd6: a_to_g = 7'b0100000;
            4'd7: a_to_g = 7'b0001111;
            4'd8: a_to_g = 7'b0000000;
            4'd9: a_to_g = 7'b0000100;
            default: a_to_g = 7'b1111111; // blank
        endcase

        // Enable an0 and an1 only (active-low)
        an = 8'b11111111;
        if (sel) an[0] = 0;
        else     an[1] = 0;
    end

    assign dp = 1'b1; // decimal point off
endmodule

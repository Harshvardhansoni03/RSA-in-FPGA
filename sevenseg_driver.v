module sevenseg_driver(
    input  wire clk,
    input  wire [7:0] value,
    output reg  [6:0] a_to_g,
    output reg  [7:0] an,
    output wire dp
);
    reg [3:0] digit;
    reg [19:0] refresh_counter = 0;

    assign dp = 1;

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    always @(*) begin
        case (refresh_counter[19:17])
            3'b000: begin an = 8'b11111110; digit = value % 10; end      // ones
            3'b001: begin an = 8'b11111101; digit = (value / 10) % 10; end // tens
            default: begin an = 8'b11111111; digit = 4'b1111; end
        endcase

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
            default: a_to_g = 7'b1111111;
        endcase
    end
endmodule

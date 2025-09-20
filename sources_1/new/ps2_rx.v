// ps2_rx.v
module ps2_rx(
    input  wire clk,
    input  wire ps2_clk,
    input  wire ps2_data,
    output reg  [7:0] scan_code,
    output reg  new_code
);
    reg [10:0] shift;
    reg [3:0]  count;
    reg ps2c_sync, ps2c_prev;

    always @(posedge clk) begin
        ps2c_sync <= ps2_clk;
        ps2c_prev <= ps2c_sync;

        if (ps2c_prev && !ps2c_sync) begin
            shift <= {ps2_data, shift[10:1]};
            if (count == 10) begin
                scan_code <= shift[8:1];
                new_code  <= 1;
                count <= 0;
            end else begin
                count <= count + 1;
                new_code <= 0;
            end
        end
    end
endmodule

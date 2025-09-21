// bin2bcd.v
module bin2bcd(
    input  wire [7:0] binary,
    output reg  [3:0] tens,
    output reg  [3:0] ones
);
    integer i;
    reg [7:0] temp;
    always @(*) begin
        temp = binary;
        tens = 0;
        ones = 0;
        for (i=7; i>=0; i=i-1) begin
            if (tens >= 5) tens = tens + 3;
            if (ones >= 5) ones = ones + 3;
            {tens, ones} = {tens, ones} << 1;
            ones[0] = temp[i];
        end
    end
endmodule

`timescale 1ns/1ps

module tb_top_module;
    reg clk;
    reg btnC;
    wire [6:0] a_to_g;
    wire [7:0] an;
    wire dp;

    // Instantiate DUT
    top_module DUT (
        .clk(clk),
        .btnC(btnC),
        .a_to_g(a_to_g),
        .an(an),
        .dp(dp)
    );

    // Clock generator: 100 MHz -> 10 ns
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        btnC = 0;

        // Display with fixed RSA params n=33, e=3
        $display("RSA Encryption Testbench: n=33, e=3");
        $monitor("Time=%0t Plain=%0d Cipher=%0d", $time, DUT.rand_num, DUT.cipher);

        // First press
        #50 btnC = 1;
        #20 btnC = 0;

        // Second press
        #200 btnC = 1;
        #20 btnC = 0;

        #1000 $finish;
    end
endmodule

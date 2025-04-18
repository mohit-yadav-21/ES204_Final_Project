module matrix_multiplication_tb;

reg clk, reset, clear;
reg [7:0] a1, a2, a3;
reg [7:0] b1, b2, b3;
wire [23:0] c1, c2, c3, c4, c5, c6, c7, c8, c9;

matrix_multiplication uut (
    .clk(clk),
    .reset(reset),
    .clear(clear),
    .a1(a1), .a2(a2), .a3(a3),
    .b1(b1), .b2(b2), .b3(b3),
    .c1(c1), .c2(c2), .c3(c3),
    .c4(c4), .c5(c5), .c6(c6),
    .c7(c7), .c8(c8), .c9(c9)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    clear = 0;
    a1 = 0; a2 = 0; a3 = 0;
    b1 = 0; b2 = 0; b3 = 0;
    #10;

    reset = 0;
    a1 = 1; a2 = 2; a3 = 3;
    b1 = 4; b2 = 5; b3 = 6;
    #10;

    a1 = 7; a2 = 8; a3 = 9;
    b1 = 1; b2 = 2; b3 = 3;
    #10;

    clear = 1;
    #10;

    clear = 0;
    a1 = 2; a2 = 3; a3 = 4;
    b1 = 5; b2 = 6; b3 = 7;
    #10;
end

endmodule


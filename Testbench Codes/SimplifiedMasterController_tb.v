module SimplifiedMasterController_tb;

reg clk, reset, start;
reg [7:0] A00, A01, A02;
reg [7:0] A10, A11, A12;
reg [7:0] A20, A21, A22;
reg [7:0] B00, B01, B02;
reg [7:0] B10, B11, B12;
reg [7:0] B20, B21, B22;
wire [7:0] a1, a2, a3;
wire [7:0] b1, b2, b3;
wire done, clear;

SimplifiedMasterController uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .A00(A00), .A01(A01), .A02(A02),
    .A10(A10), .A11(A11), .A12(A12),
    .A20(A20), .A21(A21), .A22(A22),
    .B00(B00), .B01(B01), .B02(B02),
    .B10(B10), .B11(B11), .B12(B12),
    .B20(B20), .B21(B21), .B22(B22),
    .a1(a1), .a2(a2), .a3(a3),
    .b1(b1), .b2(b2), .b3(b3),
    .done(done),
    .clear(clear)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    start = 0;

    A00 = 1; A01 = 2; A02 = 3;
    A10 = 4; A11 = 5; A12 = 6;
    A20 = 7; A21 = 8; A22 = 9;

    B00 = 1; B01 = 2; B02 = 3;
    B10 = 4; B11 = 5; B12 = 6;
    B20 = 7; B21 = 8; B22 = 9;

    #10;
    reset = 0;
    start = 1;
    #10;
    start = 0;
end

endmodule

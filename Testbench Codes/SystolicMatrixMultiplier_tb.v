module SystolicMatrixMultiplier_tb;

reg clk, reset, start;
reg [7:0] A00, A01, A02;
reg [7:0] A10, A11, A12;
reg [7:0] A20, A21, A22;

reg [7:0] B00, B01, B02;
reg [7:0] B10, B11, B12;
reg [7:0] B20, B21, B22;

wire [23:0] C00, C01, C02;
wire [23:0] C10, C11, C12;
wire [23:0] C20, C21, C22;
wire done;

SystolicMatrixMultiplier uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .A00(A00), .A01(A01), .A02(A02),
    .A10(A10), .A11(A11), .A12(A12),
    .A20(A20), .A21(A21), .A22(A22),
    .B00(B00), .B01(B01), .B02(B02),
    .B10(B10), .B11(B11), .B12(B12),
    .B20(B20), .B21(B21), .B22(B22),
    .C00(C00), .C01(C01), .C02(C02),
    .C10(C10), .C11(C11), .C12(C12),
    .C20(C20), .C21(C21), .C22(C22),
    .done(done)
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

    B00 = 9; B01 = 8; B02 = 7;
    B10 = 6; B11 = 5; B12 = 4;
    B20 = 3; B21 = 2; B22 = 1;

    #10;
    reset = 0;
    start = 1;
    #10;
    start = 0;
end

endmodule

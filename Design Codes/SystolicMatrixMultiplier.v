module SystolicMatrixMultiplier(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] A00, A01, A02,
    input wire [7:0] A10, A11, A12,
    input wire [7:0] A20, A21, A22,
    input wire [7:0] B00, B01, B02,
    input wire [7:0] B10, B11, B12,
    input wire [7:0] B20, B21, B22,
    output wire [23:0] C00, C01, C02,
    output wire [23:0] C10, C11, C12,
    output wire [23:0] C20, C21, C22,
    output wire done
);
    wire [7:0] a1, a2, a3;
    wire [7:0] b1, b2, b3;
    wire clr;
   
    SimplifiedMasterController controller (
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
        .clear(clr)
    );
   
    matrix_multiplication systolic_array (
        .clk(clk),
        .reset(reset),
        .clear(clr),
        .a1(a1), .a2(a2), .a3(a3),
        .b1(b1), .b2(b2), .b3(b3),
        .c1(C00), .c2(C01), .c3(C02),
        .c4(C10), .c5(C11), .c6(C12),
        .c7(C20), .c8(C21), .c9(C22)
    );
   
endmodule

module matrix_multiplication(
    input wire clk, reset, clear,
    input wire [7:0] a1, a2, a3,
    input wire [7:0] b1, b2, b3,
    output wire [23:0] c1, c2, c3,c4, c5, c6, c7, c8, c9
);
    // horizontal wires
    wire [7:0] a12, a23, a45, a56, a78, a89;
    // vertical wires
    wire [7:0] b14, b25, b36, b47, b58, b69;
    
    wire [17:0] pe_c1, pe_c2, pe_c3, 
                pe_c4, pe_c5, pe_c6,
                pe_c7, pe_c8, pe_c9;
    

    pe pe1 (.clk(clk), .reset(reset), .clear(clear), .in_a(a1), .in_b(b1), .out_a(a12), .out_b(b14), .out_c(pe_c1));
    pe pe2 (.clk(clk), .reset(reset), .clear(clear), .in_a(a12), .in_b(b2), .out_a(a23), .out_b(b25), .out_c(pe_c2));
    pe pe3 (.clk(clk), .reset(reset), .clear(clear), .in_a(a23), .in_b(b3), .out_a(), .out_b(b36), .out_c(pe_c3));

    pe pe4 (.clk(clk), .reset(reset), .clear(clear), .in_a(a2), .in_b(b14), .out_a(a45), .out_b(b47), .out_c(pe_c4));
    pe pe5 (.clk(clk), .reset(reset), .clear(clear), .in_a(a45), .in_b(b25), .out_a(a56), .out_b(b58), .out_c(pe_c5));
    pe pe6 (.clk(clk), .reset(reset), .clear(clear), .in_a(a56), .in_b(b36), .out_a(), .out_b(b69), .out_c(pe_c6));

    pe pe7 (.clk(clk), .reset(reset), .clear(clear), .in_a(a3), .in_b(b47), .out_a(a78), .out_b(), .out_c(pe_c7));
    pe pe8 (.clk(clk), .reset(reset), .clear(clear), .in_a(a78), .in_b(b58), .out_a(a89), .out_b(), .out_c(pe_c8));
    pe pe9 (.clk(clk), .reset(reset), .clear(clear), .in_a(a89), .in_b(b69), .out_a(), .out_b(), .out_c(pe_c9));
    
    assign c1 = {6'b0, pe_c1};
    assign c2 = {6'b0, pe_c2};
    assign c3 = {6'b0, pe_c3};
    assign c4 = {6'b0, pe_c4};
    assign c5 = {6'b0, pe_c5};
    assign c6 = {6'b0, pe_c6};
    assign c7 = {6'b0, pe_c7};
    assign c8 = {6'b0, pe_c8};
    assign c9 = {6'b0, pe_c9};
    
endmodule

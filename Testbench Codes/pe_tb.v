module pe_tb;

reg clk, reset, clear;
reg [7:0] in_a, in_b;
wire [7:0] out_a, out_b;
wire [17:0] out_c;

pe uut (
    .clk(clk),
    .reset(reset),
    .clear(clear),
    .in_a(in_a),
    .in_b(in_b),
    .out_a(out_a),
    .out_b(out_b),
    .out_c(out_c)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    clear = 0;
    in_a = 0;
    in_b = 0;
    #10;

    reset = 0;
    in_a = 3;
    in_b = 4;
    #10;

    in_a = 2;
    in_b = 5;
    #10;

    clear = 1;
    #10;

    clear = 0;
    in_a = 1;
    in_b = 1;

end

endmodule
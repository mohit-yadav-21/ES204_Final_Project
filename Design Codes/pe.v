module pe(
    input wire clk, reset,
    input wire clear,         
    input wire [7:0] in_a, in_b,
    output reg [7:0] out_a, out_b,
    output reg [17:0] out_c
);
    always @(posedge clk) begin
        if (reset || clear) begin
            out_a <= 0;
            out_b <= 0;
            out_c <= 0;
        end
        else begin
            out_c <= out_c + in_a * in_b;
            out_a <= in_a;
            out_b <= in_b;
        end
    end
endmodule
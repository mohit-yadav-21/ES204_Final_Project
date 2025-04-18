module matrix_receive(
    input clk,              
    input reset,           
    input rx,              
    input clear,            // Clear signal to reset counters
    output reg done,        
    output reg [7:0] data0,
    output reg [7:0] data1,
    output reg [7:0] data2,
    output reg [7:0] data3,
    output reg [7:0] data4,
    output reg [7:0] data5,
    output reg [7:0] data6,
    output reg [7:0] data7,
    output reg [7:0] data8,
    output reg [7:0] data9,
    output reg [7:0] data10,
    output reg [7:0] data11,
    output reg [7:0] data12,
    output reg [7:0] data13,
    output reg [7:0] data14,
    output reg [7:0] data15,
    output reg [7:0] data16,
    output reg [7:0] data17,
    output reg [4:0] recv_count  // 5-bit counter: counts 0 to 17
);

//    parameter NUM_INPUT_BYTES = 18;
    wire [7:0] rx_data;
    wire rx_done;

    uart_rx #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200),
        .OVERSAMPLE(16)
    ) uart_receiver (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    reg rx_done_d;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_done_d <= 1'b0;
            recv_count <= 5'd0;
            done <= 1'b0;
            data0  <= 0; data1  <= 0; data2  <= 0; data3  <= 0; data4  <= 0;
            data5  <= 0; data6  <= 0; data7  <= 0; data8  <= 0; data9  <= 0;
            data10 <= 0; data11 <= 0; data12 <= 0; data13 <= 0; data14 <= 0;
            data15 <= 0; data16 <= 0; data17 <= 0;
        end else if (clear) begin
            recv_count <= 0;
            done <= 1'b0;
        end else begin
            rx_done_d <= rx_done;
            if (~rx_done_d && rx_done) begin
                case (recv_count)
                    5'd0:  data0  <= rx_data;
                    5'd1:  data1  <= rx_data;
                    5'd2:  data2  <= rx_data;
                    5'd3:  data3  <= rx_data;
                    5'd4:  data4  <= rx_data;
                    5'd5:  data5  <= rx_data;
                    5'd6:  data6  <= rx_data;
                    5'd7:  data7  <= rx_data;
                    5'd8:  data8  <= rx_data;
                    5'd9:  data9  <= rx_data;
                    5'd10: data10 <= rx_data;
                    5'd11: data11 <= rx_data;
                    5'd12: data12 <= rx_data;
                    5'd13: data13 <= rx_data;
                    5'd14: data14 <= rx_data;
                    5'd15: data15 <= rx_data;
                    5'd16: data16 <= rx_data;
                    5'd17: data17 <= rx_data;
                endcase
                if (recv_count == 5'd17)
                    done <= 1'b1;
                else
                    recv_count <= recv_count + 1'b1;
            end
        end
    end

endmodule

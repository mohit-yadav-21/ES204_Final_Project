`timescale 1ns/1ps
module MatrixMultUARTTop(
    input clk,
    input reset,
    input rx,             
    output tx
//    output reg tx_done,
//    output [23:0] C00, C01, C02, C10, C11, C12, C20, C21, C22
);
    wire [7:0] data0, data1, data2, data3, data4, data5, data6, data7, data8;
    wire [7:0] data9, data10, data11, data12, data13, data14, data15, data16, data17;
    wire [23:0] C00, C01, C02, C10, C11, C12, C20, C21, C22;
    reg tx_done;
    wire rx_done_flag;
    wire rx_clear;

    matrix_receive u_rx (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .clear(rx_clear),
        .done(rx_done_flag),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .data6(data6),
        .data7(data7),
        .data8(data8),
        .data9(data9),
        .data10(data10),
        .data11(data11),
        .data12(data12),
        .data13(data13),
        .data14(data14),
        .data15(data15),
        .data16(data16),
        .data17(data17)
//        .recv_count()
    );

    wire [7:0] A00 = data0;
    wire [7:0] A01 = data1;
    wire [7:0] A02 = data2;
    wire [7:0] A10 = data3;
    wire [7:0] A11 = data4;
    wire [7:0] A12 = data5;
    wire [7:0] A20 = data6;
    wire [7:0] A21 = data7;
    wire [7:0] A22 = data8;
    wire [7:0] B00 = data9;
    wire [7:0] B01 = data10;
    wire [7:0] B02 = data11;
    wire [7:0] B10 = data12;
    wire [7:0] B11 = data13;
    wire [7:0] B12 = data14;
    wire [7:0] B20 = data15;
    wire [7:0] B21 = data16;
    wire [7:0] B22 = data17;

    wire mult_done;
    reg start_mult;
    reg [1:0] m_state;
    localparam M_IDLE = 0, M_RUN = 1, M_DONE = 2;
    
    // Multiplication FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            m_state <= M_IDLE;
            start_mult <= 0;
        end else begin
            case (m_state)
                M_IDLE: begin
                    start_mult <= 0;
                    if (rx_done_flag)
                        m_state <= M_RUN;
                end
                M_RUN: begin
                    start_mult <= 1;
                    m_state <= M_DONE;
                end
                M_DONE: begin
                    start_mult <= 0;
                    if (tx_done)  // When transmission is finished, go back to idle
                        m_state <= M_IDLE;
                end
            endcase
        end
    end

    
    SystolicMatrixMultiplier systolic_mult (
        .clk(clk),
        .reset(reset),
        .start(start_mult),
        .A00(A00), .A01(A01), .A02(A02),
        .A10(A10), .A11(A11), .A12(A12),
        .A20(A20), .A21(A21), .A22(A22),
        .B00(B00), .B01(B01), .B02(B02),
        .B10(B10), .B11(B11), .B12(B12),
        .B20(B20), .B21(B21), .B22(B22),
        .C00(C00), .C01(C01), .C02(C02),
        .C10(C10), .C11(C11), .C12(C12),
        .C20(C20), .C21(C21), .C22(C22),
        .done(mult_done)
    );

// Transmission
    reg [4:0] tx_count;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx_busy;
    
    localparam T_IDLE = 0,
               T_LOAD = 1,
               T_ASSERT = 2,
               T_WAIT_HIGH = 3,
               T_WAIT_LOW = 4,
               T_DONE = 5,
               T_RESET = 6;
               
    // T_IDLE: Wait for multiplication 
    // T_LOAD:  Load the next byte 
    // T_ASSERT: Assert tx_start for one cycle.
    // T_WAIT_HIGH: Wait for tx_busy to become high.
    // T_WAIT_LOW:Wait for tx_busy to become low.
    // T_DONE: Transmission complete.
    // T_RESET: Reset tx_done and assert rx_clear.

    reg [2:0] tx_state;

    uart_tx #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
    ) tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_state <= T_IDLE;
            tx_count <= 0;
            tx_start <= 0;
            tx_data <= 0;
            tx_done <= 0;
        end else begin
            case (tx_state)
                T_IDLE: begin
                    tx_start <= 0;
                    if (mult_done) begin
                        tx_count <= 0;
                        tx_state <= T_LOAD;
                    end
                end
                T_LOAD: begin
                    case (tx_count)
                                               
                        5'd0:  tx_data <= C00[23:16];
                        5'd1:  tx_data <= C00[15:8];
                        5'd2:  tx_data <= C00[7:0];
                        5'd3:  tx_data <= C01[23:16];
                        5'd4:  tx_data <= C01[15:8];
                        5'd5:  tx_data <= C01[7:0];
                        5'd6:  tx_data <= C02[23:16];
                        5'd7:  tx_data <= C02[15:8];
                        5'd8:  tx_data <= C02[7:0];
                        5'd9:  tx_data <= C10[23:16];
                        5'd10: tx_data <= C10[15:8];
                        5'd11: tx_data <= C10[7:0];
                        5'd12: tx_data <= C11[23:16];
                        5'd13: tx_data <= C11[15:8];
                        5'd14: tx_data <= C11[7:0];
                        5'd15: tx_data <= C12[23:16];
                        5'd16: tx_data <= C12[15:8];
                        5'd17: tx_data <= C12[7:0];
                        5'd18: tx_data <= C20[23:16];
                        5'd19: tx_data <= C20[15:8];
                        5'd20: tx_data <= C20[7:0];
                        5'd21: tx_data <= C21[23:16];
                        5'd22: tx_data <= C21[15:8];
                        5'd23: tx_data <= C21[7:0];
                        5'd24: tx_data <= C22[23:16];
                        5'd25: tx_data <= C22[15:8];
                        5'd26: tx_data <= C22[7:0];
                        default: tx_data <= 8'h00;

                    endcase
                    tx_state <= T_ASSERT;
                end
                T_ASSERT: begin
                    tx_start <= 1;
                    tx_state <= T_WAIT_HIGH;
                end
                T_WAIT_HIGH: begin
                    tx_start <= 0;
                    if (tx_busy)
                        tx_state <= T_WAIT_LOW;
                end
                T_WAIT_LOW: begin
                    if (!tx_busy) begin
                        if (tx_count == 5'd26)
                            tx_state <= T_DONE;
                        else begin
                            tx_count <= tx_count + 1;
                            tx_state <= T_LOAD;
                        end
                    end
                end
                T_DONE: begin
                    tx_done <= 1;
                    tx_state <= T_RESET;
                end
                T_RESET: begin
                    tx_done <= 0;
                    tx_state <= T_IDLE;
                end
                default: tx_state <= T_IDLE;
            endcase
        end
    end

    assign rx_clear = (tx_state == T_RESET);

endmodule

module tb_MatrixMultUARTTop;
    reg clk;
    reg reset;
    reg rx;        
    wire tx; 
    wire tx_done;
    wire [23:0] C00, C01, C02, C10, C11, C12, C20, C21, C22;  


    MatrixMultUARTTop dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx),
        .tx_done(tx_done),
        .C00(C00),
        .C01(C01),
        .C02(C02),
        .C10(C10),
        .C11(C11),
        .C12(C12),
        .C20(C20),
        .C21(C21),
        .C22(C22)
    );

    // Clock generation (100Mhz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task send_byte;
        input [7:0] byte;
        integer i;
        begin            
            rx = 0;
            #8680;  
            //(LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                #8680;
            end
            rx = 1;
            #8680;
        end
    endtask

    
    initial begin
        reset = 1;
        rx = 1;  
        #50;
        reset = 0;
        #50;
        
        
        send_byte(8'd1);
        send_byte(8'd2);
        send_byte(8'd3);
        send_byte(8'd4);
        send_byte(8'd5);
        send_byte(8'd6);
        send_byte(8'd7);
        send_byte(8'd8);
        send_byte(8'd9);
        send_byte(8'd9);
        send_byte(8'd8);
        send_byte(8'd7);
        send_byte(8'd6);
        send_byte(8'd5);
        send_byte(8'd4);
        send_byte(8'd3);
        send_byte(8'd2);
        send_byte(8'd1);
        #2500000;
        
        
        send_byte(8'd2);
        send_byte(8'd3);
        send_byte(8'd4);
        send_byte(8'd5);
        send_byte(8'd6);
        send_byte(8'd7);
        send_byte(8'd8);
        send_byte(8'd9);
        send_byte(8'd10);
        send_byte(8'd10);
        send_byte(8'd9);
        send_byte(8'd8);
        send_byte(8'd7);
        send_byte(8'd6);
        send_byte(8'd5);
        send_byte(8'd4);
        send_byte(8'd3);
        send_byte(8'd2);
        #500000;
        
        #100000;
    end

endmodule

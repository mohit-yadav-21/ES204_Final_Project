module uart_rx_tb;

  reg clk;
  reg reset;
  reg rx;
  wire [7:0] rx_data;
  wire rx_done;

  uart_rx uut (
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  parameter BIT_PERIOD = 8680; 

  task send_uart_byte(input [7:0] byte);
    integer i;
    begin
      rx = 0;
      #(BIT_PERIOD);
      for (i = 0; i < 8; i = i + 1) begin
        rx = byte[i];
        #(BIT_PERIOD);
      end

      rx = 1;
      #(BIT_PERIOD);
    end
  endtask

  initial begin
    reset = 1;
    rx = 1;
    #100;
    
    reset = 0;
    #1000;

    send_uart_byte(8'd26);

   
  end
endmodule
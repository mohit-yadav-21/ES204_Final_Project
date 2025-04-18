module tb_uart_tx;
  reg clk;
  reg reset;
  reg tx_start;
  reg [7:0] tx_data;
  wire tx;
  wire tx_busy;

  uart_tx uut (
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
  );

  initial begin
    clk = 0;
  end

  always #5 clk = ~clk;

  initial begin
    reset    = 1;
    tx_start = 0;
    tx_data  = 8'h00;

    #20;
    reset = 0;

    #50;

    tx_data  = 8'd29;
    tx_start = 1;
    #10;
    tx_start = 0;

    #90000;

    tx_data  = 8'd18;
    tx_start = 1;
    #10;
    tx_start = 0;

    #90000;

    tx_data  = 8'd255;
    tx_start = 1;
    #10;
    tx_start = 0;

    #90000;

  end

endmodule
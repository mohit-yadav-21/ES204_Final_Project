module matrix_receive_tb;

  reg clk;
  reg reset;
  reg rx;         
  wire done;
  wire [4:0] recv_count;
  wire [7:0] data0, data1, data2, data3, data4, data5, data6, data7, data8;

 
  matrix_receive uut (
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .done(done),
    .data0(data0),
    .data1(data1),
    .data2(data2),
    .data3(data3),
    .data4(data4),
    .data5(data5),
    .data6(data6),
    .data7(data7),
    .data8(data8),
    .recv_count(recv_count)
  );


  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  parameter BIT_PERIOD = 8680; 
  task send_byte(input [7:0] data);
    integer i;
    begin
      rx = 0;
      #(BIT_PERIOD);

      for (i = 0; i < 8; i = i + 1) begin
        rx = data[i];
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

    send_byte(8'h55);  
    send_byte(8'hAA); 
    send_byte(8'h11);
    send_byte(8'h22); 
    send_byte(8'h33); 
    send_byte(8'h44);  
    send_byte(8'h77); 
    send_byte(8'h7F);  
    send_byte(8'h99);  
      
  end

endmodule
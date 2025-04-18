module uart_tx(
    input clk,               
    input reset,             // Active-high 
    input tx_start,          
    input [7:0] tx_data,     
    output reg tx,           
    output reg tx_busy       
);
    parameter CLK_FREQ   = 100_000_000;  
    parameter BAUD_RATE  = 115200;
    parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;  

    localparam STATE_IDLE  = 0,
               STATE_START = 1,
               STATE_DATA  = 2,
               STATE_STOP  = 3;

    reg [1:0] state;
    reg [9:0] clk_count; // counter for bit period
    reg [2:0] bit_index; // 0 to 7
    reg [7:0] data_reg; 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_IDLE;
            clk_count <= 0;
            bit_index <= 0;
            tx <= 1;      
            tx_busy <= 0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    tx <= 1;
                    clk_count <= 0;
                    bit_index <= 0;
                    tx_busy <= 0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        state <= STATE_START;
                        tx_busy <= 1;
                        
                    end
                end

                STATE_START: begin
                    tx <= 0; 
                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        state <= STATE_DATA;
                    end
                end

                STATE_DATA: begin
                    tx <= data_reg[bit_index];
                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        if (bit_index < 7)
                            bit_index <= bit_index + 1;
                        else begin
                            bit_index <= 0;
                            state <= STATE_STOP;
                        end
                    end
                end

                STATE_STOP: begin
                    tx <= 1; 
                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        state <= STATE_IDLE;
                        tx_busy <= 0;
                    end
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end
endmodule



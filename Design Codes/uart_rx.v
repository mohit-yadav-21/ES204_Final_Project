module uart_rx(
    input clk,                
    input reset,              // Active-high reset
    input rx,                 
    output reg [7:0] rx_data, // Received 8-bit data
    output reg rx_done        // One-cycle pulse
);

    // Parameters 
    parameter CLK_FREQ   = 100_000_000;  
    parameter BAUD_RATE  = 115200;       
    parameter OVERSAMPLE = 16;            

    parameter DIV_COUNTER = CLK_FREQ / (BAUD_RATE * OVERSAMPLE);
    parameter MID_SAMPLE  = OVERSAMPLE / 2;

    localparam STATE_IDLE  = 0,
               STATE_START = 1,
               STATE_DATA  = 2,
               STATE_STOP  = 3;

    reg [1:0] state;          
    reg [13:0] counter;       // for clock division.
    reg [3:0] sample_count;   // (0 to OVERSAMPLE-1).
    reg [2:0] bit_index;      // (0 to 7).
    reg [7:0] data_reg;       

    //for majority sampling
    reg maj_prev, maj_mid, maj_next;

    // FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= STATE_IDLE;
            counter     <= 0;
            sample_count<= 0;
            bit_index   <= 0;
            data_reg    <= 0;
            rx_data     <= 0;
            rx_done     <= 0;
            maj_prev    <= 0;
            maj_mid     <= 0;
            maj_next    <= 0;
        end else begin
            
            rx_done <= 0;
            
            if (counter < DIV_COUNTER - 1) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;  
                case (state)
                    STATE_IDLE: begin
                        sample_count <= 0;
                        bit_index <= 0;
                        // Wait for 0 on rx 
                        if (~rx) begin
                            state <= STATE_START;
                        end
                    end

                    STATE_START: begin
                        if (sample_count == MID_SAMPLE) begin
                            // Verifying
                            if (~rx)
                                state <= STATE_DATA;
                            else
                                state <= STATE_IDLE; 
                            sample_count <= 0;
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end

                   
                    STATE_DATA: begin
                        
                        if (sample_count == MID_SAMPLE - 1) begin
                            maj_prev <= rx;
                        end
                        if (sample_count == MID_SAMPLE) begin
                            maj_mid <= rx;
                        end
                        if (sample_count == MID_SAMPLE + 1) begin
                            maj_next <= rx;
                        end
                        
                        if (sample_count == OVERSAMPLE - 1) begin
                            // Majority voteing out of 3
                            data_reg[bit_index] <= (maj_prev & maj_mid) | (maj_mid & maj_next) | (maj_prev & maj_next);
                            sample_count <= 0;
                            if (bit_index == 7)
                                state <= STATE_STOP;
                            else
                                bit_index <= bit_index + 1;
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end

                 
                    STATE_STOP: begin
                        if (sample_count == MID_SAMPLE - 1) begin
                            maj_prev <= rx;
                        end
                        if (sample_count == MID_SAMPLE) begin
                            maj_mid <= rx;
                        end
                        if (sample_count == MID_SAMPLE + 1) begin
                            maj_next <= rx;
                        end
                        
                        if (sample_count == OVERSAMPLE - 1) begin
                            // Majority voting again
                            if ((maj_prev & maj_mid) | (maj_mid & maj_next) | (maj_prev & maj_next)) begin
                                rx_data <= data_reg;
                                rx_done <= 1;  // one-cycle pulse
                            end
                            sample_count <= 0;
                            state <= STATE_IDLE;
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end

                    default: state <= STATE_IDLE;
                endcase
            end
        end
    end

endmodule
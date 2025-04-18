# 3x3 Matrix Multiplication Using Systolic Arrays with UART Integration

This repository contains the Verilog code for implementing a 3x3 matrix multiplication using systolic arrays. The project also includes UART integration to connect the Basys3 FPGA board to a laptop for input handling using a Python script.

## Features
- **Systolic Array Architecture:** Efficient computation for matrix multiplication.
- **UART Integration:** Enables data transfer between the Basys3 FPGA board and a laptop.
- **Input Handling:** Python script for inputting two 3x3 matrices, where each element is 8 bits.

## Block Diagram
Below is the block diagram of the system. 

![Block Diagram](/Other%20Files/BlockDiagram.png)

## How It Works
1. **Inputs:** Two 3x3 matrices are provided as inputs via the UART interface. Each element is represented using 8 bits.
2. **Processing:** The matrices are processed using a systolic array for efficient multiplication.
3. **Outputs:** The resulting 3x3 matrix is sent back to the laptop through the UART interface.

## Module Explanations

1. **MatrixMultUARTTop**: The top-level module that connects all the other components, coordinating the matrix multiplication and UART communication.
2. **uart_rx**: Handles the reception of 1 byte from the laptop via UART communication.
3. **matrix_receive**: Using the uart_rx module, handles the reception of the two input matrices.
4. **pe**: The PEs are the basic computational unit of the systolic array that performs multiplication and accumulation for individual elements.
5. **matrix_multiplication**: Connects 9 PEs to form systolic arrays.
6. **SimplifiesMasterController**: Controls the flow of inputs to the systolic array.
7. **SystolicMatrixMultiplier**: Connects the matrix_multiplication and SimplifiedMasterController modules to each other.
8. **uart_tx**: Sends the resulting 3x3 matrix back to the laptop via UART after processing.

## File Structure
- Design Codes - Contains the Verilog design source files.
- Testbench Codes - Contains the Verilog simulation source files.
- Other Files - Contains a Python script, constraints file, presentation and the block diagram.

## Requirements
- Basys3 FPGA Board
- Vivado Design Suite
- Python 3.x

## Implementation
- [Implementation Videos](https://iitgnacin-my.sharepoint.com/:f:/g/personal/23110207_iitgn_ac_in/Epcz5gzxI7RKm7uqvrsUTH8BKhkDLiXcI5wY0NY-FzVY1g?e=720wWB)





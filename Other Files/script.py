import serial
import time

SERIAL_PORT = 'COM7'   
BAUD_RATE = 115200

ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)


def combine_3_bytes(b1, b2, b3):
    return (b1 << 16) | (b2 << 8) | b3

print("Type 'q' at any prompt to quit.\n")
   
while True:
    try:
        matrix_A_input = input("Enter 9 values for matrix_A separated by spaces: ")
        if matrix_A_input.lower() == 'q':
            break
        matrix_A = list(map(int, matrix_A_input.split()))
        if len(matrix_A) != 9:
            print("Please enter exactly 9 integers for matrix_A.")
            continue

        matrix_B_input = input("Enter 9 values for matrix_B separated by spaces: ")
        if matrix_B_input.lower() == 'q':
            break
        matrix_B = list(map(int, matrix_B_input.split()))
        if len(matrix_B) != 9:
            print("Please enter exactly 9 integers for matrix_B.")
            continue

        input_data = matrix_A + matrix_B  

        print("Sending data to FPGA")
        for byte in input_data:
            ser.write(byte.to_bytes(1, byteorder='big'))
        print("Sent")

        output_data = []
        start_time = time.time()
        timeout_seconds = 3

        print("Waiting for output bytes...")
        while len(output_data) < 27:
            if ser.in_waiting > 0:
                received = ser.read(1)
                if received:
                    byte_val = int.from_bytes(received, byteorder='big')
                    output_data.append(byte_val)
            if time.time() - start_time > timeout_seconds:
                break

        if len(output_data) == 27:
            results = []
            for i in range(0, 27, 3):
                results.append(combine_3_bytes(output_data[i], output_data[i+1], output_data[i+2]))

            print("Matrix multiplication result:")
            print(f"C00 = {results[0]}, C01 = {results[1]}, C02 = {results[2]}")
            print(f"C10 = {results[3]}, C11 = {results[4]}, C12 = {results[5]}")
            print(f"C20 = {results[6]}, C21 = {results[7]}, C22 = {results[8]}")
        else:
            print("Did not receive all expected output bytes.\n")

    except Exception as e:
        print(f"Error: {e}\n")
        continue

ser.close()
print("Serial connection closed. Program terminated.")

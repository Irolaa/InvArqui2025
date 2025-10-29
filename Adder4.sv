module Adder4(
    input wire [7:0] A,  // Número de 8 bits al que se le sumará 4
    input wire Ci,       // Carry in, normalmente será 0 en este caso
    output wire [7:0] S, // Resultado de la suma
    output wire Co       // Carry out
);
    wire [7:0] B = 8'b00000100; // Valor constante 4 en binario
    wire [7:0] carry;           // Señales internas de acarreo entre los sumadores

    // Suma de cada bit utilizando el módulo AdderBit

    // Bit menos significativo (bit 0)
    AdderBit adder0(.A(A[0]), .B(B[0]), .Ci(Ci), .Co(carry[0]), .S(S[0]));

    // Bit 1
    AdderBit adder1(.A(A[1]), .B(B[1]), .Ci(carry[0]), .Co(carry[1]), .S(S[1]));

    // Bit 2
    AdderBit adder2(.A(A[2]), .B(B[2]), .Ci(carry[1]), .Co(carry[2]), .S(S[2]));

    // Bit 3
    AdderBit adder3(.A(A[3]), .B(B[3]), .Ci(carry[2]), .Co(carry[3]), .S(S[3]));

    // Bit 4
    AdderBit adder4(.A(A[4]), .B(B[4]), .Ci(carry[3]), .Co(carry[4]), .S(S[4]));

    // Bit 5
    AdderBit adder5(.A(A[5]), .B(B[5]), .Ci(carry[4]), .Co(carry[5]), .S(S[5]));

    // Bit 6
    AdderBit adder6(.A(A[6]), .B(B[6]), .Ci(carry[5]), .Co(carry[6]), .S(S[6]));

    // Bit más significativo (bit 7)
    AdderBit adder7(.A(A[7]), .B(B[7]), .Ci(carry[6]), .Co(Co), .S(S[7]));

endmodule
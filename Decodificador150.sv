module Decodificador150(
    input logic [7:0] num,          // Número de entrada de 8 bits (0 a 150)
    output logic [6:0] seg_centenas, // Salida del decodificador para centenas
    output logic [6:0] seg_decenas,  // Salida del decodificador para decenas
    output logic [6:0] seg_unidades  // Salida del decodificador para unidades
);

    logic [3:0] centenas, decenas, unidades;

    // Cálculo de centenas, decenas y unidades en valores de 4 bits
    assign centenas = (num / 100) % 10;
    assign decenas = (num / 10) % 10;
    assign unidades = num % 10;

    // Instancias del módulo Decodificador9 con conexión por nombre CORRECTA
    
    // Conexión para las Centenas
    Decodificador9 dec_centenas (
        .sw1(centenas[3]), 
        .sw2(centenas[2]), 
        .sw3(centenas[1]), 
        .sw4(centenas[0]), 
        .salida(seg_centenas)
    );
    
    // Conexión para las Decenas
    Decodificador9 dec_decenas (
        .sw1(decenas[3]), 
        .sw2(decenas[2]), 
        .sw3(decenas[1]), 
        .sw4(decenas[0]), 
        .salida(seg_decenas)
    );
    
    // Conexión para las Unidades
    Decodificador9 dec_unidades (
        .sw1(unidades[3]), 
        .sw2(unidades[2]), 
        .sw3(unidades[1]), 
        .sw4(unidades[0]), 
        .salida(seg_unidades)
    );

endmodule
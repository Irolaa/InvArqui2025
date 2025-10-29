module SistemaContadorDecodificador150(
    input logic clk,       // Señal de reloj
    input logic reset,     // Señal para reiniciar el contador
    output logic [6:0] seg_centenas, // Salida para display de centenas
    output logic [6:0] seg_decenas,  // Salida para display de decenas
    output logic [6:0] seg_unidades  // Salida para display de unidades
);

    // Salida del contador (número de 8 bits, valor entre 0 y 150)
    logic [7:0] count;

    // Instancia del módulo del contador
    Adder1Automatic contador (clk,reset,count);

    // Instancia del decodificador para mostrar centenas, decenas y unidades
    Decodificador150 decodificador (count,seg_centenas,seg_decenas,seg_unidades);

endmodule


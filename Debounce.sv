module Debounce(
    input logic clk,
    input logic reset,
    input logic button_in,
    output logic button_out
);
    parameter integer DEBOUNCE_TIME = 100_000; // Ajusta según la frecuencia del reloj

    logic [19:0] counter; // Contador para el debouncing
    logic button_reg;     // Registro del estado del botón

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            button_reg <= 0;
            button_out <= 0;
        end else begin
            if (button_in != button_reg) begin
                counter <= 0; // Reinicia el contador si hay cambio
            end else if (counter < DEBOUNCE_TIME) begin
                counter <= counter + 1; // Incrementa el contador
            end else begin
                button_out <= button_in; // Establece la salida del botón
            end
            button_reg <= button_in; // Actualiza el registro del botón
        end
    end
endmodule

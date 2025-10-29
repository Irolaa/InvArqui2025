module LED_Animation (
    input logic clk,
    input logic reset,
    input logic count_reached,
    output logic [4:0] led // Salida de 5 LEDs
);

    logic [1:0] toggle_counter;    // Contador para controlar el número de repeticiones
    logic animation_active = 0;    // Señal para activar la animación
    logic [3:0] animation_step;    // Para definir los pasos de la animación

    // Divisor de frecuencia
    logic slow_clk;                // Reloj lento
    logic [23:0] div_counter;      // Ajusta el tamaño según la frecuencia deseada

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            div_counter <= 0;
        else
            div_counter <= div_counter + 1;
    end

    assign slow_clk = div_counter[23]; 

    always_ff @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            animation_active <= 0;
            toggle_counter <= 2'd0;
            led <= 5'b00000;
            animation_step <= 4'd0;
        end else if (count_reached && !animation_active) begin
            // Iniciar la animación cuando se alcance el conteo
            animation_active <= 1;
            animation_step <= 4'd1;
        end else if (animation_active) begin
            case (animation_step)
                4'd1: begin
                    led <= 5'b00001; // Encender LED 1
                    animation_step <= 4'd2;
                end
                4'd2: begin
                    led <= 5'b00011; // Encender LED 2
                    animation_step <= 4'd3;
                end
                4'd3: begin
                    led <= 5'b00111; // Encender LED 3
                    animation_step <= 4'd4;
                end
                4'd4: begin
                    led <= 5'b01111; // Encender LED 4
                    animation_step <= 4'd5;
                end
                4'd5: begin
                    led <= 5'b11111; // Encender LED 5
                    animation_step <= 4'd6;
                end
                4'd6: begin
                    led <= 5'b00000; // Apagar todos los LEDs
                    animation_step <= 4'd1; // Reiniciar la secuencia
                    toggle_counter <= toggle_counter + 1;
                    if (toggle_counter == 2'd2) begin
                        animation_active <= 0; // Desactivar la animación después de tres ciclos
                        toggle_counter <= 2'd0;
                    end
                end
            endcase
        end
    end
endmodule


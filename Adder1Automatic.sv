module Adder1Automatic (
    input logic clk,               
    input logic reset,
	 input logic select_button,
    output logic [6:0] seg_centenas, // Salida para display de centenas
    output logic [6:0] seg_decenas,  // Salida para display de decenas
    output logic [6:0] seg_unidades, // Salida para display de unidades
	 output logic count_reached,
    output logic [4:0] led          
);

    // Frecuencia del CLK de la FPGA (50,000,000 Hz)
    localparam CLK_FREQ = 26'd50_000_000; 

    logic [7:0] count;           // Contador
    logic slow_pulse_1hz;        // Pulso de 1Hz
    logic [25:0] div_counter; 

    // Bloque del Divisor de Frecuencia: genera un pulso de 1 Hz (cada 1 segundo)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            div_counter <= 26'd0;
            slow_pulse_1hz <= 1'b0; 
        end else if (div_counter == CLK_FREQ - 1) begin // Cuando llega a 49,999,999
            div_counter <= 26'd0;    
            slow_pulse_1hz <= 1'b1;  // Genera el pulso ALTO (por 1 ciclo de clk)
        end else begin
            div_counter <= div_counter + 1; 
            slow_pulse_1hz <= 1'b0;  
        end
    end

    // Instancia del decodificador 
    Decodificador150 decodificador (
        .num(count),                 
        .seg_centenas(seg_centenas), 
        .seg_decenas(seg_decenas),   
        .seg_unidades(seg_unidades)  
    );
	
    // Bloque secuencial para incrementar el contador.
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin 
            count <= 8'd0;
            count_reached <= 0;
        end else if (slow_pulse_1hz) begin // Se activa cada 1 segundo
            if (count == 8'd150) begin
                count <= 8'd0; 
                count_reached <= 1;
            end else if (select_button) begin 
                count <= count + 8'd1; // Incrementa con el pulso de 1 segundo
            end else if (~select_button) begin 
                count <= 8'd0;
                count_reached <= 0;
            end
        end else begin
            // Mantiene el estado de count_reached mientras no haya pulso de 1 segundo
            count_reached <= (count == 8'd150) ? 1 : 0; 
        end
    end
	
	
	LED_Animation led_anim (.clk(clk), .reset(reset), .count_reached(count_reached), .led(led));

endmodule
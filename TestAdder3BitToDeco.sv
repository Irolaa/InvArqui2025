module TestAdder3BitToDeco;
    // Definición de señales de prueba
    logic clk;
    logic reset;
    logic select_button;
    logic [6:0] seg_centenas;
    logic [6:0] seg_decenas;
    logic [6:0] seg_unidades;
    logic count_reached;
    logic [4:0] led;

    // Instanciación del módulo bajo prueba
    Adder10Automatic uut (
        .clk(clk),
        .reset(reset),
        .select_button(select_button),
        .seg_centenas(seg_centenas),
        .seg_decenas(seg_decenas),
        .seg_unidades(seg_unidades),
        .count_reached(count_reached),
        .led(led)
    );

    // Generación del reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Reloj con un período de 10 unidades de tiempo
    end

    // Proceso de prueba
    initial begin
        // Inicialización
        reset = 1;
        select_button = 0;
        #20 reset = 0; // Desactivar reset después de 20 unidades de tiempo

        // Test 1: Comprobar reset
        #10;
        assert(uut.count == 8'd0) else $fatal("Error: El contador no se reseteó correctamente.");
        
        // Test 2: Incremento al presionar select_button
        select_button = 1;
        #10;
        select_button = 0; // Soltar el botón
        #50; // Esperar a que el contador sume 10 en cada pulso
        assert(uut.count == 8'd10) else $fatal("Error: El contador no incrementó correctamente en 10.");

        // Test 3: Incremento hasta alcanzar 150
        repeat (14) begin
            select_button = 1;
            #10;
            select_button = 0;
            #50;
        end
        assert(uut.count == 8'd150) else $fatal("Error: El contador no alcanzó el valor esperado de 150.");
        
        // Test 4: Verificar `count_reached` al llegar a 150
        #10;
        assert(count_reached == 1) else $fatal("Error: La señal count_reached no se activó al alcanzar 150.");

        // Test 5: Comprobar el reinicio automático al superar 150
        select_button = 1;
        #10;
        select_button = 0;
        #50;
        assert(uut.count == 8'd0) else $fatal("Error: El contador no se reinició correctamente al alcanzar 150.");

        // Test 6: Reset durante conteo
        select_button = 1;
        #10 reset = 1; // Activar reset mientras se presiona el botón
        #10 reset = 0; // Desactivar reset
        #10;
        assert(uut.count == 8'd0) else $fatal("Error: El contador no se reinició correctamente con reset.");

        // Fin del test
        $display("Todas las pruebas pasaron correctamente.");
        $finish;
    end
endmodule

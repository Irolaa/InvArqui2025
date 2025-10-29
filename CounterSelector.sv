module CounterSelector(
    input logic clk,
    input logic reset,
    input logic next_button,
    input logic select_button,
	 input logic selec_A_M,
	 input logic buttonM,
    output logic [6:0] display_7seg,
    output logic [6:0] seg_centenas,
    output logic [6:0] seg_decenas,
    output logic [6:0] seg_unidades,
    output logic [4:0] led 
);
    
    // Parámetros de Display
    parameter L = 7'b1000111; // L
    parameter E = 7'b0000110; // E
    parameter U = 7'b1000001; // U

    // Variables de Estado y Pulso
    logic [6:0] current_display = L;
    
    // Detección de Pulso de Botones
    logic press = 0; 
    logic prev_select_button = 0;
    logic next_press = 0; 
    logic prev_next_button = 0;

    // Control de Selección (Mutuamente Excluyente)
    logic [2:0] active_auto_idx; 
    logic [2:0] active_manual_idx; 

    // Conexiones a los Módulos Contadores
    logic count_reached1, count_reached4, count_reached10;
    logic count_reached1M, count_reached4M, count_reached10M;
    
    logic [6:0] seg_centenas_a1, seg_decenas_a1, seg_unidades_a1;
    logic [6:0] seg_centenas_a4, seg_decenas_a4, seg_unidades_a4;
    logic [6:0] seg_centenas_a10, seg_decenas_a10, seg_unidades_a10;
    
    logic [6:0] seg_centenas_a1M, seg_decenas_a1M, seg_unidades_a1M;
    logic [6:0] seg_centenas_a4M, seg_decenas_a4M, seg_unidades_a4M;
    logic [6:0] seg_centenas_a10M, seg_decenas_a10M, seg_unidades_a10M;

    logic [4:0] led_a1, led_a4, led_a10;
    logic [4:0] led_a1M, led_a4M, led_a10M;
    
    //---------------------------------------------------------
    // Bloque 1: Generación de Señales de Pulso (Detección de Flanco)
    //---------------------------------------------------------
    always_ff @(posedge clk) begin
        // Detección de flanco de subida para select_button
        prev_select_button <= select_button; 
        if (select_button && ~prev_select_button)
            press <= 1;
        else
            press <= 0;

        // Detección de flanco de subida para next_button
        prev_next_button <= next_button; 
        if (next_button && ~prev_next_button)
            next_press <= 1;
        else
            next_press <= 0;
    end

    //---------------------------------------------------------
    // Bloque 2: Lógica de Control (Navegación y Activación de Contadores)
    //---------------------------------------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_display <= L;
            active_auto_idx <= 3'd0;
            active_manual_idx <= 3'd0;
        end else begin
            
            // 1. Lógica de Deselección (cuando se alcanza el límite)
            if (count_reached1 | count_reached4 | count_reached10) active_auto_idx <= 3'd0;
            if (count_reached1M | count_reached4M | count_reached10M) active_manual_idx <= 3'd0;
            
            // 2. Lógica de Navegación (solo si ningún contador está activo y se presiona NEXT)
            if (next_press && active_auto_idx == 3'd0 && active_manual_idx == 3'd0) begin 
                case (current_display)
                    L: current_display <= E;
                    E: current_display <= U;
                    U: current_display <= L;
                endcase
            end
            
            // 3. Lógica de Selección (solo si se presiona SELECT y ningún contador está activo)
            if (press && active_auto_idx == 3'd0 && active_manual_idx == 3'd0) begin
                if (~selec_A_M) begin // Seleccionar contador Automático
                    case (current_display)
                        L: active_auto_idx <= 3'd1; 
                        E: active_auto_idx <= 3'd2; 
                        U: active_auto_idx <= 3'd3; 
                    endcase
                end else begin // Seleccionar contador Manual
                    case (current_display)
                        L: active_manual_idx <= 3'd1; 
                        E: active_manual_idx <= 3'd2; 
                        U: active_manual_idx <= 3'd3; 
                    endcase
                end
            end
        end
    end
    
    //---------------------------------------------------------
    // Bloque 3: Instancias de Contadores
    //---------------------------------------------------------

    // Asignación de señales de activación a los contadores automáticos
    assign select1 = (active_auto_idx == 3'd1);
    assign select4 = (active_auto_idx == 3'd2);
    assign select10 = (active_auto_idx == 3'd3);

    // Asignación de señales de activación a los contadores manuales
    assign select1M = (active_manual_idx == 3'd1);
    assign select4M = (active_manual_idx == 3'd2);
    assign select10M = (active_manual_idx == 3'd3);


    Adder1Automatic adder1 (clk, reset, select1, seg_centenas_a1, seg_decenas_a1, seg_unidades_a1, count_reached1,led_a1);
    Adder4Automatic adder4 (clk, reset, select4, seg_centenas_a4, seg_decenas_a4, seg_unidades_a4,count_reached4,led_a4);
    Adder10Automatic adder10 (clk, reset, select10, seg_centenas_a10, seg_decenas_a10, seg_unidades_a10,count_reached10,led_a10);
		
	Adder1Manual adder1M (clk,reset,buttonM,select1M,seg_centenas_a1M,seg_decenas_a1M,seg_unidades_a1M,count_reached1M,led_a1M);
	Adder4Manual adder4M (clk,reset,buttonM,select4M,seg_centenas_a4M,seg_decenas_a4M,seg_unidades_a4M,count_reached4M,led_a4M);
	Adder10Manual adder10M (clk,reset,buttonM,select10M,seg_centenas_a10M,seg_decenas_a10M,seg_unidades_a10M,count_reached10M,led_a10M); 
    
    //---------------------------------------------------------
    // Bloque 4: Multiplexor de Salida (Combinacional)
    //---------------------------------------------------------
    assign display_7seg = current_display;

    always_comb begin
        // Valores por defecto
        seg_centenas = 7'b0;
        seg_decenas = 7'b0;
        seg_unidades = 7'b0;
        led = 5'b0;

        if (selec_A_M) begin // MODO MANUAL 
            case (current_display)
                L: begin 
                    seg_centenas = seg_centenas_a1M;
                    seg_decenas = seg_decenas_a1M;
                    seg_unidades = seg_unidades_a1M;
                    led = led_a1M;
                end
                E: begin 
                    seg_centenas = seg_centenas_a4M;
                    seg_decenas = seg_decenas_a4M;
                    seg_unidades = seg_unidades_a4M;
                    led = led_a4M;
                end
                U: begin 
                    seg_centenas = seg_centenas_a10M;
                    seg_decenas = seg_decenas_a10M;
                    seg_unidades = seg_unidades_a10M;
                    led = led_a10M;
                end
            endcase
        end else begin // MODO AUTOMÁTICO
            case (current_display)
                L: begin 
                    seg_centenas = seg_centenas_a1;
                    seg_decenas = seg_decenas_a1;
                    seg_unidades = seg_unidades_a1;
                    led = led_a1;
                end
                E: begin 
                    seg_centenas = seg_centenas_a4;
                    seg_decenas = seg_decenas_a4;
                    seg_unidades = seg_unidades_a4;
                    led = led_a4;
                end
                U: begin 
                    seg_centenas = seg_centenas_a10;
                    seg_decenas = seg_decenas_a10;
                    seg_unidades = seg_unidades_a10;
                    led = led_a10;
                end
            endcase
        end
    end
	
endmodule
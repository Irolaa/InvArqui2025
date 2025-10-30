module CounterSelector(
    input  logic clk,
    input  logic reset,
    input  logic next_button,
    input  logic select_button,   // NO pasa por debounce (usa 1 Hz exacto)
    input  logic selec_A_M,
    input  logic buttonM,
    output logic [6:0] display_7seg,
    output logic [6:0] seg_centenas,
    output logic [6:0] seg_decenas,
    output logic [6:0] seg_unidades,
    output logic [4:0] led 
);

    // =============================================================
    // Parámetros de Display (L, E, U)
    // =============================================================
    parameter L = 7'b1000111; // L
    parameter E = 7'b0000110; // E
    parameter U = 7'b1000001; // U

    // =============================================================
    // Señales de estado
    // =============================================================
    logic [6:0] current_display = L;
    logic [2:0] active_auto_idx;
    logic [2:0] active_manual_idx;

    // =============================================================
    // Señales limpias (solo botones físicos)
    // =============================================================
    logic next_button_clean, selec_A_M_clean, buttonM_clean;

    // Antirrebote (≈10 ms a 50 MHz)
    Debounce #(.DEBOUNCE_TIME(500_000)) db_next (
        .clk(clk), .reset(reset),
        .button_in(next_button),
        .button_out(next_button_clean)
    );

    Debounce #(.DEBOUNCE_TIME(500_000)) db_mode (
        .clk(clk), .reset(reset),
        .button_in(selec_A_M),
        .button_out(selec_A_M_clean)
    );

    Debounce #(.DEBOUNCE_TIME(500_000)) db_btnM (
        .clk(clk), .reset(reset),
        .button_in(buttonM),
        .button_out(buttonM_clean)
    );

    // =============================================================
    // Detección de flanco para select y next
    // =============================================================
    logic press = 0;
    logic next_press = 0;
    logic prev_select_button = 0;
    logic prev_next_button = 0;

    always_ff @(posedge clk) begin
        // select_button (sin debounce)
        prev_select_button <= select_button;
        if (select_button && ~prev_select_button)
            press <= 1;
        else
            press <= 0;

        // next_button (con debounce)
        prev_next_button <= next_button_clean;
        if (next_button_clean && ~prev_next_button)
            next_press <= 1;
        else
            next_press <= 0;
    end

    // =============================================================
    // Lógica de Control
    // =============================================================
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_display   <= L;
            active_auto_idx   <= 3'd0;
            active_manual_idx <= 3'd0;
        end else begin
            // 1. Deselección automática al llegar al límite
            if (count_reached1 | count_reached4 | count_reached10)
                active_auto_idx <= 3'd0;
            if (count_reached1M | count_reached4M | count_reached10M)
                active_manual_idx <= 3'd0;

            // 2. Navegación (solo si no hay contador activo)
            if (next_press && active_auto_idx == 3'd0 && active_manual_idx == 3'd0) begin
                case (current_display)
                    L: current_display <= E;
                    E: current_display <= U;
                    U: current_display <= L;
                endcase
            end

            // 3. Selección (solo si se presiona SELECT y no hay contadores activos)
            if (press && active_auto_idx == 3'd0 && active_manual_idx == 3'd0) begin
                if (~selec_A_M_clean) begin // Modo Automático
                    case (current_display)
                        L: active_auto_idx <= 3'd1;
                        E: active_auto_idx <= 3'd2;
                        U: active_auto_idx <= 3'd3;
                    endcase
                end else begin // Modo Manual
                    case (current_display)
                        L: active_manual_idx <= 3'd1;
                        E: active_manual_idx <= 3'd2;
                        U: active_manual_idx <= 3'd3;
                    endcase
                end
            end
        end
    end

    // =============================================================
    // Señales de conexión a los contadores
    // =============================================================
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

    // Selección de contadores
    logic select1, select4, select10;
    logic select1M, select4M, select10M;

    assign select1  = (active_auto_idx   == 3'd1);
    assign select4  = (active_auto_idx   == 3'd2);
    assign select10 = (active_auto_idx   == 3'd3);
    assign select1M  = (active_manual_idx == 3'd1);
    assign select4M  = (active_manual_idx == 3'd2);
    assign select10M = (active_manual_idx == 3'd3);

    // =============================================================
    // Instancias de Contadores
    // =============================================================
    Adder1Automatic  adder1  (clk, reset, select1,  seg_centenas_a1,  seg_decenas_a1,  seg_unidades_a1,  count_reached1,  led_a1);
    Adder4Automatic  adder4  (clk, reset, select4,  seg_centenas_a4,  seg_decenas_a4,  seg_unidades_a4,  count_reached4,  led_a4);
    Adder10Automatic adder10 (clk, reset, select10, seg_centenas_a10, seg_decenas_a10, seg_unidades_a10, count_reached10, led_a10);

    // Contadores manuales usan señal limpia (debounced)
    Adder1Manual  adder1M (clk, reset, buttonM_clean, select1M,  seg_centenas_a1M,  seg_decenas_a1M,  seg_unidades_a1M,  count_reached1M,  led_a1M);
    Adder4Manual  adder4M (clk, reset, buttonM_clean, select4M,  seg_centenas_a4M,  seg_decenas_a4M,  seg_unidades_a4M,  count_reached4M,  led_a4M);
    Adder10Manual adder10M(clk, reset, buttonM_clean, select10M, seg_centenas_a10M, seg_decenas_a10M, seg_unidades_a10M, count_reached10M, led_a10M);

    // =============================================================
    // Multiplexor de salida
    // =============================================================
    assign display_7seg = current_display;

    always_comb begin
        seg_centenas = 7'b0;
        seg_decenas  = 7'b0;
        seg_unidades = 7'b0;
        led          = 5'b0;

        if (selec_A_M_clean) begin // MODO MANUAL
            case (current_display)
                L: begin 
                    seg_centenas = seg_centenas_a1M;
                    seg_decenas  = seg_decenas_a1M;
                    seg_unidades = seg_unidades_a1M;
                    led = led_a1M;
                end
                E: begin 
                    seg_centenas = seg_centenas_a4M;
                    seg_decenas  = seg_decenas_a4M;
                    seg_unidades = seg_unidades_a4M;
                    led = led_a4M;
                end
                U: begin 
                    seg_centenas = seg_centenas_a10M;
                    seg_decenas  = seg_decenas_a10M;
                    seg_unidades = seg_unidades_a10M;
                    led = led_a10M;
                end
            endcase
        end else begin // MODO AUTOMÁTICO
            case (current_display)
                L: begin 
                    seg_centenas = seg_centenas_a1;
                    seg_decenas  = seg_decenas_a1;
                    seg_unidades = seg_unidades_a1;
                    led = led_a1;
                end
                E: begin 
                    seg_centenas = seg_centenas_a4;
                    seg_decenas  = seg_decenas_a4;
                    seg_unidades = seg_unidades_a4;
                    led = led_a4;
                end
                U: begin 
                    seg_centenas = seg_centenas_a10;
                    seg_decenas  = seg_decenas_a10;
                    seg_unidades = seg_unidades_a10;
                    led = led_a10;
                end
            endcase
        end
    end

endmodule

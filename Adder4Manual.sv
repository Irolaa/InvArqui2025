
  module Adder4Manual (
	 input clk,	
    input logic reset,
	 input buttonM,
	 input logic selec,
    output logic [6:0] seg_centenas, // Salida para display de centenas
    output logic [6:0] seg_decenas,  // Salida para display de decenas
    output logic [6:0] seg_unidades,  // Salida para display de unidades
	 output logic count_reached,
    output logic [4:0] led    
);

    logic [7:0] count;       // Señal del contador de 8 bits
    
	Decodificador150 decodificador (count, seg_centenas, seg_decenas, seg_unidades);
	

	always @(posedge buttonM or posedge reset) begin
        if (reset) begin 
            count <= 8'd0;
				count_reached = 0;
        end else if (~selec)begin
				count <= 8'd0;
				count_reached = 0;
		  end else if (count >= 8'd150) begin 
            count <= 8'd0;
				count_reached = 1;
        end else if(selec)begin 
				count_reached = 0;
				count <= count + 8'd4;
        end else begin 
				count_reached = 0;
		  end	
		  
    end
	 
	 
	 LED_Animation led_anim (clk,reset,count_reached,led);

endmodule



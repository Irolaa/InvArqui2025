module Decodificador9(input sw1, sw2, sw3, sw4, output [6:0]salida);

assign salida[0] = ~((~sw1 & ~sw2 & ~sw3 & ~sw4) | (~sw1 & ~sw2 & sw3 & ~sw4) | (~sw1 & ~sw2 & sw3 & sw4) | (~sw1 & sw2 & ~sw3 & sw4) | (~sw1 & sw2 & sw3 & ~sw4) | (~sw1 & sw2 & sw3 & sw4) |(sw1 & ~sw2 & ~sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & sw4));

assign salida[1] = ~((~sw1 & ~sw2 & ~sw3 & ~sw4) | (~sw1 & ~sw2 & ~sw3 & sw4) | (~sw1 & ~sw2 & sw3 & ~sw4) | (~sw1 & ~sw2 & sw3 & sw4) | (~sw1 & sw2 & ~sw3 & ~sw4) | (~sw1 & sw2 & sw3 & sw4) | (sw1 & ~sw2 & ~sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & sw4));

assign salida[2] = ~((~sw1 & ~sw2 & ~sw3 & ~sw4) | (~sw1 & ~sw2 & ~sw3 & sw4) |(~sw1 & ~sw2 & sw3 & sw4) | (~sw1 & sw2 & ~sw3 & ~sw4) | (~sw1 & sw2 & ~sw3 & sw4) | (~sw1 & sw2 & sw3 & ~sw4) | (~sw1 & sw2 & sw3 & sw4) | (sw1 & ~sw2 & ~sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & sw4));

assign salida[3] = ~((~sw1 & ~sw2 & ~sw3 & ~sw4) | (~sw1 & ~sw2 & sw3 & ~sw4) | (~sw1 & ~sw2 & sw3 & sw4)  |(~sw1 & sw2 & ~sw3 & sw4)| (~sw1 & sw2 & sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & ~sw4));

assign salida[4] = ~((~sw1 & ~sw2 & ~sw3 & ~sw4) | (~sw1 & ~sw2 & sw3 & ~sw4) | (~sw1 & sw2 & sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & ~sw4));

assign salida[5] = ~((~sw1 & ~sw2 & ~sw3 & ~sw4) | (~sw1 & sw2 & ~sw3 & ~sw4) | (~sw1 & sw2 & ~sw3 & sw4) | (~sw1 & sw2 & sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & sw4));

assign salida[6] =~((~sw1 & ~sw2 & sw3 & ~sw4) | (~sw1 & ~sw2 & sw3 & sw4) | (~sw1 & sw2 & ~sw3 & ~sw4) | (~sw1 & sw2 & ~sw3 & sw4) | (~sw1 & sw2 & sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & ~sw4) | (sw1 & ~sw2 & ~sw3 & sw4));

endmodule

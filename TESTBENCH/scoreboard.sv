module convseriones();
  import "DPI-C" function int unsigned signo(input shortreal flotante);
  import "DPI-C" function int unsigned exponente(input shortreal flotante);
  import "DPI-C" function int unsigned mantisa(input shortreal flotante);
  import "DPI-C" function shortreal flotante(input int unsigned signo, input int unsigned exponente, input int unsigned mantisa);

endmodule


class scoreboard;
  logic [7:0] store [$];
endclass

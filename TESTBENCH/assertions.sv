`define DUV_PATH top.dut

module whitebox();
/*
  fpu dut (
    .clk(clk),
    .rmode(intf.rmode),
    .fpu_op(intf.fpu_op),
    .opa(intf.opa),
    .opb(intf.opb),
    .out(intf.out),
    .inf(intf.inf),
    .snan(intf.snan),
    .qnan(intf.qnan),
    .ine(intf.ine),
    .overflow(intf.overflow),
    .underflow(intf.underflow),
    .zero(intf.zero),
    .div_by_zero(intf.div_by_zero)
  );
*/
//Constantes

parameter infinito = 32'h7F800000;
parameter cero = 32'h00000000;
parameter suma = 8'b000;
parameter resta = 8'b001;
parameter multi = 8'b010;
parameter divi = 8'b011;
parameter NumMax = 32'h7F7FFFFF;
parameter NumMin = 32'h00000001;
parameter holis = ((`DUV_PATH.opb == cero) && (`DUV_PATH.fpu_op == divi));

//******************Aserciones**************************

  //Inmediate assertion
 /* 
  always_comb begin //division por zero
    a0: assert ((`DUV_PATH.opb == cero) && (`DUV_PATH.fpu_op == divi));
  end

    property a_p_1;
    @(negedge `DUV_PATH.clk)
    disable iff (($isunknown(`DUV_PATH.div_by_zero)==0) ||`DUV_PATH.div_by_zero == 0)
    (`DUV_PATH.opb == cero) && (`DUV_PATH.fpu_op == divi)==1;
    endproperty

  always_comb begin //division por zero
    a1: assert (!((`DUV_PATH.opb == cero) && (`DUV_PATH.fpu_op == divi) && (`DUV_PATH.div_by_zero == 1)));
  end
  */
    property a1;
    //disable iff(((`DUV_PATH.opb === cero) && (`DUV_PATH.fpu_op == divi))==0)
    disable iff(`DUV_PATH.div_by_zero == 0)
    @(posedge `DUV_PATH.clk) (((`DUV_PATH.opb == cero) && (`DUV_PATH.fpu_op == divi)))&& (`DUV_PATH.div_by_zero == 1);
    //@(posedge `DUV_PATH.clk)  $rose(holis==1) |-> ##4 $`DUV_PATH.div_by_zero == 1;
    endproperty

    assert_a1: assert property (a1);

  always_comb begin //A=-B, fpu_op = sum => Zero = 1
    a2: assert ((`DUV_PATH.opa == -(`DUV_PATH.opb)) && (`DUV_PATH.fpu_op == suma) && (`DUV_PATH.zero == 1)); // consultar 
  end

  always_comb begin //A = B => A-B=0 => Zero = 1
    a3: assert ((`DUV_PATH.opa == `DUV_PATH.opb) && (`DUV_PATH.fpu_op == resta) && (`DUV_PATH.zero == 1));
  end

  always_comb begin //A = 0 ó B = 0, fpu_op = mul => Zero = 1
    a4: assert (((`DUV_PATH.opa == cero) ||(`DUV_PATH.opb == cero)) && (`DUV_PATH.fpu_op == multi) && (`DUV_PATH.zero == 1));
  end
 
  always_comb begin // A = 0, B = cont !=0,fpu_op = div => Zero = 1
    a5: assert ((`DUV_PATH.opa == cero) && (`DUV_PATH.fpu_op == divi) && (`DUV_PATH.zero == 1));
  end

  always_comb begin // ninguna bandera puede ser XXXXX ó Z
    a6: assert (!($isunknown(`DUV_PATH.inf)||$isunknown(`DUV_PATH.snan)||$isunknown(`DUV_PATH.qnan)||$isunknown(`DUV_PATH.ine)||$isunknown(`DUV_PATH.overflow)||$isunknown(`DUV_PATH.underflow)||$isunknown(`DUV_PATH.zero)||$isunknown(`DUV_PATH.div_by_zero)));
  end
/*
  always_comb begin //si A o B cambia y el operador no cambia, resultado debe cambiar.
    a7: assert ();
  end

  always_comb begin // el reloj siempre debe correr
    a8: assert ();
  end
*/
  always_comb begin //inf+-const = inf
    a9: assert (((`DUV_PATH.opa == infinito) && (`DUV_PATH.opb != infinito)) && ((`DUV_PATH.fpu_op == suma)||(`DUV_PATH.fpu_op == resta)) && (`DUV_PATH.inf == 1));
  end

  always_comb begin//const+-inf = inf
    a10: assert (((`DUV_PATH.opa != infinito) && (`DUV_PATH.opb == infinito)) && ((`DUV_PATH.fpu_op == suma)||(`DUV_PATH.fpu_op == resta)) && (`DUV_PATH.inf == 1));
  end

  always_comb begin//inf*const = inf; const !=0
    a11: assert (((`DUV_PATH.opa == infinito) && ((`DUV_PATH.opb != infinito)&&(`DUV_PATH.opb != cero))) && (`DUV_PATH.fpu_op == multi) && (`DUV_PATH.inf == 1));
  end

  always_comb begin//const*inf = inf; const !=0
    a12: assert ((((`DUV_PATH.opa != infinito)&&(`DUV_PATH.opa != cero)) && (`DUV_PATH.opb == infinito)) && (`DUV_PATH.fpu_op == multi) && (`DUV_PATH.inf == 1));
  end

  always_comb begin//inf/const = inf; const !=0
    a13: assert (((`DUV_PATH.opa == infinito) && ((`DUV_PATH.opb != infinito)&&(`DUV_PATH.opb != cero))) && (`DUV_PATH.fpu_op == divi) && (`DUV_PATH.inf == 1));
  end

  always_comb begin //inf*0 ó 0*inf = NaN
    a14: assert (( ((`DUV_PATH.opa == cero)&&(`DUV_PATH.opb == infinito)) || ((`DUV_PATH.opa == infinito)&&(`DUV_PATH.opb == cero)) ) && (`DUV_PATH.fpu_op == multi) && (`DUV_PATH.qnan == 1));
  end

  always_comb begin // +-inf+-inf = NaN
    a15: assert (((`DUV_PATH.opa == infinito)&&(`DUV_PATH.opb == infinito)) && ((`DUV_PATH.fpu_op == suma)||(`DUV_PATH.fpu_op == resta)) && (`DUV_PATH.qnan == 1));
  end

  always_comb begin// +-inf / +-inf = NaN
    a16: assert (((`DUV_PATH.opa == infinito)&&(`DUV_PATH.opb == infinito)) && (`DUV_PATH.fpu_op == divi) && (`DUV_PATH.qnan == 1));
  end

  always_comb begin //0/0 = NaN
    a17: assert (((`DUV_PATH.opa == cero)&&(`DUV_PATH.opb == cero)) && (`DUV_PATH.fpu_op == divi) && (`DUV_PATH.qnan == 1));
  end

  always_comb begin // Si resultado es mayor a NumMax, overflow =1
    a18: assert ((`DUV_PATH.out <= NumMax)&& (`DUV_PATH.overflow == 1)); // consulta
  end

  always_comb begin //Si resultado es menor que NumMin underflow = 1
    a19: assert ((`DUV_PATH.out >= NumMin) && (`DUV_PATH.overflow == 1));// consulta
  end

  always_comb begin // underflow no puede ser igual que overflow cuando son 1
    a20: assert (!((`DUV_PATH.overflow == 1)&&(`DUV_PATH.underflow == 1)));
  end


  property empty_p_0;
    @(posedge `DUV_PATH.clk)
    disable iff ($isunknown(`DUV_PATH.out))
    (`DUV_PATH.overflow != `DUV_PATH.underflow ) == 1;
  endproperty

    
endmodule


  
`define DUV_PATH top.dut

module assertions();

//---------------------------------------
  //clock signal declaration
  //---------------------------------------
  reg clk_aux = 0;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  initial 
  forever #5 clk_aux = ~clk_aux;

//Constantes

parameter infinito = 32'h7F800000;
parameter cero = 32'h00000000;
parameter suma = 8'b000;
parameter resta = 8'b001;
parameter multi = 8'b010;
parameter divi = 8'b011;
parameter NumMax = 32'h7F7FFFFF;
parameter NumMin = 32'h00000001;
parameter uno = 32'h3F800000;

//******************Aserciones**************************


property a1;
//disable iff(((`DUV_PATH.opb === cero) && (`DUV_PATH.fpu_op == divi))==0)
@(negedge `DUV_PATH.clk) ((`DUV_PATH.opb == cero) && (`DUV_PATH.fpu_op == divi)) |-> ##[2:10] $rose(`DUV_PATH.div_by_zero);
endproperty
assert_a1: assert property (a1);

//GENERAR CASO    
property a2; //A=-B, fpu_op = sum => Zero = 1
@(negedge `DUV_PATH.clk) (((`DUV_PATH.opa[31]) == !(`DUV_PATH.opb[31]))&& ((`DUV_PATH.opa[30:0]) == (`DUV_PATH.opb[30:0])) && (`DUV_PATH.fpu_op == suma))|-> ##[2:10] $rose(`DUV_PATH.zero);
endproperty
assert_a2: assert property (a2);


property a3; //A = B => A-B=0 => Zero = 1 
@(negedge `DUV_PATH.clk) ((`DUV_PATH.opa == `DUV_PATH.opb) && (`DUV_PATH.fpu_op == resta)) |-> ##[2:10] $rose(`DUV_PATH.zero);
endproperty
assert_a3: assert property (a3);


property a4; //A = 0 ó B = 0, fpu_op = mul => Zero = 1
@(negedge `DUV_PATH.clk) (((`DUV_PATH.opa == cero) ||(`DUV_PATH.opb == cero)) && (`DUV_PATH.fpu_op == multi)) |-> ##[2:10] $rose(`DUV_PATH.zero);
endproperty
assert_a4: assert property (a4);

property a5; // A = 0, B = cont !=0,fpu_op = div => Zero = 1
@(negedge `DUV_PATH.clk) ((`DUV_PATH.opa == cero) &&(`DUV_PATH.opb != cero)&& (`DUV_PATH.fpu_op == divi)) |-> ##[2:10] $rose(`DUV_PATH.zero);
endproperty
assert_a5: assert property (a5);


always_comb begin // ninguna bandera puede ser XXXXX ó Z
a6: assert (!($isunknown(`DUV_PATH.inf)||$isunknown(`DUV_PATH.snan)||$isunknown(`DUV_PATH.qnan)||$isunknown(`DUV_PATH.ine)||$isunknown(`DUV_PATH.overflow)||$isunknown(`DUV_PATH.underflow)||$isunknown(`DUV_PATH.zero)||$isunknown(`DUV_PATH.div_by_zero)));
end

property a8; // el reloj siempre debe correr
@(posedge clk_aux) (`DUV_PATH.clk == clk_aux);
endproperty
assert_a8: assert property (a8);

property clk_hi; 
      time v; 
      @(posedge `DUV_PATH.clk) (1, v=$time) |-> @(negedge `DUV_PATH.clk) ($time-v)==5ns;
    endproperty 
    clk_hi_a8: assert property(clk_hi);  

property clk_lo; 
  time v; 
  @(negedge `DUV_PATH.clk) (1, v=$time) |-> @(posedge `DUV_PATH.clk) ($time-v)==5ns;
endproperty 
clk_lo_a8: assert property(clk_lo); 

property a9; //inf+-const = inf
@(negedge `DUV_PATH.clk)  (((`DUV_PATH.opa == infinito) && (`DUV_PATH.opb != infinito)) && ((`DUV_PATH.fpu_op == suma)||(`DUV_PATH.fpu_op == resta))) |-> ##[2:10] $rose(`DUV_PATH.inf);
endproperty
assert_a9: assert property (a9);

property a10; //const+-inf = inf
@(negedge `DUV_PATH.clk) (((`DUV_PATH.opa != infinito) && (`DUV_PATH.opb == infinito)) && ((`DUV_PATH.fpu_op == suma)||(`DUV_PATH.fpu_op == resta))) |-> ##[2:10] $rose(`DUV_PATH.inf);
endproperty
assert_a10: assert property (a10);

property a11;//inf*const = inf; const !=0
@(negedge `DUV_PATH.clk) (((`DUV_PATH.opa == infinito) && ((`DUV_PATH.opb != infinito)&&(`DUV_PATH.opb != cero))) && (`DUV_PATH.fpu_op == multi)) |-> ##[2:10] $rose(`DUV_PATH.inf);
endproperty
assert_a11: assert property (a11);

property a12;//inf*const = inf; const !=0
@(negedge `DUV_PATH.clk) ((((`DUV_PATH.opa != infinito)&&(`DUV_PATH.opa != cero)) && (`DUV_PATH.opb == infinito)) && (`DUV_PATH.fpu_op == multi)) |-> ##[2:10] $rose(`DUV_PATH.inf);
endproperty
assert_a12: assert property (a12);

property a13;//inf/const = inf; const !=0
@(negedge `DUV_PATH.clk) ((`DUV_PATH.opa == infinito) && ((`DUV_PATH.opb != infinito)&&(`DUV_PATH.opb != cero))) && (`DUV_PATH.fpu_op == divi) |-> ##[2:10] $rose(`DUV_PATH.inf);
endproperty
assert_a13: assert property (a13);

property a14; //inf*0 ó 0*inf = NaN
@(negedge `DUV_PATH.clk)  (( ((`DUV_PATH.opa == cero)&&(`DUV_PATH.opb == infinito)) || ((`DUV_PATH.opa == infinito)&&(`DUV_PATH.opb == cero)) ) && (`DUV_PATH.fpu_op == multi)) |-> ##[2:10] $rose(`DUV_PATH.qnan);
endproperty
assert_a14: assert property (a14);

property a15; // +-inf+-inf = NaN
@(negedge `DUV_PATH.clk)  (((`DUV_PATH.opa == infinito)&&(`DUV_PATH.opb == infinito)) && ((`DUV_PATH.fpu_op == suma)||(`DUV_PATH.fpu_op == resta))) |-> ##[2:10] $rose(`DUV_PATH.qnan);
endproperty
assert_a15: assert property (a15);

property a16;// +-inf / +-inf = NaN
@(negedge `DUV_PATH.clk) (((`DUV_PATH.opa == infinito)&&(`DUV_PATH.opb == infinito)) && (`DUV_PATH.fpu_op == divi)) |-> ##[2:10] $rose(`DUV_PATH.qnan);
endproperty
assert_a16: assert property (a16);

property a17; //0/0 = NaN
@(negedge `DUV_PATH.clk) (((`DUV_PATH.opa == cero)&&(`DUV_PATH.opb == cero)) && (`DUV_PATH.fpu_op == divi))  |-> ##[2:10] $rose(`DUV_PATH.qnan);
endproperty
assert_a17: assert property (a17);

property a18; // Si resultado es mayor a NumMax, overflow =1
@(negedge `DUV_PATH.clk) ((`DUV_PATH.opa == NumMax)&&(`DUV_PATH.opb <= NumMax)&&((`DUV_PATH.fpu_op == multi)||(`DUV_PATH.fpu_op == suma))) |-> ##[2:10] $rose(`DUV_PATH.overflow); // consulta
endproperty
assert_a18: assert property (a18);

property a19; // Si resultado es mayor a NumMax, overflow =1
@(negedge `DUV_PATH.clk) ((`DUV_PATH.opa >= uno)&&(`DUV_PATH.opb == NumMax)&&((`DUV_PATH.fpu_op == multi)||(`DUV_PATH.fpu_op == suma))) |-> ##[2:10] $rose(`DUV_PATH.overflow); // consulta
endproperty
assert_a19: assert property (a19);

property a20;//Si resultado es menor que NumMin underflow = 1
@(negedge `DUV_PATH.clk) ((`DUV_PATH.opa == NumMin)&&(`DUV_PATH.opa >= NumMin)&&((`DUV_PATH.fpu_op == divi)||(`DUV_PATH.opa == resta))) |-> ##[2:10] $rose(`DUV_PATH.underflow);
endproperty
assert_a20: assert property (a20);

always_comb begin // underflow no puede ser igual que overflow cuando son 1
a21: assert (!((`DUV_PATH.overflow == 1)&&(`DUV_PATH.underflow == 1)));
end


endmodule

interface fpu_intf(input clk);
  
  //---------------------------------------
  //declaring the signals
  //---------------------------------------
  logic [1:0] rmode;
  logic [2:0] fpu_op;
  logic [31:0] opa;
  logic [31:0] opb;
  logic [31:0] out;
  logic inf;
  logic snan;
  logic qnan;
  logic ine; 
  logic overflow; 
  logic underflow; 
  logic zero; 
  logic div_by_zero; 

endinterface

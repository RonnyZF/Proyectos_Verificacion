class stimulus;
  rand  logic[31:0] opa;
  rand  logic[31:0] opb;
  rand  logic[2:0] fpu_op; 
  rand  logic[1:0] rmode;
  
  constraint const_opa {opa inside {[0:50]}; }  
  constraint const_opb {opb inside {[0:50]}; }  
  constraint const_fpu_op {fpu_op inside {[0:3]}; }  
endclass

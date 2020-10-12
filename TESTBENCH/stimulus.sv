class stimulus;
  rand  logic[31:0] opa;
  rand  logic[31:0] opb;
  
  constraint const_opa {opa inside {[0:50]}; }  
  constraint const_opb {opb inside {[0:50]}; }  
endclass

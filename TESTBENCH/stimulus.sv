class stimulus;
  rand  logic[31:0] opa;
  rand  logic[31:0] opb;
  rand integer delay;
  
  constraint const_delay {delay inside {[20:50]}; }  
endclass

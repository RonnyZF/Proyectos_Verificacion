class stimulus;
  //rand  logic[31:0] opa;
  //rand  logic[31:0] opb;

  logic[31:0] opa = 32'd2;
  logic[31:0] opb = 32'd3;
  rand integer delay;
  
  constraint const_delay {delay inside {[20:50]}; }  
endclass

class stimulus;
  rand  shortreal opa;
  rand  shortreal opb;
 
  constraint const_opa {opa inside {[0:50]}; }  
  constraint const_opb {opb inside {[0:50]}; } 
endclass

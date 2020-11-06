class stimulus;
  rand logic sign1;
  rand logic sign2;
  rand logic[7:0] exp1;
  rand logic[7:0] exp2;
  rand logic[22:0] mantissa1;
  rand logic[22:0] mantissa2;
  rand  logic[2:0] fpu_op; 
  rand  logic[1:0] rmode;
	
  constraint const_sign1 {sign1 inside {[0:1]}; }
  constraint const_sign2 {sign2 inside {[0:1]}; }  
  constraint const_exp1 {exp1 inside {[0:255]}; }
  constraint const_exp2 {exp2 inside {[0:255]}; }
  constraint const_mantissa1 {mantissa1 inside {[0:8388607]}; }
  constraint const_mantissa2 {mantissa2 inside {[0:8388607]}; }  
  constraint const_fpu_op {fpu_op inside {[0:3]}; }  
  constraint const_rmode {rmode inside {[0:0]}; }  
endclass

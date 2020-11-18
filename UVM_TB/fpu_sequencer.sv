//-------------------------------------------------------------------------
//						fpu_sequencer - www.verificationguide.com
//-------------------------------------------------------------------------

class fpu_sequencer extends uvm_sequencer#(fpu_seq_item);

  `uvm_component_utils(fpu_sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
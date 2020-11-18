//-------------------------------------------------------------------------
//						fpu_env - www.verificationguide.com
//-------------------------------------------------------------------------

`include "fpu_agent.sv"
`include "fpu_scoreboard.sv"

class fpu_model_env extends uvm_env;
  
  //---------------------------------------
  // agent and scoreboard instance
  //---------------------------------------
  fpu_agent      fpu_agnt;
  fpu_scoreboard fpu_scb;
  
  `uvm_component_utils(fpu_model_env)
  
  //--------------------------------------- 
  // constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - crate the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    fpu_agnt = fpu_agent::type_id::create("fpu_agnt", this);
    fpu_scb  = fpu_scoreboard::type_id::create("fpu_scb", this);
  endfunction : build_phase
  
  //---------------------------------------
  // connect_phase - connecting monitor and scoreboard port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    fpu_agnt.monitor.item_collected_port.connect(fpu_scb.item_collected_export);
  endfunction : connect_phase

endclass : fpu_model_env
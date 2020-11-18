//-------------------------------------------------------------------------
//						fpu_write_read_test - www.verificationguide.com 
//-------------------------------------------------------------------------
class fpu_wr_rd_test extends fpu_model_base_test;

  `uvm_component_utils(fpu_wr_rd_test)
  
  //---------------------------------------
  // sequence instance 
  //--------------------------------------- 
  //wr_rd_sequence seq;
  wr_rd_sequence seq;

  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "fpu_wr_rd_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the sequence
    //seq = wr_rd_sequence::type_id::create("seq");
    seq = wr_rd_sequence::type_id::create("seq");
  endfunction : build_phase
  
  //---------------------------------------
  // run_phase - starting the test
  //---------------------------------------
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
      seq.start(env.fpu_agnt.sequencer);
    phase.drop_objection(this);
    
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase
  
endclass : fpu_wr_rd_test
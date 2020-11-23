class fpu_item extends uvm_sequence_item;

  rand logic[31:0] opa, opb;
  rand logic[31:0] out;

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

  //assign opa = {sign1, exp1, mantissa1};
  //assign opb = {sign2, exp2, mantissa2};   

  // Use utility macros to implement standard functions
  // like print, copy, clone, etc
  `uvm_object_utils_begin(fpu_item)
  `uvm_field_int (opa, UVM_DEFAULT)
  `uvm_field_int (opb, UVM_DEFAULT)
  `uvm_field_int (out, UVM_DEFAULT)
  `uvm_field_int (fpu_op, UVM_DEFAULT)
  `uvm_field_int (rmode, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "fpu_item");
    super.new(name);
  endfunction
endclass

class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)
  function new(string name="gen_item_seq");
    super.new(name);
  endfunction

  rand int num; 	// Config total number of items to be sent

  constraint c1 { num inside {10}; }

  virtual task body();
    fpu_item f_item = fpu_item::type_id::create("f_item");
    for (int i = 0; i < num; i ++) begin
      //start_item(f_item);
    	//f_item.randomize();
    	//`uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
    	//f_item.print();
      //finish_item(f_item);
      `uvm_do(f_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass


class fpu_driver extends uvm_driver #(fpu_item);

  `uvm_component_utils (fpu_driver)
  function new (string name = "fpu_driver", uvm_component parent = null);
    super.new (name, parent);
  endfunction

  virtual fpu_intf intf;

  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
  endfunction
   
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      fpu_item f_item;
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(f_item);
      fork
        operation(f_item);
        //overflow(f_item);
        //div_zero(f_item);
      join
      seq_item_port.item_done();
    end
  endtask  

  task operation(fpu_item f_item);
    begin
      $display("TASK OPERATION\n");
      @ (negedge intf.clk);
      intf.opa = f_item.opa;
      intf.opb = f_item.opb;
      intf.fpu_op = f_item.fpu_op;
      intf.rmode = f_item.rmode;
    end
     @ (negedge intf.clk);
  endtask

  task overflow(fpu_item f_item);
    begin
      @ (negedge intf.clk);
      intf.opa = 32'h7F7FFFFF;
      intf.opb = f_item.opb;
      intf.fpu_op = 3'b010;
      intf.rmode = f_item.rmode;
    end
     @ (negedge intf.clk);
  endtask

  task div_zero(fpu_item f_item);
    begin
      @ (negedge intf.clk);
      intf.opa = f_item.opa;
      intf.opb = 32'h00000000;
      intf.fpu_op = 3'b011;
      intf.rmode = f_item.rmode;
    end
     @ (negedge intf.clk);
  endtask    
  
endclass

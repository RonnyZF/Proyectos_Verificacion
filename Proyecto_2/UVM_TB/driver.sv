class fpu_item extends uvm_sequence_item;

  //rand logic [7:0] data;
  //rand bit   rd;
  rand logic[31:0] opa, opb;
  rand logic[2:0] fpu_op;
  rand logic[1:0] rmode;

  // Use utility macros to implement standard functions
  // like print, copy, clone, etc
  `uvm_object_utils_begin(fpu_item)
    `uvm_field_int (data, UVM_DEFAULT)
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

  constraint c1 { num inside {[2:5]}; }

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
        //drive_fpu(f_item);
        //read_fpu(f_item);
        operation(f_item);
        overflow(f_item);
        div_zero(f_item);
      join
      seq_item_port.item_done();
    end
  endtask  

  task operation(fpu_item f_item);
    //repeat(iteration)
    begin
      $display("TASK OPERATION\n");
      //sti = new();
      @ (negedge intf.clk);
      intf.opa = f_item.opa;
      intf.opb = f_item.opb;
      intf.fpu_op = f_item.fpu_op;
      intf.rmode = f_item.rmode;
      //if(sti.randomize()) // Generate stimulus
        //$display("decimal opa = %d and opb = %d in the DUT\n", sti.opa, sti.opb);
        //opa = {sti.sign1, sti.exp1, sti.mantissa1};
        //opb = {sti.sign2, sti.exp2, sti.mantissa2};
        //intf.opa = opa; // Drive to DUT
        //intf.opb = opb; // Drive to DUT
        //$display("IEEE754 opa = %h and opb = %h in the DUT\n", intf.opa, intf.opb);
        //intf.fpu_op = sti.fpu_op;
      	//intf.rmode = sti.rmode;
      //sb.opa.push_front(opa);// Cal exp value and store in Scoreboard
      //sb.opb.push_front(opb);// Cal exp value and store in Scoreboard
      //sb.fpu_op.push_front(sti.fpu_op);// Cal exp value and store in Scoreboard
      //sb.rmode.push_front(sti.rmode);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);
  endtask

  task overflow(fpu_item f_item);
    //repeat(iteration)
    begin
      //sti = new();
      @ (negedge intf.clk);
      intf.opa = 32'h7F7FFFFF;
      intf.opb = f_item.opb;
      intf.fpu_op = 3'b010;
      intf.rmode = f_item.rmode;
      //if(sti.randomize()) // Generate stimulus
        //$display("decimal opa = %d and opb = %d in the DUT\n", sti.opa, sti.opb);
        //opb = {sti.sign2, sti.exp2, sti.mantissa2};
        //intf.opa = 32'h7F7FFFFF; // Drive to DUT
        //intf.opb = opb; // Drive to DUT
        //$display("IEEE754 opa = %h and opb = %h in the DUT\n", intf.opa, intf.opb);
        //intf.fpu_op = 3'b010;
        //intf.rmode = sti.rmode;
        //$display("FPU_OP = %d and RMODE = %d \n", sti.fpu_op, sti.rmode);
      //sb.opa.push_front(intf.opa);// Cal exp value and store in Scoreboard
      //sb.opb.push_front(intf.opb);// Cal exp value and store in Scoreboard
      //sb.fpu_op.push_front(sti.fpu_op);// Cal exp value and store in Scoreboard
      //sb.rmode.push_front(sti.rmode);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);
  endtask

  task div_zero(fpu_item f_item);
    //repeat(iteration)
    begin
      //sti = new();
      @ (negedge intf.clk);
      intf.opa = f_item.opa;
      intf.opb = 32'h00000000;
      intf.fpu_op = 3'b011;
      intf.rmode = f_item.rmode;
      //if(sti.randomize()) // Generate stimulus
        //opa = {sti.sign1, sti.exp1, sti.mantissa1};
        //intf.opa = opa; // Drive to DUT
        //intf.opb = 32'h00000000;
        //intf.fpu_op = 3'b011;
        //intf.rmode = sti.rmode;
      //sb.opa.push_front(intf.opa);// Cal exp value and store in Scoreboard
      //sb.opb.push_front(intf.opb);// Cal exp value and store in Scoreboard
      //sb.fpu_op.push_front(sti.fpu_op);// Cal exp value and store in Scoreboard
      //sb.rmode.push_front(sti.rmode);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);
  endtask

/*
  virtual task drive_fpu(fpu_item f_item);
       
     @ (negedge intf.clk);
     $display("Driving 0x%h value in the DUT\n", f_item.data);
     intf.data_in = f_item.data; // Drive to DUT
     intf.wr_en = 1;
     @ (negedge intf.clk);
     intf.wr_en = 0;
  endtask
  
  virtual task read_fpu(fpu_item f_item);
    if(f_item.rd ==1)
      begin
        @ (negedge intf.clk);
        intf.rd_en = 1;
        @ (negedge intf.clk);
        intf.rd_en = 0;
      end
  endtask
       
  virtual task fpu_reset();  // Reset method
    $display("Executing Reset\n");
    intf.data_in = 0;
    intf.rst = 0;
    intf.wr_cs = 0;
    intf.rd_cs = 0;
    intf.data_in = 0;
    intf.rd_en = 0;
    intf.wr_en = 0;
    intf.rst = 1;
    @ (negedge intf.clk);
    intf.rst = 0;
    @ (negedge intf.clk);
    intf.wr_cs = 1;
    intf.rd_cs = 1;

  endtask
*/      
  
endclass

class test_basic2 extends test_basic;

  `uvm_component_utils(test_basic2)
  
  function new (string name="test_basic2", uvm_component parent=null);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
  	 
     // Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
    
    //factory to override 'base_agent' by 'child_agent' by name
    factory.set_type_override_by_name("gen_item_seq", "gen_item_seq2");

    // Print factory configuration
    factory.print();
  endfunction

endclass

class gen_item_seq2 extends gen_item_seq;
  `uvm_object_utils(gen_item_seq2)
  function new(string name="gen_item_seq2");
    super.new(name);
  endfunction
  
  int num = 30; 	// Config total number of items to be sent

  //constraint c1 { num inside {[20:50]}; }
  
  virtual task body();
     fpu_item f_item = fpu_item::type_id::create("f_item");
	

    for (int i = 0; i < num; i ++) begin

    // Asercion 1
      `uvm_do(f_item,,,{f_item.opb==0;f_item.fpu_op==3;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 2
      `uvm_do(f_item,,,{f_item.opa==32'h3FA00000;f_item.opb==32'hBFA00000;f_item.fpu_op==0;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 3
      $display("Aqui inicia asercion 3");
      `uvm_do(f_item,,,{f_item.opa==32'h3FA00000;f_item.opb==32'h3FA00000;f_item.fpu_op==1;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})  
    // Asercion 4a
      `uvm_do(f_item,,,{f_item.opa==0;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})   
    // Asercion 4b
      `uvm_do(f_item,,,{f_item.opb==0;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})    
    // Asercion 5
      `uvm_do(f_item,,,{f_item.opa==0;f_item.opb==2;f_item.fpu_op==3;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 9+
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.fpu_op==0;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.fpu_op==0;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})    
    // Asercion 9-
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.fpu_op==1;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.fpu_op==1;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 10+
        `uvm_do(f_item,,,{f_item.opb==32'h7F800000;f_item.fpu_op==0;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opb==32'hFF800000;f_item.fpu_op==0;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 10-
        `uvm_do(f_item,,,{f_item.opb==32'h7F800000;f_item.fpu_op==1;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opb==32'hFF800000;f_item.fpu_op==1;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})      
    // Asercion 11
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.opb==32'h3F800000;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.opb==32'h3F800000;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 12
        `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h7F800000;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'hFF800000;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 13
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.opb==32'h3F800000;f_item.fpu_op==3;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.opb==32'h3F800000;f_item.fpu_op==3;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})    
    // Asercion 14
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.opb==0;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.opb==0;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 15
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.opb==32'h7F800000;f_item.fpu_op==0;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 16
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.opb==32'h7F800000;f_item.fpu_op==3;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.opb==32'h7F800000;f_item.fpu_op==3;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 17
      `uvm_do(f_item,,,{f_item.opa==0;f_item.opb==0;f_item.fpu_op==3;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 18
      `uvm_do(f_item,,,{f_item.opa==32'h7F7FFFFF;f_item.opb==32'h40000000;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 18
      `uvm_do(f_item,,,{f_item.opa==32'h40000000;f_item.opb==32'h7F7FFFFF;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F800000;f_item.fpu_op==0;})
    // Asercion 20
      `uvm_do(f_item,,,{f_item.opa==32'h00000001;f_item.opb==32'h461C0000;f_item.fpu_op==3;})
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask

endclass


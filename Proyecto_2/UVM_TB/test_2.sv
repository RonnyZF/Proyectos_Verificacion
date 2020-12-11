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
  
  int num = 10; 	// Config total number of items to be sent

  //constraint c1 { num inside {[20:50]}; }
  
  virtual task body();
    /*
     fpu_item f_item = fpu_item::type_id::create("f_item");
    // Asercion 1
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opb==0;f_item.fpu_op==3;})
    end
    // Asercion 2
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==32'h3FA00000;f_item.opb==32'hBFA00000;f_item.fpu_op==0;})
    end
    */
    // Asercion 3
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==32'h3FA00000;f_item.opb==32'h3FA00000;f_item.fpu_op==1;})
    end
    /*
    // Asercion 4a
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==0;f_item.fpu_op==2;})
    end
    // Asercion 4b
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opb==0;f_item.fpu_op==2;})
    end
    // Asercion 5
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==0;f_item.fpu_op==3;})
    end
    // Asercion 9+
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.fpu_op==0;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.fpu_op==0;})
      end
    end
    // Asercion 9-
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.fpu_op==1;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.fpu_op==1;})
      end
    end
    // Asercion 10+
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opb==32'h7F800000;f_item.fpu_op==0;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opb==32'hFF800000;f_item.fpu_op==0;})
      end
    end
    // Asercion 10-
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opb==32'h7F800000;f_item.fpu_op==1;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opb==32'hFF800000;f_item.fpu_op==1;})
      end
    end
    // Asercion 11
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.fpu_op==2;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.fpu_op==2;})
      end
    end 
    // Asercion 12
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opb==32'h7F800000;f_item.fpu_op==3;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opb==32'hFF800000;f_item.fpu_op==3;})
      end
    end
    // Asercion 13
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.fpu_op==3;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.fpu_op==3;})
      end
    end
    // Asercion 14
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.opb==0;f_item.fpu_op==2;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.opb==0;f_item.fpu_op==2;})
      end
    end
    // Asercion 15
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.opb==32'h7F800000;f_item.fpu_op==0;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.opb==32'hFF800000;f_item.fpu_op==0;})
      end
    end
    // Asercion 16
    for (int i = 0; i < num; i ++) begin
      if(i%2) begin
        `uvm_do(f_item,,,{f_item.opa==32'h7F800000;f_item.opb==32'h7F800000;f_item.fpu_op==3;})
      end
      else begin
        `uvm_do(f_item,,,{f_item.opa==32'hFF800000;f_item.opb==32'h7F800000;f_item.fpu_op==3;})
      end
    end
    // Asercion 17
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==0;f_item.opb==0;f_item.fpu_op==3;})
    end
    // Asercion 20
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==32'h00000001;f_item.opb==32'h00000001;f_item.fpu_op==0;})
    end
    */
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask

endclass


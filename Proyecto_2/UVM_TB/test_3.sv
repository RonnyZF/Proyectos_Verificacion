class test_basic3 extends test_basic2;

  `uvm_component_utils(test_basic3)
  
  function new (string name="test_basic3", uvm_component parent=null);
    super.new (name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
  	 
     // Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
    
    //factory to override 'base_agent' by 'child_agent' by name
    factory.set_type_override_by_name("gen_item_seq2", "gen_item_seq3");

    // Print factory configuration
    factory.print();
  endfunction

endclass

class gen_item_seq3 extends gen_item_seq2;
  `uvm_object_utils(gen_item_seq3)
  function new(string name="gen_item_seq3");
    super.new(name);
  endfunction
  
  //rand int num; 	// Config total number of items to be sent
  int num = 500;

  //constraint c1 { num inside {[20:50]}; }
  
  virtual task body();
     fpu_item f_item = fpu_item::type_id::create("f_item");
    // Div by Zero
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opb==0;f_item.fpu_op==3;})
    end

    // NaN
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==32'h7F800001;f_item.fpu_op==0;})
    end

    // Normal ops
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item);
    end

    // Zero Flag and div by zero
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==0;f_item.opb==0;})
    end

    //Max number
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==32'h7F7FFFFF;f_item.opb==32'h7F7FFFFF;f_item.fpu_op==0;})
      `uvm_do(f_item,,,{f_item.opa==32'h7F7FFFFF;f_item.opb==32'h7F7FFFFF;f_item.fpu_op==1;})
      `uvm_do(f_item,,,{f_item.opa==32'h7F7FFFFF;f_item.opb==32'h7F7FFFFF;f_item.fpu_op==2;})
      `uvm_do(f_item,,,{f_item.opa==32'h7F7FFFFF;f_item.opb==32'h7F7FFFFF;f_item.fpu_op==3;})
    end

    //Test rmode
    for (int i = 0; i < num; i ++) begin
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F4CCCCD;f_item.fpu_op==0;f_item.rmode==0;})		//1 + 0.8 = 1.8
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F4CCCCD;f_item.fpu_op==0;f_item.rmode==1;})		//1 + 0.8 = 1.8
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F4CCCCD;f_item.fpu_op==0;f_item.rmode==2;})		//1 + 0.8 = 1.8
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F4CCCCD;f_item.fpu_op==0;f_item.rmode==3;})		//1 + 0.8 = 1.8

      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F000000;f_item.fpu_op==0;f_item.rmode==0;})		//1 + 0.5 = 1.5
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F000000;f_item.fpu_op==0;f_item.rmode==1;})		//1 + 0.5 = 1.5
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F000000;f_item.fpu_op==0;f_item.rmode==2;})		//1 + 0.5 = 1.5
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F000000;f_item.fpu_op==0;f_item.rmode==3;})		//1 + 0.5 = 1.5

      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3E4CCCCD;f_item.fpu_op==0;f_item.rmode==0;})		//1 + 0.2 = 1.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3E4CCCCD;f_item.fpu_op==0;f_item.rmode==1;})		//1 + 0.2 = 1.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3E4CCCCD;f_item.fpu_op==0;f_item.rmode==2;})		//1 + 0.2 = 1.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3E4CCCCD;f_item.fpu_op==0;f_item.rmode==3;})		//1 + 0.2 = 1.2

      `uvm_do(f_item,,,{f_item.opa==32'h3FE66666;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==0;})		//1.8 - 1 = 0.8
      `uvm_do(f_item,,,{f_item.opa==32'h3FE66666;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==1;})		//1.8 - 1 = 0.8
      `uvm_do(f_item,,,{f_item.opa==32'h3FE66666;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==2;})		//1.8 - 1 = 0.8
      `uvm_do(f_item,,,{f_item.opa==32'h3FE66666;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==3;})		//1.8 - 1 = 0.8

      `uvm_do(f_item,,,{f_item.opa==32'h3FC00000;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==0;})		//1.5 - 1 = 0.5
      `uvm_do(f_item,,,{f_item.opa==32'h3FC00000;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==1;})		//1.5 - 1 = 0.5
      `uvm_do(f_item,,,{f_item.opa==32'h3FC00000;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==2;})		//1.5 - 1 = 0.5
      `uvm_do(f_item,,,{f_item.opa==32'h3FC00000;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==3;})		//1.5 - 1 = 0.5

      `uvm_do(f_item,,,{f_item.opa==32'h3F99999A;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==0;})		//1.2 - 1 = 0.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F99999A;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==1;})		//1.2 - 1 = 0.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F99999A;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==2;})		//1.2 - 1 = 0.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F99999A;f_item.opb==32'h3F800000;f_item.fpu_op==1;f_item.rmode==3;})		//1.2 - 1 = 0.2

      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F99999A;f_item.fpu_op==1;f_item.rmode==0;})		//1 - 1.2 = -0.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F99999A;f_item.fpu_op==1;f_item.rmode==1;})		//1 - 1.2 = -0.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F99999A;f_item.fpu_op==1;f_item.rmode==2;})		//1 - 1.2 = -0.2
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3F99999A;f_item.fpu_op==1;f_item.rmode==3;})		//1 - 1.2 = -0.2

      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3FC00000;f_item.fpu_op==1;f_item.rmode==0;})		//1 - 1.5 = -0.5
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3FC00000;f_item.fpu_op==1;f_item.rmode==1;})		//1 - 1.5 = -0.5
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3FC00000;f_item.fpu_op==1;f_item.rmode==2;})		//1 - 1.5 = -0.5
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3FC00000;f_item.fpu_op==1;f_item.rmode==3;})		//1 - 1.5 = -0.5

      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3FE66666;f_item.fpu_op==1;f_item.rmode==0;})		//1 - 1.8 = -0.8
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3FE66666;f_item.fpu_op==1;f_item.rmode==1;})		//1 - 1.8 = -0.8
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3FE66666;f_item.fpu_op==1;f_item.rmode==2;})		//1 - 1.8 = -0.8
      `uvm_do(f_item,,,{f_item.opa==32'h3F800000;f_item.opb==32'h3FE66666;f_item.fpu_op==1;f_item.rmode==3;})		//1 - 1.8 = -0.8

      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3E4CCCCD;f_item.fpu_op==1;f_item.rmode==0;})		//-1 - 0.2 = -1.2
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3E4CCCCD;f_item.fpu_op==1;f_item.rmode==1;})		//-1 - 0.2 = -1.2
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3E4CCCCD;f_item.fpu_op==1;f_item.rmode==2;})		//-1 - 0.2 = -1.2
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3E4CCCCD;f_item.fpu_op==1;f_item.rmode==3;})		//-1 - 0.2 = -1.2

      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3F000000;f_item.fpu_op==1;f_item.rmode==0;})		//-1 - 0.5 = -1.5
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3F000000;f_item.fpu_op==1;f_item.rmode==1;})		//-1 - 0.5 = -1.5
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3F000000;f_item.fpu_op==1;f_item.rmode==2;})		//-1 - 0.5 = -1.5
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3F000000;f_item.fpu_op==1;f_item.rmode==3;})		//-1 - 0.5 = -1.5

      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3F4CCCCD;f_item.fpu_op==1;f_item.rmode==0;})		//-1 - 0.8 = -1.8
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3F4CCCCD;f_item.fpu_op==1;f_item.rmode==1;})		//-1 - 0.8 = -1.8
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3F4CCCCD;f_item.fpu_op==1;f_item.rmode==2;})		//-1 - 0.8 = -1.8
      `uvm_do(f_item,,,{f_item.opa==32'hBF800000;f_item.opb==32'h3F4CCCCD;f_item.fpu_op==1;f_item.rmode==3;})		//-1 - 0.8 = -1.8

    end



    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask

endclass


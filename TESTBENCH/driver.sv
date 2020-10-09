class driver;
  stimulus sti;
  scoreboard sb;
 
  virtual intf_cnt intf;
        
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
                
  task add(input integer iteration);
    $display("TASK ADD\n");
    repeat(iteration)
    begin
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        $display("Adding opa = 0x%h and opb = 0x%h in the DUT\n", sti.opa, sti.opb);
        intf.opa = sti.opa; // Drive to DUT
      	intf.opb = sti.opb; // Drive to DUT
        intf.fpu_op = 0;
      	intf.rmode = 0;
     	
      sb.store.push_front(sti.opa);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);

  endtask
  
  task sub(input integer iteration);
    $display("TASK SUB\n");
    repeat(iteration)
    begin
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        $display("Substract opa = 0x%h and opb = 0x%h in the DUT\n", sti.opa, sti.opb);
        intf.opa = sti.opa; // Drive to DUT
      	intf.opb = sti.opb; // Drive to DUT
        intf.fpu_op = 1;
      	intf.rmode = 0;
     	
      sb.store.push_front(sti.opa);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);

  endtask
  
  task mul(input integer iteration);
    $display("TASK MUL\n");
    repeat(iteration)
    begin
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        $display("Multiplying opa = 0x%h and opb = 0x%h in the DUT\n", sti.opa, sti.opb);
        intf.opa = sti.opa; // Drive to DUT
      	intf.opb = sti.opb; // Drive to DUT
        intf.fpu_op = 2;
      	intf.rmode = 0;
     	
      sb.store.push_front(sti.opa);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);

  endtask
  
  task div(input integer iteration);
    $display("TASK DIV\n");
    repeat(iteration)
    begin
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        $display("Dividing opa = 0x%h and opb = 0x%h in the DUT\n", sti.opa, sti.opb);
        intf.opa = sti.opa; // Drive to DUT
      	intf.opb = sti.opb; // Drive to DUT
        intf.fpu_op = 3;
      	intf.rmode = 0;
     	
      sb.store.push_front(sti.opa);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);

  endtask
 
endclass

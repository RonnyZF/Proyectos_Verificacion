class driver;
  stimulus sti;
  scoreboard sb;
 
  virtual intf_cnt intf;
        
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
        
  task reset();  // Reset method
    $display("Executing Reset\n");
    intf.rmode = 0;
    intf.fpu_op = 0;
    intf.opa = 0;
    intf.opb = 0;
//    @ (negedge intf.clk);
//    intf.rst = 0;


  endtask
        
  task suma(input integer iteration);
    $display("TASK SUMA\n");
    repeat(iteration)
    begin
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        $display("Driving opa = 0x%h and opb = 0x%h in the DUT\n", sti.opa, sti.opb);
        intf.opa = sti.opa; // Drive to DUT
      	intf.opb = sti.opb; // Drive to DUT
        intf.fpu_op = 0;
      	intf.rmode = 0;
      	
      sb.store.push_front(sti.opa);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);

  endtask
 /* 
  task read(input integer iteration);
    repeat(iteration)
    begin
      @ (negedge intf.clk);
      intf.rd_en = 1;
       //intf.rd_cs = 1;
    end
      @ (negedge intf.clk);
      intf.rd_en = 0;
    //intf.rd_cs = 0;
  endtask
  
*/
endclass

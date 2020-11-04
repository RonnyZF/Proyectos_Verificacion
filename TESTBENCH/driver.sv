
class driver;
  stimulus sti;
  scoreboard sb;
 
  virtual intf_cnt intf;
        
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
                
  task operation(input integer iteration);
    repeat(iteration)
    begin
      $display("TASK OPERATION\n");
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        //$display("decimal opa = %d and opb = %d in the DUT\n", sti.opa, sti.opb);
        intf.opa = $shortrealtobits(sti.opa); // Drive to DUT
        intf.opb = $shortrealtobits(sti.opb); // Drive to DUT
        //$display("IEEE754 opa = %h and opb = %h in the DUT\n", intf.opa, intf.opb);
        intf.fpu_op = sti.fpu_op;
      	intf.rmode = sti.rmode;
        //$display("FPU_OP = %d and RMODE = %d \n", sti.fpu_op, sti.rmode);
      sb.opa.push_front(sti.opa);// Cal exp value and store in Scoreboard
      sb.opb.push_front(sti.opb);// Cal exp value and store in Scoreboard
      sb.fpu_op.push_front(sti.fpu_op);// Cal exp value and store in Scoreboard
      sb.rmode.push_front(sti.rmode);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);
  endtask
  
  task overflow(input integer iteration);
    repeat(iteration)
    begin
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        //$display("decimal opa = %d and opb = %d in the DUT\n", sti.opa, sti.opb);
        intf.opa = 32'h7F7FFFFF; // Drive to DUT
        intf.opb = $shortrealtobits(sti.opb); // Drive to DUT
        //$display("IEEE754 opa = %h and opb = %h in the DUT\n", intf.opa, intf.opb);
        intf.fpu_op = 3'b010;
        intf.rmode = sti.rmode;
        //$display("FPU_OP = %d and RMODE = %d \n", sti.fpu_op, sti.rmode);
      sb.opa.push_front(intf.opa);// Cal exp value and store in Scoreboard
      sb.opb.push_front(intf.opb);// Cal exp value and store in Scoreboard
      sb.fpu_op.push_front(sti.fpu_op);// Cal exp value and store in Scoreboard
      sb.rmode.push_front(sti.rmode);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);
  endtask

  task div_zero(input integer iteration);
    repeat(iteration)
    begin
      sti = new();
      @ (negedge intf.clk);
      if(sti.randomize()) // Generate stimulus
        intf.opa = $shortrealtobits(sti.opa); // Drive to DUT
        intf.opb = 32'h00000000;
        intf.fpu_op = 3'b011;
        intf.rmode = sti.rmode;
      sb.opa.push_front(intf.opa);// Cal exp value and store in Scoreboard
      sb.opb.push_front(intf.opb);// Cal exp value and store in Scoreboard
      sb.fpu_op.push_front(sti.fpu_op);// Cal exp value and store in Scoreboard
      sb.rmode.push_front(sti.rmode);// Cal exp value and store in Scoreboard
    end
     @ (negedge intf.clk);
  endtask

endclass

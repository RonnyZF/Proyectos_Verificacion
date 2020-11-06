
class driver;
  stimulus sti;
  scoreboard sb;
  logic[31:0] opa, opb;
 
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
        opa = {sti.sign1, sti.exp1, sti.mantissa1};
        opb = {sti.sign2, sti.exp2, sti.mantissa2};
        intf.opa = opa; // Drive to DUT
        intf.opb = opb; // Drive to DUT
        //$display("IEEE754 opa = %h and opb = %h in the DUT\n", intf.opa, intf.opb);
        intf.fpu_op = sti.fpu_op;
      	intf.rmode = sti.rmode;
        $display("FPU_OP = %d and RMODE = %d \n", sti.fpu_op, sti.rmode);
      sb.opa.push_front(opa);// Cal exp value and store in Scoreboard
      sb.opb.push_front(opb);// Cal exp value and store in Scoreboard
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
        opb = {sti.sign2, sti.exp2, sti.mantissa2};
        intf.opa = 32'h7F7FFFFF; // Drive to DUT
        intf.opb = opb; // Drive to DUT
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
        opa = {sti.sign1, sti.exp1, sti.mantissa1};
        intf.opa = opa; // Drive to DUT
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
